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

abstract class EnvironmentConfig
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  EnvironmentConfig._({
    required this.hasDev,
    required this.hasStaging,
    required this.hasProd,
    required this.bundleIdBase,
    required this.minIosVersion,
    required this.minAndroidSdk,
  });

  factory EnvironmentConfig({
    required bool hasDev,
    required bool hasStaging,
    required bool hasProd,
    required String bundleIdBase,
    required String minIosVersion,
    required int minAndroidSdk,
  }) = _EnvironmentConfigImpl;

  factory EnvironmentConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return EnvironmentConfig(
      hasDev: _i1.BoolJsonExtension.fromJson(jsonSerialization['hasDev']),
      hasStaging: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['hasStaging'],
      ),
      hasProd: _i1.BoolJsonExtension.fromJson(jsonSerialization['hasProd']),
      bundleIdBase: jsonSerialization['bundleIdBase'] as String,
      minIosVersion: jsonSerialization['minIosVersion'] as String,
      minAndroidSdk: jsonSerialization['minAndroidSdk'] as int,
    );
  }

  bool hasDev;

  bool hasStaging;

  bool hasProd;

  String bundleIdBase;

  String minIosVersion;

  int minAndroidSdk;

  /// Returns a shallow copy of this [EnvironmentConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EnvironmentConfig copyWith({
    bool? hasDev,
    bool? hasStaging,
    bool? hasProd,
    String? bundleIdBase,
    String? minIosVersion,
    int? minAndroidSdk,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EnvironmentConfig',
      'hasDev': hasDev,
      'hasStaging': hasStaging,
      'hasProd': hasProd,
      'bundleIdBase': bundleIdBase,
      'minIosVersion': minIosVersion,
      'minAndroidSdk': minAndroidSdk,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EnvironmentConfig',
      'hasDev': hasDev,
      'hasStaging': hasStaging,
      'hasProd': hasProd,
      'bundleIdBase': bundleIdBase,
      'minIosVersion': minIosVersion,
      'minAndroidSdk': minAndroidSdk,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _EnvironmentConfigImpl extends EnvironmentConfig {
  _EnvironmentConfigImpl({
    required bool hasDev,
    required bool hasStaging,
    required bool hasProd,
    required String bundleIdBase,
    required String minIosVersion,
    required int minAndroidSdk,
  }) : super._(
         hasDev: hasDev,
         hasStaging: hasStaging,
         hasProd: hasProd,
         bundleIdBase: bundleIdBase,
         minIosVersion: minIosVersion,
         minAndroidSdk: minAndroidSdk,
       );

  /// Returns a shallow copy of this [EnvironmentConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EnvironmentConfig copyWith({
    bool? hasDev,
    bool? hasStaging,
    bool? hasProd,
    String? bundleIdBase,
    String? minIosVersion,
    int? minAndroidSdk,
  }) {
    return EnvironmentConfig(
      hasDev: hasDev ?? this.hasDev,
      hasStaging: hasStaging ?? this.hasStaging,
      hasProd: hasProd ?? this.hasProd,
      bundleIdBase: bundleIdBase ?? this.bundleIdBase,
      minIosVersion: minIosVersion ?? this.minIosVersion,
      minAndroidSdk: minAndroidSdk ?? this.minAndroidSdk,
    );
  }
}
