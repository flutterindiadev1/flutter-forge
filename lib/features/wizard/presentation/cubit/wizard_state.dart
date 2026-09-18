import 'package:equatable/equatable.dart';
import '../../models/project_config.dart';

enum AiAnalysisStatus { idle, running, done, failed }

class WizardState extends Equatable {
  final WizardStep currentStep;
  final ProjectConfig config;
  final bool isSubmitting;
  final String? errorMessage;
  final List<String> cyclicDependencyWarnings;
  final AiAnalysisStatus aiAnalysisStatus;
  final String? aiAnalysisError;
  final bool apiKeySaved;
  final bool githubTokenSaved;
  final bool isEditingExisting;

  const WizardState({
    this.currentStep = WizardStep.identity,
    this.config = const ProjectConfig(),
    this.isSubmitting = false,
    this.errorMessage,
    this.cyclicDependencyWarnings = const [],
    this.aiAnalysisStatus = AiAnalysisStatus.idle,
    this.aiAnalysisError,
    this.apiKeySaved = false,
    this.githubTokenSaved = false,
    this.isEditingExisting = false,
  });

  int get stepIndex => WizardStep.values.indexOf(currentStep);
  bool get isFirstStep => currentStep == WizardStep.values.first;
  bool get isLastStep => currentStep == WizardStep.values.last;

  WizardState copyWith({
    WizardStep? currentStep,
    ProjectConfig? config,
    bool? isSubmitting,
    String? errorMessage,
    List<String>? cyclicDependencyWarnings,
    AiAnalysisStatus? aiAnalysisStatus,
    String? aiAnalysisError,
    bool? apiKeySaved,
    bool? githubTokenSaved,
    bool? isEditingExisting,
    bool clearError = false,
  }) {
    return WizardState(
      currentStep: currentStep ?? this.currentStep,
      config: config ?? this.config,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      cyclicDependencyWarnings:
          cyclicDependencyWarnings ?? this.cyclicDependencyWarnings,
      aiAnalysisStatus: aiAnalysisStatus ?? this.aiAnalysisStatus,
      aiAnalysisError: clearError ? null : (aiAnalysisError ?? this.aiAnalysisError),
      apiKeySaved: apiKeySaved ?? this.apiKeySaved,
      githubTokenSaved: githubTokenSaved ?? this.githubTokenSaved,
      isEditingExisting: isEditingExisting ?? this.isEditingExisting,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        config,
        isSubmitting,
        errorMessage,
        cyclicDependencyWarnings,
        aiAnalysisStatus,
        aiAnalysisError,
        apiKeySaved,
        githubTokenSaved,
        isEditingExisting,
      ];
}
