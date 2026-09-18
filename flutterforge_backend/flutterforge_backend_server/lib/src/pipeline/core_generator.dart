import 'dart:io';
import 'package:mustache_template/mustache.dart';
import '../generated/protocol.dart';
import 'generator_event.dart';

class CoreGenerator {
  Stream<GeneratorEvent> generate(ProjectConfig config) async* {
    yield GeneratorEvent(message: 'Generating core architecture...', progress: 0.1);
    
    final projectId = config.projectId ?? 'unknown_project';
    final projectDir = Directory('/tmp/flutterforge/$projectId');
    final templatesDir = Directory('lib/src/pipeline/templates/core');

    if (!await templatesDir.exists()) {
      yield GeneratorEvent(message: 'Templates directory not found.', level: 'error', progress: 1.0, isError: true);
      return;
    }

    // Clean up default files from flutter create
    final defaultTestFile = File('${projectDir.path}/test/widget_test.dart');
    if (await defaultTestFile.exists()) {
      await defaultTestFile.delete();
    }

    // Determine booleans from ProjectConfig
    final hasAuth = config.integrations.firebaseAuth;
    final hasPaywall = config.integrations.revenueCat || config.monetization?.provider?.name == 'revenueCat';
    final hasSettings = config.features.any((f) => f.name.toLowerCase() == 'settings');
    final hasOnboarding = config.features.any((f) => f.name.toLowerCase() == 'onboarding');
    final hasFirebase = config.integrations.firebaseAuth || config.integrations.firebaseFirestore || config.integrations.firebaseCrashlytics;
    final hasCrashlytics = config.integrations.firebaseCrashlytics;
    final hasLocalization = config.localization.targetLanguages.length > 1;

    final sm = config.architecture?.stateManagement?.toLowerCase() ?? 'bloc';
    final isBloc = sm == 'bloc';
    final isRiverpod = sm == 'riverpod';
    final isProvider = sm == 'provider';

    final data = {
      'projectName': config.projectName,
      'hasAuth': hasAuth,
      'hasPaywall': hasPaywall,
      'hasSettings': hasSettings,
      'hasOnboarding': hasOnboarding,
      'hasFirebase': hasFirebase,
      'hasCrashlytics': hasCrashlytics,
      'hasLocalization': hasLocalization,
      'apiBaseUrl': 'https://api.example.com',
      'primaryColor': '0xFF6200EE',
      'isBloc': isBloc,
      'isRiverpod': isRiverpod,
      'isProvider': isProvider,
    };

    final entities = await templatesDir.list(recursive: true).toList();
    int totalFiles = entities.whereType<File>().length;
    int processed = 0;

    for (var entity in entities) {
      if (entity is File && entity.path.endsWith('.mustache')) {
        // Strip the base path 'lib/src/pipeline/templates/core'
        final relativePath = entity.path.replaceFirst(templatesDir.path, '');
        final cleanPath = relativePath.startsWith('/') ? relativePath.substring(1) : relativePath;
        
        // Convert .mustache to .dart
        final destPath = cleanPath.replaceAll('.mustache', '.dart');
        final finalDestPath = '${projectDir.path}/lib/$destPath';
        
        final destFile = File(finalDestPath);
        await destFile.parent.create(recursive: true);
        
        // Render
        final templateContent = await entity.readAsString();
        final template = Template(templateContent, lenient: true);
        final output = template.renderString(data);
        
        await destFile.writeAsString(output);
        
        processed++;
        yield GeneratorEvent(
          message: 'Generated lib/$destPath', 
          progress: 0.1 + (0.9 * (processed / totalFiles))
        );
      }
    }

    yield GeneratorEvent(
      message: 'Core architecture generated successfully.',
      level: 'success',
      progress: 1.0,
    );
  }
}
