import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/units.dart';
import '../../../l10n/app_l10n.dart';
import '../../backup/data/backup_service.dart';
import '../../backup/presentation/backup_actions.dart';
import '../application/cloud_providers.dart';
import '../domain/cloud_backend.dart';

/// Settings rows for the optional account: sign-in, encrypted cloud backup, sign-out.
/// Renders nothing when the build has no backend.
class CloudAccountSection extends ConsumerStatefulWidget {
  const CloudAccountSection({super.key});

  @override
  ConsumerState<CloudAccountSection> createState() => _CloudAccountSectionState();
}

class _CloudAccountSectionState extends ConsumerState<CloudAccountSection> {
  bool _busy = false;

  Future<void> _guard(Future<void> Function() action, String failure) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await action();
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(failure)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _upload() async {
    final l = AppL10n.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final passphrase = await askPassphrase(context, confirm: true);
    if (passphrase == null) return;
    setState(() => _busy = true);
    try {
      final service = await ref.read(cloudBackupServiceProvider.future);
      await service!.upload(passphrase);
      ref.invalidate(cloudBackupInfoProvider);
      messenger.showSnackBar(SnackBar(content: Text(l.cloudBackupDone)));
    } on CloudFileTooLargeException catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l.cloudBackupTooLarge(e.limit ~/ (1024 * 1024)))),
      );
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(l.cloudFailed)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    final l = AppL10n.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final passphrase = await askPassphrase(context, confirm: false);
    if (passphrase == null || !mounted) return;
    final sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.backupImportTitle),
        content: Text(l.backupImportBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.cancel)),
          TextButton(
            key: const Key('cloud-restore-confirm'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.backupImportConfirm),
          ),
        ],
      ),
    );
    if (sure != true) return;
    setState(() => _busy = true);
    final control = ref.read(appControlProvider);
    final db = ref.read(databaseProvider);
    try {
      final service = await ref.read(cloudBackupServiceProvider.future);
      await service!.downloadAndStage(passphrase, currentSchemaVersion: db.schemaVersion);
    } on BackupTooNewException {
      messenger.showSnackBar(SnackBar(content: Text(l.backupTooNew)));
      if (mounted) setState(() => _busy = false);
      return;
    } on BackupUnreadableException {
      messenger.showSnackBar(SnackBar(content: Text(l.backupUnreadable)));
      if (mounted) setState(() => _busy = false);
      return;
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(l.cloudFailed)));
      if (mounted) setState(() => _busy = false);
      return;
    }
    await db.close();
    BackupService.commitRestore(control.databaseFile);
    await control.restart();
  }

  @override
  Widget build(BuildContext context) {
    final backend = ref.watch(cloudBackendProvider);
    if (backend == null) return const SizedBox.shrink();
    final l = AppL10n.of(context);
    final user = ref.watch(cloudUserProvider).value;
    final info = ref.watch(cloudBackupInfoProvider).value;
    final dates = MaterialLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(l.cloudTitle, style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w700)),
        ),
        if (_busy) const LinearProgressIndicator(),
        if (user == null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(l.cloudOptionalHint, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              key: const Key('cloud-sign-in'),
              onPressed: _busy ? null : () => _guard(backend.signInWithGoogle, l.cloudFailed),
              icon: const Icon(Icons.login),
              label: Text(l.signInGoogle),
            ),
          ),
        ] else ...[
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: Text(user.email, textDirection: TextDirection.ltr),
            subtitle: Text(user.isCoach ? l.roleCoach : l.signedIn),
          ),
          ListTile(
            key: const Key('cloud-backup-upload'),
            leading: const Icon(Icons.cloud_upload_outlined),
            title: Text(l.cloudBackupNow),
            subtitle: Text(
              info == null
                  ? l.cloudBackupNone
                  : l.cloudBackupLast(westernDigits(dates.formatMediumDate(info.updatedAt))),
            ),
            enabled: !_busy,
            onTap: _upload,
          ),
          if (info != null)
            ListTile(
              key: const Key('cloud-backup-restore'),
              leading: const Icon(Icons.cloud_download_outlined),
              title: Text(l.cloudRestore),
              subtitle: Text(l.backupImportHint),
              enabled: !_busy,
              onTap: _restore,
            ),
          ListTile(
            key: const Key('cloud-sign-out'),
            leading: const Icon(Icons.logout),
            title: Text(l.signOut),
            enabled: !_busy,
            onTap: () => _guard(backend.signOut, l.cloudFailed),
          ),
          ListTile(
            key: const Key('cloud-delete-data'),
            leading: const Icon(Icons.delete_forever_outlined, color: AppColors.error),
            title: Text(l.cloudDeleteData),
            subtitle: Text(l.cloudDeleteDataHint),
            enabled: !_busy,
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l.cloudDeleteData),
                  content: Text(l.cloudDeleteDataBody),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.cancel)),
                    TextButton(
                      key: const Key('cloud-delete-confirm'),
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(l.delete, style: const TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              );
              if (ok != true) return;
              await _guard(() async {
                await backend.deleteMyCloudData();
                ref.invalidate(cloudBackupInfoProvider);
                ref.invalidate(mySubmissionsProvider);
              }, l.cloudFailed);
            },
          ),
        ],
      ],
    );
  }
}
