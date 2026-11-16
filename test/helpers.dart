import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:material_ui/material_ui.dart';
import 'package:solo_calisthenics/app.dart';
import 'package:solo_calisthenics/core/db/app_database.dart';
import 'package:solo_calisthenics/core/notifications/notification_service.dart';
import 'package:solo_calisthenics/core/platform/volume_buttons.dart';
import 'package:solo_calisthenics/core/providers.dart';
import 'package:solo_calisthenics/features/exercises/data/exercise_repository.dart';
import 'package:solo_calisthenics/features/exercises/domain/exercise.dart';
import 'package:solo_calisthenics/features/profile/application/profile_controller.dart';
import 'package:solo_calisthenics/features/profile/domain/profile.dart';
import 'package:solo_calisthenics/features/settings/application/settings_controller.dart';
import 'package:solo_calisthenics/features/settings/data/settings_repository.dart';

/// The real bundled seed data.
ExerciseLibrary loadLibrary() => ExerciseLibrary.fromJsonString(
  File('assets/data/exercises.json').readAsStringSync(),
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

  List<Override> overrides({
    UserProfile? profile = testProfile,
    List<Injury> injuries = const [],
    AppSettings settings = const AppSettings(localeCode: 'en'),
  }) => [
    databaseProvider.overrideWithValue(db),
    exerciseLibraryProvider.overrideWithValue(library),
    notificationServiceProvider.overrideWithValue(notifications),
    clockProvider.overrideWithValue(clock.call),
    volumeButtonsProvider.overrideWithValue(volume),
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
  }) => ProviderScope(
    overrides: overrides(
      profile: profile,
      injuries: injuries,
      settings: AppSettings(localeCode: locale),
    ),
    child: const SoloApp(),
  );
}
