import 'dart:io';
import 'package:mustache_template/mustache.dart';
import '../generated/protocol.dart';
import 'generator_event.dart';

class OnboardingGenerator {
  Stream<GeneratorEvent> generate(ProjectConfig config) async* {
    final hasOnboarding = config.features.any((f) => f.name.toLowerCase() == 'onboarding');
    if (!hasOnboarding) return;

    yield GeneratorEvent(message: 'Generating Onboarding module...', progress: 0.1);
    
    final projectId = config.projectId ?? 'unknown_project';
    final projectDir = Directory('/tmp/flutterforge/$projectId');
    final templatesDir = Directory('lib/src/pipeline/templates/onboarding');

    if (!await templatesDir.exists()) {
      yield GeneratorEvent(message: 'Onboarding templates directory not found.', level: 'error', progress: 1.0, isError: true);
      return;
    }

    final data = {
      'projectName': config.projectName,
      'hasAuth': config.integrations.firebaseAuth,
    };

    final entities = await templatesDir.list(recursive: true).toList();
    int totalFiles = entities.whereType<File>().length;
    int processed = 0;

    for (var entity in entities) {
      if (entity is File && entity.path.endsWith('.mustache')) {
        final relativePath = entity.path.replaceFirst(templatesDir.path, '');
        final cleanPath = relativePath.startsWith('/') ? relativePath.substring(1) : relativePath;
        
        final destPath = cleanPath.replaceAll('.mustache', '.dart');
        final finalDestPath = '${projectDir.path}/lib/features/onboarding/$destPath';
        
        final destFile = File(finalDestPath);
        await destFile.parent.create(recursive: true);
        
        final templateContent = await entity.readAsString();
        final template = Template(templateContent, lenient: true);
        final output = template.renderString(data);
        
        await destFile.writeAsString(output);
        
        processed++;
        yield GeneratorEvent(
          message: 'Generated onboarding/$destPath', 
          progress: 0.1 + (0.9 * (processed / totalFiles))
        );
      }
    }

    yield GeneratorEvent(
      message: 'Onboarding module generated successfully.',
      level: 'success',
      progress: 1.0,
    );
  }
}
