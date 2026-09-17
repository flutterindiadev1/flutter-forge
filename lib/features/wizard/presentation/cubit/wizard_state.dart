import 'package:equatable/equatable.dart';
import '../../models/project_config.dart';
import '../../models/feature_node.dart';


enum WizardStep { identity, postman, figma, architecture, features }

class WizardState extends Equatable {
  final WizardStep currentStep;
  final ProjectConfig config;
  final bool isSubmitting;
  final String? errorMessage;
  final List<String> cyclicDependencyWarnings;

  const WizardState({
    this.currentStep = WizardStep.identity,
    this.config = const ProjectConfig(),
    this.isSubmitting = false,
    this.errorMessage,
    this.cyclicDependencyWarnings = const [],
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
    bool clearError = false,
  }) {
    return WizardState(
      currentStep: currentStep ?? this.currentStep,
      config: config ?? this.config,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      cyclicDependencyWarnings:
          cyclicDependencyWarnings ?? this.cyclicDependencyWarnings,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        config,
        isSubmitting,
        errorMessage,
        cyclicDependencyWarnings,
      ];
}
