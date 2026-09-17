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

abstract class PostmanConfig implements _i1.SerializableModel {
  PostmanConfig._({
    required this.collectionVersion,
    required this.name,
    required this.folderCount,
  });

  factory PostmanConfig({
    required String collectionVersion,
    required String name,
    required int folderCount,
  }) = _PostmanConfigImpl;

  factory PostmanConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return PostmanConfig(
      collectionVersion: jsonSerialization['collectionVersion'] as String,
      name: jsonSerialization['name'] as String,
      folderCount: jsonSerialization['folderCount'] as int,
    );
  }

  String collectionVersion;

  String name;

  int folderCount;

  /// Returns a shallow copy of this [PostmanConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PostmanConfig copyWith({
    String? collectionVersion,
    String? name,
    int? folderCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PostmanConfig',
      'collectionVersion': collectionVersion,
      'name': name,
      'folderCount': folderCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PostmanConfigImpl extends PostmanConfig {
  _PostmanConfigImpl({
    required String collectionVersion,
    required String name,
    required int folderCount,
  }) : super._(
         collectionVersion: collectionVersion,
         name: name,
         folderCount: folderCount,
       );

  /// Returns a shallow copy of this [PostmanConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PostmanConfig copyWith({
    String? collectionVersion,
    String? name,
    int? folderCount,
  }) {
    return PostmanConfig(
      collectionVersion: collectionVersion ?? this.collectionVersion,
      name: name ?? this.name,
      folderCount: folderCount ?? this.folderCount,
    );
  }
}
