import '../../profile/domain/profile.dart';

enum MovementPattern { push, pull, legs, core, statics }

enum ExerciseType { reps, hold }

/// Ordered so that comparisons work: none < low < medium < high.
enum StressLevel { none, low, medium, high }

/// Text available in every supported language. Falls back to English.
class Localized<T> {
  const Localized(this.values);
  final Map<String, T> values;
  T of(String languageCode) => values[languageCode] ?? values['en']!;
}

class Exercise {
  const Exercise({
    required this.id,
    required this.pattern,
    required this.chainId,
    required this.level,
    required this.type,
    required this.defaultSets,
    required this.targetMin,
    required this.targetMax,
    required this.restSec,
    required this.jointStress,
    required this.equipment,
    required this.name,
    required this.cues,
    required this.mistakes,
    this.regressionId,
    this.progressionId,
    this.media,
  });

  final String id;
  final MovementPattern pattern;
  final String chainId;

  /// 1-based position inside the progression chain (1 = easiest).
  final int level;
  final ExerciseType type;
  final int defaultSets;

  /// Rep range, or hold range in seconds when [type] is [ExerciseType.hold].
  final int targetMin;
  final int targetMax;
  final int restSec;
  final Map<Joint, StressLevel> jointStress;
  final List<String> equipment;
  final Localized<String> name;
  final Localized<List<String>> cues;
  final Localized<List<String>> mistakes;
  final String? regressionId;
  final String? progressionId;

  /// File name inside assets/media/exercises/, or null to show the placeholder.
  final String? media;

  bool get isHold => type == ExerciseType.hold;
  StressLevel stressOn(Joint joint) => jointStress[joint] ?? StressLevel.none;

  factory Exercise.fromJson(Map<String, dynamic> j) {
    Localized<List<String>> lists(String key) => Localized({
      for (final e in (j[key] as Map<String, dynamic>).entries)
        e.key: (e.value as List).cast<String>(),
    });
    final d = j['defaults'] as Map<String, dynamic>;
    final stress = (j['jointStress'] as Map<String, dynamic>?) ?? const {};
    return Exercise(
      id: j['id'] as String,
      pattern: MovementPattern.values.byName(j['pattern'] as String),
      chainId: j['chain'] as String,
      level: j['level'] as int,
      type: ExerciseType.values.byName(j['type'] as String),
      defaultSets: d['sets'] as int,
      targetMin: d['min'] as int,
      targetMax: d['max'] as int,
      restSec: d['restSec'] as int,
      jointStress: {
        for (final joint in Joint.values)
          joint: StressLevel.values.byName(
            (stress[joint.name] as String?) ?? 'none',
          ),
      },
      equipment: ((j['equipment'] as List?) ?? const []).cast<String>(),
      name: Localized(
        (j['name'] as Map<String, dynamic>).cast<String, String>(),
      ),
      cues: lists('cues'),
      mistakes: lists('mistakes'),
      regressionId: j['regression'] as String?,
      progressionId: j['progression'] as String?,
      media: j['media'] as String?,
    );
  }
}

class ProgressionChain {
  const ProgressionChain({
    required this.id,
    required this.pattern,
    required this.name,
  });
  final String id;
  final MovementPattern pattern;
  final Localized<String> name;
}
