import 'dart:async';
import '../generated/protocol.dart';
import 'environment_checker.dart';
import 'scaffold_generator.dart';
import 'dependency_installer.dart';
import 'core_generator.dart';
import 'auth_generator.dart';
import 'onboarding_generator.dart';
import 'paywall_generator.dart';
import 'settings_generator.dart';
import 'feature_scaffolder.dart';
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
    yield createState(PipelinePhase.parsing, 1.0); 
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

    // Phase 2: Core Architecture
    yield createState(PipelinePhase.structureGen, 0.2);
    


    // Run CoreGenerator
    final coreGen = CoreGenerator();
    bool coreOk = false;
    await for (final event in coreGen.generate(config)) {
      addLog(event.message, level: event.level);
      yield createState(PipelinePhase.structureGen, 0.2 + (event.progress * 0.8));
      if (event.isError) {
        yield createState(PipelinePhase.failed, 1.0, isComplete: true);
        return;
      }
      if (event.progress >= 1.0) coreOk = true;
    }
    if (!coreOk) return;

    // Phase 3: Module Generation
    yield createState(PipelinePhase.structureGen, 0.0);
    
    // Auth
    final authGen = AuthGenerator();
    await for (final event in authGen.generate(config)) {
      addLog(event.message, level: event.level);
      yield createState(PipelinePhase.structureGen, event.progress * 0.2);
      if (event.isError) { yield createState(PipelinePhase.failed, 1.0, isComplete: true); return; }
    }
    
    // Onboarding
    final onboardingGen = OnboardingGenerator();
    await for (final event in onboardingGen.generate(config)) {
      addLog(event.message, level: event.level);
      yield createState(PipelinePhase.structureGen, 0.2 + (event.progress * 0.2));
      if (event.isError) { yield createState(PipelinePhase.failed, 1.0, isComplete: true); return; }
    }

    // Paywall
    final paywallGen = PaywallGenerator();
    await for (final event in paywallGen.generate(config)) {
      addLog(event.message, level: event.level);
      yield createState(PipelinePhase.structureGen, 0.4 + (event.progress * 0.2));
      if (event.isError) { yield createState(PipelinePhase.failed, 1.0, isComplete: true); return; }
    }
    
    // Settings
    final settingsGen = SettingsGenerator();
    await for (final event in settingsGen.generate(config)) {
      addLog(event.message, level: event.level);
      yield createState(PipelinePhase.structureGen, 0.6 + (event.progress * 0.2));
      if (event.isError) { yield createState(PipelinePhase.failed, 1.0, isComplete: true); return; }
    }
    
    // Custom Features
    final featureScaffolder = FeatureScaffolder();
    await for (final event in featureScaffolder.generate(config)) {
      addLog(event.message, level: event.level);
      yield createState(PipelinePhase.structureGen, 0.8 + (event.progress * 0.2));
      if (event.isError) { yield createState(PipelinePhase.failed, 1.0, isComplete: true); return; }
    }


    addLog('Pipeline Complete!', level: 'success');
    yield createState(PipelinePhase.done, 1.0, isComplete: true, preview: 'lib/\n└── main.dart\n');
  }
}
