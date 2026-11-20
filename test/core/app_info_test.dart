import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:solo_calisthenics/core/app_info.dart';

void main() {
  test('the version shown in the app matches pubspec.yaml', () {
    final line = File('pubspec.yaml')
        .readAsLinesSync()
        .firstWhere((l) => l.startsWith('version:'));
    expect(line.split(':').last.trim().split('+').first, AppInfo.version);
  });

  test('logo files exist and are declared as assets', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(pubspec, contains('- assets/branding/'));
    for (final f in [AppInfo.logoFull, AppInfo.logoMark]) {
      expect(File(f).existsSync(), isTrue, reason: f);
    }
  });
}
