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

abstract class PipelineEvent implements _i1.SerializableModel {
  PipelineEvent._({
    required this.message,
    required this.level,
    required this.timestamp,
  });

  factory PipelineEvent({
    required String message,
    required String level,
    required DateTime timestamp,
  }) = _PipelineEventImpl;

  factory PipelineEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return PipelineEvent(
      message: jsonSerialization['message'] as String,
      level: jsonSerialization['level'] as String,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
    );
  }

  String message;

  String level;

  DateTime timestamp;

  /// Returns a shallow copy of this [PipelineEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PipelineEvent copyWith({
    String? message,
    String? level,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PipelineEvent',
      'message': message,
      'level': level,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PipelineEventImpl extends PipelineEvent {
  _PipelineEventImpl({
    required String message,
    required String level,
    required DateTime timestamp,
  }) : super._(
         message: message,
         level: level,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [PipelineEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PipelineEvent copyWith({
    String? message,
    String? level,
    DateTime? timestamp,
  }) {
    return PipelineEvent(
      message: message ?? this.message,
      level: level ?? this.level,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
