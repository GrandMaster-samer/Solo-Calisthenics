import 'package:flutter_test/flutter_test.dart';
import 'package:solo_calisthenics/features/exercises/domain/injury_filter.dart';
import 'package:solo_calisthenics/features/profile/domain/profile.dart';
import 'package:solo_calisthenics/features/workout/domain/templates.dart';

import '../helpers.dart';

void main() {
  final library = loadLibrary();

  test('harder exercises are picked as experience grows', () {
    final chain = library.chain('push_up');
    final levels = [
      for (final e in Experience.values)
        TemplateBuilder.pickForExperience(chain, e).level,
    ];
    expect(levels[0], lessThan(levels[1]));
    expect(levels[1], lessThan(levels[2]));
  });

  test('every template yields a workout for every experience level without injuries', () {
    for (final t in StarterTemplate.values) {
      for (final e in Experience.values) {
        final plan = TemplateBuilder.build(
          t,
          library: library,
          experience: e,
          injuries: const [],
        );
        expect(plan.length, t.chainIds.length, reason: '${t.name}/${e.name}');
      }
    }
  });

  test('no template ever contains an excluded exercise, for any single injury', () {
    for (final joint in Joint.values) {
      for (final severity in Severity.values) {
        final injuries = [Injury(joint: joint, severity: severity)];
        for (final t in StarterTemplate.values) {
          for (final e in Experience.values) {
            final plan = TemplateBuilder.build(
              t,
              library: library,
              experience: e,
              injuries: injuries,
            );
            for (final p in plan) {
              expect(
                InjuryFilter.isExcluded(library.byId(p.exerciseId)!, injuries),
                isFalse,
                reason:
                    '${t.name}/${e.name}/${joint.name}/${severity.name}: ${p.exerciseId}',
              );
            }
          }
        }
      }
    }
  });

  test('mild limitation caps sets and requests a warm-up for that joint', () {
    final injuries = [
      const Injury(joint: Joint.shoulders, severity: Severity.mild),
    ];
    final plan = TemplateBuilder.build(
      StarterTemplate.push,
      library: library,
      experience: Experience.intermediate,
      injuries: injuries,
    );
    final dip = plan.firstWhere(
      (p) => library.byId(p.exerciseId)!.chainId == 'dip',
    );
    expect(dip.sets, InjuryFilter.mildSetCap);
    expect(TemplateBuilder.warmUpJoints(plan, injuries, library), [
      Joint.shoulders,
    ]);
  });

  test('moderate limitation swaps in a regression from the same chain', () {
    final plan = TemplateBuilder.build(
      StarterTemplate.push,
      library: library,
      experience: Experience.advanced,
      injuries: const [
        Injury(joint: Joint.elbows, severity: Severity.moderate),
      ],
    );
    // Advanced push-up pick is the archer push-up (elbows: high) -> must be regressed.
    final pushUp = library.byId(plan.first.exerciseId)!;
    expect(pushUp.chainId, 'push_up');
    expect(pushUp.id, isNot('archer_push_up'));
    expect(pushUp.level, lessThan(library.byId('archer_push_up')!.level));
  });

  test('a hand-picked excluded exercise is kept as-is', () {
    final planche = library.byId('full_planche')!;
    final p = planPicked(planche, const [
      Injury(joint: Joint.wrists, severity: Severity.severe),
    ], library);
    expect(p.exerciseId, 'full_planche');
    expect(p.sets, planche.defaultSets);
  });
}
