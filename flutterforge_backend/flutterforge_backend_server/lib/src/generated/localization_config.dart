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
import 'package:flutterforge_backend_server/src/generated/protocol.dart' as _i2;

abstract class LocalizationConfig
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  LocalizationConfig._({
    required this.targetLanguages,
    required this.defaultLanguage,
  });

  factory LocalizationConfig({
    required List<String> targetLanguages,
    required String defaultLanguage,
  }) = _LocalizationConfigImpl;

  factory LocalizationConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return LocalizationConfig(
      targetLanguages: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['targetLanguages'],
      ),
      defaultLanguage: jsonSerialization['defaultLanguage'] as String,
    );
  }

  List<String> targetLanguages;

  String defaultLanguage;

  /// Returns a shallow copy of this [LocalizationConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LocalizationConfig copyWith({
    List<String>? targetLanguages,
    String? defaultLanguage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LocalizationConfig',
      'targetLanguages': targetLanguages.toJson(),
      'defaultLanguage': defaultLanguage,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LocalizationConfig',
      'targetLanguages': targetLanguages.toJson(),
      'defaultLanguage': defaultLanguage,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _LocalizationConfigImpl extends LocalizationConfig {
  _LocalizationConfigImpl({
    required List<String> targetLanguages,
    required String defaultLanguage,
  }) : super._(
         targetLanguages: targetLanguages,
         defaultLanguage: defaultLanguage,
       );

  /// Returns a shallow copy of this [LocalizationConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LocalizationConfig copyWith({
    List<String>? targetLanguages,
    String? defaultLanguage,
  }) {
    return LocalizationConfig(
      targetLanguages:
          targetLanguages ?? this.targetLanguages.map((e0) => e0).toList(),
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
    );
  }
}
