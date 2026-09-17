import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/pipeline_event.dart';

export '../../models/pipeline_event.dart';


class PipelineCubit extends Cubit<PipelineState> {
  final String projectId;

  PipelineCubit({required this.projectId})
      : super(const PipelineState()) {
    _startPipeline();
  }

  void _log(String message, {String level = 'info'}) {
    final newLogs = [
      ...state.logs,
      PipelineEvent(
          message: message, level: level, timestamp: DateTime.now()),
    ];
    emit(state.copyWith(logs: newLogs));
  }

  Future<void> _startPipeline() async {
    // ── Phase 1: Parsing ──────────────────────────────────────────────────
    emit(state.copyWith(phase: PipelinePhase.parsing, phaseProgress: 0.0));
    _log('🔍 Starting FlutterForge pipeline for project: $projectId');
    await _tick(0.1); _log('📄 Parsing Figma JSON file...');
    await _tick(0.3); _log('✅ Figma file parsed — 12 frames, 47 components detected');
    await _tick(0.5); _log('📦 Parsing Postman Collection v2.1...');
    await _tick(0.7); _log('✅ 23 endpoints detected across 4 resource groups');
    await _tick(0.9); _log('🏗️  Building Abstract Syntax Tree from endpoint schemas...',
        level: 'info');
    await _tick(1.0); _log('✅ AST built — 12 DTO interfaces generated', level: 'success');

    // ── Phase 2: Structure Generation ────────────────────────────────────
    emit(state.copyWith(phase: PipelinePhase.structureGen, phaseProgress: 0.0));
    _log('📁 Generating Clean Architecture directory structure...');
    await _tick(0.2); _log('  → lib/features/auth/domain/entities/user.dart');
    await _tick(0.35); _log('  → lib/features/auth/data/datasources/auth_remote_ds.dart');
    await _tick(0.5); _log('  → lib/core/network/api_client.dart (Dio)');
    await _tick(0.65); _log('  → lib/core/di/injection.dart (GetIt)');
    await _tick(0.8); _log('🎨 Generating Dart DTOs from endpoint schemas...');
    await _tick(0.9); _log('  → UserResponseDto, ProductDto, CartItemDto (+9 more)');
    await _tick(1.0); _log('✅ Directory scaffold complete — 48 files generated', level: 'success');

    // ── Phase 3: Elicitation ─────────────────────────────────────────────
    emit(state.copyWith(
      phase: PipelinePhase.elicitation,
      phaseProgress: 0.0,
      isAwaitingElicitation: true,
      currentElicitationQuestion:
          'I detected WebSocket connections in 3 endpoints (/stream/notifications, /stream/orders, /stream/inventory). What real-time infrastructure are we targeting?',
      elicitationContext:
          '3 WebSocket endpoints detected — the generated BLoC event streams depend on the transport layer.',
      elicitationOptions: [
        'AWS IoT Core (MQTT over WebSocket)',
        'Standard WebSocket server (dart:io WebSocket)',
        'Firebase Realtime Database listeners',
        'Supabase Realtime (PostgreSQL logical replication)',
      ],
    ));
    _log('⏸️  Paused — awaiting developer input for elicitation phase', level: 'warning');
  }

  Future<void> answerElicitation(String answer) async {
    _log('💬 Developer answered: "$answer"', level: 'success');
    emit(state.copyWith(phaseProgress: 0.5, clearElicitation: true));
    _log('🔄 Continuing to next elicitation question...');
    await Future.delayed(const Duration(milliseconds: 800));

    // Second elicitation question
    emit(state.copyWith(
      isAwaitingElicitation: true,
      currentElicitationQuestion:
          'Should pagination state for the product listing be global (across all screens) or scoped to the Shop feature only?',
      elicitationContext:
          'Detected pagination in /products and /search endpoints. State scope affects BLoC provider placement.',
      elicitationOptions: [
        'Global — share state across the entire app',
        'Scoped — isolate to Shop feature BLoC only',
        'Both — global cache, scoped UI state',
      ],
    ));
    _log('⏸️  Second elicitation question queued', level: 'warning');
  }

  Future<void> answerSecondElicitation(String answer) async {
    _log('💬 Developer answered: "$answer"', level: 'success');
    emit(state.copyWith(
      phaseProgress: 1.0,
      clearElicitation: true,
      isAwaitingElicitation: false,
    ));

    await Future.delayed(const Duration(milliseconds: 600));
    _log('✅ Elicitation complete — context injected into LLM prompt', level: 'success');

    // ── Phase 4: LLM Generation ──────────────────────────────────────────
    emit(state.copyWith(phase: PipelinePhase.llmGen, phaseProgress: 0.0));
    _log('🤖 Constructing constrained LLM prompt...');
    _log('   → Injecting: AST interfaces + architecture rules + developer context');
    await _tick(0.15);
    _log('🔑 LLM generating business logic inside // custom-code-start blocks...');
    await _tick(0.35);
    _log('  → AuthRepository.signIn() — JWT refresh token logic');
    await _tick(0.5);
    _log('  → ProductRepository — offline-first caching with Hive fallback');
    await _tick(0.65);
    _log('  → OrderStreamBloc — AWS IoT Core MQTT event listener');
    await _tick(0.8);
    _log('  → CartBloc — optimistic UI with rollback on network failure');
    await _tick(0.9);
    _log('  → NotificationBloc — WebSocket reconnection with exponential backoff');
    await _tick(1.0);
    _log('✅ LLM generation complete — 18 implementation files written', level: 'success');

    // ── Phase 5: AST Merge & Validation ──────────────────────────────────
    emit(state.copyWith(phase: PipelinePhase.astMerge, phaseProgress: 0.0));
    _log('🔬 Parsing LLM output through Dart AST validator...');
    await _tick(0.2);
    _log('  → Checking interface contracts...');
    await _tick(0.4);
    _log('  → Validating import resolution...');
    await _tick(0.5);
    _log('⚠️  Hallucinated import detected: package:undefined_pkg — triggering self-correction',
        level: 'warning');
    await _tick(0.6);
    _log('🔄 LLM self-correction loop invoked...');
    await _tick(0.75);
    _log('✅ Import corrected → package:dio/dio.dart');
    await _tick(0.9);
    _log('🔀 Merging validated code into scaffold files...');
    await _tick(1.0);
    _log('✅ AST merge complete — all contracts satisfied', level: 'success');

    // ── Done ─────────────────────────────────────────────────────────────
    emit(state.copyWith(
      phase: PipelinePhase.done,
      phaseProgress: 1.0,
      isComplete: true,
      generatedPayloadPreview: _mockOutputTree,
    ));
    _log('🚀 FlutterForge generation complete! Your project is ready.', level: 'success');
  }

  Future<void> _tick(double progress) async {
    await Future.delayed(const Duration(milliseconds: 600));
    emit(state.copyWith(phaseProgress: progress));
  }

  static const _mockOutputTree = '''
my_ecommerce_app/
├── lib/
│   ├── core/
│   │   ├── di/injection.dart
│   │   ├── network/api_client.dart
│   │   └── utils/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── datasources/auth_remote_ds.dart
│   │   │   │   └── repositories/auth_repo_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/user.dart
│   │   │   │   └── repositories/auth_repository.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/auth_bloc.dart
│   │   │       └── screens/login_screen.dart
│   │   ├── shop/
│   │   │   ├── data/...
│   │   │   ├── domain/...
│   │   │   └── presentation/...
│   │   └── cart/...
│   └── main.dart
└── pubspec.yaml
''';
}
