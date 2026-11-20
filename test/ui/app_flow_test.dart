import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:solo_calisthenics/features/profile/application/profile_controller.dart';
import 'package:solo_calisthenics/features/profile/data/profile_repository.dart';
import 'package:solo_calisthenics/features/profile/domain/profile.dart';
import 'package:solo_calisthenics/features/exercises/presentation/exercise_detail_screen.dart';
import 'package:solo_calisthenics/features/onboarding/presentation/onboarding_screen.dart';
import 'package:solo_calisthenics/features/settings/presentation/settings_screen.dart';
import 'package:solo_calisthenics/features/workout/application/active_session_controller.dart';
import 'package:solo_calisthenics/features/workout/data/workout_repository.dart';
import 'package:solo_calisthenics/features/workout/domain/workout_models.dart';
import 'package:solo_calisthenics/features/workout/presentation/active_session_screen.dart';
import 'package:solo_calisthenics/features/workout/presentation/home_shell.dart';

import '../helpers.dart';

/// A small phone, to catch overflows.
void usePhone(WidgetTester tester) {
  tester.view.physicalSize = const Size(360, 720);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<void> settle(WidgetTester tester) =>
    tester.pumpAndSettle(const Duration(milliseconds: 50));

/// Scrolls the target into view first, like a user would, then taps it.
Future<void> tapOn(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) {
    // Lazily built list: scroll until the item exists.
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
  }
  if (finder.hitTestable().evaluate().isEmpty) {
    // Only scroll when needed, so the screen is not moved under the user's feet.
    await tester.ensureVisible(finder);
    await tester.pump();
  }
  await tester.tap(finder);
}

void main() {
  late TestEnv env;
  setUp(() => env = TestEnv());
  tearDown(() => env.db.close());

  testWidgets(
    'onboarding in Arabic: RTL, disclaimer gate, saves profile and injuries',
    (tester) async {
      usePhone(tester);
      await tester.pumpWidget(env.app(profile: null, locale: 'ar'));
      await settle(tester);

      expect(
        Directionality.of(tester.element(find.byType(OnboardingScreen))),
        TextDirection.rtl,
      );
      expect(
        find.text('تنبيه صحي'),
        findsOneWidget,
      ); // medical disclaimer is shown

      final next = find.byKey(const Key('onboarding-next'));
      expect(
        tester.widget<FilledButton>(next).onPressed,
        isNull,
        reason: 'must accept the disclaimer first',
      );
      await tapOn(tester, find.byKey(const Key('accept-disclaimer')));
      await tester.pump();
      await tester.tap(next);
      await settle(tester);

      // Stats: empty form is rejected.
      await tester.tap(next);
      await settle(tester);
      expect(find.text('أدخل قيمة صحيحة'), findsWidgets);
      await tester.enterText(
        find.byKey(const Key('birth-year')),
        '2012',
      ); // a 14-year-old is welcome
      await tester.enterText(find.byKey(const Key('height-cm')), '160');
      await tester.enterText(find.byKey(const Key('weight')), '52.5');
      await tester.tap(next);
      await settle(tester);

      // Experience is required.
      expect(tester.widget<FilledButton>(next).onPressed, isNull);
      await tapOn(tester, find.byKey(const Key('experience-beginner')));
      await tester.pump();
      await tester.tap(next);
      await settle(tester);

      // Baseline test is optional.
      await tester.tap(find.text('تخطٍّ'));
      await settle(tester);

      // Joints.
      await tapOn(tester, find.byKey(const Key('joint-shoulders-moderate')));
      await tester.pump();
      await tester.tap(next);
      await settle(tester);

      expect(find.byType(HomeShell), findsOneWidget);
      final repo = ProfileRepository(env.db);
      final saved = (await repo.loadProfile())!;
      expect(saved.birthYear, 2012);
      expect(saved.heightCm, 160);
      expect(saved.weightKg, 52.5);
      expect(saved.experience, Experience.beginner);
      expect(saved.maxPushUps, isNull);
      expect(await repo.loadInjuries(), [
        const Injury(joint: Joint.shoulders, severity: Severity.moderate),
      ]);
    },
  );

  testWidgets('library greys out excluded exercises and labels the joint', (
    tester,
  ) async {
    usePhone(tester);
    await tester.pumpWidget(
      env.app(
        injuries: const [
          Injury(joint: Joint.wrists, severity: Severity.severe),
        ],
      ),
    );
    await settle(tester);
    await tester.tap(find.text('Library'));
    await settle(tester);

    double opacityOf(String id) => tester
        .widget<Opacity>(
          find
              .ancestor(
                of: find.byKey(Key('exercise-$id')),
                matching: find.byType(Opacity),
              )
              .first,
        )
        .opacity;
    // Push-up loads the wrists at medium -> excluded for severe wrists; wall push-up (low) is fine.
    expect(opacityOf('push_up'), lessThan(1));
    expect(opacityOf('wall_push_up'), 1);
    expect(find.text('Not recommended for your Wrists'), findsWidgets);

    // Detail page explains it and offers the regression.
    await tapOn(tester, find.byKey(const Key('exercise-push_up')));
    await settle(tester);
    expect(find.byType(ExerciseDetailScreen), findsOneWidget);
    expect(
      find.text('Try instead: Incline Push-up'),
      findsNothing,
    ); // incline is wrists:medium too
    expect(find.text('Try instead: Wall Push-up'), findsOneWidget);
    // Every exercise has its own drawing; the placeholder is gone.
    expect(find.byKey(const Key('exercise-illustration')), findsOneWidget);
    expect(find.textContaining('PLACEHOLDER'), findsNothing);
    expect(find.bySemanticsLabel('Drawing of Push-up'), findsOneWidget);
  });

  testWidgets(
    'full workout: template, tap counting, done, RIR, rest, manual entry, finish',
    (tester) async {
      usePhone(tester);
      await tester.pumpWidget(env.app());
      await settle(tester);

      await tapOn(tester, find.byKey(const Key('template-fullBody')));
      await settle(tester);
      await tester.tap(find.byKey(const Key('start-workout')));
      await settle(tester);
      expect(find.byType(ActiveSessionScreen), findsOneWidget);

      // Count 3 reps on the tap zone, remove one, add it back.
      for (var i = 0; i < 3; i++) {
        await tester.tap(find.byKey(const Key('tap-zone')));
        await tester.pump();
      }
      expect(tester.widget<Text>(find.byKey(const Key('counter'))).data, '3');
      await tester.tap(find.byKey(const Key('minus-one')));
      await tester.pump();
      expect(tester.widget<Text>(find.byKey(const Key('counter'))).data, '2');

      // Volume buttons count too (Android): up adds a rep, down removes one.
      await tester.pump(const Duration(milliseconds: 250));
      expect(env.volume.capturing, isTrue);
      env.volume.press('up');
      env.volume.press('up');
      env.volume.press('down');
      await tester.pump();
      await tester.pump();
      expect(tester.widget<Text>(find.byKey(const Key('counter'))).data, '3');
      await tester.tap(find.byKey(const Key('minus-one')));
      await tester.pump();

      await tester.tap(find.byKey(const Key('done-set')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 250));
      expect(
        env.volume.capturing,
        isFalse,
        reason: 'volume keys work normally while resting',
      );

      // Rest view with the one-tap RIR picker.
      expect(find.byKey(const Key('rest-clock')), findsOneWidget);
      await tester.tap(find.byKey(const Key('rir-2')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final container = ProviderScope.containerOf(
        tester.element(find.byType(ActiveSessionScreen)),
      );
      var session = container.read(activeSessionProvider).value!;
      expect(session.exercises.first.sets.single.value, 2);
      expect(session.exercises.first.sets.single.rir, 2);
      expect(env.notifications.restEnd, isNotNull);

      // The rest ends by itself when the clock passes its end.
      env.clock.advance(const Duration(minutes: 10));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byKey(const Key('tap-zone')), findsOneWidget);

      // Manual numeric input.
      await tester.tap(find.byKey(const Key('manual-entry')));
      await settle(tester);
      await tester.enterText(find.byKey(const Key('manual-field')), '11');
      await tester.tap(find.byKey(const Key('manual-save')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      session = container.read(activeSessionProvider).value!;
      expect(session.exercises.first.sets.map((s) => s.value), [2, 11]);

      // Finish early.
      await tester.tap(find.byKey(const Key('finish-workout')));
      await settle(tester);
      await tester.tap(find.text('Finish').last);
      await settle(tester);
      expect(find.byType(ActiveSessionScreen), findsNothing);
      expect((await WorkoutRepository(env.db).history()).single.totalSets, 2);
      expect(find.text('Full body'), findsWidgets); // now listed in history
    },
  );

  testWidgets(
    'relaunch with an unfinished workout goes straight back into it',
    (tester) async {
      usePhone(tester);
      final repo = WorkoutRepository(env.db);
      final id = await repo.createSession('Pull', const [
        PlannedExercise(
          exerciseId: 'pull_up',
          sets: 3,
          targetMin: 4,
          targetMax: 10,
          restSec: 120,
        ),
      ], now: env.clock.now);
      final session = (await repo.load(id))!;
      await repo.addSet(
        sessionId: id,
        sessionExerciseId: session.exercises.first.id,
        value: 6,
        method: LogMethod.manual,
        now: env.clock.now,
        restSec: 0,
      );
      await repo.setPendingCount(id, 4);

      await tester.pumpWidget(env.app());
      await settle(tester);
      expect(find.byType(ActiveSessionScreen), findsOneWidget);
      expect(tester.widget<Text>(find.byKey(const Key('counter'))).data, '4');
      expect(find.text('Set 2 of 3  ·  4–10 reps'), findsOneWidget);
    },
  );

  testWidgets('every main screen lays out in Arabic (RTL) without overflow', (
    tester,
  ) async {
    usePhone(tester);
    const injuries = [
      Injury(joint: Joint.wrists, severity: Severity.mild),
      Injury(joint: Joint.knees, severity: Severity.moderate),
    ];
    await tester.pumpWidget(env.app(locale: 'ar', injuries: injuries));
    await settle(tester);
    expect(
      Directionality.of(tester.element(find.byType(HomeShell))),
      TextDirection.rtl,
    );

    // Train -> preview -> active session (log view, rest view).
    await tapOn(tester, find.byKey(const Key('template-push')));
    await settle(tester);
    expect(
      find.text('أحمِ هذه المفاصل أولاً'),
      findsOneWidget,
    ); // targeted warm-up for flagged joints
    await tester.tap(find.byKey(const Key('start-workout')));
    await settle(tester);
    expect(
      Directionality.of(tester.element(find.byType(ActiveSessionScreen))),
      TextDirection.rtl,
    );
    await tester.tap(find.byKey(const Key('tap-zone')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('done-set')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('تخطي الراحة'), findsOneWidget);
    await tester.tap(find.byKey(const Key('skip-rest')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byType(BackButton).last);
    await settle(tester);

    // Library (all patterns), detail, settings, profile editor.
    await tester.tap(find.text('المكتبة'));
    await settle(tester);
    for (final p in ['pull', 'legs', 'core', 'statics']) {
      await tester.ensureVisible(find.byKey(Key('pattern-$p')));
      await tester.tap(find.byKey(Key('pattern-$p')));
      await settle(tester);
    }
    await tapOn(tester, find.byKey(const Key('exercise-crow_pose')));
    await settle(tester);
    expect(find.text('وضعية الغراب'), findsWidgets);
    await tester.tap(find.byType(BackButton).last);
    await settle(tester);

    await tester.tap(find.text('الإعدادات'));
    await settle(tester);
    expect(find.byType(SettingsScreen), findsOneWidget);
    await tapOn(tester, find.byKey(const Key('edit-profile')));
    await settle(tester);
    expect(find.byType(OnboardingScreen), findsOneWidget);
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(const Key('onboarding-next')));
      await settle(tester);
    }
    expect(find.text('المفاصل والإصابات'), findsOneWidget);
  });

  testWidgets('profile edits take effect immediately in the library', (
    tester,
  ) async {
    usePhone(tester);
    await tester.pumpWidget(env.app());
    await settle(tester);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(HomeShell)),
    );
    await container.read(profileProvider.notifier).save(testProfile, const [
      Injury(joint: Joint.shoulders, severity: Severity.severe),
    ]);
    await tester.tap(find.text('Library'));
    await settle(tester);
    expect(find.text('Not recommended for your Shoulders'), findsWidgets);
  });
}
