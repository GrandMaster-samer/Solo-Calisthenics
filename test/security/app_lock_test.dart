import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:solo_calisthenics/features/security/data/app_lock.dart';

import '../helpers.dart';

String hex(List<int> b) =>
    b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();

void main() {
  test('PBKDF2-HMAC-SHA256 matches the published test vectors', () {
    expect(
      hex(AppLock.pbkdf2(utf8.encode('password'), utf8.encode('salt'), 1)),
      '120fb6cffcf8b32c43e7225256c4f837a86548c92ccc35480805987cb70be17b',
    );
    expect(
      hex(AppLock.pbkdf2(utf8.encode('password'), utf8.encode('salt'), 2)),
      'ae4d0c95af6b46d32d0adff928f06dd02a303f8ef3c251dfd6e2d85a95474c43',
    );
  });

  test('PIN format', () {
    expect(AppLock.isValidPin('1234'), isTrue);
    expect(AppLock.isValidPin('12345678'), isTrue);
    expect(AppLock.isValidPin('123'), isFalse);
    expect(AppLock.isValidPin('123456789'), isFalse);
    expect(AppLock.isValidPin('12a4'), isFalse);
  });

  test(
    'set, verify, change and remove; the PIN itself is never stored',
    () async {
      final store = MemorySecretStore();
      final lock = AppLock(store, FakeBiometrics());
      final now = DateTime(2026);
      expect(await lock.hasPin(), isFalse);
      expect(await lock.verify('1234', now: now), isFalse);

      await lock.setPin('4821');
      expect(await lock.hasPin(), isTrue);
      expect(store.values.values.single.contains('4821'), isFalse);
      expect(await lock.verify('4821', now: now), isTrue);
      expect(await lock.verify('4822', now: now), isFalse);

      // Same PIN, new salt: stored value differs.
      final before = store.values.values.single;
      await lock.setPin('4821');
      expect(store.values.values.single, isNot(before));

      await lock.setPin('999999');
      expect(await lock.verify('4821', now: now), isFalse);
      expect(await lock.verify('999999', now: now), isTrue);

      await lock.clearPin();
      expect(await lock.hasPin(), isFalse);
      await expectLater(lock.setPin('12'), throwsArgumentError);
    },
  );

  test('five wrong attempts pause further tries for 30 seconds, even with the right PIN', () async {
    final lock = AppLock(MemorySecretStore(), FakeBiometrics());
    var now = DateTime(2026);
    await lock.setPin('4821');
    for (var i = 0; i < AppLock.maxAttempts; i++) {
      expect(await lock.verify('0000', now: now), isFalse);
    }
    expect(lock.lockoutRemaining(now), AppLock.lockout);
    expect(await lock.verify('4821', now: now), isFalse);
    now = now.add(const Duration(seconds: 31));
    expect(lock.lockoutRemaining(now), Duration.zero);
    expect(await lock.verify('4821', now: now), isTrue);
  });
}
