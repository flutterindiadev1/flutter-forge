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

abstract class ProjectRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = ProjectRecordTable();

  static const db = ProjectRecordRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static ProjectRecordInclude include() {
    return ProjectRecordInclude._();
  }

  static ProjectRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<ProjectRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProjectRecordTable>? orderByList,
    ProjectRecordInclude? include,
  }) {
    return ProjectRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ProjectRecord.t),
      include: include,
    );
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

class ProjectRecordUpdateTable extends _i1.UpdateTable<ProjectRecordTable> {
  ProjectRecordUpdateTable(super.table);

  _i1.ColumnValue<String, String> projectId(String value) => _i1.ColumnValue(
    table.projectId,
    value,
  );

  _i1.ColumnValue<String, String> userId(String? value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> configJson(String value) => _i1.ColumnValue(
    table.configJson,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> repoUrl(String? value) => _i1.ColumnValue(
    table.repoUrl,
    value,
  );

  _i1.ColumnValue<String, String> githubUsername(String? value) =>
      _i1.ColumnValue(
        table.githubUsername,
        value,
      );

  _i1.ColumnValue<String, String> iterationHistory(String? value) =>
      _i1.ColumnValue(
        table.iterationHistory,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class ProjectRecordTable extends _i1.Table<int?> {
  ProjectRecordTable({super.tableRelation})
    : super(tableName: 'project_records') {
    updateTable = ProjectRecordUpdateTable(this);
    projectId = _i1.ColumnString(
      'projectId',
      this,
    );
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    configJson = _i1.ColumnString(
      'configJson',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    repoUrl = _i1.ColumnString(
      'repoUrl',
      this,
    );
    githubUsername = _i1.ColumnString(
      'githubUsername',
      this,
    );
    iterationHistory = _i1.ColumnString(
      'iterationHistory',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final ProjectRecordUpdateTable updateTable;

  late final _i1.ColumnString projectId;

  late final _i1.ColumnString userId;

  late final _i1.ColumnString configJson;

  late final _i1.ColumnString status;

  late final _i1.ColumnString repoUrl;

  late final _i1.ColumnString githubUsername;

  late final _i1.ColumnString iterationHistory;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    projectId,
    userId,
    configJson,
    status,
    repoUrl,
    githubUsername,
    iterationHistory,
    createdAt,
    updatedAt,
  ];
}

class ProjectRecordInclude extends _i1.IncludeObject {
  ProjectRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ProjectRecord.t;
}

class ProjectRecordIncludeList extends _i1.IncludeList {
  ProjectRecordIncludeList._({
    _i1.WhereExpressionBuilder<ProjectRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ProjectRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ProjectRecord.t;
}

class ProjectRecordRepository {
  const ProjectRecordRepository._();

  /// Returns a list of [ProjectRecord]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<ProjectRecord>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProjectRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProjectRecord>(
      where: where?.call(ProjectRecord.t),
      orderBy: orderBy?.call(ProjectRecord.t),
      orderByList: orderByList?.call(ProjectRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ProjectRecord] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<ProjectRecord?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<ProjectRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProjectRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProjectRecord>(
      where: where?.call(ProjectRecord.t),
      orderBy: orderBy?.call(ProjectRecord.t),
      orderByList: orderByList?.call(ProjectRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProjectRecord] by its [id] or null if no such row exists.
  Future<ProjectRecord?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProjectRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProjectRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [ProjectRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ProjectRecord>> insert(
    _i1.DatabaseSession session,
    List<ProjectRecord> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ProjectRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ProjectRecord] and returns the inserted row.
  ///
  /// The returned [ProjectRecord] will have its `id` field set.
  Future<ProjectRecord> insertRow(
    _i1.DatabaseSession session,
    ProjectRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProjectRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ProjectRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ProjectRecord>> update(
    _i1.DatabaseSession session,
    List<ProjectRecord> rows, {
    _i1.ColumnSelections<ProjectRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ProjectRecord>(
      rows,
      columns: columns?.call(ProjectRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProjectRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProjectRecord> updateRow(
    _i1.DatabaseSession session,
    ProjectRecord row, {
    _i1.ColumnSelections<ProjectRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProjectRecord>(
      row,
      columns: columns?.call(ProjectRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProjectRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProjectRecord?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ProjectRecordUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ProjectRecord>(
      id,
      columnValues: columnValues(ProjectRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ProjectRecord>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ProjectRecordUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ProjectRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectRecordTable>? orderBy,
    _i1.OrderByListBuilder<ProjectRecordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ProjectRecord>(
      columnValues: columnValues(ProjectRecord.t.updateTable),
      where: where(ProjectRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectRecord.t),
      orderByList: orderByList?.call(ProjectRecord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ProjectRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ProjectRecord>> delete(
    _i1.DatabaseSession session,
    List<ProjectRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ProjectRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ProjectRecord].
  Future<ProjectRecord> deleteRow(
    _i1.DatabaseSession session,
    ProjectRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProjectRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ProjectRecord>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProjectRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ProjectRecord>(
      where: where(ProjectRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ProjectRecord>(
      where: where?.call(ProjectRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProjectRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProjectRecordTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProjectRecord>(
      where: where(ProjectRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
