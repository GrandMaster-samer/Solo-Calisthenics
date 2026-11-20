import 'package:flutter_test/flutter_test.dart';
import 'package:solo_calisthenics/features/exercises/domain/injury_filter.dart';
import 'package:solo_calisthenics/features/planner/domain/placement.dart';
import 'package:solo_calisthenics/features/planner/domain/progression_engine.dart';
import 'package:solo_calisthenics/features/planner/domain/weekly_planner.dart';
import 'package:solo_calisthenics/features/profile/domain/profile.dart';

import '../helpers.dart';

void main() {
  final library = loadLibrary();
  final monday = DateTime.utc(2026, 1, 5);

  PlanConfig config({
    int days = 3,
    int minutes = 45,
    Set<String> skills = const {},
  }) => PlanConfig(
    daysPerWeek: days,
    sessionMinutes: minutes,
    focusSkills: skills,
    startedAt: monday,
  );

  WeekPlan build(
    PlanConfig c, {
    UserProfile profile = testProfile,
    List<Injury> injuries = const [],
    bool deload = false,
    Map<String, ChainState>? states,
  }) => WeeklyPlanner.build(
    config: c,
    library: library,
    profile: profile,
    injuries: injuries,
    states: states ?? WeeklyPlanner.placeMissing(const {}, library, profile),
    weekStart: monday,
    isDeload: deload,
  );

  test(
    '2 to 6 training days produce that many sessions on distinct weekdays',
    () {
      for (var d = PlanConfig.minDays; d <= PlanConfig.maxDays; d++) {
        final week = build(config(days: d));
        expect(week.days.length, d);
        expect(week.days.map((x) => x.weekday).toSet().length, d);
        for (final day in week.days) {
          expect(
            day.exercises,
            isNotEmpty,
            reason: '$d days, day ${day.index}',
          );
        }
      }
    },
  );

  test('splits: full body for 2 days and for beginners on 3; push/pull/legs otherwise', () {
    expect(WeeklyPlanner.split(2, Experience.advanced), [
      DayType.fullBody,
      DayType.fullBody,
    ]);
    expect(WeeklyPlanner.split(3, Experience.beginner).toSet(), {
      DayType.fullBody,
    });
    expect(WeeklyPlanner.split(3, Experience.intermediate), [
      DayType.push,
      DayType.pull,
      DayType.legsCore,
    ]);
    expect(
      WeeklyPlanner.split(
        6,
        Experience.intermediate,
      ).where((t) => t == DayType.legsCore).length,
      2,
    );
  });

  test(
    'a longer session holds more work, and estimates respect the chosen length',
    () {
      final short = build(config(minutes: 20));
      final long = build(config(minutes: 90));
      for (var i = 0; i < short.days.length; i++) {
        expect(
          long.days[i].exercises.length,
          greaterThanOrEqualTo(short.days[i].exercises.length),
        );
      }
      expect(
        long.days.fold<int>(0, (s, d) => s + d.exercises.length),
        greaterThan(short.days.fold<int>(0, (s, d) => s + d.exercises.length)),
      );
      for (final day in long.days) {
        expect(day.estimatedMinutes, lessThanOrEqualTo(90));
      }
    },
  );

  test(
    'skill work appears only when chosen, and comes first in the session',
    () {
      bool hasChain(WeekPlan w, String chain) => w.days.any(
        (d) => d.exercises.any(
          (e) => library.byId(e.exerciseId)!.chainId == chain,
        ),
      );
      expect(hasChain(build(config(minutes: 60)), 'handstand'), isFalse);
      final withSkill = build(config(minutes: 60, skills: {'handstand'}));
      expect(hasChain(withSkill, 'handstand'), isTrue);
      final pushDay = withSkill.days.firstWhere((d) => d.type == DayType.push);
      expect(
        library.byId(pushDay.exercises.first.exerciseId)!.chainId,
        'handstand',
      );
    },
  );

  test('the plan never contains an excluded exercise, for any injury', () {
    for (final joint in Joint.values) {
      for (final severity in Severity.values) {
        final injuries = [Injury(joint: joint, severity: severity)];
        for (final experience in Experience.values) {
          final profile = UserProfile(
            birthYear: 1990,
            heightCm: 180,
            weightKg: 80,
            experience: experience,
          );
          final week = build(
            config(
              days: 6,
              minutes: 90,
              skills: PlanConfig.skillChoices.toSet(),
            ),
            profile: profile,
            injuries: injuries,
          );
          for (final day in week.days) {
            for (final e in day.exercises) {
              expect(
                InjuryFilter.isExcluded(library.byId(e.exerciseId)!, injuries),
                isFalse,
                reason:
                    '${joint.name}/${severity.name}/${experience.name}: ${e.exerciseId}',
              );
            }
          }
        }
      }
    }
  });

  test('mild limitation caps sets in the plan', () {
    final week = build(
      config(minutes: 90),
      injuries: const [Injury(joint: Joint.shoulders, severity: Severity.mild)],
    );
    final dips = week.days
        .expand((d) => d.exercises)
        .where((e) => library.byId(e.exerciseId)!.chainId == 'dip');
    expect(dips, isNotEmpty);
    for (final e in dips) {
      expect(e.sets, InjuryFilter.mildSetCap);
    }
  });

  test('the plan follows the current level and goals of each chain', () {
    final states = WeeklyPlanner.placeMissing(const {}, library, testProfile);
    states['push_up'] = const ChainState(
      chainId: 'push_up',
      exerciseId: 'diamond_push_up',
    );
    states['plank'] = const ChainState(
      chainId: 'plank',
      exerciseId: 'plank',
      holdTarget: 40,
    );
    final all = build(
      config(minutes: 90),
      states: states,
    ).days.expand((d) => d.exercises).toList();
    expect(all.any((e) => e.exerciseId == 'diamond_push_up'), isTrue);
    final plank = all.firstWhere((e) => e.exerciseId == 'plank');
    expect(
      plank.targetMin,
      40,
      reason: 'hold goal carried into the prescription',
    );
  });

  test('deload week: fewer sets and easier targets, same exercises', () {
    final normal = build(config(minutes: 60));
    final light = build(config(minutes: 60), deload: true);
    expect(light.isDeload, isTrue);
    final normalSets = <String, int>{
      for (final e in normal.days.expand((d) => d.exercises))
        e.exerciseId: e.sets,
    };
    var reduced = 0;
    for (final e in light.days.expand((d) => d.exercises)) {
      final def = library.byId(e.exerciseId)!;
      expect(e.sets, lessThanOrEqualTo(def.defaultSets));
      expect(
        e.targetMax,
        lessThanOrEqualTo((def.targetMin + def.targetMax) ~/ 2),
      );
      if (normalSets[e.exerciseId] != null &&
          e.sets < normalSets[e.exerciseId]!) {
        reduced++;
      }
    }
    expect(reduced, greaterThan(0));
  });

  group('placement from the baseline test', () {
    UserProfile p({
      int? push,
      int? pull,
      int? hang,
      int? plank,
      Experience exp = Experience.intermediate,
    }) => UserProfile(
      birthYear: 1990,
      heightCm: 180,
      weightKg: 80,
      experience: exp,
      maxPushUps: push,
      maxPullUps: pull,
      maxDeadHangSec: hang,
      maxPlankSec: plank,
    );

    test('push-ups', () {
      final chain = library.chain('push_up');
      expect(Placement.start(chain, p(push: 0)).id, 'wall_push_up');
      expect(Placement.start(chain, p(push: 7)).id, 'knee_push_up');
      expect(Placement.start(chain, p(push: 15)).id, 'push_up');
      expect(Placement.start(chain, p(push: 60)).id, 'archer_push_up');
    });

    test('pull-ups use the dead hang when no pull-up is possible yet', () {
      final chain = library.chain('pull_up');
      expect(Placement.start(chain, p(pull: 0, hang: 10)).id, 'dead_hang');
      expect(
        Placement.start(chain, p(pull: 0, hang: 40)).id,
        'scapular_pull_up',
      );
      expect(Placement.start(chain, p(pull: 4)).id, 'chin_up');
      expect(Placement.start(chain, p(pull: 8)).id, 'pull_up');
    });

    test('a test result beats the experience level; without one, experience decides', () {
      final chain = library.chain('push_up');
      expect(
        Placement.start(chain, p(push: 2, exp: Experience.advanced)).id,
        'incline_push_up',
      );
      final levels = [
        for (final e in Experience.values)
          Placement.start(chain, p(exp: e)).level,
      ];
      expect(levels[0], lessThan(levels[2]));
    });

    test('skill chains start at the first step for beginners', () {
      for (final id in ['planche', 'front_lever', 'handstand', 'muscle_up']) {
        expect(
          Placement.start(library.chain(id), p(exp: Experience.beginner)).level,
          1,
          reason: id,
        );
      }
    });
  });

  group('deload schedule', () {
    PlanConfig c({DateTime? last, int every = 5}) => PlanConfig(
      daysPerWeek: 3,
      sessionMinutes: 45,
      focusSkills: const {},
      startedAt: DateTime(2026, 1, 7), // a Wednesday; week starts Mon 5 Jan
      deloadEveryWeeks: every,
      lastDeloadStart: last,
    );

    test('not due during the first N weeks, due in week N+1', () {
      expect(DeloadPolicy.isDue(DateTime(2026, 1, 7), c()), isFalse);
      expect(
        DeloadPolicy.isDue(DateTime(2026, 2, 8), c()),
        isFalse,
      ); // last day of week 5
      expect(
        DeloadPolicy.isDue(DateTime(2026, 2, 9), c()),
        isTrue,
      ); // Monday of week 6
      expect(DeloadPolicy.isDue(DateTime(2026, 2, 2), c(every: 4)), isTrue);
    });

    test('a deload lasts 7 days, then the count restarts after it', () {
      final start = DateTime.utc(2026, 2, 9);
      expect(DeloadPolicy.isActive(DateTime(2026, 2, 9), start), isTrue);
      expect(DeloadPolicy.isActive(DateTime(2026, 2, 15, 23), start), isTrue);
      expect(DeloadPolicy.isActive(DateTime(2026, 2, 16), start), isFalse);
      expect(
        DeloadPolicy.isDue(DateTime(2026, 2, 12), c(last: start)),
        isFalse,
        reason: 'already in it',
      );
      expect(
        DeloadPolicy.isDue(DateTime(2026, 3, 16), c(last: start)),
        isFalse,
      ); // week 5 after
      expect(DeloadPolicy.isDue(DateTime(2026, 3, 23), c(last: start)), isTrue);
    });

    test('week key is the Monday of the week', () {
      expect(
        DeloadPolicy.weekKey(DateTime(2026, 1, 11, 22)),
        '2026-01-05',
      ); // Sunday night
      expect(DeloadPolicy.weekKey(DateTime(2026, 1, 12)), '2026-01-12');
    });
  });
}
