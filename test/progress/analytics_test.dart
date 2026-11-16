import 'package:flutter_test/flutter_test.dart';
import 'package:solo_calisthenics/features/progress/data/analytics_repository.dart';
import 'package:solo_calisthenics/features/workout/data/workout_repository.dart';
import 'package:solo_calisthenics/features/workout/domain/workout_models.dart';

import '../helpers.dart';

void main() {
  late TestEnv env;
  late WorkoutRepository workouts;
  late AnalyticsRepository analytics;
  setUp(() {
    env = TestEnv();
    workouts = WorkoutRepository(env.db);
    analytics = AnalyticsRepository(env.db);
  });
  tearDown(() => env.db.close());

  Future<void> session(DateTime day, Map<String, List<int>> sets, {bool finish = true}) async {
    final id = await workouts.createSession(
      'S',
      [
        for (final e in sets.keys)
          PlannedExercise(exerciseId: e, sets: sets[e]!.length, targetMin: 1, targetMax: 99, restSec: 60),
      ],
      now: day,
    );
    final s = (await workouts.load(id))!;
    for (final ex in s.exercises) {
      for (final v in sets[ex.exerciseId]!) {
        await workouts.addSet(
          sessionId: id,
          sessionExerciseId: ex.id,
          value: v,
          method: LogMethod.manual,
          now: day,
          restSec: 0,
        );
      }
    }
    if (finish) await workouts.finish(id, now: day.add(const Duration(minutes: 40)));
  }

  test('empty history gives eight empty weeks and zeros', () async {
    final a = await analytics.load(now: DateTime(2026, 3, 4));
    expect(a.weeks.length, AnalyticsRepository.weeksShown);
    expect(a.weeks.every((w) => w.workouts == 0 && w.sets == 0), isTrue);
    expect(a.weeks.last.weekStart, DateTime.utc(2026, 3, 2));
    expect(a.totalWorkouts, 0);
    expect(a.weekStreak, 0);
    expect(a.trends, isEmpty);
  });

  test('weekly consistency, set volume, streak and best-set trends', () async {
    final now = DateTime(2026, 3, 4); // Wednesday; this week starts Mon 2 Mar
    await session(DateTime(2026, 2, 3), {'push_up': [8, 8, 7]}); // 4 weeks ago
    // (week of 9 Feb has no workout: breaks the streak)
    await session(DateTime(2026, 2, 17), {'push_up': [9, 9, 8], 'plank': [30, 30]});
    await session(DateTime(2026, 2, 19), {'push_up': [10, 9, 9]});
    await session(DateTime(2026, 2, 24), {'push_up': [12, 10, 10], 'plank': [45, 40]});
    await session(DateTime(2026, 3, 3), {'pull_up': [5, 4]});
    await session(DateTime(2026, 3, 4), {'pull_up': [9]}, finish: false); // still running: not counted

    final a = await analytics.load(now: now);
    expect(a.totalWorkouts, 5);
    expect(a.weeks.map((w) => w.workouts), [0, 0, 0, 1, 0, 2, 1, 1]);
    expect(a.weeks.map((w) => w.sets), [0, 0, 0, 3, 0, 8, 5, 2]);
    expect(a.weekStreak, 3);

    final push = a.trends.firstWhere((t) => t.exerciseId == 'push_up');
    expect(push.sessions, 4);
    expect(push.firstBest, 8);
    expect(push.latestBest, 12);
    expect(push.change, 4);
    final plank = a.trends.firstWhere((t) => t.exerciseId == 'plank');
    expect((plank.firstBest, plank.latestBest), (30, 45));
    expect(a.trends.any((t) => t.exerciseId == 'pull_up'), isFalse, reason: 'needs two sessions');
    expect(a.trends.first.exerciseId, 'push_up', reason: 'most trained first');
  });

  test('an empty current week does not break the streak yet', () async {
    await session(DateTime(2026, 2, 17), {'push_up': [8]});
    await session(DateTime(2026, 2, 24), {'push_up': [8]});
    expect((await analytics.load(now: DateTime(2026, 3, 2))).weekStreak, 2);
    expect((await analytics.load(now: DateTime(2026, 3, 9))).weekStreak, 0);
  });

  test('photos: metadata list is newest first, bytes load by id, delete works', () async {
    final a = await analytics.addPhoto(tinyPng, takenAt: DateTime(2026, 1, 1), weightKg: 80);
    final b = await analytics.addPhoto(tinyPng, takenAt: DateTime(2026, 2, 1));
    final list = await analytics.photos();
    expect(list.map((p) => p.id), [b, a]);
    expect(list.last.weightKg, 80);
    expect(await analytics.photoBytes(a), tinyPng);
    await analytics.deletePhoto(a);
    expect((await analytics.photos()).single.id, b);
    expect(await analytics.photoBytes(a), isNull);
  });
}
