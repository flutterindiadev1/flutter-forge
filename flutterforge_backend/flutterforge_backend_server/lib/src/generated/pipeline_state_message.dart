/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod/serverpod.dart' as _i1;
import 'pipeline_phase.dart' as _i2;
import 'pipeline_event.dart' as _i3;
import 'package:flutterforge_backend_server/src/generated/protocol.dart' as _i4;

abstract class PipelineStateMessage
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PipelineStateMessage._({
    required this.phase,
    required this.phaseProgress,
    required this.logs,
    required this.isAwaitingElicitation,
    this.currentElicitationQuestion,
    this.elicitationContext,
    this.elicitationOptions,
    this.generatedPayloadPreview,
    required this.isComplete,
  });

  factory PipelineStateMessage({
    required _i2.PipelinePhase phase,
    required double phaseProgress,
    required List<_i3.PipelineEvent> logs,
    required bool isAwaitingElicitation,
    String? currentElicitationQuestion,
    String? elicitationContext,
    List<String>? elicitationOptions,
    String? generatedPayloadPreview,
    required bool isComplete,
  }) = _PipelineStateMessageImpl;

  factory PipelineStateMessage.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PipelineStateMessage(
      phase: _i2.PipelinePhase.fromJson((jsonSerialization['phase'] as String)),
      phaseProgress: (jsonSerialization['phaseProgress'] as num).toDouble(),
      logs: _i4.Protocol().deserialize<List<_i3.PipelineEvent>>(
        jsonSerialization['logs'],
      ),
      isAwaitingElicitation: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isAwaitingElicitation'],
      ),
      currentElicitationQuestion:
          jsonSerialization['currentElicitationQuestion'] as String?,
      elicitationContext: jsonSerialization['elicitationContext'] as String?,
      elicitationOptions: jsonSerialization['elicitationOptions'] == null
          ? null
          : _i4.Protocol().deserialize<List<String>>(
              jsonSerialization['elicitationOptions'],
            ),
      generatedPayloadPreview:
          jsonSerialization['generatedPayloadPreview'] as String?,
      isComplete: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isComplete'],
      ),
    );
  }

  _i2.PipelinePhase phase;

  double phaseProgress;

  List<_i3.PipelineEvent> logs;

  bool isAwaitingElicitation;

  String? currentElicitationQuestion;

  String? elicitationContext;

  List<String>? elicitationOptions;

  String? generatedPayloadPreview;

  bool isComplete;

  /// Returns a shallow copy of this [PipelineStateMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PipelineStateMessage copyWith({
    _i2.PipelinePhase? phase,
    double? phaseProgress,
    List<_i3.PipelineEvent>? logs,
    bool? isAwaitingElicitation,
    String? currentElicitationQuestion,
    String? elicitationContext,
    List<String>? elicitationOptions,
    String? generatedPayloadPreview,
    bool? isComplete,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PipelineStateMessage',
      'phase': phase.toJson(),
      'phaseProgress': phaseProgress,
      'logs': logs.toJson(valueToJson: (v) => v.toJson()),
      'isAwaitingElicitation': isAwaitingElicitation,
      if (currentElicitationQuestion != null)
        'currentElicitationQuestion': currentElicitationQuestion,
      if (elicitationContext != null) 'elicitationContext': elicitationContext,
      if (elicitationOptions != null)
        'elicitationOptions': elicitationOptions?.toJson(),
      if (generatedPayloadPreview != null)
        'generatedPayloadPreview': generatedPayloadPreview,
      'isComplete': isComplete,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PipelineStateMessage',
      'phase': phase.toJson(),
      'phaseProgress': phaseProgress,
      'logs': logs.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'isAwaitingElicitation': isAwaitingElicitation,
      if (currentElicitationQuestion != null)
        'currentElicitationQuestion': currentElicitationQuestion,
      if (elicitationContext != null) 'elicitationContext': elicitationContext,
      if (elicitationOptions != null)
        'elicitationOptions': elicitationOptions?.toJson(),
      if (generatedPayloadPreview != null)
        'generatedPayloadPreview': generatedPayloadPreview,
      'isComplete': isComplete,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PipelineStateMessageImpl extends PipelineStateMessage {
  _PipelineStateMessageImpl({
    required _i2.PipelinePhase phase,
    required double phaseProgress,
    required List<_i3.PipelineEvent> logs,
    required bool isAwaitingElicitation,
    String? currentElicitationQuestion,
    String? elicitationContext,
    List<String>? elicitationOptions,
    String? generatedPayloadPreview,
    required bool isComplete,
  }) : super._(
         phase: phase,
         phaseProgress: phaseProgress,
         logs: logs,
         isAwaitingElicitation: isAwaitingElicitation,
         currentElicitationQuestion: currentElicitationQuestion,
         elicitationContext: elicitationContext,
         elicitationOptions: elicitationOptions,
         generatedPayloadPreview: generatedPayloadPreview,
         isComplete: isComplete,
       );

  /// Returns a shallow copy of this [PipelineStateMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PipelineStateMessage copyWith({
    _i2.PipelinePhase? phase,
    double? phaseProgress,
    List<_i3.PipelineEvent>? logs,
    bool? isAwaitingElicitation,
    Object? currentElicitationQuestion = _Undefined,
    Object? elicitationContext = _Undefined,
    Object? elicitationOptions = _Undefined,
    Object? generatedPayloadPreview = _Undefined,
    bool? isComplete,
  }) {
    return PipelineStateMessage(
      phase: phase ?? this.phase,
      phaseProgress: phaseProgress ?? this.phaseProgress,
      logs: logs ?? this.logs.map((e0) => e0.copyWith()).toList(),
      isAwaitingElicitation:
          isAwaitingElicitation ?? this.isAwaitingElicitation,
      currentElicitationQuestion: currentElicitationQuestion is String?
          ? currentElicitationQuestion
          : this.currentElicitationQuestion,
      elicitationContext: elicitationContext is String?
          ? elicitationContext
          : this.elicitationContext,
      elicitationOptions: elicitationOptions is List<String>?
          ? elicitationOptions
          : this.elicitationOptions?.map((e0) => e0).toList(),
      generatedPayloadPreview: generatedPayloadPreview is String?
          ? generatedPayloadPreview
          : this.generatedPayloadPreview,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
