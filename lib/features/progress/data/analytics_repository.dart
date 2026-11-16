
import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../planner/domain/weekly_planner.dart';

class WeekStat {
  const WeekStat({required this.weekStart, required this.workouts, required this.sets});
  final DateTime weekStart;
  final int workouts;
  final int sets;
}

/// Best single set of an exercise over time (reps, or seconds for holds).
class ExerciseTrend {
  const ExerciseTrend({
    required this.exerciseId,
    required this.sessions,
    required this.firstBest,
    required this.latestBest,
    required this.allTimeBest,
  });
  final String exerciseId;
  final int sessions;
  final int firstBest;
  final int latestBest;
  final int allTimeBest;

  int get change => latestBest - firstBest;
}

class AnalyticsData {
  const AnalyticsData({
    required this.weeks,
    required this.totalWorkouts,
    required this.weekStreak,
    required this.trends,
  });

  /// Oldest first, always [AnalyticsRepository.weeksShown] entries ending with the current week.
  final List<WeekStat> weeks;
  final int totalWorkouts;

  /// Consecutive weeks with at least one workout, up to now.
  final int weekStreak;

  /// Exercises trained in at least two sessions, most trained first.
  final List<ExerciseTrend> trends;
}

class PhotoInfo {
  const PhotoInfo({required this.id, required this.takenAt, this.weightKg});
  final int id;
  final DateTime takenAt;
  final double? weightKg;
}

class AnalyticsRepository {
  AnalyticsRepository(this._db);
  final AppDatabase _db;
  static const weeksShown = 8;

  Future<AnalyticsData> load({required DateTime now}) async {
    // One row per (session, exercise): best set and number of sets.
    final best = _db.setLogs.value.max();
    final count = _db.setLogs.id.count();
    final q = _db.selectOnly(_db.setLogs).join([
      innerJoin(_db.sessionExercises, _db.sessionExercises.id.equalsExp(_db.setLogs.sessionExerciseId)),
      innerJoin(_db.sessions, _db.sessions.id.equalsExp(_db.sessionExercises.sessionId)),
    ])
      ..addColumns([_db.sessions.id, _db.sessions.startedAt, _db.sessionExercises.exerciseId, best, count])
      ..where(_db.sessions.finishedAt.isNotNull())
      ..groupBy([_db.sessions.id, _db.sessionExercises.exerciseId])
      ..orderBy([OrderingTerm.asc(_db.sessions.startedAt), OrderingTerm.asc(_db.sessions.id)]);
    final rows = await q.get();

    final sessionWeek = <int, DateTime>{};
    final setsPerWeek = <DateTime, int>{};
    final bests = <String, List<int>>{};
    for (final r in rows) {
      final week = DeloadPolicy.mondayOf(r.read(_db.sessions.startedAt)!);
      sessionWeek[r.read(_db.sessions.id)!] = week;
      setsPerWeek.update(week, (v) => v + (r.read(count) ?? 0), ifAbsent: () => r.read(count) ?? 0);
      bests.putIfAbsent(r.read(_db.sessionExercises.exerciseId)!, () => []).add(r.read(best) ?? 0);
    }
    final workoutsPerWeek = <DateTime, int>{};
    for (final w in sessionWeek.values) {
      workoutsPerWeek.update(w, (v) => v + 1, ifAbsent: () => 1);
    }

    final thisWeek = DeloadPolicy.mondayOf(now);
    final weeks = [
      for (var i = weeksShown - 1; i >= 0; i--)
        () {
          final w = thisWeek.subtract(Duration(days: 7 * i));
          return WeekStat(weekStart: w, workouts: workoutsPerWeek[w] ?? 0, sets: setsPerWeek[w] ?? 0);
        }(),
    ];

    // The current week does not break the streak while it is still empty.
    var streak = 0;
    var cursor = workoutsPerWeek.containsKey(thisWeek) ? thisWeek : thisWeek.subtract(const Duration(days: 7));
    while (workoutsPerWeek.containsKey(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 7));
    }

    final trends = [
      for (final e in bests.entries)
        if (e.value.length >= 2)
          ExerciseTrend(
            exerciseId: e.key,
            sessions: e.value.length,
            firstBest: e.value.first,
            latestBest: e.value.last,
            allTimeBest: e.value.reduce((a, b) => a > b ? a : b),
          ),
    ]..sort((a, b) => b.sessions.compareTo(a.sessions));

    return AnalyticsData(weeks: weeks, totalWorkouts: sessionWeek.length, weekStreak: streak, trends: trends);
  }

  // ---- Progress photos (stored encrypted inside the database) ----

  Future<int> addPhoto(Uint8List bytes, {required DateTime takenAt, double? weightKg}) => _db
      .into(_db.progressPhotos)
      .insert(ProgressPhotosCompanion.insert(takenAt: takenAt, bytes: bytes, weightKg: Value(weightKg)));

  /// Metadata only, newest first; image bytes are loaded one at a time with [photoBytes].
  Future<List<PhotoInfo>> photos() async {
    final t = _db.progressPhotos;
    final q = _db.selectOnly(t)
      ..addColumns([t.id, t.takenAt, t.weightKg])
      ..orderBy([OrderingTerm.desc(t.takenAt), OrderingTerm.desc(t.id)]);
    return [
      for (final r in await q.get())
        PhotoInfo(id: r.read(t.id)!, takenAt: r.read(t.takenAt)!, weightKg: r.read(t.weightKg)),
    ];
  }

  Future<Uint8List?> photoBytes(int id) async =>
      (await (_db.select(_db.progressPhotos)..where((p) => p.id.equals(id))).getSingleOrNull())?.bytes;

  Future<void> deletePhoto(int id) => (_db.delete(_db.progressPhotos)..where((p) => p.id.equals(id))).go();
}
