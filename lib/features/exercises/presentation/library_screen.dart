import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/labels.dart';
import '../../../l10n/app_l10n.dart';
import '../../profile/application/profile_controller.dart';
import '../domain/exercise.dart';
import '../domain/injury_filter.dart';
import 'exercise_detail_screen.dart';
import 'exercise_media.dart';

/// Exercise library grouped by movement pattern and progression chain.
/// With [pickMode] it becomes a multi-select picker and pops with the chosen ids.
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key, this.pickMode = false});
  final bool pickMode;

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  MovementPattern _pattern = MovementPattern.push;
  final _picked = <String>[];

  Future<void> _toggle(Exercise e, ExerciseAssessment a) async {
    if (_picked.contains(e.id)) {
      setState(() => _picked.remove(e.id));
      return;
    }
    if (a.isExcluded && !await confirmExcluded(context, a)) return;
    setState(() => _picked.add(e.id));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final library = ref.watch(exerciseLibraryProvider);
    final injuries = ref.watch(profileProvider.select((p) => p.injuries));
    final chains = library.chainsFor(_pattern);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pickMode ? l.pickExercises : l.tabLibrary),
      ),
      floatingActionButton: widget.pickMode && _picked.isNotEmpty
          ? FloatingActionButton.extended(
              key: const Key('picker-done'),
              onPressed: () =>
                  Navigator.of(context).pop(List<String>.of(_picked)),
              icon: const Icon(Icons.check),
              label: Text(l.addSelected(_picked.length)),
            )
          : null,
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              children: [
                for (final p in MovementPattern.values)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ChoiceChip(
                      key: Key('pattern-${p.name}'),
                      avatar: Icon(patternIcon(p), size: 18),
                      showCheckmark: false,
                      label: Text(l.pattern(p)),
                      selected: _pattern == p,
                      labelStyle: TextStyle(
                        color: _pattern == p
                            ? AppColors.background
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) => setState(() => _pattern = p),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                for (final chain in chains) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Text(
                      chain.name.of(lang),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        for (final e in library.chain(chain.id))
                          _ExerciseTile(
                            exercise: e,
                            assessment: InjuryFilter.assess(
                              e,
                              injuries,
                              lookup: library.byId,
                            ),
                            picked: widget.pickMode
                                ? _picked.contains(e.id)
                                : null,
                            onPick: (a) => _toggle(e, a),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Asks before adding an exercise the injury screening excludes. Returns true to proceed.
Future<bool> confirmExcluded(BuildContext context, ExerciseAssessment a) async {
  final l = AppL10n.of(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.excludedConfirmTitle),
      content: Text(l.excludedConfirmBody(l.joints(a.blockingJoints))),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l.addAnyway),
        ),
      ],
    ),
  );
  return ok ?? false;
}

class _ExerciseTile extends StatelessWidget {
  const _ExerciseTile({
    required this.exercise,
    required this.assessment,
    required this.picked,
    required this.onPick,
  });
  final Exercise exercise;
  final ExerciseAssessment assessment;

  /// null when not in pick mode.
  final bool? picked;
  final void Function(ExerciseAssessment) onPick;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final excluded = assessment.isExcluded;
    final note = switch (assessment.status) {
      ExerciseStatus.excluded => l.notRecommendedFor(
        l.joints(assessment.blockingJoints),
      ),
      ExerciseStatus.caution => l.cautionFor(l.joints(assessment.warmUpJoints)),
      ExerciseStatus.allowed => null,
    };
    return Opacity(
      // Excluded exercises stay visible (greyed) so the path ahead is clear.
      opacity: excluded ? 0.45 : 1,
      child: ListTile(
        key: Key('exercise-${exercise.id}'),
        minVerticalPadding: 10,
        leading: CircleAvatar(
          backgroundColor: AppColors.surfaceElevated,
          foregroundColor: AppColors.textPrimary,
          child: Text('${exercise.level}'),
        ),
        title: Text(
          exercise.name.of(lang),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${exercise.defaultSets} × ${l.target(exercise.isHold, exercise.targetMin, exercise.targetMax)}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            if (note != null)
              Row(
                children: [
                  Icon(
                    excluded ? Icons.block : Icons.warning_amber_rounded,
                    size: 14,
                    color: excluded ? AppColors.error : AppColors.warning,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      note,
                      style: TextStyle(
                        fontSize: 12,
                        color: excluded ? AppColors.error : AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        trailing: picked == null
            ? const Icon(Icons.chevron_right)
            : Checkbox(value: picked, onChanged: (_) => onPick(assessment)),
        onTap: picked != null
            ? () => onPick(assessment)
            : () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ExerciseDetailScreen(exerciseId: exercise.id),
                ),
              ),
      ),
    );
  }
}
