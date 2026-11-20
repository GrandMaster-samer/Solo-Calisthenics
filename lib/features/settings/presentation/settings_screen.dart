import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/app_info.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/units.dart';
import '../../../l10n/app_l10n.dart';
import '../../backup/presentation/backup_actions.dart';
import '../../cloud/presentation/cloud_account_section.dart';
import '../../onboarding/presentation/onboarding_screen.dart';
import '../../security/presentation/lock_gate.dart';
import '../application/settings_controller.dart';
import '../data/settings_repository.dart';

final _biometricsAvailableProvider = FutureProvider<bool>(
  (ref) => ref.watch(appLockProvider).biometrics.isAvailable(),
);

/// Asks for the current PIN on a full-screen route. Returns true when accepted.
Future<bool> _confirmPin(BuildContext context) async {
  final ok = await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) =>
          PinEntryScreen(onUnlocked: () => Navigator.of(context).pop(true)),
    ),
  );
  return ok ?? false;
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final s = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);
    final volume = ref.watch(volumeButtonsProvider);
    final weekdays = l.weekdaysShort.split(',');
    final hasPin = ref.watch(hasPinProvider).value ?? false;

    Future<void> applyReminders(AppSettings next) async {
      final notifications = ref.read(notificationServiceProvider);
      await controller.change((_) => next);
      if (next.reminderDays.isNotEmpty) await notifications.requestPermission();
      await notifications.scheduleReminders(
        next.reminderDays,
        next.reminderMinutes,
        title: l.reminderTitle,
        body: l.reminderBody,
      );
    }

    Widget header(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.secondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    Widget choice<T>(
      String title,
      T value,
      Map<T, String> options,
      void Function(T) onChanged,
    ) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<T>(
              showSelectedIcon: false,
              segments: [
                for (final e in options.entries)
                  ButtonSegment(value: e.key, label: Text(e.value)),
              ],
              selected: {value},
              onSelectionChanged: (v) => onChanged(v.first),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.tabSettings)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          header(l.settingsGeneral),
          choice<String>(
            l.language,
            s.localeCode ?? '',
            {'': l.languageSystem, 'en': 'English', 'ar': 'العربية'},
            (v) => controller.change(
              (c) => c.copyWith(localeCode: () => v.isEmpty ? null : v),
            ),
          ),
          choice<WeightUnit>(l.weight, s.weightUnit, {
            WeightUnit.kg: l.unitKg,
            WeightUnit.lb: l.unitLb,
          }, (v) => controller.change((c) => c.copyWith(weightUnit: v))),
          choice<HeightUnit>(l.height, s.heightUnit, {
            HeightUnit.cm: l.unitCm,
            HeightUnit.ftIn: l.unitFtIn,
          }, (v) => controller.change((c) => c.copyWith(heightUnit: v))),
          ListTile(
            key: const Key('edit-profile'),
            leading: const Icon(Icons.person_outline),
            title: Text(l.editProfile),
            subtitle: Text(l.editProfileHint),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const OnboardingScreen(editing: true),
                fullscreenDialog: true,
              ),
            ),
          ),
          header(l.settingsWorkout),
          choice<EffortMode>(l.effortScale, s.effortMode, {
            EffortMode.rir: l.effortRir,
            EffortMode.rpe: l.effortRpe,
          }, (v) => controller.change((c) => c.copyWith(effortMode: v))),
          SwitchListTile(
            title: Text(l.settingSound),
            value: s.sound,
            onChanged: (v) => controller.change((c) => c.copyWith(sound: v)),
          ),
          SwitchListTile(
            title: Text(l.settingHaptics),
            value: s.haptics,
            onChanged: (v) => controller.change((c) => c.copyWith(haptics: v)),
          ),
          if (volume.isSupported)
            SwitchListTile(
              title: Text(l.settingVolumeButtons),
              subtitle: Text(l.settingVolumeButtonsHint),
              value: s.volumeButtons,
              onChanged: (v) =>
                  controller.change((c) => c.copyWith(volumeButtons: v)),
            ),
          header(l.settingsReminders),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: [
                for (var day = 1; day <= 7; day++)
                  FilterChip(
                    key: Key('reminder-day-$day'),
                    showCheckmark: false,
                    label: Text(weekdays[day - 1]),
                    labelStyle: TextStyle(
                      color: s.reminderDays.contains(day)
                          ? AppColors.background
                          : AppColors.textPrimary,
                    ),
                    selected: s.reminderDays.contains(day),
                    onSelected: (on) => applyReminders(
                      s.copyWith(
                        reminderDays: on
                            ? {...s.reminderDays, day}
                            : ({...s.reminderDays}..remove(day)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: Text(l.reminderTime),
            trailing: Text(
              westernDigits(
                TimeOfDay(
                  hour: s.reminderMinutes ~/ 60,
                  minute: s.reminderMinutes % 60,
                ).format(context),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: s.reminderMinutes ~/ 60,
                  minute: s.reminderMinutes % 60,
                ),
              );
              if (picked != null) {
                await applyReminders(
                  s.copyWith(reminderMinutes: picked.hour * 60 + picked.minute),
                );
              }
            },
          ),
          header(l.settingsSecurity),
          ListTile(
            key: const Key('pin-setting'),
            leading: const Icon(Icons.pin_outlined),
            title: Text(hasPin ? l.changePin : l.setPin),
            subtitle: Text(l.pinSettingHint),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              // Changing an existing PIN requires entering it first.
              if (hasPin && !await _confirmPin(context)) return;
              if (!context.mounted) return;
              await Navigator.of(context).push(
                MaterialPageRoute<bool>(builder: (_) => const PinSetupScreen()),
              );
            },
          ),
          if (hasPin) ...[
            ListTile(
              key: const Key('remove-pin'),
              leading: const Icon(Icons.lock_open),
              title: Text(l.removePin),
              onTap: () async {
                if (!await _confirmPin(context)) return;
                await ref.read(appLockProvider).clearPin();
                await controller.change(
                  (c) =>
                      c.copyWith(lockWholeApp: false, biometricUnlock: false),
                );
                ref.invalidate(hasPinProvider);
              },
            ),
            SwitchListTile(
              key: const Key('lock-whole-app'),
              title: Text(l.lockWholeApp),
              subtitle: Text(l.lockWholeAppHint),
              value: s.lockWholeApp,
              onChanged: (v) =>
                  controller.change((c) => c.copyWith(lockWholeApp: v)),
            ),
            if (ref.watch(_biometricsAvailableProvider).value ?? false)
              SwitchListTile(
                title: Text(l.useBiometrics),
                value: s.biometricUnlock,
                onChanged: (v) =>
                    controller.change((c) => c.copyWith(biometricUnlock: v)),
              ),
          ],
          header(l.backupTitle),
          ListTile(
            key: const Key('backup-export'),
            leading: const Icon(Icons.upload_file_outlined),
            title: Text(l.backupExport),
            subtitle: Text(l.backupExportHint),
            onTap: () => exportBackup(context, ref),
          ),
          ListTile(
            key: const Key('backup-import'),
            leading: const Icon(Icons.download_outlined),
            title: Text(l.backupImport),
            subtitle: Text(l.backupImportHint),
            onTap: () => importBackup(context, ref),
          ),
          const CloudAccountSection(),
          header(l.settingsAbout),
          ListTile(
            key: const Key('about-app'),
            leading: Image.asset(
              AppInfo.logoMark,
              width: 40,
              height: 40,
              excludeFromSemantics: true,
              errorBuilder: (_, _, _) => const SizedBox(width: 40),
            ),
            title: Text(
              l.appName,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              '${l.versionLabel(AppInfo.version)}\n${l.madeBy(AppInfo.developer)}',
            ),
            isThreeLine: true,
          ),
          ListTile(
            leading: const Icon(Icons.health_and_safety_outlined),
            title: Text(l.disclaimerTitle),
            onTap: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(l.disclaimerTitle),
                content: Text(l.disclaimerBody),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l.ok),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(l.privacyTitle),
            subtitle: Text(l.privacyBody),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l.licenses),
            onTap: () => showLicensePage(
              context: context,
              applicationName: l.appName,
              applicationVersion: AppInfo.version,
              applicationLegalese:
                  '© ${AppInfo.copyrightYear} ${AppInfo.developer}',
              applicationIcon: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(AppInfo.logoMark, width: 64, height: 64),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
