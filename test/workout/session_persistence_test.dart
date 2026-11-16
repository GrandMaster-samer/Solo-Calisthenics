import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:solo_calisthenics/core/db/app_database.dart';
import 'package:solo_calisthenics/core/db/encrypted_connection.dart';
import 'package:solo_calisthenics/features/profile/data/profile_repository.dart';
import 'package:solo_calisthenics/features/profile/domain/profile.dart';
import 'package:solo_calisthenics/features/workout/application/active_session_controller.dart';
import 'package:solo_calisthenics/features/workout/data/workout_repository.dart';
import 'package:solo_calisthenics/features/workout/domain/workout_models.dart';

import '../helpers.dart';

const restText = (title: 'Rest over', body: 'Go');
const plan = [
  PlannedExercise(
    exerciseId: 'push_up',
    sets: 2,
    targetMin: 8,
    targetMax: 12,
    restSec: 90,
  ),
  PlannedExercise(
    exerciseId: 'plank',
    sets: 1,
    targetMin: 20,
    targetMax: 60,
    restSec: 60,
  ),
];

class MemoryKeyStore implements KeyStore {
  String? key;
  @override
  Future<String?> read() async => key;
  @override
  Future<void> write(String hexKey) async => key = hexKey;
  @override
  Future<void> delete() async => key = null;
}

void main() {
  group('active session controller', () {
    late TestEnv env;
    setUp(() => env = TestEnv());
    tearDown(() => env.db.close());

    test('logging a set saves it, clears the counter, starts rest and schedules the alert', () async {
      final c = env.container();
      addTearDown(c.dispose);
      final controller = c.read(activeSessionProvider.notifier);
      await c.read(activeSessionProvider.future);
      await controller.start('Push', plan);

      controller.setPendingCount(9);
      expect(c.read(activeSessionProvider).value!.pendingCount, 9);

      final setId = await controller.logSet(9, LogMethod.tap, restText);
      final s = c.read(activeSessionProvider).value!;
      expect(setId, isNotNull);
      expect(s.exercises.first.sets.single.value, 9);
      expect(s.exercises.first.sets.single.method, LogMethod.tap);
      expect(s.pendingCount, 0);
      expect(s.restEndsAt, env.clock.now.add(const Duration(seconds: 90)));
      expect(env.notifications.restEnd, s.restEndsAt);
      expect(s.restRemaining(env.clock.now), 90);
      expect(s.currentIndex, 0, reason: 'one more set of push-ups to go');
    });

    test('rest counts down from wall-clock time and survives time passing in the background', () async {
      final c = env.container();
      addTearDown(c.dispose);
      final controller = c.read(activeSessionProvider.notifier);
      await c.read(activeSessionProvider.future);
      await controller.start('Push', plan);
      await controller.logSet(8, LogMethod.done, restText);

      env.clock.advance(const Duration(seconds: 30));
      expect(
        c.read(activeSessionProvider).value!.restRemaining(env.clock.now),
        60,
      );

      await controller.adjustRest(
        15,
        restText,
        sessionExerciseId: c
            .read(activeSessionProvider)
            .value!
            .exercises
            .first
            .id,
      );
      var s = c.read(activeSessionProvider).value!;
      expect(s.restRemaining(env.clock.now), 75);
      expect(
        s.exercises.first.restSec,
        105,
        reason: 'the new rest length is remembered',
      );
      expect(env.notifications.restEnd, s.restEndsAt);

      env.clock.advance(const Duration(minutes: 5)); // phone was in the pocket
      expect(s.restRemaining(env.clock.now), 0);
      await controller.completeRest();
      s = c.read(activeSessionProvider).value!;
      expect(s.restEndsAt, isNull);
    });

    test('skip rest cancels the alert', () async {
      final c = env.container();
      addTearDown(c.dispose);
      final controller = c.read(activeSessionProvider.notifier);
      await c.read(activeSessionProvider.future);
      await controller.start('Push', plan);
      await controller.logSet(8, LogMethod.done, restText);
      await controller.skipRest();
      expect(c.read(activeSessionProvider).value!.restEndsAt, isNull);
      expect(env.notifications.restEnd, isNull);
    });

    test('moves to the next exercise when one is complete; no rest after the final set', () async {
      final c = env.container();
      addTearDown(c.dispose);
      final controller = c.read(activeSessionProvider.notifier);
      await c.read(activeSessionProvider.future);
      await controller.start('Push', plan);
      await controller.logSet(10, LogMethod.done, restText);
      await controller.logSet(9, LogMethod.done, restText);
      var s = c.read(activeSessionProvider).value!;
      expect(s.currentIndex, 1, reason: 'push-ups done, plank is next');
      expect(s.restEndsAt, isNotNull);

      await controller.skipRest();
      await controller.logSet(40, LogMethod.timer, restText);
      s = c.read(activeSessionProvider).value!;
      expect(s.allComplete, isTrue);
      expect(s.restEndsAt, isNull);
      expect(env.notifications.restEnd, isNull);
    });

    test(
      'RIR / RPE are stored on the set; undo removes the last set',
      () async {
        final c = env.container();
        addTearDown(c.dispose);
        final controller = c.read(activeSessionProvider.notifier);
        await c.read(activeSessionProvider.future);
        await controller.start('Push', plan);
        final id = (await controller.logSet(10, LogMethod.manual, restText))!;
        await controller.setEffort(id, rir: 2);
        expect(
          c.read(activeSessionProvider).value!.exercises.first.sets.single.rir,
          2,
        );
        await controller.setEffort(id, rpe: 8.5);
        final set = c
            .read(activeSessionProvider)
            .value!
            .exercises
            .first
            .sets
            .single;
        expect(set.rpe, 8.5);
        expect(set.rir, isNull);

        await controller.undoLastSet(0);
        final s = c.read(activeSessionProvider).value!;
        expect(s.exercises.first.sets, isEmpty);
        expect(s.restEndsAt, isNull);
      },
    );

    test(
      'finish moves the workout to history; an empty workout is dropped',
      () async {
        final c = env.container();
        addTearDown(c.dispose);
        final controller = c.read(activeSessionProvider.notifier);
        await c.read(activeSessionProvider.future);

        await controller.start('Empty', plan);
        await controller.finish();
        expect(await WorkoutRepository(env.db).history(), isEmpty);

        await controller.start('Push', plan);
        await controller.logSet(10, LogMethod.done, restText);
        env.clock.advance(const Duration(minutes: 12));
        await controller.finish();
        expect(c.read(activeSessionProvider).value, isNull);
        final history = await WorkoutRepository(env.db).history();
        expect(history.single.name, 'Push');
        expect(history.single.totalSets, 1);
        expect(history.single.duration, const Duration(minutes: 12));
        expect(await WorkoutRepository(env.db).loadActive(), isNull);
      },
    );

    test('app killed mid-workout: a fresh app instance restores sets, counter, position and rest', () async {
      final first = env.container();
      final controller = first.read(activeSessionProvider.notifier);
      await first.read(activeSessionProvider.future);
      await controller.start('Push', plan);
      await controller.logSet(10, LogMethod.done, restText);
      await controller.skipRest();
      await controller.logSet(
        9,
        LogMethod.done,
        restText,
      ); // -> rest running, plank queued
      controller.setPendingCount(3);
      await Future<void>.delayed(
        Duration.zero,
      ); // let the background write land
      final restEnd = first.read(activeSessionProvider).value!.restEndsAt;
      first.dispose(); // "kill" the app; nothing in memory survives

      final second = env.container();
      addTearDown(second.dispose);
      final restored = (await second.read(activeSessionProvider.future))!;
      expect(restored.name, 'Push');
      expect(restored.exercises.first.sets.map((s) => s.value), [10, 9]);
      expect(restored.currentIndex, 1);
      expect(restored.pendingCount, 3);
      expect(restored.restEndsAt, restEnd);
      expect(restored.finishedAt, isNull);
    });
  });

  group('encrypted database file', () {
    late Directory dir;
    setUp(() => dir = Directory.systemTemp.createTempSync('solo_db_test'));
    tearDown(() => dir.deleteSync(recursive: true));

    test('data survives a restart with the stored key and is unreadable without it', () async {
      final file = File('${dir.path}/app.db');
      final keyStore = MemoryKeyStore();

      var db = AppDatabase(
        await openAppExecutor(file: file, keyStore: keyStore),
      );
      await ProfileRepository(db).save(testProfile, const [
        Injury(joint: Joint.lowerBack, severity: Severity.severe),
      ]);
      final id = await WorkoutRepository(db)
          .createSession('Secret session', plan, now: DateTime(2026, 1, 5));
      await db.close();
      expect(keyStore.key, hasLength(64));

      // Restart: same key -> everything is back.
      db = AppDatabase(await openAppExecutor(file: file, keyStore: keyStore));
      expect((await WorkoutRepository(db).load(id))!.name, 'Secret session');
      expect(
        (await ProfileRepository(db).loadInjuries()).single.severity,
        Severity.severe,
      );
      await db.close();

      // On disk: not a plain SQLite file, and no readable content.
      final bytes = file.readAsBytesSync();
      final raw = String.fromCharCodes(bytes);
      expect(raw.startsWith('SQLite format 3'), isFalse);
      for (final needle in [
        'Secret session',
        'push_up',
        'lowerBack',
        'severe',
      ]) {
        expect(raw.contains(needle), isFalse, reason: needle);
      }

      // Wrong key or missing key -> locked, never silently recreated.
      final wrong = MemoryKeyStore()..key = generateHexKey();
      await expectLater(
        openAppExecutor(file: file, keyStore: wrong),
        throwsA(isA<DatabaseLockedException>()),
      );
      await expectLater(
        openAppExecutor(file: file, keyStore: MemoryKeyStore()),
        throwsA(isA<DatabaseLockedException>()),
      );

      // Reset path: wipes file and key, then a new database can be created.
      await wipeAppData(file: file, keyStore: keyStore);
      expect(file.existsSync(), isFalse);
      expect(keyStore.key, isNull);
      db = AppDatabase(await openAppExecutor(file: file, keyStore: keyStore));
      expect(await WorkoutRepository(db).loadActive(), isNull);
      await db.close();
    });
  });
}
