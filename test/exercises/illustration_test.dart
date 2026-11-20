import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:solo_calisthenics/features/exercises/domain/illustration.dart';

import '../helpers.dart';

void main() {
  final library = loadLibrary();
  final set = library.illustrations;
  final l = set.lengths;

  test(
    'every exercise has a drawing, and every drawing belongs to an exercise',
    () {
      expect(
        set.byExercise.keys.toSet(),
        library.exercises.map((e) => e.id).toSet(),
      );
    },
  );

  test('drawings are well formed: one anchor per drawing, all angles, valid cover, sane timing', () {
    const known = {
      'floor',
      'bar',
      'lowBar',
      'post',
      'wall',
      'bench',
      'dipBars',
      'pad',
      'band',
    };
    for (final MapEntry(key: id, value: ill) in set.byExercise.entries) {
      expect(ill.poses.map((p) => p.anchor).toSet().length, 1, reason: id);
      for (final p in ill.poses) {
        for (final k in FigurePose.angleKeys) {
          expect(p.angles[k]?.isFinite, isTrue, reason: '$id $k');
        }
      }
      expect(ill.cover, inInclusiveRange(0, ill.poses.length - 1), reason: id);
      for (final prop in ill.props) {
        expect(known, contains(prop.type), reason: id);
      }
      if (!ill.isStatic) {
        expect(ill.loopMs, inInclusiveRange(1500, 9000), reason: id);
      }
      final b = ill.bounds(l);
      expect(b.width, greaterThan(25), reason: id);
      expect(b.height, greaterThan(30), reason: id);
    }
  });

  test('limbs keep their length in every frame (no stretching)', () {
    double dist(Offset a, Offset b) => (a - b).distance;
    for (final MapEntry(key: id, value: ill) in set.byExercise.entries) {
      for (var i = 0; i <= 20; i++) {
        final j = ill.poseAt(ill.loopMs * i / 20).joints(l);
        expect(
          dist(j['shoulder']!, j['nearElbow']!),
          closeTo(l.upper, 1e-6),
          reason: id,
        );
        expect(
          dist(j['nearKnee']!, j['nearAnkle']!),
          closeTo(l.shin, 1e-6),
          reason: id,
        );
        expect(
          dist(j['hip']!, j['farKnee']!),
          closeTo(l.thigh, 1e-6),
          reason: id,
        );
      }
    }
  });

  test('the pinned point stays put while the figure moves', () {
    final pull = set['pull_up']!;
    for (var i = 0; i <= 30; i++) {
      final p = pull.poseAt(pull.loopMs * i / 30);
      expect(p.joints(l)['nearHand']!.dx, closeTo(0, 1e-6));
      expect(p.joints(l)['nearHand']!.dy, closeTo(0, 1e-6));
    }
  });

  test('contacts touch: push-up hands and toes stay on the floor at the top and bottom', () {
    final push = set['push_up']!;
    for (final p in push.poses) {
      final j = p.joints(l);
      expect(j['nearHand']!.dy, closeTo(-3, 0.01));
      expect(j['nearToe']!.dy, closeTo(-3, 0.01));
    }
    // ... and the body is a straight line from heel to neck.
    final j = push.poses.first.joints(l);
    final a = math.atan2(
      j['neck']!.dy - j['hip']!.dy,
      j['neck']!.dx - j['hip']!.dx,
    );
    final b = math.atan2(
      j['hip']!.dy - j['nearAnkle']!.dy,
      j['hip']!.dx - j['nearAnkle']!.dx,
    );
    expect(a, closeTo(b, 1e-6));
  });

  test('the loop holds, moves forward, holds and comes back', () {
    final ill = set['push_up']!;
    expect(ill.poses.length, 2);
    FigurePose at(double ms) => ill.poseAt(ms);
    expect(at(0)['nu'], ill.poses.first['nu']);
    expect(at(ill.holdMs - 1.0)['nu'], ill.poses.first['nu']);
    final midForward = at(ill.holdMs + ill.forwardMs / 2)['nu'];
    expect(
      midForward,
      closeTo((ill.poses.first['nu'] + ill.poses.last['nu']) / 2, 0.01),
    );
    expect(at(ill.holdMs + ill.forwardMs + 1.0)['nu'], ill.poses.last['nu']);
    expect(at(ill.loopMs - 1.0)['nu'], closeTo(ill.poses.first['nu'], 0.01));
    expect(at(ill.loopMs + 1.0)['nu'], ill.poses.first['nu'], reason: 'loops');
  });

  test('negatives show the starting position as their still image', () {
    expect(set['negative_pull_up']!.cover, 0);
    expect(set['pull_up']!.cover, 1);
    expect(set['dead_hang']!.isStatic, isTrue);
  });
}
