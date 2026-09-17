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

abstract class FigmaConfig
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  FigmaConfig._({
    required this.fileUrl,
    required this.accessToken,
  });

  factory FigmaConfig({
    required String fileUrl,
    required String accessToken,
  }) = _FigmaConfigImpl;

  factory FigmaConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return FigmaConfig(
      fileUrl: jsonSerialization['fileUrl'] as String,
      accessToken: jsonSerialization['accessToken'] as String,
    );
  }

  String fileUrl;

  String accessToken;

  /// Returns a shallow copy of this [FigmaConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FigmaConfig copyWith({
    String? fileUrl,
    String? accessToken,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FigmaConfig',
      'fileUrl': fileUrl,
      'accessToken': accessToken,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FigmaConfig',
      'fileUrl': fileUrl,
      'accessToken': accessToken,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _FigmaConfigImpl extends FigmaConfig {
  _FigmaConfigImpl({
    required String fileUrl,
    required String accessToken,
  }) : super._(
         fileUrl: fileUrl,
         accessToken: accessToken,
       );

  /// Returns a shallow copy of this [FigmaConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FigmaConfig copyWith({
    String? fileUrl,
    String? accessToken,
  }) {
    return FigmaConfig(
      fileUrl: fileUrl ?? this.fileUrl,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}
