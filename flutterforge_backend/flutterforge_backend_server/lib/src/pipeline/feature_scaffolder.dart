import 'dart:io';
import 'package:mustache_template/mustache.dart';
import '../generated/protocol.dart';
import 'generator_event.dart';

class FeatureScaffolder {
  // We exclude standard features since they have their own generators
  static const List<String> _standardFeatures = ['auth', 'onboarding', 'paywall', 'settings', 'profile'];

  Stream<GeneratorEvent> generate(ProjectConfig config) async* {
    yield GeneratorEvent(message: 'Generating custom feature scaffolds...', progress: 0.1);
    
    final projectId = config.projectId ?? 'unknown_project';
    final projectDir = Directory('/tmp/flutterforge/$projectId');
    final templatesDir = Directory('lib/src/pipeline/templates/feature');

    if (!await templatesDir.exists()) {
      yield GeneratorEvent(message: 'Feature templates directory not found.', level: 'error', progress: 1.0, isError: true);
      return;
    }

    final customFeatures = config.features.where(
      (f) => !_standardFeatures.contains(f.name.toLowerCase())
    ).toList();

    if (customFeatures.isEmpty) {
      yield GeneratorEvent(message: 'No custom features to generate.', progress: 1.0);
      return;
    }

    final sm = config.architecture?.stateManagement?.toLowerCase() ?? 'bloc';
    final isBloc = sm == 'bloc';
    final isRiverpod = sm == 'riverpod';
    final isProvider = sm == 'provider';

    final entities = await templatesDir.list(recursive: true).toList();
    final templateFiles = entities.whereType<File>().where((e) {
      if (!e.path.endsWith('.mustache')) return false;
      final pathStr = e.path;
      if (pathStr.contains('/presentation/')) {
        if (pathStr.contains('/bloc/') && !isBloc) return false;
        if (pathStr.contains('/riverpod/') && !isRiverpod) return false;
        if (pathStr.contains('/provider/') && !isProvider) return false;
      }
      return true;
    }).toList();

    int totalTasks = customFeatures.length * templateFiles.length;
    int processed = 0;

    for (var feature in customFeatures) {
      final slug = feature.name.toLowerCase().replaceAll(' ', '_');
      
      // Basic PascalCase for class names
      final className = feature.name.split(RegExp(r'[ _]')).map((word) {
        if (word.isEmpty) return '';
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join('');

      // camelCase for variable names
      final camelCaseName = className[0].toLowerCase() + className.substring(1);

      final data = {
        'projectName': config.projectName,
        'slug': slug,
        'className': className,
        'camelCaseName': camelCaseName,
        'hasNetwork': config.architecture?.network == 'dio' || config.architecture?.network == 'http',
        'isBloc': isBloc,
        'isRiverpod': isRiverpod,
        'isProvider': isProvider,
      };

      for (var templateFile in templateFiles) {
        final relativePath = templateFile.path.replaceFirst(templatesDir.path, '');
        final cleanPath = relativePath.startsWith('/') ? relativePath.substring(1) : relativePath;
        
        // e.g. domain/entities/entity.mustache -> domain/entities/${slug}_entity.dart
        // bloc.mustache -> ${slug}_bloc.dart
        String destFilename = cleanPath.replaceAll('.mustache', '.dart');
        final parts = destFilename.split('/');
        final filename = parts.last;
        
        // If the filename is just "entity.dart", "bloc.dart", etc., we prepend the slug
        // If it already has something, we still might want to prepend. The templates are named "entity.mustache", etc.
        // Let's explicitly replace generic names
        String prefixedFilename = '${slug}_$filename';
        
        parts[parts.length - 1] = prefixedFilename;
        final finalDestRelative = parts.join('/');
        
        final finalDestPath = '${projectDir.path}/lib/features/$slug/$finalDestRelative';
        
        final destFile = File(finalDestPath);
        await destFile.parent.create(recursive: true);
        
        final templateContent = await templateFile.readAsString();
        final template = Template(templateContent, lenient: true);
        final output = template.renderString(data);
        
        await destFile.writeAsString(output);
        
        processed++;
        yield GeneratorEvent(
          message: 'Generated features/$slug/$finalDestRelative', 
          progress: 0.1 + (0.9 * (processed / totalTasks))
        );
      }
    }

    yield GeneratorEvent(
      message: 'Custom features generated successfully.',
      level: 'success',
      progress: 1.0,
    );
  }
}
