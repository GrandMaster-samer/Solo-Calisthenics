import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../settings/application/settings_controller.dart';
import '../data/workout_repository.dart';
import '../domain/workout_models.dart';

/// Localized text for the rest-over notification, supplied by the UI.
typedef RestText = ({String title, String body});

final activeSessionProvider =
    AsyncNotifierProvider<ActiveSessionController, WorkoutSession?>(
      ActiveSessionController.new,
    );

final historyProvider = FutureProvider<List<SessionSummary>>((ref) {
  ref.watch(activeSessionProvider); // refresh when a session finishes
  return ref.watch(workoutRepositoryProvider).history();
});

/// Drives the workout in progress. State always mirrors what is in the database:
/// every action writes first, then reloads, so killing the app loses nothing.
class ActiveSessionController extends AsyncNotifier<WorkoutSession?> {
  WorkoutRepository get _repo => ref.read(workoutRepositoryProvider);
  DateTime _now() => ref.read(clockProvider)();

  @override
  Future<WorkoutSession?> build() =>
      ref.read(workoutRepositoryProvider).loadActive();

  Future<void> _reload(int id) async {
    final session = await _repo.load(id);
    state = AsyncData(session?.finishedAt == null ? session : null);
  }

  Future<void> start(String name, List<PlannedExercise> plan) async {
    final existing = state.value;
    if (existing != null) await _repo.discard(existing.id);
    final id = await _repo.createSession(name, plan, now: _now());
    await _reload(id);
  }

  /// Tap / volume-button counting. Updates the UI immediately and persists in the background.
  void setPendingCount(int count) {
    final s = state.value;
    if (s == null || count < 0 || count == s.pendingCount) return;
    state = AsyncData(s.copyWith(pendingCount: count));
    unawaited(_repo.setPendingCount(s.id, count));
  }

  /// Saves a set for the current exercise and starts its rest timer.
  /// Returns the id of the new set (for the RIR/RPE picker), or null if nothing was saved.
  Future<int?> logSet(int value, LogMethod method, RestText restText) async {
    final s = state.value;
    final ex = s?.current;
    if (s == null || ex == null || value <= 0) return null;
    final now = _now();
    final isLastSetOfWorkout =
        ex.sets.length + 1 >= ex.targetSets &&
        s.exercises.every((e) => e.id == ex.id || e.isComplete);
    final restSec = isLastSetOfWorkout ? 0 : ex.restSec;
    final setId = await _repo.addSet(
      sessionId: s.id,
      sessionExerciseId: ex.id,
      value: value,
      method: method,
      now: now,
      restSec: restSec,
    );
    // When this exercise is done, queue up the next unfinished one during the rest.
    if (ex.sets.length + 1 >= ex.targetSets) {
      final next = _nextIncomplete(
        s,
        after: s.currentIndex,
        justCompleted: ex.id,
      );
      if (next != null) await _repo.setCurrentIndex(s.id, next);
    }
    final notifications = ref.read(notificationServiceProvider);
    if (restSec > 0) {
      await notifications.scheduleRestEnd(
        now.add(Duration(seconds: restSec)),
        title: restText.title,
        body: restText.body,
        sound: ref.read(settingsProvider).sound,
      );
    } else {
      await notifications.cancelRestEnd();
    }
    await _reload(s.id);
    return setId;
  }

  int? _nextIncomplete(
    WorkoutSession s, {
    required int after,
    required int justCompleted,
  }) {
    final n = s.exercises.length;
    for (var step = 1; step < n; step++) {
      final i = (after + step) % n;
      final e = s.exercises[i];
      if (e.id != justCompleted && !e.isComplete) return i;
    }
    return null;
  }

  Future<void> setEffort(int setId, {int? rir, double? rpe}) async {
    final s = state.value;
    if (s == null) return;
    await _repo.setEffort(setId, rir: rir, rpe: rpe);
    await _reload(s.id);
  }

  /// Removes the most recently logged set of exercise [index] and stops the rest.
  Future<void> undoLastSet(int index) async {
    final s = state.value;
    if (s == null ||
        index < 0 ||
        index >= s.exercises.length ||
        s.exercises[index].sets.isEmpty) {
      return;
    }
    await _repo.deleteSet(s.exercises[index].sets.last.id);
    await _repo.setCurrentIndex(s.id, index);
    await _repo.setRest(s.id, endsAt: null, totalSec: null);
    await ref.read(notificationServiceProvider).cancelRestEnd();
    await _reload(s.id);
  }

  Future<void> goTo(int index) async {
    final s = state.value;
    if (s == null ||
        index < 0 ||
        index >= s.exercises.length ||
        index == s.currentIndex) {
      return;
    }
    await _repo.setCurrentIndex(s.id, index);
    await _reload(s.id);
  }

  /// The user ended the rest early: clear it and cancel the pending notification.
  Future<void> skipRest() async {
    await ref.read(notificationServiceProvider).cancelRestEnd();
    await completeRest();
  }

  /// The rest ran out. The notification is left alone so its sound can play.
  Future<void> completeRest() async {
    final s = state.value;
    if (s == null || s.restEndsAt == null) return;
    await _repo.setRest(s.id, endsAt: null, totalSec: null);
    await _reload(s.id);
  }

  /// Adds or removes rest time now, and remembers the new length for the exercise
  /// the rest belongs to ([sessionExerciseId]).
  Future<void> adjustRest(
    int deltaSec,
    RestText restText, {
    int? sessionExerciseId,
  }) async {
    final s = state.value;
    final end = s?.restEndsAt;
    if (s == null || end == null) return;
    final now = _now();
    var newEnd = end.add(Duration(seconds: deltaSec));
    if (newEnd.isBefore(now)) newEnd = now;
    final total = ((s.restTotalSec ?? 0) + deltaSec).clamp(0, 3600);
    await _repo.setRest(s.id, endsAt: newEnd, totalSec: total);
    if (sessionExerciseId != null && total > 0) {
      await _repo.setExerciseRest(sessionExerciseId, total);
    }
    await ref
        .read(notificationServiceProvider)
        .scheduleRestEnd(
          newEnd,
          title: restText.title,
          body: restText.body,
          sound: ref.read(settingsProvider).sound,
        );
    await _reload(s.id);
  }

  Future<void> finish() async {
    final s = state.value;
    if (s == null) return;
    await ref.read(notificationServiceProvider).cancelRestEnd();
    if (s.totalSets == 0) {
      await _repo.discard(s.id); // nothing logged: do not pollute history
    } else {
      await _repo.finish(s.id, now: _now());
    }
    state = const AsyncData(null);
  }

  Future<void> discard() async {
    final s = state.value;
    if (s == null) return;
    await ref.read(notificationServiceProvider).cancelRestEnd();
    await _repo.discard(s.id);
    state = const AsyncData(null);
  }
}
