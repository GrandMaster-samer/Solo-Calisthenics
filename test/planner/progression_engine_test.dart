import 'package:flutter_test/flutter_test.dart';
import 'package:solo_calisthenics/features/exercises/domain/exercise.dart';
import 'package:solo_calisthenics/features/planner/domain/progression_engine.dart';

import '../helpers.dart';

// fakeExercise: range 5-10, 3 sets.
final reps = fakeExercise('mid');
final hold = fakeExercise('hold', type: ExerciseType.hold); // 5-10 s, step 5

Performance perf(List<int> values, {double? rir, int sets = 3}) =>
    Performance(values: values, targetSets: sets, avgRir: rir);

ProgressionResult run(
  ChainState s,
  Performance p, {
  Exercise? exercise,
  Performance? previous,
  String? next = 'hard',
  String? prev = 'easy',
}) => ProgressionEngine.evaluate(
  state: s,
  exercise: exercise ?? reps,
  performance: p,
  previous: previous,
  nextExerciseId: next,
  previousExerciseId: prev,
);

void main() {
  const start = ChainState(chainId: 'chain', exerciseId: 'mid');
  const holdStart = ChainState(chainId: 'chain', exerciseId: 'hold');

  group('rep exercises: double progression', () {
    test('top of the range on all sets once: repeat, streak 1', () {
      final r = run(start, perf([10, 10, 10]));
      expect(r.action, ProgressionAction.repeat);
      expect(r.state.successStreak, 1);
      expect(r.state.exerciseId, 'mid');
    });

    test(
      'top of the range on all sets for 2 consecutive sessions: advance',
      () {
        final first = run(start, perf([10, 10, 10])).state;
        final r = run(first, perf([10, 11, 10]));
        expect(r.action, ProgressionAction.advance);
        expect(r.state.exerciseId, 'hard');
        expect(r.state.successStreak, 0, reason: 'new exercise starts clean');
      },
    );

    test('the two sessions must be consecutive', () {
      var s = run(start, perf([10, 10, 10])).state;
      s = run(s, perf([10, 9, 8])).state; // missed the top on later sets
      expect(s.successStreak, 0);
      final r = run(s, perf([10, 10, 10]));
      expect(r.action, ProgressionAction.repeat);
    });

    test('one set short of the top does not count', () {
      expect(run(start, perf([10, 10, 9])).state.successStreak, 0);
    });

    test('skipping a prescribed set does not count, even at the top', () {
      expect(run(start, perf([10, 10])).state.successStreak, 0);
    });

    test('RIR 3+ at the top advances after a single session', () {
      final r = run(start, perf([10, 10, 10], rir: 3));
      expect(r.action, ProgressionAction.advance);
    });

    test('RIR below 3 at the top still needs two sessions', () {
      expect(
        run(start, perf([10, 10, 10], rir: 1)).action,
        ProgressionAction.repeat,
      );
    });

    test('end of the chain: add reps instead of advancing', () {
      final first = run(start, perf([10, 10, 10]), next: null).state;
      final r = run(first, perf([10, 10, 10]), next: null);
      expect(r.action, ProgressionAction.increaseTarget);
      expect(r.state.exerciseId, 'mid');
      expect(r.state.bonus, ProgressionEngine.repStep);
      expect(ProgressionEngine.range(reps, r.state), (min: 7, max: 12));
      // The old top is no longer enough.
      expect(
        run(r.state, perf([10, 10, 10]), next: null).state.successStreak,
        0,
      );
    });

    test('below the bottom of the range twice in a row: regress', () {
      final first = run(start, perf([4, 3, 3]));
      expect(first.action, ProgressionAction.repeat);
      expect(first.state.failStreak, 1);
      final r = run(first.state, perf([3, 3, 2]));
      expect(r.action, ProgressionAction.regress);
      expect(r.state.exerciseId, 'easy');
    });

    test('a normal session in between clears the fail streak', () {
      var s = run(start, perf([4, 4, 4])).state;
      s = run(s, perf([7, 6, 6])).state;
      expect(s.failStreak, 0);
      expect(run(s, perf([4, 4, 4])).action, ProgressionAction.repeat);
    });

    test('first exercise of a chain cannot regress', () {
      final first = run(start, perf([2, 2, 2]), prev: null).state;
      final r = run(first, perf([2, 2, 2]), prev: null);
      expect(r.action, ProgressionAction.repeat);
      expect(r.state.exerciseId, 'mid');
    });

    test('inside the range: repeat with no streaks', () {
      final r = run(start, perf([8, 7, 6]));
      expect(r.action, ProgressionAction.repeat);
      expect(r.state.successStreak, 0);
      expect(r.state.failStreak, 0);
    });

    test('nothing logged changes nothing', () {
      final s = start.copyWith(successStreak: 1);
      final r = run(s, perf([]));
      expect(r.action, ProgressionAction.repeat);
      expect(r.state.successStreak, 1);
    });
  });

  group('static holds', () {
    test('hitting the hold goal on every set raises the goal by one step', () {
      expect(ProgressionEngine.holdGoal(hold, holdStart), 5);
      final r = run(holdStart, perf([5, 6, 5]), exercise: hold);
      expect(r.action, ProgressionAction.increaseTarget);
      expect(r.state.holdTarget, 10);
      expect(r.state.exerciseId, 'hold');
    });

    test('missing the goal on one set keeps the goal', () {
      final r = run(holdStart, perf([5, 5, 4]), exercise: hold);
      expect(r.action, ProgressionAction.repeat);
      expect(ProgressionEngine.holdGoal(hold, r.state), 5);
    });

    test(
      'holding the top of the range for 2 consecutive sessions advances',
      () {
        final atTop = holdStart.copyWith(holdTarget: () => 10);
        final first = run(atTop, perf([10, 10, 10]), exercise: hold);
        expect(first.action, ProgressionAction.repeat);
        final r = run(first.state, perf([12, 10, 10]), exercise: hold);
        expect(r.action, ProgressionAction.advance);
        expect(r.state.exerciseId, 'hard');
        expect(
          r.state.holdTarget,
          isNull,
          reason: 'the next exercise starts at its own minimum',
        );
      },
    );

    test('3x10s -> 3x20s style stepping uses 10 s steps on long ranges', () {
      final long = fakeExercise(
        'long',
        type: ExerciseType.hold,
      ); // 5-10 default
      expect(ProgressionEngine.holdStep(long), 5);
      final plank = loadLibrary().byId('plank')!; // 20-60 s
      expect(ProgressionEngine.holdStep(plank), 10);
      final r = ProgressionEngine.evaluate(
        state: const ChainState(chainId: 'plank', exerciseId: 'plank'),
        exercise: plank,
        performance: perf([20, 22, 20]),
      );
      expect(r.state.holdTarget, 30);
    });

    test('far below the goal twice: the goal steps down before the exercise regresses', () {
      final s = holdStart.copyWith(holdTarget: () => 10);
      final first = run(s, perf([5, 4, 4]), exercise: hold);
      expect(first.state.failStreak, 1);
      final second = run(first.state, perf([6, 5, 4]), exercise: hold);
      expect(second.action, ProgressionAction.decreaseTarget);
      expect(second.state.holdTarget, 5);
      // Already at the bottom of the range: now the exercise itself regresses.
      final third = run(second.state, perf([2, 2, 2]), exercise: hold);
      final fourth = run(third.state, perf([2, 2, 2]), exercise: hold);
      expect(fourth.action, ProgressionAction.regress);
      expect(fourth.state.exerciseId, 'easy');
    });
  });

  group('volume trend (deload trigger input)', () {
    test('a drop of more than 10% versus the previous session counts', () {
      final r = run(start, perf([6, 6, 5]), previous: perf([8, 8, 8]));
      expect(r.state.dropStreak, 1);
      final again = run(r.state, perf([5, 5, 4]), previous: perf([6, 6, 5]));
      expect(again.state.dropStreak, 2);
    });

    test('a steady or better session resets the drop streak', () {
      final s = start.copyWith(dropStreak: 1);
      expect(
        run(s, perf([8, 8, 7]), previous: perf([8, 8, 8])).state.dropStreak,
        0,
      );
    });

    test('no previous session: no drop', () {
      expect(run(start, perf([5, 5, 5])).state.dropStreak, 0);
    });
  });
}
