import 'dart:io';
import 'dart:isolate';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../../core/db/encrypted_connection.dart';
import '../../../core/providers.dart';
import '../../backup/data/backup_service.dart';
import '../data/clip_source.dart';
import '../domain/cloud_backend.dart';

/// Null when the build has no backend configured: every cloud feature is hidden
/// and the app behaves exactly as in Phases 1 and 2. Overridden in main().
final cloudBackendProvider = Provider<CloudBackend?>((ref) => null);

final cloudUserProvider = StreamProvider<CloudUser?>((ref) {
  final backend = ref.watch(cloudBackendProvider);
  return backend == null ? Stream.value(null) : backend.userChanges;
});

final entitlementsProvider = Provider<Entitlements>(
  (ref) => const FreeEntitlements(),
);
final clipSourceProvider = Provider<ClipSource>((ref) => DeviceClipSource());

final cloudBackupInfoProvider = FutureProvider<CloudBackupInfo?>((ref) async {
  final user = ref.watch(cloudUserProvider).value;
  final backend = ref.watch(cloudBackendProvider);
  return user == null || backend == null ? null : backend.backupInfo();
});

final mySubmissionsProvider = FutureProvider<List<Submission>>((ref) async {
  final user = ref.watch(cloudUserProvider).value;
  final backend = ref.watch(cloudBackendProvider);
  return user == null || backend == null ? const [] : backend.mySubmissions();
});

final reviewQueueProvider = FutureProvider<List<Submission>>((ref) async {
  final user = ref.watch(cloudUserProvider).value;
  final backend = ref.watch(cloudBackendProvider);
  return user == null || !user.isCoach || backend == null
      ? const []
      : backend.reviewQueue();
});

/// Runs CPU-heavy work off the UI thread. Tests replace it with a direct call.
typedef HeavyRunner = Future<void> Function(void Function() work);

Future<void> isolateRunner(void Function() work) => Isolate.run(work);

/// Cloud backup = the Phase 2 passphrase-encrypted backup file, stored on the server.
/// The passphrase and the plaintext never leave the device.
class CloudBackupService {
  CloudBackupService({
    required this.backend,
    required this.databaseFile,
    required this.keyStore,
    required this.tempDirectory,
    this.runner = isolateRunner,
  });
  final CloudBackend backend;
  final File databaseFile;
  final KeyStore keyStore;
  final Directory tempDirectory;
  final HeavyRunner runner;

  File get _temp =>
      File(p.join(tempDirectory.path, 'cloud.${BackupService.fileExtension}'));

  Future<void> upload(String passphrase) async {
    final hexKey = await keyStore.read();
    if (hexKey == null) throw StateError('database key missing');
    final out = _temp;
    final database = databaseFile;
    try {
      await runner(
        () => BackupService.export(
          database: database,
          hexKey: hexKey,
          passphrase: passphrase,
          out: out,
        ),
      );
      final size = out.lengthSync();
      if (size > CloudLimits.maxBackupBytes) {
        throw CloudFileTooLargeException(size, CloudLimits.maxBackupBytes);
      }
      await backend.uploadBackup(out);
    } finally {
      if (out.existsSync()) out.deleteSync();
    }
  }

  /// Downloads the cloud backup and stages it next to the database. Throws
  /// [BackupUnreadableException] on a wrong passphrase; nothing is replaced until
  /// [BackupService.commitRestore] is called with the database closed.
  Future<void> downloadAndStage(
    String passphrase, {
    required int currentSchemaVersion,
  }) async {
    final hexKey = await keyStore.read();
    if (hexKey == null) throw StateError('database key missing');
    final file = _temp;
    final database = databaseFile;
    try {
      await backend.downloadBackup(file);
      await runner(
        () => BackupService.stageRestore(
          backup: file,
          passphrase: passphrase,
          database: database,
          hexKey: hexKey,
          currentSchemaVersion: currentSchemaVersion,
        ),
      );
    } finally {
      if (file.existsSync()) file.deleteSync();
    }
  }
}

/// Temp directory for cloud backup work; overridden in tests.
final cloudTempDirectoryProvider = Provider<Future<Directory> Function()>(
  (ref) =>
      () async => Directory.systemTemp,
);
final heavyRunnerProvider = Provider<HeavyRunner>((ref) => isolateRunner);

final cloudBackupServiceProvider = FutureProvider<CloudBackupService?>((
  ref,
) async {
  final backend = ref.watch(cloudBackendProvider);
  if (backend == null) return null;
  final control = ref.watch(appControlProvider);
  return CloudBackupService(
    backend: backend,
    databaseFile: control.databaseFile,
    keyStore: control.keyStore,
    tempDirectory: await ref.watch(cloudTempDirectoryProvider)(),
    runner: ref.watch(heavyRunnerProvider),
  );
});
