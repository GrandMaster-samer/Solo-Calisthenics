import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// Small secret key/value store (platform keystore in the app, a map in tests).
abstract interface class SecretStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

class SecureSecretStore implements SecretStore {
  const SecureSecretStore();
  static const _storage = FlutterSecureStorage();
  @override
  Future<String?> read(String key) => _storage.read(key: key);
  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);
  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// Device biometrics. Abstracted so tests do not need the platform plugin.
abstract interface class Biometrics {
  Future<bool> isAvailable();
  Future<bool> authenticate(String reason);
}

class DeviceBiometrics implements Biometrics {
  final _auth = LocalAuthentication();

  @override
  Future<bool> isAvailable() async {
    try {
      return await _auth.canCheckBiometrics && await _auth.isDeviceSupported();
    } on Object {
      return false;
    }
  }

  @override
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
      );
    } on Object {
      return false; // cancelled, not enrolled, locked out: fall back to the PIN
    }
  }
}

/// PIN protection for the photo vault and (optionally) the whole app.
/// Only a salted PBKDF2 hash of the PIN is stored, in the platform keystore.
class AppLock {
  AppLock(this._store, this.biometrics);
  final SecretStore _store;
  final Biometrics biometrics;

  static const _key = 'app_lock_pin_v1';
  static const iterations = 60000;
  static const minPinLength = 4;
  static const maxPinLength = 8;

  /// Wrong attempts allowed before a pause is enforced.
  static const maxAttempts = 5;
  static const lockout = Duration(seconds: 30);

  int _failed = 0;
  DateTime? _lockedUntil;

  static bool isValidPin(String pin) =>
      pin.length >= minPinLength &&
      pin.length <= maxPinLength &&
      RegExp(r'^\d+$').hasMatch(pin);

  Future<bool> hasPin() async => await _store.read(_key) != null;

  Future<void> setPin(String pin) async {
    if (!isValidPin(pin)) {
      throw ArgumentError('PIN must be $minPinLength-$maxPinLength digits');
    }
    final r = Random.secure();
    final salt = Uint8List.fromList(List.generate(16, (_) => r.nextInt(256)));
    final hash = pbkdf2(utf8.encode(pin), salt, iterations);
    await _store.write(
      _key,
      '$iterations:${base64Encode(salt)}:${base64Encode(hash)}',
    );
    _failed = 0;
    _lockedUntil = null;
  }

  Future<void> clearPin() => _store.delete(_key);

  /// Time left before another attempt is allowed, or zero.
  Duration lockoutRemaining(DateTime now) {
    final until = _lockedUntil;
    return until == null || !until.isAfter(now)
        ? Duration.zero
        : until.difference(now);
  }

  Future<bool> verify(String pin, {required DateTime now}) async {
    if (lockoutRemaining(now) > Duration.zero) return false;
    final stored = await _store.read(_key);
    if (stored == null) return false;
    final parts = stored.split(':');
    if (parts.length != 3) return false;
    final hash = pbkdf2(
      utf8.encode(pin),
      base64Decode(parts[1]),
      int.parse(parts[0]),
    );
    final ok = _constantTimeEquals(hash, base64Decode(parts[2]));
    if (ok) {
      _failed = 0;
    } else if (++_failed >= maxAttempts) {
      _failed = 0;
      _lockedUntil = now.add(lockout);
    }
    return ok;
  }

  static bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }

  /// PBKDF2-HMAC-SHA256, one 32-byte block.
  static Uint8List pbkdf2(List<int> password, List<int> salt, int iterations) {
    final hmac = Hmac(sha256, password);
    var u = hmac.convert([...salt, 0, 0, 0, 1]).bytes;
    final out = Uint8List.fromList(u);
    for (var i = 1; i < iterations; i++) {
      u = hmac.convert(u).bytes;
      for (var j = 0; j < out.length; j++) {
        out[j] ^= u[j];
      }
    }
    return out;
  }
}

/// Hides the app's content in the task switcher and blocks screenshots (Android).
/// Best effort; a no-op where unsupported.
Future<void> setSecureWindow(bool secure) async {
  try {
    await const MethodChannel('solo_calisthenics/window')
        .invokeMethod<void>('setSecure', secure);
  } on Object {
    // Not available (iOS, tests).
  }
}
