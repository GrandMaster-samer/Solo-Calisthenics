import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

const _latin = 'Inter';
const _arabic = 'IBMPlexSansArabic';

/// Text style for timers and rep counters: tabular figures so digits never shift.
TextStyle numericStyle(
  double size, {
  Color color = AppColors.textPrimary,
  FontWeight weight = FontWeight.w700,
}) {
  return TextStyle(
    fontFamily: _latin,
    fontSize: size,
    height: 1.0,
    fontWeight: weight,
    color: color,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}

ThemeData buildAppTheme(Locale locale) {
  final isArabic = locale.languageCode == 'ar';
  const scheme = ColorScheme.dark(
    surface: AppColors.surface,
    surfaceContainerLowest: AppColors.background,
    surfaceContainerLow: AppColors.surface,
    surfaceContainer: AppColors.surface,
    surfaceContainerHigh: AppColors.surfaceElevated,
    surfaceContainerHighest: AppColors.surfaceElevated,
    primary: AppColors.primary,
    onPrimary: AppColors.background,
    secondary: AppColors.secondary,
    onSecondary: AppColors.background,
    error: AppColors.error,
    onError: AppColors.background,
    onSurface: AppColors.textPrimary,
    onSurfaceVariant: AppColors.textSecondary,
    outline: Color(0xFF3A404A),
    outlineVariant: Color(0xFF2A2F37),
  );
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: isArabic ? _arabic : _latin,
    fontFamilyFallback: isArabic ? const [_latin] : const [_arabic],
  );
  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));
  return base.copyWith(
    materialTapTargetSize: MaterialTapTargetSize.padded, // keeps 48dp targets
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 52),
        shape: shape,
        textStyle: base.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 52),
        shape: shape,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: AppColors.surfaceElevated,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: AppColors.surfaceElevated,
      selectedColor: AppColors.primary,
      checkmarkColor: AppColors.background,
      side: BorderSide.none,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.primary,
      surfaceTintColor: Colors.transparent,
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFF2A2F37), space: 1),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
