import 'dart:io';
import 'package:mustache_template/mustache.dart';
import '../generated/protocol.dart';
import 'generator_event.dart';

class PaywallGenerator {
  Stream<GeneratorEvent> generate(ProjectConfig config) async* {
    final hasPaywall = config.integrations.revenueCat || config.monetization?.provider?.name == 'revenueCat';
    if (!hasPaywall) return;

    yield GeneratorEvent(message: 'Generating Paywall module...', progress: 0.1);
    
    final projectId = config.projectId ?? 'unknown_project';
    final projectDir = Directory('/tmp/flutterforge/$projectId');
    final templatesDir = Directory('lib/src/pipeline/templates/paywall');

    if (!await templatesDir.exists()) {
      yield GeneratorEvent(message: 'Paywall templates directory not found.', level: 'error', progress: 1.0, isError: true);
      return;
    }

    final data = {
      'projectName': config.projectName,
      'revenueCatApiKey': 'TODO_REVENUECAT_API_KEY', // User will replace this
      'entitlementId': 'premium',
    };

    final entities = await templatesDir.list(recursive: true).toList();
    int totalFiles = entities.whereType<File>().length;
    int processed = 0;

    for (var entity in entities) {
      if (entity is File && entity.path.endsWith('.mustache')) {
        final relativePath = entity.path.replaceFirst(templatesDir.path, '');
        final cleanPath = relativePath.startsWith('/') ? relativePath.substring(1) : relativePath;
        
        final destPath = cleanPath.replaceAll('.mustache', '.dart');
        final finalDestPath = '${projectDir.path}/lib/features/paywall/$destPath';
        
        final destFile = File(finalDestPath);
        await destFile.parent.create(recursive: true);
        
        final templateContent = await entity.readAsString();
        final template = Template(templateContent, lenient: true);
        final output = template.renderString(data);
        
        await destFile.writeAsString(output);
        
        processed++;
        yield GeneratorEvent(
          message: 'Generated paywall/$destPath', 
          progress: 0.1 + (0.9 * (processed / totalFiles))
        );
      }
    }

    yield GeneratorEvent(
      message: 'Paywall module generated successfully.',
      level: 'success',
      progress: 1.0,
    );
  }
}
