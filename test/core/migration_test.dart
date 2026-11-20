import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solo_calisthenics/core/db/app_database.dart';
import 'package:solo_calisthenics/features/planner/data/progress_repository.dart';
import 'package:solo_calisthenics/features/planner/domain/progression_engine.dart';
import 'package:solo_calisthenics/features/workout/data/workout_repository.dart';
import 'package:sqlite3/sqlite3.dart';

/// The schema exactly as Phase 1 (version 1) created it.
const v1Schema = '''
CREATE TABLE profiles (id INTEGER NOT NULL, birth_year INTEGER NOT NULL, height_cm REAL NOT NULL, weight_kg REAL NOT NULL, experience TEXT NOT NULL, max_push_ups INTEGER NULL, max_pull_ups INTEGER NULL, max_dead_hang_sec INTEGER NULL, max_plank_sec INTEGER NULL, created_at INTEGER NOT NULL, PRIMARY KEY (id));
CREATE TABLE injuries (joint TEXT NOT NULL, severity TEXT NOT NULL, is_current INTEGER NOT NULL DEFAULT 1 CHECK (is_current IN (0, 1)), PRIMARY KEY (joint));
CREATE TABLE settings ("key" TEXT NOT NULL, value TEXT NOT NULL, PRIMARY KEY ("key"));
CREATE TABLE sessions (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, started_at INTEGER NOT NULL, finished_at INTEGER NULL, current_index INTEGER NOT NULL DEFAULT 0, pending_count INTEGER NOT NULL DEFAULT 0, rest_ends_at INTEGER NULL, rest_total_sec INTEGER NULL);
CREATE TABLE session_exercises (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, session_id INTEGER NOT NULL REFERENCES sessions (id) ON DELETE CASCADE, exercise_id TEXT NOT NULL, order_index INTEGER NOT NULL, target_sets INTEGER NOT NULL, target_min INTEGER NOT NULL, target_max INTEGER NOT NULL, rest_sec INTEGER NOT NULL);
CREATE TABLE set_logs (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, session_exercise_id INTEGER NOT NULL REFERENCES session_exercises (id) ON DELETE CASCADE, set_number INTEGER NOT NULL, value INTEGER NOT NULL, rir INTEGER NULL, rpe REAL NULL, method TEXT NOT NULL, logged_at INTEGER NOT NULL);
INSERT INTO sessions (name, started_at, pending_count) VALUES ('Old workout', 1767636000, 4);
INSERT INTO session_exercises (session_id, exercise_id, order_index, target_sets, target_min, target_max, rest_sec) VALUES (1, 'push_up', 0, 3, 8, 12, 90);
INSERT INTO set_logs (session_exercise_id, set_number, value, method, logged_at) VALUES (1, 1, 10, 'tap', 1767636100);
PRAGMA user_version = 1;
''';

void main() {
  test('a Phase 1 database upgrades to version 2 and keeps its data', () async {
    final dir = Directory.systemTemp.createTempSync('solo_migration');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/v1.db');
    sqlite3.open(file.path)
      ..execute(v1Schema)
      ..close();

    final db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);

    // The in-progress Phase 1 workout is still there, with the new columns defaulted.
    final session = (await WorkoutRepository(db).loadActive())!;
    expect(session.name, 'Old workout');
    expect(session.pendingCount, 4);
    expect(session.exercises.single.sets.single.value, 10);
    expect(session.planWeek, isNull);
    expect(session.isDeload, isFalse);

    // New tables work.
    final repo = ProgressRepository(db);
    await repo.saveChainState(
      const ChainState(chainId: 'push_up', exerciseId: 'push_up'),
      now: DateTime(2026),
    );
    expect((await repo.chainStates()).keys, ['push_up']);
    expect(await repo.milestones(), isEmpty);
    expect(
      (await db.customSelect('PRAGMA user_version').getSingle())
          .data
          .values
          .single,
      2,
    );
  });
}
