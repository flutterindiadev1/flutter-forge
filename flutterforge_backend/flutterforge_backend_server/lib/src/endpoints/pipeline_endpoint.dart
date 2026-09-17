import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'dart:async';
import 'dart:convert';
import '../pipeline/pipeline_orchestrator.dart';

class PipelineEndpoint extends Endpoint {
  
  Stream<PipelineStateMessage> startPipeline(Session session, Stream<PipelineCommand> commandStream) async* {
    session.log('Pipeline stream opened');
    
    final iterator = StreamIterator(commandStream);

    // We expect the first command to be the project name (which is the projectId)
    if (!await iterator.moveNext()) return;
    final projectId = iterator.current.command;

    final record = await ProjectRecord.db.findFirstRow(
      session,
      where: (t) => t.projectId.equals(projectId),
    );

    if (record == null) {
      session.log('Project record not found for id: $projectId', level: LogLevel.error);
      return;
    }

    final projectConfig = ProjectConfig.fromJson(jsonDecode(record.configJson));
    session.log('Starting pipeline for project: ${projectConfig.projectName}');
    
    final orchestrator = PipelineOrchestrator(
      config: projectConfig,
      commandIterator: iterator,
    );

    bool hasError = false;
    await for (final state in orchestrator.run()) {
      yield state;
      if (state.phase == PipelinePhase.failed) {
        hasError = true;
      }
    }

    if (hasError) {
      record.status = 'failed';
    } else {
      record.status = 'ready';
    }
    
    await ProjectRecord.db.updateRow(session, record);
  }
}
