import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:solo_calisthenics/core/db/app_database.dart';
import 'package:solo_calisthenics/core/db/encrypted_connection.dart';
import 'package:solo_calisthenics/features/backup/data/backup_service.dart';
import 'package:solo_calisthenics/features/cloud/application/cloud_providers.dart';
import 'package:solo_calisthenics/features/cloud/data/cloud_config.dart';
import 'package:solo_calisthenics/features/cloud/domain/cloud_backend.dart';
import 'package:solo_calisthenics/features/profile/data/profile_repository.dart';
import 'package:solo_calisthenics/features/progress/data/analytics_repository.dart';
import 'package:solo_calisthenics/features/workout/data/workout_repository.dart';

import '../helpers.dart';
import '../workout/session_persistence_test.dart' show MemoryKeyStore;
import 'fake_backend.dart';

void main() {
  late Directory dir;
  late FakeClock clock;
  late FakeCloudBackend backend;
  setUp(() {
    dir = Directory.systemTemp.createTempSync('solo_cloud');
    clock = FakeClock();
    backend = FakeCloudBackend(clock: clock.call);
  });
  tearDown(() => dir.deleteSync(recursive: true));

  Future<void> direct(void Function() work) async => work();

  Future<({File file, MemoryKeyStore keys, CloudBackupService service})> device(String name) async {
    final file = File('${dir.path}/$name.db');
    final keys = MemoryKeyStore();
    final db = AppDatabase(await openAppExecutor(file: file, keyStore: keys));
    await db.customSelect('SELECT 1').get();
    await db.close();
    final temp = Directory('${dir.path}/tmp_$name')..createSync();
    return (
      file: file,
      keys: keys,
      service: CloudBackupService(
        backend: backend,
        databaseFile: file,
        keyStore: keys,
        tempDirectory: temp,
        runner: direct,
      ),
    );
  }

  test('no cloud configuration in a default build', () {
    expect(CloudConfig.fromEnvironment(), isNull);
  });

  group('encrypted cloud backup', () {
    test('upload needs a signed-in user', () async {
      final a = await device('a');
      await expectLater(a.service.upload('long passphrase'), throwsA(isA<NotSignedInException>()));
    });

    test('phone A uploads, phone B restores with the passphrase; the server only holds ciphertext', () async {
      final a = await device('a');
      var db = AppDatabase(openEncryptedExecutor(a.file, (await a.keys.read())!));
      await ProfileRepository(db).save(testProfile, const []);
      await WorkoutRepository(db).createSession('Cloud session', const [], now: clock.now);
      await AnalyticsRepository(db).addPhoto(tinyPng, takenAt: clock.now);
      await db.close();

      await backend.signInWithGoogle();
      await a.service.upload('long passphrase');
      final stored = String.fromCharCodes(backend.backups['athlete-1']!);
      expect(stored.startsWith('SQLite format 3'), isFalse);
      expect(stored.contains('Cloud session'), isFalse);
      expect((await backend.backupInfo())!.updatedAt, clock.now);
      expect(Directory('${dir.path}/tmp_a').listSync(), isEmpty, reason: 'no temp copy left on the phone');

      // New phone, same Google account, different device key.
      final b = await device('b');
      await expectLater(
        b.service.downloadAndStage('wrong passphrase', currentSchemaVersion: 2),
        throwsA(isA<BackupUnreadableException>()),
      );
      await b.service.downloadAndStage('long passphrase', currentSchemaVersion: 2);
      BackupService.commitRestore(b.file);
      db = AppDatabase(openEncryptedExecutor(b.file, (await b.keys.read())!));
      addTearDown(db.close);
      expect((await WorkoutRepository(db).loadActive())!.name, 'Cloud session');
      expect((await ProfileRepository(db).loadProfile())!.birthYear, testProfile.birthYear);
      expect((await AnalyticsRepository(db).photos()).length, 1);
      expect(Directory('${dir.path}/tmp_b').listSync(), isEmpty);
    });

    test('a failed upload leaves no temp file and reports the error', () async {
      final a = await device('a');
      await backend.signInWithGoogle();
      backend.failNextCall = true;
      await expectLater(a.service.upload('long passphrase'), throwsA(isA<SocketException>()));
      expect(Directory('${dir.path}/tmp_a').listSync(), isEmpty);
      expect(backend.backups, isEmpty);
    });

    test('another account cannot see the backup', () async {
      final a = await device('a');
      await backend.signInWithGoogle();
      await a.service.upload('long passphrase');
      await backend.signOut();
      backend.nextUser = const CloudUser(id: 'someone-else', email: 'x@example.com');
      await backend.signInWithGoogle();
      expect(await backend.backupInfo(), isNull);
    });
  });

  group('coach review rules', () {
    File clip([int bytes = 1024]) => File('${dir.path}/c$bytes.mp4')..writeAsBytesSync(List.filled(bytes, 0));
    const coach = CloudUser(id: 'coach-1', email: 'coach@example.com', isCoach: true);

    test('submit, review, feedback: the clip is deleted the moment feedback is sent', () async {
      await backend.signInWithGoogle();
      final s = await backend.submitClip(clip: clip(), exerciseId: 'muscle_up_negative', note: 'Left elbow?');
      expect(backend.clips.length, 1);
      expect(await backend.reviewQueue(), isEmpty, reason: 'athletes never see the queue');
      await expectLater(backend.sendFeedback(s.id, 'self-review'), throwsStateError);

      await backend.signOut();
      backend.nextUser = coach;
      await backend.signInWithGoogle();
      final queue = await backend.reviewQueue();
      expect(queue.single.note, 'Left elbow?');
      expect((await backend.clipUrl(queue.single)).toString(), contains('token='));
      await backend.sendFeedback(s.id, 'Keep the bar closer.');
      expect(backend.clips, isEmpty);
      expect(await backend.reviewQueue(), isEmpty);

      await backend.signOut();
      backend.nextUser = const CloudUser(id: 'athlete-1', email: 'athlete@example.com');
      await backend.signInWithGoogle();
      final mine = (await backend.mySubmissions()).single;
      expect(mine.status, SubmissionStatus.reviewed);
      expect(mine.feedback, 'Keep the bar closer.');
      expect(mine.videoPath, isNull);
      await expectLater(backend.clipUrl(mine), throwsStateError);
    });

    test('unreviewed clips are purged after 30 days, not before', () async {
      await backend.signInWithGoogle();
      await backend.submitClip(clip: clip(), exerciseId: 'pull_up', note: '');
      clock.advance(const Duration(days: 29));
      expect(await backend.purgeExpiredClips(now: clock.now), 0);
      expect(backend.clips.length, 1);
      clock.advance(const Duration(days: 1));
      expect(await backend.purgeExpiredClips(now: clock.now), 1);
      expect(backend.clips, isEmpty);
      expect((await backend.mySubmissions()).single.status, SubmissionStatus.pending);
      expect(await backend.purgeExpiredClips(now: clock.now), 0, reason: 'idempotent');
    });

    test('an athlete purges only their own clips; a coach purges everyone\'s', () async {
      await backend.signInWithGoogle();
      await backend.submitClip(clip: clip(), exerciseId: 'pull_up', note: '');
      await backend.signOut();
      backend.nextUser = const CloudUser(id: 'athlete-2', email: 'b@example.com');
      await backend.signInWithGoogle();
      await backend.submitClip(clip: clip(), exerciseId: 'dip', note: '');
      clock.advance(const Duration(days: 31));
      expect(await backend.purgeExpiredClips(now: clock.now), 1);
      expect(backend.clips.keys.single, startsWith('athlete-1/'));
      await backend.signOut();
      backend.nextUser = coach;
      await backend.signInWithGoogle();
      expect(await backend.purgeExpiredClips(now: clock.now), 1);
      expect(backend.clips, isEmpty);
    });

    test('oversized clips are refused; deleting cloud data removes everything of that user only', () async {
      await backend.signInWithGoogle();
      await expectLater(
        backend.submitClip(clip: clip(CloudLimits.maxClipBytes + 1), exerciseId: 'dip', note: ''),
        throwsA(isA<CloudFileTooLargeException>()),
      );
      await backend.submitClip(clip: clip(), exerciseId: 'dip', note: '');
      backend.backups['athlete-1'] = [1, 2, 3];
      backend.backups['other'] = [9];
      await backend.deleteMyCloudData();
      expect(backend.clips, isEmpty);
      expect(await backend.mySubmissions(), isEmpty);
      expect(backend.backups.keys, ['other']);
    });

    test('coach review is open to every signed-in user until payments exist', () async {
      expect(await const FreeEntitlements().canUseCoachReview(coach), isTrue);
    });
  });
}
