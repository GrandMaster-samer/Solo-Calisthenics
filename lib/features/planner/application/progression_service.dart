import '../../exercises/data/exercise_repository.dart';
import '../../workout/domain/workout_models.dart';
import '../data/progress_repository.dart';
import '../domain/progression_engine.dart';
import '../domain/weekly_planner.dart';

/// What changed after a workout, for the summary shown to the user.
class ProgressionChange {
  const ProgressionChange({
    required this.exerciseId,
    required this.action,
    this.newExerciseId,
  });
  final String exerciseId;
  final ProgressionAction action;

  /// Set for advance/regress.
  final String? newExerciseId;
}

/// Average RIR over rated sets (RPE converted as 10 - RPE), or null.
double? averageRir(Iterable<SetLog> sets) {
  final rated = [
    for (final s in sets)
      if (s.rir != null)
        s.rir!.toDouble()
      else if (s.rpe != null)
        (10 - s.rpe!).clamp(0, 10).toDouble(),
  ];
  return rated.isEmpty ? null : rated.reduce((a, b) => a + b) / rated.length;
}

/// Applies the progression engine to a finished session and stores the outcome.
class ProgressionService {
  ProgressionService(this._repo, this._library);
  final ProgressRepository _repo;
  final ExerciseLibrary _library;

  Future<List<ProgressionChange>> applyFinishedSession(
    WorkoutSession session, {
    required DateTime now,
  }) async {
    if (session.isDeload) {
      return const []; // lighter on purpose; says nothing about progress
    }
    final states = await _repo.chainStates();
    final changes = <ProgressionChange>[];
    var deloadTriggered = false;

    for (final ex in session.exercises) {
      if (ex.sets.isEmpty) continue;
      final def = _library.byId(ex.exerciseId);
      if (def == null) continue;
      // Only the exercise the user is currently working on in a chain drives that chain.
      final state =
          states[def.chainId] ??
          ChainState(chainId: def.chainId, exerciseId: def.id);
      if (state.exerciseId != def.id) continue;

      final result = ProgressionEngine.evaluate(
        state: state,
        exercise: def,
        performance: Performance(
          values: [for (final s in ex.sets) s.value],
          targetSets: ex.targetSets,
          avgRir: averageRir(ex.sets),
        ),
        previous: await _repo.previousPerformance(
          def.id,
          beforeSessionId: session.id,
        ),
        nextExerciseId: def.progressionId,
        previousExerciseId: def.regressionId,
      );
      states[def.chainId] = result.state;
      await _repo.saveChainState(result.state, now: now);
      if (result.action == ProgressionAction.advance) {
        await _repo.addMilestone(
          def.chainId,
          result.state.exerciseId,
          now: now,
        );
      }
      if (result.action != ProgressionAction.repeat) {
        changes.add(
          ProgressionChange(
            exerciseId: def.id,
            action: result.action,
            newExerciseId: result.state.exerciseId == def.id
                ? null
                : result.state.exerciseId,
          ),
        );
      }
      if (result.state.dropStreak >= 2) deloadTriggered = true;
    }

    // Performance dropped two sessions running: start a lighter week now.
    if (deloadTriggered) {
      final config = await _repo.planConfig();
      if (config != null &&
          !DeloadPolicy.isActive(now, config.lastDeloadStart)) {
        await _repo.savePlanConfig(
          config.copyWith(lastDeloadStart: () => DeloadPolicy.day(now)),
        );
      }
      await _repo.resetDropStreaks();
    }
    return changes;
  }
}
