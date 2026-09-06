// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MealsTable extends Meals with TableInfo<$MealsTable, Meal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, calories, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Meal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Meal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Meal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MealsTable createAlias(String alias) {
    return $MealsTable(attachedDatabase, alias);
  }
}

class Meal extends DataClass implements Insertable<Meal> {
  final int id;
  final String name;
  final int calories;
  final DateTime createdAt;
  const Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['calories'] = Variable<int>(calories);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MealsCompanion toCompanion(bool nullToAbsent) {
    return MealsCompanion(
      id: Value(id),
      name: Value(name),
      calories: Value(calories),
      createdAt: Value(createdAt),
    );
  }

  factory Meal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Meal(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      calories: serializer.fromJson<int>(json['calories']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'calories': serializer.toJson<int>(calories),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Meal copyWith({int? id, String? name, int? calories, DateTime? createdAt}) =>
      Meal(
        id: id ?? this.id,
        name: name ?? this.name,
        calories: calories ?? this.calories,
        createdAt: createdAt ?? this.createdAt,
      );
  Meal copyWithCompanion(MealsCompanion data) {
    return Meal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      calories: data.calories.present ? data.calories.value : this.calories,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Meal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('calories: $calories, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, calories, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Meal &&
          other.id == this.id &&
          other.name == this.name &&
          other.calories == this.calories &&
          other.createdAt == this.createdAt);
}

class MealsCompanion extends UpdateCompanion<Meal> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> calories;
  final Value<DateTime> createdAt;
  const MealsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.calories = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MealsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int calories,
    required DateTime createdAt,
  }) : name = Value(name),
       calories = Value(calories),
       createdAt = Value(createdAt);
  static Insertable<Meal> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? calories,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (calories != null) 'calories': calories,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MealsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? calories,
    Value<DateTime>? createdAt,
  }) {
    return MealsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('calories: $calories, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FastingSessionsTable extends FastingSessions
    with TableInfo<$FastingSessionsTable, FastingSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FastingSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _protocolNameMeta = const VerificationMeta(
    'protocolName',
  );
  @override
  late final GeneratedColumn<String> protocolName = GeneratedColumn<String>(
    'protocol_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedDurationMinutesMeta =
      const VerificationMeta('plannedDurationMinutes');
  @override
  late final GeneratedColumn<int> plannedDurationMinutes = GeneratedColumn<int>(
    'planned_duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualDurationMinutesMeta =
      const VerificationMeta('actualDurationMinutes');
  @override
  late final GeneratedColumn<int> actualDurationMinutes = GeneratedColumn<int>(
    'actual_duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    protocolName,
    startedAt,
    endedAt,
    plannedDurationMinutes,
    actualDurationMinutes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fasting_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FastingSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('protocol_name')) {
      context.handle(
        _protocolNameMeta,
        protocolName.isAcceptableOrUnknown(
          data['protocol_name']!,
          _protocolNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_protocolNameMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('planned_duration_minutes')) {
      context.handle(
        _plannedDurationMinutesMeta,
        plannedDurationMinutes.isAcceptableOrUnknown(
          data['planned_duration_minutes']!,
          _plannedDurationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedDurationMinutesMeta);
    }
    if (data.containsKey('actual_duration_minutes')) {
      context.handle(
        _actualDurationMinutesMeta,
        actualDurationMinutes.isAcceptableOrUnknown(
          data['actual_duration_minutes']!,
          _actualDurationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actualDurationMinutesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FastingSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FastingSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      protocolName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}protocol_name'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      )!,
      plannedDurationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_duration_minutes'],
      )!,
      actualDurationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_duration_minutes'],
      )!,
    );
  }

  @override
  $FastingSessionsTable createAlias(String alias) {
    return $FastingSessionsTable(attachedDatabase, alias);
  }
}

class FastingSession extends DataClass implements Insertable<FastingSession> {
  final int id;
  final String protocolName;
  final DateTime startedAt;
  final DateTime endedAt;
  final int plannedDurationMinutes;
  final int actualDurationMinutes;
  const FastingSession({
    required this.id,
    required this.protocolName,
    required this.startedAt,
    required this.endedAt,
    required this.plannedDurationMinutes,
    required this.actualDurationMinutes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['protocol_name'] = Variable<String>(protocolName);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    map['planned_duration_minutes'] = Variable<int>(plannedDurationMinutes);
    map['actual_duration_minutes'] = Variable<int>(actualDurationMinutes);
    return map;
  }

  FastingSessionsCompanion toCompanion(bool nullToAbsent) {
    return FastingSessionsCompanion(
      id: Value(id),
      protocolName: Value(protocolName),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      plannedDurationMinutes: Value(plannedDurationMinutes),
      actualDurationMinutes: Value(actualDurationMinutes),
    );
  }

  factory FastingSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FastingSession(
      id: serializer.fromJson<int>(json['id']),
      protocolName: serializer.fromJson<String>(json['protocolName']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
      plannedDurationMinutes: serializer.fromJson<int>(
        json['plannedDurationMinutes'],
      ),
      actualDurationMinutes: serializer.fromJson<int>(
        json['actualDurationMinutes'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'protocolName': serializer.toJson<String>(protocolName),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
      'plannedDurationMinutes': serializer.toJson<int>(plannedDurationMinutes),
      'actualDurationMinutes': serializer.toJson<int>(actualDurationMinutes),
    };
  }

  FastingSession copyWith({
    int? id,
    String? protocolName,
    DateTime? startedAt,
    DateTime? endedAt,
    int? plannedDurationMinutes,
    int? actualDurationMinutes,
  }) => FastingSession(
    id: id ?? this.id,
    protocolName: protocolName ?? this.protocolName,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    plannedDurationMinutes:
        plannedDurationMinutes ?? this.plannedDurationMinutes,
    actualDurationMinutes: actualDurationMinutes ?? this.actualDurationMinutes,
  );
  FastingSession copyWithCompanion(FastingSessionsCompanion data) {
    return FastingSession(
      id: data.id.present ? data.id.value : this.id,
      protocolName: data.protocolName.present
          ? data.protocolName.value
          : this.protocolName,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      plannedDurationMinutes: data.plannedDurationMinutes.present
          ? data.plannedDurationMinutes.value
          : this.plannedDurationMinutes,
      actualDurationMinutes: data.actualDurationMinutes.present
          ? data.actualDurationMinutes.value
          : this.actualDurationMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FastingSession(')
          ..write('id: $id, ')
          ..write('protocolName: $protocolName, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('plannedDurationMinutes: $plannedDurationMinutes, ')
          ..write('actualDurationMinutes: $actualDurationMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    protocolName,
    startedAt,
    endedAt,
    plannedDurationMinutes,
    actualDurationMinutes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FastingSession &&
          other.id == this.id &&
          other.protocolName == this.protocolName &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.plannedDurationMinutes == this.plannedDurationMinutes &&
          other.actualDurationMinutes == this.actualDurationMinutes);
}

class FastingSessionsCompanion extends UpdateCompanion<FastingSession> {
  final Value<int> id;
  final Value<String> protocolName;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<int> plannedDurationMinutes;
  final Value<int> actualDurationMinutes;
  const FastingSessionsCompanion({
    this.id = const Value.absent(),
    this.protocolName = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.plannedDurationMinutes = const Value.absent(),
    this.actualDurationMinutes = const Value.absent(),
  });
  FastingSessionsCompanion.insert({
    this.id = const Value.absent(),
    required String protocolName,
    required DateTime startedAt,
    required DateTime endedAt,
    required int plannedDurationMinutes,
    required int actualDurationMinutes,
  }) : protocolName = Value(protocolName),
       startedAt = Value(startedAt),
       endedAt = Value(endedAt),
       plannedDurationMinutes = Value(plannedDurationMinutes),
       actualDurationMinutes = Value(actualDurationMinutes);
  static Insertable<FastingSession> custom({
    Expression<int>? id,
    Expression<String>? protocolName,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? plannedDurationMinutes,
    Expression<int>? actualDurationMinutes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (protocolName != null) 'protocol_name': protocolName,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (plannedDurationMinutes != null)
        'planned_duration_minutes': plannedDurationMinutes,
      if (actualDurationMinutes != null)
        'actual_duration_minutes': actualDurationMinutes,
    });
  }

  FastingSessionsCompanion copyWith({
    Value<int>? id,
    Value<String>? protocolName,
    Value<DateTime>? startedAt,
    Value<DateTime>? endedAt,
    Value<int>? plannedDurationMinutes,
    Value<int>? actualDurationMinutes,
  }) {
    return FastingSessionsCompanion(
      id: id ?? this.id,
      protocolName: protocolName ?? this.protocolName,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      plannedDurationMinutes:
          plannedDurationMinutes ?? this.plannedDurationMinutes,
      actualDurationMinutes:
          actualDurationMinutes ?? this.actualDurationMinutes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (protocolName.present) {
      map['protocol_name'] = Variable<String>(protocolName.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (plannedDurationMinutes.present) {
      map['planned_duration_minutes'] = Variable<int>(
        plannedDurationMinutes.value,
      );
    }
    if (actualDurationMinutes.present) {
      map['actual_duration_minutes'] = Variable<int>(
        actualDurationMinutes.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FastingSessionsCompanion(')
          ..write('id: $id, ')
          ..write('protocolName: $protocolName, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('plannedDurationMinutes: $plannedDurationMinutes, ')
          ..write('actualDurationMinutes: $actualDurationMinutes')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MealsTable meals = $MealsTable(this);
  late final $FastingSessionsTable fastingSessions = $FastingSessionsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [meals, fastingSessions];
}

typedef $$MealsTableCreateCompanionBuilder = MealsCompanion Function({
  Value<int> id,
  required String name,
  required int calories,
  required DateTime createdAt,
});
typedef $$MealsTableUpdateCompanionBuilder = MealsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> calories,
  Value<DateTime> createdAt,
});

class $$MealsTableFilterComposer extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MealsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MealsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealsTable,
          Meal,
          $$MealsTableFilterComposer,
          $$MealsTableOrderingComposer,
          $$MealsTableAnnotationComposer,
          $$MealsTableCreateCompanionBuilder,
          $$MealsTableUpdateCompanionBuilder,
          (Meal, BaseReferences<_$AppDatabase, $MealsTable, Meal>),
          Meal,
          PrefetchHooks Function()
        > {
  $$MealsTableTableManager(_$AppDatabase db, $MealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MealsCompanion(
                id: id,
                name: name,
                calories: calories,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int calories,
                required DateTime createdAt,
              }) => MealsCompanion.insert(
                id: id,
                name: name,
                calories: calories,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MealsTable, Meal>(table),
                  BaseReferences<_$AppDatabase, $MealsTable, Meal>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MealsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealsTable,
      Meal,
      $$MealsTableFilterComposer,
      $$MealsTableOrderingComposer,
      $$MealsTableAnnotationComposer,
      $$MealsTableCreateCompanionBuilder,
      $$MealsTableUpdateCompanionBuilder,
      (Meal, BaseReferences<_$AppDatabase, $MealsTable, Meal>),
      Meal,
      PrefetchHooks Function()
    >;
typedef $$FastingSessionsTableCreateCompanionBuilder =
    FastingSessionsCompanion Function({
      Value<int> id,
      required String protocolName,
      required DateTime startedAt,
      required DateTime endedAt,
      required int plannedDurationMinutes,
      required int actualDurationMinutes,
    });
typedef $$FastingSessionsTableUpdateCompanionBuilder =
    FastingSessionsCompanion Function({
      Value<int> id,
      Value<String> protocolName,
      Value<DateTime> startedAt,
      Value<DateTime> endedAt,
      Value<int> plannedDurationMinutes,
      Value<int> actualDurationMinutes,
    });

class $$FastingSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $FastingSessionsTable> {
  $$FastingSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get protocolName => $composableBuilder(
    column: $table.protocolName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedDurationMinutes => $composableBuilder(
    column: $table.plannedDurationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualDurationMinutes => $composableBuilder(
    column: $table.actualDurationMinutes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FastingSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FastingSessionsTable> {
  $$FastingSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get protocolName => $composableBuilder(
    column: $table.protocolName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedDurationMinutes => $composableBuilder(
    column: $table.plannedDurationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualDurationMinutes => $composableBuilder(
    column: $table.actualDurationMinutes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FastingSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FastingSessionsTable> {
  $$FastingSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get protocolName => $composableBuilder(
    column: $table.protocolName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get plannedDurationMinutes => $composableBuilder(
    column: $table.plannedDurationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualDurationMinutes => $composableBuilder(
    column: $table.actualDurationMinutes,
    builder: (column) => column,
  );
}

class $$FastingSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FastingSessionsTable,
          FastingSession,
          $$FastingSessionsTableFilterComposer,
          $$FastingSessionsTableOrderingComposer,
          $$FastingSessionsTableAnnotationComposer,
          $$FastingSessionsTableCreateCompanionBuilder,
          $$FastingSessionsTableUpdateCompanionBuilder,
          (
            FastingSession,
            BaseReferences<
              _$AppDatabase,
              $FastingSessionsTable,
              FastingSession
            >,
          ),
          FastingSession,
          PrefetchHooks Function()
        > {
  $$FastingSessionsTableTableManager(
    _$AppDatabase db,
    $FastingSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FastingSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FastingSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FastingSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> protocolName = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> endedAt = const Value.absent(),
                Value<int> plannedDurationMinutes = const Value.absent(),
                Value<int> actualDurationMinutes = const Value.absent(),
              }) => FastingSessionsCompanion(
                id: id,
                protocolName: protocolName,
                startedAt: startedAt,
                endedAt: endedAt,
                plannedDurationMinutes: plannedDurationMinutes,
                actualDurationMinutes: actualDurationMinutes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String protocolName,
                required DateTime startedAt,
                required DateTime endedAt,
                required int plannedDurationMinutes,
                required int actualDurationMinutes,
              }) => FastingSessionsCompanion.insert(
                id: id,
                protocolName: protocolName,
                startedAt: startedAt,
                endedAt: endedAt,
                plannedDurationMinutes: plannedDurationMinutes,
                actualDurationMinutes: actualDurationMinutes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FastingSessionsTable, FastingSession>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $FastingSessionsTable,
                    FastingSession
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FastingSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FastingSessionsTable,
      FastingSession,
      $$FastingSessionsTableFilterComposer,
      $$FastingSessionsTableOrderingComposer,
      $$FastingSessionsTableAnnotationComposer,
      $$FastingSessionsTableCreateCompanionBuilder,
      $$FastingSessionsTableUpdateCompanionBuilder,
      (
        FastingSession,
        BaseReferences<_$AppDatabase, $FastingSessionsTable, FastingSession>,
      ),
      FastingSession,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db, _db.meals);
  $$FastingSessionsTableTableManager get fastingSessions =>
      $$FastingSessionsTableTableManager(_db, _db.fastingSessions);
}
