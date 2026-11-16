import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/units.dart';
import '../../../core/widgets/labels.dart';
import '../../../l10n/app_l10n.dart';
import '../../exercises/domain/exercise.dart';
import '../../exercises/presentation/exercise_detail_screen.dart';
import '../../exercises/presentation/exercise_media.dart';
import '../../planner/application/planner_controller.dart';
import '../../planner/domain/progression_engine.dart';

/// Visual unlock map: every progression chain as a path of nodes, from the first
/// regression to the full skill, showing what is done, what is current and what is locked.
class SkillTreeScreen extends ConsumerStatefulWidget {
  const SkillTreeScreen({super.key});

  @override
  ConsumerState<SkillTreeScreen> createState() => _SkillTreeScreenState();
}

class _SkillTreeScreenState extends ConsumerState<SkillTreeScreen> {
  MovementPattern _pattern = MovementPattern.statics;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final library = ref.watch(exerciseLibraryProvider);
    final states = ref.watch(chainStatesProvider).value ?? const <String, ChainState>{};
    final milestones = ref.watch(milestonesProvider).value ?? const [];
    final unlockedAt = {for (final m in milestones.reversed) m.exerciseId: m.achievedAt};

    return Scaffold(
      appBar: AppBar(title: Text(l.tabSkills)),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              children: [
                // Skills first: statics are what people come to this screen for.
                for (final p in [MovementPattern.statics, ...MovementPattern.values.where((p) => p != MovementPattern.statics)])
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ChoiceChip(
                      key: Key('skill-pattern-${p.name}'),
                      avatar: Icon(patternIcon(p), size: 18),
                      showCheckmark: false,
                      label: Text(l.pattern(p)),
                      selected: _pattern == p,
                      labelStyle: TextStyle(
                        color: _pattern == p ? AppColors.background : AppColors.textPrimary,
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
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                for (final chain in library.chainsFor(_pattern))
                  Builder(builder: (context) {
                    final exercises = library.chain(chain.id);
                    final state = states[chain.id];
                    final current = exercises.where((e) => e.id == state?.exerciseId).firstOrNull;
                    final currentLevel = current?.level ?? 1;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    chain.name.of(lang),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(end: 8),
                                  child: Text(
                                    l.levelInChain(currentLevel, exercises.length),
                                    style: const TextStyle(color: AppColors.textSecondary),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: (currentLevel - 1) / (exercises.length - 1).clamp(1, 99),
                                minHeight: 6,
                                backgroundColor: AppColors.surfaceElevated,
                              ),
                            ),
                            const SizedBox(height: 12),
                            for (final e in exercises)
                              _Node(
                                exercise: e,
                                status: e.level < currentLevel
                                    ? _NodeStatus.done
                                    : (e.level == currentLevel ? _NodeStatus.current : _NodeStatus.locked),
                                isFirst: e.level == 1,
                                isLast: e.level == exercises.length,
                                unlockedAt: unlockedAt[e.id],
                                goal: e.level == currentLevel && state != null
                                    ? (e.isHold
                                        ? l.goalHold(ProgressionEngine.holdGoal(e, state))
                                        : l.goalReps(ProgressionEngine.range(e, state).max))
                                    : null,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _NodeStatus { done, current, locked }

class _Node extends StatelessWidget {
  const _Node({
    required this.exercise,
    required this.status,
    required this.isFirst,
    required this.isLast,
    this.unlockedAt,
    this.goal,
  });
  final Exercise exercise;
  final _NodeStatus status;
  final bool isFirst;
  final bool isLast;
  final DateTime? unlockedAt;
  final String? goal;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final color = switch (status) {
      _NodeStatus.done => AppColors.success,
      _NodeStatus.current => AppColors.primary,
      _NodeStatus.locked => const Color(0xFF3A404A),
    };
    // State is never color alone: each status has its own icon and a text label.
    final icon = switch (status) {
      _NodeStatus.done => Icons.check,
      _NodeStatus.current => isLast ? Icons.emoji_events : Icons.play_arrow,
      _NodeStatus.locked => isLast ? Icons.emoji_events_outlined : Icons.lock_outline,
    };
    final statusText = switch (status) {
      _NodeStatus.done => l.nodeDone,
      _NodeStatus.current => goal == null ? l.nodeCurrent : '${l.nodeCurrent} · $goal',
      _NodeStatus.locked => l.nodeLocked,
    };
    final line = Expanded(
      child: Container(width: 3, color: status == _NodeStatus.locked ? const Color(0xFF2A2F37) : AppColors.success),
    );
    return InkWell(
      key: Key('skill-node-${exercise.id}'),
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => ExerciseDetailScreen(exerciseId: exercise.id)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  isFirst ? const Spacer() : line,
                  Container(
                    width: status == _NodeStatus.current ? 36 : 28,
                    height: status == _NodeStatus.current ? 36 : 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: status == _NodeStatus.locked ? AppColors.surfaceElevated : color,
                      border: Border.all(color: color, width: 2),
                    ),
                    child: Icon(
                      icon,
                      size: status == _NodeStatus.current ? 20 : 16,
                      color: status == _NodeStatus.locked ? AppColors.textSecondary : AppColors.background,
                    ),
                  ),
                  isLast
                      ? const Spacer()
                      : Expanded(
                          child: Container(
                            width: 3,
                            color: status == _NodeStatus.done ? AppColors.success : const Color(0xFF2A2F37),
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      exercise.name.of(lang),
                      style: TextStyle(
                        fontWeight: status == _NodeStatus.current ? FontWeight.w700 : FontWeight.w500,
                        fontSize: status == _NodeStatus.current ? 16 : 15,
                        color: status == _NodeStatus.locked ? AppColors.textSecondary : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      unlockedAt != null && status != _NodeStatus.locked
                          ? '$statusText · ${l.unlockedOn(westernDigits(MaterialLocalizations.of(context).formatShortDate(unlockedAt!)))}'
                          : statusText,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
