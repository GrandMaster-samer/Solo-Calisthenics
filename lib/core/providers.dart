import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/exercises/data/exercise_repository.dart';
import '../features/profile/data/profile_repository.dart';
import '../features/settings/data/settings_repository.dart';
import '../features/workout/data/workout_repository.dart';
import 'db/app_database.dart';
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
