import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/pipeline_event.dart';
import '../../../../core/network/api_client.dart';
import 'package:flutterforge_backend_client/flutterforge_backend_client.dart' as sp;

export '../../models/pipeline_event.dart';

class PipelineCubit extends Cubit<PipelineState> {
  final String projectId;
  StreamSubscription? _subscription;
  final StreamController<sp.PipelineCommand> _commandStreamController = StreamController<sp.PipelineCommand>.broadcast();

  PipelineCubit({required this.projectId})
      : super(const PipelineState()) {
    _startPipeline();
  }

  Future<void> _startPipeline() async {
    try {
      final responseStream = client.pipeline.startPipeline(_commandStreamController.stream);

      _subscription = responseStream.listen((message) {
        final newPhase = PipelinePhase.values.firstWhere(
          (e) => e.name == message.phase.name,
          orElse: () => PipelinePhase.parsing,
        );

        final newLogs = message.logs.map((e) => PipelineEvent(
          message: e.message,
          level: e.level,
          timestamp: e.timestamp,
        )).toList();

        emit(state.copyWith(
          phase: newPhase,
          phaseProgress: message.phaseProgress,
          logs: newLogs,
          isAwaitingElicitation: message.isAwaitingElicitation,
          currentElicitationQuestion: message.currentElicitationQuestion,
          elicitationContext: message.elicitationContext,
          elicitationOptions: message.elicitationOptions,
          generatedPayloadPreview: message.generatedPayloadPreview,
          isComplete: message.isComplete,
          clearElicitation: !message.isAwaitingElicitation,
        ));
      });

      // Wait for the websocket connection to establish before sending the first command
      await Future.delayed(const Duration(milliseconds: 500));
      _commandStreamController.add(sp.PipelineCommand(command: projectId));
      
    } catch (e) {
      _log('Error connecting to Serverpod: $e', level: 'error');
    }
  }

  void _log(String message, {String level = 'info'}) {
    final newLogs = [
      ...state.logs,
      PipelineEvent(message: message, level: level, timestamp: DateTime.now()),
    ];
    emit(state.copyWith(logs: newLogs));
  }

  void submitElicitationAnswer(String answer) {
    emit(state.copyWith(
      clearElicitation: true,
      phaseProgress: 1.0,
      isAwaitingElicitation: false,
    ));
    _log('User selected: $answer', level: 'info');
    _commandStreamController.add(sp.PipelineCommand(command: answer));
  }
  
  // Backward compatibility for existing UI calls
  void answerElicitation(String answer) {
    submitElicitationAnswer(answer);
  }
  
  void answerSecondElicitation(String answer) {
    submitElicitationAnswer(answer);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _commandStreamController.close();
    return super.close();
  }
}
