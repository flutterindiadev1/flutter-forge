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

abstract class ProjectRecord implements _i1.SerializableModel {
  ProjectRecord._({
    this.id,
    required this.projectId,
    this.userId,
    required this.configJson,
    required this.status,
    this.repoUrl,
    this.githubUsername,
    this.iterationHistory,
    required this.createdAt,
    this.updatedAt,
  });

  factory ProjectRecord({
    int? id,
    required String projectId,
    String? userId,
    required String configJson,
    required String status,
    String? repoUrl,
    String? githubUsername,
    String? iterationHistory,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ProjectRecordImpl;

  factory ProjectRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectRecord(
      id: jsonSerialization['id'] as int?,
      projectId: jsonSerialization['projectId'] as String,
      userId: jsonSerialization['userId'] as String?,
      configJson: jsonSerialization['configJson'] as String,
      status: jsonSerialization['status'] as String,
      repoUrl: jsonSerialization['repoUrl'] as String?,
      githubUsername: jsonSerialization['githubUsername'] as String?,
      iterationHistory: jsonSerialization['iterationHistory'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String projectId;

  String? userId;

  String configJson;

  String status;

  String? repoUrl;

  String? githubUsername;

  String? iterationHistory;

  DateTime createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [ProjectRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectRecord copyWith({
    int? id,
    String? projectId,
    String? userId,
    String? configJson,
    String? status,
    String? repoUrl,
    String? githubUsername,
    String? iterationHistory,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectRecord',
      if (id != null) 'id': id,
      'projectId': projectId,
      if (userId != null) 'userId': userId,
      'configJson': configJson,
      'status': status,
      if (repoUrl != null) 'repoUrl': repoUrl,
      if (githubUsername != null) 'githubUsername': githubUsername,
      if (iterationHistory != null) 'iterationHistory': iterationHistory,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectRecordImpl extends ProjectRecord {
  _ProjectRecordImpl({
    int? id,
    required String projectId,
    String? userId,
    required String configJson,
    required String status,
    String? repoUrl,
    String? githubUsername,
    String? iterationHistory,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         projectId: projectId,
         userId: userId,
         configJson: configJson,
         status: status,
         repoUrl: repoUrl,
         githubUsername: githubUsername,
         iterationHistory: iterationHistory,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ProjectRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProjectRecord copyWith({
    Object? id = _Undefined,
    String? projectId,
    Object? userId = _Undefined,
    String? configJson,
    String? status,
    Object? repoUrl = _Undefined,
    Object? githubUsername = _Undefined,
    Object? iterationHistory = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
  }) {
    return ProjectRecord(
      id: id is int? ? id : this.id,
      projectId: projectId ?? this.projectId,
      userId: userId is String? ? userId : this.userId,
      configJson: configJson ?? this.configJson,
      status: status ?? this.status,
      repoUrl: repoUrl is String? ? repoUrl : this.repoUrl,
      githubUsername: githubUsername is String?
          ? githubUsername
          : this.githubUsername,
      iterationHistory: iterationHistory is String?
          ? iterationHistory
          : this.iterationHistory,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
