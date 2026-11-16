import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/cloud_backend.dart';
import 'cloud_config.dart';

/// [CloudBackend] on Supabase (Auth, Postgres with row-level security, Storage).
/// The matching tables, policies and buckets are created by supabase/setup.sql.
///
/// NOTE: this class could not be exercised against a live project when it was
/// written; it is compile-checked only. The behaviour the app relies on is covered
/// by tests against a fake backend that follows the same contract.
class SupabaseBackend implements CloudBackend {
  SupabaseBackend._(this._client);
  final SupabaseClient _client;

  static const _backups = 'backups';
  static const _clips = 'review-videos';
  static const _backupName = 'backup.solobackup';

  bool _isCoach = false;
  final _users = StreamController<CloudUser?>.broadcast();

  static Future<SupabaseBackend> connect(CloudConfig config) async {
    final supabase = await Supabase.initialize(url: config.url, publishableKey: config.publishableKey);
    final backend = SupabaseBackend._(supabase.client);
    await backend._refreshRole();
    supabase.client.auth.onAuthStateChange.listen((_) async {
      await backend._refreshRole();
      backend._users.add(backend.currentUser);
    });
    return backend;
  }

  Future<void> _refreshRole() async {
    if (_client.auth.currentUser == null) {
      _isCoach = false;
      return;
    }
    try {
      _isCoach = await _client.rpc('is_coach') == true;
    } on Object {
      _isCoach = false;
    }
  }

  String get _uid {
    final id = _client.auth.currentUser?.id;
    if (id == null) throw const NotSignedInException();
    return id;
  }

  @override
  CloudUser? get currentUser {
    final u = _client.auth.currentUser;
    return u == null ? null : CloudUser(id: u.id, email: u.email ?? '', isCoach: _isCoach);
  }

  @override
  Stream<CloudUser?> get userChanges async* {
    yield currentUser;
    yield* _users.stream;
  }

  @override
  Future<void> signInWithGoogle() async {
    // Opens the system browser; the session arrives through the deep link.
    await _client.auth.signInWithOAuth(OAuthProvider.google, redirectTo: CloudConfig.redirectUrl);
  }

  @override
  Future<void> signOut() => _client.auth.signOut();

  @override
  Future<void> deleteMyCloudData() async {
    final uid = _uid;
    final clips = await _client.storage.from(_clips).list(path: uid);
    if (clips.isNotEmpty) {
      await _client.storage.from(_clips).remove([for (final f in clips) '$uid/${f.name}']);
    }
    await _client.storage.from(_backups).remove(['$uid/$_backupName']);
    await _client.from('submissions').delete().eq('user_id', uid);
  }

  // ---- Backup ----

  @override
  Future<void> uploadBackup(File encryptedBackup) async {
    final size = encryptedBackup.lengthSync();
    if (size > CloudLimits.maxBackupBytes) throw CloudFileTooLargeException(size, CloudLimits.maxBackupBytes);
    await _client.storage.from(_backups).upload(
          '$_uid/$_backupName',
          encryptedBackup,
          fileOptions: const FileOptions(upsert: true, contentType: 'application/octet-stream'),
        );
  }

  @override
  Future<CloudBackupInfo?> backupInfo() async {
    final files = await _client.storage.from(_backups).list(path: _uid);
    final file = files.where((f) => f.name == _backupName).firstOrNull;
    if (file == null) return null;
    final updated = DateTime.tryParse(file.updatedAt ?? file.createdAt ?? '');
    final size = file.metadata?['size'];
    return CloudBackupInfo(updatedAt: (updated ?? DateTime.now()).toLocal(), sizeBytes: size is int ? size : 0);
  }

  @override
  Future<void> downloadBackup(File into) async {
    final bytes = await _client.storage.from(_backups).download('$_uid/$_backupName');
    await into.writeAsBytes(bytes, flush: true);
  }

  // ---- Coach review ----

  Submission _fromRow(Map<String, dynamic> r) => Submission(
        id: r['id'] as String,
        userId: r['user_id'] as String,
        exerciseId: r['exercise_id'] as String,
        note: (r['note'] as String?) ?? '',
        status: r['status'] == 'reviewed' ? SubmissionStatus.reviewed : SubmissionStatus.pending,
        createdAt: DateTime.parse(r['created_at'] as String).toLocal(),
        videoPath: r['video_path'] as String?,
        feedback: r['feedback'] as String?,
        reviewedAt: r['reviewed_at'] == null ? null : DateTime.parse(r['reviewed_at'] as String).toLocal(),
      );

  @override
  Future<Submission> submitClip({required File clip, required String exerciseId, required String note}) async {
    final uid = _uid;
    final size = clip.lengthSync();
    if (size > CloudLimits.maxClipBytes) throw CloudFileTooLargeException(size, CloudLimits.maxClipBytes);
    final path = '$uid/${DateTime.now().toUtc().millisecondsSinceEpoch}.mp4';
    await _client.storage.from(_clips).upload(path, clip, fileOptions: const FileOptions(contentType: 'video/mp4'));
    try {
      final row = await _client
          .from('submissions')
          .insert({'exercise_id': exerciseId, 'note': note, 'video_path': path})
          .select()
          .single();
      return _fromRow(row);
    } on Object {
      await _client.storage.from(_clips).remove([path]); // do not leave an orphan clip
      rethrow;
    }
  }

  @override
  Future<List<Submission>> mySubmissions() async {
    final rows = await _client.from('submissions').select().eq('user_id', _uid).order('created_at', ascending: false);
    return [for (final r in rows) _fromRow(r)];
  }

  @override
  Future<List<Submission>> reviewQueue() async {
    final rows = await _client.from('submissions').select().eq('status', 'pending').order('created_at');
    return [for (final r in rows) _fromRow(r)];
  }

  @override
  Future<Uri> clipUrl(Submission submission) async {
    final path = submission.videoPath;
    if (path == null) throw StateError('clip already deleted');
    return Uri.parse(await _client.storage.from(_clips).createSignedUrl(path, 600));
  }

  @override
  Future<void> sendFeedback(String submissionId, String feedback) async {
    final row = await _client.from('submissions').select('video_path').eq('id', submissionId).single();
    await _client.from('submissions').update({
      'feedback': feedback,
      'status': 'reviewed',
      'coach_id': _uid,
      'reviewed_at': DateTime.now().toUtc().toIso8601String(),
      'video_path': null,
    }).eq('id', submissionId);
    final path = row['video_path'] as String?;
    if (path != null) await _client.storage.from(_clips).remove([path]);
  }

  @override
  Future<int> purgeExpiredClips({required DateTime now}) async {
    final cutoff = now.toUtc().subtract(const Duration(days: CloudLimits.clipRetentionDays)).toIso8601String();
    var query = _client.from('submissions').select('id, video_path').not('video_path', 'is', null).lt('created_at', cutoff);
    if (!_isCoach) query = query.eq('user_id', _uid);
    final rows = await query;
    final paths = [for (final r in rows) r['video_path'] as String];
    if (paths.isEmpty) return 0;
    await _client.storage.from(_clips).remove(paths);
    // Row-level security lets a coach clear the path; an athlete's row keeps a
    // stale path, which clipUrl treats as gone once the object is deleted.
    if (_isCoach) {
      await _client.from('submissions').update({'video_path': null}).inFilter('id', [for (final r in rows) r['id']]);
    }
    return paths.length;
  }
}
