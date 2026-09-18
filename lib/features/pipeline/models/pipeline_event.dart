import 'package:equatable/equatable.dart';

enum PipelinePhase { parsing, structureGen, elicitation, done, failed }

class PipelineEvent extends Equatable {
  final String message;
  final String level; // info | success | warning | error
  final DateTime timestamp;

  const PipelineEvent({
    required this.message,
    required this.level,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [message, timestamp];
}

class PipelineState extends Equatable {
  final String? projectId;
  final PipelinePhase phase;
  final double phaseProgress; // 0.0 - 1.0
  final List<PipelineEvent> logs;
  final bool isAwaitingElicitation;
  final String? currentElicitationQuestion;
  final String? elicitationContext;
  final List<String>? elicitationOptions;
  final String? generatedPayloadPreview;
  final bool isComplete;

  const PipelineState({
    this.projectId,
    this.phase = PipelinePhase.parsing,
    this.phaseProgress = 0.0,
    this.logs = const [],
    this.isAwaitingElicitation = false,
    this.currentElicitationQuestion,
    this.elicitationContext,
    this.elicitationOptions,
    this.generatedPayloadPreview,
    this.isComplete = false,
  });

  PipelineState copyWith({
    String? projectId,
    PipelinePhase? phase,
    double? phaseProgress,
    List<PipelineEvent>? logs,
    bool? isAwaitingElicitation,
    String? currentElicitationQuestion,
    String? elicitationContext,
    List<String>? elicitationOptions,
    String? generatedPayloadPreview,
    bool? isComplete,
    bool clearElicitation = false,
  }) {
    return PipelineState(
      projectId: projectId ?? this.projectId,
      phase: phase ?? this.phase,
      phaseProgress: phaseProgress ?? this.phaseProgress,
      logs: logs ?? this.logs,
      isAwaitingElicitation: clearElicitation
          ? false
          : (isAwaitingElicitation ?? this.isAwaitingElicitation),
      currentElicitationQuestion: clearElicitation
          ? null
          : (currentElicitationQuestion ?? this.currentElicitationQuestion),
      elicitationContext: clearElicitation
          ? null
          : (elicitationContext ?? this.elicitationContext),
      elicitationOptions: clearElicitation
          ? null
          : (elicitationOptions ?? this.elicitationOptions),
      generatedPayloadPreview:
          generatedPayloadPreview ?? this.generatedPayloadPreview,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  @override
  List<Object?> get props => [projectId, phase, phaseProgress, logs, isAwaitingElicitation, isComplete];
}
