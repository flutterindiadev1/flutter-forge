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
import 'feature_node.dart' as _i2;
import 'custom_painter_spec.dart' as _i3;
import 'native_module_spec.dart' as _i4;
import 'pub_dependency.dart' as _i5;
import 'asset_file.dart' as _i6;
import 'architecture_config.dart' as _i7;
import 'integration_config.dart' as _i8;
import 'environment_config.dart' as _i9;
import 'localization_config.dart' as _i10;
import 'monetization_config.dart' as _i11;
import 'testing_config.dart' as _i12;
import 'ci_cd_config.dart' as _i13;
import 'package:flutterforge_backend_server/src/generated/protocol.dart'
    as _i14;

abstract class ProjectConfig
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ProjectConfig._({
    this.projectId,
    required this.projectName,
    required this.description,
    required this.team,
    required this.platforms,
    this.templateId,
    required this.features,
    required this.customPainters,
    required this.nativeModules,
    required this.dependencies,
    this.figmaFileUrl,
    this.figmaAccessToken,
    this.appIcon,
    required this.assets,
    this.architecture,
    required this.integrations,
    required this.environment,
    required this.localization,
    this.monetization,
    required this.testing,
    required this.ciCd,
  });

  factory ProjectConfig({
    String? projectId,
    required String projectName,
    required String description,
    required String team,
    required List<String> platforms,
    String? templateId,
    required List<_i2.FeatureNode> features,
    required List<_i3.CustomPainterSpec> customPainters,
    required List<_i4.NativeModuleSpec> nativeModules,
    required List<_i5.PubDependency> dependencies,
    String? figmaFileUrl,
    String? figmaAccessToken,
    _i6.AssetFile? appIcon,
    required List<_i6.AssetFile> assets,
    _i7.ArchitectureConfig? architecture,
    required _i8.IntegrationConfig integrations,
    required _i9.EnvironmentConfig environment,
    required _i10.LocalizationConfig localization,
    _i11.MonetizationConfig? monetization,
    required _i12.TestingConfig testing,
    required _i13.CiCdConfig ciCd,
  }) = _ProjectConfigImpl;

  factory ProjectConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectConfig(
      projectId: jsonSerialization['projectId'] as String?,
      projectName: jsonSerialization['projectName'] as String,
      description: jsonSerialization['description'] as String,
      team: jsonSerialization['team'] as String,
      platforms: _i14.Protocol().deserialize<List<String>>(
        jsonSerialization['platforms'],
      ),
      templateId: jsonSerialization['templateId'] as String?,
      features: _i14.Protocol().deserialize<List<_i2.FeatureNode>>(
        jsonSerialization['features'],
      ),
      customPainters: _i14.Protocol().deserialize<List<_i3.CustomPainterSpec>>(
        jsonSerialization['customPainters'],
      ),
      nativeModules: _i14.Protocol().deserialize<List<_i4.NativeModuleSpec>>(
        jsonSerialization['nativeModules'],
      ),
      dependencies: _i14.Protocol().deserialize<List<_i5.PubDependency>>(
        jsonSerialization['dependencies'],
      ),
      figmaFileUrl: jsonSerialization['figmaFileUrl'] as String?,
      figmaAccessToken: jsonSerialization['figmaAccessToken'] as String?,
      appIcon: jsonSerialization['appIcon'] == null
          ? null
          : _i14.Protocol().deserialize<_i6.AssetFile>(
              jsonSerialization['appIcon'],
            ),
      assets: _i14.Protocol().deserialize<List<_i6.AssetFile>>(
        jsonSerialization['assets'],
      ),
      architecture: jsonSerialization['architecture'] == null
          ? null
          : _i14.Protocol().deserialize<_i7.ArchitectureConfig>(
              jsonSerialization['architecture'],
            ),
      integrations: _i14.Protocol().deserialize<_i8.IntegrationConfig>(
        jsonSerialization['integrations'],
      ),
      environment: _i14.Protocol().deserialize<_i9.EnvironmentConfig>(
        jsonSerialization['environment'],
      ),
      localization: _i14.Protocol().deserialize<_i10.LocalizationConfig>(
        jsonSerialization['localization'],
      ),
      monetization: jsonSerialization['monetization'] == null
          ? null
          : _i14.Protocol().deserialize<_i11.MonetizationConfig>(
              jsonSerialization['monetization'],
            ),
      testing: _i14.Protocol().deserialize<_i12.TestingConfig>(
        jsonSerialization['testing'],
      ),
      ciCd: _i14.Protocol().deserialize<_i13.CiCdConfig>(
        jsonSerialization['ciCd'],
      ),
    );
  }

  String? projectId;

  String projectName;

  String description;

  String team;

  List<String> platforms;

  String? templateId;

  List<_i2.FeatureNode> features;

  List<_i3.CustomPainterSpec> customPainters;

  List<_i4.NativeModuleSpec> nativeModules;

  List<_i5.PubDependency> dependencies;

  String? figmaFileUrl;

  String? figmaAccessToken;

  _i6.AssetFile? appIcon;

  List<_i6.AssetFile> assets;

  _i7.ArchitectureConfig? architecture;

  _i8.IntegrationConfig integrations;

  _i9.EnvironmentConfig environment;

  _i10.LocalizationConfig localization;

  _i11.MonetizationConfig? monetization;

  _i12.TestingConfig testing;

  _i13.CiCdConfig ciCd;

  /// Returns a shallow copy of this [ProjectConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectConfig copyWith({
    String? projectId,
    String? projectName,
    String? description,
    String? team,
    List<String>? platforms,
    String? templateId,
    List<_i2.FeatureNode>? features,
    List<_i3.CustomPainterSpec>? customPainters,
    List<_i4.NativeModuleSpec>? nativeModules,
    List<_i5.PubDependency>? dependencies,
    String? figmaFileUrl,
    String? figmaAccessToken,
    _i6.AssetFile? appIcon,
    List<_i6.AssetFile>? assets,
    _i7.ArchitectureConfig? architecture,
    _i8.IntegrationConfig? integrations,
    _i9.EnvironmentConfig? environment,
    _i10.LocalizationConfig? localization,
    _i11.MonetizationConfig? monetization,
    _i12.TestingConfig? testing,
    _i13.CiCdConfig? ciCd,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectConfig',
      if (projectId != null) 'projectId': projectId,
      'projectName': projectName,
      'description': description,
      'team': team,
      'platforms': platforms.toJson(),
      if (templateId != null) 'templateId': templateId,
      'features': features.toJson(valueToJson: (v) => v.toJson()),
      'customPainters': customPainters.toJson(valueToJson: (v) => v.toJson()),
      'nativeModules': nativeModules.toJson(valueToJson: (v) => v.toJson()),
      'dependencies': dependencies.toJson(valueToJson: (v) => v.toJson()),
      if (figmaFileUrl != null) 'figmaFileUrl': figmaFileUrl,
      if (figmaAccessToken != null) 'figmaAccessToken': figmaAccessToken,
      if (appIcon != null) 'appIcon': appIcon?.toJson(),
      'assets': assets.toJson(valueToJson: (v) => v.toJson()),
      if (architecture != null) 'architecture': architecture?.toJson(),
      'integrations': integrations.toJson(),
      'environment': environment.toJson(),
      'localization': localization.toJson(),
      if (monetization != null) 'monetization': monetization?.toJson(),
      'testing': testing.toJson(),
      'ciCd': ciCd.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectConfig',
      if (projectId != null) 'projectId': projectId,
      'projectName': projectName,
      'description': description,
      'team': team,
      'platforms': platforms.toJson(),
      if (templateId != null) 'templateId': templateId,
      'features': features.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'customPainters': customPainters.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'nativeModules': nativeModules.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'dependencies': dependencies.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      if (figmaFileUrl != null) 'figmaFileUrl': figmaFileUrl,
      if (figmaAccessToken != null) 'figmaAccessToken': figmaAccessToken,
      if (appIcon != null) 'appIcon': appIcon?.toJsonForProtocol(),
      'assets': assets.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (architecture != null)
        'architecture': architecture?.toJsonForProtocol(),
      'integrations': integrations.toJsonForProtocol(),
      'environment': environment.toJsonForProtocol(),
      'localization': localization.toJsonForProtocol(),
      if (monetization != null)
        'monetization': monetization?.toJsonForProtocol(),
      'testing': testing.toJsonForProtocol(),
      'ciCd': ciCd.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectConfigImpl extends ProjectConfig {
  _ProjectConfigImpl({
    String? projectId,
    required String projectName,
    required String description,
    required String team,
    required List<String> platforms,
    String? templateId,
    required List<_i2.FeatureNode> features,
    required List<_i3.CustomPainterSpec> customPainters,
    required List<_i4.NativeModuleSpec> nativeModules,
    required List<_i5.PubDependency> dependencies,
    String? figmaFileUrl,
    String? figmaAccessToken,
    _i6.AssetFile? appIcon,
    required List<_i6.AssetFile> assets,
    _i7.ArchitectureConfig? architecture,
    required _i8.IntegrationConfig integrations,
    required _i9.EnvironmentConfig environment,
    required _i10.LocalizationConfig localization,
    _i11.MonetizationConfig? monetization,
    required _i12.TestingConfig testing,
    required _i13.CiCdConfig ciCd,
  }) : super._(
         projectId: projectId,
         projectName: projectName,
         description: description,
         team: team,
         platforms: platforms,
         templateId: templateId,
         features: features,
         customPainters: customPainters,
         nativeModules: nativeModules,
         dependencies: dependencies,
         figmaFileUrl: figmaFileUrl,
         figmaAccessToken: figmaAccessToken,
         appIcon: appIcon,
         assets: assets,
         architecture: architecture,
         integrations: integrations,
         environment: environment,
         localization: localization,
         monetization: monetization,
         testing: testing,
         ciCd: ciCd,
       );

  /// Returns a shallow copy of this [ProjectConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProjectConfig copyWith({
    Object? projectId = _Undefined,
    String? projectName,
    String? description,
    String? team,
    List<String>? platforms,
    Object? templateId = _Undefined,
    List<_i2.FeatureNode>? features,
    List<_i3.CustomPainterSpec>? customPainters,
    List<_i4.NativeModuleSpec>? nativeModules,
    List<_i5.PubDependency>? dependencies,
    Object? figmaFileUrl = _Undefined,
    Object? figmaAccessToken = _Undefined,
    Object? appIcon = _Undefined,
    List<_i6.AssetFile>? assets,
    Object? architecture = _Undefined,
    _i8.IntegrationConfig? integrations,
    _i9.EnvironmentConfig? environment,
    _i10.LocalizationConfig? localization,
    Object? monetization = _Undefined,
    _i12.TestingConfig? testing,
    _i13.CiCdConfig? ciCd,
  }) {
    return ProjectConfig(
      projectId: projectId is String? ? projectId : this.projectId,
      projectName: projectName ?? this.projectName,
      description: description ?? this.description,
      team: team ?? this.team,
      platforms: platforms ?? this.platforms.map((e0) => e0).toList(),
      templateId: templateId is String? ? templateId : this.templateId,
      features: features ?? this.features.map((e0) => e0.copyWith()).toList(),
      customPainters:
          customPainters ??
          this.customPainters.map((e0) => e0.copyWith()).toList(),
      nativeModules:
          nativeModules ??
          this.nativeModules.map((e0) => e0.copyWith()).toList(),
      dependencies:
          dependencies ?? this.dependencies.map((e0) => e0.copyWith()).toList(),
      figmaFileUrl: figmaFileUrl is String? ? figmaFileUrl : this.figmaFileUrl,
      figmaAccessToken: figmaAccessToken is String?
          ? figmaAccessToken
          : this.figmaAccessToken,
      appIcon: appIcon is _i6.AssetFile? ? appIcon : this.appIcon?.copyWith(),
      assets: assets ?? this.assets.map((e0) => e0.copyWith()).toList(),
      architecture: architecture is _i7.ArchitectureConfig?
          ? architecture
          : this.architecture?.copyWith(),
      integrations: integrations ?? this.integrations.copyWith(),
      environment: environment ?? this.environment.copyWith(),
      localization: localization ?? this.localization.copyWith(),
      monetization: monetization is _i11.MonetizationConfig?
          ? monetization
          : this.monetization?.copyWith(),
      testing: testing ?? this.testing.copyWith(),
      ciCd: ciCd ?? this.ciCd.copyWith(),
    );
  }
}
