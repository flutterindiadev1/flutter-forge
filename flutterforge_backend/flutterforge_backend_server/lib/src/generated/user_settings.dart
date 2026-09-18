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

abstract class UserSettings
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserSettings._({
    this.id,
    required this.userInfoId,
  });

  factory UserSettings({
    int? id,
    required String userInfoId,
  }) = _UserSettingsImpl;

  factory UserSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserSettings(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as String,
    );
  }

  static final t = UserSettingsTable();

  static const db = UserSettingsRepository._();

  @override
  int? id;

  String userInfoId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserSettings copyWith({
    int? id,
    String? userInfoId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserSettings',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserSettings',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
    };
  }

  static UserSettingsInclude include() {
    return UserSettingsInclude._();
  }

  static UserSettingsIncludeList includeList({
    _i1.WhereExpressionBuilder<UserSettingsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserSettingsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserSettingsTable>? orderByList,
    UserSettingsInclude? include,
  }) {
    return UserSettingsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserSettings.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserSettings.t),
      include: include,
    );
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
  }) : super._(
         id: id,
         userInfoId: userInfoId,
       );

  /// Returns a shallow copy of this [UserSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserSettings copyWith({
    Object? id = _Undefined,
    String? userInfoId,
  }) {
    return UserSettings(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
    );
  }
}

class UserSettingsUpdateTable extends _i1.UpdateTable<UserSettingsTable> {
  UserSettingsUpdateTable(super.table);

  _i1.ColumnValue<String, String> userInfoId(String value) => _i1.ColumnValue(
    table.userInfoId,
    value,
  );
}

class UserSettingsTable extends _i1.Table<int?> {
  UserSettingsTable({super.tableRelation}) : super(tableName: 'user_settings') {
    updateTable = UserSettingsUpdateTable(this);
    userInfoId = _i1.ColumnString(
      'userInfoId',
      this,
    );
  }

  late final UserSettingsUpdateTable updateTable;

  late final _i1.ColumnString userInfoId;

  @override
  List<_i1.Column> get columns => [
    id,
    userInfoId,
  ];
}

class UserSettingsInclude extends _i1.IncludeObject {
  UserSettingsInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserSettings.t;
}

class UserSettingsIncludeList extends _i1.IncludeList {
  UserSettingsIncludeList._({
    _i1.WhereExpressionBuilder<UserSettingsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserSettings.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserSettings.t;
}

class UserSettingsRepository {
  const UserSettingsRepository._();

  /// Returns a list of [UserSettings]s matching the given query parameters.
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
  Future<List<UserSettings>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserSettingsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserSettingsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserSettingsTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserSettings>(
      where: where?.call(UserSettings.t),
      orderBy: orderBy?.call(UserSettings.t),
      orderByList: orderByList?.call(UserSettings.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserSettings] matching the given query parameters.
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
  Future<UserSettings?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserSettingsTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserSettingsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserSettingsTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserSettings>(
      where: where?.call(UserSettings.t),
      orderBy: orderBy?.call(UserSettings.t),
      orderByList: orderByList?.call(UserSettings.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserSettings] by its [id] or null if no such row exists.
  Future<UserSettings?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserSettings>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserSettings]s in the list and returns the inserted rows.
  ///
  /// The returned [UserSettings]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<UserSettings>> insert(
    _i1.DatabaseSession session,
    List<UserSettings> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<UserSettings>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [UserSettings] and returns the inserted row.
  ///
  /// The returned [UserSettings] will have its `id` field set.
  Future<UserSettings> insertRow(
    _i1.DatabaseSession session,
    UserSettings row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserSettings>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserSettings]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserSettings>> update(
    _i1.DatabaseSession session,
    List<UserSettings> rows, {
    _i1.ColumnSelections<UserSettingsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserSettings>(
      rows,
      columns: columns?.call(UserSettings.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserSettings]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserSettings> updateRow(
    _i1.DatabaseSession session,
    UserSettings row, {
    _i1.ColumnSelections<UserSettingsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserSettings>(
      row,
      columns: columns?.call(UserSettings.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserSettings] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserSettings?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<UserSettingsUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserSettings>(
      id,
      columnValues: columnValues(UserSettings.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserSettings]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserSettings>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<UserSettingsUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UserSettingsTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserSettingsTable>? orderBy,
    _i1.OrderByListBuilder<UserSettingsTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserSettings>(
      columnValues: columnValues(UserSettings.t.updateTable),
      where: where(UserSettings.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserSettings.t),
      orderByList: orderByList?.call(UserSettings.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserSettings]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserSettings>> delete(
    _i1.DatabaseSession session,
    List<UserSettings> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserSettings>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserSettings].
  Future<UserSettings> deleteRow(
    _i1.DatabaseSession session,
    UserSettings row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserSettings>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserSettings>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UserSettingsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserSettings>(
      where: where(UserSettings.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UserSettingsTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserSettings>(
      where: where?.call(UserSettings.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserSettings] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UserSettingsTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserSettings>(
      where: where(UserSettings.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
