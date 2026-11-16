import '../../exercises/domain/exercise.dart';
import '../../profile/domain/profile.dart';

/// Chooses the starting exercise in a chain from the baseline test, falling back
/// to experience level when a test result is missing.
abstract final class Placement {
  /// Skill chains start conservatively: nobody is placed deep into them without proof.
  static const skillChains = {'handstand', 'planche', 'front_lever', 'muscle_up', 'l_sit', 'dragon_flag', 'hspu'};

  static Exercise start(List<Exercise> chain, UserProfile profile) {
    assert(chain.isNotEmpty);
    final id = switch (chain.first.chainId) {
      'push_up' => _pushUp(profile.maxPushUps),
      'pull_up' => _pullUp(profile.maxPullUps, profile.maxDeadHangSec),
      'plank' => _plank(profile.maxPlankSec),
      _ => null,
    };
    if (id != null) {
      final match = chain.where((e) => e.id == id).firstOrNull;
      if (match != null) return match;
    }
    return byExperience(chain, profile.experience);
  }

  static Exercise byExperience(List<Exercise> chain, Experience experience) {
    final skill = skillChains.contains(chain.first.chainId);
    final fraction = switch (experience) {
      Experience.beginner => skill ? 0.0 : 0.2,
      Experience.intermediate => skill ? 0.2 : 0.5,
      Experience.advanced => skill ? 0.5 : 0.75,
    };
    return chain[((chain.length - 1) * fraction).round()];
  }

  static String? _pushUp(int? max) => switch (max) {
        null => null,
        < 1 => 'wall_push_up',
        < 5 => 'incline_push_up',
        < 10 => 'knee_push_up',
        < 20 => 'push_up',
        < 30 => 'diamond_push_up',
        < 40 => 'decline_push_up',
        _ => 'archer_push_up',
      };

  static String? _pullUp(int? max, int? deadHangSec) => switch (max) {
        null => deadHangSec == null ? null : (deadHangSec < 20 ? 'dead_hang' : 'scapular_pull_up'),
        < 1 => (deadHangSec ?? 0) < 20 ? 'dead_hang' : 'scapular_pull_up',
        < 3 => 'negative_pull_up',
        < 6 => 'chin_up',
        < 12 => 'pull_up',
        _ => 'l_sit_pull_up',
      };

  static String? _plank(int? sec) => switch (sec) {
        null => null,
        < 20 => 'knee_plank',
        < 60 => 'plank',
        < 90 => 'side_plank',
        _ => 'hollow_body_hold',
      };
}
