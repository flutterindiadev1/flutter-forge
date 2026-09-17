import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../generated/protocol.dart';

class FeatureGeneratorEvent {
  final String message;
  final String level;
  final double progress;
  final bool isError;
  final bool isAwaitingElicitation;
  final String? elicitationQuestion;
  final String? elicitationContext;

  FeatureGeneratorEvent({
    required this.message,
    this.level = 'info',
    this.progress = 0.0,
    this.isError = false,
    this.isAwaitingElicitation = false,
    this.elicitationQuestion,
    this.elicitationContext,
  });
}

class FeatureGenerator {
  Stream<FeatureGeneratorEvent> generate(ProjectConfig config, StreamIterator<PipelineCommand> commandIterator) async* {
    if (config.geminiApiKey.isEmpty) {
      yield FeatureGeneratorEvent(
        message: 'No Gemini API key provided. Skipping feature code generation.',
        level: 'warning',
        progress: 1.0,
      );
      return;
    }

    yield FeatureGeneratorEvent(
      message: 'Initializing AI Feature Generator...',
      level: 'info',
      progress: 0.0,
    );

    final model = GenerativeModel(
      model: 'gemini-3.6-flash',
      apiKey: config.geminiApiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
      ),
    );

    final totalFeatures = config.features.length;
    if (totalFeatures == 0) {
      yield FeatureGeneratorEvent(
        message: 'No features found to generate.',
        level: 'info',
        progress: 1.0,
      );
      return;
    }

    for (int i = 0; i < totalFeatures; i++) {
      final feature = config.features[i];
      final featureProgressStart = i / totalFeatures;
      final featureProgressEnd = (i + 1) / totalFeatures;

      yield FeatureGeneratorEvent(
        message: 'Analyzing feature: ${feature.name}',
        level: 'info',
        progress: featureProgressStart,
      );

      bool requiresElicitation = true;
      String contextMemory = '';
      int elicitationCount = 0;

      while (requiresElicitation) {
        final prompt = _buildPrompt(config, feature, contextMemory);
        
        yield FeatureGeneratorEvent(
          message: 'Prompting LLM for ${feature.name}...',
          level: 'info',
          progress: featureProgressStart + 0.1,
        );

        Map<String, dynamic>? parsed;
        
        try {
          int retries = 0;
          
          while (retries < 5) {
            try {
              final response = await model.generateContent([Content.text(prompt)]);
              final rawText = response.text ?? '{}';
              final startIndex = rawText.indexOf('{');
              final endIndex = rawText.lastIndexOf('}');
              
              String responseText = rawText;
              if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
                responseText = rawText.substring(startIndex, endIndex + 1);
              }
              
              parsed = jsonDecode(responseText);
              break; // Break on successful generation and parse
            } catch (e) {
              final errorStr = e.toString();
              if (errorStr.contains('Quota exceeded') || errorStr.contains('429')) {
                if (retries == 4) rethrow;
                yield FeatureGeneratorEvent(
                  message: 'Rate limit hit for ${feature.name}. Waiting 60s before retrying...',
                  level: 'warning',
                  progress: featureProgressStart + 0.1,
                );
                await Future.delayed(const Duration(seconds: 60));
                retries++;
              } else if (e is FormatException) {
                if (retries == 4) {
                  yield FeatureGeneratorEvent(
                    message: 'Failed to parse JSON from AI for ${feature.name}: $e. Skipping feature...',
                    level: 'warning',
                    progress: featureProgressStart,
                  );
                  continue;
                }
                yield FeatureGeneratorEvent(
                  message: 'AI returned malformed JSON for ${feature.name}. Retrying...',
                  level: 'warning',
                  progress: featureProgressStart + 0.1,
                );
                retries++;
              } else {
                rethrow;
              }
            }
          }
        } catch (e) {
          yield FeatureGeneratorEvent(
            message: 'AI Generation failed for ${feature.name}: $e. Skipping feature...',
            level: 'warning',
            progress: featureProgressStart,
          );
          continue;
        }

        if (parsed == null) continue;

        if (parsed.containsKey('question') && parsed['question'] != null && elicitationCount < 2) {
          final question = parsed['question'] as String;
          yield FeatureGeneratorEvent(
            message: 'AI needs more information for ${feature.name}...',
            level: 'warning',
            progress: featureProgressStart + 0.2,
            isAwaitingElicitation: true,
            elicitationQuestion: question,
            elicitationContext: 'Feature: ${feature.name}',
          );

          // Wait for user to answer
          if (await commandIterator.moveNext()) {
            final answer = commandIterator.current.command;
            yield FeatureGeneratorEvent(
              message: 'Received user input for ${feature.name}. Resuming...',
              level: 'info',
              progress: featureProgressStart + 0.3,
            );
            contextMemory += '\\n\\nQ: $question\\nA: $answer';
            elicitationCount++;
          } else {
            yield FeatureGeneratorEvent(
              message: 'Pipeline stream closed while waiting for elicitation.',
              level: 'error',
              progress: featureProgressStart,
              isError: true,
            );
            return;
          }
        } else if (parsed.containsKey('files')) {
          requiresElicitation = false; // We got files, break loop
          
          yield FeatureGeneratorEvent(
            message: 'Writing generated code for ${feature.name}...',
            level: 'info',
            progress: featureProgressStart + 0.6,
          );

          final files = parsed['files'] as List<dynamic>;
          for (final f in files) {
            final path = f['path'] as String;
            final content = f['content'] as String;
            
            final targetPath = '/tmp/flutterforge/${config.projectId}/$path';
            final targetFile = File(targetPath);
            await targetFile.parent.create(recursive: true);
            await targetFile.writeAsString(content);
          }

          yield FeatureGeneratorEvent(
            message: 'Finished generating ${feature.name}.',
            level: 'success',
            progress: featureProgressEnd,
          );
        } else {
          yield FeatureGeneratorEvent(
            message: 'Unexpected AI response format for ${feature.name}. Skipping...',
            level: 'warning',
            progress: featureProgressEnd,
          );
          requiresElicitation = false;
        }
      }
    }

    yield FeatureGeneratorEvent(
      message: 'All features generated successfully.',
      level: 'success',
      progress: 1.0,
    );
  }

  String _buildPrompt(ProjectConfig config, FeatureNode feature, String contextMemory) {
    final pattern = config.architecture?.pattern ?? 'clean_architecture';
    final stateManagement = config.architecture?.stateManagement ?? 'bloc';

    return '''
You are an expert Flutter Developer and Architect.
I am building a Flutter app with the following configuration:
Project Name: ${config.projectName}
Description: ${config.description}
Architecture Pattern: $pattern
State Management: $stateManagement

Your task is to implement the following feature:
Feature Name: ${feature.name}
Feature Layer: ${feature.layer.name}

$contextMemory

If you do NOT have enough information to design and implement this feature perfectly, you may ask ONE clarifying question.
If you DO have enough information, you must generate the complete Dart code files for this feature.

RESPOND ONLY IN VALID JSON FORMAT.

If you need to ask a question, return:
{
  "question": "Your clarifying question here..."
}

If you are ready to generate the code, return:
{
  "files": [
    {
      "path": "lib/features/${feature.name.toLowerCase().replaceAll(' ', '_')}/presentation/screens/example.dart",
      "content": "import 'package:flutter/material.dart';\\n\\n// ..."
    }
  ]
}

Ensure that "path" is a relative path starting from the root of the flutter project (e.g., "lib/...").
Provide production-ready, complete code.
''';
  }
}
