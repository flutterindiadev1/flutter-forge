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

abstract class AssetFile implements _i1.SerializableModel {
  AssetFile._({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
    required this.sizeBytes,
  });

  factory AssetFile({
    required String id,
    required String name,
    required String type,
    required String url,
    required int sizeBytes,
  }) = _AssetFileImpl;

  factory AssetFile.fromJson(Map<String, dynamic> jsonSerialization) {
    return AssetFile(
      id: jsonSerialization['id'] as String,
      name: jsonSerialization['name'] as String,
      type: jsonSerialization['type'] as String,
      url: jsonSerialization['url'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
    );
  }

  String id;

  String name;

  String type;

  String url;

  int sizeBytes;

  /// Returns a shallow copy of this [AssetFile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AssetFile copyWith({
    String? id,
    String? name,
    String? type,
    String? url,
    int? sizeBytes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AssetFile',
      'id': id,
      'name': name,
      'type': type,
      'url': url,
      'sizeBytes': sizeBytes,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AssetFileImpl extends AssetFile {
  _AssetFileImpl({
    required String id,
    required String name,
    required String type,
    required String url,
    required int sizeBytes,
  }) : super._(
         id: id,
         name: name,
         type: type,
         url: url,
         sizeBytes: sizeBytes,
       );

  /// Returns a shallow copy of this [AssetFile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AssetFile copyWith({
    String? id,
    String? name,
    String? type,
    String? url,
    int? sizeBytes,
  }) {
    return AssetFile(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      url: url ?? this.url,
      sizeBytes: sizeBytes ?? this.sizeBytes,
    );
  }
}
