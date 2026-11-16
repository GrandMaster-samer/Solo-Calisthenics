import 'package:drift/drift.dart';

part 'app_database.g.dart';

/// Single-row table (id = 1) with the user's baseline stats. Metric units only.
@DataClassName('ProfileRow')
class Profiles extends Table {
  IntColumn get id => integer()();
  IntColumn get birthYear => integer()();
  RealColumn get heightCm => real()();
  RealColumn get weightKg => real()();
  TextColumn get experience => text()(); // Experience.name
  IntColumn get maxPushUps => integer().nullable()();
  IntColumn get maxPullUps => integer().nullable()();
  IntColumn get maxDeadHangSec => integer().nullable()();
  IntColumn get maxPlankSec => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// One row per flagged joint.
@DataClassName('InjuryRow')
class Injuries extends Table {
  TextColumn get joint => text()(); // Joint.name
  TextColumn get severity => text()(); // Severity.name
  BoolColumn get isCurrent => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {joint};
}

/// Key/value app settings (locale, units, reminders, ...).
@DataClassName('SettingRow')
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// A workout. `finishedAt == null` means it is still in progress and must be restored on launch.
@DataClassName('SessionRow')
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();
  IntColumn get currentIndex => integer().withDefault(const Constant(0))();
  IntColumn get pendingCount =>
      integer().withDefault(const Constant(0))(); // taps not yet saved as a set
  DateTimeColumn get restEndsAt => dateTime().nullable()();
  IntColumn get restTotalSec => integer().nullable()();
}

@DataClassName('SessionExerciseRow')
class SessionExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId =>
      integer().references(Sessions, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text()(); // id in assets/data/exercises.json
  IntColumn get orderIndex => integer()();
  IntColumn get targetSets => integer()();
  IntColumn get targetMin => integer()(); // reps, or seconds for holds
  IntColumn get targetMax => integer()();
  IntColumn get restSec => integer()();
}

@DataClassName('SetLogRow')
class SetLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionExerciseId => integer().references(
    SessionExercises,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get setNumber => integer()();
  IntColumn get value => integer()(); // reps, or seconds for holds
  IntColumn get rir => integer().nullable()();
  RealColumn get rpe => real().nullable()();
  TextColumn get method => text()(); // LogMethod.name
  DateTimeColumn get loggedAt => dateTime()();
}

@DriftDatabase(
  tables: [Profiles, Injuries, Settings, Sessions, SessionExercises, SetLogs],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async => customStatement('PRAGMA foreign_keys = ON'),
  );
}
