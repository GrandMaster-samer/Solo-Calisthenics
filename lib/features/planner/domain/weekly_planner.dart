import '../../exercises/data/exercise_repository.dart';
import '../../exercises/domain/injury_filter.dart';
import '../../profile/domain/profile.dart';
import '../../workout/domain/workout_models.dart';
import 'placement.dart';
import 'progression_engine.dart';

enum DayType { fullBody, push, pull, legsCore, upper }

/// The user's planner choices.
class PlanConfig {
  const PlanConfig({
    required this.daysPerWeek,
    required this.sessionMinutes,
    required this.focusSkills,
    required this.startedAt,
    this.deloadEveryWeeks = 5,
    this.lastDeloadStart,
  });

  static const minDays = 2;
  static const maxDays = 6;
  static const sessionLengths = [20, 30, 45, 60, 75, 90];

  /// Chains the user can opt into as skill work.
  static const skillChoices = [
    'handstand',
    'l_sit',
    'muscle_up',
    'front_lever',
    'planche',
    'dragon_flag',
  ];

  final int daysPerWeek;
  final int sessionMinutes;

  /// Chain ids of the skills to train (subset of [skillChoices]).
  final Set<String> focusSkills;
  final DateTime startedAt;

  /// A lighter week is scheduled automatically every this many weeks (4 to 6).
  final int deloadEveryWeeks;

  /// First day of the most recent deload week.
  final DateTime? lastDeloadStart;

  PlanConfig copyWith({DateTime? Function()? lastDeloadStart}) => PlanConfig(
    daysPerWeek: daysPerWeek,
    sessionMinutes: sessionMinutes,
    focusSkills: focusSkills,
    startedAt: startedAt,
    deloadEveryWeeks: deloadEveryWeeks,
    lastDeloadStart: lastDeloadStart != null
        ? lastDeloadStart()
        : this.lastDeloadStart,
  );
}

class PlannedDay {
  const PlannedDay({
    required this.index,
    required this.weekday,
    required this.type,
    required this.exercises,
    required this.estimatedMinutes,
  });
  final int index;

  /// ISO weekday, 1 = Monday.
  final int weekday;
  final DayType type;
  final List<PlannedExercise> exercises;
  final int estimatedMinutes;
}

class WeekPlan {
  const WeekPlan({
    required this.weekStart,
    required this.isDeload,
    required this.days,
  });
  final DateTime weekStart;
  final bool isDeload;
  final List<PlannedDay> days;
}

/// Calendar helpers and the deload schedule. Dates are compared as calendar days.
abstract final class DeloadPolicy {
  static DateTime day(DateTime d) => DateTime.utc(d.year, d.month, d.day);
  static DateTime mondayOf(DateTime d) =>
      day(d).subtract(Duration(days: d.weekday - 1));

  /// yyyy-MM-dd of the Monday of [d]'s week; identifies a plan week in storage.
  static String weekKey(DateTime d) =>
      mondayOf(d).toIso8601String().substring(0, 10);

  /// A deload lasts 7 days from its start.
  static bool isActive(DateTime now, DateTime? lastDeloadStart) {
    if (lastDeloadStart == null) return false;
    final days = day(now).difference(day(lastDeloadStart)).inDays;
    return days >= 0 && days < 7;
  }

  /// Whether a scheduled deload should begin in [now]'s week.
  static bool isDue(DateTime now, PlanConfig config) {
    if (isActive(now, config.lastDeloadStart)) return false;
    final last = config.lastDeloadStart;
    // Count full training weeks since the plan started or the last deload ended.
    final anchor = last == null
        ? mondayOf(config.startedAt)
        : mondayOf(day(last).add(const Duration(days: 7)));
    final weeks = mondayOf(now).difference(anchor).inDays ~/ 7;
    return weeks >= config.deloadEveryWeeks;
  }
}

/// Builds the week's routine from the user's choices, level in each chain and injuries.
/// Deterministic: the same inputs always give the same plan.
abstract final class WeeklyPlanner {
  static const warmUpMinutes = 5;
  static const secondsPerSet = 45;
  static const minExercises = 3;

  /// Split by training days per week.
  static List<DayType> split(int days, Experience experience) => switch (days) {
    <= 2 => const [DayType.fullBody, DayType.fullBody],
    3 =>
      experience == Experience.beginner
          ? const [DayType.fullBody, DayType.fullBody, DayType.fullBody]
          : const [DayType.push, DayType.pull, DayType.legsCore],
    4 => const [DayType.push, DayType.pull, DayType.legsCore, DayType.upper],
    5 => const [
      DayType.push,
      DayType.pull,
      DayType.legsCore,
      DayType.push,
      DayType.pull,
    ],
    _ => const [
      DayType.push,
      DayType.pull,
      DayType.legsCore,
      DayType.push,
      DayType.pull,
      DayType.legsCore,
    ],
  };

  /// Training weekdays (1 = Monday), spread to leave rest days where possible.
  static List<int> weekdays(int days) => switch (days) {
    <= 2 => const [1, 4],
    3 => const [1, 3, 5],
    4 => const [1, 2, 4, 5],
    5 => const [1, 2, 3, 5, 6],
    _ => const [1, 2, 3, 4, 5, 6],
  };

  /// Chains per day type in priority order: skill work first while fresh, then main
  /// strength, then accessories and core. [variant] alternates repeated day types.
  static List<String> slots(DayType type, int variant) {
    final alt = variant.isOdd;
    return switch (type) {
      DayType.push =>
        alt
            ? const ['planche', 'handstand', 'dip', 'hspu', 'push_up', 'plank']
            : const ['handstand', 'planche', 'push_up', 'dip', 'hspu', 'plank'],
      DayType.pull =>
        alt
            ? const [
                'muscle_up',
                'front_lever',
                'row',
                'pull_up',
                'l_sit',
                'leg_raise',
              ]
            : const [
                'front_lever',
                'muscle_up',
                'pull_up',
                'row',
                'leg_raise',
                'l_sit',
              ],
      DayType.legsCore =>
        alt
            ? const [
                'hinge',
                'squat',
                'dragon_flag',
                'plank',
                'leg_raise',
                'l_sit',
              ]
            : const [
                'squat',
                'hinge',
                'leg_raise',
                'plank',
                'l_sit',
                'dragon_flag',
              ],
      DayType.fullBody =>
        alt
            ? const [
                'handstand',
                'dip',
                'row',
                'squat',
                'push_up',
                'pull_up',
                'hinge',
                'leg_raise',
                'l_sit',
              ]
            : const [
                'handstand',
                'push_up',
                'pull_up',
                'squat',
                'row',
                'dip',
                'hinge',
                'plank',
                'l_sit',
              ],
      DayType.upper => const [
        'muscle_up',
        'front_lever',
        'pull_up',
        'push_up',
        'row',
        'dip',
        'hspu',
        'l_sit',
      ],
    };
  }

  /// Starting state for every chain that has none yet.
  static Map<String, ChainState> placeMissing(
    Map<String, ChainState> states,
    ExerciseLibrary library,
    UserProfile profile,
  ) {
    final result = Map.of(states);
    for (final chain in library.chains) {
      if (result.containsKey(chain.id)) continue;
      final exercises = library.chain(chain.id);
      if (exercises.isEmpty) continue;
      result[chain.id] = ChainState(
        chainId: chain.id,
        exerciseId: Placement.start(exercises, profile).id,
      );
    }
    return result;
  }

  /// Prescription for one chain: current level, injury rules, then deload.
  static PlannedExercise? prescribe(
    ChainState state, {
    required ExerciseLibrary library,
    required List<Injury> injuries,
    required bool isDeload,
  }) {
    var exercise = library.byId(state.exerciseId);
    if (exercise == null) return null;
    var chainState = state;
    var assessment = InjuryFilter.assess(
      exercise,
      injuries,
      lookup: library.byId,
    );
    if (assessment.isExcluded) {
      // Moderate/severe limitation: train the nearest allowed regression instead.
      final substitute = assessment.substituteId == null
          ? null
          : library.byId(assessment.substituteId!);
      if (substitute == null) return null;
      exercise = substitute;
      chainState = state.moveTo(substitute.id);
      assessment = InjuryFilter.assess(
        exercise,
        injuries,
        lookup: library.byId,
      );
    }
    final range = ProgressionEngine.range(exercise, chainState);
    var sets = InjuryFilter.cappedSets(exercise.defaultSets, assessment);
    var min = exercise.isHold
        ? ProgressionEngine.holdGoal(exercise, chainState)
        : range.min;
    var max = range.max;
    if (isDeload) {
      // Lighter week: roughly 40% fewer sets and stay in the lower half of the range.
      sets = (sets * 0.6).round().clamp(1, sets);
      min = range.min;
      max = (range.min + range.max) ~/ 2;
    }
    return PlannedExercise(
      exerciseId: exercise.id,
      sets: sets,
      targetMin: min,
      targetMax: max,
      restSec: exercise.restSec,
    );
  }

  static int estimateMinutes(Iterable<PlannedExercise> exercises) {
    final seconds = exercises.fold<int>(
      0,
      (sum, e) => sum + e.sets * (secondsPerSet + e.restSec),
    );
    return warmUpMinutes + (seconds / 60).ceil();
  }

  static WeekPlan build({
    required PlanConfig config,
    required ExerciseLibrary library,
    required UserProfile profile,
    required List<Injury> injuries,
    required Map<String, ChainState> states,
    required DateTime weekStart,
    required bool isDeload,
  }) {
    final types = split(config.daysPerWeek, profile.experience);
    final days = weekdays(config.daysPerWeek);
    final seen = <DayType, int>{};
    final result = <PlannedDay>[];
    for (var i = 0; i < types.length; i++) {
      final type = types[i];
      final variant = seen.update(type, (v) => v + 1, ifAbsent: () => 0);
      final picked = <PlannedExercise>[];
      for (final chainId in slots(type, variant)) {
        final isSkill = PlanConfig.skillChoices.contains(chainId);
        if (isSkill && !config.focusSkills.contains(chainId)) continue;
        final state = states[chainId];
        if (state == null) continue;
        final planned = prescribe(
          state,
          library: library,
          injuries: injuries,
          isDeload: isDeload,
        );
        if (planned == null ||
            picked.any((p) => p.exerciseId == planned.exerciseId)) {
          continue;
        }
        // Fill until the session length is used up, but never go below a useful minimum.
        final fits =
            estimateMinutes([...picked, planned]) <= config.sessionMinutes;
        if (fits || picked.length < minExercises) picked.add(planned);
      }
      result.add(
        PlannedDay(
          index: i,
          weekday: days[i],
          type: type,
          exercises: picked,
          estimatedMinutes: estimateMinutes(picked),
        ),
      );
    }
    return WeekPlan(weekStart: weekStart, isDeload: isDeload, days: result);
  }
}
