import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../models/project_config.dart';
import '../../models/feature_node.dart';
import 'wizard_state.dart';
import '../../../../core/network/api_client.dart';
import 'package:flutterforge_backend_client/flutterforge_backend_client.dart'
    as sp;
import 'package:google_generative_ai/google_generative_ai.dart';

class WizardCubit extends Cubit<WizardState> {
  WizardCubit()
    : super(WizardState(config: ProjectConfig(projectId: const Uuid().v4())));

  void reset({String? templateId}) {
    final tId = templateId ?? 'Blank Canvas';
    String projectName = '';
    String description = '';
    
    if (tId == 'E-Commerce') {
      projectName = 'E-Commerce App';
      description = 'A fully-featured e-commerce platform with Cart, Payments, and Product Catalog features.';
    } else if (tId == 'Social Media') {
      projectName = 'Social Network';
      description = 'A social networking app including Feeds, Profiles, and Chat functionality.';
    } else if (tId == 'SaaS Dashboard') {
      projectName = 'Admin Portal';
      description = 'Admin panels, charts, and user management ready to go.';
    }

    emit(WizardState(
      config: ProjectConfig(
        projectId: const Uuid().v4(),
        templateId: tId,
        projectName: projectName,
        description: description,
      ),
    ));
    loadSavedApiKey();
  }

  // ─── API Key Management ───────────────────────────────────────────────────

  Future<void> loadSavedApiKey() async {
    try {
      final settings = await client.user.getSettings();
      bool apiSaved = false;
      bool githubSaved = false;
      var newConfig = state.config;
      
      if (settings.geminiApiKey != null && settings.geminiApiKey!.isNotEmpty) {
        newConfig = newConfig.copyWith(geminiApiKey: settings.geminiApiKey);
        apiSaved = true;
      }
      
      // Load GitHub token as well
      if (settings.githubToken != null && settings.githubToken!.isNotEmpty) {
        newConfig = newConfig.copyWith(githubToken: settings.githubToken);
        githubSaved = true;
      }

      emit(
        state.copyWith(
          config: newConfig,
          apiKeySaved: apiSaved,
          githubTokenSaved: githubSaved,
        ),
      );
    } catch (e) {
      debugPrint('Failed to load api keys: $e');
      emit(state.copyWith(apiKeySaved: false, githubTokenSaved: false));
    }
  }

  Future<void> saveApiKey(String key) async {
    try {
      await client.user.saveApiKey(key);
      emit(
        state.copyWith(
          config: state.config.copyWith(geminiApiKey: key),
          apiKeySaved: true,
        ),
      );
    } catch (e) {
      debugPrint('Failed to save api key: $e');
    }
  }

  Future<void> saveGithubToken(String key) async {
    try {
      await client.user.saveGithubToken(key);
      emit(
        state.copyWith(
          config: state.config.copyWith(githubToken: key),
          githubTokenSaved: true,
        ),
      );
    } catch (e) {
      debugPrint('Failed to save github token: $e');
    }
  }

  // ─── Background AI Analysis ───────────────────────────────────────────────

  Future<void> triggerBackgroundAnalysis() async {
    if (state.config.description.isEmpty) {
      return;
    }
    if (state.aiAnalysisStatus == AiAnalysisStatus.running ||
        state.aiAnalysisStatus == AiAnalysisStatus.done) {
      return;
    }

    emit(
      state.copyWith(
        aiAnalysisStatus: AiAnalysisStatus.running,
        clearError: true,
      ),
    );

    try {
      List<FeatureNode> generatedFeatures = [];
      final apiKey = state.config.geminiApiKey;

      if (apiKey.isEmpty) {
        // Fallback to dummy data if no API key is provided
        await Future.delayed(const Duration(seconds: 2));
        generatedFeatures = [
          FeatureNode(
            id: const Uuid().v4(),
            name: 'Authentication',
            description: 'Login, signup, password reset',
            layer: FeatureLayer.domain,
            dependencyIds: const [],
            x: 100,
            y: 100,
          ),
          FeatureNode(
            id: const Uuid().v4(),
            name: 'Dashboard',
            description: 'Main view with stats and quick actions',
            layer: FeatureLayer.ui,
            dependencyIds: const [],
            x: 300,
            y: 100,
          ),
        ];
      } else {
        final prompt = '''
You are a software architect. I am building a Flutter app named '${state.config.projectName}'.
App description: '${state.config.description}'.
${state.config.persona != null ? "Target persona: ${state.config.persona!.role} (Goal: ${state.config.persona!.goal})" : ""}

Generate a list of exactly 4 to 8 core features required to build this app.
Respond ONLY with a valid JSON array of objects.
Each object must have exactly these keys:
- "name": (string) A short name for the feature.
- "description": (string) A brief description.
- "layer": (string) One of 'ui', 'domain', 'data', or 'shared'.
- "dependencies": (array of strings) The exact names of other features in this list that this feature depends on.
''';

        final content = [Content.text(prompt)];
        String responseText = '[]';
        
        try {
          final model = GenerativeModel(
            model: 'gemini-3.6-flash',
            apiKey: apiKey,
            generationConfig: GenerationConfig(
              responseMimeType: 'application/json',
            ),
          );
          final response = await model.generateContent(content);
          responseText = response.text ?? '[]';
        } catch (e1) {
          if (e1.toString().contains('503') || e1.toString().contains('UNAVAILABLE')) {
            throw Exception('The AI model is currently experiencing high demand. Please try again later.');
          }
          debugPrint('Falling back to gemini-1.5-pro due to: $e1');
          try {
            final fallbackModel = GenerativeModel(
              model: 'gemini-1.5-pro',
              apiKey: apiKey,
              generationConfig: GenerationConfig(
                responseMimeType: 'application/json',
              ),
            );
            final response = await fallbackModel.generateContent(content);
            responseText = response.text ?? '[]';
          } catch (e2) {
            if (e2.toString().contains('503') || e2.toString().contains('UNAVAILABLE')) {
              throw Exception('The AI model is currently experiencing high demand. Please try again later.');
            }
            debugPrint('Both AI calls failed. Falling back to dummy features. Error: $e2');
            generatedFeatures = [
              FeatureNode(id: const Uuid().v4(), name: 'Authentication', description: 'Login, signup', layer: FeatureLayer.domain, dependencyIds: const [], x: 100, y: 100),
              FeatureNode(id: const Uuid().v4(), name: 'Dashboard', description: 'Main view', layer: FeatureLayer.ui, dependencyIds: const [], x: 300, y: 100),
            ];
          }
        }
        
        if (generatedFeatures.isEmpty) {
          String cleanJson = responseText.trim();
          if (cleanJson.startsWith('```json')) {
            cleanJson = cleanJson.substring(7);
          } else if (cleanJson.startsWith('```')) {
            cleanJson = cleanJson.substring(3);
          }
          if (cleanJson.endsWith('```')) {
            cleanJson = cleanJson.substring(0, cleanJson.length - 3);
          }
          cleanJson = cleanJson.trim();
          
          final List<dynamic> jsonList = jsonDecode(cleanJson);
          final Map<String, String> nameToId = {};
          final Map<String, List<String>> nameToDeps = {};
          
          double currentX = 100;
          double currentY = 100;
          
          // First pass: generate IDs and map them
          for (var item in jsonList) {
            final name = (item as Map<String, dynamic>)['name']?.toString() ?? 'Unknown Feature';
            nameToId[name] = const Uuid().v4();
            nameToDeps[name] = List<String>.from(item['dependencies'] ?? []);
          }

          for (var i = 0; i < jsonList.length; i++) {
            final item = jsonList[i] as Map<String, dynamic>;
            final name = item['name']?.toString() ?? 'Unknown Feature';
            final layerStr = item['layer']?.toString().toLowerCase() ?? 'domain';
            FeatureLayer layer;
            switch (layerStr) {
              case 'ui': layer = FeatureLayer.ui; break;
              case 'data': layer = FeatureLayer.data; break;
              case 'shared': layer = FeatureLayer.shared; break;
              default: layer = FeatureLayer.domain;
            }

            final depNames = nameToDeps[name] ?? [];
            final depIds = depNames
                .map((depName) => nameToId[depName])
                .where((id) => id != null)
                .cast<String>()
                .toList();

            generatedFeatures.add(
              FeatureNode(
                id: nameToId[name]!,
                name: name,
                description: item['description']?.toString() ?? '',
                layer: layer,
                dependencyIds: depIds,
                x: currentX,
                y: currentY,
              ),
            );

            // Simple layout: increment Y for every feature, X alternates or wraps
            currentY += 100;
            if (currentY > 400) {
              currentY = 100;
              currentX += 250;
            }
          }
        }
      }

      emit(
        state.copyWith(
          aiAnalysisStatus: AiAnalysisStatus.done,
          config: state.config.copyWith(features: generatedFeatures),
        ),
      );
    } catch (e) {
      debugPrint('AI Analysis Error: $e');
      emit(
        state.copyWith(
          aiAnalysisStatus: AiAnalysisStatus.failed,
          aiAnalysisError: e.toString(),
        ),
      );
    }
  }

  void retryAnalysis() {
    emit(
      state.copyWith(aiAnalysisStatus: AiAnalysisStatus.idle, clearError: true),
    );
    triggerBackgroundAnalysis();
  }

  // ─── Navigation ───────────────────────────────────────────────────────────

  void nextStep() {
    final steps = WizardStep.values;
    final idx = state.stepIndex;
    if (idx < steps.length - 1) {
      emit(state.copyWith(currentStep: steps[idx + 1], clearError: true));
      if (steps[idx] == WizardStep.identity) {
        triggerBackgroundAnalysis();
      }
    }
  }

  void previousStep() {
    final steps = WizardStep.values;
    final idx = state.stepIndex;
    if (idx > 0) {
      emit(state.copyWith(currentStep: steps[idx - 1], clearError: true));
    }
  }

  void goToStep(WizardStep step) {
    emit(state.copyWith(currentStep: step, clearError: true));
    if (step == WizardStep.features &&
        state.aiAnalysisStatus == AiAnalysisStatus.idle) {
      triggerBackgroundAnalysis();
    }
  }

  // ─── Step 1: Identity ─────────────────────────────────────────────────────

  void updateIdentity({
    String? projectName,
    String? description,
    String? team,
    List<String>? platforms,
    String? geminiApiKey,
    String? inspiredBy,
    UserPersona? persona,
  }) {
    emit(
      state.copyWith(
        config: state.config.copyWith(
          projectName: projectName,
          description: description,
          team: team,
          platforms: platforms,
          geminiApiKey: geminiApiKey,
          inspiredBy: inspiredBy,
          persona: persona,
        ),
      ),
    );
  }

  // ─── Step 2: Features (and Custom Requirements) ───────────────────────────

  void addFeature(FeatureNode feature) {
    final updated = [...state.config.features, feature];
    _updateFeaturesWithCycleCheck(updated);
  }

  void addMultipleFeatures(List<FeatureNode> newFeatures) {
    final existingNames = state.config.features.map((e) => e.name).toSet();
    final toAdd = newFeatures
        .where((f) => !existingNames.contains(f.name))
        .toList();
    final updated = [...state.config.features, ...toAdd];
    _updateFeaturesWithCycleCheck(updated);
  }

  void updateFeature(FeatureNode feature) {
    final updated = state.config.features
        .map((f) => f.id == feature.id ? feature : f)
        .toList();
    _updateFeaturesWithCycleCheck(updated);
  }

  void removeFeature(String featureId) {
    final updated = state.config.features
        .where((f) => f.id != featureId)
        .map(
          (f) => f.copyWith(
            dependencyIds: f.dependencyIds
                .where((d) => d != featureId)
                .toList(),
          ),
        )
        .toList();
    _updateFeaturesWithCycleCheck(updated);
  }

  void updateFeaturePosition(String featureId, double x, double y) {
    final updated = state.config.features
        .map((f) => f.id == featureId ? f.copyWith(x: x, y: y) : f)
        .toList();
    emit(state.copyWith(config: state.config.copyWith(features: updated)));
  }

  void toggleDependency(String featureId, String dependencyId) {
    final features = state.config.features;
    final feature = features.firstWhere((f) => f.id == featureId);
    final newDeps = feature.dependencyIds.contains(dependencyId)
        ? feature.dependencyIds.where((d) => d != dependencyId).toList()
        : [...feature.dependencyIds, dependencyId];
    final updated = features
        .map((f) => f.id == featureId ? f.copyWith(dependencyIds: newDeps) : f)
        .toList();
    _updateFeaturesWithCycleCheck(updated);
  }

  void _updateFeaturesWithCycleCheck(List<FeatureNode> features) {
    final cycles = DependencyGraphValidator.detectCycles(features);
    emit(
      state.copyWith(
        config: state.config.copyWith(features: features),
        cyclicDependencyWarnings: cycles,
      ),
    );
  }

  // Custom Requirements
  void addCustomPainter(CustomPainterSpec spec) {
    emit(
      state.copyWith(
        config: state.config.copyWith(
          customPainters: [...state.config.customPainters, spec],
        ),
      ),
    );
  }

  void removeCustomPainter(String id) {
    emit(
      state.copyWith(
        config: state.config.copyWith(
          customPainters: state.config.customPainters
              .where((p) => p.id != id)
              .toList(),
        ),
      ),
    );
  }

  void addNativeModule(NativeModuleSpec spec) {
    emit(
      state.copyWith(
        config: state.config.copyWith(
          nativeModules: [...state.config.nativeModules, spec],
        ),
      ),
    );
  }

  void removeNativeModule(String id) {
    emit(
      state.copyWith(
        config: state.config.copyWith(
          nativeModules: state.config.nativeModules
              .where((m) => m.id != id)
              .toList(),
        ),
      ),
    );
  }

  void addDependency(PubDependency dep) {
    emit(
      state.copyWith(
        config: state.config.copyWith(
          dependencies: [...state.config.dependencies, dep],
        ),
      ),
    );
  }

  void removeDependency(String id) {
    emit(
      state.copyWith(
        config: state.config.copyWith(
          dependencies: state.config.dependencies
              .where((d) => d.id != id)
              .toList(),
        ),
      ),
    );
  }

  Future<PubDependency?> resolvePubDevUrl(String url) async {
    try {
      final dep = await client.project.resolvePubDependency(url);
      if (dep != null) {
        return PubDependency(
          id: const Uuid().v4(),
          packageName: dep.packageName,
          pubDevUrl: dep.pubDevUrl,
          version: dep.version,
        );
      }
    } catch (e) {
      debugPrint('Error resolving pub dev url: $e');
    }
    return null;
  }

  void addLlmInstruction(LlmInstruction instruction) {
    emit(
      state.copyWith(
        config: state.config.copyWith(
          llmInstructions: [...state.config.llmInstructions, instruction],
        ),
      ),
    );
  }

  void removeLlmInstruction(String id) {
    emit(
      state.copyWith(
        config: state.config.copyWith(
          llmInstructions: state.config.llmInstructions
              .where((i) => i.id != id)
              .toList(),
        ),
      ),
    );
  }

  // ─── Step 3: Design + Assets ──────────────────────────────────────────────

  void updateDesignSource(DesignSource source) {
    emit(state.copyWith(config: state.config.copyWith(designSource: source)));
  }

  void updateAiDesignBrief(AiDesignBrief brief) {
    emit(state.copyWith(config: state.config.copyWith(aiDesignBrief: brief)));
  }

  void updateFigma({String? figmaFileUrl, String? figmaAccessToken}) {
    emit(
      state.copyWith(
        config: state.config.copyWith(
          figmaFileUrl: figmaFileUrl,
          figmaAccessToken: figmaAccessToken,
        ),
      ),
    );
  }

  Future<void> uploadAppIcon(dynamic file) async {
    // TODO: implement file upload
    final asset = AssetFile(
      id: const Uuid().v4(),
      name: 'icon.png',
      type: 'icon',
      url: 'https://example.com/icon.png',
      sizeBytes: 1024,
    );
    emit(state.copyWith(config: state.config.copyWith(appIcon: asset)));
  }

  Future<void> uploadAsset(dynamic file) async {
    // TODO: implement file upload
    final asset = AssetFile(
      id: const Uuid().v4(),
      name: 'asset.png',
      type: 'image',
      url: 'https://example.com/asset.png',
      sizeBytes: 1024,
    );
    emit(
      state.copyWith(
        config: state.config.copyWith(assets: [...state.config.assets, asset]),
      ),
    );
  }

  void removeAsset(String id) {
    emit(
      state.copyWith(
        config: state.config.copyWith(
          assets: state.config.assets.where((a) => a.id != id).toList(),
        ),
      ),
    );
  }

  // ─── Step 4: Architecture (and configs) ───────────────────────────────────

  void updateArchitecture(ArchitectureConfig architecture) {
    emit(
      state.copyWith(config: state.config.copyWith(architecture: architecture)),
    );
  }

  void updateArchitectureField({
    String? pattern,
    String? stateManagement,
    String? di,
    String? network,
    String? localStorage,
    String? navigation,
  }) {
    final current =
        state.config.architecture ??
        const ArchitectureConfig(
          pattern: 'clean_architecture',
          stateManagement: 'bloc',
          di: 'get_it',
          network: 'dio',
          localStorage: 'hive',
          navigation: 'go_router',
        );
    emit(
      state.copyWith(
        config: state.config.copyWith(
          architecture: ArchitectureConfig(
            pattern: pattern ?? current.pattern,
            stateManagement: stateManagement ?? current.stateManagement,
            di: di ?? current.di,
            network: network ?? current.network,
            localStorage: localStorage ?? current.localStorage,
            navigation: navigation ?? current.navigation,
          ),
        ),
      ),
    );
  }

  void updateIntegrations(IntegrationConfig config) {
    emit(state.copyWith(config: state.config.copyWith(integrations: config)));
  }

  void updateEnvironment(EnvironmentConfig config) {
    emit(state.copyWith(config: state.config.copyWith(environment: config)));
  }

  void updateLocalization(LocalizationConfig config) {
    emit(state.copyWith(config: state.config.copyWith(localization: config)));
  }

  void updateMonetization(MonetizationConfig? config) {
    emit(state.copyWith(config: state.config.copyWith(monetization: config)));
  }

  void updateTesting(TestingConfig config) {
    emit(state.copyWith(config: state.config.copyWith(testing: config)));
  }

  void updateCiCd(CiCdConfig config) {
    emit(state.copyWith(config: state.config.copyWith(ciCd: config)));
  }

  // ─── Step 5: Postman ──────────────────────────────────────────────────────

  void loadPostmanCollection(String jsonContent) {
    try {
      final decoded = json.decode(jsonContent) as Map<String, dynamic>;
      final collection = PostmanCollection.fromJson(decoded);
      emit(
        state.copyWith(
          config: state.config.copyWith(postmanCollection: collection),
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Invalid Postman collection: ${e.toString()}',
        ),
      );
    }
  }

  void clearPostmanCollection() {
    emit(
      state.copyWith(
        config: state.config.copyWith(
          postmanCollection: null,
        ), // Will null out via sentinel if we fixed copyWith to accept null, wait, the sentinel is _sentinel, but we pass null here, which is fine since the default is _sentinel, not null. Wait. In copyWith: Object? postmanCollection = _sentinel. If we pass null, it uses null.
        clearError: true,
      ),
    );
  }

  // ─── Templates ────────────────────────────────────────────────────────────

  void applyTemplate(ProjectConfig templateConfig) {
    emit(
      state.copyWith(
        config: templateConfig,
        currentStep: WizardStep.identity, // Reset to first step
        clearError: true,
      ),
    );
  }

  // ─── Submit ───────────────────────────────────────────────────────────────

  Future<bool> submitProject() async {
    if (!state.githubTokenSaved && (state.config.githubToken == null || state.config.githubToken!.isEmpty)) {
      emit(state.copyWith(errorMessage: 'GitHub Token is required for the pipeline to push to your repository. Please go back to Step 1 and provide it.'));
      return false;
    }
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      final local = state.config;
      final spConfig = sp.ProjectConfig(
        projectId: local.projectId ?? 'pending',
        projectName: local.projectName,
        description: local.description,
        team: local.team,
        platforms: local.platforms,
        geminiApiKey: local.geminiApiKey,
        inspiredBy: local.inspiredBy,
        persona: local.persona != null ? sp.UserPersona(
          type: sp.UserPersonaType.values.firstWhere((e) => e.name == local.persona!.type.name, orElse: () => sp.UserPersonaType.general),
          role: local.persona!.role,
          goal: local.persona!.goal,
          painPoints: local.persona!.painPoints,
          needsScreenReader: local.persona!.needsScreenReader,
          needsLargeText: local.persona!.needsLargeText,
          needsHighContrast: local.persona!.needsHighContrast,
          needsReducedMotion: local.persona!.needsReducedMotion,
        ) : null,
        templateId: local.templateId,
        features: local.features.map((f) => sp.FeatureNode(nodeId: f.id, name: f.name, layer: sp.FeatureLayer.values.firstWhere((e) => e.name == f.layer.name, orElse: () => sp.FeatureLayer.shared), dependencyIds: f.dependencyIds)).toList(),
        nativeModules: local.nativeModules.map((m) => sp.NativeModuleSpec(id: m.id, moduleName: m.moduleName, description: m.description, platforms: m.platforms, featureId: m.featureId)).toList(),
        customPainters: local.customPainters.map((p) => sp.CustomPainterSpec(id: p.id, name: p.name, description: p.description, featureId: p.featureId)).toList(),
        dependencies: local.dependencies.map((d) => sp.PubDependency(id: d.id, packageName: d.packageName, pubDevUrl: d.pubDevUrl, version: d.version)).toList(),
        llmInstructions: local.llmInstructions.map((i) => sp.LlmInstruction(id: i.id, instruction: i.instruction, featureId: i.featureId)).toList(),
        designSource: sp.DesignSource.values.firstWhere((e) => e.name == local.designSource.name, orElse: () => sp.DesignSource.aiGenerated),
        aiDesignBrief: local.aiDesignBrief != null ? sp.AiDesignBrief(
          prompt: local.aiDesignBrief!.prompt,
          stylePreference: local.aiDesignBrief!.stylePreference,
          style: sp.AppStyle.values.firstWhere((e) => e.name == local.aiDesignBrief!.style.name, orElse: () => sp.AppStyle.material3),
          primaryColor: local.aiDesignBrief!.primaryColor,
          typography: sp.TypographyFeel.values.firstWhere((e) => e.name == local.aiDesignBrief!.typography.name, orElse: () => sp.TypographyFeel.modern),
          colorMode: sp.ColorMode.values.firstWhere((e) => e.name == local.aiDesignBrief!.colorMode.name, orElse: () => sp.ColorMode.system),
          density: sp.LayoutDensity.values.firstWhere((e) => e.name == local.aiDesignBrief!.density.name, orElse: () => sp.LayoutDensity.comfortable),
        ) : null,
        figmaFileUrl: local.figmaFileUrl,
        figmaAccessToken: local.figmaAccessToken,
        appIcon: local.appIcon != null ? sp.AssetFile(id: local.appIcon!.id, name: local.appIcon!.name, type: local.appIcon!.type, url: local.appIcon!.url, sizeBytes: local.appIcon!.sizeBytes) : null,
        assets: local.assets.map((a) => sp.AssetFile(id: a.id, name: a.name, type: a.type, url: a.url, sizeBytes: a.sizeBytes)).toList(),
        architecture: local.architecture != null ? sp.ArchitectureConfig(pattern: local.architecture!.pattern, stateManagement: local.architecture!.stateManagement, di: local.architecture!.di, network: local.architecture!.network, localStorage: local.architecture!.localStorage, navigation: local.architecture!.navigation) : null,
        integrations: sp.IntegrationConfig(
          firebaseAuth: local.integrations.firebaseAuth,
          firebaseFirestore: local.integrations.firebaseFirestore,
          firebaseAnalytics: local.integrations.firebaseAnalytics,
          firebaseCrashlytics: local.integrations.firebaseCrashlytics,
          firebaseMessaging: local.integrations.firebaseMessaging,
          firebaseRemoteConfig: local.integrations.firebaseRemoteConfig,
          firebaseStorage: local.integrations.firebaseStorage,
          stripe: local.integrations.stripe,
          revenueCat: local.integrations.revenueCat,
          googlePay: local.integrations.googlePay,
          googleMaps: local.integrations.googleMaps,
          mapbox: local.integrations.mapbox,
          googleSignIn: local.integrations.googleSignIn,
          appleSignIn: local.integrations.appleSignIn,
          facebookAuth: local.integrations.facebookAuth,
          sentry: local.integrations.sentry,
          datadog: local.integrations.datadog,
          postHog: local.integrations.postHog,
        ),
        environment: sp.EnvironmentConfig(
          hasDev: local.environment.hasDev,
          hasStaging: local.environment.hasStaging,
          hasProd: local.environment.hasProd,
          bundleIdBase: local.environment.bundleIdBase,
          minIosVersion: local.environment.minIosVersion,
          minAndroidSdk: local.environment.minAndroidSdk,
        ),
        localization: sp.LocalizationConfig(
          targetLanguages: local.localization.targetLanguages,
          defaultLanguage: local.localization.defaultLanguage,
        ),
        monetization: local.monetization != null ? sp.MonetizationConfig(
          model: sp.MonetizationModel.values.firstWhere((e) => e.name == local.monetization!.model.name, orElse: () => sp.MonetizationModel.free),
          provider: local.monetization!.provider != null ? sp.SubscriptionProvider.values.firstWhere((e) => e.name == local.monetization!.provider!.name, orElse: () => sp.SubscriptionProvider.revenueCat) : null,
          plans: local.monetization!.plans,
        ) : null,
        testing: sp.TestingConfig(
          generateUnitTests: local.testing.generateUnitTests,
          generateWidgetTests: local.testing.generateWidgetTests,
          generateIntegrationTests: local.testing.generateIntegrationTests,
          coverageTarget: local.testing.coverageTarget,
        ),
        ciCd: sp.CiCdConfig(platform: sp.CiCdPlatform.values.firstWhere((e) => e.name == local.ciCd.platform.name, orElse: () => sp.CiCdPlatform.none), runTestsOnPr: local.ciCd.runTestsOnPr, deployToFirebaseAppDistribution: local.ciCd.deployToFirebaseAppDistribution, deployToStores: local.ciCd.deployToStores, notifySlack: local.ciCd.notifySlack),
        postmanCollection: local.postmanCollection != null ? sp.PostmanConfig(collectionVersion: local.postmanCollection!.version, name: local.postmanCollection!.name, folderCount: local.postmanCollection!.folders.length) : null,
        githubToken: local.githubToken,
      );

      final generatedId = await client.project.submitConfig(spConfig);
      
      // Update local state with the backend-generated ID
      emit(state.copyWith(config: state.config.copyWith(projectId: generatedId)));
      return true;
    } catch (e) {
      debugPrint('Error submitting project config to Serverpod: $e');
      emit(state.copyWith(errorMessage: 'Failed to submit project: $e'));
      return false;
    } finally {
      emit(state.copyWith(isSubmitting: false));
    }
  }

  Map<String, dynamic> get finalPayload => state.config.toJson();
  Future<({List<String> questions, List<String> features})> analyzeRequirements(String? apiKey, Map<String, String>? answers) async {
    // Simulate AI analysis delay
    await Future.delayed(const Duration(seconds: 2));
    
    // In a real implementation, this would use the Gemini API to analyze the prompt and answers
    // and return dynamic questions and features.
    return (
      questions: [
        'Do you need offline support?',
        'Will there be user-generated content?'
      ],
      features: [
        'User Authentication',
        'Profile Management',
        'Cloud Sync'
      ]
    );
  }
}
