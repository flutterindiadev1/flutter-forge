import 'package:equatable/equatable.dart';
import 'feature_node.dart';

// --- Enums ---
enum WizardStep { identity, features, design, architecture, postman }

enum DesignSource { aiGenerated, figma, skipped }

enum UserPersonaType {
  general,
  business,
  developer,
  elderly,
  children,
  healthcare,
}

enum ColorMode { light, dark, system }

enum LayoutDensity { comfortable, compact, spacious }

enum AppStyle { minimal, material3, glassmorphism, playful, corporate }

enum TypographyFeel { modern, classic, rounded }

enum MonetizationModel { free, freemium, oneTimePurchase, adSupported }

enum SubscriptionProvider { revenueCat, inAppPurchase }

enum CiCdPlatform { githubActions, gitlabCi, bitbucketPipelines, none }

// --- Models ---
class UserPersona extends Equatable {
  final UserPersonaType type;
  final String role;
  final String goal;
  final String painPoints;
  final bool needsScreenReader;
  final bool needsLargeText;
  final bool needsHighContrast;
  final bool needsReducedMotion;

  const UserPersona({
    this.type = UserPersonaType.general,
    this.role = '',
    this.goal = '',
    this.painPoints = '',
    this.needsScreenReader = false,
    this.needsLargeText = false,
    this.needsHighContrast = false,
    this.needsReducedMotion = false,
  });

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'role': role,
    'goal': goal,
    'painPoints': painPoints,
    'needsScreenReader': needsScreenReader,
    'needsLargeText': needsLargeText,
    'needsHighContrast': needsHighContrast,
    'needsReducedMotion': needsReducedMotion,
  };

  @override
  List<Object?> get props => [
    type,
    role,
    goal,
    painPoints,
    needsScreenReader,
    needsLargeText,
    needsHighContrast,
    needsReducedMotion,
  ];
}

class AiDesignBrief extends Equatable {
  final String prompt;
  final String stylePreference;
  final AppStyle style;
  final String primaryColor;
  final TypographyFeel typography;
  final ColorMode colorMode;
  final LayoutDensity density;

  const AiDesignBrief({
    this.prompt = '',
    this.stylePreference = '',
    this.style = AppStyle.material3,
    this.primaryColor = '#6366F1',
    this.typography = TypographyFeel.modern,
    this.colorMode = ColorMode.system,
    this.density = LayoutDensity.comfortable,
  });

  Map<String, dynamic> toJson() => {
    'prompt': prompt,
    'stylePreference': stylePreference,
    'style': style.name,
    'primaryColor': primaryColor,
    'typography': typography.name,
    'colorMode': colorMode.name,
    'density': density.name,
  };

  @override
  List<Object?> get props => [
    prompt,
    stylePreference,
    style,
    primaryColor,
    typography,
    colorMode,
    density,
  ];
}

class AssetFile extends Equatable {
  final String id;
  final String name;
  final String type;
  final String url;
  final int sizeBytes;

  const AssetFile({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
    required this.sizeBytes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'url': url,
    'sizeBytes': sizeBytes,
  };

  @override
  List<Object?> get props => [id, name, type, url, sizeBytes];
}

class CustomPainterSpec extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? featureId;

  const CustomPainterSpec({
    required this.id,
    required this.name,
    required this.description,
    this.featureId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'featureId': featureId,
  };

  @override
  List<Object?> get props => [id, name, description, featureId];
}

class NativeModuleSpec extends Equatable {
  final String id;
  final String moduleName;
  final String description;
  final List<String> platforms;
  final String? featureId;

  const NativeModuleSpec({
    required this.id,
    required this.moduleName,
    required this.description,
    required this.platforms,
    this.featureId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'moduleName': moduleName,
    'description': description,
    'platforms': platforms,
    'featureId': featureId,
  };

  @override
  List<Object?> get props => [
    id,
    moduleName,
    description,
    platforms,
    featureId,
  ];
}

class PubDependency extends Equatable {
  final String id;
  final String packageName;
  final String pubDevUrl;
  final String? version;
  final String? featureId;

  const PubDependency({
    required this.id,
    required this.packageName,
    required this.pubDevUrl,
    this.version,
    this.featureId,
  });

  PubDependency copyWith({
    String? id,
    String? packageName,
    String? pubDevUrl,
    String? version,
    String? featureId,
  }) {
    return PubDependency(
      id: id ?? this.id,
      packageName: packageName ?? this.packageName,
      pubDevUrl: pubDevUrl ?? this.pubDevUrl,
      version: version ?? this.version,
      featureId: featureId ?? this.featureId,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'packageName': packageName,
    'pubDevUrl': pubDevUrl,
    'version': version,
    'featureId': featureId,
  };

  @override
  List<Object?> get props => [id, packageName, pubDevUrl, version, featureId];
}

class LlmInstruction extends Equatable {
  final String id;
  final String instruction;
  final String? featureId;

  const LlmInstruction({required this.id, required this.instruction, this.featureId});

  Map<String, dynamic> toJson() => {'id': id, 'instruction': instruction, 'featureId': featureId};

  @override
  List<Object?> get props => [id, instruction, featureId];
}

class IntegrationConfig extends Equatable {
  final bool firebaseAuth;
  final bool firebaseFirestore;
  final bool firebaseAnalytics;
  final bool firebaseCrashlytics;
  final bool firebaseMessaging;
  final bool firebaseRemoteConfig;
  final bool firebaseStorage;
  final bool stripe;
  final bool revenueCat;
  final bool googlePay;
  final bool googleMaps;
  final bool mapbox;
  final bool googleSignIn;
  final bool appleSignIn;
  final bool facebookAuth;
  final bool sentry;
  final bool datadog;
  final bool postHog;

  const IntegrationConfig({
    this.firebaseAuth = false,
    this.firebaseFirestore = false,
    this.firebaseAnalytics = false,
    this.firebaseCrashlytics = false,
    this.firebaseMessaging = false,
    this.firebaseRemoteConfig = false,
    this.firebaseStorage = false,
    this.stripe = false,
    this.revenueCat = false,
    this.googlePay = false,
    this.googleMaps = false,
    this.mapbox = false,
    this.googleSignIn = false,
    this.appleSignIn = false,
    this.facebookAuth = false,
    this.sentry = false,
    this.datadog = false,
    this.postHog = false,
  });

  IntegrationConfig copyWith({
    bool? firebaseAuth,
    bool? firebaseFirestore,
    bool? firebaseAnalytics,
    bool? firebaseCrashlytics,
    bool? firebaseMessaging,
    bool? firebaseRemoteConfig,
    bool? firebaseStorage,
    bool? stripe,
    bool? revenueCat,
    bool? googlePay,
    bool? googleMaps,
    bool? mapbox,
    bool? googleSignIn,
    bool? appleSignIn,
    bool? facebookAuth,
    bool? sentry,
    bool? datadog,
    bool? postHog,
  }) {
    return IntegrationConfig(
      firebaseAuth: firebaseAuth ?? this.firebaseAuth,
      firebaseFirestore: firebaseFirestore ?? this.firebaseFirestore,
      firebaseAnalytics: firebaseAnalytics ?? this.firebaseAnalytics,
      firebaseCrashlytics: firebaseCrashlytics ?? this.firebaseCrashlytics,
      firebaseMessaging: firebaseMessaging ?? this.firebaseMessaging,
      firebaseRemoteConfig: firebaseRemoteConfig ?? this.firebaseRemoteConfig,
      firebaseStorage: firebaseStorage ?? this.firebaseStorage,
      stripe: stripe ?? this.stripe,
      revenueCat: revenueCat ?? this.revenueCat,
      googlePay: googlePay ?? this.googlePay,
      googleMaps: googleMaps ?? this.googleMaps,
      mapbox: mapbox ?? this.mapbox,
      googleSignIn: googleSignIn ?? this.googleSignIn,
      appleSignIn: appleSignIn ?? this.appleSignIn,
      facebookAuth: facebookAuth ?? this.facebookAuth,
      sentry: sentry ?? this.sentry,
      datadog: datadog ?? this.datadog,
      postHog: postHog ?? this.postHog,
    );
  }

  Map<String, dynamic> toJson() => {
    'firebaseAuth': firebaseAuth,
    'firebaseFirestore': firebaseFirestore,
    'firebaseAnalytics': firebaseAnalytics,
    'firebaseCrashlytics': firebaseCrashlytics,
    'firebaseMessaging': firebaseMessaging,
    'firebaseRemoteConfig': firebaseRemoteConfig,
    'firebaseStorage': firebaseStorage,
    'stripe': stripe,
    'revenueCat': revenueCat,
    'googlePay': googlePay,
    'googleMaps': googleMaps,
    'mapbox': mapbox,
    'googleSignIn': googleSignIn,
    'appleSignIn': appleSignIn,
    'facebookAuth': facebookAuth,
    'sentry': sentry,
    'datadog': datadog,
    'postHog': postHog,
  };

  @override
  List<Object?> get props => [
    firebaseAuth,
    firebaseFirestore,
    firebaseAnalytics,
    firebaseCrashlytics,
    firebaseMessaging,
    firebaseRemoteConfig,
    firebaseStorage,
    stripe,
    revenueCat,
    googlePay,
    googleMaps,
    mapbox,
    googleSignIn,
    appleSignIn,
    facebookAuth,
    sentry,
    datadog,
    postHog,
  ];
}

class EnvironmentConfig extends Equatable {
  final bool hasDev;
  final bool hasStaging;
  final bool hasProd;
  final String bundleIdBase;
  final String minIosVersion;
  final int minAndroidSdk;

  const EnvironmentConfig({
    this.hasDev = true,
    this.hasStaging = true,
    this.hasProd = true,
    this.bundleIdBase = 'com.example.app',
    this.minIosVersion = '15.0',
    this.minAndroidSdk = 24,
  });

  EnvironmentConfig copyWith({
    bool? hasDev,
    bool? hasStaging,
    bool? hasProd,
    String? bundleIdBase,
    String? minIosVersion,
    int? minAndroidSdk,
  }) {
    return EnvironmentConfig(
      hasDev: hasDev ?? this.hasDev,
      hasStaging: hasStaging ?? this.hasStaging,
      hasProd: hasProd ?? this.hasProd,
      bundleIdBase: bundleIdBase ?? this.bundleIdBase,
      minIosVersion: minIosVersion ?? this.minIosVersion,
      minAndroidSdk: minAndroidSdk ?? this.minAndroidSdk,
    );
  }

  Map<String, dynamic> toJson() => {
    'hasDev': hasDev,
    'hasStaging': hasStaging,
    'hasProd': hasProd,
    'bundleIdBase': bundleIdBase,
    'minIosVersion': minIosVersion,
    'minAndroidSdk': minAndroidSdk,
  };

  @override
  List<Object?> get props => [
    hasDev,
    hasStaging,
    hasProd,
    bundleIdBase,
    minIosVersion,
    minAndroidSdk,
  ];
}

class LocalizationConfig extends Equatable {
  final List<String> targetLanguages;
  final String defaultLanguage;

  const LocalizationConfig({
    this.targetLanguages = const ['English'],
    this.defaultLanguage = 'English',
  });

  LocalizationConfig copyWith({
    List<String>? targetLanguages,
    String? defaultLanguage,
  }) {
    return LocalizationConfig(
      targetLanguages: targetLanguages ?? this.targetLanguages,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
    );
  }

  Map<String, dynamic> toJson() => {
    'targetLanguages': targetLanguages,
    'defaultLanguage': defaultLanguage,
  };

  @override
  List<Object?> get props => [targetLanguages, defaultLanguage];
}

class MonetizationConfig extends Equatable {
  final MonetizationModel model;
  final SubscriptionProvider? provider;
  final List<String> plans;

  const MonetizationConfig({
    this.model = MonetizationModel.free,
    this.provider,
    this.plans = const [],
  });

  MonetizationConfig copyWith({
    MonetizationModel? model,
    Object? provider = _sentinel,
    List<String>? plans,
  }) {
    return MonetizationConfig(
      model: model ?? this.model,
      provider: provider == _sentinel ? this.provider : provider as SubscriptionProvider?,
      plans: plans ?? this.plans,
    );
  }

  Map<String, dynamic> toJson() => {
    'model': model.name,
    'provider': provider?.name,
    'plans': plans,
  };

  @override
  List<Object?> get props => [model, provider, plans];
}

class TestingConfig extends Equatable {
  final bool generateUnitTests;
  final bool generateWidgetTests;
  final bool generateIntegrationTests;
  final int coverageTarget;

  const TestingConfig({
    this.generateUnitTests = true,
    this.generateWidgetTests = true,
    this.generateIntegrationTests = false,
    this.coverageTarget = 80,
  });

  TestingConfig copyWith({
    bool? generateUnitTests,
    bool? generateWidgetTests,
    bool? generateIntegrationTests,
    int? coverageTarget,
  }) {
    return TestingConfig(
      generateUnitTests: generateUnitTests ?? this.generateUnitTests,
      generateWidgetTests: generateWidgetTests ?? this.generateWidgetTests,
      generateIntegrationTests: generateIntegrationTests ?? this.generateIntegrationTests,
      coverageTarget: coverageTarget ?? this.coverageTarget,
    );
  }

  Map<String, dynamic> toJson() => {
    'generateUnitTests': generateUnitTests,
    'generateWidgetTests': generateWidgetTests,
    'generateIntegrationTests': generateIntegrationTests,
    'coverageTarget': coverageTarget,
  };

  @override
  List<Object?> get props => [
    generateUnitTests,
    generateWidgetTests,
    generateIntegrationTests,
    coverageTarget,
  ];
}

class CiCdConfig extends Equatable {
  final CiCdPlatform platform;
  final bool runTestsOnPr;
  final bool deployToFirebaseAppDistribution;
  final bool deployToStores;
  final bool notifySlack;

  const CiCdConfig({
    this.platform = CiCdPlatform.none,
    this.runTestsOnPr = false,
    this.deployToFirebaseAppDistribution = false,
    this.deployToStores = false,
    this.notifySlack = false,
  });

  Map<String, dynamic> toJson() => {
    'platform': platform.name,
    'runTestsOnPr': runTestsOnPr,
    'deployToFirebaseAppDistribution': deployToFirebaseAppDistribution,
    'deployToStores': deployToStores,
    'notifySlack': notifySlack,
  };

  @override
  List<Object?> get props => [
    platform,
    runTestsOnPr,
    deployToFirebaseAppDistribution,
    deployToStores,
    notifySlack,
  ];
}

class PostmanCollection extends Equatable {
  final String name;
  final String version;
  final List<PostmanFolder> folders;

  const PostmanCollection({
    required this.name,
    required this.version,
    required this.folders,
  });

  factory PostmanCollection.fromJson(Map<String, dynamic> json) {
    final info = json['info'] as Map<String, dynamic>? ?? {};
    final items = json['item'] as List<dynamic>? ?? [];
    return PostmanCollection(
      name: info['name']?.toString() ?? 'Unnamed Collection',
      version: info['schema']?.toString().contains('2.1') == true
          ? '2.1'
          : '2.0',
      folders: items
          .map((i) => PostmanFolder.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [name, version, folders];
}

class PostmanFolder extends Equatable {
  final String name;
  final List<PostmanEndpoint> endpoints;
  final List<PostmanFolder> subfolders;

  const PostmanFolder({
    required this.name,
    required this.endpoints,
    required this.subfolders,
  });

  factory PostmanFolder.fromJson(Map<String, dynamic> json) {
    final items = json['item'] as List<dynamic>? ?? [];
    final endpoints = <PostmanEndpoint>[];
    final subfolders = <PostmanFolder>[];

    for (final item in items) {
      final m = item as Map<String, dynamic>;
      if (m.containsKey('item')) {
        subfolders.add(PostmanFolder.fromJson(m));
      } else if (m.containsKey('request')) {
        endpoints.add(PostmanEndpoint.fromJson(m));
      }
    }

    return PostmanFolder(
      name: json['name']?.toString() ?? 'Unnamed',
      endpoints: endpoints,
      subfolders: subfolders,
    );
  }

  @override
  List<Object?> get props => [name, endpoints, subfolders];
}

class PostmanEndpoint extends Equatable {
  final String name;
  final String method;
  final String path;
  final List<String> detectedSchemas;

  const PostmanEndpoint({
    required this.name,
    required this.method,
    required this.path,
    required this.detectedSchemas,
  });

  factory PostmanEndpoint.fromJson(Map<String, dynamic> json) {
    final request = json['request'] as Map<String, dynamic>? ?? {};
    final url = request['url'];
    String path = '';
    if (url is String) {
      path = url;
    } else if (url is Map) {
      final raw = url['raw'] as String? ?? '';
      path = raw;
    }

    final body = request['body'] as Map<String, dynamic>? ?? {};
    final schemas = <String>[];
    if (body['raw'] != null) schemas.add('JSON Body');
    if (body['formdata'] != null) schemas.add('Form Data');

    return PostmanEndpoint(
      name: json['name']?.toString() ?? 'Unnamed',
      method: request['method']?.toString().toUpperCase() ?? 'GET',
      path: path,
      detectedSchemas: schemas,
    );
  }

  @override
  List<Object?> get props => [name, method, path];
}

class ArchitectureConfig extends Equatable {
  final String pattern;
  final String stateManagement;
  final String di;
  final String network;
  final String localStorage;
  final String navigation;

  const ArchitectureConfig({
    required this.pattern,
    required this.stateManagement,
    required this.di,
    required this.network,
    required this.localStorage,
    required this.navigation,
  });

  Map<String, dynamic> toJson() => {
    'pattern': pattern,
    'stateManagement': stateManagement,
    'di': di,
    'network': network,
    'localStorage': localStorage,
    'navigation': navigation,
  };

  @override
  List<Object?> get props => [
    pattern,
    stateManagement,
    di,
    network,
    localStorage,
    navigation,
  ];
}

class _Sentinel {
  const _Sentinel();
}

const _sentinel = _Sentinel();

class ProjectConfig extends Equatable {
  final String? projectId;
  final String projectName;
  final String description;
  final String team;
  final List<String> platforms;
  final String geminiApiKey;
  final String inspiredBy;
  final UserPersona? persona;
  final String? templateId;
  final List<FeatureNode> features;
  final List<CustomPainterSpec> customPainters;
  final List<NativeModuleSpec> nativeModules;
  final List<PubDependency> dependencies;
  final List<LlmInstruction> llmInstructions;
  final DesignSource designSource;
  final AiDesignBrief? aiDesignBrief;
  final String? figmaFileUrl;
  final String? figmaAccessToken;
  final AssetFile? appIcon;
  final List<AssetFile> assets;
  final ArchitectureConfig? architecture;
  final IntegrationConfig integrations;
  final EnvironmentConfig environment;
  final LocalizationConfig localization;
  final MonetizationConfig? monetization;
  final TestingConfig testing;
  final CiCdConfig ciCd;
  final PostmanCollection? postmanCollection;
  final String? githubToken;

  const ProjectConfig({
    this.projectId,
    this.projectName = '',
    this.description = '',
    this.team = '',
    this.platforms = const [],
    this.geminiApiKey = '',
    this.inspiredBy = '',
    this.persona,
    this.templateId,
    this.features = const [],
    this.customPainters = const [],
    this.nativeModules = const [],
    this.dependencies = const [],
    this.llmInstructions = const [],
    this.designSource = DesignSource.skipped,
    this.aiDesignBrief,
    this.figmaFileUrl,
    this.figmaAccessToken,
    this.appIcon,
    this.assets = const [],
    this.architecture = const ArchitectureConfig(
      pattern: 'clean_architecture',
      stateManagement: 'bloc',
      di: 'get_it',
      network: 'dio',
      localStorage: 'hive',
      navigation: 'go_router',
    ),
    this.integrations = const IntegrationConfig(),
    this.environment = const EnvironmentConfig(),
    this.localization = const LocalizationConfig(),
    this.monetization,
    this.testing = const TestingConfig(),
    this.ciCd = const CiCdConfig(),
    this.postmanCollection,
    this.githubToken,
  });

  ProjectConfig copyWith({
    String? projectId,
    String? projectName,
    String? description,
    String? team,
    List<String>? platforms,
    String? geminiApiKey,
    String? inspiredBy,
    Object? persona = _sentinel,
    Object? templateId = _sentinel,
    List<FeatureNode>? features,
    List<CustomPainterSpec>? customPainters,
    List<NativeModuleSpec>? nativeModules,
    List<PubDependency>? dependencies,
    List<LlmInstruction>? llmInstructions,
    DesignSource? designSource,
    Object? aiDesignBrief = _sentinel,
    Object? figmaFileUrl = _sentinel,
    Object? figmaAccessToken = _sentinel,
    Object? appIcon = _sentinel,
    List<AssetFile>? assets,
    Object? architecture = _sentinel,
    IntegrationConfig? integrations,
    EnvironmentConfig? environment,
    LocalizationConfig? localization,
    Object? monetization = _sentinel,
    TestingConfig? testing,
    CiCdConfig? ciCd,
    Object? postmanCollection = _sentinel,
    Object? githubToken = _sentinel,
  }) {
    return ProjectConfig(
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      description: description ?? this.description,
      team: team ?? this.team,
      platforms: platforms ?? this.platforms,
      geminiApiKey: geminiApiKey ?? this.geminiApiKey,
      inspiredBy: inspiredBy ?? this.inspiredBy,
      persona: persona == _sentinel ? this.persona : persona as UserPersona?,
      templateId: templateId == _sentinel
          ? this.templateId
          : templateId as String?,
      features: features ?? this.features,
      customPainters: customPainters ?? this.customPainters,
      nativeModules: nativeModules ?? this.nativeModules,
      dependencies: dependencies ?? this.dependencies,
      llmInstructions: llmInstructions ?? this.llmInstructions,
      designSource: designSource ?? this.designSource,
      aiDesignBrief: aiDesignBrief == _sentinel
          ? this.aiDesignBrief
          : aiDesignBrief as AiDesignBrief?,
      figmaFileUrl: figmaFileUrl == _sentinel
          ? this.figmaFileUrl
          : figmaFileUrl as String?,
      figmaAccessToken: figmaAccessToken == _sentinel
          ? this.figmaAccessToken
          : figmaAccessToken as String?,
      appIcon: appIcon == _sentinel ? this.appIcon : appIcon as AssetFile?,
      assets: assets ?? this.assets,
      architecture: architecture == _sentinel
          ? this.architecture
          : architecture as ArchitectureConfig?,
      integrations: integrations ?? this.integrations,
      environment: environment ?? this.environment,
      localization: localization ?? this.localization,
      monetization: monetization == _sentinel
          ? this.monetization
          : monetization as MonetizationConfig?,
      testing: testing ?? this.testing,
      ciCd: ciCd ?? this.ciCd,
      postmanCollection: postmanCollection == _sentinel
          ? this.postmanCollection
          : postmanCollection as PostmanCollection?,
      githubToken: githubToken == _sentinel
          ? this.githubToken
          : githubToken as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'projectId': projectId,
    'projectName': projectName,
    'description': description,
    'team': team,
    'platforms': platforms,
    'inspiredBy': inspiredBy,
    'persona': persona?.toJson(),
    'templateId': templateId,
    'features': features.map((f) => f.toJson()).toList(),
    'customPainters': customPainters.map((p) => p.toJson()).toList(),
    'nativeModules': nativeModules.map((m) => m.toJson()).toList(),
    'dependencies': dependencies.map((d) => d.toJson()).toList(),
    'llmInstructions': llmInstructions.map((i) => i.toJson()).toList(),
    'designSource': designSource.name,
    'aiDesignBrief': aiDesignBrief?.toJson(),
    'figma': {'fileUrl': figmaFileUrl, 'accessToken': figmaAccessToken},
    'appIcon': appIcon?.toJson(),
    'assets': assets.map((a) => a.toJson()).toList(),
    'architecture': architecture?.toJson(),
    'integrations': integrations.toJson(),
    'environment': environment.toJson(),
    'localization': localization.toJson(),
    'monetization': monetization?.toJson(),
    'testing': testing.toJson(),
    'ciCd': ciCd.toJson(),
    'postman': postmanCollection != null
        ? {
            'collectionVersion': postmanCollection!.version,
            'name': postmanCollection!.name,
            'folderCount': postmanCollection!.folders.length,
          }
        : null,
    'githubToken': githubToken,
  };

  String get slug =>
      projectName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');

  @override
  List<Object?> get props => [
    projectId,
    projectName,
    description,
    team,
    platforms,
    geminiApiKey,
    inspiredBy,
    persona,
    templateId,
    features,
    customPainters,
    nativeModules,
    dependencies,
    llmInstructions,
    designSource,
    aiDesignBrief,
    figmaFileUrl,
    figmaAccessToken,
    appIcon,
    assets,
    architecture,
    integrations,
    environment,
    localization,
    monetization,
    testing,
    ciCd,
    postmanCollection,
    githubToken,
  ];
}
