import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../domain/progression_engine.dart';
import '../domain/weekly_planner.dart';

class Milestone {
  const Milestone({required this.chainId, required this.exerciseId, required this.achievedAt});
  final String chainId;
  final String exerciseId;
  final DateTime achievedAt;
}

/// Chain levels, skill unlocks, the plan configuration and performance history.
class ProgressRepository {
  ProgressRepository(this._db);
  final AppDatabase _db;

  // ---- Chain levels ----

  Future<Map<String, ChainState>> chainStates() async {
    final rows = await _db.select(_db.chainProgress).get();
    return {
      for (final r in rows)
        r.chainId: ChainState(
          chainId: r.chainId,
          exerciseId: r.exerciseId,
          holdTarget: r.holdTarget,
          bonus: r.bonus,
          successStreak: r.successStreak,
          failStreak: r.failStreak,
          dropStreak: r.dropStreak,
        ),
    };
  }

  Future<void> saveChainState(ChainState s, {required DateTime now}) =>
      _db.into(_db.chainProgress).insertOnConflictUpdate(
            ChainProgressCompanion.insert(
              chainId: s.chainId,
              exerciseId: s.exerciseId,
              holdTarget: Value(s.holdTarget),
              bonus: Value(s.bonus),
              successStreak: Value(s.successStreak),
              failStreak: Value(s.failStreak),
              dropStreak: Value(s.dropStreak),
              updatedAt: now,
            ),
          );

  Future<void> resetDropStreaks() =>
      _db.update(_db.chainProgress).write(const ChainProgressCompanion(dropStreak: Value(0)));

  // ---- Milestones ----

  Future<void> addMilestone(String chainId, String exerciseId, {required DateTime now}) => _db
      .into(_db.milestones)
      .insert(MilestonesCompanion.insert(chainId: chainId, exerciseId: exerciseId, achievedAt: now));

  Future<List<Milestone>> milestones() async {
    final rows = await (_db.select(_db.milestones)..orderBy([(m) => OrderingTerm.desc(m.achievedAt)])).get();
    return [for (final r in rows) Milestone(chainId: r.chainId, exerciseId: r.exerciseId, achievedAt: r.achievedAt)];
  }

  // ---- Plan configuration (stored in the settings key/value table) ----

  Future<PlanConfig?> planConfig() async {
    final rows = await (_db.select(_db.settings)..where((s) => s.key.like('plan.%'))).get();
    final m = {for (final r in rows) r.key: r.value};
    final days = int.tryParse(m['plan.days'] ?? '');
    final started = DateTime.tryParse(m['plan.startedAt'] ?? '');
    if (days == null || started == null) return null;
    return PlanConfig(
      daysPerWeek: days.clamp(PlanConfig.minDays, PlanConfig.maxDays),
      sessionMinutes: int.tryParse(m['plan.minutes'] ?? '') ?? 45,
      focusSkills: (m['plan.focus'] ?? '').split(',').where(PlanConfig.skillChoices.contains).toSet(),
      startedAt: started,
      deloadEveryWeeks: (int.tryParse(m['plan.deloadEvery'] ?? '') ?? 5).clamp(4, 6),
      lastDeloadStart: DateTime.tryParse(m['plan.lastDeload'] ?? ''),
    );
  }

  Future<void> savePlanConfig(PlanConfig c) {
    final values = {
      'plan.days': '${c.daysPerWeek}',
      'plan.minutes': '${c.sessionMinutes}',
      'plan.focus': (c.focusSkills.toList()..sort()).join(','),
      'plan.startedAt': c.startedAt.toIso8601String(),
      'plan.deloadEvery': '${c.deloadEveryWeeks}',
      'plan.lastDeload': c.lastDeloadStart?.toIso8601String() ?? '',
    };
    return _db.batch((b) {
      b.insertAllOnConflictUpdate(
        _db.settings,
        [for (final e in values.entries) SettingsCompanion.insert(key: e.key, value: e.value)],
      );
    });
  }

  // ---- Performance history ----

  /// The most recent finished, non-deload performance of [exerciseId] before [beforeSessionId].
  Future<Performance?> previousPerformance(String exerciseId, {required int beforeSessionId}) async {
    final q = _db.select(_db.sessionExercises).join([
      innerJoin(_db.sessions, _db.sessions.id.equalsExp(_db.sessionExercises.sessionId)),
    ])
      ..where(_db.sessionExercises.exerciseId.equals(exerciseId) &
          _db.sessions.finishedAt.isNotNull() &
          _db.sessions.isDeload.equals(false) &
          _db.sessions.id.isSmallerThanValue(beforeSessionId))
      ..orderBy([OrderingTerm.desc(_db.sessions.id)]);
    for (final row in await q.get()) {
      final ex = row.readTable(_db.sessionExercises);
      final sets = await (_db.select(_db.setLogs)
            ..where((s) => s.sessionExerciseId.equals(ex.id))
            ..orderBy([(s) => OrderingTerm.asc(s.setNumber)]))
          .get();
      if (sets.isEmpty) continue;
      return Performance(values: [for (final s in sets) s.value], targetSets: ex.targetSets);
    }
    return null;
  }
}
