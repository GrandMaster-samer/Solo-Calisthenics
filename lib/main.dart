import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'app.dart';
import 'core/db/app_database.dart';
import 'core/db/encrypted_connection.dart';
import 'core/notifications/notification_service.dart';
import 'core/providers.dart';
import 'core/theme/app_colors.dart';
import 'features/exercises/data/exercise_repository.dart';
import 'features/profile/application/profile_controller.dart';
import 'features/profile/data/profile_repository.dart';
import 'features/settings/application/settings_controller.dart';
import 'features/settings/data/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Bundled fonts are under the SIL Open Font License; show it on the licenses page.
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([
      'Inter',
    ], await rootBundle.loadString('assets/fonts/Inter-OFL.txt'));
    yield LicenseEntryWithLineBreaks([
      'IBM Plex Sans Arabic',
    ], await rootBundle.loadString('assets/fonts/IBMPlexSansArabic-OFL.txt'));
  });
  await _boot();
}

Future<void> _boot() async {
  const keyStore = SecureKeyStore();
  final File file = await defaultDatabaseFile();
  final AppDatabase db;
  try {
    db = AppDatabase(await openAppExecutor(file: file, keyStore: keyStore));
    await db.customSelect('SELECT 1').get(); // forces open + migrations
  } on Object catch (e) {
    debugPrint('Database could not be opened: $e');
    runApp(
      _LockedApp(
        onReset: () async {
          await wipeAppData(file: file, keyStore: keyStore);
          await _boot();
        },
      ),
    );
    return;
  }

  final notifications = LocalNotificationService();
  try {
    await notifications.init();
  } on Object catch (e) {
    debugPrint(
      'Notifications unavailable: $e',
    ); // the app still works without them
  }

  final profiles = ProfileRepository(db);
  final settings = await SettingsRepository(db).load();
  final profile = await profiles.loadProfile();
  final injuries = await profiles.loadInjuries();
  final library = await ExerciseLibrary.load();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        exerciseLibraryProvider.overrideWithValue(library),
        notificationServiceProvider.overrideWithValue(notifications),
        initialSettingsProvider.overrideWithValue(settings),
        initialProfileProvider.overrideWithValue(
          ProfileState(profile: profile, injuries: injuries),
        ),
      ],
      child: const SoloApp(),
    ),
  );
}

/// Shown when the encrypted database cannot be unlocked (its key is gone).
/// Shown before localization is available, so the text is bilingual.
class _LockedApp extends StatelessWidget {
  const _LockedApp({required this.onReset});
  final Future<void> Function() onReset;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true)
          .copyWith(scaffoldBackgroundColor: AppColors.background),
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 56,
                  color: AppColors.warning,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your encrypted data cannot be unlocked on this device. '
                  'You can reset the app to start fresh. This deletes all local data.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'تعذّر فتح بياناتك المشفّرة على هذا الجهاز. يمكنك إعادة ضبط التطبيق للبدء من جديد. سيؤدي ذلك إلى حذف جميع البيانات المحلية.',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.error,
                  ),
                  onPressed: onReset,
                  child: const Text('Reset app data  ·  إعادة ضبط التطبيق'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
