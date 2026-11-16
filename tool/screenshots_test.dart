// Renders real screens to PNG files with the bundled fonts, for visual review.
// Not part of the test suite. Run:
//   flutter test tool/screenshots_test.dart --update-goldens
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:solo_calisthenics/features/profile/domain/profile.dart';
import 'package:solo_calisthenics/features/workout/application/active_session_controller.dart';
import 'package:solo_calisthenics/features/workout/presentation/active_session_screen.dart';

import '../test/helpers.dart';

Future<void> loadFont(String family, List<String> paths) async {
  final loader = FontLoader(family);
  for (final p in paths) {
    loader.addFont(Future.value(ByteData.sublistView(File(p).readAsBytesSync())));
  }
  await loader.load();
}

void main() {
  setUpAll(() async {
    final flutterRoot = Platform.environment['FLUTTER_ROOT']!;
    await loadFont('Inter', ['assets/fonts/Inter.ttf']);
    await loadFont('IBMPlexSansArabic', [
      for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold']) 'assets/fonts/IBMPlexSansArabic-$w.ttf',
    ]);
    await loadFont('MaterialIcons', ['$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf']);
  });

  Future<void> shot(WidgetTester tester, String name) async {
    await tester.pump(const Duration(milliseconds: 400));
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('screenshots/$name.png'));
  }

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2220);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  const injuries = [
    Injury(joint: Joint.wrists, severity: Severity.severe),
    Injury(joint: Joint.shoulders, severity: Severity.mild),
  ];

  for (final lang in ['en', 'ar']) {
    testWidgets('screens $lang', (tester) async {
      phone(tester);
      final env = TestEnv();
      addTearDown(env.db.close);
      await tester.pumpWidget(env.app(locale: lang, injuries: injuries));
      await tester.pumpAndSettle();
      await shot(tester, '${lang}_1_train');

      await tester.tap(find.byIcon(Icons.menu_book_outlined));
      await tester.pumpAndSettle();
      await shot(tester, '${lang}_2_library');
      await tester.tap(find.byKey(const Key('exercise-wall_push_up')));
      await tester.pumpAndSettle();
      await shot(tester, '${lang}_3_exercise');
      await tester.tap(find.byType(BackButton).last);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.fitness_center));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('template-pull')));
      await tester.pumpAndSettle();
      await shot(tester, '${lang}_4_preview');
      await tester.tap(find.byKey(const Key('start-workout')));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.chevron_right)); // a rep-based exercise
      await tester.pump(const Duration(milliseconds: 300));
      for (var i = 0; i < 7; i++) {
        await tester.tap(find.byKey(const Key('tap-zone')));
        await tester.pump();
      }
      await shot(tester, '${lang}_5_logging');
      await tester.tap(find.byKey(const Key('done-set')));
      await tester.pump(const Duration(milliseconds: 300));
      env.clock.advance(const Duration(seconds: 23));
      final c = ProviderScope.containerOf(tester.element(find.byType(ActiveSessionScreen)));
      final set = c.read(activeSessionProvider).value!.exercises.expand((e) => e.sets).single;
      await c.read(activeSessionProvider.notifier).setEffort(set.id, rir: 2);
      await shot(tester, '${lang}_6_rest');
    });

    testWidgets('onboarding $lang', (tester) async {
      phone(tester);
      final env = TestEnv();
      addTearDown(env.db.close);
      await tester.pumpWidget(env.app(profile: null, locale: lang));
      await tester.pumpAndSettle();
      await shot(tester, '${lang}_0_welcome');
    });
  }
}
