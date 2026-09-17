import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'dart:async';

class PipelineEndpoint extends Endpoint {
  
  @override
  Future<void> streamOpened(StreamingSession session) async {
    session.log('Pipeline stream opened');
  }

  @override
  Future<void> handleStreamMessage(
    StreamingSession session,
    SerializableModel message,
  ) async {
    if (message is PipelineCommand) {
      session.log('Received start signal in stream, starting pipeline simulation...');
      // Start pipeline simulation in the background
      unawaited(_simulatePipeline(session, message.command));
    }
  }

  Future<void> _simulatePipeline(StreamingSession session, String projectName) async {
    List<PipelineEvent> logs = [];

    void sendState(PipelinePhase phase, double progress, {
      bool isAwaitingElicitation = false,
      String? question,
      String? context,
      List<String>? options,
      bool isComplete = false,
      String? preview,
    }) {
      final state = PipelineStateMessage(
        phase: phase,
        phaseProgress: progress,
        logs: logs,
        isAwaitingElicitation: isAwaitingElicitation,
        currentElicitationQuestion: question,
        elicitationContext: context,
        elicitationOptions: options,
        generatedPayloadPreview: preview,
        isComplete: isComplete,
      );
      sendStreamMessage(session, state);
    }

    void addLog(String message, {String level = 'info'}) {
      logs = [
        ...logs,
        PipelineEvent(message: message, level: level, timestamp: DateTime.now())
      ];
    }

    // Phase 1
    sendState(PipelinePhase.parsing, 0.0);
    addLog('Starting FlutterForge pipeline for project: $projectName');
    await Future.delayed(const Duration(milliseconds: 600));
    sendState(PipelinePhase.parsing, 0.2);
    addLog('Parsing Figma JSON file...');
    await Future.delayed(const Duration(milliseconds: 800));
    sendState(PipelinePhase.parsing, 1.0);
    addLog('Figma parsed successfully.', level: 'success');

    // Phase 2
    sendState(PipelinePhase.structureGen, 0.0);
    addLog('Generating Architecture structure...');
    await Future.delayed(const Duration(milliseconds: 800));
    addLog('Scaffolding features...');
    await Future.delayed(const Duration(milliseconds: 800));
    sendState(PipelinePhase.structureGen, 1.0);

    // Phase 3 - Elicitation
    addLog('Paused - Awaiting developer input', level: 'warning');
    sendState(PipelinePhase.elicitation, 0.0,
        isAwaitingElicitation: true,
        question: 'Detected WebSocket connection in Postman. Which transport?',
        context: 'Realtime events require a transport layer.',
        options: ['Standard WebSockets', 'Firebase', 'AWS IoT Core']);
    
    // We pause here in a real scenario, waiting for another stream message to answer it.
    // For this simulation, we'll just wait 5 seconds and auto-resume.
    await Future.delayed(const Duration(seconds: 5));
    
    addLog('Developer auto-selected: Standard WebSockets', level: 'success');
    sendState(PipelinePhase.elicitation, 1.0);
    
    // Phase 4
    sendState(PipelinePhase.llmGen, 0.0);
    addLog('Generating LLM logic blocks...');
    await Future.delayed(const Duration(seconds: 1));
    sendState(PipelinePhase.llmGen, 1.0);
    addLog('LLM generation complete', level: 'success');

    // Phase 5
    sendState(PipelinePhase.astMerge, 0.0);
    addLog('Validating and merging AST...');
    await Future.delayed(const Duration(seconds: 1));
    sendState(PipelinePhase.astMerge, 1.0);
    
    addLog('Pipeline Complete!', level: 'success');
    sendState(PipelinePhase.done, 1.0, isComplete: true, preview: 'lib/\n└── main.dart\n');
  }
}
