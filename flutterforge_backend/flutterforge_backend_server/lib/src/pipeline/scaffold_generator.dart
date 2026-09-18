import 'dart:io';
import 'dart:convert';
import '../generated/protocol.dart';

class ScaffoldEvent {
  final String message;
  final String level;
  final double progress;
  final bool isError;

  ScaffoldEvent({
    required this.message,
    this.level = 'info',
    this.progress = 0.0,
    this.isError = false,
  });
}

class ScaffoldGenerator {
  Stream<ScaffoldEvent> generate(ProjectConfig config) async* {
    yield ScaffoldEvent(message: 'Initializing scaffold...', progress: 0.1);
    
    // We will generate in /tmp/flutterforge/<projectId>
    final projectId = config.projectId ?? 'unknown_project';
    final projectDir = Directory('/tmp/flutterforge/$projectId');
    
    if (await projectDir.exists()) {
      yield ScaffoldEvent(message: 'Cleaning up existing directory...', progress: 0.15);
      await projectDir.delete(recursive: true);
    }
    await projectDir.create(recursive: true);
    
    final projectName = config.projectName.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_').toLowerCase();
    final org = config.environment.bundleIdBase;
    
    final List<String> args = [
      'create',
      '.',
      '--project-name',
      projectName,
      '--org',
      org,
      '--no-pub'
    ];

    if (config.platforms.isNotEmpty) {
      args.add('--platforms');
      args.add(config.platforms.map((p) => p.toLowerCase()).join(','));
    }

    yield ScaffoldEvent(message: 'Running flutter create...', progress: 0.2);

    try {
      final process = await Process.start(
        'flutter',
        args,
        workingDirectory: projectDir.path,
      );

      // We will stream process output using await for on process.stdout
      
      double currentProgress = 0.2;
      await for (final line in process.stdout.transform(utf8.decoder).transform(const LineSplitter())) {
        currentProgress = (currentProgress + 0.05).clamp(0.2, 0.9);
        yield ScaffoldEvent(message: '  $line', progress: currentProgress);
      }

      final exitCode = await process.exitCode;
      if (exitCode != 0) {
        final stderrStr = await process.stderr.transform(utf8.decoder).join();
        yield ScaffoldEvent(
          message: 'Flutter create failed: $stderrStr',
          level: 'error',
          progress: 1.0,
          isError: true,
        );
        return;
      }
      
      yield ScaffoldEvent(
        message: 'Scaffold generated successfully in $projectDir',
        level: 'success',
        progress: 1.0,
      );
    } catch (e) {
      yield ScaffoldEvent(
        message: 'Failed to start flutter create: $e',
        level: 'error',
        progress: 1.0,
        isError: true,
      );
    }
  }
}
