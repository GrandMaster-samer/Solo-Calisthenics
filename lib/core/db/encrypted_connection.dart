import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

/// Where the database encryption key lives. Abstracted so tests can use an in-memory store.
abstract interface class KeyStore {
  Future<String?> read();
  Future<void> write(String hexKey);
  Future<void> delete();
}

class SecureKeyStore implements KeyStore {
  const SecureKeyStore();
  static const _name = 'db_key_v1';
  static const _storage = FlutterSecureStorage();

  @override
  Future<String?> read() => _storage.read(key: _name);
  @override
  Future<void> write(String hexKey) =>
      _storage.write(key: _name, value: hexKey);
  @override
  Future<void> delete() => _storage.delete(key: _name);
}

/// 256-bit random key as 64 hex characters.
String generateHexKey([Random? random]) {
  final r = random ?? Random.secure();
  return List.generate(
    32,
    (_) => r.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();
}

/// Thrown when the database file exists but cannot be decrypted (for example the
/// key was wiped from the keystore). The app offers a reset in that case.
class DatabaseLockedException implements Exception {
  const DatabaseLockedException(this.cause);
  final Object cause;
  @override
  String toString() => 'DatabaseLockedException: $cause';
}

void _applyKey(Database db, String hexKey) {
  db.execute('PRAGMA key = "x\'$hexKey\'";');
  if (db.select('PRAGMA cipher_version;').isEmpty) {
    // Never fall back to plaintext silently.
    throw StateError('SQLCipher is not available in this build');
  }
  db.execute('PRAGMA foreign_keys = ON;');
  db.select(
    'SELECT count(*) FROM sqlite_master;',
  ); // fails here if the key is wrong
}

/// Opens (or creates) an SQLCipher-encrypted database file.
QueryExecutor openEncryptedExecutor(File file, String hexKey) {
  return NativeDatabase(file, setup: (db) => _applyKey(db, hexKey));
}

Future<File> defaultDatabaseFile() async {
  final dir = await getApplicationSupportDirectory();
  return File(p.join(dir.path, 'solo_calisthenics.db'));
}

/// Loads the key (creating it on first launch) and returns an executor for [file].
Future<QueryExecutor> openAppExecutor({
  required File file,
  required KeyStore keyStore,
}) async {
  var key = await keyStore.read();
  if (key == null) {
    if (file.existsSync()) {
      throw const DatabaseLockedException(
        'database exists but its key is missing',
      );
    }
    key = generateHexKey();
    await keyStore.write(key);
  }
  // Probe synchronously so a wrong key surfaces now instead of on the first query.
  try {
    final probe = sqlite3.open(file.path);
    try {
      _applyKey(probe, key);
    } finally {
      probe.close();
    }
  } on Object catch (e) {
    throw DatabaseLockedException(e);
  }
  return openEncryptedExecutor(file, key);
}

/// Deletes the database and its key. Used by the "reset app data" recovery path.
Future<void> wipeAppData({
  required File file,
  required KeyStore keyStore,
}) async {
  for (final suffix in ['', '-wal', '-shm', '-journal']) {
    final f = File('${file.path}$suffix');
    if (f.existsSync()) f.deleteSync();
  }
  await keyStore.delete();
}
