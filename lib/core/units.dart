/// All measurements are stored in metric; these helpers convert for display and input.
enum WeightUnit { kg, lb }

enum HeightUnit { cm, ftIn }

abstract final class Units {
  static const _lbPerKg = 2.2046226218;
  static const _cmPerInch = 2.54;

  static double kgToLb(double kg) => kg * _lbPerKg;
  static double lbToKg(double lb) => lb / _lbPerKg;

  static double feetInchesToCm(int feet, double inches) =>
      (feet * 12 + inches) * _cmPerInch;

  /// Returns whole feet and rounded inches, carrying 12in over to the next foot.
  static ({int feet, int inches}) cmToFeetInches(double cm) {
    final totalInches = (cm / _cmPerInch).round();
    return (feet: totalInches ~/ 12, inches: totalInches % 12);
  }

  static String formatWeight(double kg, WeightUnit unit) {
    final v = unit == WeightUnit.kg ? kg : kgToLb(kg);
    final s = v.toStringAsFixed(1);
    return '${s.endsWith('.0') ? s.substring(0, s.length - 2) : s} ${unit.name}';
  }

  static String formatHeight(double cm, HeightUnit unit) {
    if (unit == HeightUnit.cm) return '${cm.round()} cm';
    final fi = cmToFeetInches(cm);
    return "${fi.feet}'${fi.inches}\"";
  }

  /// mm:ss for timers.
  static String formatClock(int totalSeconds) {
    final s = totalSeconds < 0 ? 0 : totalSeconds;
    return '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';
  }
}

/// Replaces Arabic-Indic digits with Western ones. The app shows 0-9 in both
/// languages, including in dates formatted by the system for Arabic.
String westernDigits(String s) {
  const arabic = '٠١٢٣٤٥٦٧٨٩';
  final out = StringBuffer();
  for (final ch in s.split('')) {
    final i = arabic.indexOf(ch);
    out.write(i < 0 ? ch : '$i');
  }
  return out.toString();
}
