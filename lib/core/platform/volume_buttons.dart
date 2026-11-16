import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Hardware volume buttons as rep counters. Android only: iOS offers no supported
/// API, so [isSupported] is false there and the UI falls back to the tap zone.
class VolumeButtons {
  const VolumeButtons();
  static const _method = MethodChannel('solo_calisthenics/volume_buttons');
  static const _events = EventChannel(
    'solo_calisthenics/volume_buttons/events',
  );

  bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// While enabled, volume presses do not change the volume.
  Future<void> setCapture(bool enabled) async {
    if (!isSupported) return;
    try {
      await _method.invokeMethod<void>('setCapture', enabled);
    } on MissingPluginException {
      // Not running inside the Android host activity (e.g. tests).
    }
  }

  /// Emits one event per press ("up" or "down").
  Stream<String> get presses => isSupported
      ? _events.receiveBroadcastStream().map((e) => e as String)
      : const Stream.empty();
}
