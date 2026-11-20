import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/providers.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_l10n.dart';
import '../domain/exercise.dart';
import 'exercise_illustration.dart';

IconData patternIcon(MovementPattern p) => switch (p) {
  MovementPattern.push => Icons.keyboard_double_arrow_up,
  MovementPattern.pull => Icons.keyboard_double_arrow_down,
  MovementPattern.legs => Icons.directions_run,
  MovementPattern.core => Icons.adjust,
  MovementPattern.statics => Icons.balance,
};

/// Looping visual guide for an exercise. A clip named in the exercise's `media`
/// field wins (see assets/media/README.md); otherwise the app's own animated
/// drawing is shown, and a labeled placeholder only if neither exists.
class ExerciseMedia extends ConsumerWidget {
  const ExerciseMedia({super.key, required this.exercise});
  final Exercise exercise;

  static const directory = 'assets/media/exercises/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final media = exercise.media;
    final lang = Localizations.localeOf(context).languageCode;
    final drawn =
        ref.watch(exerciseLibraryProvider).illustrations[exercise.id] != null;
    final fallback = drawn
        ? ColoredBox(
            key: const Key('exercise-illustration'),
            color: AppColors.surfaceElevated,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ExerciseIllustration(
                exerciseId: exercise.id,
                semanticLabel: illustrationLabel(
                  context,
                  exercise.name.of(lang),
                ),
              ),
            ),
          )
        : _Placeholder(exercise: exercise);
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: media == null
            ? fallback
            : Image.asset(
                '$directory$media',
                fit: BoxFit.cover,
                gaplessPlayback: true,
                errorBuilder: (_, _, _) => fallback,
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
