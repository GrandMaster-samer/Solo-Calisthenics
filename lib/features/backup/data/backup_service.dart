import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

/// Thrown when a backup file cannot be opened with the given passphrase
/// (wrong passphrase, or not a Solo Calisthenics backup).
class BackupUnreadableException implements Exception {
  const BackupUnreadableException();
}

/// Thrown when the backup was made by a newer app version than this one.
class BackupTooNewException implements Exception {
  const BackupTooNewException();
}

/// Encrypted backup files the user controls.
///
/// A backup is a complete SQLCipher database re-encrypted with the user's passphrase
/// (SQLCipher derives the key with PBKDF2). It contains everything: profile, workouts,
/// progress and photos. It can be opened with any SQLCipher 4 tool and the passphrase.
abstract final class BackupService {
  static const fileExtension = 'solobackup';
  static const minPassphraseLength = 8;

  static String _quote(String s) => "'${s.replaceAll("'", "''")}'";

  static String fileName(DateTime now) =>
      'solo-calisthenics-${now.toIso8601String().substring(0, 10)}.$fileExtension';

  /// Writes a passphrase-encrypted copy of the app database to [out].
  static void export({
    required File database,
    required String hexKey,
    required String passphrase,
    required File out,
  }) {
    if (out.existsSync()) out.deleteSync();
    final db = sqlite3.open(database.path);
    try {
      db.execute('PRAGMA key = "x\'$hexKey\'";');
      final version = db.select('PRAGMA user_version;').first.values.first as int;
      db.execute('ATTACH DATABASE ${_quote(out.path)} AS backup KEY ${_quote(passphrase)};');
      db.select("SELECT sqlcipher_export('backup');");
      db.execute('PRAGMA backup.user_version = $version;');
      db.execute('DETACH DATABASE backup;');
    } finally {
      db.close();
    }
  }

  static File _staged(File database) => File('${database.path}.restore');

  /// Step 1 of a restore: reads [backup] with [passphrase] and writes a copy
  /// re-encrypted with the device key next to the app database. Safe to run while
  /// the app database is open; nothing is replaced yet.
  static void stageRestore({
    required File backup,
    required String passphrase,
    required File database,
    required String hexKey,
    required int currentSchemaVersion,
  }) {
    final staged = _staged(database);
    if (staged.existsSync()) staged.deleteSync();
    // The new copy is the main database; the backup is attached and only read from.
    final db = sqlite3.open(staged.path);
    try {
      db.execute('PRAGMA key = "x\'$hexKey\'";');
      final int version;
      try {
        db.execute('ATTACH DATABASE ${_quote(backup.path)} AS backup KEY ${_quote(passphrase)};');
        final tables = db.select("SELECT name FROM backup.sqlite_master WHERE type = 'table' AND name = 'profiles';");
        if (tables.isEmpty) throw const BackupUnreadableException();
        version = db.select('PRAGMA backup.user_version;').first.values.first as int;
      } on SqliteException {
        throw const BackupUnreadableException();
      }
      if (version > currentSchemaVersion) throw const BackupTooNewException();
      db.select("SELECT sqlcipher_export('main', 'backup');");
      db.execute('PRAGMA user_version = $version;'); // older backups migrate on next open
      db.execute('DETACH DATABASE backup;');
    } catch (_) {
      db.close();
      if (staged.existsSync()) staged.deleteSync();
      rethrow;
    }
    db.close();
  }

  /// Step 2: swaps the staged copy in. The app database must be closed first.
  static void commitRestore(File database) {
    final staged = _staged(database);
    if (!staged.existsSync()) throw StateError('no staged restore');
    for (final suffix in ['-wal', '-shm', '-journal']) {
      final f = File('${database.path}$suffix');
      if (f.existsSync()) f.deleteSync();
    }
    staged.renameSync(database.path);
  }
}
