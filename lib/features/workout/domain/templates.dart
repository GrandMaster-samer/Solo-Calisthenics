import '../../exercises/data/exercise_repository.dart';
import '../../exercises/domain/exercise.dart';
import '../../exercises/domain/injury_filter.dart';
import '../../profile/domain/profile.dart';
import 'workout_models.dart';

/// Fixed starter workouts for Phase 1. Each lists progression chains; the concrete
/// exercise per chain is chosen from the user's experience and injury screening.
enum StarterTemplate {
  push(['push_up', 'dip', 'hspu']),
  pull(['pull_up', 'row', 'leg_raise']),
  legsCore(['squat', 'hinge', 'plank', 'leg_raise']),
  fullBody(['push_up', 'row', 'squat', 'plank']);

  const StarterTemplate(this.chainIds);
  final List<String> chainIds;
}

abstract final class TemplateBuilder {
  /// Picks a starting exercise in [chain] from experience alone.
  // TODO: Phase 2 - place the user from baseline test results and logged
  // performance (progression engine) instead of this coarse experience mapping.
  static Exercise pickForExperience(
    List<Exercise> chain,
    Experience experience,
  ) {
    final fraction = switch (experience) {
      Experience.beginner => 0.2,
      Experience.intermediate => 0.5,
      Experience.advanced => 0.75,
    };
    return chain[((chain.length - 1) * fraction).round()];
  }

  /// Applies the injury rules to one exercise: substitutes a regression when it is
  /// excluded (or drops it when no safe regression exists) and caps sets for mild limitations.
  static PlannedExercise? plan(
    Exercise exercise,
    List<Injury> injuries,
    ExerciseLibrary library,
  ) {
    var chosen = exercise;
    var assessment = InjuryFilter.assess(
      chosen,
      injuries,
      lookup: library.byId,
    );
    if (assessment.isExcluded) {
      final substitute = assessment.substituteId == null
          ? null
          : library.byId(assessment.substituteId!);
      if (substitute == null) return null;
      chosen = substitute;
      assessment = InjuryFilter.assess(chosen, injuries, lookup: library.byId);
    }
    return PlannedExercise(
      exerciseId: chosen.id,
      sets: InjuryFilter.cappedSets(chosen.defaultSets, assessment),
      targetMin: chosen.targetMin,
      targetMax: chosen.targetMax,
      restSec: chosen.restSec,
    );
  }

  static List<PlannedExercise> build(
    StarterTemplate template, {
    required ExerciseLibrary library,
    required Experience experience,
    required List<Injury> injuries,
  }) {
    final result = <PlannedExercise>[];
    for (final chainId in template.chainIds) {
      final chain = library.chain(chainId);
      if (chain.isEmpty) continue;
      final planned = plan(
        pickForExperience(chain, experience),
        injuries,
        library,
      );
      if (planned != null) result.add(planned);
    }
    return result;
  }

  /// Flagged joints that the planned exercises actually load, for the warm-up card.
  static List<Joint> warmUpJoints(
    Iterable<PlannedExercise> plan,
    List<Injury> injuries,
    ExerciseLibrary library,
  ) {
    final joints = <Joint>{};
    for (final p in plan) {
      final e = library.byId(p.exerciseId);
      if (e == null) continue;
      joints.addAll(InjuryFilter.assess(e, injuries).warmUpJoints);
    }
    return Joint.values.where(joints.contains).toList();
  }
}

/// The exercise exactly as defined in the library, with no injury adjustments.
PlannedExercise plannedFromDefaults(Exercise e) => PlannedExercise(
  exerciseId: e.id,
  sets: e.defaultSets,
  targetMin: e.targetMin,
  targetMax: e.targetMax,
  restSec: e.restSec,
);

/// Plans an exercise the user picked by hand. Excluded picks were already confirmed
/// by the user, so they are kept as-is; everything else gets the usual volume cap.
PlannedExercise planPicked(
  Exercise e,
  List<Injury> injuries,
  ExerciseLibrary library,
) => InjuryFilter.isExcluded(e, injuries)
    ? plannedFromDefaults(e)
    : (TemplateBuilder.plan(e, injuries, library) ?? plannedFromDefaults(e));
