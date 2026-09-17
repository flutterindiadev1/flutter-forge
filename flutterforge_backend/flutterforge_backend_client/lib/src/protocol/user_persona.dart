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
import 'user_persona_type.dart' as _i2;

abstract class UserPersona implements _i1.SerializableModel {
  UserPersona._({
    required this.type,
    required this.role,
    required this.goal,
    required this.painPoints,
    required this.needsScreenReader,
    required this.needsLargeText,
    required this.needsHighContrast,
    required this.needsReducedMotion,
  });

  factory UserPersona({
    required _i2.UserPersonaType type,
    required String role,
    required String goal,
    required String painPoints,
    required bool needsScreenReader,
    required bool needsLargeText,
    required bool needsHighContrast,
    required bool needsReducedMotion,
  }) = _UserPersonaImpl;

  factory UserPersona.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserPersona(
      type: _i2.UserPersonaType.fromJson((jsonSerialization['type'] as String)),
      role: jsonSerialization['role'] as String,
      goal: jsonSerialization['goal'] as String,
      painPoints: jsonSerialization['painPoints'] as String,
      needsScreenReader: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['needsScreenReader'],
      ),
      needsLargeText: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['needsLargeText'],
      ),
      needsHighContrast: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['needsHighContrast'],
      ),
      needsReducedMotion: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['needsReducedMotion'],
      ),
    );
  }

  _i2.UserPersonaType type;

  String role;

  String goal;

  String painPoints;

  bool needsScreenReader;

  bool needsLargeText;

  bool needsHighContrast;

  bool needsReducedMotion;

  /// Returns a shallow copy of this [UserPersona]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserPersona copyWith({
    _i2.UserPersonaType? type,
    String? role,
    String? goal,
    String? painPoints,
    bool? needsScreenReader,
    bool? needsLargeText,
    bool? needsHighContrast,
    bool? needsReducedMotion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserPersona',
      'type': type.toJson(),
      'role': role,
      'goal': goal,
      'painPoints': painPoints,
      'needsScreenReader': needsScreenReader,
      'needsLargeText': needsLargeText,
      'needsHighContrast': needsHighContrast,
      'needsReducedMotion': needsReducedMotion,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _UserPersonaImpl extends UserPersona {
  _UserPersonaImpl({
    required _i2.UserPersonaType type,
    required String role,
    required String goal,
    required String painPoints,
    required bool needsScreenReader,
    required bool needsLargeText,
    required bool needsHighContrast,
    required bool needsReducedMotion,
  }) : super._(
         type: type,
         role: role,
         goal: goal,
         painPoints: painPoints,
         needsScreenReader: needsScreenReader,
         needsLargeText: needsLargeText,
         needsHighContrast: needsHighContrast,
         needsReducedMotion: needsReducedMotion,
       );

  /// Returns a shallow copy of this [UserPersona]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserPersona copyWith({
    _i2.UserPersonaType? type,
    String? role,
    String? goal,
    String? painPoints,
    bool? needsScreenReader,
    bool? needsLargeText,
    bool? needsHighContrast,
    bool? needsReducedMotion,
  }) {
    return UserPersona(
      type: type ?? this.type,
      role: role ?? this.role,
      goal: goal ?? this.goal,
      painPoints: painPoints ?? this.painPoints,
      needsScreenReader: needsScreenReader ?? this.needsScreenReader,
      needsLargeText: needsLargeText ?? this.needsLargeText,
      needsHighContrast: needsHighContrast ?? this.needsHighContrast,
      needsReducedMotion: needsReducedMotion ?? this.needsReducedMotion,
    );
  }
}
