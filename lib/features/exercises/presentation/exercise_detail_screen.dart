import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/labels.dart';
import '../../../l10n/app_l10n.dart';
import '../../profile/application/profile_controller.dart';
import '../../profile/domain/profile.dart';
import '../../workout/domain/templates.dart';
import '../../workout/presentation/workout_preview_screen.dart';
import '../domain/exercise.dart';
import '../domain/injury_filter.dart';
import 'exercise_media.dart';
import 'library_screen.dart' show confirmExcluded;

class ExerciseDetailScreen extends ConsumerWidget {
  const ExerciseDetailScreen({
    super.key,
    required this.exerciseId,
    this.showStart = true,
  });
  final String exerciseId;

  /// Hidden when opened from inside a running workout.
  final bool showStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final library = ref.watch(exerciseLibraryProvider);
    final injuries = ref.watch(profileProvider.select((p) => p.injuries));
    final e = library.byId(exerciseId);
    if (e == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l.exerciseMissing)),
      );
    }
    final a = InjuryFilter.assess(e, injuries, lookup: library.byId);
    final text = Theme.of(context).textTheme;

    void open(String id) => Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) =>
            ExerciseDetailScreen(exerciseId: id, showStart: showStart),
      ),
    );

    Future<void> start() async {
      if (a.isExcluded && !await confirmExcluded(context, a)) return;
      if (!context.mounted) return;
      // An excluded exercise the user insists on is planned as-is, without substitution.
      final planned = a.isExcluded
          ? null
          : TemplateBuilder.plan(e, injuries, library);
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => WorkoutPreviewScreen(
            name: e.name.of(lang),
            initialPlan: [planned ?? plannedFromDefaults(e)],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(e.name.of(lang))),
      bottomNavigationBar: showStart
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: FilledButton.icon(
                  onPressed: start,
                  icon: const Icon(Icons.play_arrow),
                  label: Text(l.trainThis),
                ),
              ),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ExerciseMedia(exercise: e),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                avatar: Icon(patternIcon(e.pattern), size: 18),
                label: Text(l.pattern(e.pattern)),
              ),
              Chip(
                label: Text(
                  '${e.defaultSets} × ${l.target(e.isHold, e.targetMin, e.targetMax)}',
                ),
              ),
              Chip(label: Text(l.restSeconds(e.restSec))),
              Chip(
                label: Text(
                  l.levelInChain(e.level, library.chain(e.chainId).length),
                ),
              ),
            ],
          ),
          if (a.status != ExerciseStatus.allowed) ...[
            const SizedBox(height: 16),
            _AssessmentBanner(
              assessment: a,
              substitute: a.substituteId == null
                  ? null
                  : library.byId(a.substituteId!),
              onOpen: open,
            ),
          ],
          _Section(
            title: l.formCues,
            color: AppColors.primary,
            icon: Icons.check_circle_outline,
            items: e.cues.of(lang),
          ),
          _Section(
            title: l.commonMistakes,
            color: AppColors.error,
            icon: Icons.cancel_outlined,
            items: e.mistakes.of(lang),
          ),
          const SizedBox(height: 20),
          Text(
            l.jointStress,
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  for (final j in Joint.values)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Expanded(child: Text(l.joint(j))),
                          _StressDots(level: e.stressOn(j)),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 72,
                            child: Text(
                              l.stress(e.stressOn(j)),
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l.progressionPath,
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _LinkTile(
                  label: l.easier,
                  icon: Icons.south,
                  exercise: e.regressionId == null
                      ? null
                      : library.byId(e.regressionId!),
                  onOpen: open,
                ),
                const Divider(),
                _LinkTile(
                  label: l.harder,
                  icon: Icons.north,
                  exercise: e.progressionId == null
                      ? null
                      : library.byId(e.progressionId!),
                  onOpen: open,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _AssessmentBanner extends StatelessWidget {
  const _AssessmentBanner({
    required this.assessment,
    required this.substitute,
    required this.onOpen,
  });
  final ExerciseAssessment assessment;
  final Exercise? substitute;
  final void Function(String id) onOpen;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final excluded = assessment.isExcluded;
    final color = excluded ? AppColors.error : AppColors.warning;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                excluded ? Icons.block : Icons.warning_amber_rounded,
                color: color,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  excluded
                      ? l.notRecommendedFor(l.joints(assessment.blockingJoints))
                      : l.cautionFor(l.joints(assessment.warmUpJoints)),
                  style: TextStyle(color: color, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          if (!excluded) ...[
            const SizedBox(height: 8),
            for (final j in assessment.warmUpJoints) Text('• ${l.warmUp(j)}'),
            if (assessment.maxSets != null) ...[
              const SizedBox(height: 4),
              Text(l.volumeCapped(assessment.maxSets!)),
            ],
          ],
          if (excluded && substitute != null)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: () => onOpen(substitute!.id),
                icon: const Icon(Icons.swap_horiz),
                label: Text(l.trySubstitute(substitute!.name.of(lang))),
              ),
            ),
          if (excluded && substitute == null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(l.noSubstitute),
            ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.items,
    required this.color,
    required this.icon,
  });
  final String title;
  final List<String> items;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 10),
                Expanded(child: Text(item)),
              ],
            ),
          ),
      ],
    );
  }
}

class _StressDots extends StatelessWidget {
  const _StressDots({required this.level});
  final StressLevel level;

  @override
  Widget build(BuildContext context) {
    final color = switch (level) {
      StressLevel.none => AppColors.textSecondary,
      StressLevel.low => AppColors.success,
      StressLevel.medium => AppColors.warning,
      StressLevel.high => AppColors.error,
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 3; i++)
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsetsDirectional.only(start: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i <= level.index ? color : const Color(0xFF2A2F37),
            ),
          ),
      ],
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.label,
    required this.icon,
    required this.exercise,
    required this.onOpen,
  });
  final String label;
  final IconData icon;
  final Exercise? exercise;
  final void Function(String id) onOpen;

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final e = exercise;
    return ListTile(
      leading: Icon(
        icon,
        color: e == null ? AppColors.textSecondary : AppColors.secondary,
      ),
      title: Text(
        label,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
      ),
      subtitle: Text(
        e?.name.of(lang) ?? AppL10n.of(context).noneInChain,
        style: TextStyle(
          color: e == null ? AppColors.textSecondary : AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: e == null ? null : const Icon(Icons.chevron_right),
      onTap: e == null ? null : () => onOpen(e.id),
    );
  }
}
