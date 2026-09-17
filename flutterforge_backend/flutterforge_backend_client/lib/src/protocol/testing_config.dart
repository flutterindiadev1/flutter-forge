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

abstract class TestingConfig implements _i1.SerializableModel {
  TestingConfig._({
    required this.generateUnitTests,
    required this.generateWidgetTests,
    required this.generateIntegrationTests,
    required this.coverageTarget,
  });

  factory TestingConfig({
    required bool generateUnitTests,
    required bool generateWidgetTests,
    required bool generateIntegrationTests,
    required int coverageTarget,
  }) = _TestingConfigImpl;

  factory TestingConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return TestingConfig(
      generateUnitTests: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['generateUnitTests'],
      ),
      generateWidgetTests: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['generateWidgetTests'],
      ),
      generateIntegrationTests: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['generateIntegrationTests'],
      ),
      coverageTarget: jsonSerialization['coverageTarget'] as int,
    );
  }

  bool generateUnitTests;

  bool generateWidgetTests;

  bool generateIntegrationTests;

  int coverageTarget;

  /// Returns a shallow copy of this [TestingConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TestingConfig copyWith({
    bool? generateUnitTests,
    bool? generateWidgetTests,
    bool? generateIntegrationTests,
    int? coverageTarget,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TestingConfig',
      'generateUnitTests': generateUnitTests,
      'generateWidgetTests': generateWidgetTests,
      'generateIntegrationTests': generateIntegrationTests,
      'coverageTarget': coverageTarget,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _TestingConfigImpl extends TestingConfig {
  _TestingConfigImpl({
    required bool generateUnitTests,
    required bool generateWidgetTests,
    required bool generateIntegrationTests,
    required int coverageTarget,
  }) : super._(
         generateUnitTests: generateUnitTests,
         generateWidgetTests: generateWidgetTests,
         generateIntegrationTests: generateIntegrationTests,
         coverageTarget: coverageTarget,
       );

  /// Returns a shallow copy of this [TestingConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TestingConfig copyWith({
    bool? generateUnitTests,
    bool? generateWidgetTests,
    bool? generateIntegrationTests,
    int? coverageTarget,
  }) {
    return TestingConfig(
      generateUnitTests: generateUnitTests ?? this.generateUnitTests,
      generateWidgetTests: generateWidgetTests ?? this.generateWidgetTests,
      generateIntegrationTests:
          generateIntegrationTests ?? this.generateIntegrationTests,
      coverageTarget: coverageTarget ?? this.coverageTarget,
    );
  }
}
