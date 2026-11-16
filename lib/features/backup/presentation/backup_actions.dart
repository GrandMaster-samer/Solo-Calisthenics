import 'dart:io';
import 'dart:isolate';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/providers.dart';
import '../../../l10n/app_l10n.dart';
import '../data/backup_service.dart';

/// Asks for a backup passphrase. With [confirm] it must be typed twice (export).
Future<String?> askPassphrase(BuildContext context, {required bool confirm}) {
  final l = AppL10n.of(context);
  final first = TextEditingController();
  final second = TextEditingController();
  final form = GlobalKey<FormState>();
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.backupPassphrase),
      content: Form(
        key: form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (confirm)
              Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(l.backupPassphraseHint)),
            TextFormField(
              key: const Key('passphrase'),
              controller: first,
              obscureText: true,
              autofocus: true,
              decoration: InputDecoration(labelText: l.backupPassphrase),
              validator: (v) => confirm && (v ?? '').length < BackupService.minPassphraseLength
                  ? l.backupPassphraseShort(BackupService.minPassphraseLength)
                  : ((v ?? '').isEmpty ? l.invalidValue : null),
            ),
            if (confirm) ...[
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('passphrase-again'),
                controller: second,
                obscureText: true,
                decoration: InputDecoration(labelText: l.backupPassphraseAgain),
                validator: (v) => v != first.text ? l.backupPassphraseMismatch : null,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        TextButton(
          key: const Key('passphrase-ok'),
          onPressed: () {
            if (form.currentState!.validate()) Navigator.pop(context, first.text);
          },
          child: Text(l.ok),
        ),
      ],
    ),
  );
}

/// Exports everything to a passphrase-encrypted file and opens the share sheet so
/// the user decides where it goes (Files, a drive, another device).
Future<void> exportBackup(BuildContext context, WidgetRef ref) async {
  final l = AppL10n.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final passphrase = await askPassphrase(context, confirm: true);
  if (passphrase == null) return;
  final control = ref.read(appControlProvider);
  final hexKey = await control.keyStore.read();
  if (hexKey == null) return;
  final database = control.databaseFile;
  final out = File(p.join((await getTemporaryDirectory()).path, BackupService.fileName(ref.read(clockProvider)())));
  try {
    await Isolate.run(
      () => BackupService.export(database: database, hexKey: hexKey, passphrase: passphrase, out: out),
    );
    await SharePlus.instance.share(ShareParams(files: [XFile(out.path)], subject: l.backupTitle));
  } on Object {
    messenger.showSnackBar(SnackBar(content: Text(l.backupExportFailed)));
  } finally {
    if (out.existsSync()) out.deleteSync(); // the user's copy is the only one that should remain
  }
}

/// Restores a backup file chosen by the user, replacing all current data, then restarts the app.
Future<void> importBackup(BuildContext context, WidgetRef ref) async {
  final l = AppL10n.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final picked = await FilePicker.pickFiles();
  final path = picked.firstOrNull?.path;
  if (path == null || !context.mounted) return;
  final passphrase = await askPassphrase(context, confirm: false);
  if (passphrase == null || !context.mounted) return;
  final sure = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.backupImportTitle),
      content: Text(l.backupImportBody),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.cancel)),
        TextButton(
          key: const Key('import-confirm'),
          onPressed: () => Navigator.pop(context, true),
          child: Text(l.backupImportConfirm),
        ),
      ],
    ),
  );
  if (sure != true) return;
  final control = ref.read(appControlProvider);
  final hexKey = await control.keyStore.read();
  if (hexKey == null) return;
  final database = control.databaseFile;
  final db = ref.read(databaseProvider);
  final schema = db.schemaVersion;
  final backup = File(path);
  try {
    // Nothing is replaced until the whole backup has been read successfully.
    await Isolate.run(
      () => BackupService.stageRestore(
        backup: backup,
        passphrase: passphrase,
        database: database,
        hexKey: hexKey,
        currentSchemaVersion: schema,
      ),
    );
  } on BackupTooNewException {
    messenger.showSnackBar(SnackBar(content: Text(l.backupTooNew)));
    return;
  } on Object {
    messenger.showSnackBar(SnackBar(content: Text(l.backupUnreadable)));
    return;
  }
  await db.close();
  BackupService.commitRestore(database);
  await control.restart();
}
