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
import 'architecture_config.dart' as _i2;
import 'feature_layer.dart' as _i3;
import 'feature_node.dart' as _i4;
import 'figma_config.dart' as _i5;
import 'greetings/greeting.dart' as _i6;
import 'pipeline_command.dart' as _i7;
import 'pipeline_event.dart' as _i8;
import 'pipeline_phase.dart' as _i9;
import 'pipeline_state_message.dart' as _i10;
import 'postman_config.dart' as _i11;
import 'project_config.dart' as _i12;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i13;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i14;
export 'architecture_config.dart';
export 'feature_layer.dart';
export 'feature_node.dart';
export 'figma_config.dart';
export 'greetings/greeting.dart';
export 'pipeline_command.dart';
export 'pipeline_event.dart';
export 'pipeline_phase.dart';
export 'pipeline_state_message.dart';
export 'postman_config.dart';
export 'project_config.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.ArchitectureConfig) {
      return _i2.ArchitectureConfig.fromJson(data) as T;
    }
    if (t == _i3.FeatureLayer) {
      return _i3.FeatureLayer.fromJson(data) as T;
    }
    if (t == _i4.FeatureNode) {
      return _i4.FeatureNode.fromJson(data) as T;
    }
    if (t == _i5.FigmaConfig) {
      return _i5.FigmaConfig.fromJson(data) as T;
    }
    if (t == _i6.Greeting) {
      return _i6.Greeting.fromJson(data) as T;
    }
    if (t == _i7.PipelineCommand) {
      return _i7.PipelineCommand.fromJson(data) as T;
    }
    if (t == _i8.PipelineEvent) {
      return _i8.PipelineEvent.fromJson(data) as T;
    }
    if (t == _i9.PipelinePhase) {
      return _i9.PipelinePhase.fromJson(data) as T;
    }
    if (t == _i10.PipelineStateMessage) {
      return _i10.PipelineStateMessage.fromJson(data) as T;
    }
    if (t == _i11.PostmanConfig) {
      return _i11.PostmanConfig.fromJson(data) as T;
    }
    if (t == _i12.ProjectConfig) {
      return _i12.ProjectConfig.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.ArchitectureConfig?>()) {
      return (data != null ? _i2.ArchitectureConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.FeatureLayer?>()) {
      return (data != null ? _i3.FeatureLayer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.FeatureNode?>()) {
      return (data != null ? _i4.FeatureNode.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.FigmaConfig?>()) {
      return (data != null ? _i5.FigmaConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Greeting?>()) {
      return (data != null ? _i6.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.PipelineCommand?>()) {
      return (data != null ? _i7.PipelineCommand.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.PipelineEvent?>()) {
      return (data != null ? _i8.PipelineEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.PipelinePhase?>()) {
      return (data != null ? _i9.PipelinePhase.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.PipelineStateMessage?>()) {
      return (data != null ? _i10.PipelineStateMessage.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.PostmanConfig?>()) {
      return (data != null ? _i11.PostmanConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.ProjectConfig?>()) {
      return (data != null ? _i12.ProjectConfig.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i8.PipelineEvent>) {
      return (data as List)
              .map((e) => deserialize<_i8.PipelineEvent>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i4.FeatureNode>) {
      return (data as List).map((e) => deserialize<_i4.FeatureNode>(e)).toList()
          as T;
    }
    try {
      return _i13.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i14.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.ArchitectureConfig => 'ArchitectureConfig',
      _i3.FeatureLayer => 'FeatureLayer',
      _i4.FeatureNode => 'FeatureNode',
      _i5.FigmaConfig => 'FigmaConfig',
      _i6.Greeting => 'Greeting',
      _i7.PipelineCommand => 'PipelineCommand',
      _i8.PipelineEvent => 'PipelineEvent',
      _i9.PipelinePhase => 'PipelinePhase',
      _i10.PipelineStateMessage => 'PipelineStateMessage',
      _i11.PostmanConfig => 'PostmanConfig',
      _i12.ProjectConfig => 'ProjectConfig',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'flutterforge_backend.',
        '',
      );
    }

    switch (data) {
      case _i2.ArchitectureConfig():
        return 'ArchitectureConfig';
      case _i3.FeatureLayer():
        return 'FeatureLayer';
      case _i4.FeatureNode():
        return 'FeatureNode';
      case _i5.FigmaConfig():
        return 'FigmaConfig';
      case _i6.Greeting():
        return 'Greeting';
      case _i7.PipelineCommand():
        return 'PipelineCommand';
      case _i8.PipelineEvent():
        return 'PipelineEvent';
      case _i9.PipelinePhase():
        return 'PipelinePhase';
      case _i10.PipelineStateMessage():
        return 'PipelineStateMessage';
      case _i11.PostmanConfig():
        return 'PostmanConfig';
      case _i12.ProjectConfig():
        return 'ProjectConfig';
    }
    className = _i13.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i14.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'ArchitectureConfig') {
      return deserialize<_i2.ArchitectureConfig>(data['data']);
    }
    if (dataClassName == 'FeatureLayer') {
      return deserialize<_i3.FeatureLayer>(data['data']);
    }
    if (dataClassName == 'FeatureNode') {
      return deserialize<_i4.FeatureNode>(data['data']);
    }
    if (dataClassName == 'FigmaConfig') {
      return deserialize<_i5.FigmaConfig>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i6.Greeting>(data['data']);
    }
    if (dataClassName == 'PipelineCommand') {
      return deserialize<_i7.PipelineCommand>(data['data']);
    }
    if (dataClassName == 'PipelineEvent') {
      return deserialize<_i8.PipelineEvent>(data['data']);
    }
    if (dataClassName == 'PipelinePhase') {
      return deserialize<_i9.PipelinePhase>(data['data']);
    }
    if (dataClassName == 'PipelineStateMessage') {
      return deserialize<_i10.PipelineStateMessage>(data['data']);
    }
    if (dataClassName == 'PostmanConfig') {
      return deserialize<_i11.PostmanConfig>(data['data']);
    }
    if (dataClassName == 'ProjectConfig') {
      return deserialize<_i12.ProjectConfig>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i13.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i14.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i13.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i14.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
