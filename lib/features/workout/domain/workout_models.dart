/// How a set was recorded.
enum LogMethod { tap, volumeButton, manual, done, timer }

/// One exercise as planned before a session starts.
class PlannedExercise {
  const PlannedExercise({
    required this.exerciseId,
    required this.sets,
    required this.targetMin,
    required this.targetMax,
    required this.restSec,
  });
  final String exerciseId;
  final int sets;
  final int targetMin;
  final int targetMax;
  final int restSec;

  PlannedExercise copyWith({int? sets, int? restSec}) => PlannedExercise(
    exerciseId: exerciseId,
    sets: sets ?? this.sets,
    targetMin: targetMin,
    targetMax: targetMax,
    restSec: restSec ?? this.restSec,
  );
}

class SetLog {
  const SetLog({
    required this.id,
    required this.setNumber,
    required this.value,
    required this.method,
    required this.loggedAt,
    this.rir,
    this.rpe,
  });
  final int id;
  final int setNumber;

  /// Reps, or seconds for holds.
  final int value;
  final LogMethod method;
  final DateTime loggedAt;
  final int? rir;
  final double? rpe;
}

class SessionExercise {
  const SessionExercise({
    required this.id,
    required this.exerciseId,
    required this.orderIndex,
    required this.targetSets,
    required this.targetMin,
    required this.targetMax,
    required this.restSec,
    required this.sets,
  });
  final int id;
  final String exerciseId;
  final int orderIndex;
  final int targetSets;
  final int targetMin;
  final int targetMax;
  final int restSec;
  final List<SetLog> sets;

  bool get isComplete => sets.length >= targetSets;
}

class WorkoutSession {
  const WorkoutSession({
    required this.id,
    required this.name,
    required this.startedAt,
    required this.exercises,
    this.finishedAt,
    this.currentIndex = 0,
    this.pendingCount = 0,
    this.restEndsAt,
    this.restTotalSec,
  });
  final int id;
  final String name;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final List<SessionExercise> exercises;

  /// Index into [exercises] of the exercise on screen.
  final int currentIndex;

  /// Reps counted by tap/volume button that are not yet saved as a set.
  final int pendingCount;

  /// Wall-clock end of the running rest, or null when not resting. Stored as a
  /// timestamp so the timer survives backgrounding and app restarts.
  final DateTime? restEndsAt;
  final int? restTotalSec;

  SessionExercise? get current => exercises.isEmpty
      ? null
      : exercises[currentIndex.clamp(0, exercises.length - 1)];
  int get totalSets => exercises.fold(0, (sum, e) => sum + e.sets.length);
  bool get allComplete =>
      exercises.isNotEmpty && exercises.every((e) => e.isComplete);

  /// Seconds of rest left at [now]; 0 when not resting or already over.
  int restRemaining(DateTime now) {
    final end = restEndsAt;
    if (end == null) return 0;
    final ms = end.difference(now).inMilliseconds;
    return ms <= 0 ? 0 : (ms / 1000).ceil();
  }

  WorkoutSession copyWith({int? pendingCount}) => WorkoutSession(
    id: id,
    name: name,
    startedAt: startedAt,
    finishedAt: finishedAt,
    exercises: exercises,
    currentIndex: currentIndex,
    pendingCount: pendingCount ?? this.pendingCount,
    restEndsAt: restEndsAt,
    restTotalSec: restTotalSec,
  );
}

/// Finished workout, for the history list.
class SessionSummary {
  const SessionSummary({
    required this.id,
    required this.name,
    required this.startedAt,
    required this.finishedAt,
    required this.totalSets,
  });
  final int id;
  final String name;
  final DateTime startedAt;
  final DateTime finishedAt;
  final int totalSets;

  Duration get duration => finishedAt.difference(startedAt);
}
