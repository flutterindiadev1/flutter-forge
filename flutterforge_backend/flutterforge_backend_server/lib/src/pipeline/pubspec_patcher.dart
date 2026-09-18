import 'dart:io';
import '../generated/protocol.dart';

class PubspecEvent {
  final String message;
  final String level;
  final double progress;
  final bool isError;

  PubspecEvent({
    required this.message,
    this.level = 'info',
    this.progress = 0.0,
    this.isError = false,
  });
}

class PubspecPatcher {
  Stream<PubspecEvent> patch(ProjectConfig config) async* {
    yield PubspecEvent(message: 'Patching pubspec.yaml...', progress: 0.1);
    
    final projectId = config.projectId ?? 'unknown_project';
    final projectPath = '/tmp/flutterforge/$projectId';
    final pubspecFile = File('$projectPath/pubspec.yaml');
    
    if (!await pubspecFile.exists()) {
      yield PubspecEvent(message: 'pubspec.yaml not found.', level: 'error', progress: 1.0, isError: true);
      return;
    }
    
    String content = await pubspecFile.readAsString();
    
    // Check localization
    if (config.localization.targetLanguages.length > 1) {
      yield PubspecEvent(message: 'Adding localization settings...', progress: 0.5);
      
      if (!content.contains('flutter_localizations:')) {
        content = content.replaceFirst(
          'dependencies:\n  flutter:\n    sdk: flutter',
          'dependencies:\n  flutter:\n    sdk: flutter\n  flutter_localizations:\n    sdk: flutter\n  intl: any'
        );
      }
      
      if (!content.contains('generate: true')) {
        content = content.replaceFirst(
          '\nflutter:\n',
          '\nflutter:\n  generate: true\n'
        );
      }
      
      // Generate l10n.yaml
      final l10nFile = File('$projectPath/l10n.yaml');
      await l10nFile.writeAsString('''
arb-dir: lib/l10n
template-arb-file: app_${config.localization.defaultLanguage}.arb
''');

      // Generate base arb files
      final arbDir = Directory('$projectPath/lib/l10n');
      await arbDir.create(recursive: true);
      final arbFile = File('${arbDir.path}/app_${config.localization.defaultLanguage}.arb');
      await arbFile.writeAsString('{\n  "helloWorld": "Hello World!"\n}');
      
      for (final lang in config.localization.targetLanguages) {
        if (lang == config.localization.defaultLanguage) continue;
        final targetArbFile = File('${arbDir.path}/app_$lang.arb');
        await targetArbFile.writeAsString('{\n  "helloWorld": "Hello World!"\n}');
      }
    }
    
    // Check Design & Assets
    if (config.appIcon != null || config.assets.isNotEmpty) {
      yield PubspecEvent(message: 'Configuring assets...', progress: 0.6);
      
      final assetsDir = Directory('$projectPath/assets');
      if (!await assetsDir.exists()) await assetsDir.create(recursive: true);
      
      final iconsDir = Directory('$projectPath/assets/icons');
      if (!await iconsDir.exists()) await iconsDir.create(recursive: true);
      
      final assetPaths = <String>{};
      
      if (config.appIcon != null) {
        final ext = config.appIcon!.name.split('.').last;
        final iconPath = 'assets/icons/app_icon.$ext';
        // Create an empty dummy file so flutter pub get doesn't crash
        await File('$projectPath/$iconPath').writeAsBytes([0]); 
        assetPaths.add('assets/icons/');
      }
      
      for (final asset in config.assets) {
        final assetPath = 'assets/${asset.name}';
        await File('$projectPath/$assetPath').writeAsBytes([0]);
        assetPaths.add('assets/');
      }
      
      if (assetPaths.isNotEmpty) {
        if (!content.contains('\n  assets:')) {
          final assetsStr = assetPaths.map((p) => '    - $p').join('\n');
          content = content.replaceFirst(
            '\nflutter:\n',
            '\nflutter:\n  assets:\n$assetsStr\n'
          );
        }
      }
    }
    
    await pubspecFile.writeAsString(content);
    
    yield PubspecEvent(message: 'Pubspec patched successfully.', level: 'success', progress: 1.0);
  }
}
