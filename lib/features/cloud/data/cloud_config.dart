/// Cloud settings come from build-time defines, so the default build has no backend
/// at all:
///
///   flutter run --dart-define=SUPABASE_URL=https://xyz.supabase.co \
///               --dart-define=SUPABASE_KEY=your-publishable-key
///
/// See supabase/README.md.
class CloudConfig {
  const CloudConfig({required this.url, required this.publishableKey});
  final String url;
  final String publishableKey;

  /// Deep link the browser returns to after Google sign-in. Must be listed under
  /// "Redirect URLs" in the Supabase project and matches AndroidManifest / Info.plist.
  static const redirectUrl = 'com.grandmastersamer.solocalisthenics://login-callback';

  static const _url = String.fromEnvironment('SUPABASE_URL');
  static const _key = String.fromEnvironment('SUPABASE_KEY');

  /// Null when the build was not given a backend.
  static CloudConfig? fromEnvironment() =>
      _url.isEmpty || _key.isEmpty ? null : const CloudConfig(url: _url, publishableKey: _key);
}
