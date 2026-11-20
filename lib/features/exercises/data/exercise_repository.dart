import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/exercise.dart';
import '../domain/illustration.dart';

/// In-memory, read-only exercise library parsed from the bundled JSON seed.
class ExerciseLibrary {
  ExerciseLibrary({
    required this.chains,
    required List<Exercise> exercises,
    this.illustrations = IllustrationSet.empty,
  }) : exercises = List.unmodifiable(exercises),
       _byId = {for (final e in exercises) e.id: e};

  static const assetPath = 'assets/data/exercises.json';

  final List<ProgressionChain> chains;
  final List<Exercise> exercises;
  final Map<String, Exercise> _byId;

  /// Drawn, animated guide for each exercise.
  final IllustrationSet illustrations;

  Exercise? byId(String id) => _byId[id];

  /// Exercises of one chain, easiest first.
  List<Exercise> chain(String chainId) =>
      exercises.where((e) => e.chainId == chainId).toList()
        ..sort((a, b) => a.level.compareTo(b.level));

  List<ProgressionChain> chainsFor(MovementPattern pattern) =>
      chains.where((c) => c.pattern == pattern).toList();

  factory ExerciseLibrary.fromJsonString(
    String source, {
    String? illustrations,
  }) {
    final json = jsonDecode(source) as Map<String, dynamic>;
    return ExerciseLibrary(
      chains: [
        for (final c in (json['chains'] as List).cast<Map<String, dynamic>>())
          ProgressionChain(
            id: c['id'] as String,
            pattern: MovementPattern.values.byName(c['pattern'] as String),
            name: Localized(
              (c['name'] as Map<String, dynamic>).cast<String, String>(),
            ),
          ),
      ],
      exercises: [
        for (final e
            in (json['exercises'] as List).cast<Map<String, dynamic>>())
          Exercise.fromJson(e),
      ],
      illustrations: illustrations == null
          ? IllustrationSet.empty
          : IllustrationSet.fromJsonString(illustrations),
    );
  }

  static Future<ExerciseLibrary> load([AssetBundle? bundle]) async {
    final b = bundle ?? rootBundle;
    return ExerciseLibrary.fromJsonString(
      await b.loadString(assetPath),
      illustrations: await b.loadString(IllustrationSet.assetPath),
    );
  }
}
