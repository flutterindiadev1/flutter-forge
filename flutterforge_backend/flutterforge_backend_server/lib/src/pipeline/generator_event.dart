class GeneratorEvent {
  final String message;
  final String level;
  final double progress;
  final bool isError;
  final bool isAwaitingElicitation;
  final String? elicitationQuestion;
  final String? elicitationContext;

  GeneratorEvent({
    required this.message,
    this.level = 'info',
    this.progress = 0.0,
    this.isError = false,
    this.isAwaitingElicitation = false,
    this.elicitationQuestion,
    this.elicitationContext,
  });
}
