import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Meals extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get calories => integer()();

  DateTimeColumn get createdAt => dateTime()();
}

class FastingSessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get protocolName => text()();

  DateTimeColumn get startedAt => dateTime()();

  DateTimeColumn get endedAt => dateTime()();

  IntColumn get plannedDurationMinutes => integer()();

  IntColumn get actualDurationMinutes => integer()();
}

@DriftDatabase(tables: [Meals, FastingSessions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'mamba_fast_tracker'));

  @override
  int get schemaVersion => 2;


  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(fastingSessions);
        }
      },
    );
  }

  Future<int> addMeal(MealsCompanion meal) {
    return into(meals).insert(meal);
  }

  Future<List<Meal>> getAllMeals() {
    return select(meals).get();
  }

  Future<bool> updateMeal(Meal meal) {
    return update(meals).replace(meal);
  }

  Future<int> deleteMeal(int id) {
    return (delete(meals)..where((meal) => meal.id.equals(id))).go();
  }

  Future<List<Meal>> getMealsForDay(DateTime day) {
    final startOfDay = DateTime(day.year, day.month, day.day);

    final startOfNextDay = startOfDay.add(const Duration(days: 1));

    return (select(meals)
          ..where(
            (meal) =>
                meal.createdAt.isBiggerOrEqualValue(startOfDay) &
                meal.createdAt.isSmallerThanValue(startOfNextDay),
          )
          ..orderBy([(meal) => OrderingTerm.asc(meal.createdAt)]))
        .get();
  }
  Future<int> addFastingSession(
  FastingSessionsCompanion session,
) {
  return into(fastingSessions).insert(session);
}

Future<List<FastingSession>> getFastingSessionsForDay(
  DateTime day,
) {
  final startOfDay = DateTime(day.year, day.month, day.day);
  final startOfNextDay = startOfDay.add(const Duration(days: 1));

  return (select(fastingSessions)
        ..where(
          (session) =>
              session.endedAt.isBiggerOrEqualValue(startOfDay) &
              session.endedAt.isSmallerThanValue(startOfNextDay),
        )
        ..orderBy([
          (session) => OrderingTerm.asc(session.endedAt),
        ]))
      .get();
}
Future<List<FastingSession>> getFastingSessionsBetween(
  DateTime start,
  DateTime end,
) {
  return (select(fastingSessions)
        ..where(
          (session) =>
              session.endedAt.isBiggerOrEqualValue(start) &
              session.endedAt.isSmallerThanValue(end),
        )
        ..orderBy([
          (session) => OrderingTerm.asc(session.endedAt),
        ]))
      .get();
}

Future<List<Meal>> getMealsBetween(
  DateTime start,
  DateTime end,
) {
  return (select(meals)
        ..where(
          (meal) =>
              meal.createdAt.isBiggerOrEqualValue(start) &
              meal.createdAt.isSmallerThanValue(end),
        )
        ..orderBy([
          (meal) => OrderingTerm.asc(meal.createdAt),
        ]))
      .get();
}
}
