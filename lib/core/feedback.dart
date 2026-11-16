import 'package:flutter/services.dart';

/// Haptic and sound confirmation for logging actions. Respects the user's settings.
class Feedback {
  const Feedback({required this.haptics, required this.sound});
  final bool haptics;
  final bool sound;

  /// One rep counted.
  void count() {
    if (haptics) HapticFeedback.lightImpact();
    if (sound) SystemSound.play(SystemSoundType.click);
  }

  /// A set was saved.
  void setSaved() {
    if (haptics) HapticFeedback.mediumImpact();
  }

  /// Rest is over. The audible alert comes from the rest notification.
  void restOver() {
    if (haptics) HapticFeedback.heavyImpact();
  }
}
