import 'package:flutter/foundation.dart';
import 'project_config.dart';
import 'feature_node.dart';

FeatureNode parseFeatureNode(Map<String, dynamic> json) {
  return FeatureNode(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    description: json['description'] as String? ?? '',
    layer: FeatureLayer.values.firstWhere(
      (e) => e.name == json['layer'],
      orElse: () => FeatureLayer.domain,
    ),
    dependencyIds: (json['dependencies'] as List?)?.map((e) => e as String).toList() ?? [],
    x: json['x'] as double?,
    y: json['y'] as double?,
  );
}

UserPersona parseUserPersona(Map<String, dynamic> json) {
  return UserPersona(
    type: UserPersonaType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => UserPersonaType.values.first,
    ),
    role: json['role'] as String? ?? '',
    goal: json['goal'] as String? ?? '',
    painPoints: json['painPoints'] as String? ?? '',
    needsScreenReader: json['needsScreenReader'] as bool? ?? false,
    needsLargeText: json['needsLargeText'] as bool? ?? false,
    needsHighContrast: json['needsHighContrast'] as bool? ?? false,
    needsReducedMotion: json['needsReducedMotion'] as bool? ?? false,
  );
}

AiDesignBrief parseAiDesignBrief(Map<String, dynamic> json) {
  return AiDesignBrief(
    prompt: json['prompt'] as String? ?? '',
    stylePreference: json['stylePreference'] as String? ?? '',
    style: AppStyle.values.firstWhere(
      (e) => e.name == json['style'],
      orElse: () => AppStyle.values.first,
    ),
    primaryColor: json['primaryColor'] as String? ?? '',
    typography: TypographyFeel.values.firstWhere(
      (e) => e.name == json['typography'],
      orElse: () => TypographyFeel.values.first,
    ),
    colorMode: ColorMode.values.firstWhere(
      (e) => e.name == json['colorMode'],
      orElse: () => ColorMode.values.first,
    ),
    density: LayoutDensity.values.firstWhere(
      (e) => e.name == json['density'],
      orElse: () => LayoutDensity.values.first,
    ),
  );
}

AssetFile parseAssetFile(Map<String, dynamic> json) {
  return AssetFile(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    type: json['type'] as String? ?? '',
    url: json['url'] as String? ?? '',
    sizeBytes: json['sizeBytes'] as int? ?? 0,
  );
}

CustomPainterSpec parseCustomPainterSpec(Map<String, dynamic> json) {
  return CustomPainterSpec(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    description: json['description'] as String? ?? '',
    featureId: json['featureId'] as String?,
  );
}

NativeModuleSpec parseNativeModuleSpec(Map<String, dynamic> json) {
  return NativeModuleSpec(
    id: json['id'] as String? ?? '',
    moduleName: json['moduleName'] as String? ?? '',
    description: json['description'] as String? ?? '',
    platforms:
        (json['platforms'] as List?)?.map((e) => e as String).toList() ?? [],
    featureId: json['featureId'] as String?,
  );
}

PubDependency parsePubDependency(Map<String, dynamic> json) {
  return PubDependency(
    id: json['id'] as String? ?? '',
    packageName: json['packageName'] as String? ?? '',
    pubDevUrl: json['pubDevUrl'] as String? ?? '',
    version: json['version'] as String?,
    featureId: json['featureId'] as String?,
  );
}

LlmInstruction parseLlmInstruction(Map<String, dynamic> json) {
  return LlmInstruction(
    id: json['id'] as String? ?? '',
    instruction: json['instruction'] as String? ?? '',
    featureId: json['featureId'] as String?,
  );
}

IntegrationConfig parseIntegrationConfig(Map<String, dynamic> json) {
  return IntegrationConfig(
    firebaseAuth: json['firebaseAuth'] as bool? ?? false,
    firebaseFirestore: json['firebaseFirestore'] as bool? ?? false,
    firebaseAnalytics: json['firebaseAnalytics'] as bool? ?? false,
    firebaseCrashlytics: json['firebaseCrashlytics'] as bool? ?? false,
    firebaseMessaging: json['firebaseMessaging'] as bool? ?? false,
    firebaseRemoteConfig: json['firebaseRemoteConfig'] as bool? ?? false,
    firebaseStorage: json['firebaseStorage'] as bool? ?? false,
    stripe: json['stripe'] as bool? ?? false,
    revenueCat: json['revenueCat'] as bool? ?? false,
    googlePay: json['googlePay'] as bool? ?? false,
    googleMaps: json['googleMaps'] as bool? ?? false,
    mapbox: json['mapbox'] as bool? ?? false,
    googleSignIn: json['googleSignIn'] as bool? ?? false,
    appleSignIn: json['appleSignIn'] as bool? ?? false,
    facebookAuth: json['facebookAuth'] as bool? ?? false,
    sentry: json['sentry'] as bool? ?? false,
    datadog: json['datadog'] as bool? ?? false,
    postHog: json['postHog'] as bool? ?? false,
  );
}

EnvironmentConfig parseEnvironmentConfig(Map<String, dynamic> json) {
  return EnvironmentConfig(
    hasDev: json['hasDev'] as bool? ?? false,
    hasStaging: json['hasStaging'] as bool? ?? false,
    hasProd: json['hasProd'] as bool? ?? false,
    bundleIdBase: json['bundleIdBase'] as String? ?? '',
    minIosVersion: json['minIosVersion'] as String? ?? '',
    minAndroidSdk: json['minAndroidSdk'] as int? ?? 0,
  );
}

LocalizationConfig parseLocalizationConfig(Map<String, dynamic> json) {
  return LocalizationConfig(
    targetLanguages:
        (json['targetLanguages'] as List?)?.map((e) => e as String).toList() ??
        [],
    defaultLanguage: json['defaultLanguage'] as String? ?? '',
  );
}

MonetizationConfig parseMonetizationConfig(Map<String, dynamic> json) {
  return MonetizationConfig(
    model: MonetizationModel.values.firstWhere(
      (e) => e.name == json['model'],
      orElse: () => MonetizationModel.values.first,
    ),
    provider: SubscriptionProvider.values.firstWhere(
      (e) => e.name == json['provider'],
      orElse: () => SubscriptionProvider.values.first,
    ),
    plans: (json['plans'] as List?)?.map((e) => e as String).toList() ?? [],
  );
}

TestingConfig parseTestingConfig(Map<String, dynamic> json) {
  return TestingConfig(
    generateUnitTests: json['generateUnitTests'] as bool? ?? false,
    generateWidgetTests: json['generateWidgetTests'] as bool? ?? false,
    generateIntegrationTests:
        json['generateIntegrationTests'] as bool? ?? false,
    coverageTarget: json['coverageTarget'] as int? ?? 0,
  );
}

CiCdConfig parseCiCdConfig(Map<String, dynamic> json) {
  return CiCdConfig(
    platform: CiCdPlatform.values.firstWhere(
      (e) => e.name == json['platform'],
      orElse: () => CiCdPlatform.values.first,
    ),
    runTestsOnPr: json['runTestsOnPr'] as bool? ?? false,
    deployToFirebaseAppDistribution:
        json['deployToFirebaseAppDistribution'] as bool? ?? false,
    deployToStores: json['deployToStores'] as bool? ?? false,
    notifySlack: json['notifySlack'] as bool? ?? false,
  );
}

PostmanCollection parsePostmanCollection(Map<String, dynamic> json) {
  return PostmanCollection(
    name: json['name'] as String? ?? '',
    version: json['version'] as String? ?? '',
    folders:
        (json['folders'] as List?)
            ?.map((e) => parsePostmanFolder(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

PostmanFolder parsePostmanFolder(Map<String, dynamic> json) {
  return PostmanFolder(
    name: json['name'] as String? ?? '',
    endpoints:
        (json['endpoints'] as List?)
            ?.map((e) => parsePostmanEndpoint(e as Map<String, dynamic>))
            .toList() ??
        [],
    subfolders:
        (json['subfolders'] as List?)
            ?.map((e) => parsePostmanFolder(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

PostmanEndpoint parsePostmanEndpoint(Map<String, dynamic> json) {
  return PostmanEndpoint(
    name: json['name'] as String? ?? '',
    method: json['method'] as String? ?? '',
    path: json['path'] as String? ?? '',
    detectedSchemas:
        (json['detectedSchemas'] as List?)?.map((e) => e as String).toList() ??
        [],
  );
}

ArchitectureConfig parseArchitectureConfig(Map<String, dynamic> json) {
  return ArchitectureConfig(
    pattern: json['pattern'] as String? ?? '',
    stateManagement: json['stateManagement'] as String? ?? '',
    di: json['di'] as String? ?? '',
    network: json['network'] as String? ?? '',
    localStorage: json['localStorage'] as String? ?? '',
    navigation: json['navigation'] as String? ?? '',
  );
}

ProjectConfig parseProjectConfig(Map<String, dynamic> json) {
  debugPrint('parseProjectConfig called for ${json['projectName']}');
  return ProjectConfig(
    projectId: json['projectId'] as String?,
    projectName: json['projectName'] as String? ?? '',
    description: json['description'] as String? ?? '',
    team: json['team'] as String? ?? '',
    platforms:
        (json['platforms'] as List?)?.map((e) => e as String).toList() ?? [],
    geminiApiKey: json['geminiApiKey'] as String? ?? '',
    inspiredBy: json['inspiredBy'] as String? ?? '',
    persona: json['persona'] != null
        ? parseUserPersona(json['persona'] as Map<String, dynamic>)
        : null,
    templateId: json['templateId'] as String?,
    features:
        (json['features'] as List?)?.map((e) => parseFeatureNode(e as Map<String, dynamic>)).toList() ??
        [],
    customPainters:
        (json['customPainters'] as List?)
            ?.map((e) => parseCustomPainterSpec(e as Map<String, dynamic>))
            .toList() ??
        [],
    nativeModules:
        (json['nativeModules'] as List?)
            ?.map((e) => parseNativeModuleSpec(e as Map<String, dynamic>))
            .toList() ??
        [],
    dependencies:
        (json['dependencies'] as List?)
            ?.map((e) => parsePubDependency(e as Map<String, dynamic>))
            .toList() ??
        [],
    llmInstructions:
        (json['llmInstructions'] as List?)
            ?.map((e) => parseLlmInstruction(e as Map<String, dynamic>))
            .toList() ??
        [],
    designSource: DesignSource.values.firstWhere(
      (e) => e.name == json['designSource'],
      orElse: () => DesignSource.values.first,
    ),
    aiDesignBrief: json['aiDesignBrief'] != null
        ? parseAiDesignBrief(json['aiDesignBrief'] as Map<String, dynamic>)
        : null,
    figmaFileUrl: json['figmaFileUrl'] as String?,
    figmaAccessToken: json['figmaAccessToken'] as String?,
    appIcon: json['appIcon'] != null
        ? parseAssetFile(json['appIcon'] as Map<String, dynamic>)
        : null,
    assets:
        (json['assets'] as List?)
            ?.map((e) => parseAssetFile(e as Map<String, dynamic>))
            .toList() ??
        [],
    architecture: json['architecture'] != null
        ? parseArchitectureConfig(json['architecture'] as Map<String, dynamic>)
        : null,
    integrations: json['integrations'] != null
        ? parseIntegrationConfig(json['integrations'] as Map<String, dynamic>)
        : const IntegrationConfig(),
    environment: json['environment'] != null
        ? parseEnvironmentConfig(json['environment'] as Map<String, dynamic>)
        : const EnvironmentConfig(),
    localization: json['localization'] != null
        ? parseLocalizationConfig(json['localization'] as Map<String, dynamic>)
        : const LocalizationConfig(),
    monetization: json['monetization'] != null
        ? parseMonetizationConfig(json['monetization'] as Map<String, dynamic>)
        : null,
    testing: json['testing'] != null
        ? parseTestingConfig(json['testing'] as Map<String, dynamic>)
        : const TestingConfig(),
    ciCd: json['ciCd'] != null
        ? parseCiCdConfig(json['ciCd'] as Map<String, dynamic>)
        : const CiCdConfig(),
    postmanCollection: json['postmanCollection'] != null
        ? parsePostmanCollection(
            json['postmanCollection'] as Map<String, dynamic>,
          )
        : null,
    githubToken: json['githubToken'] as String?,
  );
}
