import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../generated/protocol.dart';

class AiEndpoint extends Endpoint {
  Future<AiAnalysisResult> analyzeRequirements(
    Session session,
    String apiKey,
    String description,
    Map<String, String>? answers,
  ) async {
    if (apiKey.trim().isEmpty) {
      throw Exception('API Key is required');
    }

    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );

    // Build the prompt
    final buffer = StringBuffer();
    buffer.writeln('You are an expert Flutter application architect.');
    buffer.writeln('The user wants to build an app with the following description:');
    buffer.writeln('"""$description"""');
    
    if (answers != null && answers.isNotEmpty) {
      buffer.writeln('\nThe user has provided answers to clarifying questions:');
      answers.forEach((q, a) {
        buffer.writeln('Q: $q');
        buffer.writeln('A: $a');
      });
    }

    buffer.writeln('''
Based on this information, decide if you have enough clarity to generate a list of core features for this app.
If you need more clarity, ask 1 to 3 concise follow-up questions.
If you have enough clarity, generate the core features.

You MUST respond strictly in the following JSON format without Markdown formatting or extra text:
{
  "questions": [
    "Question 1?",
    "Question 2?"
  ],
  "features": [
    {
      "name": "FeatureName",
      "layer": "ui|domain|data|shared",
      "dependencies": ["OtherFeatureName"]
    }
  ]
}

- If you are asking questions, the "features" array should be empty.
- If you are providing features, the "questions" array should be empty.
- The layer must be one of: "ui", "domain", "data", "shared".
- dependencies must be names of other features you listed.
''');

    final response = await model.generateContent([Content.text(buffer.toString())]);
    final text = response.text;

    if (text == null) {
      throw Exception('Empty response from AI');
    }

    // Clean up potential markdown formatting from AI output
    final jsonStr = text.replaceAll(RegExp(r'^```json\n?|```\n?$'), '').trim();

    try {
      final jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;
      
      final questionsList = (jsonMap['questions'] as List?)?.map((e) => e.toString()).toList() ?? [];
      final featuresList = (jsonMap['features'] as List?)?.map((f) {
        final fMap = f as Map<String, dynamic>;
        
        FeatureLayer layer;
        switch(fMap['layer']) {
          case 'domain': layer = FeatureLayer.domain; break;
          case 'data': layer = FeatureLayer.data; break;
          case 'shared': layer = FeatureLayer.shared; break;
          default: layer = FeatureLayer.ui;
        }

        final deps = (fMap['dependencies'] as List?)?.map((e) => e.toString()).toList() ?? [];
        
        // nodeId is supposed to be unique, we'll use the feature name for easier mapping and replace later in UI.
        return FeatureNode(
          nodeId: fMap['name'].toString().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_'),
          name: fMap['name'].toString(),
          layer: layer,
          dependencyIds: deps,
        );
      }).toList() ?? [];

      return AiAnalysisResult(
        questions: questionsList,
        features: featuresList,
      );
    } catch (e) {
      session.log('Failed to parse AI JSON: $e\nResponse text: $text');
      throw Exception('Failed to parse AI response. Please try again.');
    }
  }
}
