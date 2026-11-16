import '../../features/exercises/domain/exercise.dart';
import '../../features/profile/domain/profile.dart';
import '../../l10n/app_l10n.dart';

/// Localized names for enums, in one place.
extension Labels on AppL10n {
  String joint(Joint j) => switch (j) {
    Joint.wrists => jointWrists,
    Joint.shoulders => jointShoulders,
    Joint.elbows => jointElbows,
    Joint.knees => jointKnees,
    Joint.lowerBack => jointLowerBack,
  };

  String severity(Severity s) => switch (s) {
    Severity.mild => severityMild,
    Severity.moderate => severityModerate,
    Severity.severe => severitySevere,
  };

  String experience(Experience e) => switch (e) {
    Experience.beginner => expBeginner,
    Experience.intermediate => expIntermediate,
    Experience.advanced => expAdvanced,
  };

  String pattern(MovementPattern p) => switch (p) {
    MovementPattern.push => patternPush,
    MovementPattern.pull => patternPull,
    MovementPattern.legs => patternLegs,
    MovementPattern.core => patternCore,
    MovementPattern.statics => patternStatics,
  };

  String stress(StressLevel s) => switch (s) {
    StressLevel.none => stressNone,
    StressLevel.low => stressLow,
    StressLevel.medium => stressMedium,
    StressLevel.high => stressHigh,
  };

  String warmUp(Joint j) => switch (j) {
    Joint.wrists => warmUpWrists,
    Joint.shoulders => warmUpShoulders,
    Joint.elbows => warmUpElbows,
    Joint.knees => warmUpKnees,
    Joint.lowerBack => warmUpLowerBack,
  };

  /// "8–12 reps" or "10–20 s".
  String target(bool isHold, int min, int max) =>
      isHold ? targetSeconds(min, max) : targetReps(min, max);

  String joints(Iterable<Joint> list) => list.map(joint).join(listSeparator);
}
