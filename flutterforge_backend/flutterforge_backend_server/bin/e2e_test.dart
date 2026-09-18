import 'dart:async';
import 'package:flutterforge_backend_server/src/generated/protocol.dart';
import 'package:flutterforge_backend_server/src/pipeline/pipeline_orchestrator.dart';

void main() async {
  print('Starting E2E Test...');
  
  final config = ProjectConfig(
    projectId: 'e2e_test_project',
    projectName: 'E2eTestProject',
    description: 'An E2E test project',
    team: 'Flutter Forge',
    platforms: ['ios', 'android'],
    features: [
      FeatureNode(
        nodeId: 'feat_1',
        name: 'Settings',
        layer: FeatureLayer.ui,
        dependencyIds: [],
      ),
      FeatureNode(
        nodeId: 'feat_2',
        name: 'Dashboard',
        layer: FeatureLayer.ui,
        dependencyIds: [],
      ),
      FeatureNode(
        nodeId: 'feat_3',
        name: 'Onboarding',
        layer: FeatureLayer.ui,
        dependencyIds: [],
      ),
    ],
    customPainters: [],
    nativeModules: [],
    dependencies: [],
    assets: [],
    architecture: ArchitectureConfig(
      pattern: 'clean',
      stateManagement: 'riverpod',
      di: 'get_it',
      network: 'dio',
      localStorage: 'hive',
      navigation: 'go_router',
    ),
    integrations: IntegrationConfig(
      firebaseAuth: true,
      firebaseFirestore: true,
      firebaseCrashlytics: true,
      firebaseAnalytics: false,
      firebaseMessaging: false,
      firebaseRemoteConfig: false,
      firebaseStorage: false,
      revenueCat: true,
      stripe: false,
      sentry: false,
      googlePay: false,
      googleMaps: false,
      mapbox: false,
      googleSignIn: false,
      appleSignIn: false,
      facebookAuth: false,
      datadog: false,
      postHog: false,
    ),
    environment: EnvironmentConfig(
      hasDev: true,
      hasStaging: false,
      hasProd: true,
      bundleIdBase: 'com.flutterforge',
      minIosVersion: '13.0',
      minAndroidSdk: 21,
    ),
    localization: LocalizationConfig(
      targetLanguages: ['en', 'es'],
      defaultLanguage: 'en',
    ),
    testing: TestingConfig(
      generateUnitTests: true,
      generateWidgetTests: true,
      generateIntegrationTests: true,
      coverageTarget: 80,
    ),
    ciCd: CiCdConfig(
      platform: CiCdPlatform.githubActions,
      runTestsOnPr: true,
      deployToFirebaseAppDistribution: true,
      deployToStores: true,
      notifySlack: false,
    ),
  );

  final StreamController<PipelineCommand> commandController = StreamController();
  final orchestrator = PipelineOrchestrator(
    config: config,
    commandIterator: StreamIterator(commandController.stream),
  );

  await for (final state in orchestrator.run()) {
    if (state.logs.isNotEmpty) {
      final latest = state.logs.last;
      print('[${latest.level}] ${latest.message} (Progress: ${state.phaseProgress})');
    }
  }
  
  print('E2E Test generation phase complete.');
}
