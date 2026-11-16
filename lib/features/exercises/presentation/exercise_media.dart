import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_l10n.dart';
import '../domain/exercise.dart';

IconData patternIcon(MovementPattern p) => switch (p) {
  MovementPattern.push => Icons.keyboard_double_arrow_up,
  MovementPattern.pull => Icons.keyboard_double_arrow_down,
  MovementPattern.legs => Icons.directions_run,
  MovementPattern.core => Icons.adjust,
  MovementPattern.statics => Icons.balance,
};

/// Looping visual guide for an exercise. Shows the bundled animated WebP named in
/// the exercise's `media` field, or a clearly labeled placeholder when none exists yet.
/// See assets/media/README.md for how to add clips.
class ExerciseMedia extends StatelessWidget {
  const ExerciseMedia({super.key, required this.exercise});
  final Exercise exercise;

  static const directory = 'assets/media/exercises/';

  @override
  Widget build(BuildContext context) {
    final media = exercise.media;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: media == null
            ? _Placeholder(exercise: exercise)
            : Image.asset(
                '$directory$media',
                fit: BoxFit.cover,
                gaplessPlayback: true,
                errorBuilder: (_, _, _) => _Placeholder(exercise: exercise),
              ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.exercise});
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceElevated,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            patternIcon(exercise.pattern),
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 8),
          Text(
            AppL10n.of(context).mediaPlaceholder,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
