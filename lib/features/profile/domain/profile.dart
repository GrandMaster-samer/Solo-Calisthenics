enum Experience { beginner, intermediate, advanced }

/// Joints covered by the injury screening. Names match the keys in exercises.json.
enum Joint { wrists, shoulders, elbows, knees, lowerBack }

enum Severity { mild, moderate, severe }

class Injury {
  const Injury({
    required this.joint,
    required this.severity,
    this.isCurrent = true,
  });
  final Joint joint;
  final Severity severity;

  /// Stored for the user's reference. The filtering rules use [severity] only.
  final bool isCurrent;

  @override
  bool operator ==(Object other) =>
      other is Injury &&
      other.joint == joint &&
      other.severity == severity &&
      other.isCurrent == isCurrent;
  @override
  int get hashCode => Object.hash(joint, severity, isCurrent);
}

class UserProfile {
  const UserProfile({
    required this.birthYear,
    required this.heightCm,
    required this.weightKg,
    required this.experience,
    this.maxPushUps,
    this.maxPullUps,
    this.maxDeadHangSec,
    this.maxPlankSec,
  });

  final int birthYear;
  final double heightCm;
  final double weightKg;
  final Experience experience;

  // Optional baseline test results.
  final int? maxPushUps;
  final int? maxPullUps;
  final int? maxDeadHangSec;
  final int? maxPlankSec;

  int ageIn(int year) => year - birthYear;
}
