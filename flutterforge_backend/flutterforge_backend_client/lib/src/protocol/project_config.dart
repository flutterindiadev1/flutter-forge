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
import 'user_persona.dart' as _i2;
import 'feature_node.dart' as _i3;
import 'custom_painter_spec.dart' as _i4;
import 'native_module_spec.dart' as _i5;
import 'pub_dependency.dart' as _i6;
import 'llm_instruction.dart' as _i7;
import 'design_source.dart' as _i8;
import 'ai_design_brief.dart' as _i9;
import 'asset_file.dart' as _i10;
import 'architecture_config.dart' as _i11;
import 'integration_config.dart' as _i12;
import 'environment_config.dart' as _i13;
import 'localization_config.dart' as _i14;
import 'monetization_config.dart' as _i15;
import 'testing_config.dart' as _i16;
import 'ci_cd_config.dart' as _i17;
import 'postman_config.dart' as _i18;
import 'package:flutterforge_backend_client/src/protocol/protocol.dart' as _i19;

abstract class ProjectConfig implements _i1.SerializableModel {
  ProjectConfig._({
    this.projectId,
    required this.projectName,
    required this.description,
    required this.team,
    required this.platforms,
    required this.geminiApiKey,
    required this.inspiredBy,
    this.persona,
    this.templateId,
    required this.features,
    required this.customPainters,
    required this.nativeModules,
    required this.dependencies,
    required this.llmInstructions,
    required this.designSource,
    this.aiDesignBrief,
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
    this.postmanCollection,
    this.githubToken,
  });

  factory ProjectConfig({
    String? projectId,
    required String projectName,
    required String description,
    required String team,
    required List<String> platforms,
    required String geminiApiKey,
    required String inspiredBy,
    _i2.UserPersona? persona,
    String? templateId,
    required List<_i3.FeatureNode> features,
    required List<_i4.CustomPainterSpec> customPainters,
    required List<_i5.NativeModuleSpec> nativeModules,
    required List<_i6.PubDependency> dependencies,
    required List<_i7.LlmInstruction> llmInstructions,
    required _i8.DesignSource designSource,
    _i9.AiDesignBrief? aiDesignBrief,
    String? figmaFileUrl,
    String? figmaAccessToken,
    _i10.AssetFile? appIcon,
    required List<_i10.AssetFile> assets,
    _i11.ArchitectureConfig? architecture,
    required _i12.IntegrationConfig integrations,
    required _i13.EnvironmentConfig environment,
    required _i14.LocalizationConfig localization,
    _i15.MonetizationConfig? monetization,
    required _i16.TestingConfig testing,
    required _i17.CiCdConfig ciCd,
    _i18.PostmanConfig? postmanCollection,
    String? githubToken,
  }) = _ProjectConfigImpl;

  factory ProjectConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectConfig(
      projectId: jsonSerialization['projectId'] as String?,
      projectName: jsonSerialization['projectName'] as String,
      description: jsonSerialization['description'] as String,
      team: jsonSerialization['team'] as String,
      platforms: _i19.Protocol().deserialize<List<String>>(
        jsonSerialization['platforms'],
      ),
      geminiApiKey: jsonSerialization['geminiApiKey'] as String,
      inspiredBy: jsonSerialization['inspiredBy'] as String,
      persona: jsonSerialization['persona'] == null
          ? null
          : _i19.Protocol().deserialize<_i2.UserPersona>(
              jsonSerialization['persona'],
            ),
      templateId: jsonSerialization['templateId'] as String?,
      features: _i19.Protocol().deserialize<List<_i3.FeatureNode>>(
        jsonSerialization['features'],
      ),
      customPainters: _i19.Protocol().deserialize<List<_i4.CustomPainterSpec>>(
        jsonSerialization['customPainters'],
      ),
      nativeModules: _i19.Protocol().deserialize<List<_i5.NativeModuleSpec>>(
        jsonSerialization['nativeModules'],
      ),
      dependencies: _i19.Protocol().deserialize<List<_i6.PubDependency>>(
        jsonSerialization['dependencies'],
      ),
      llmInstructions: _i19.Protocol().deserialize<List<_i7.LlmInstruction>>(
        jsonSerialization['llmInstructions'],
      ),
      designSource: _i8.DesignSource.fromJson(
        (jsonSerialization['designSource'] as String),
      ),
      aiDesignBrief: jsonSerialization['aiDesignBrief'] == null
          ? null
          : _i19.Protocol().deserialize<_i9.AiDesignBrief>(
              jsonSerialization['aiDesignBrief'],
            ),
      figmaFileUrl: jsonSerialization['figmaFileUrl'] as String?,
      figmaAccessToken: jsonSerialization['figmaAccessToken'] as String?,
      appIcon: jsonSerialization['appIcon'] == null
          ? null
          : _i19.Protocol().deserialize<_i10.AssetFile>(
              jsonSerialization['appIcon'],
            ),
      assets: _i19.Protocol().deserialize<List<_i10.AssetFile>>(
        jsonSerialization['assets'],
      ),
      architecture: jsonSerialization['architecture'] == null
          ? null
          : _i19.Protocol().deserialize<_i11.ArchitectureConfig>(
              jsonSerialization['architecture'],
            ),
      integrations: _i19.Protocol().deserialize<_i12.IntegrationConfig>(
        jsonSerialization['integrations'],
      ),
      environment: _i19.Protocol().deserialize<_i13.EnvironmentConfig>(
        jsonSerialization['environment'],
      ),
      localization: _i19.Protocol().deserialize<_i14.LocalizationConfig>(
        jsonSerialization['localization'],
      ),
      monetization: jsonSerialization['monetization'] == null
          ? null
          : _i19.Protocol().deserialize<_i15.MonetizationConfig>(
              jsonSerialization['monetization'],
            ),
      testing: _i19.Protocol().deserialize<_i16.TestingConfig>(
        jsonSerialization['testing'],
      ),
      ciCd: _i19.Protocol().deserialize<_i17.CiCdConfig>(
        jsonSerialization['ciCd'],
      ),
      postmanCollection: jsonSerialization['postmanCollection'] == null
          ? null
          : _i19.Protocol().deserialize<_i18.PostmanConfig>(
              jsonSerialization['postmanCollection'],
            ),
      githubToken: jsonSerialization['githubToken'] as String?,
    );
  }

  String? projectId;

  String projectName;

  String description;

  String team;

  List<String> platforms;

  String geminiApiKey;

  String inspiredBy;

  _i2.UserPersona? persona;

  String? templateId;

  List<_i3.FeatureNode> features;

  List<_i4.CustomPainterSpec> customPainters;

  List<_i5.NativeModuleSpec> nativeModules;

  List<_i6.PubDependency> dependencies;

  List<_i7.LlmInstruction> llmInstructions;

  _i8.DesignSource designSource;

  _i9.AiDesignBrief? aiDesignBrief;

  String? figmaFileUrl;

  String? figmaAccessToken;

  _i10.AssetFile? appIcon;

  List<_i10.AssetFile> assets;

  _i11.ArchitectureConfig? architecture;

  _i12.IntegrationConfig integrations;

  _i13.EnvironmentConfig environment;

  _i14.LocalizationConfig localization;

  _i15.MonetizationConfig? monetization;

  _i16.TestingConfig testing;

  _i17.CiCdConfig ciCd;

  _i18.PostmanConfig? postmanCollection;

  String? githubToken;

  /// Returns a shallow copy of this [ProjectConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectConfig copyWith({
    String? projectId,
    String? projectName,
    String? description,
    String? team,
    List<String>? platforms,
    String? geminiApiKey,
    String? inspiredBy,
    _i2.UserPersona? persona,
    String? templateId,
    List<_i3.FeatureNode>? features,
    List<_i4.CustomPainterSpec>? customPainters,
    List<_i5.NativeModuleSpec>? nativeModules,
    List<_i6.PubDependency>? dependencies,
    List<_i7.LlmInstruction>? llmInstructions,
    _i8.DesignSource? designSource,
    _i9.AiDesignBrief? aiDesignBrief,
    String? figmaFileUrl,
    String? figmaAccessToken,
    _i10.AssetFile? appIcon,
    List<_i10.AssetFile>? assets,
    _i11.ArchitectureConfig? architecture,
    _i12.IntegrationConfig? integrations,
    _i13.EnvironmentConfig? environment,
    _i14.LocalizationConfig? localization,
    _i15.MonetizationConfig? monetization,
    _i16.TestingConfig? testing,
    _i17.CiCdConfig? ciCd,
    _i18.PostmanConfig? postmanCollection,
    String? githubToken,
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
      'geminiApiKey': geminiApiKey,
      'inspiredBy': inspiredBy,
      if (persona != null) 'persona': persona?.toJson(),
      if (templateId != null) 'templateId': templateId,
      'features': features.toJson(valueToJson: (v) => v.toJson()),
      'customPainters': customPainters.toJson(valueToJson: (v) => v.toJson()),
      'nativeModules': nativeModules.toJson(valueToJson: (v) => v.toJson()),
      'dependencies': dependencies.toJson(valueToJson: (v) => v.toJson()),
      'llmInstructions': llmInstructions.toJson(valueToJson: (v) => v.toJson()),
      'designSource': designSource.toJson(),
      if (aiDesignBrief != null) 'aiDesignBrief': aiDesignBrief?.toJson(),
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
      if (postmanCollection != null)
        'postmanCollection': postmanCollection?.toJson(),
      if (githubToken != null) 'githubToken': githubToken,
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
    required String geminiApiKey,
    required String inspiredBy,
    _i2.UserPersona? persona,
    String? templateId,
    required List<_i3.FeatureNode> features,
    required List<_i4.CustomPainterSpec> customPainters,
    required List<_i5.NativeModuleSpec> nativeModules,
    required List<_i6.PubDependency> dependencies,
    required List<_i7.LlmInstruction> llmInstructions,
    required _i8.DesignSource designSource,
    _i9.AiDesignBrief? aiDesignBrief,
    String? figmaFileUrl,
    String? figmaAccessToken,
    _i10.AssetFile? appIcon,
    required List<_i10.AssetFile> assets,
    _i11.ArchitectureConfig? architecture,
    required _i12.IntegrationConfig integrations,
    required _i13.EnvironmentConfig environment,
    required _i14.LocalizationConfig localization,
    _i15.MonetizationConfig? monetization,
    required _i16.TestingConfig testing,
    required _i17.CiCdConfig ciCd,
    _i18.PostmanConfig? postmanCollection,
    String? githubToken,
  }) : super._(
         projectId: projectId,
         projectName: projectName,
         description: description,
         team: team,
         platforms: platforms,
         geminiApiKey: geminiApiKey,
         inspiredBy: inspiredBy,
         persona: persona,
         templateId: templateId,
         features: features,
         customPainters: customPainters,
         nativeModules: nativeModules,
         dependencies: dependencies,
         llmInstructions: llmInstructions,
         designSource: designSource,
         aiDesignBrief: aiDesignBrief,
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
         postmanCollection: postmanCollection,
         githubToken: githubToken,
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
    String? geminiApiKey,
    String? inspiredBy,
    Object? persona = _Undefined,
    Object? templateId = _Undefined,
    List<_i3.FeatureNode>? features,
    List<_i4.CustomPainterSpec>? customPainters,
    List<_i5.NativeModuleSpec>? nativeModules,
    List<_i6.PubDependency>? dependencies,
    List<_i7.LlmInstruction>? llmInstructions,
    _i8.DesignSource? designSource,
    Object? aiDesignBrief = _Undefined,
    Object? figmaFileUrl = _Undefined,
    Object? figmaAccessToken = _Undefined,
    Object? appIcon = _Undefined,
    List<_i10.AssetFile>? assets,
    Object? architecture = _Undefined,
    _i12.IntegrationConfig? integrations,
    _i13.EnvironmentConfig? environment,
    _i14.LocalizationConfig? localization,
    Object? monetization = _Undefined,
    _i16.TestingConfig? testing,
    _i17.CiCdConfig? ciCd,
    Object? postmanCollection = _Undefined,
    Object? githubToken = _Undefined,
  }) {
    return ProjectConfig(
      projectId: projectId is String? ? projectId : this.projectId,
      projectName: projectName ?? this.projectName,
      description: description ?? this.description,
      team: team ?? this.team,
      platforms: platforms ?? this.platforms.map((e0) => e0).toList(),
      geminiApiKey: geminiApiKey ?? this.geminiApiKey,
      inspiredBy: inspiredBy ?? this.inspiredBy,
      persona: persona is _i2.UserPersona? ? persona : this.persona?.copyWith(),
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
      llmInstructions:
          llmInstructions ??
          this.llmInstructions.map((e0) => e0.copyWith()).toList(),
      designSource: designSource ?? this.designSource,
      aiDesignBrief: aiDesignBrief is _i9.AiDesignBrief?
          ? aiDesignBrief
          : this.aiDesignBrief?.copyWith(),
      figmaFileUrl: figmaFileUrl is String? ? figmaFileUrl : this.figmaFileUrl,
      figmaAccessToken: figmaAccessToken is String?
          ? figmaAccessToken
          : this.figmaAccessToken,
      appIcon: appIcon is _i10.AssetFile? ? appIcon : this.appIcon?.copyWith(),
      assets: assets ?? this.assets.map((e0) => e0.copyWith()).toList(),
      architecture: architecture is _i11.ArchitectureConfig?
          ? architecture
          : this.architecture?.copyWith(),
      integrations: integrations ?? this.integrations.copyWith(),
      environment: environment ?? this.environment.copyWith(),
      localization: localization ?? this.localization.copyWith(),
      monetization: monetization is _i15.MonetizationConfig?
          ? monetization
          : this.monetization?.copyWith(),
      testing: testing ?? this.testing.copyWith(),
      ciCd: ciCd ?? this.ciCd.copyWith(),
      postmanCollection: postmanCollection is _i18.PostmanConfig?
          ? postmanCollection
          : this.postmanCollection?.copyWith(),
      githubToken: githubToken is String? ? githubToken : this.githubToken,
    );
  }
}
