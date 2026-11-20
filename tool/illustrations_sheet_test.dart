// Renders every exercise drawing with the app's own painter into one sheet, for review.
// Not part of the test suite. Run:
//   flutter test tool/illustrations_sheet_test.dart --update-goldens
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:solo_calisthenics/core/theme/app_colors.dart';
import 'package:solo_calisthenics/features/exercises/presentation/exercise_illustration.dart';

import '../test/helpers.dart';

Future<void> loadFont(String family, List<String> paths) async {
  final loader = FontLoader(family);
  for (final p in paths) {
    loader.addFont(Future.value(ByteData.sublistView(File(p).readAsBytesSync())));
  }
  await loader.load();
}

void main() {
  setUpAll(() => loadFont('Inter', ['assets/fonts/Inter.ttf']));

  testWidgets('all illustrations', (tester) async {
    const cols = 8, cellW = 230.0, cellH = 200.0;
    final env = TestEnv();
    addTearDown(env.db.close);
    final ex = env.library.exercises;
    final rows = (ex.length / cols).ceil();
    tester.view.physicalSize = Size(cols * cellW, rows * cellH);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: env.overrides(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Inter', scaffoldBackgroundColor: AppColors.background),
          home: Scaffold(
            body: Wrap(
              children: [
                for (var i = 0; i < ex.length; i++)
                  SizedBox(
                    width: cellW,
                    height: cellH,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${i + 1}. ${ex[i].name.of('en')}',
                              style: const TextStyle(color: AppColors.primary, fontSize: 12)),
                          const SizedBox(height: 4),
                          Expanded(
                            child: Container(
                              color: AppColors.surfaceElevated,
                              padding: const EdgeInsets.all(6),
                              child: ExerciseIllustration(exerciseId: ex[i].id, animate: false),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('screenshots/illustrations_sheet.png'));
  });
}
