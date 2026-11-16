import 'package:flutter_test/flutter_test.dart';
import 'package:solo_calisthenics/features/exercises/domain/exercise.dart';
import 'package:solo_calisthenics/features/exercises/domain/injury_filter.dart';
import 'package:solo_calisthenics/features/profile/domain/profile.dart';

import '../helpers.dart';

Injury injury(Joint j, Severity s) => Injury(joint: j, severity: s);

void main() {
  Exercise ex(StressLevel wrist) =>
      fakeExercise('e', stress: {Joint.wrists: wrist});

  group('exclusion matrix (severity x stress)', () {
    // Expected: is the exercise excluded?
    const expected = {
      Severity.severe: {
        StressLevel.none: false,
        StressLevel.low: false,
        StressLevel.medium: true,
        StressLevel.high: true,
      },
      Severity.moderate: {
        StressLevel.none: false,
        StressLevel.low: false,
        StressLevel.medium: false,
        StressLevel.high: true,
      },
      Severity.mild: {
        StressLevel.none: false,
        StressLevel.low: false,
        StressLevel.medium: false,
        StressLevel.high: false,
      },
    };
    for (final severity in Severity.values) {
      for (final stress in StressLevel.values) {
        test('${severity.name} + ${stress.name}', () {
          expect(
            InjuryFilter.isExcluded(ex(stress), [
              injury(Joint.wrists, severity),
            ]),
            expected[severity]![stress],
          );
        });
      }
    }
  });

  test('no injuries means every exercise is allowed', () {
    final a = InjuryFilter.assess(ex(StressLevel.high), const []);
    expect(a.status, ExerciseStatus.allowed);
    expect(a.maxSets, isNull);
    expect(a.warmUpJoints, isEmpty);
  });

  test('an injury on a joint the exercise does not load changes nothing', () {
    final a = InjuryFilter.assess(ex(StressLevel.high), [
      injury(Joint.knees, Severity.severe),
    ]);
    expect(a.status, ExerciseStatus.allowed);
  });

  test(
    'mild: allowed with warm-up; volume capped only at medium/high stress',
    () {
      final low = InjuryFilter.assess(ex(StressLevel.low), [
        injury(Joint.wrists, Severity.mild),
      ]);
      expect(low.status, ExerciseStatus.caution);
      expect(low.warmUpJoints, [Joint.wrists]);
      expect(low.maxSets, isNull);

      final high = InjuryFilter.assess(ex(StressLevel.high), [
        injury(Joint.wrists, Severity.mild),
      ]);
      expect(high.status, ExerciseStatus.caution);
      expect(high.maxSets, InjuryFilter.mildSetCap);
      expect(InjuryFilter.cappedSets(4, high), InjuryFilter.mildSetCap);
      expect(
        InjuryFilter.cappedSets(1, high),
        1,
        reason: 'the cap never adds sets',
      );
    },
  );

  test('moderate with medium stress is allowed, warmed up, and not capped', () {
    final a = InjuryFilter.assess(ex(StressLevel.medium), [
      injury(Joint.wrists, Severity.moderate),
    ]);
    expect(a.status, ExerciseStatus.caution);
    expect(a.warmUpJoints, [Joint.wrists]);
    expect(a.maxSets, isNull);
  });

  test('moderate: high-stress exercise is replaced by the nearest allowed regression', () {
    final easy = fakeExercise('easy', stress: {Joint.wrists: StressLevel.low});
    final mid = fakeExercise(
      'mid',
      stress: {Joint.wrists: StressLevel.high},
      regression: 'easy',
    );
    final hard = fakeExercise(
      'hard',
      stress: {Joint.wrists: StressLevel.high},
      regression: 'mid',
    );
    final byId = {
      for (final e in [easy, mid, hard]) e.id: e,
    };

    final a = InjuryFilter.assess(hard, [
      injury(Joint.wrists, Severity.moderate),
    ], lookup: (id) => byId[id]);
    expect(a.status, ExerciseStatus.excluded);
    expect(a.blockingJoints, [Joint.wrists]);
    expect(
      a.substituteId,
      'easy',
      reason: 'skips "mid", which is also excluded',
    );
  });

  test('no substitute when the whole chain below is excluded', () {
    final easy = fakeExercise(
      'easy',
      stress: {Joint.shoulders: StressLevel.medium},
    );
    final hard = fakeExercise(
      'hard',
      stress: {Joint.shoulders: StressLevel.high},
      regression: 'easy',
    );
    final byId = {easy.id: easy, hard.id: hard};
    final a = InjuryFilter.assess(hard, [
      injury(Joint.shoulders, Severity.severe),
    ], lookup: (id) => byId[id]);
    expect(a.isExcluded, isTrue);
    expect(a.substituteId, isNull);
  });

  test('a regression loop in bad data does not hang', () {
    final a = fakeExercise(
      'a',
      stress: {Joint.knees: StressLevel.high},
      regression: 'b',
    );
    final b = fakeExercise(
      'b',
      stress: {Joint.knees: StressLevel.high},
      regression: 'a',
    );
    final byId = {'a': a, 'b': b};
    expect(
      InjuryFilter.findSubstitute(a, [
        injury(Joint.knees, Severity.moderate),
      ], (id) => byId[id]),
      isNull,
    );
  });

  test('several injuries: the strictest one wins and all blocking joints are reported', () {
    final e = fakeExercise(
      'e',
      stress: {
        Joint.wrists: StressLevel.high,
        Joint.shoulders: StressLevel.medium,
        Joint.elbows: StressLevel.low,
      },
    );
    final a = InjuryFilter.assess(e, [
      injury(Joint.wrists, Severity.moderate), // excludes (high)
      injury(Joint.shoulders, Severity.severe), // excludes (medium)
      injury(Joint.elbows, Severity.mild), // would only warm up
    ]);
    expect(a.status, ExerciseStatus.excluded);
    expect(a.blockingJoints, [Joint.wrists, Joint.shoulders]);
  });

  group('against the bundled library', () {
    final library = loadLibrary();

    test(
      'severe wrists: planche chain is fully excluded, pull-ups stay available',
      () {
        final injuries = [injury(Joint.wrists, Severity.severe)];
        for (final e in library.chain('planche')) {
          expect(InjuryFilter.isExcluded(e, injuries), isTrue, reason: e.id);
        }
        expect(
          InjuryFilter.isExcluded(library.byId('pull_up')!, injuries),
          isFalse,
        );
      },
    );

    test(
      'moderate shoulders: dip is substituted by an easier dip-chain exercise',
      () {
        final a = InjuryFilter.assess(library.byId('dip')!, [
          injury(Joint.shoulders, Severity.moderate),
        ], lookup: library.byId);
        expect(a.isExcluded, isTrue);
        expect(a.substituteId, 'support_hold');
      },
    );

    test('severe knees never blocks upper-body pulling', () {
      final injuries = [injury(Joint.knees, Severity.severe)];
      for (final e in library.exercises.where(
        (e) => e.pattern == MovementPattern.pull,
      )) {
        expect(InjuryFilter.isExcluded(e, injuries), isFalse, reason: e.id);
      }
    });
  });
}
