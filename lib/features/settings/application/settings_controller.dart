import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../data/settings_repository.dart';

/// Settings loaded before the first frame; overridden in main().
final initialSettingsProvider = Provider<AppSettings>(
  (ref) => const AppSettings(),
);

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.read(initialSettingsProvider);

  Future<void> change(AppSettings Function(AppSettings current) update) async {
    state = update(state);
    await ref.read(settingsRepositoryProvider).save(state);
  }
}
