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

abstract class LlmInstruction
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  LlmInstruction._({
    required this.id,
    required this.instruction,
    this.featureId,
  });

  factory LlmInstruction({
    required String id,
    required String instruction,
    String? featureId,
  }) = _LlmInstructionImpl;

  factory LlmInstruction.fromJson(Map<String, dynamic> jsonSerialization) {
    return LlmInstruction(
      id: jsonSerialization['id'] as String,
      instruction: jsonSerialization['instruction'] as String,
      featureId: jsonSerialization['featureId'] as String?,
    );
  }

  String id;

  String instruction;

  String? featureId;

  /// Returns a shallow copy of this [LlmInstruction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LlmInstruction copyWith({
    String? id,
    String? instruction,
    String? featureId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LlmInstruction',
      'id': id,
      'instruction': instruction,
      if (featureId != null) 'featureId': featureId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LlmInstruction',
      'id': id,
      'instruction': instruction,
      if (featureId != null) 'featureId': featureId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LlmInstructionImpl extends LlmInstruction {
  _LlmInstructionImpl({
    required String id,
    required String instruction,
    String? featureId,
  }) : super._(
         id: id,
         instruction: instruction,
         featureId: featureId,
       );

  /// Returns a shallow copy of this [LlmInstruction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LlmInstruction copyWith({
    String? id,
    String? instruction,
    Object? featureId = _Undefined,
  }) {
    return LlmInstruction(
      id: id ?? this.id,
      instruction: instruction ?? this.instruction,
      featureId: featureId is String? ? featureId : this.featureId,
    );
  }
}
