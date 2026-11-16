import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:solo_calisthenics/features/planner/data/progress_repository.dart';
import 'package:solo_calisthenics/features/planner/domain/progression_engine.dart';
import 'package:solo_calisthenics/features/profile/domain/profile.dart';
import 'package:solo_calisthenics/features/progress/data/analytics_repository.dart';
import 'package:solo_calisthenics/features/progress/presentation/vault_screen.dart';
import 'package:solo_calisthenics/features/security/presentation/lock_gate.dart';
import 'package:solo_calisthenics/features/settings/data/settings_repository.dart';
import 'package:solo_calisthenics/features/workout/data/workout_repository.dart';
import 'package:solo_calisthenics/features/workout/domain/workout_models.dart';
import 'package:solo_calisthenics/features/workout/presentation/active_session_screen.dart';
import 'package:solo_calisthenics/features/workout/presentation/home_shell.dart';

import '../helpers.dart';

void usePhone(WidgetTester tester) {
  tester.view.physicalSize = const Size(360, 720);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Lets animations finish and database-backed futures complete (they resolve
/// between frames, so one pumpAndSettle is not always enough).
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 4; i++) {
    await tester.pumpAndSettle(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
  }
}

/// The vertical scrollable of the screen on top (skips horizontal chip rows).
Finder mainList() => find
    .byWidgetPredicate((w) => w is Scrollable && w.axisDirection == AxisDirection.down)
    .last;

/// Scrolls the main list down in small steps until [finder] has been built.
Future<void> scrollTo(WidgetTester tester, Finder finder) async {
  // Down first, then back up: the item may be above the current position.
  for (final step in const [-150.0, 150.0]) {
    for (var i = 0; i < 60 && finder.evaluate().isEmpty; i++) {
      await tester.drag(mainList(), Offset(0, step));
      await tester.pump();
    }
  }
  expect(finder, findsWidgets);
  // Centre it, clear of the app bar and the bottom navigation.
  await Scrollable.ensureVisible(tester.element(finder.first), alignment: 0.5);
  await tester.pump();
}

Future<void> tapOn(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) {
    // Lazily built list: scroll the main vertical list until the item exists.
    await scrollTo(tester, finder);
  }
  if (finder.hitTestable().evaluate().isEmpty) {
    // Only scroll when needed, so the screen is not moved under the user's feet.
    await Scrollable.ensureVisible(tester.element(finder.first), alignment: 0.5);
    await tester.pump();
  }
  await tester.tap(finder);
  await settle(tester);
}

Future<void> typePin(WidgetTester tester, String pin) async {
  for (final d in pin.split('')) {
    await tester.tap(find.byKey(Key('pin-$d')));
    await tester.pump();
  }
  await tester.tap(find.byKey(const Key('pin-ok')));
  // PBKDF2 runs for real here; give the futures a few frames.
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  await settle(tester);
}

void main() {
  late TestEnv env;
  setUp(() => env = TestEnv());
  tearDown(() => env.db.close());

  testWidgets('create a weekly plan, train a planned day, see it ticked off', (tester) async {
    usePhone(tester);
    await tester.pumpWidget(env.app());
    await settle(tester);

    await tapOn(tester, find.byKey(const Key('create-plan')));
    await tapOn(tester, find.byKey(const Key('plan-days-4')));
    await tapOn(tester, find.byKey(const Key('plan-minutes-30')));
    await tapOn(tester, find.byKey(const Key('plan-skill-planche')));
    await tapOn(tester, find.byKey(const Key('plan-deload-4')));
    await tapOn(tester, find.byKey(const Key('save-plan')));

    final saved = (await ProgressRepository(env.db).planConfig())!;
    expect(saved.daysPerWeek, 4);
    expect(saved.sessionMinutes, 30);
    expect(saved.focusSkills.contains('planche'), isTrue);
    expect(saved.deloadEveryWeeks, 4);

    // ignore: avoid_print
    expect(find.text('This week'), findsOneWidget);
    expect(find.text("Today's workout"), findsOneWidget); // the test clock is a Monday
    expect(find.byKey(const Key('template-push')), findsNothing, reason: 'the plan replaces starter workouts');

    await tapOn(tester, find.byKey(const Key('start-planned')));
    await tapOn(tester, find.byKey(const Key('start-workout')));
    expect(find.byType(ActiveSessionScreen), findsOneWidget);
    await tester.tap(find.byKey(const Key('manual-entry')));
    await settle(tester);
    await tester.enterText(find.byKey(const Key('manual-field')), '9');
    await tester.tap(find.byKey(const Key('manual-save')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byKey(const Key('finish-workout')));
    await settle(tester);
    await tester.tap(find.text('Finish').last);
    await settle(tester);
    if (find.byKey(const Key('progress-ok')).evaluate().isNotEmpty) {
      await tester.tap(find.byKey(const Key('progress-ok')));
      await settle(tester);
    }
    expect(find.byType(ActiveSessionScreen), findsNothing);

    final done = await WorkoutRepository(env.db).completedPlanDays('2026-01-05');
    expect(done, {0});
    expect(find.text('Next workout'), findsOneWidget);
    await scrollTo(tester, find.byKey(const Key('plan-day-0')));
    expect(
      find.descendant(of: find.byKey(const Key('plan-day-0')), matching: find.byIcon(Icons.check_circle)),
      findsOneWidget,
    );
  });

  testWidgets('deload week is announced on the plan and in the workout preview', (tester) async {
    usePhone(tester);
    final repo = ProgressRepository(env.db);
    await tester.pumpWidget(env.app());
    await settle(tester);
    await tapOn(tester, find.byKey(const Key('create-plan')));
    await tapOn(tester, find.byKey(const Key('save-plan')));
    expect(find.byKey(const Key('deload-badge')), findsNothing);

    // Five weeks later the scheduled lighter week begins.
    env.clock.advance(const Duration(days: 35));
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(env.app());
    await settle(tester);
    expect(find.byKey(const Key('deload-badge')), findsOneWidget);
    expect((await repo.planConfig())!.lastDeloadStart, isNotNull);
    await tapOn(tester, find.byKey(const Key('start-planned')));
    expect(find.textContaining('Lighter week: fewer sets'), findsOneWidget);
  });

  testWidgets('skill tree shows done, current and locked steps and unlock dates (Arabic)', (tester) async {
    usePhone(tester);
    final repo = ProgressRepository(env.db);
    await repo.saveChainState(
      const ChainState(chainId: 'planche', exerciseId: 'advanced_tuck_planche', holdTarget: 10),
      now: env.clock.now,
    );
    await repo.addMilestone('planche', 'advanced_tuck_planche', now: env.clock.now);
    await tester.pumpWidget(env.app(locale: 'ar'));
    await settle(tester);
    await tester.tap(find.text('المهارات'));
    await settle(tester);

    await scrollTo(tester, find.byKey(const Key('skill-node-full_planche')));
    IconData iconOf(String id) => tester
        .widget<Icon>(find.descendant(of: find.byKey(Key('skill-node-$id')), matching: find.byType(Icon)).first)
        .icon!;
    expect(iconOf('planche_lean'), Icons.check);
    expect(iconOf('tuck_planche'), Icons.check);
    expect(iconOf('advanced_tuck_planche'), Icons.play_arrow);
    expect(iconOf('straddle_planche'), Icons.lock_outline);
    expect(find.textContaining('الهدف 10 ث'), findsOneWidget); // current hold goal
    expect(find.textContaining('فُتح في'), findsOneWidget); // unlock date
    expect(find.text('المستوى 3 من 5'), findsOneWidget);

    for (final p in ['push', 'pull', 'legs', 'core']) {
      await tester.ensureVisible(find.byKey(Key('skill-pattern-$p')));
      await tester.tap(find.byKey(Key('skill-pattern-$p')));
      await settle(tester);
    }
  });

  testWidgets('progress dashboard: stats, charts, trends and milestones (Arabic, no overflow)', (tester) async {
    usePhone(tester);
    final workouts = WorkoutRepository(env.db);
    for (final (day, reps) in [(DateTime(2025, 12, 23), 8), (DateTime(2025, 12, 30), 10), (DateTime(2026, 1, 5), 12)]) {
      final id = await workouts.createSession(
        'S',
        const [PlannedExercise(exerciseId: 'push_up', sets: 2, targetMin: 8, targetMax: 12, restSec: 90)],
        now: day,
      );
      final s = (await workouts.load(id))!;
      for (var i = 0; i < 2; i++) {
        await workouts.addSet(
          sessionId: id,
          sessionExerciseId: s.exercises.single.id,
          value: reps,
          method: LogMethod.manual,
          now: day,
          restSec: 0,
        );
      }
      await workouts.finish(id, now: day.add(const Duration(minutes: 30)));
    }
    await ProgressRepository(env.db).addMilestone('push_up', 'diamond_push_up', now: env.clock.now);

    await tester.pumpWidget(env.app(locale: 'ar'));
    await settle(tester);
    await tester.tap(find.text('التقدّم'));
    await settle(tester);

    expect(find.text('3'), findsWidgets); // total workouts and the 3-week streak
    expect(find.byKey(const Key('chart-workouts')), findsOneWidget);
    // Tapping a bar names its week.
    await tester.tapAt(tester.getTopRight(find.byKey(const Key('chart-workouts'))) + const Offset(-30, 60));
    await tester.pump();
    expect(find.textContaining('أسبوع '), findsWidgets);

    await scrollTo(tester, find.text('إنجازات المهارات'));
    expect(find.text('+4'), findsOneWidget); // push-up best set 8 -> 12
    await scrollTo(tester, find.byKey(const Key('open-vault')));
    expect(find.text('ضغط الماسة'), findsOneWidget); // milestone
  });

  testWidgets('photo vault: add photos, compare two, then protect with a PIN', (tester) async {
    usePhone(tester);
    final analytics = AnalyticsRepository(env.db);
    await analytics.addPhoto(tinyPng, takenAt: DateTime(2025, 11, 1), weightKg: 78);
    await tester.pumpWidget(env.app());
    await settle(tester);
    await tester.tap(find.text('Progress'));
    await settle(tester);
    await tapOn(tester, find.byKey(const Key('open-vault')));
    expect(find.byType(VaultScreen), findsOneWidget);
    expect(find.text('Set a PIN to lock this vault.'), findsOneWidget);

    // Add a photo (the picker is faked); the weight is pre-filled from the profile.
    await tester.tap(find.byKey(const Key('vault-add-camera')));
    await settle(tester);
    expect(find.text('74.0'), findsOneWidget);
    await tester.tap(find.byKey(const Key('photo-save')));
    await settle(tester);
    final photos = await analytics.photos();
    expect(photos.length, 2);
    expect(photos.first.weightKg, 74);

    // Compare: older photo first, 65 days and -4 kg apart.
    await tester.tap(find.byKey(Key('photo-${photos[0].id}')));
    await tester.pump();
    await tester.tap(find.byKey(Key('photo-${photos[1].id}')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('vault-compare')));
    await settle(tester);
    expect(tester.widget<Text>(find.byKey(const Key('compare-summary'))).data, '65 days apart · ‎−4.0 kg');
    await tester.tap(find.byType(BackButton).last);
    await settle(tester);

    // Set a PIN from the vault.
    await tester.tap(find.byKey(const Key('vault-set-pin')));
    await settle(tester);
    await typePin(tester, '2580');
    await typePin(tester, '2581'); // mismatch -> start again
    expect(find.text('The PINs did not match. Start again.'), findsOneWidget);
    await typePin(tester, '2580');
    await typePin(tester, '2580');
    expect(await env.appLock.hasPin(), isTrue);
    expect(find.text('Set a PIN to lock this vault.'), findsNothing);

    // Leaving and coming back now requires the PIN.
    await tester.tap(find.byType(BackButton).last);
    await settle(tester);
    await tapOn(tester, find.byKey(const Key('open-vault')));
    expect(find.byType(PinEntryScreen), findsOneWidget);
    expect(find.byKey(Key('photo-${photos[0].id}')), findsNothing, reason: 'nothing is built behind the lock');
    await typePin(tester, '1111');
    expect(find.text('Wrong PIN'), findsOneWidget);
    await typePin(tester, '2580');
    expect(find.byKey(Key('photo-${photos[0].id}')), findsOneWidget);
  });

  testWidgets('whole-app lock: PIN on launch, re-locks in the background, biometrics can unlock', (tester) async {
    usePhone(tester);
    await env.appLock.setPin('4821');
    const locked = AppSettings(localeCode: 'ar', lockWholeApp: true, biometricUnlock: true);
    await tester.pumpWidget(env.app(settings: locked));
    await settle(tester);
    expect(find.byType(PinEntryScreen), findsOneWidget);
    expect(find.text('أدخل رمز PIN'), findsOneWidget);
    expect(find.text('تمرين اليوم'), findsNothing);
    expect(find.byKey(const Key('create-plan')), findsNothing, reason: 'app content is not reachable while locked');

    await typePin(tester, '4821');
    expect(find.byType(PinEntryScreen), findsNothing);
    expect(find.byKey(const Key('create-plan')), findsOneWidget);

    // Backgrounding locks again; this time biometrics are available and accepted.
    env.biometrics.available = true;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await settle(tester);
    expect(find.byType(PinEntryScreen), findsNothing, reason: 'unlocked by biometrics');
    expect(find.byType(HomeShell), findsOneWidget);

    // Rejected biometrics leave the PIN prompt up.
    env.biometrics.accept = false;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await settle(tester);
    expect(find.byType(PinEntryScreen), findsOneWidget);
  });

  testWidgets('security settings: lock options appear once a PIN exists; removing it needs the PIN', (tester) async {
    usePhone(tester);
    await env.appLock.setPin('4821');
    await tester.pumpWidget(env.app(injuries: const [Injury(joint: Joint.knees, severity: Severity.mild)]));
    await settle(tester);
    await tester.tap(find.text('Settings'));
    await settle(tester);
    // ignore: avoid_print
    await tapOn(tester, find.byKey(const Key('lock-whole-app')));
    expect((await SettingsRepository(env.db).load()).lockWholeApp, isTrue);
    // Turning it on does not lock the session in progress until the app is backgrounded... it asks now.
    if (find.byType(PinEntryScreen).evaluate().isNotEmpty) await typePin(tester, '4821');

    await tapOn(tester, find.byKey(const Key('remove-pin')));
    expect(find.byType(PinEntryScreen), findsOneWidget);
    await typePin(tester, '4821');
    expect(await env.appLock.hasPin(), isFalse);
    expect((await SettingsRepository(env.db).load()).lockWholeApp, isFalse);
    expect(find.byKey(const Key('lock-whole-app')), findsNothing);
    expect(find.byKey(const Key('backup-export')), findsOneWidget);
  });
}
