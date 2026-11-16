import 'dart:async';
import 'dart:io';

import 'package:solo_calisthenics/features/cloud/data/clip_source.dart';
import 'package:solo_calisthenics/features/cloud/domain/cloud_backend.dart';

/// In-memory server that follows the [CloudBackend] contract, including the
/// access rules the real SQL policies enforce.
class FakeCloudBackend implements CloudBackend {
  FakeCloudBackend({required this.clock});
  final DateTime Function() clock;

  /// Who "Sign in with Google" signs in as.
  CloudUser nextUser = const CloudUser(id: 'athlete-1', email: 'athlete@example.com');
  bool failNextCall = false;

  final backups = <String, List<int>>{}; // user id -> stored bytes
  final backupTimes = <String, DateTime>{};
  final clips = <String, List<int>>{}; // storage path -> bytes
  final _rows = <Submission>[];
  final _users = StreamController<CloudUser?>.broadcast();
  CloudUser? _user;
  var _nextId = 1;

  void _maybeFail() {
    if (failNextCall) {
      failNextCall = false;
      throw const SocketException('offline');
    }
  }

  CloudUser get _me => _user ?? (throw const NotSignedInException());

  @override
  CloudUser? get currentUser => _user;

  @override
  Stream<CloudUser?> get userChanges async* {
    yield _user;
    yield* _users.stream;
  }

  @override
  Future<void> signInWithGoogle() async {
    _maybeFail();
    _user = nextUser;
    _users.add(_user);
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _users.add(null);
  }

  @override
  Future<void> deleteMyCloudData() async {
    final id = _me.id;
    backups.remove(id);
    backupTimes.remove(id);
    clips.removeWhere((path, _) => path.startsWith('$id/'));
    _rows.removeWhere((s) => s.userId == id);
  }

  @override
  Future<void> uploadBackup(File encryptedBackup) async {
    _maybeFail();
    final bytes = encryptedBackup.readAsBytesSync();
    if (bytes.length > CloudLimits.maxBackupBytes) {
      throw CloudFileTooLargeException(bytes.length, CloudLimits.maxBackupBytes);
    }
    backups[_me.id] = bytes;
    backupTimes[_me.id] = clock();
  }

  @override
  Future<CloudBackupInfo?> backupInfo() async {
    final bytes = backups[_me.id];
    return bytes == null ? null : CloudBackupInfo(updatedAt: backupTimes[_me.id]!, sizeBytes: bytes.length);
  }

  @override
  Future<void> downloadBackup(File into) async {
    _maybeFail();
    final bytes = backups[_me.id];
    if (bytes == null) throw StateError('no backup');
    into.writeAsBytesSync(bytes);
  }

  @override
  Future<Submission> submitClip({required File clip, required String exerciseId, required String note}) async {
    _maybeFail();
    final bytes = clip.readAsBytesSync();
    if (bytes.length > CloudLimits.maxClipBytes) {
      throw CloudFileTooLargeException(bytes.length, CloudLimits.maxClipBytes);
    }
    final id = 's${_nextId++}';
    final path = '${_me.id}/$id.mp4';
    clips[path] = bytes;
    final s = Submission(
      id: id,
      userId: _me.id,
      exerciseId: exerciseId,
      note: note,
      status: SubmissionStatus.pending,
      createdAt: clock(),
      videoPath: path,
    );
    _rows.add(s);
    return s;
  }

  @override
  Future<List<Submission>> mySubmissions() async =>
      _rows.where((s) => s.userId == _me.id).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  @override
  Future<List<Submission>> reviewQueue() async {
    if (!_me.isCoach) return const []; // row-level security: athletes see only their own
    return _rows.where((s) => s.status == SubmissionStatus.pending).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  @override
  Future<Uri> clipUrl(Submission submission) async {
    final path = submission.videoPath;
    if (path == null || !clips.containsKey(path)) throw StateError('clip already deleted');
    if (!_me.isCoach && submission.userId != _me.id) throw StateError('forbidden');
    return Uri.parse('https://fake.invalid/$path?token=short-lived');
  }

  Submission _copy(Submission s, {SubmissionStatus? status, String? feedback, DateTime? reviewedAt, bool dropClip = false}) =>
      Submission(
        id: s.id,
        userId: s.userId,
        exerciseId: s.exerciseId,
        note: s.note,
        status: status ?? s.status,
        createdAt: s.createdAt,
        videoPath: dropClip ? null : s.videoPath,
        feedback: feedback ?? s.feedback,
        reviewedAt: reviewedAt ?? s.reviewedAt,
      );

  @override
  Future<void> sendFeedback(String submissionId, String feedback) async {
    _maybeFail();
    if (!_me.isCoach) throw StateError('forbidden');
    final i = _rows.indexWhere((s) => s.id == submissionId);
    clips.remove(_rows[i].videoPath);
    _rows[i] = _copy(_rows[i], status: SubmissionStatus.reviewed, feedback: feedback, reviewedAt: clock(), dropClip: true);
  }

  @override
  Future<int> purgeExpiredClips({required DateTime now}) async {
    final me = _me;
    var removed = 0;
    for (var i = 0; i < _rows.length; i++) {
      final s = _rows[i];
      if (s.videoPath == null || !s.isExpired(now)) continue;
      if (!me.isCoach && s.userId != me.id) continue;
      clips.remove(s.videoPath);
      _rows[i] = _copy(s, dropClip: true);
      removed++;
    }
    return removed;
  }
}

/// Stands in for the camera and the video encoder.
class FakeClipSource implements ClipSource {
  FakeClipSource(this.directory);
  final Directory directory;
  bool tooLong = false;
  var _n = 0;

  @override
  Future<File?> pick({required bool camera}) async {
    if (tooLong) throw const ClipTooLongException();
    return File('${directory.path}/clip${_n++}.mp4')..writeAsBytesSync(List.filled(2048, 1));
  }
}
