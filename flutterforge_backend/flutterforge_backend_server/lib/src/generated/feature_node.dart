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
import 'feature_layer.dart' as _i2;
import 'package:flutterforge_backend_server/src/generated/protocol.dart' as _i3;

abstract class FeatureNode
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  FeatureNode._({
    required this.nodeId,
    required this.name,
    required this.layer,
    required this.dependencyIds,
  });

  factory FeatureNode({
    required String nodeId,
    required String name,
    required _i2.FeatureLayer layer,
    required List<String> dependencyIds,
  }) = _FeatureNodeImpl;

  factory FeatureNode.fromJson(Map<String, dynamic> jsonSerialization) {
    return FeatureNode(
      nodeId: jsonSerialization['nodeId'] as String,
      name: jsonSerialization['name'] as String,
      layer: _i2.FeatureLayer.fromJson((jsonSerialization['layer'] as String)),
      dependencyIds: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['dependencyIds'],
      ),
    );
  }

  String nodeId;

  String name;

  _i2.FeatureLayer layer;

  List<String> dependencyIds;

  /// Returns a shallow copy of this [FeatureNode]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FeatureNode copyWith({
    String? nodeId,
    String? name,
    _i2.FeatureLayer? layer,
    List<String>? dependencyIds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FeatureNode',
      'nodeId': nodeId,
      'name': name,
      'layer': layer.toJson(),
      'dependencyIds': dependencyIds.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FeatureNode',
      'nodeId': nodeId,
      'name': name,
      'layer': layer.toJson(),
      'dependencyIds': dependencyIds.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _FeatureNodeImpl extends FeatureNode {
  _FeatureNodeImpl({
    required String nodeId,
    required String name,
    required _i2.FeatureLayer layer,
    required List<String> dependencyIds,
  }) : super._(
         nodeId: nodeId,
         name: name,
         layer: layer,
         dependencyIds: dependencyIds,
       );

  /// Returns a shallow copy of this [FeatureNode]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FeatureNode copyWith({
    String? nodeId,
    String? name,
    _i2.FeatureLayer? layer,
    List<String>? dependencyIds,
  }) {
    return FeatureNode(
      nodeId: nodeId ?? this.nodeId,
      name: name ?? this.name,
      layer: layer ?? this.layer,
      dependencyIds:
          dependencyIds ?? this.dependencyIds.map((e0) => e0).toList(),
    );
  }
}
