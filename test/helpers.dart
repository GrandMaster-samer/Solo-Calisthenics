import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:material_ui/material_ui.dart';
import 'package:solo_calisthenics/app.dart';
import 'package:solo_calisthenics/core/db/app_database.dart';
import 'package:solo_calisthenics/core/notifications/notification_service.dart';
import 'package:solo_calisthenics/core/platform/volume_buttons.dart';
import 'package:solo_calisthenics/core/providers.dart';
import 'package:solo_calisthenics/features/cloud/application/cloud_providers.dart';
import 'package:solo_calisthenics/features/cloud/data/clip_source.dart';
import 'package:solo_calisthenics/features/cloud/domain/cloud_backend.dart';
import 'package:solo_calisthenics/features/cloud/presentation/coach_screens.dart';
import 'package:solo_calisthenics/features/exercises/data/exercise_repository.dart';
import 'package:solo_calisthenics/features/exercises/presentation/exercise_illustration.dart';
import 'package:solo_calisthenics/features/exercises/domain/exercise.dart';
import 'package:solo_calisthenics/features/profile/application/profile_controller.dart';
import 'package:solo_calisthenics/features/profile/domain/profile.dart';
import 'package:solo_calisthenics/features/security/data/app_lock.dart';
import 'package:solo_calisthenics/features/settings/application/settings_controller.dart';
import 'package:solo_calisthenics/features/settings/data/settings_repository.dart';

/// The real bundled seed data.
ExerciseLibrary loadLibrary() => ExerciseLibrary.fromJsonString(
  File('assets/data/exercises.json').readAsStringSync(),
  illustrations: File('assets/data/illustrations.json').readAsStringSync(),
);

AppDatabase memoryDb() => AppDatabase(NativeDatabase.memory());

/// Minimal exercise for rule tests. [stress] maps joints to stress levels.
Exercise fakeExercise(
  String id, {
  Map<Joint, StressLevel> stress = const {},
  String? regression,
  int sets = 3,
  ExerciseType type = ExerciseType.reps,
}) => Exercise(
  id: id,
  pattern: MovementPattern.push,
  chainId: 'chain',
  level: 1,
  type: type,
  defaultSets: sets,
  targetMin: 5,
  targetMax: 10,
  restSec: 60,
  jointStress: stress,
  equipment: const [],
  name: Localized({'en': id, 'ar': id}),
  cues: const Localized({'en': [], 'ar': []}),
  mistakes: const Localized({'en': [], 'ar': []}),
  regressionId: regression,
);

/// Clock that only moves when a test says so.
class FakeClock {
  FakeClock([DateTime? start]) : now = start ?? DateTime(2026, 1, 5, 18);
  DateTime now;
  DateTime call() => now;
  void advance(Duration d) => now = now.add(d);
}

/// Stands in for the Android hardware buttons.
class FakeVolumeButtons implements VolumeButtons {
  final _presses = StreamController<String>.broadcast();
  bool capturing = false;

  void press(String button) => _presses.add(button);

  @override
  bool get isSupported => true;
  @override
  Future<void> setCapture(bool enabled) async => capturing = enabled;
  @override
  Stream<String> get presses => _presses.stream;
}

class MemorySecretStore implements SecretStore {
  final values = <String, String>{};
  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<void> write(String key, String value) async => values[key] = value;
  @override
  Future<void> delete(String key) async => values.remove(key);
}

class FakeBiometrics implements Biometrics {
  bool available = false;
  bool accept = true;
  @override
  Future<bool> isAvailable() async => available;
  @override
  Future<bool> authenticate(String reason) async => accept;
}

/// A valid 1x1 PNG, standing in for a camera photo.
final tinyPng = Uint8List.fromList(const [
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52, //
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42, 0x60, 0x82,
]);

const testProfile = UserProfile(
  birthYear: 1995,
  heightCm: 178,
  weightKg: 74,
  experience: Experience.intermediate,
);

class TestEnv {
  TestEnv({AppDatabase? db, FakeClock? clock})
    : db = db ?? memoryDb(),
      clock = clock ?? FakeClock();
  final AppDatabase db;
  final FakeClock clock;
  final notifications = NoopNotificationService();
  final library = loadLibrary();
  final volume = FakeVolumeButtons();

  /// Set before building the app to enable the optional cloud features.
  CloudBackend? cloud;
  ClipSource? clipSource;
  final biometrics = FakeBiometrics();
  late final appLock = AppLock(MemorySecretStore(), biometrics);

  List<Override> overrides({
    UserProfile? profile = testProfile,
    List<Injury> injuries = const [],
    AppSettings settings = const AppSettings(localeCode: 'en'),
  }) => [
    databaseProvider.overrideWithValue(db),
    exerciseLibraryProvider.overrideWithValue(library),
    notificationServiceProvider.overrideWithValue(notifications),
    clockProvider.overrideWithValue(clock.call),
    // Looping animations would never let pumpAndSettle finish.
    animateIllustrationsProvider.overrideWithValue(false),
    volumeButtonsProvider.overrideWithValue(volume),
    cloudBackendProvider.overrideWithValue(cloud),
    if (clipSource != null) clipSourceProvider.overrideWithValue(clipSource!),
    clipPlayerBuilderProvider.overrideWithValue((url) => Text('PLAYER $url')),
    appLockProvider.overrideWithValue(appLock),
    photoPickerProvider.overrideWithValue(
      ({required bool camera}) async => tinyPng,
    ),
    initialSettingsProvider.overrideWithValue(settings),
    initialProfileProvider.overrideWithValue(
      ProfileState(profile: profile, injuries: injuries),
    ),
  ];

  ProviderContainer container({List<Injury> injuries = const []}) =>
      ProviderContainer(overrides: overrides(injuries: injuries));

  /// The whole app, as main() builds it.
  Widget app({
    UserProfile? profile = testProfile,
    List<Injury> injuries = const [],
    String locale = 'en',
    AppSettings? settings,
  }) => ProviderScope(
    overrides: overrides(
      profile: profile,
      injuries: injuries,
      settings: settings ?? AppSettings(localeCode: locale),
    ),
    child: const SoloApp(),
  );
}
