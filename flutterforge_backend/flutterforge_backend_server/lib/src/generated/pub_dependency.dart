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

abstract class PubDependency
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PubDependency._({
    required this.id,
    required this.packageName,
    required this.pubDevUrl,
    this.version,
    this.featureId,
  });

  factory PubDependency({
    required String id,
    required String packageName,
    required String pubDevUrl,
    String? version,
    String? featureId,
  }) = _PubDependencyImpl;

  factory PubDependency.fromJson(Map<String, dynamic> jsonSerialization) {
    return PubDependency(
      id: jsonSerialization['id'] as String,
      packageName: jsonSerialization['packageName'] as String,
      pubDevUrl: jsonSerialization['pubDevUrl'] as String,
      version: jsonSerialization['version'] as String?,
      featureId: jsonSerialization['featureId'] as String?,
    );
  }

  String id;

  String packageName;

  String pubDevUrl;

  String? version;

  String? featureId;

  /// Returns a shallow copy of this [PubDependency]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PubDependency copyWith({
    String? id,
    String? packageName,
    String? pubDevUrl,
    String? version,
    String? featureId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PubDependency',
      'id': id,
      'packageName': packageName,
      'pubDevUrl': pubDevUrl,
      if (version != null) 'version': version,
      if (featureId != null) 'featureId': featureId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PubDependency',
      'id': id,
      'packageName': packageName,
      'pubDevUrl': pubDevUrl,
      if (version != null) 'version': version,
      if (featureId != null) 'featureId': featureId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PubDependencyImpl extends PubDependency {
  _PubDependencyImpl({
    required String id,
    required String packageName,
    required String pubDevUrl,
    String? version,
    String? featureId,
  }) : super._(
         id: id,
         packageName: packageName,
         pubDevUrl: pubDevUrl,
         version: version,
         featureId: featureId,
       );

  /// Returns a shallow copy of this [PubDependency]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PubDependency copyWith({
    String? id,
    String? packageName,
    String? pubDevUrl,
    Object? version = _Undefined,
    Object? featureId = _Undefined,
  }) {
    return PubDependency(
      id: id ?? this.id,
      packageName: packageName ?? this.packageName,
      pubDevUrl: pubDevUrl ?? this.pubDevUrl,
      version: version is String? ? version : this.version,
      featureId: featureId is String? ? featureId : this.featureId,
    );
  }
}
