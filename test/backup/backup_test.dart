import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:solo_calisthenics/core/db/app_database.dart';
import 'package:solo_calisthenics/core/db/encrypted_connection.dart';
import 'package:solo_calisthenics/features/backup/data/backup_service.dart';
import 'package:solo_calisthenics/features/planner/data/progress_repository.dart';
import 'package:solo_calisthenics/features/planner/domain/progression_engine.dart';
import 'package:solo_calisthenics/features/profile/data/profile_repository.dart';
import 'package:solo_calisthenics/features/profile/domain/profile.dart';
import 'package:solo_calisthenics/features/progress/data/analytics_repository.dart';
import 'package:solo_calisthenics/features/workout/data/workout_repository.dart';
import 'package:solo_calisthenics/features/workout/domain/workout_models.dart';

import '../helpers.dart';

void main() {
  late Directory dir;
  setUp(() => dir = Directory.systemTemp.createTempSync('solo_backup'));
  tearDown(() => dir.deleteSync(recursive: true));

  Future<({File file, String key})> seededDevice(String name) async {
    final file = File('${dir.path}/$name.db');
    final key = generateHexKey();
    final db = AppDatabase(openEncryptedExecutor(file, key));
    await ProfileRepository(db).save(testProfile, const [
      Injury(joint: Joint.knees, severity: Severity.moderate),
    ]);
    final repo = WorkoutRepository(db);
    final id = await repo.createSession('Backup me', const [
      PlannedExercise(
        exerciseId: 'pull_up',
        sets: 3,
        targetMin: 4,
        targetMax: 10,
        restSec: 120,
      ),
    ], now: DateTime(2026, 1, 5));
    final s = (await repo.load(id))!;
    await repo.addSet(
      sessionId: id,
      sessionExerciseId: s.exercises.single.id,
      value: 7,
      method: LogMethod.manual,
      now: DateTime(2026, 1, 5, 0, 5),
      restSec: 0,
    );
    await repo.finish(id, now: DateTime(2026, 1, 5, 0, 30));
    await ProgressRepository(db).saveChainState(
      const ChainState(chainId: 'pull_up', exerciseId: 'pull_up'),
      now: DateTime(2026, 1, 5),
    );
    await AnalyticsRepository(db)
        .addPhoto(tinyPng, takenAt: DateTime(2026, 1, 5), weightKg: 74);
    await db.close();
    return (file: file, key: key);
  }

  test('export then restore on another device brings back everything, photos included', () async {
    final source = await seededDevice('phone_a');
    final backup = File('${dir.path}/export.solobackup');
    BackupService.export(
      database: source.file,
      hexKey: source.key,
      passphrase: "correct horse 'battery'",
      out: backup,
    );

    // The backup file is encrypted too.
    final raw = String.fromCharCodes(backup.readAsBytesSync());
    expect(raw.startsWith('SQLite format 3'), isFalse);
    expect(raw.contains('Backup me'), isFalse);

    // A different device: different key, existing unrelated data.
    final target = await seededDevice('phone_b');
    final other = AppDatabase(openEncryptedExecutor(target.file, target.key));
    await WorkoutRepository(other)
        .createSession('Will be replaced', const [], now: DateTime(2026, 2, 1));
    await other.close();

    BackupService.stageRestore(
      backup: backup,
      passphrase: "correct horse 'battery'",
      database: target.file,
      hexKey: target.key,
      currentSchemaVersion: 2,
    );
    BackupService.commitRestore(target.file);

    final db = AppDatabase(openEncryptedExecutor(target.file, target.key));
    addTearDown(db.close);
    expect((await ProfileRepository(db).loadProfile())!.weightKg, 74);
    expect(
      (await ProfileRepository(db).loadInjuries()).single.joint,
      Joint.knees,
    );
    final history = await WorkoutRepository(db).history();
    expect(history.single.name, 'Backup me');
    expect(history.single.totalSets, 1);
    expect(
      await WorkoutRepository(db).loadActive(),
      isNull,
      reason: 'the replaced session is gone',
    );
    expect((await ProgressRepository(db).chainStates()).keys, ['pull_up']);
    final photos = await AnalyticsRepository(db).photos();
    expect(await AnalyticsRepository(db).photoBytes(photos.single.id), tinyPng);
  });

  test('a wrong passphrase or a random file is rejected and the current data is untouched', () async {
    final source = await seededDevice('phone_a');
    final backup = File('${dir.path}/export.solobackup');
    BackupService.export(
      database: source.file,
      hexKey: source.key,
      passphrase: 'right passphrase',
      out: backup,
    );
    final before = source.file.readAsBytesSync();

    void attempt(File f, String pass) => BackupService.stageRestore(
      backup: f,
      passphrase: pass,
      database: source.file,
      hexKey: source.key,
      currentSchemaVersion: 2,
    );
    expect(
      () => attempt(backup, 'wrong passphrase'),
      throwsA(isA<BackupUnreadableException>()),
    );
    final junk = File('${dir.path}/holiday.jpg')
      ..writeAsBytesSync(List.filled(4096, 7));
    expect(
      () => attempt(junk, 'right passphrase'),
      throwsA(isA<BackupUnreadableException>()),
    );

    expect(source.file.readAsBytesSync(), before);
    expect(
      File('${source.file.path}.restore').existsSync(),
      isFalse,
      reason: 'no half-written file left behind',
    );
    expect(() => BackupService.commitRestore(source.file), throwsStateError);
  });

  test('a backup from a newer app version is refused', () async {
    final source = await seededDevice('phone_a');
    final backup = File('${dir.path}/export.solobackup');
    BackupService.export(
      database: source.file,
      hexKey: source.key,
      passphrase: 'right passphrase',
      out: backup,
    );
    expect(
      () => BackupService.stageRestore(
        backup: backup,
        passphrase: 'right passphrase',
        database: source.file,
        hexKey: source.key,
        currentSchemaVersion: 1,
      ),
      throwsA(isA<BackupTooNewException>()),
    );
  });

  test('file name carries the date and extension', () {
    expect(
      BackupService.fileName(DateTime(2026, 3, 9, 14)),
      'solo-calisthenics-2026-03-09.solobackup',
    );
  });
}
