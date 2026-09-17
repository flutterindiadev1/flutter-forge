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
import 'feature_node.dart' as _i2;
import 'package:flutterforge_backend_client/src/protocol/protocol.dart' as _i3;

abstract class AiAnalysisResult implements _i1.SerializableModel {
  AiAnalysisResult._({
    required this.questions,
    required this.features,
  });

  factory AiAnalysisResult({
    required List<String> questions,
    required List<_i2.FeatureNode> features,
  }) = _AiAnalysisResultImpl;

  factory AiAnalysisResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiAnalysisResult(
      questions: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['questions'],
      ),
      features: _i3.Protocol().deserialize<List<_i2.FeatureNode>>(
        jsonSerialization['features'],
      ),
    );
  }

  List<String> questions;

  List<_i2.FeatureNode> features;

  /// Returns a shallow copy of this [AiAnalysisResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AiAnalysisResult copyWith({
    List<String>? questions,
    List<_i2.FeatureNode>? features,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiAnalysisResult',
      'questions': questions.toJson(),
      'features': features.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AiAnalysisResultImpl extends AiAnalysisResult {
  _AiAnalysisResultImpl({
    required List<String> questions,
    required List<_i2.FeatureNode> features,
  }) : super._(
         questions: questions,
         features: features,
       );

  /// Returns a shallow copy of this [AiAnalysisResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AiAnalysisResult copyWith({
    List<String>? questions,
    List<_i2.FeatureNode>? features,
  }) {
    return AiAnalysisResult(
      questions: questions ?? this.questions.map((e0) => e0).toList(),
      features: features ?? this.features.map((e0) => e0.copyWith()).toList(),
    );
  }
}
