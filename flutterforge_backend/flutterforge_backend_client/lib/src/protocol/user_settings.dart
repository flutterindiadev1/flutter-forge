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

abstract class UserSettings implements _i1.SerializableModel {
  UserSettings._({
    this.id,
    required this.userInfoId,
    this.geminiApiKey,
    this.githubToken,
  });

  factory UserSettings({
    int? id,
    required String userInfoId,
    String? geminiApiKey,
    String? githubToken,
  }) = _UserSettingsImpl;

  factory UserSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserSettings(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as String,
      geminiApiKey: jsonSerialization['geminiApiKey'] as String?,
      githubToken: jsonSerialization['githubToken'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String userInfoId;

  String? geminiApiKey;

  String? githubToken;

  /// Returns a shallow copy of this [UserSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserSettings copyWith({
    int? id,
    String? userInfoId,
    String? geminiApiKey,
    String? githubToken,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserSettings',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      if (geminiApiKey != null) 'geminiApiKey': geminiApiKey,
      if (githubToken != null) 'githubToken': githubToken,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserSettingsImpl extends UserSettings {
  _UserSettingsImpl({
    int? id,
    required String userInfoId,
    String? geminiApiKey,
    String? githubToken,
  }) : super._(
         id: id,
         userInfoId: userInfoId,
         geminiApiKey: geminiApiKey,
         githubToken: githubToken,
       );

  /// Returns a shallow copy of this [UserSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserSettings copyWith({
    Object? id = _Undefined,
    String? userInfoId,
    Object? geminiApiKey = _Undefined,
    Object? githubToken = _Undefined,
  }) {
    return UserSettings(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      geminiApiKey: geminiApiKey is String? ? geminiApiKey : this.geminiApiKey,
      githubToken: githubToken is String? ? githubToken : this.githubToken,
    );
  }
}
