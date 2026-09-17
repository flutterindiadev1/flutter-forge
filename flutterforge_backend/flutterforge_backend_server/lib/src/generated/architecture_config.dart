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

abstract class ArchitectureConfig
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ArchitectureConfig._({
    required this.pattern,
    required this.stateManagement,
    required this.di,
    required this.network,
    required this.localStorage,
    required this.navigation,
  });

  factory ArchitectureConfig({
    required String pattern,
    required String stateManagement,
    required String di,
    required String network,
    required String localStorage,
    required String navigation,
  }) = _ArchitectureConfigImpl;

  factory ArchitectureConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return ArchitectureConfig(
      pattern: jsonSerialization['pattern'] as String,
      stateManagement: jsonSerialization['stateManagement'] as String,
      di: jsonSerialization['di'] as String,
      network: jsonSerialization['network'] as String,
      localStorage: jsonSerialization['localStorage'] as String,
      navigation: jsonSerialization['navigation'] as String,
    );
  }

  String pattern;

  String stateManagement;

  String di;

  String network;

  String localStorage;

  String navigation;

  /// Returns a shallow copy of this [ArchitectureConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ArchitectureConfig copyWith({
    String? pattern,
    String? stateManagement,
    String? di,
    String? network,
    String? localStorage,
    String? navigation,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ArchitectureConfig',
      'pattern': pattern,
      'stateManagement': stateManagement,
      'di': di,
      'network': network,
      'localStorage': localStorage,
      'navigation': navigation,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ArchitectureConfig',
      'pattern': pattern,
      'stateManagement': stateManagement,
      'di': di,
      'network': network,
      'localStorage': localStorage,
      'navigation': navigation,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ArchitectureConfigImpl extends ArchitectureConfig {
  _ArchitectureConfigImpl({
    required String pattern,
    required String stateManagement,
    required String di,
    required String network,
    required String localStorage,
    required String navigation,
  }) : super._(
         pattern: pattern,
         stateManagement: stateManagement,
         di: di,
         network: network,
         localStorage: localStorage,
         navigation: navigation,
       );

  /// Returns a shallow copy of this [ArchitectureConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ArchitectureConfig copyWith({
    String? pattern,
    String? stateManagement,
    String? di,
    String? network,
    String? localStorage,
    String? navigation,
  }) {
    return ArchitectureConfig(
      pattern: pattern ?? this.pattern,
      stateManagement: stateManagement ?? this.stateManagement,
      di: di ?? this.di,
      network: network ?? this.network,
      localStorage: localStorage ?? this.localStorage,
      navigation: navigation ?? this.navigation,
    );
  }
}
