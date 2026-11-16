import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/profile/application/profile_controller.dart';
import 'features/settings/application/settings_controller.dart';
import 'features/workout/presentation/home_shell.dart';
import 'l10n/app_l10n.dart';

const supportedAppLocales = [Locale('en'), Locale('ar')];

/// The user's explicit choice, or the system language when it is supported, else English.
Locale resolveLocale(String? chosenCode, Locale systemLocale) {
  final code = chosenCode ?? systemLocale.languageCode;
  return supportedAppLocales.firstWhere(
    (l) => l.languageCode == code,
    orElse: () => supportedAppLocales.first,
  );
}

class SoloApp extends ConsumerWidget {
  const SoloApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeCode = ref.watch(settingsProvider.select((s) => s.localeCode));
    final onboarded = ref.watch(profileProvider.select((p) => p.isOnboarded));
    final locale = resolveLocale(
      localeCode,
      PlatformDispatcher.instance.locale,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppL10n.of(context).appName,
      locale: locale,
      supportedLocales: supportedAppLocales,
      localizationsDelegates: [
        AppL10n.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      theme: buildAppTheme(locale),
      home: onboarded ? const HomeShell() : const OnboardingScreen(),
    );
  }
}
