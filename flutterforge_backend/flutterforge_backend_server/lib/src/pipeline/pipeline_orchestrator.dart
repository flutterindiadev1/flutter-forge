import 'dart:async';
import '../generated/protocol.dart';
import 'environment_checker.dart';
import 'scaffold_generator.dart';
import 'dependency_installer.dart';
import 'architecture_generator.dart';
import 'feature_generator.dart';
import 'github_pusher.dart';
import 'pubspec_patcher.dart';

class PipelineOrchestrator {
  final ProjectConfig config;
  final StreamIterator<PipelineCommand> commandIterator;
  
  PipelineOrchestrator({
    required this.config,
    required this.commandIterator,
  });

  Stream<PipelineStateMessage> run() async* {
    List<PipelineEvent> logs = [];

    PipelineStateMessage createState(PipelinePhase phase, double progress, {
      bool isAwaitingElicitation = false,
      String? question,
      String? context,
      List<String>? options,
      bool isComplete = false,
      String? preview,
    }) {
      return PipelineStateMessage(
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
    }

    void addLog(String message, {String level = 'info'}) {
      logs = [
        ...logs,
        PipelineEvent(message: message, level: level, timestamp: DateTime.now())
      ];
    }

    // Phase 0: Environment Check
    yield createState(PipelinePhase.parsing, 0.0);
    
    final envOk = await EnvironmentChecker.checkEnvironment((msg, {level = 'info'}) {
      addLog(msg, level: level);
    });
    
    // We yield the state again so logs are pushed
    yield createState(PipelinePhase.parsing, 0.1);

    if (!envOk) {
      addLog('Pipeline aborted due to missing prerequisites.', level: 'error');
      yield createState(PipelinePhase.failed, 1.0, isComplete: true);
      return;
    }

    // Phase 1: Scaffold
    yield createState(PipelinePhase.parsing, 0.2);
    
    final scaffoldGen = ScaffoldGenerator();
    bool scaffoldOk = false;
    
    await for (final event in scaffoldGen.generate(config)) {
      addLog(event.message, level: event.level);
      yield createState(PipelinePhase.parsing, 0.2 + (event.progress * 0.8));
      if (event.isError) {
        yield createState(PipelinePhase.failed, 1.0, isComplete: true);
        return;
      }
      if (event.progress >= 1.0) {
        scaffoldOk = true;
      }
    }

    if (!scaffoldOk) return;

    // Phase 1.5: Dependencies
    yield createState(PipelinePhase.parsing, 1.0); // Parsing & Scaffold complete
    
    // Dependencies logically happen after scaffold but before structure gen,
    // we'll run it here under structureGen phase initially.
    yield createState(PipelinePhase.structureGen, 0.0);
    
    final depInstaller = DependencyInstaller();
    bool depOk = false;
    
    await for (final event in depInstaller.install(config)) {
      addLog(event.message, level: event.level);
      yield createState(PipelinePhase.structureGen, (event.progress * 0.2));
      if (event.isError) {
        yield createState(PipelinePhase.failed, 1.0, isComplete: true);
        return;
      }
      if (event.progress >= 1.0) {
        depOk = true;
      }
    }

    if (!depOk) return;

    // Phase 1.8: Pubspec Patching
    final pubspecPatcher = PubspecPatcher();
    await for (final event in pubspecPatcher.patch(config)) {
      addLog(event.message, level: event.level);
      if (event.isError) {
        yield createState(PipelinePhase.failed, 1.0, isComplete: true);
        return;
      }
    }

    // Phase 2: Architecture Structure
    yield createState(PipelinePhase.structureGen, 0.0);
    final archGenerator = ArchitectureGenerator();
    bool archOk = false;

    await for (final event in archGenerator.generate(config)) {
      addLog(event.message, level: event.level);
      // We map the 0-1 progress of ArchitectureGenerator into the 0.2 - 1.0 range of this phase
      yield createState(PipelinePhase.structureGen, 0.2 + (event.progress * 0.8));
      if (event.isError) {
        yield createState(PipelinePhase.failed, 1.0, isComplete: true);
        return;
      }
      if (event.progress >= 1.0) {
        archOk = true;
      }
    }

    if (!archOk) return;

    // Phase 3: Feature LLM Generation
    yield createState(PipelinePhase.llmGen, 0.0);
    final featureGenerator = FeatureGenerator();
    bool featureOk = false;

    await for (final event in featureGenerator.generate(config, commandIterator)) {
      addLog(event.message, level: event.level);
      
      yield createState(
        PipelinePhase.llmGen, 
        event.progress,
        isAwaitingElicitation: event.isAwaitingElicitation,
        question: event.elicitationQuestion,
        context: event.elicitationContext,
      );
      
      if (event.isError) {
        yield createState(PipelinePhase.failed, 1.0, isComplete: true);
        return;
      }
      if (event.progress >= 1.0 && !event.isAwaitingElicitation) {
        featureOk = true;
      }
    }

    if (!featureOk) return;
    
    // Remaining mock phases for now
    yield createState(PipelinePhase.astMerge, 0.0);
    addLog('Validating and merging AST (mock)...');
    await Future.delayed(const Duration(milliseconds: 800));
    yield createState(PipelinePhase.astMerge, 1.0);

    // Phase 5: GitHub Push
    yield createState(PipelinePhase.astMerge, 0.0);
    final githubPusher = GithubPusher();
    bool githubOk = false;

    await for (final event in githubPusher.push(config)) {
      addLog(event.message, level: event.level);
      yield createState(PipelinePhase.astMerge, event.progress);
      if (event.isError) {
        // Warning: GitHub push failing shouldn't fail the whole pipeline as they can still download ZIP.
        // We just log it as an error and move on, but we don't abort generation.
        addLog('GitHub push failed, but project is generated.', level: 'warning');
        break;
      }
      if (event.progress >= 1.0) {
        githubOk = true;
      }
    }

    addLog('Pipeline Complete!', level: 'success');
    yield createState(PipelinePhase.done, 1.0, isComplete: true, preview: 'lib/\n└── main.dart\n');
  }
}
