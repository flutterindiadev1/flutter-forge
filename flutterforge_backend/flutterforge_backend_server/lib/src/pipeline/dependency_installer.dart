import 'dart:io';
import 'dart:convert';
import '../generated/protocol.dart';

class DependencyEvent {
  final String message;
  final String level;
  final double progress;
  final bool isError;

  DependencyEvent({
    required this.message,
    this.level = 'info',
    this.progress = 0.0,
    this.isError = false,
  });
}

class DependencyInstaller {
  Stream<DependencyEvent> install(ProjectConfig config) async* {
    yield DependencyEvent(message: 'Installing dependencies...', progress: 0.0);
    
    final projectId = config.projectId ?? 'unknown_project';
    final projectDir = Directory('/tmp/flutterforge/$projectId');
    
    if (config.dependencies.isEmpty) {
      yield DependencyEvent(message: 'No extra dependencies to install.', progress: 1.0);
      return;
    }

    final totalDeps = config.dependencies.length;
    int currentDep = 0;

    for (final dep in config.dependencies) {
      final packageRef = dep.version != null ? '${dep.packageName}:${dep.version}' : dep.packageName;
      
      yield DependencyEvent(
        message: 'Adding $packageRef...',
        progress: currentDep / totalDeps,
      );

      try {
        final process = await Process.start(
          'flutter',
          ['pub', 'add', packageRef],
          workingDirectory: projectDir.path,
        );

        // We can just await it since pub add is usually fast
        final exitCode = await process.exitCode;
        if (exitCode != 0) {
          final stderrStr = await process.stderr.transform(utf8.decoder).join();
          yield DependencyEvent(
            message: 'Failed to add ${dep.packageName}: $stderrStr',
            level: 'error',
            progress: 1.0,
            isError: true,
          );
          return;
        }

        currentDep++;
        yield DependencyEvent(
          message: '✓ Added ${dep.packageName}',
          level: 'success',
          progress: currentDep / totalDeps,
        );
      } catch (e) {
        yield DependencyEvent(
          message: 'Error installing ${dep.packageName}: $e',
          level: 'error',
          progress: 1.0,
          isError: true,
        );
        return;
      }
    }

    yield DependencyEvent(
      message: 'All dependencies installed.',
      level: 'success',
      progress: 1.0,
    );
  }
}
