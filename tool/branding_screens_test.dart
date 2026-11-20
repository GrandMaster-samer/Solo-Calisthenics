// Screenshots of the screens that show the logo. Not part of the test suite. Run:
//   flutter test tool/branding_screens_test.dart --update-goldens
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:solo_calisthenics/core/app_info.dart';

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
    await loadFont('Inter', ['assets/fonts/Inter.ttf']);
    await loadFont('IBMPlexSansArabic', [
      for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold']) 'assets/fonts/IBMPlexSansArabic-$w.ttf',
    ]);
    await loadFont('MaterialIcons', ['${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf']);
  });

  Future<void> images(WidgetTester tester) async {
    await tester.runAsync(() async {
      for (final e in find.byType(Image).evaluate()) {
        await precacheImage((e.widget as Image).image, e);
      }
    });
    await tester.pumpAndSettle();
  }

  for (final lang in ['en', 'ar']) {
    testWidgets('branding $lang', (tester) async {
      tester.view.physicalSize = const Size(1080, 2220);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final env = TestEnv();
      addTearDown(env.db.close);
      await tester.pumpWidget(env.app(profile: null, locale: lang));
      await tester.pumpAndSettle();
      await images(tester);
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('screenshots/${lang}_brand_welcome.png'));

      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(env.app(locale: lang));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();
      final list = find.byWidgetPredicate((w) => w is Scrollable && w.axisDirection == AxisDirection.down).last;
      for (var i = 0; i < 40 && find.byKey(const Key('about-app')).evaluate().isEmpty; i++) {
        await tester.drag(list, const Offset(0, -300));
        await tester.pump();
      }
      await Scrollable.ensureVisible(tester.element(find.byKey(const Key('about-app'))), alignment: 0.4);
      await tester.pumpAndSettle();
      await images(tester);
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('screenshots/${lang}_brand_about.png'));
      expect(find.textContaining(AppInfo.developer), findsOneWidget);
    });
  }
}
