import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../models/project_config.dart';
import '../../models/feature_node.dart';
import 'wizard_state.dart';

class WizardCubit extends Cubit<WizardState> {
  WizardCubit()
      : super(WizardState(
          config: ProjectConfig(projectId: const Uuid().v4()),
        ));

  // ─── Navigation ───────────────────────────────────────────────────────────

  void nextStep() {
    final steps = WizardStep.values;
    final idx = state.stepIndex;
    if (idx < steps.length - 1) {
      emit(state.copyWith(
        currentStep: steps[idx + 1],
        clearError: true,
      ));
    }
  }

  void previousStep() {
    final steps = WizardStep.values;
    final idx = state.stepIndex;
    if (idx > 0) {
      emit(state.copyWith(
        currentStep: steps[idx - 1],
        clearError: true,
      ));
    }
  }

  void goToStep(WizardStep step) {
    emit(state.copyWith(currentStep: step, clearError: true));
  }

  // ─── Step 1: Identity ─────────────────────────────────────────────────────

  void updateIdentity({
    String? projectName,
    String? description,
    String? team,
    List<String>? platforms,
  }) {
    emit(state.copyWith(
      config: state.config.copyWith(
        projectName: projectName,
        description: description,
        team: team,
        platforms: platforms,
      ),
    ));
  }

  // ─── Step 2: Postman ──────────────────────────────────────────────────────

  void loadPostmanCollection(String jsonContent) {
    try {
      final decoded = json.decode(jsonContent) as Map<String, dynamic>;
      final collection = PostmanCollection.fromJson(decoded);
      emit(state.copyWith(
        config: state.config.copyWith(postmanCollection: collection),
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Invalid Postman collection: ${e.toString()}',
      ));
    }
  }

  void clearPostmanCollection() {
    emit(state.copyWith(
      config: state.config.copyWith(postmanCollection: null),
      clearError: true,
    ));
  }

  // ─── Step 3: Figma ────────────────────────────────────────────────────────

  void updateFigma({String? figmaFileUrl, String? figmaAccessToken}) {
    emit(state.copyWith(
      config: state.config.copyWith(
        figmaFileUrl: figmaFileUrl,
        figmaAccessToken: figmaAccessToken,
      ),
    ));
  }

  // ─── Step 4: Architecture ─────────────────────────────────────────────────

  void updateArchitecture(ArchitectureConfig architecture) {
    emit(state.copyWith(
      config: state.config.copyWith(architecture: architecture),
    ));
  }

  void updateArchitectureField({
    String? pattern,
    String? stateManagement,
    String? di,
    String? network,
    String? localStorage,
    String? navigation,
  }) {
    final current = state.config.architecture ??
        const ArchitectureConfig(
          pattern: 'clean_architecture',
          stateManagement: 'bloc',
          di: 'get_it',
          network: 'dio',
          localStorage: 'hive',
          navigation: 'go_router',
        );
    emit(state.copyWith(
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
    ));
  }

  // ─── Step 5: Features ─────────────────────────────────────────────────────

  void addFeature(FeatureNode feature) {
    final updated = [...state.config.features, feature];
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
        .map((f) => f.copyWith(
              dependencyIds: f.dependencyIds
                  .where((d) => d != featureId)
                  .toList(),
            ))
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
        .map((f) =>
            f.id == featureId ? f.copyWith(dependencyIds: newDeps) : f)
        .toList();
    _updateFeaturesWithCycleCheck(updated);
  }

  void _updateFeaturesWithCycleCheck(List<FeatureNode> features) {
    final cycles = DependencyGraphValidator.detectCycles(features);
    emit(state.copyWith(
      config: state.config.copyWith(features: features),
      cyclicDependencyWarnings: cycles,
    ));
  }

  // ─── Submit ───────────────────────────────────────────────────────────────

  Future<void> submitProject() async {
    emit(state.copyWith(isSubmitting: true));
    await Future.delayed(const Duration(milliseconds: 800));
    // The pipeline screen will handle navigation after receiving the config
    emit(state.copyWith(isSubmitting: false));
  }

  Map<String, dynamic> get finalPayload => state.config.toJson();
}
