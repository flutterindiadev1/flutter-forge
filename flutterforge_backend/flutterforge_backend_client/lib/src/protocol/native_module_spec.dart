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
import 'package:flutterforge_backend_client/src/protocol/protocol.dart' as _i2;

abstract class NativeModuleSpec implements _i1.SerializableModel {
  NativeModuleSpec._({
    required this.id,
    required this.moduleName,
    required this.description,
    required this.platforms,
    this.featureId,
  });

  factory NativeModuleSpec({
    required String id,
    required String moduleName,
    required String description,
    required List<String> platforms,
    String? featureId,
  }) = _NativeModuleSpecImpl;

  factory NativeModuleSpec.fromJson(Map<String, dynamic> jsonSerialization) {
    return NativeModuleSpec(
      id: jsonSerialization['id'] as String,
      moduleName: jsonSerialization['moduleName'] as String,
      description: jsonSerialization['description'] as String,
      platforms: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['platforms'],
      ),
      featureId: jsonSerialization['featureId'] as String?,
    );
  }

  String id;

  String moduleName;

  String description;

  List<String> platforms;

  String? featureId;

  /// Returns a shallow copy of this [NativeModuleSpec]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NativeModuleSpec copyWith({
    String? id,
    String? moduleName,
    String? description,
    List<String>? platforms,
    String? featureId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NativeModuleSpec',
      'id': id,
      'moduleName': moduleName,
      'description': description,
      'platforms': platforms.toJson(),
      if (featureId != null) 'featureId': featureId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NativeModuleSpecImpl extends NativeModuleSpec {
  _NativeModuleSpecImpl({
    required String id,
    required String moduleName,
    required String description,
    required List<String> platforms,
    String? featureId,
  }) : super._(
         id: id,
         moduleName: moduleName,
         description: description,
         platforms: platforms,
         featureId: featureId,
       );

  /// Returns a shallow copy of this [NativeModuleSpec]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NativeModuleSpec copyWith({
    String? id,
    String? moduleName,
    String? description,
    List<String>? platforms,
    Object? featureId = _Undefined,
  }) {
    return NativeModuleSpec(
      id: id ?? this.id,
      moduleName: moduleName ?? this.moduleName,
      description: description ?? this.description,
      platforms: platforms ?? this.platforms.map((e0) => e0).toList(),
      featureId: featureId is String? ? featureId : this.featureId,
    );
  }
}
