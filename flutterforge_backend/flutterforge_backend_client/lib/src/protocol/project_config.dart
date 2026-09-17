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
import 'figma_config.dart' as _i2;
import 'postman_config.dart' as _i3;
import 'architecture_config.dart' as _i4;
import 'feature_node.dart' as _i5;
import 'package:flutterforge_backend_client/src/protocol/protocol.dart' as _i6;

abstract class ProjectConfig implements _i1.SerializableModel {
  ProjectConfig._({
    required this.projectId,
    required this.projectName,
    required this.platforms,
    this.figma,
    this.postman,
    this.architecture,
    required this.features,
  });

  factory ProjectConfig({
    required String projectId,
    required String projectName,
    required List<String> platforms,
    _i2.FigmaConfig? figma,
    _i3.PostmanConfig? postman,
    _i4.ArchitectureConfig? architecture,
    required List<_i5.FeatureNode> features,
  }) = _ProjectConfigImpl;

  factory ProjectConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectConfig(
      projectId: jsonSerialization['projectId'] as String,
      projectName: jsonSerialization['projectName'] as String,
      platforms: _i6.Protocol().deserialize<List<String>>(
        jsonSerialization['platforms'],
      ),
      figma: jsonSerialization['figma'] == null
          ? null
          : _i6.Protocol().deserialize<_i2.FigmaConfig>(
              jsonSerialization['figma'],
            ),
      postman: jsonSerialization['postman'] == null
          ? null
          : _i6.Protocol().deserialize<_i3.PostmanConfig>(
              jsonSerialization['postman'],
            ),
      architecture: jsonSerialization['architecture'] == null
          ? null
          : _i6.Protocol().deserialize<_i4.ArchitectureConfig>(
              jsonSerialization['architecture'],
            ),
      features: _i6.Protocol().deserialize<List<_i5.FeatureNode>>(
        jsonSerialization['features'],
      ),
    );
  }

  String projectId;

  String projectName;

  List<String> platforms;

  _i2.FigmaConfig? figma;

  _i3.PostmanConfig? postman;

  _i4.ArchitectureConfig? architecture;

  List<_i5.FeatureNode> features;

  /// Returns a shallow copy of this [ProjectConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectConfig copyWith({
    String? projectId,
    String? projectName,
    List<String>? platforms,
    _i2.FigmaConfig? figma,
    _i3.PostmanConfig? postman,
    _i4.ArchitectureConfig? architecture,
    List<_i5.FeatureNode>? features,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectConfig',
      'projectId': projectId,
      'projectName': projectName,
      'platforms': platforms.toJson(),
      if (figma != null) 'figma': figma?.toJson(),
      if (postman != null) 'postman': postman?.toJson(),
      if (architecture != null) 'architecture': architecture?.toJson(),
      'features': features.toJson(valueToJson: (v) => v.toJson()),
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
    required String projectId,
    required String projectName,
    required List<String> platforms,
    _i2.FigmaConfig? figma,
    _i3.PostmanConfig? postman,
    _i4.ArchitectureConfig? architecture,
    required List<_i5.FeatureNode> features,
  }) : super._(
         projectId: projectId,
         projectName: projectName,
         platforms: platforms,
         figma: figma,
         postman: postman,
         architecture: architecture,
         features: features,
       );

  /// Returns a shallow copy of this [ProjectConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProjectConfig copyWith({
    String? projectId,
    String? projectName,
    List<String>? platforms,
    Object? figma = _Undefined,
    Object? postman = _Undefined,
    Object? architecture = _Undefined,
    List<_i5.FeatureNode>? features,
  }) {
    return ProjectConfig(
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      platforms: platforms ?? this.platforms.map((e0) => e0).toList(),
      figma: figma is _i2.FigmaConfig? ? figma : this.figma?.copyWith(),
      postman: postman is _i3.PostmanConfig?
          ? postman
          : this.postman?.copyWith(),
      architecture: architecture is _i4.ArchitectureConfig?
          ? architecture
          : this.architecture?.copyWith(),
      features: features ?? this.features.map((e0) => e0.copyWith()).toList(),
    );
  }
}
