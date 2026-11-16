import 'dart:ui';

/// Brand palette. Dark-first; every screen pulls colors from here or the ColorScheme.
abstract final class AppColors {
  static const background = Color(0xFF0E0F12);
  static const surface = Color(0xFF171A1F);
  static const surfaceElevated = Color(0xFF20242B);
  static const primary = Color(0xFFC6FF3D); // electric lime
  static const secondary = Color(0xFF00D1FF); // cyan
  static const success = Color(0xFF3DDC97);
  static const warning = Color(0xFFFF8A3D);
  static const error = Color(0xFFFF4D5E);
  static const textPrimary = Color(0xFFF2F4F7);
  static const textSecondary = Color(0xFF9AA3AF);
}
