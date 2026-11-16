import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:solo_calisthenics/features/exercises/domain/exercise.dart';

import '../helpers.dart';

/// Guards the JSON seed so it can be edited by hand without breaking the app.
void main() {
  final library = loadLibrary();

  test('ids are unique and every pattern has exercises', () {
    final ids = library.exercises.map((e) => e.id).toList();
    expect(ids.toSet().length, ids.length);
    for (final p in MovementPattern.values) {
      expect(
        library.exercises.where((e) => e.pattern == p),
        isNotEmpty,
        reason: p.name,
      );
    }
  });

  test('every exercise belongs to a known chain with the same pattern', () {
    final chains = {for (final c in library.chains) c.id: c};
    for (final e in library.exercises) {
      expect(chains[e.chainId], isNotNull, reason: e.id);
      expect(chains[e.chainId]!.pattern, e.pattern, reason: e.id);
    }
  });

  test('regression/progression links are valid, symmetric and stay inside the chain', () {
    for (final e in library.exercises) {
      for (final id in [e.regressionId, e.progressionId].whereType<String>()) {
        expect(library.byId(id), isNotNull, reason: '${e.id} -> $id');
        expect(library.byId(id)!.chainId, e.chainId, reason: '${e.id} -> $id');
      }
      if (e.progressionId != null) {
        expect(
          library.byId(e.progressionId!)!.regressionId,
          e.id,
          reason: e.id,
        );
      }
      if (e.regressionId != null) {
        expect(
          library.byId(e.regressionId!)!.progressionId,
          e.id,
          reason: e.id,
        );
      }
    }
  });

  test('chains are ordered 1..n with one start and one end', () {
    for (final c in library.chains) {
      final chain = library.chain(c.id);
      expect(
        chain.map((e) => e.level),
        List.generate(chain.length, (i) => i + 1),
        reason: c.id,
      );
      expect(chain.first.regressionId, isNull, reason: c.id);
      expect(chain.last.progressionId, isNull, reason: c.id);
    }
  });

  test('every exercise has English and Arabic names, cues and mistakes, and sane targets', () {
    final arabic = RegExp(r'[؀-ۿ]');
    for (final e in library.exercises) {
      for (final lang in ['en', 'ar']) {
        expect(e.name.values[lang], isNotEmpty, reason: '${e.id} name $lang');
        expect(e.cues.values[lang], isNotEmpty, reason: '${e.id} cues $lang');
        expect(
          e.mistakes.values[lang],
          isNotEmpty,
          reason: '${e.id} mistakes $lang',
        );
      }
      expect(arabic.hasMatch(e.name.of('ar')), isTrue, reason: e.id);
      expect(e.cues.of('ar').length, e.cues.of('en').length, reason: e.id);
      expect(e.defaultSets, inInclusiveRange(1, 6), reason: e.id);
      expect(e.targetMin, lessThanOrEqualTo(e.targetMax), reason: e.id);
      expect(e.targetMin, greaterThan(0), reason: e.id);
      expect(e.restSec, inInclusiveRange(30, 300), reason: e.id);
    }
  });

  test('media files named in the seed exist in the asset folder', () {
    for (final e in library.exercises.where((e) => e.media != null)) {
      expect(
        File('assets/media/exercises/${e.media}').existsSync(),
        isTrue,
        reason: e.id,
      );
    }
  });
}
