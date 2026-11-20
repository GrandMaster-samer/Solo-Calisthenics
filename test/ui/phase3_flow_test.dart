import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:solo_calisthenics/features/cloud/domain/cloud_backend.dart';
import 'package:solo_calisthenics/features/cloud/presentation/coach_screens.dart';

import '../cloud/fake_backend.dart';
import '../helpers.dart';
import 'phase2_flow_test.dart' show mainList, scrollTo, settle, tapOn, usePhone;

void main() {
  late TestEnv env;
  late Directory dir;
  setUp(() {
    env = TestEnv();
    dir = Directory.systemTemp.createTempSync('solo_ui_cloud');
  });
  tearDown(() async {
    await env.db.close();
    dir.deleteSync(recursive: true);
  });

  testWidgets('without a backend there is no trace of cloud features', (
    tester,
  ) async {
    usePhone(tester);
    await tester.pumpWidget(env.app());
    await settle(tester);
    await tester.tap(find.text('Progress'));
    await settle(tester);
    await scrollTo(tester, find.byKey(const Key('open-vault')));
    expect(find.byKey(const Key('open-coach')), findsNothing);
    await tester.tap(find.text('Settings'));
    await settle(tester);
    await scrollTo(tester, find.text('Open-source licenses'));
    expect(find.byKey(const Key('cloud-sign-in')), findsNothing);
    expect(
      find.text('Account and cloud (optional)', skipOffstage: false),
      findsNothing,
    );
  });

  testWidgets(
    'athlete sends a clip, coach reviews it, athlete reads the feedback',
    (tester) async {
      usePhone(tester);
      final backend = FakeCloudBackend(clock: env.clock.call);
      final clips = FakeClipSource(dir);
      env
        ..cloud = backend
        ..clipSource = clips;
      await tester.pumpWidget(env.app());
      await settle(tester);

      // Sign in from Settings; the core app was usable before this.
      await tester.tap(find.text('Settings'));
      await settle(tester);
      await tapOn(tester, find.byKey(const Key('cloud-sign-in')));
      expect(find.text('athlete@example.com'), findsOneWidget);
      expect(
        find.text(
          'No cloud backup yet. Encrypted on this device before upload.',
        ),
        findsOneWidget,
      );

      // Send a clip.
      await tester.tap(find.text('Progress'));
      await settle(tester);
      await tapOn(tester, find.byKey(const Key('open-coach')));
      expect(find.byType(CoachHubScreen), findsOneWidget);
      expect(
        find.byKey(const Key('open-coach-inbox')),
        findsNothing,
        reason: 'athletes have no inbox',
      );
      expect(
        tester
            .widget<FilledButton>(find.byKey(const Key('clip-send')))
            .onPressed,
        isNull,
      );

      clips.tooLong = true;
      await tapOn(tester, find.byKey(const Key('clip-record')));
      expect(
        find.text('The clip must be 30 seconds or shorter.'),
        findsOneWidget,
      );
      clips.tooLong = false;
      await tapOn(tester, find.byKey(const Key('clip-record')));
      expect(find.text('Clip ready to send'), findsOneWidget);

      await tapOn(tester, find.byKey(const Key('clip-exercise')));
      await tapOn(tester, find.byKey(const Key('pattern-pull')));
      await tapOn(tester, find.byKey(const Key('exercise-pull_up')));
      await tapOn(tester, find.byKey(const Key('picker-done')));
      expect(find.text('Pull-up'), findsOneWidget);
      await tester.enterText(
        find.byKey(const Key('clip-note')),
        'Do I reach full extension?',
      );
      await tapOn(tester, find.byKey(const Key('clip-send')));

      expect(backend.clips.length, 1);
      expect(
        dir.listSync(),
        isEmpty,
        reason: 'the local clip is removed after upload',
      );
      await scrollTo(tester, find.text('Waiting'));
      expect(find.text('Do I reach full extension?'), findsOneWidget);

      // The coach signs in on the same build.
      await backend.signOut();
      backend.nextUser = const CloudUser(
        id: 'coach-1',
        email: 'coach@example.com',
        isCoach: true,
      );
      await backend.signInWithGoogle();
      await settle(tester);
      await scrollTo(tester, find.byKey(const Key('open-coach-inbox')));
      expect(find.text('1 clip waiting'), findsOneWidget);
      await tapOn(tester, find.byKey(const Key('open-coach-inbox')));
      await tapOn(tester, find.byKey(const Key('queue-s1')));
      expect(
        find.textContaining('PLAYER https://fake.invalid/athlete-1/s1.mp4'),
        findsOneWidget,
      );
      expect(
        tester
            .widget<FilledButton>(find.byKey(const Key('feedback-send')))
            .onPressed,
        isNull,
      );
      await tester.enterText(
        find.byKey(const Key('feedback-field')),
        'Yes. Pause one second at the bottom.',
      );
      await tester.pump();
      await tapOn(tester, find.byKey(const Key('feedback-send')));
      expect(backend.clips, isEmpty, reason: 'clip deleted with the feedback');
      expect(find.text('No clips waiting for review.'), findsOneWidget);
      await tester.tap(find.byType(BackButton).last);
      await settle(tester);

      // Back as the athlete: the feedback is in the inbox.
      await backend.signOut();
      backend.nextUser = const CloudUser(
        id: 'athlete-1',
        email: 'athlete@example.com',
      );
      await backend.signInWithGoogle();
      await settle(tester);
      await scrollTo(tester, find.text('Reviewed'));
      expect(find.text('Yes. Pause one second at the bottom.'), findsOneWidget);
    },
  );

  testWidgets(
    'coach review in Arabic: sign-in prompt, hub and settings lay out RTL',
    (tester) async {
      usePhone(tester);
      final backend = FakeCloudBackend(clock: env.clock.call);
      env
        ..cloud = backend
        ..clipSource = FakeClipSource(dir);
      await tester.pumpWidget(env.app(locale: 'ar'));
      await settle(tester);
      await tester.tap(find.text('التقدّم'));
      await settle(tester);
      await tapOn(tester, find.byKey(const Key('open-coach')));
      expect(
        find.textContaining('تحتاج مراجعة المدرب إلى حساب'),
        findsOneWidget,
      );
      backend.failNextCall = true; // offline: a message, no crash
      await tapOn(tester, find.byKey(const Key('coach-sign-in')));
      expect(find.textContaining('تعذّر تنفيذ العملية'), findsOneWidget);
      await tapOn(tester, find.byKey(const Key('coach-sign-in')));
      expect(
        Directionality.of(tester.element(find.byType(CoachHubScreen))),
        TextDirection.rtl,
      );
      expect(find.text('مقطع جديد'), findsOneWidget);
      await tapOn(tester, find.byKey(const Key('clip-gallery')));
      expect(find.text('المقطع جاهز للإرسال'), findsOneWidget);
      await tester.tap(find.byType(BackButton).last);
      await settle(tester);

      await tester.tap(find.text('الإعدادات'));
      await settle(tester);
      await scrollTo(tester, find.byKey(const Key('cloud-delete-data')));
      expect(find.text('athlete@example.com'), findsOneWidget);
      await tapOn(tester, find.byKey(const Key('cloud-sign-out')));
      await scrollTo(tester, find.byKey(const Key('cloud-sign-in')));
      expect(mainList(), findsOneWidget);
    },
  );
}
