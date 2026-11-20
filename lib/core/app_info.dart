/// Facts about the app shown in Settings > About and on the licenses page.
abstract final class AppInfo {
  /// Keep in sync with `version:` in pubspec.yaml (a test checks this).
  static const version = '1.0.0';

  /// The developer, shown as "Made by …". A name, so it is not translated.
  static const developer = 'GrandMaster-samer';

  static const copyrightYear = 2026;

  static const logoFull = 'assets/branding/logo_full.png';
  static const logoMark = 'assets/branding/logo_mark.png';
}
