import 'dart:io';
import 'package:mustache_template/mustache.dart';
import '../generated/protocol.dart';
import 'generator_event.dart';

class CicdGenerator {
  Stream<GeneratorEvent> generate(ProjectConfig config) async* {
    yield GeneratorEvent(message: 'Generating CI/CD and Fastlane pipelines...', progress: 0.1);
    
    if (config.ciCd.platform == CiCdPlatform.none && !config.ciCd.deployToFirebaseAppDistribution && !config.ciCd.deployToStores) {
      yield GeneratorEvent(
        message: 'No CI/CD pipeline requested.',
        level: 'success',
        progress: 1.0,
      );
      return;
    }

    final projectId = config.projectId ?? 'unknown_project';
    final projectDir = Directory('/tmp/flutterforge/$projectId');

    final data = {
      'projectName': config.projectName,
      'runTestsOnPr': config.ciCd.runTestsOnPr,
      'deployToFirebaseAppDistribution': config.ciCd.deployToFirebaseAppDistribution,
      'deployToStores': config.ciCd.deployToStores,
    };

    // Fastlane
    if (config.ciCd.deployToFirebaseAppDistribution || config.ciCd.deployToStores) {
      final fastlaneTemplateFile = File('lib/src/pipeline/templates/cicd/fastlane/Fastfile.mustache');
      if (await fastlaneTemplateFile.exists()) {
        final content = await fastlaneTemplateFile.readAsString();
        final template = Template(content, lenient: true);
        final output = template.renderString(data);
        
        final fastlaneDirIos = Directory('${projectDir.path}/ios/fastlane');
        await fastlaneDirIos.create(recursive: true);
        await File('${fastlaneDirIos.path}/Fastfile').writeAsString(output);

        final fastlaneDirAndroid = Directory('${projectDir.path}/android/fastlane');
        await fastlaneDirAndroid.create(recursive: true);
        await File('${fastlaneDirAndroid.path}/Fastfile').writeAsString(output);
        
        yield GeneratorEvent(message: 'Generated Fastlane configurations', progress: 0.5);
      }
    }

    // CI/CD Platform
    if (config.ciCd.platform != CiCdPlatform.none) {
      String? templatePath;
      String? destPath;

      switch (config.ciCd.platform) {
        case CiCdPlatform.githubActions:
          templatePath = 'lib/src/pipeline/templates/cicd/githubActions/main.yml.mustache';
          destPath = '.github/workflows/main.yml';
          break;
        case CiCdPlatform.gitlabCi:
          templatePath = 'lib/src/pipeline/templates/cicd/gitlabCi/.gitlab-ci.yml.mustache';
          destPath = '.gitlab-ci.yml';
          break;
        case CiCdPlatform.bitbucketPipelines:
          templatePath = 'lib/src/pipeline/templates/cicd/bitbucketPipelines/bitbucket-pipelines.yml.mustache';
          destPath = 'bitbucket-pipelines.yml';
          break;
        default:
          break;
      }

      if (templatePath != null && destPath != null) {
        final templateFile = File(templatePath);
        if (await templateFile.exists()) {
          final content = await templateFile.readAsString();
          final template = Template(content, lenient: true);
          final output = template.renderString(data);
          
          final destFile = File('${projectDir.path}/$destPath');
          await destFile.parent.create(recursive: true);
          await destFile.writeAsString(output);
          
          yield GeneratorEvent(message: 'Generated $destPath', progress: 0.9);
        }
      }
    }

    yield GeneratorEvent(
      message: 'CI/CD pipelines generated successfully.',
      level: 'success',
      progress: 1.0,
    );
  }
}
