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
import 'cicd_platform.dart' as _i2;

abstract class CiCdConfig implements _i1.SerializableModel {
  CiCdConfig._({
    required this.platform,
    required this.runTestsOnPr,
    required this.deployToFirebaseAppDistribution,
    required this.deployToStores,
    required this.notifySlack,
  });

  factory CiCdConfig({
    required _i2.CiCdPlatform platform,
    required bool runTestsOnPr,
    required bool deployToFirebaseAppDistribution,
    required bool deployToStores,
    required bool notifySlack,
  }) = _CiCdConfigImpl;

  factory CiCdConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return CiCdConfig(
      platform: _i2.CiCdPlatform.fromJson(
        (jsonSerialization['platform'] as String),
      ),
      runTestsOnPr: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['runTestsOnPr'],
      ),
      deployToFirebaseAppDistribution: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['deployToFirebaseAppDistribution'],
      ),
      deployToStores: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['deployToStores'],
      ),
      notifySlack: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['notifySlack'],
      ),
    );
  }

  _i2.CiCdPlatform platform;

  bool runTestsOnPr;

  bool deployToFirebaseAppDistribution;

  bool deployToStores;

  bool notifySlack;

  /// Returns a shallow copy of this [CiCdConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CiCdConfig copyWith({
    _i2.CiCdPlatform? platform,
    bool? runTestsOnPr,
    bool? deployToFirebaseAppDistribution,
    bool? deployToStores,
    bool? notifySlack,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CiCdConfig',
      'platform': platform.toJson(),
      'runTestsOnPr': runTestsOnPr,
      'deployToFirebaseAppDistribution': deployToFirebaseAppDistribution,
      'deployToStores': deployToStores,
      'notifySlack': notifySlack,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CiCdConfigImpl extends CiCdConfig {
  _CiCdConfigImpl({
    required _i2.CiCdPlatform platform,
    required bool runTestsOnPr,
    required bool deployToFirebaseAppDistribution,
    required bool deployToStores,
    required bool notifySlack,
  }) : super._(
         platform: platform,
         runTestsOnPr: runTestsOnPr,
         deployToFirebaseAppDistribution: deployToFirebaseAppDistribution,
         deployToStores: deployToStores,
         notifySlack: notifySlack,
       );

  /// Returns a shallow copy of this [CiCdConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CiCdConfig copyWith({
    _i2.CiCdPlatform? platform,
    bool? runTestsOnPr,
    bool? deployToFirebaseAppDistribution,
    bool? deployToStores,
    bool? notifySlack,
  }) {
    return CiCdConfig(
      platform: platform ?? this.platform,
      runTestsOnPr: runTestsOnPr ?? this.runTestsOnPr,
      deployToFirebaseAppDistribution:
          deployToFirebaseAppDistribution ??
          this.deployToFirebaseAppDistribution,
      deployToStores: deployToStores ?? this.deployToStores,
      notifySlack: notifySlack ?? this.notifySlack,
    );
  }
}
