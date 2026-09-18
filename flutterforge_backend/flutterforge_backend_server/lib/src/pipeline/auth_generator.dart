import 'dart:io';
import 'package:mustache_template/mustache.dart';
import '../generated/protocol.dart';
import 'generator_event.dart';

class AuthGenerator {
  Stream<GeneratorEvent> generate(ProjectConfig config) async* {
    final hasAuth = config.integrations.firebaseAuth;
    if (!hasAuth) return; // Skip if auth is not requested

    yield GeneratorEvent(message: 'Generating Auth module...', progress: 0.1);
    
    final projectId = config.projectId ?? 'unknown_project';
    final projectDir = Directory('/tmp/flutterforge/$projectId');
    final templatesDir = Directory('lib/src/pipeline/templates/auth');

    if (!await templatesDir.exists()) {
      yield GeneratorEvent(message: 'Auth templates directory not found.', level: 'error', progress: 1.0, isError: true);
      return;
    }

    final sm = config.architecture?.stateManagement?.toLowerCase() ?? 'bloc';
    final isBloc = sm == 'bloc';
    final isRiverpod = sm == 'riverpod';
    final isProvider = sm == 'provider';

    final data = {
      'projectName': config.projectName,
      'hasAuth': hasAuth,
      'isBloc': isBloc,
      'isRiverpod': isRiverpod,
      'isProvider': isProvider,
    };

    final entities = await templatesDir.list(recursive: true).toList();
    int totalFiles = entities.whereType<File>().length;
    int processed = 0;

    for (var entity in entities) {
      if (entity is File && entity.path.endsWith('.mustache')) {
        final pathStr = entity.path;
        if (pathStr.contains('/presentation/')) {
          if (pathStr.contains('/bloc/') && !isBloc) continue;
          if (pathStr.contains('/riverpod/') && !isRiverpod) continue;
          if (pathStr.contains('/provider/') && !isProvider) continue;
        }

        // Strip the base path
        final relativePath = pathStr.replaceFirst(templatesDir.path, '');
        final cleanPath = relativePath.startsWith('/') ? relativePath.substring(1) : relativePath;
        
        // Convert .mustache to .dart and place in lib/features/auth/
        final destPath = cleanPath.replaceAll('.mustache', '.dart');
        final finalDestPath = '${projectDir.path}/lib/features/auth/$destPath';
        
        final destFile = File(finalDestPath);
        await destFile.parent.create(recursive: true);
        
        // Render
        final templateContent = await entity.readAsString();
        final template = Template(templateContent, lenient: true);
        final output = template.renderString(data);
        
        await destFile.writeAsString(output);
        
        processed++;
        yield GeneratorEvent(
          message: 'Generated auth/$destPath', 
          progress: 0.1 + (0.9 * (processed / totalFiles))
        );
      }
    }

    yield GeneratorEvent(
      message: 'Auth module generated successfully.',
      level: 'success',
      progress: 1.0,
    );
  }
}
