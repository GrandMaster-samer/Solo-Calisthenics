import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../features/exercises/data/exercise_repository.dart';
import '../features/profile/data/profile_repository.dart';
import '../features/settings/data/settings_repository.dart';
import '../features/workout/data/workout_repository.dart';
import '../features/progress/data/analytics_repository.dart';
import '../features/security/data/app_lock.dart';
import 'db/app_database.dart';
import 'db/encrypted_connection.dart';
import 'notifications/notification_service.dart';
import 'platform/volume_buttons.dart';

// Overridden in main() (and in tests) once the dependencies are ready.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider not overridden'),
);
final exerciseLibraryProvider = Provider<ExerciseLibrary>(
  (ref) => throw UnimplementedError('exerciseLibraryProvider not overridden'),
);
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NoopNotificationService(),
);

/// Injectable clock so timers are testable.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);
final volumeButtonsProvider = Provider<VolumeButtons>(
  (ref) => const VolumeButtons(),
);

final profileRepositoryProvider = Provider(
  (ref) => ProfileRepository(ref.watch(databaseProvider)),
);
final settingsRepositoryProvider = Provider(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);
final workoutRepositoryProvider = Provider(
  (ref) => WorkoutRepository(ref.watch(databaseProvider)),
);

final analyticsRepositoryProvider = Provider(
  (ref) => AnalyticsRepository(ref.watch(databaseProvider)),
);

/// One instance for the app's lifetime so failed-attempt counting is not reset.
final appLockProvider = Provider<AppLock>(
  (ref) => AppLock(const SecureSecretStore(), DeviceBiometrics()),
);

/// Handles to things only main() knows: where the database lives and how to restart.
class AppControl {
  const AppControl({
    required this.databaseFile,
    required this.keyStore,
    required this.restart,
  });
  final File databaseFile;
  final KeyStore keyStore;

  /// Closes the database and boots the app again (after a restore or a wipe).
  final Future<void> Function() restart;
}

final appControlProvider = Provider<AppControl>(
  (ref) => throw UnimplementedError('appControlProvider not overridden'),
);

/// Returns the bytes of a photo from the camera or the gallery, or null if cancelled.
/// The picked image is downscaled and never written to the gallery by the app.
typedef PhotoPicker = Future<Uint8List?> Function({required bool camera});

final photoPickerProvider = Provider<PhotoPicker>((ref) {
  return ({required bool camera}) async {
    final file = await ImagePicker().pickImage(
      source: camera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 82,
    );
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    try {
      await File(file.path)
          .delete(); // do not leave an unencrypted copy in the cache
    } on Object {
      // Some sources hand out paths that cannot be deleted.
    }
    return bytes;
  };
});
