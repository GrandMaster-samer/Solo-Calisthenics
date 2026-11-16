import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/exercise.dart';

/// In-memory, read-only exercise library parsed from the bundled JSON seed.
class ExerciseLibrary {
  ExerciseLibrary({required this.chains, required List<Exercise> exercises})
    : exercises = List.unmodifiable(exercises),
      _byId = {for (final e in exercises) e.id: e};

  static const assetPath = 'assets/data/exercises.json';

  final List<ProgressionChain> chains;
  final List<Exercise> exercises;
  final Map<String, Exercise> _byId;

  Exercise? byId(String id) => _byId[id];

  /// Exercises of one chain, easiest first.
  List<Exercise> chain(String chainId) =>
      exercises.where((e) => e.chainId == chainId).toList()
        ..sort((a, b) => a.level.compareTo(b.level));

  List<ProgressionChain> chainsFor(MovementPattern pattern) =>
      chains.where((c) => c.pattern == pattern).toList();

  factory ExerciseLibrary.fromJsonString(String source) {
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
    );
  }

  static Future<ExerciseLibrary> load([AssetBundle? bundle]) async =>
      ExerciseLibrary.fromJsonString(
        await (bundle ?? rootBundle).loadString(assetPath),
      );
}
