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

import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class PipelineCommand implements _i1.SerializableModel {
  PipelineCommand._({
    required this.command,
    this.payload,
  });

  factory PipelineCommand({
    required String command,
    String? payload,
  }) = _PipelineCommandImpl;

  factory PipelineCommand.fromJson(Map<String, dynamic> jsonSerialization) {
    return PipelineCommand(
      command: jsonSerialization['command'] as String,
      payload: jsonSerialization['payload'] as String?,
    );
  }

  String command;

  String? payload;

  /// Returns a shallow copy of this [PipelineCommand]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PipelineCommand copyWith({
    String? command,
    String? payload,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PipelineCommand',
      'command': command,
      if (payload != null) 'payload': payload,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PipelineCommandImpl extends PipelineCommand {
  _PipelineCommandImpl({
    required String command,
    String? payload,
  }) : super._(
         command: command,
         payload: payload,
       );

  /// Returns a shallow copy of this [PipelineCommand]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PipelineCommand copyWith({
    String? command,
    Object? payload = _Undefined,
  }) {
    return PipelineCommand(
      command: command ?? this.command,
      payload: payload is String? ? payload : this.payload,
    );
  }
}
