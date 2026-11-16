import 'package:flutter_test/flutter_test.dart';
import 'package:solo_calisthenics/features/planner/application/planner_controller.dart';
import 'package:solo_calisthenics/features/planner/application/progression_service.dart';
import 'package:solo_calisthenics/features/planner/data/progress_repository.dart';
import 'package:solo_calisthenics/features/planner/domain/progression_engine.dart';
import 'package:solo_calisthenics/features/planner/domain/weekly_planner.dart';
import 'package:solo_calisthenics/features/workout/application/active_session_controller.dart';
import 'package:solo_calisthenics/features/workout/domain/workout_models.dart';

import '../helpers.dart';

const restText = (title: 't', body: 'b');
PlannedExercise pushUps({int sets = 3}) =>
    PlannedExercise(exerciseId: 'push_up', sets: sets, targetMin: 8, targetMax: 12, restSec: 90);

void main() {
  late TestEnv env;
  late ProgressRepository repo;
  setUp(() {
    env = TestEnv();
    repo = ProgressRepository(env.db);
  });
  tearDown(() => env.db.close());

  /// Runs a whole workout through the real controller, like the UI does.
  Future<List<ProgressionChange>> workout(
    dynamic container,
    List<int> reps, {
    int? rir,
    PlanLink? link,
    PlannedExercise? exercise,
  }) async {
    final c = container.read(activeSessionProvider.notifier) as ActiveSessionController;
    await container.read(activeSessionProvider.future);
    await c.start('Push', [exercise ?? pushUps()], link: link);
    for (final r in reps) {
      final id = await c.logSet(r, LogMethod.manual, restText);
      if (rir != null) await c.setEffort(id!, rir: rir);
      await c.skipRest();
    }
    env.clock.advance(const Duration(days: 2));
    return c.finish();
  }

  test('two top-of-range sessions in a row unlock the next exercise and record a milestone', () async {
    final c = env.container();
    addTearDown(c.dispose);
    await repo.saveChainState(const ChainState(chainId: 'push_up', exerciseId: 'push_up'), now: env.clock.now);

    expect(await workout(c, [12, 12, 12]), isEmpty, reason: 'first session only builds the streak');
    expect((await repo.chainStates())['push_up']!.successStreak, 1);

    final changes = await workout(c, [12, 12, 12]);
    expect(changes.single.action, ProgressionAction.advance);
    expect(changes.single.newExerciseId, 'diamond_push_up');
    expect((await repo.chainStates())['push_up']!.exerciseId, 'diamond_push_up');
    final milestones = await repo.milestones();
    expect(milestones.single.exerciseId, 'diamond_push_up');
    expect(milestones.single.chainId, 'push_up');
  });

  test('logged RIR feeds the decision: an easy top session advances at once', () async {
    final c = env.container();
    addTearDown(c.dispose);
    await repo.saveChainState(const ChainState(chainId: 'push_up', exerciseId: 'push_up'), now: env.clock.now);
    final changes = await workout(c, [12, 12, 12], rir: 4);
    expect(changes.single.action, ProgressionAction.advance);
  });

  test('RPE is converted to RIR', () {
    SetLog set({int? rir, double? rpe}) =>
        SetLog(id: 1, setNumber: 1, value: 10, method: LogMethod.done, loggedAt: DateTime(2026), rir: rir, rpe: rpe);
    expect(averageRir([set(rpe: 7), set(rpe: 9)]), 2);
    expect(averageRir([set(rir: 1), set()]), 1, reason: 'unrated sets are ignored');
    expect(averageRir([set()]), isNull);
  });

  test('training an easier exercise than the current level does not move the chain', () async {
    final c = env.container();
    addTearDown(c.dispose);
    await repo.saveChainState(const ChainState(chainId: 'push_up', exerciseId: 'diamond_push_up'), now: env.clock.now);
    await workout(c, [12, 12, 12]);
    await workout(c, [12, 12, 12]);
    final s = (await repo.chainStates())['push_up']!;
    expect(s.exerciseId, 'diamond_push_up');
    expect(s.successStreak, 0);
  });

  test('deload sessions never change progress', () async {
    final c = env.container();
    addTearDown(c.dispose);
    await repo.saveChainState(
      const ChainState(chainId: 'push_up', exerciseId: 'push_up', successStreak: 1),
      now: env.clock.now,
    );
    final changes = await workout(
      c,
      [12, 12],
      exercise: pushUps(sets: 2),
      link: const PlanLink(week: '2026-01-05', dayIndex: 0, isDeload: true),
    );
    expect(changes, isEmpty);
    final s = (await repo.chainStates())['push_up']!;
    expect(s.exerciseId, 'push_up');
    expect(s.successStreak, 1);
  });

  test('performance dropping two sessions in a row starts a lighter week', () async {
    final c = env.container();
    addTearDown(c.dispose);
    await c.read(plannerProvider.notifier).configure(
          daysPerWeek: 3,
          sessionMinutes: 45,
          focusSkills: const {},
          deloadEveryWeeks: 6,
        );
    await repo.saveChainState(const ChainState(chainId: 'push_up', exerciseId: 'push_up'), now: env.clock.now);
    expect((await c.read(plannerProvider.future))!.week.isDeload, isFalse);

    await workout(c, [11, 10, 10]); // baseline: 31 reps
    await workout(c, [9, 9, 8]); // 26: first drop
    expect((await repo.chainStates())['push_up']!.dropStreak, 1);
    expect((await c.read(plannerProvider.future))!.week.isDeload, isFalse);

    await workout(c, [8, 8, 6]); // 22: second drop in a row
    final planner = (await c.read(plannerProvider.future))!;
    expect(planner.week.isDeload, isTrue);
    expect(DeloadPolicy.isActive(env.clock.now, planner.config.lastDeloadStart), isTrue);
    expect((await repo.chainStates())['push_up']!.dropStreak, 0, reason: 'reset once the deload is triggered');
  });

  test('scheduled deload: the planner switches to a lighter week by itself and back again', () async {
    final c = env.container();
    addTearDown(c.dispose);
    await c.read(plannerProvider.notifier).configure(
          daysPerWeek: 3,
          sessionMinutes: 45,
          focusSkills: const {},
          deloadEveryWeeks: 4,
        );
    expect((await c.read(plannerProvider.future))!.week.isDeload, isFalse);

    env.clock.advance(const Duration(days: 28)); // start of week 5
    c.invalidate(plannerProvider);
    final light = (await c.read(plannerProvider.future))!;
    expect(light.week.isDeload, isTrue);
    expect((await repo.planConfig())!.lastDeloadStart, DeloadPolicy.mondayOf(env.clock.now));

    env.clock.advance(const Duration(days: 7));
    c.invalidate(plannerProvider);
    expect((await c.read(plannerProvider.future))!.week.isDeload, isFalse);
  });

  test('plan days are ticked off when their session is finished, and the next day moves on', () async {
    final c = env.container();
    addTearDown(c.dispose);
    await c.read(plannerProvider.notifier).configure(
          daysPerWeek: 3,
          sessionMinutes: 45,
          focusSkills: const {},
          deloadEveryWeeks: 5,
        );
    var planner = (await c.read(plannerProvider.future))!;
    expect(planner.completedDays, isEmpty);
    final first = planner.nextDay!; // clock starts on Monday 5 Jan 2026
    expect(first.index, 0);

    final controller = c.read(activeSessionProvider.notifier);
    await controller.start(
      'Day',
      first.exercises,
      link: PlanLink(week: DeloadPolicy.weekKey(env.clock.now), dayIndex: first.index, isDeload: false),
    );
    await controller.logSet(5, LogMethod.done, restText);
    await controller.finish();

    planner = (await c.read(plannerProvider.future))!;
    expect(planner.completedDays, {0});
    expect(planner.nextDay!.index, 1);
  });

  test('editing the plan keeps its start date; plan config round-trips', () async {
    final c = env.container();
    addTearDown(c.dispose);
    final notifier = c.read(plannerProvider.notifier);
    await notifier.configure(daysPerWeek: 4, sessionMinutes: 60, focusSkills: {'handstand'}, deloadEveryWeeks: 6);
    final started = (await repo.planConfig())!.startedAt;
    env.clock.advance(const Duration(days: 10));
    await notifier.configure(daysPerWeek: 5, sessionMinutes: 30, focusSkills: {'planche'}, deloadEveryWeeks: 4);
    final saved = (await repo.planConfig())!;
    expect(saved.startedAt, started);
    expect(saved.daysPerWeek, 5);
    expect(saved.sessionMinutes, 30);
    expect(saved.focusSkills, {'planche'});
    expect(saved.deloadEveryWeeks, 4);
    // Placement was stored when the plan was first created.
    expect((await repo.chainStates()).length, env.library.chains.length);
  });
}
