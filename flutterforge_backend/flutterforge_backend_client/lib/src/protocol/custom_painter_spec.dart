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

abstract class CustomPainterSpec implements _i1.SerializableModel {
  CustomPainterSpec._({
    required this.id,
    required this.name,
    required this.description,
    this.featureId,
  });

  factory CustomPainterSpec({
    required String id,
    required String name,
    required String description,
    String? featureId,
  }) = _CustomPainterSpecImpl;

  factory CustomPainterSpec.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomPainterSpec(
      id: jsonSerialization['id'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      featureId: jsonSerialization['featureId'] as String?,
    );
  }

  String id;

  String name;

  String description;

  String? featureId;

  /// Returns a shallow copy of this [CustomPainterSpec]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CustomPainterSpec copyWith({
    String? id,
    String? name,
    String? description,
    String? featureId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomPainterSpec',
      'id': id,
      'name': name,
      'description': description,
      if (featureId != null) 'featureId': featureId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomPainterSpecImpl extends CustomPainterSpec {
  _CustomPainterSpecImpl({
    required String id,
    required String name,
    required String description,
    String? featureId,
  }) : super._(
         id: id,
         name: name,
         description: description,
         featureId: featureId,
       );

  /// Returns a shallow copy of this [CustomPainterSpec]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CustomPainterSpec copyWith({
    String? id,
    String? name,
    String? description,
    Object? featureId = _Undefined,
  }) {
    return CustomPainterSpec(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      featureId: featureId is String? ? featureId : this.featureId,
    );
  }
}
