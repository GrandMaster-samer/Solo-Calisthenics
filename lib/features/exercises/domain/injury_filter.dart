import '../../profile/domain/profile.dart';
import 'exercise.dart';

enum ExerciseStatus {
  /// No restriction.
  allowed,

  /// Allowed with a targeted warm-up and capped volume (mild limitation).
  caution,

  /// Not recommended for this user; offer [ExerciseAssessment.substituteId] instead.
  excluded,
}

class ExerciseAssessment {
  const ExerciseAssessment({
    required this.status,
    this.blockingJoints = const [],
    this.warmUpJoints = const [],
    this.maxSets,
    this.substituteId,
  });

  final ExerciseStatus status;

  /// Joints that caused an exclusion.
  final List<Joint> blockingJoints;

  /// Flagged joints this exercise loads; they get a targeted warm-up.
  final List<Joint> warmUpJoints;

  /// Volume cap in sets, when a mild limitation applies.
  final int? maxSets;

  /// Closest easier exercise in the chain that is not excluded, if any.
  final String? substituteId;

  bool get isExcluded => status == ExerciseStatus.excluded;
}

/// Injury rules (pure functions, no I/O):
///  * Severe   -> exclude exercises with Medium or High stress on that joint.
///  * Moderate -> exclude High stress; substitute a regression.
///  * Mild     -> allow, add a targeted warm-up and cap volume.
abstract final class InjuryFilter {
  /// Sets are capped at this number for exercises that load a mildly limited joint
  /// with Medium or High stress.
  static const mildSetCap = 2;

  static bool _excludes(Severity severity, StressLevel stress) =>
      switch (severity) {
        Severity.severe => stress.index >= StressLevel.medium.index,
        Severity.moderate => stress == StressLevel.high,
        Severity.mild => false,
      };

  /// Whether [exercise] is excluded outright, ignoring substitutes.
  static bool isExcluded(Exercise exercise, Iterable<Injury> injuries) =>
      injuries.any((i) => _excludes(i.severity, exercise.stressOn(i.joint)));

  /// Full assessment. [lookup] resolves exercise ids so a regression can be suggested.
  static ExerciseAssessment assess(
    Exercise exercise,
    Iterable<Injury> injuries, {
    Exercise? Function(String id)? lookup,
  }) {
    final blocking = <Joint>[];
    final warmUp = <Joint>[];
    var cap = false;
    for (final injury in injuries) {
      final stress = exercise.stressOn(injury.joint);
      if (stress == StressLevel.none) continue;
      if (_excludes(injury.severity, stress)) {
        blocking.add(injury.joint);
      } else {
        // Any load on a flagged joint earns a warm-up for it.
        warmUp.add(injury.joint);
        if (injury.severity == Severity.mild &&
            stress.index >= StressLevel.medium.index) {
          cap = true;
        }
      }
    }
    if (blocking.isNotEmpty) {
      return ExerciseAssessment(
        status: ExerciseStatus.excluded,
        blockingJoints: blocking,
        substituteId: lookup == null
            ? null
            : findSubstitute(exercise, injuries, lookup)?.id,
      );
    }
    if (warmUp.isEmpty) {
      return const ExerciseAssessment(status: ExerciseStatus.allowed);
    }
    return ExerciseAssessment(
      status: ExerciseStatus.caution,
      warmUpJoints: warmUp,
      maxSets: cap ? mildSetCap : null,
    );
  }

  /// Walks down the regression chain to the first exercise that is not excluded.
  static Exercise? findSubstitute(
    Exercise exercise,
    Iterable<Injury> injuries,
    Exercise? Function(String id) lookup,
  ) {
    final seen = <String>{exercise.id};
    var id = exercise.regressionId;
    while (id != null && seen.add(id)) {
      final candidate = lookup(id);
      if (candidate == null) return null;
      if (!isExcluded(candidate, injuries)) return candidate;
      id = candidate.regressionId;
    }
    return null;
  }

  /// Sets to prescribe after applying the volume cap.
  static int cappedSets(int sets, ExerciseAssessment assessment) {
    final cap = assessment.maxSets;
    return cap == null || sets <= cap ? sets : cap;
  }
}
