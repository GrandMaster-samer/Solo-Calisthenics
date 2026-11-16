import '../../exercises/domain/exercise.dart';

/// Where the user stands in one progression chain.
class ChainState {
  const ChainState({
    required this.chainId,
    required this.exerciseId,
    this.holdTarget,
    this.bonus = 0,
    this.successStreak = 0,
    this.failStreak = 0,
    this.dropStreak = 0,
  });

  final String chainId;
  final String exerciseId;

  /// Current per-set hold goal in seconds; null means "start at the bottom of the range".
  final int? holdTarget;

  /// Reps/seconds added on top of the library range once the chain has no harder exercise.
  final int bonus;

  /// Consecutive sessions at the top of the range.
  final int successStreak;

  /// Consecutive sessions below the bottom of the range.
  final int failStreak;

  /// Consecutive sessions with a clear volume drop (feeds the deload trigger).
  final int dropStreak;

  ChainState copyWith({int? Function()? holdTarget, int? bonus, int? successStreak, int? failStreak, int? dropStreak}) =>
      ChainState(
        chainId: chainId,
        exerciseId: exerciseId,
        holdTarget: holdTarget != null ? holdTarget() : this.holdTarget,
        bonus: bonus ?? this.bonus,
        successStreak: successStreak ?? this.successStreak,
        failStreak: failStreak ?? this.failStreak,
        dropStreak: dropStreak ?? this.dropStreak,
      );

  /// Fresh state on another exercise of the same chain.
  ChainState moveTo(String exerciseId) => ChainState(chainId: chainId, exerciseId: exerciseId);
}

/// What the user did for one exercise in one session.
class Performance {
  const Performance({required this.values, required this.targetSets, this.avgRir});

  /// Reps (or seconds) per logged set, in order.
  final List<int> values;

  /// Sets that were prescribed.
  final int targetSets;

  /// Average reps in reserve over the sets that have an effort rating
  /// (RPE is converted as RIR = 10 - RPE). Null when nothing was rated.
  final double? avgRir;

  int get volume => values.fold(0, (a, b) => a + b);
  bool get completedAllSets => values.length >= targetSets && targetSets > 0;
}

enum ProgressionAction {
  /// Move to the next exercise in the chain (a skill unlock).
  advance,

  /// Same exercise, bigger goal (longer hold, or more reps at the end of a chain).
  increaseTarget,

  /// Same exercise, same goal.
  repeat,

  /// Same exercise, smaller goal (shorter hold).
  decreaseTarget,

  /// Back to the previous exercise in the chain.
  regress,
}

class ProgressionResult {
  const ProgressionResult(this.action, this.state);
  final ProgressionAction action;
  final ChainState state;
}

/// Rule-based progressive overload. Pure functions: no clock, no storage.
///
/// Rep exercises (double progression): hitting the top of the rep range on every
/// prescribed set for [sessionsToAdvance] consecutive sessions advances to the next
/// exercise, or adds reps when the chain has no harder exercise.
///
/// Holds: hitting the hold goal on every set raises the goal by [holdStep] until the
/// top of the range; holding the top for [sessionsToAdvance] sessions advances.
///
/// Effort: an average RIR of [easyRir] or more at the top advances after one session.
/// Missing the bottom of the range for [sessionsToRegress] consecutive sessions regresses.
abstract final class ProgressionEngine {
  static const sessionsToAdvance = 2;
  static const sessionsToRegress = 2;
  static const easyRir = 3.0;
  static const repStep = 2;

  /// A session counts as a drop when volume falls below this share of the previous one.
  static const dropRatio = 0.9;

  static int holdStep(Exercise e) => (e.targetMax - e.targetMin) >= 30 ? 10 : 5;

  /// Bottom/top of the working range for [state] (reps or seconds).
  static ({int min, int max}) range(Exercise e, ChainState state) =>
      (min: e.targetMin + state.bonus, max: e.targetMax + state.bonus);

  /// Per-set hold goal right now.
  static int holdGoal(Exercise e, ChainState state) {
    final r = range(e, state);
    return (state.holdTarget ?? r.min).clamp(r.min, r.max);
  }

  static ProgressionResult evaluate({
    required ChainState state,
    required Exercise exercise,
    required Performance performance,
    Performance? previous,
    String? nextExerciseId,
    String? previousExerciseId,
  }) {
    assert(exercise.id == state.exerciseId);
    if (performance.values.isEmpty) return ProgressionResult(ProgressionAction.repeat, state);

    // Volume trend, used by the deload trigger.
    final dropped = previous != null && previous.volume > 0 && performance.volume < previous.volume * dropRatio;
    final tracked = state.copyWith(dropStreak: dropped ? state.dropStreak + 1 : 0);

    final result = exercise.isHold
        ? _hold(tracked, exercise, performance, nextExerciseId, previousExerciseId)
        : _reps(tracked, exercise, performance, nextExerciseId, previousExerciseId);
    // A change of exercise starts a clean slate, including the drop streak.
    return result;
  }

  static bool _easy(Performance p) => p.avgRir != null && p.avgRir! >= easyRir;

  static ProgressionResult _advanceOrGrow(ChainState s, String? nextId, int step, int newTop) {
    if (nextId != null) return ProgressionResult(ProgressionAction.advance, s.moveTo(nextId));
    // End of the chain: keep the exercise and raise the range.
    return ProgressionResult(
      ProgressionAction.increaseTarget,
      s.copyWith(bonus: s.bonus + step, successStreak: 0, failStreak: 0, holdTarget: () => newTop + step),
    );
  }

  static ProgressionResult _reps(ChainState s, Exercise e, Performance p, String? nextId, String? prevId) {
    final r = range(e, s);
    final hitTop = p.completedAllSets && p.values.take(p.targetSets).every((v) => v >= r.max);
    if (hitTop) {
      final streak = s.successStreak + 1;
      if (streak >= sessionsToAdvance || _easy(p)) {
        final res = _advanceOrGrow(s, nextId, repStep, r.max);
        // Rep exercises have no hold target.
        return ProgressionResult(res.action, res.state.copyWith(holdTarget: () => null));
      }
      return ProgressionResult(ProgressionAction.repeat, s.copyWith(successStreak: streak, failStreak: 0));
    }

    // Could not reach the bottom of the range even on the first, freshest set.
    final failed = p.values.first < r.min;
    if (failed) {
      final fails = s.failStreak + 1;
      if (fails >= sessionsToRegress) {
        if (s.bonus > 0) {
          return ProgressionResult(
            ProgressionAction.decreaseTarget,
            s.copyWith(bonus: (s.bonus - repStep).clamp(0, s.bonus), successStreak: 0, failStreak: 0),
          );
        }
        if (prevId != null) return ProgressionResult(ProgressionAction.regress, s.moveTo(prevId));
      }
      return ProgressionResult(ProgressionAction.repeat, s.copyWith(successStreak: 0, failStreak: fails));
    }
    return ProgressionResult(ProgressionAction.repeat, s.copyWith(successStreak: 0, failStreak: 0));
  }

  static ProgressionResult _hold(ChainState s, Exercise e, Performance p, String? nextId, String? prevId) {
    final r = range(e, s);
    final goal = holdGoal(e, s);
    final step = holdStep(e);
    final hit = p.completedAllSets && p.values.take(p.targetSets).every((v) => v >= goal);
    if (hit) {
      if (goal >= r.max) {
        final streak = s.successStreak + 1;
        if (streak >= sessionsToAdvance || _easy(p)) return _advanceOrGrow(s, nextId, step, r.max);
        return ProgressionResult(
          ProgressionAction.repeat,
          s.copyWith(successStreak: streak, failStreak: 0, holdTarget: () => goal),
        );
      }
      final next = (goal + step).clamp(r.min, r.max);
      return ProgressionResult(
        ProgressionAction.increaseTarget,
        s.copyWith(holdTarget: () => next, successStreak: 0, failStreak: 0),
      );
    }

    // Well short of the goal on the first set.
    final failed = p.values.first < goal * 0.7;
    if (failed) {
      final fails = s.failStreak + 1;
      if (fails >= sessionsToRegress) {
        if (goal > r.min) {
          return ProgressionResult(
            ProgressionAction.decreaseTarget,
            s.copyWith(holdTarget: () => (goal - step).clamp(r.min, r.max), successStreak: 0, failStreak: 0),
          );
        }
        if (prevId != null) return ProgressionResult(ProgressionAction.regress, s.moveTo(prevId));
      }
      return ProgressionResult(
        ProgressionAction.repeat,
        s.copyWith(successStreak: 0, failStreak: fails, holdTarget: () => goal),
      );
    }
    return ProgressionResult(
      ProgressionAction.repeat,
      s.copyWith(successStreak: 0, failStreak: 0, holdTarget: () => goal),
    );
  }
}
