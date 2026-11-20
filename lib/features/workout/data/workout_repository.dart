import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../domain/workout_models.dart';

/// All workout persistence. Every mutation is written immediately, which is what
/// makes sessions survive an app kill.
class WorkoutRepository {
  WorkoutRepository(this._db);
  final AppDatabase _db;

  Future<int> createSession(
    String name,
    List<PlannedExercise> plan, {
    required DateTime now,
    PlanLink? link,
  }) {
    return _db.transaction(() async {
      final id = await _db
          .into(_db.sessions)
          .insert(
            SessionsCompanion.insert(
              name: name,
              startedAt: now,
              planWeek: Value(link?.week),
              planDayIndex: Value(link?.dayIndex),
              isDeload: Value(link?.isDeload ?? false),
            ),
          );
      for (var i = 0; i < plan.length; i++) {
        final p = plan[i];
        await _db
            .into(_db.sessionExercises)
            .insert(
              SessionExercisesCompanion.insert(
                sessionId: id,
                exerciseId: p.exerciseId,
                orderIndex: i,
                targetSets: p.sets,
                targetMin: p.targetMin,
                targetMax: p.targetMax,
                restSec: p.restSec,
              ),
            );
      }
      return id;
    });
  }

  /// The unfinished session, if any (newest first).
  Future<WorkoutSession?> loadActive() async {
    final row =
        await (_db.select(_db.sessions)
              ..where((s) => s.finishedAt.isNull())
              ..orderBy([(s) => OrderingTerm.desc(s.id)])
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : _hydrate(row);
  }

  Future<WorkoutSession?> load(int id) async {
    final row = await (_db.select(
      _db.sessions,
    )..where((s) => s.id.equals(id))).getSingleOrNull();
    return row == null ? null : _hydrate(row);
  }

  Future<WorkoutSession> _hydrate(SessionRow row) async {
    final exRows =
        await (_db.select(_db.sessionExercises)
              ..where((e) => e.sessionId.equals(row.id))
              ..orderBy([(e) => OrderingTerm.asc(e.orderIndex)]))
            .get();
    final setRows =
        await (_db.select(_db.setLogs)
              ..where((s) => s.sessionExerciseId.isIn(exRows.map((e) => e.id)))
              ..orderBy([(s) => OrderingTerm.asc(s.setNumber)]))
            .get();
    return WorkoutSession(
      id: row.id,
      name: row.name,
      startedAt: row.startedAt,
      finishedAt: row.finishedAt,
      currentIndex: row.currentIndex,
      pendingCount: row.pendingCount,
      restEndsAt: row.restEndsAt,
      restTotalSec: row.restTotalSec,
      planWeek: row.planWeek,
      planDayIndex: row.planDayIndex,
      isDeload: row.isDeload,
      exercises: [
        for (final e in exRows)
          SessionExercise(
            id: e.id,
            exerciseId: e.exerciseId,
            orderIndex: e.orderIndex,
            targetSets: e.targetSets,
            targetMin: e.targetMin,
            targetMax: e.targetMax,
            restSec: e.restSec,
            sets: [
              for (final s in setRows.where((s) => s.sessionExerciseId == e.id))
                SetLog(
                  id: s.id,
                  setNumber: s.setNumber,
                  value: s.value,
                  rir: s.rir,
                  rpe: s.rpe,
                  method: LogMethod.values.byName(s.method),
                  loggedAt: s.loggedAt,
                ),
            ],
          ),
      ],
    );
  }

  Future<void> _updateSession(int sessionId, SessionsCompanion changes) =>
      (_db.update(
        _db.sessions,
      )..where((s) => s.id.equals(sessionId))).write(changes);

  /// Saves a set, resets the tap counter and starts the rest timer, atomically.
  /// Returns the new set's id.
  Future<int> addSet({
    required int sessionId,
    required int sessionExerciseId,
    required int value,
    required LogMethod method,
    required DateTime now,
    required int restSec,
  }) {
    return _db.transaction(() async {
      final count = _db.setLogs.id.count();
      final existing =
          await (_db.selectOnly(_db.setLogs)
                ..addColumns([count])
                ..where(
                  _db.setLogs.sessionExerciseId.equals(sessionExerciseId),
                ))
              .map((r) => r.read(count) ?? 0)
              .getSingle();
      final id = await _db
          .into(_db.setLogs)
          .insert(
            SetLogsCompanion.insert(
              sessionExerciseId: sessionExerciseId,
              setNumber: existing + 1,
              value: value,
              method: method.name,
              loggedAt: now,
            ),
          );
      await _updateSession(
        sessionId,
        SessionsCompanion(
          pendingCount: const Value(0),
          restEndsAt: Value(
            restSec > 0 ? now.add(Duration(seconds: restSec)) : null,
          ),
          restTotalSec: Value(restSec > 0 ? restSec : null),
        ),
      );
      return id;
    });
  }

  Future<void> setEffort(int setId, {int? rir, double? rpe}) =>
      (_db.update(_db.setLogs)..where((s) => s.id.equals(setId))).write(
        SetLogsCompanion(rir: Value(rir), rpe: Value(rpe)),
      );

  Future<void> deleteSet(int setId) =>
      (_db.delete(_db.setLogs)..where((s) => s.id.equals(setId))).go();

  Future<void> setPendingCount(int sessionId, int count) =>
      _updateSession(sessionId, SessionsCompanion(pendingCount: Value(count)));

  /// Moving to another exercise also clears the tap counter.
  Future<void> setCurrentIndex(int sessionId, int index) => _updateSession(
    sessionId,
    SessionsCompanion(currentIndex: Value(index), pendingCount: const Value(0)),
  );

  Future<void> setRest(
    int sessionId, {
    required DateTime? endsAt,
    required int? totalSec,
  }) => _updateSession(
    sessionId,
    SessionsCompanion(restEndsAt: Value(endsAt), restTotalSec: Value(totalSec)),
  );

  Future<void> setExerciseRest(int sessionExerciseId, int restSec) =>
      (_db.update(_db.sessionExercises)
            ..where((e) => e.id.equals(sessionExerciseId)))
          .write(SessionExercisesCompanion(restSec: Value(restSec)));

  Future<void> finish(int sessionId, {required DateTime now}) => _updateSession(
    sessionId,
    SessionsCompanion(
      finishedAt: Value(now),
      restEndsAt: const Value(null),
      pendingCount: const Value(0),
    ),
  );

  /// Deletes the session with its exercises and sets (cascade).
  Future<void> discard(int sessionId) =>
      (_db.delete(_db.sessions)..where((s) => s.id.equals(sessionId))).go();

  Future<List<SessionSummary>> history({int limit = 30}) async {
    final rows =
        await (_db.select(_db.sessions)
              ..where((s) => s.finishedAt.isNotNull())
              ..orderBy([(s) => OrderingTerm.desc(s.startedAt)])
              ..limit(limit))
            .get();
    final result = <SessionSummary>[];
    for (final r in rows) {
      final count = _db.setLogs.id.count();
      final q =
          _db.selectOnly(_db.setLogs).join([
              innerJoin(
                _db.sessionExercises,
                _db.sessionExercises.id.equalsExp(
                  _db.setLogs.sessionExerciseId,
                ),
              ),
            ])
            ..addColumns([count])
            ..where(_db.sessionExercises.sessionId.equals(r.id));
      final sets = await q.map((row) => row.read(count) ?? 0).getSingle();
      result.add(
        SessionSummary(
          id: r.id,
          name: r.name,
          startedAt: r.startedAt,
          finishedAt: r.finishedAt!,
          totalSets: sets,
        ),
      );
    }
    return result;
  }

  /// Plan day indexes that already have a finished session in [week].
  Future<Set<int>> completedPlanDays(String week) async {
    final rows =
        await (_db.select(_db.sessions)..where(
              (s) =>
                  s.planWeek.equals(week) &
                  s.finishedAt.isNotNull() &
                  s.planDayIndex.isNotNull(),
            ))
            .get();
    return {for (final r in rows) r.planDayIndex!};
  }
}
