import 'dart:io';
import 'package:mustache_template/mustache_template.dart';
import '../generated/protocol.dart';

class ArchitectureEvent {
  final String message;
  final String level;
  final double progress;
  final bool isError;

  ArchitectureEvent({
    required this.message,
    this.level = 'info',
    this.progress = 0.0,
    this.isError = false,
  });
}

class ArchitectureGenerator {
  Stream<ArchitectureEvent> generate(ProjectConfig config) async* {
    yield ArchitectureEvent(message: 'Scaffolding architecture structure...', progress: 0.1);
    
    final projectId = config.projectId ?? 'unknown_project';
    final projectDir = Directory('/tmp/flutterforge/$projectId');
    
    // Default to clean_bloc if null
    final pattern = config.architecture?.pattern ?? 'clean_architecture';
    final stateMgmt = config.architecture?.stateManagement ?? 'bloc';
    final templateSet = '${pattern}_$stateMgmt';
    
    yield ArchitectureEvent(message: 'Using template set: $templateSet', progress: 0.2);

    // Create base directories
    final dirsToCreate = [
      'lib/core/di',
      'lib/core/network',
      'lib/core/theme',
      'lib/features',
      'lib/shared/widgets',
    ];

    for (int i = 0; i < dirsToCreate.length; i++) {
      final dir = dirsToCreate[i];
      await Directory('${projectDir.path}/$dir').create(recursive: true);
      yield ArchitectureEvent(message: 'Created $dir', progress: 0.2 + (0.1 * (i / dirsToCreate.length)));
    }

    // In a real app we would read mustache files from the backend's assets/templates directory
    // For this prototype, we'll just write a basic main.dart directly
    
    yield ArchitectureEvent(message: 'Writing lib/main.dart...', progress: 0.8);
    
    final mainDartContent = '''
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${config.projectName}',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('FlutterForge Generated App'),
        ),
      ),
    );
  }
}
''';

    await File('${projectDir.path}/lib/main.dart').writeAsString(mainDartContent);

    yield ArchitectureEvent(
      message: 'Architecture generated successfully.',
      level: 'success',
      progress: 1.0,
    );
  }
}
