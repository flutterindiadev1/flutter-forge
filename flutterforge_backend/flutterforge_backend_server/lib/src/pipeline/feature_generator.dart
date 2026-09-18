import 'dart:io';
import 'dart:async';
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
    final pattern = config.architecture?.pattern ?? 'clean_architecture';
    final stateManagement = config.architecture?.stateManagement ?? 'bloc';

    yield FeatureGeneratorEvent(
      message: 'Scaffolding features ($pattern + $stateManagement)...',
      level: 'info',
      progress: 0.0,
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
      // ignore: unused_local_variable
      String contextMemory = '';
      // ignore: unused_local_variable
      int elicitationCount = 0;

      while (requiresElicitation) {

        Map<String, dynamic>? parsed;
        
        try {
          int retries = 0;
          
          while (retries < 5) {
            try {
              // Bypass LLM: scaffold structure based on architecture + state management
              final featureSlug = feature.name.toLowerCase().replaceAll(' ', '_').replaceAll('&', 'and').replaceAll(RegExp(r'[^a-z0-9_]'), '');
              final scaffoldedFiles = _scaffoldFiles(featureSlug, pattern, stateManagement);
              if (config.testing.generateUnitTests || config.testing.generateWidgetTests || config.testing.generateIntegrationTests) {
                scaffoldedFiles.addAll(_scaffoldTests(featureSlug, config.testing));
              }
              parsed = {
                'files': scaffoldedFiles.map((entry) => {
                  'path': entry.key,
                  'content': entry.value,
                }).toList(),
              };
              await Future.delayed(const Duration(milliseconds: 200));
              break; // Break on successful scaffold
            } catch (e) {
              final errorStr = e.toString();
              if (errorStr.contains('Quota exceeded') || errorStr.contains('429')) {
                if (retries == 4) rethrow;
                final waitSeconds = 60 * (retries + 1);
                yield FeatureGeneratorEvent(
                  message: 'Rate limit hit for ${feature.name}. Waiting ${waitSeconds}s before retrying...',
                  level: 'warning',
                  progress: featureProgressStart + 0.1,
                );
                await Future.delayed(Duration(seconds: waitSeconds));
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

      // Add a small delay between features to prevent hitting rate limits
      // (e.g. Gemini free tier is 15 RPM, which is 1 request every 4 seconds)
      if (i < totalFeatures - 1) {
        await Future.delayed(const Duration(seconds: 4));
      }
    }

    yield FeatureGeneratorEvent(
      message: 'All features generated successfully.',
      level: 'success',
      progress: 1.0,
    );
  }

  // ignore: unused_element
  String _buildPrompt(ProjectConfig config, FeatureNode feature, String contextMemory) {
    final pattern = config.architecture?.pattern ?? 'clean_architecture';
    final stateManagement = config.architecture?.stateManagement ?? 'bloc';
    final persona = config.persona;
    final inspiredBy = config.inspiredBy;
    final globals = config.llmInstructions.where((i) => i.featureId == null).map((i) => i.instruction).join('\n- ');
    final integrations = config.integrations;

    String integrationsText = 'Active Integrations: ';
    final activeIntegrations = <String>[];
    if (integrations.firebaseAuth) activeIntegrations.add('Firebase Auth');
    if (integrations.firebaseFirestore) activeIntegrations.add('Firestore');
    if (integrations.stripe) activeIntegrations.add('Stripe');
    if (activeIntegrations.isNotEmpty) {
      integrationsText += activeIntegrations.join(', ');
    } else {
      integrationsText = '';
    }

    return '''
You are an expert Flutter Developer and Architect.
I am building a Flutter app with the following configuration:
Project Name: ${config.projectName}
Description: ${config.description}
Architecture Pattern: $pattern
State Management: $stateManagement
Target Platforms: ${config.platforms.join(', ')}

${integrationsText.isNotEmpty ? '$integrationsText\n' : ''}
${persona != null ? 'Target Persona:\nRole: ${persona.role}\nGoal: ${persona.goal}\nPain Points: ${persona.painPoints}\n' : ''}
${inspiredBy.isNotEmpty ? 'Inspired By: $inspiredBy\n' : ''}
${globals.isNotEmpty ? 'Global Instructions:\n- $globals\n' : ''}

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

  /// Returns a list of (path, content) pairs for the given feature slug,
  /// based on the selected architecture pattern and state management.
  List<MapEntry<String, String>> _scaffoldFiles(
    String slug,
    String pattern,
    String stateManagement,
  ) {
    final base = 'lib/features/$slug';
    final files = <MapEntry<String, String>>[];

    // ── Helpers ──────────────────────────────────────────────────────────────
    String todo(String label) => '// TODO: implement $label\n';

    // ── Shared presentation files (vary only by state management) ────────────
    void addPresentationLayer() {
      switch (stateManagement) {
        case 'bloc':
          files.addAll([
            MapEntry('$base/presentation/bloc/${slug}_bloc.dart',
                "import 'package:flutter_bloc/flutter_bloc.dart';\nimport '${slug}_event.dart';\nimport '${slug}_state.dart';\n\n${todo('$slug BLoC')}"),
            MapEntry('$base/presentation/bloc/${slug}_event.dart',
                "import 'package:equatable/equatable.dart';\n\n${todo('$slug events')}"),
            MapEntry('$base/presentation/bloc/${slug}_state.dart',
                "import 'package:equatable/equatable.dart';\n\n${todo('$slug states')}"),
          ]);
          break;

        case 'riverpod':
          files.addAll([
            MapEntry('$base/presentation/providers/${slug}_provider.dart',
                "import 'package:flutter_riverpod/flutter_riverpod.dart';\n\n${todo('$slug provider')}"),
            MapEntry('$base/presentation/providers/${slug}_state.dart',
                "${todo('$slug state class')}"),
          ]);
          break;

        case 'provider':
          files.addAll([
            MapEntry('$base/presentation/providers/${slug}_notifier.dart',
                "import 'package:flutter/foundation.dart';\n\n${todo('$slug ChangeNotifier')}"),
          ]);
          break;

        default: // cubit or anything else
          files.addAll([
            MapEntry('$base/presentation/cubit/${slug}_cubit.dart',
                "import 'package:flutter_bloc/flutter_bloc.dart';\nimport '${slug}_state.dart';\n\n${todo('$slug Cubit')}"),
            MapEntry('$base/presentation/cubit/${slug}_state.dart',
                "import 'package:equatable/equatable.dart';\n\n${todo('$slug states')}"),
          ]);
      }

      files.addAll([
        MapEntry('$base/presentation/screens/${slug}_screen.dart',
            "import 'package:flutter/material.dart';\n\n${todo('$slug screen')}"),
        MapEntry('$base/presentation/widgets/${slug}_widget.dart',
            "import 'package:flutter/material.dart';\n\n${todo('$slug widget')}"),
      ]);
    }

    // ── Architecture-specific layers ─────────────────────────────────────────
    if (pattern == 'clean_architecture') {
      // Domain layer
      files.addAll([
        MapEntry('$base/domain/entities/${slug}_entity.dart',  todo('$slug entity')),
        MapEntry('$base/domain/repositories/${slug}_repository.dart', todo('$slug repository interface')),
        MapEntry('$base/domain/usecases/get_${slug}.dart', todo('get_$slug use case')),
        MapEntry('$base/domain/usecases/save_${slug}.dart', todo('save_$slug use case')),
      ]);

      // Data layer
      files.addAll([
        MapEntry('$base/data/models/${slug}_model.dart', todo('$slug model (fromJson/toJson)')),
        MapEntry('$base/data/datasources/${slug}_remote_datasource.dart', todo('$slug remote data source')),
        MapEntry('$base/data/datasources/${slug}_local_datasource.dart', todo('$slug local data source')),
        MapEntry('$base/data/repositories/${slug}_repository_impl.dart', todo('$slug repository impl')),
      ]);

      // Presentation layer (state management aware)
      addPresentationLayer();

    } else if (pattern == 'mvvm') {
      // Model
      files.addAll([
        MapEntry('$base/models/${slug}_model.dart', todo('$slug model')),
        MapEntry('$base/repositories/${slug}_repository.dart', todo('$slug repository')),
        MapEntry('$base/services/${slug}_service.dart', todo('$slug service')),
      ]);

      // ViewModel / state (state management aware)
      switch (stateManagement) {
        case 'bloc':
          files.addAll([
            MapEntry('$base/viewmodel/${slug}_bloc.dart', todo('$slug BLoC ViewModel')),
            MapEntry('$base/viewmodel/${slug}_event.dart', todo('$slug events')),
            MapEntry('$base/viewmodel/${slug}_state.dart', todo('$slug states')),
          ]);
          break;
        case 'riverpod':
          files.addAll([
            MapEntry('$base/viewmodel/${slug}_viewmodel.dart',
                "import 'package:flutter_riverpod/flutter_riverpod.dart';\n\n${todo('$slug ViewModel (Riverpod)')}"),
          ]);
          break;
        case 'provider':
          files.addAll([
            MapEntry('$base/viewmodel/${slug}_viewmodel.dart',
                "import 'package:flutter/foundation.dart';\n\nclass ${_toPascal(slug)}ViewModel extends ChangeNotifier {\n  ${todo('$slug ViewModel (Provider)')}}"),
          ]);
          break;
        default:
          files.addAll([
            MapEntry('$base/viewmodel/${slug}_cubit.dart', todo('$slug Cubit ViewModel')),
            MapEntry('$base/viewmodel/${slug}_state.dart', todo('$slug states')),
          ]);
      }

      // View
      files.addAll([
        MapEntry('$base/view/${slug}_screen.dart',
            "import 'package:flutter/material.dart';\n\n${todo('$slug screen')}"),
        MapEntry('$base/view/widgets/${slug}_widget.dart',
            "import 'package:flutter/material.dart';\n\n${todo('$slug widget')}"),
      ]);

    } else if (pattern == 'hexagonal') {
      // Hexagonal / Ports & Adapters
      files.addAll([
        MapEntry('$base/core/${slug}_entity.dart', todo('$slug entity')),
        MapEntry('$base/ports/in/${slug}_usecase.dart', todo('$slug input port (usecase)')),
        MapEntry('$base/ports/out/${slug}_port.dart', todo('$slug output port')),
        MapEntry('$base/adapters/in/ui/${slug}_screen.dart', "import 'package:flutter/material.dart';\n\n${todo('$slug UI adapter')}"),
        MapEntry('$base/adapters/out/api/${slug}_api_adapter.dart', todo('$slug API adapter')),
        MapEntry('$base/adapters/out/db/${slug}_db_adapter.dart', todo('$slug DB adapter')),
      ]);
    } else {
      // Fallback: simple feature-first flat structure
      addPresentationLayer();
      files.addAll([
        MapEntry('$base/${slug}_model.dart', todo('$slug model')),
        MapEntry('$base/${slug}_repository.dart', todo('$slug repository')),
      ]);
    }

    return files;
  }

  /// Scaffolds test files based on the requested testing flags.
  List<MapEntry<String, String>> _scaffoldTests(String slug, TestingConfig testing) {
    final files = <MapEntry<String, String>>[];
    String todo(String label) => '// TODO: write $label\n';
    
    if (testing.generateUnitTests) {
      files.add(MapEntry('test/features/$slug/${slug}_test.dart', "import 'package:flutter_test/flutter_test.dart';\n\nvoid main() {\n  ${todo('unit tests for $slug')}}\n"));
    }
    
    if (testing.generateWidgetTests) {
      files.add(MapEntry('test/features/$slug/presentation/${slug}_widget_test.dart', "import 'package:flutter_test/flutter_test.dart';\n\nvoid main() {\n  testWidgets('renders $slug widget', (tester) async {\n    ${todo('widget tests for $slug')}  });\n}\n"));
    }
    
    if (testing.generateIntegrationTests) {
      files.add(MapEntry('integration_test/${slug}_integration_test.dart', "import 'package:flutter_test/flutter_test.dart';\nimport 'package:integration_test/integration_test.dart';\n\nvoid main() {\n  IntegrationTestWidgetsFlutterBinding.ensureInitialized();\n\n  testWidgets('tests $slug flow', (tester) async {\n    ${todo('integration tests for $slug')}  });\n}\n"));
    }
    
    return files;
  }

  /// Converts snake_case to PascalCase.
  String _toPascal(String slug) =>
      slug.split('_').map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join();
}

