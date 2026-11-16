import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../domain/profile.dart';

class ProfileRepository {
  ProfileRepository(this._db);
  final AppDatabase _db;

  Future<UserProfile?> loadProfile() async {
    final row = await (_db.select(
      _db.profiles,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    if (row == null) return null;
    return UserProfile(
      birthYear: row.birthYear,
      heightCm: row.heightCm,
      weightKg: row.weightKg,
      experience: Experience.values.byName(row.experience),
      maxPushUps: row.maxPushUps,
      maxPullUps: row.maxPullUps,
      maxDeadHangSec: row.maxDeadHangSec,
      maxPlankSec: row.maxPlankSec,
    );
  }

  Future<List<Injury>> loadInjuries() async {
    final rows = await _db.select(_db.injuries).get();
    return [
      for (final r in rows)
        Injury(
          joint: Joint.values.byName(r.joint),
          severity: Severity.values.byName(r.severity),
          isCurrent: r.isCurrent,
        ),
    ];
  }

  /// Saves the profile and replaces the full injury list in one transaction.
  Future<void> save(
    UserProfile profile,
    List<Injury> injuries, {
    DateTime? now,
  }) {
    return _db.transaction(() async {
      await _db
          .into(_db.profiles)
          .insertOnConflictUpdate(
            ProfilesCompanion.insert(
              id: const Value(1),
              birthYear: profile.birthYear,
              heightCm: profile.heightCm,
              weightKg: profile.weightKg,
              experience: profile.experience.name,
              maxPushUps: Value(profile.maxPushUps),
              maxPullUps: Value(profile.maxPullUps),
              maxDeadHangSec: Value(profile.maxDeadHangSec),
              maxPlankSec: Value(profile.maxPlankSec),
              createdAt: now ?? DateTime.now(),
            ),
          );
      await _db.delete(_db.injuries).go();
      for (final i in injuries) {
        await _db
            .into(_db.injuries)
            .insert(
              InjuriesCompanion.insert(
                joint: i.joint.name,
                severity: i.severity.name,
                isCurrent: Value(i.isCurrent),
              ),
            );
      }
    });
  }
}
