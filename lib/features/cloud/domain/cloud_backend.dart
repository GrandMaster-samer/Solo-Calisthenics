import 'dart:io';

/// Limits that keep the optional cloud features inside a free tier.
abstract final class CloudLimits {
  /// Coach-review clips: at most this long, compressed to 720p before upload.
  static const maxClipSeconds = 30;
  static const maxClipBytes = 25 * 1024 * 1024;

  /// Clips are deleted after review, or after this many days at the latest.
  static const clipRetentionDays = 30;

  /// Largest backup file that can be uploaded.
  static const maxBackupBytes = 50 * 1024 * 1024;
}

class CloudUser {
  const CloudUser({required this.id, required this.email, this.isCoach = false});
  final String id;
  final String email;

  /// Coaches see the review inbox. Granted on the server, never by the app.
  final bool isCoach;
}

class CloudBackupInfo {
  const CloudBackupInfo({required this.updatedAt, required this.sizeBytes});
  final DateTime updatedAt;
  final int sizeBytes;
}

enum SubmissionStatus { pending, reviewed }

/// A clip sent for coach review, and the coach's feedback once it exists.
class Submission {
  const Submission({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.note,
    required this.status,
    required this.createdAt,
    this.videoPath,
    this.feedback,
    this.reviewedAt,
  });
  final String id;
  final String userId;
  final String exerciseId;
  final String note;
  final SubmissionStatus status;
  final DateTime createdAt;

  /// Storage path of the clip; null once it has been deleted.
  final String? videoPath;
  final String? feedback;
  final DateTime? reviewedAt;

  bool isExpired(DateTime now) => now.difference(createdAt).inDays >= CloudLimits.clipRetentionDays;
}

class NotSignedInException implements Exception {
  const NotSignedInException();
}

class CloudFileTooLargeException implements Exception {
  const CloudFileTooLargeException(this.bytes, this.limit);
  final int bytes;
  final int limit;
}

/// Everything the app needs from a server. The core app never depends on this:
/// when no backend is configured the provider is null and cloud features are hidden.
/// Implemented by [SupabaseBackend]; swap the implementation to change provider.
abstract interface class CloudBackend {
  // ---- Account ----
  CloudUser? get currentUser;

  /// Emits the current user now and on every sign-in / sign-out.
  Stream<CloudUser?> get userChanges;
  Future<void> signInWithGoogle();
  Future<void> signOut();

  /// Removes the user's backup, clips and submissions from the server.
  Future<void> deleteMyCloudData();

  // ---- Encrypted backup (the file is already encrypted on the device) ----
  Future<void> uploadBackup(File encryptedBackup);
  Future<CloudBackupInfo?> backupInfo();
  Future<void> downloadBackup(File into);

  // ---- Coach review ----
  Future<Submission> submitClip({required File clip, required String exerciseId, required String note});
  Future<List<Submission>> mySubmissions();

  /// Coach only: clips waiting for review, oldest first.
  Future<List<Submission>> reviewQueue();

  /// Short-lived link to play a clip.
  Future<Uri> clipUrl(Submission submission);

  /// Coach only: stores the feedback, marks the submission reviewed and deletes its clip.
  Future<void> sendFeedback(String submissionId, String feedback);

  /// Deletes clips older than [CloudLimits.clipRetentionDays] that this user may
  /// delete (their own; all of them for a coach). Returns how many were removed.
  Future<int> purgeExpiredClips({required DateTime now});
}

/// What the signed-in user is allowed to use. Coach review is the future paid
/// feature: add a store-backed implementation here and nothing else has to change.
abstract interface class Entitlements {
  Future<bool> canUseCoachReview(CloudUser user);
}

class FreeEntitlements implements Entitlements {
  const FreeEntitlements();

  // TODO: Payments - replace with a subscription check (store receipt verified on
  // the server). Until coach review is sold, every signed-in user may use it.
  @override
  Future<bool> canUseCoachReview(CloudUser user) async => true;
}
