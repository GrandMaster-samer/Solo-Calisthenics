import '../../../core/db/app_database.dart';
import '../../../core/units.dart';

enum EffortMode { rir, rpe }

class AppSettings {
  const AppSettings({
    this.localeCode,
    this.weightUnit = WeightUnit.kg,
    this.heightUnit = HeightUnit.cm,
    this.effortMode = EffortMode.rir,
    this.sound = true,
    this.haptics = true,
    this.volumeButtons = true,
    this.reminderDays = const {},
    this.reminderMinutes = 18 * 60,
    this.lockWholeApp = false,
    this.biometricUnlock = false,
  });

  /// null = follow the system language.
  final String? localeCode;
  final WeightUnit weightUnit;
  final HeightUnit heightUnit;
  final EffortMode effortMode;
  final bool sound;
  final bool haptics;

  /// Count reps with the hardware volume buttons (Android only).
  final bool volumeButtons;

  /// ISO weekdays (1 = Monday .. 7 = Sunday) that get a workout reminder.
  final Set<int> reminderDays;

  /// Reminder time as minutes after midnight.
  final int reminderMinutes;

  /// With a PIN set the photo vault is always locked; this also locks the whole app.
  final bool lockWholeApp;

  /// Offer fingerprint / face unlock before the PIN.
  final bool biometricUnlock;

  AppSettings copyWith({
    String? Function()? localeCode,
    WeightUnit? weightUnit,
    HeightUnit? heightUnit,
    EffortMode? effortMode,
    bool? sound,
    bool? haptics,
    bool? volumeButtons,
    Set<int>? reminderDays,
    int? reminderMinutes,
    bool? lockWholeApp,
    bool? biometricUnlock,
  }) => AppSettings(
    localeCode: localeCode != null ? localeCode() : this.localeCode,
    weightUnit: weightUnit ?? this.weightUnit,
    heightUnit: heightUnit ?? this.heightUnit,
    effortMode: effortMode ?? this.effortMode,
    sound: sound ?? this.sound,
    haptics: haptics ?? this.haptics,
    volumeButtons: volumeButtons ?? this.volumeButtons,
    reminderDays: reminderDays ?? this.reminderDays,
    reminderMinutes: reminderMinutes ?? this.reminderMinutes,
    lockWholeApp: lockWholeApp ?? this.lockWholeApp,
    biometricUnlock: biometricUnlock ?? this.biometricUnlock,
  );

  Map<String, String> toMap() => {
    'locale': localeCode ?? '',
    'weightUnit': weightUnit.name,
    'heightUnit': heightUnit.name,
    'effortMode': effortMode.name,
    'sound': '$sound',
    'haptics': '$haptics',
    'volumeButtons': '$volumeButtons',
    'reminderDays': (reminderDays.toList()..sort()).join(','),
    'reminderMinutes': '$reminderMinutes',
    'lockWholeApp': '$lockWholeApp',
    'biometricUnlock': '$biometricUnlock',
  };

  /// Tolerant of missing or unknown values so old installs keep working.
  factory AppSettings.fromMap(Map<String, String> m) {
    const d = AppSettings();
    T pick<T extends Enum>(List<T> values, String? name, T fallback) =>
        values.where((v) => v.name == name).firstOrNull ?? fallback;
    bool flag(String key, bool fallback) =>
        m[key] == null ? fallback : m[key] == 'true';
    final locale = m['locale'];
    return AppSettings(
      localeCode: (locale == null || locale.isEmpty) ? null : locale,
      weightUnit: pick(WeightUnit.values, m['weightUnit'], d.weightUnit),
      heightUnit: pick(HeightUnit.values, m['heightUnit'], d.heightUnit),
      effortMode: pick(EffortMode.values, m['effortMode'], d.effortMode),
      sound: flag('sound', d.sound),
      haptics: flag('haptics', d.haptics),
      volumeButtons: flag('volumeButtons', d.volumeButtons),
      reminderDays: (m['reminderDays'] ?? '')
          .split(',')
          .map(int.tryParse)
          .whereType<int>()
          .where((d) => d >= 1 && d <= 7)
          .toSet(),
      reminderMinutes:
          int.tryParse(m['reminderMinutes'] ?? '') ?? d.reminderMinutes,
      lockWholeApp: flag('lockWholeApp', d.lockWholeApp),
      biometricUnlock: flag('biometricUnlock', d.biometricUnlock),
    );
  }
}

class SettingsRepository {
  SettingsRepository(this._db);
  final AppDatabase _db;

  Future<AppSettings> load() async {
    final rows = await _db.select(_db.settings).get();
    return AppSettings.fromMap({for (final r in rows) r.key: r.value});
  }

  Future<void> save(AppSettings settings) {
    return _db.batch((b) {
      b.insertAllOnConflictUpdate(_db.settings, [
        for (final e in settings.toMap().entries)
          SettingsCompanion.insert(key: e.key, value: e.value),
      ]);
    });
  }
}
