import 'package:flutter_test/flutter_test.dart';
import 'package:solo_calisthenics/core/units.dart';
import 'package:solo_calisthenics/features/settings/data/settings_repository.dart';

void main() {
  test('weight converts both ways', () {
    expect(Units.kgToLb(100), closeTo(220.46, 0.01));
    expect(Units.lbToKg(Units.kgToLb(73.5)), closeTo(73.5, 1e-9));
  });

  test('height converts and carries inches into feet', () {
    expect(Units.feetInchesToCm(5, 10), closeTo(177.8, 0.01));
    expect(Units.cmToFeetInches(177.8), (feet: 5, inches: 10));
    expect(Units.cmToFeetInches(182.5), (
      feet: 6,
      inches: 0,
    )); // 71.85in rounds to 72in, not 5'12"
  });

  test('formatting', () {
    expect(Units.formatWeight(74, WeightUnit.kg), '74 kg');
    expect(Units.formatWeight(74, WeightUnit.lb), '163.1 lb');
    expect(Units.formatHeight(178, HeightUnit.ftIn), '5\'10"');
    expect(Units.formatClock(95), '01:35');
    expect(Units.formatClock(-3), '00:00');
  });

  test('settings survive a round trip and tolerate bad stored values', () {
    const s = AppSettings(
      localeCode: 'ar',
      weightUnit: WeightUnit.lb,
      effortMode: EffortMode.rpe,
      sound: false,
      reminderDays: {1, 3, 5},
      reminderMinutes: 390,
    );
    final back = AppSettings.fromMap(s.toMap());
    expect(back.localeCode, 'ar');
    expect(back.weightUnit, WeightUnit.lb);
    expect(back.effortMode, EffortMode.rpe);
    expect(back.sound, isFalse);
    expect(back.reminderDays, {1, 3, 5});
    expect(back.reminderMinutes, 390);

    final broken = AppSettings.fromMap({
      'weightUnit': 'stone',
      'reminderDays': '9,x,2',
      'locale': '',
    });
    expect(broken.weightUnit, WeightUnit.kg);
    expect(broken.reminderDays, {2});
    expect(broken.localeCode, isNull);
  });
}
