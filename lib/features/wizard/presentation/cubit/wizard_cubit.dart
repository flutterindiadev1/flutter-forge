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

class WizardCubit extends Cubit<WizardState> {
  WizardCubit()
    : super(WizardState(config: ProjectConfig(projectId: const Uuid().v4())));

  void reset({String? templateId}) {
    final tId = templateId ?? 'Blank Canvas';
    String projectName = '';
    String description = '';

    if (tId == 'E-Commerce') {
      projectName = 'E-Commerce App';
      description =
          'A fully-featured e-commerce platform with Cart, Payments, and Product Catalog features.';
    } else if (tId == 'Social Media') {
      projectName = 'Social Network';
      description =
          'A social networking app including Feeds, Profiles, and Chat functionality.';
    } else if (tId == 'SaaS Dashboard') {
      projectName = 'Admin Portal';
      description = 'Admin panels, charts, and user management ready to go.';
    }

    emit(
      WizardState(
        config: ProjectConfig(
          projectId: const Uuid().v4(),
          templateId: tId,
          projectName: projectName,
          description: description,
        ),
      ),
    );
  }

  void loadExistingProject(ProjectConfig existingConfig) {
    emit(
      WizardState(
        config: existingConfig,
        isEditingExisting: true,
        aiAnalysisStatus: AiAnalysisStatus.idle,
      ),
    );
  }



  // ─── Navigation ───────────────────────────────────────────────────────────

  void nextStep() {
    final steps = WizardStep.values;
    final idx = state.stepIndex;
    if (idx < steps.length - 1) {
      emit(state.copyWith(currentStep: steps[idx + 1], clearError: true));
      if (steps[idx] == WizardStep.identity) {
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
          environment: team != null 
              ? state.config.environment.copyWith(bundleIdBase: team)
              : state.config.environment,
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
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      final local = state.config;
      final spConfig = sp.ProjectConfig(
        projectId: local.projectId ?? 'pending',
        projectName: local.projectName,
        description: local.description,
        team: local.team,
        platforms: local.platforms,

        templateId: local.templateId,
        features: local.features
            .map(
              (f) => sp.FeatureNode(
                nodeId: f.id,
                name: f.name,
                layer: sp.FeatureLayer.values.firstWhere(
                  (e) => e.name == f.layer.name,
                  orElse: () => sp.FeatureLayer.shared,
                ),
                dependencyIds: f.dependencyIds,
              ),
            )
            .toList(),
        nativeModules: local.nativeModules
            .map(
              (m) => sp.NativeModuleSpec(
                id: m.id,
                moduleName: m.moduleName,
                description: m.description,
                platforms: m.platforms,
                featureId: m.featureId,
              ),
            )
            .toList(),
        customPainters: local.customPainters
            .map(
              (p) => sp.CustomPainterSpec(
                id: p.id,
                name: p.name,
                description: p.description,
                featureId: p.featureId,
              ),
            )
            .toList(),
        dependencies: local.dependencies
            .map(
              (d) => sp.PubDependency(
                id: d.id,
                packageName: d.packageName,
                pubDevUrl: d.pubDevUrl,
                version: d.version,
              ),
            )
            .toList(),

        figmaFileUrl: local.figmaFileUrl,
        figmaAccessToken: local.figmaAccessToken,
        appIcon: local.appIcon != null
            ? sp.AssetFile(
                id: local.appIcon!.id,
                name: local.appIcon!.name,
                type: local.appIcon!.type,
                url: local.appIcon!.url,
                sizeBytes: local.appIcon!.sizeBytes,
              )
            : null,
        assets: local.assets
            .map(
              (a) => sp.AssetFile(
                id: a.id,
                name: a.name,
                type: a.type,
                url: a.url,
                sizeBytes: a.sizeBytes,
              ),
            )
            .toList(),
        architecture: local.architecture != null
            ? sp.ArchitectureConfig(
                pattern: local.architecture!.pattern,
                stateManagement: local.architecture!.stateManagement,
                di: local.architecture!.di,
                network: local.architecture!.network,
                localStorage: local.architecture!.localStorage,
                navigation: local.architecture!.navigation,
              )
            : null,
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
        monetization: local.monetization != null
            ? sp.MonetizationConfig(
                model: sp.MonetizationModel.values.firstWhere(
                  (e) => e.name == local.monetization!.model.name,
                  orElse: () => sp.MonetizationModel.free,
                ),
                provider: local.monetization!.provider != null
                    ? sp.SubscriptionProvider.values.firstWhere(
                        (e) => e.name == local.monetization!.provider!.name,
                        orElse: () => sp.SubscriptionProvider.revenueCat,
                      )
                    : null,
                plans: local.monetization!.plans,
              )
            : null,
        testing: sp.TestingConfig(
          generateUnitTests: local.testing.generateUnitTests,
          generateWidgetTests: local.testing.generateWidgetTests,
          generateIntegrationTests: local.testing.generateIntegrationTests,
          coverageTarget: local.testing.coverageTarget,
        ),
        ciCd: sp.CiCdConfig(
          platform: sp.CiCdPlatform.values.firstWhere(
            (e) => e.name == local.ciCd.platform.name,
            orElse: () => sp.CiCdPlatform.none,
          ),
          runTestsOnPr: local.ciCd.runTestsOnPr,
          deployToFirebaseAppDistribution:
              local.ciCd.deployToFirebaseAppDistribution,
          deployToStores: local.ciCd.deployToStores,
          notifySlack: local.ciCd.notifySlack,
        ),

      );

      if (state.isEditingExisting) {
        await client.project.updateProjectConfig(state.config.projectId!, spConfig);
      } else {
        final generatedId = await client.project.submitConfig(spConfig);
        // Update local state with the backend-generated ID
        emit(
          state.copyWith(config: state.config.copyWith(projectId: generatedId)),
        );
      }
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
}
