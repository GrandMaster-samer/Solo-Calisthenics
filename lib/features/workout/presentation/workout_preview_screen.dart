import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/labels.dart';
import '../../../l10n/app_l10n.dart';
import '../../exercises/presentation/library_screen.dart';
import '../../profile/application/profile_controller.dart';
import '../../profile/domain/profile.dart';
import '../application/active_session_controller.dart';
import '../domain/templates.dart';
import '../domain/workout_models.dart';
import 'active_session_screen.dart';

/// Review and tweak a workout (sets, rest, order of exercises) before starting it.
class WorkoutPreviewScreen extends ConsumerStatefulWidget {
  const WorkoutPreviewScreen({
    super.key,
    required this.name,
    required this.initialPlan,
  });
  final String name;
  final List<PlannedExercise> initialPlan;

  @override
  ConsumerState<WorkoutPreviewScreen> createState() =>
      _WorkoutPreviewScreenState();
}

class _WorkoutPreviewScreenState extends ConsumerState<WorkoutPreviewScreen> {
  late final List<PlannedExercise> _plan = List.of(widget.initialPlan);
  bool _starting = false;

  Future<void> _add() async {
    final ids = await Navigator.of(context).push<List<String>>(
      MaterialPageRoute(builder: (_) => const LibraryScreen(pickMode: true)),
    );
    if (ids == null) return;
    final library = ref.read(exerciseLibraryProvider);
    final injuries = ref.read(profileProvider).injuries;
    setState(() {
      for (final id in ids) {
        if (_plan.every((p) => p.exerciseId != id)) {
          _plan.add(planPicked(library.byId(id)!, injuries, library));
        }
      }
    });
  }

  Future<void> _start() async {
    final l = AppL10n.of(context);
    final controller = ref.read(activeSessionProvider.notifier);
    if (ref.read(activeSessionProvider).value != null) {
      final replace = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l.replaceWorkoutTitle),
          content: Text(l.replaceWorkoutBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l.startNew),
            ),
          ],
        ),
      );
      if (replace != true) return;
    }
    setState(() => _starting = true);
    // Needed for the rest timer to alert with the screen off. The app works without it.
    await ref.read(notificationServiceProvider).requestPermission();
    await controller.start(widget.name, _plan);
    if (!mounted) return;
    Navigator.of(context).popUntil((r) => r.isFirst);
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ActiveSessionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final library = ref.watch(exerciseLibraryProvider);
    final injuries = ref.watch(profileProvider.select((p) => p.injuries));
    final warmUp = TemplateBuilder.warmUpJoints(_plan, injuries, library);

    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton.icon(
            key: const Key('start-workout'),
            onPressed: _plan.isEmpty || _starting ? null : _start,
            icon: const Icon(Icons.play_arrow),
            label: Text(l.startWorkout),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (warmUp.isNotEmpty) ...[
            WarmUpCard(joints: warmUp),
            const SizedBox(height: 12),
          ],
          for (var i = 0; i < _plan.length; i++)
            Builder(
              builder: (context) {
                final p = _plan[i];
                final e = library.byId(p.exerciseId)!;
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 4, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.name.of(lang),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    l.target(
                                      e.isHold,
                                      p.targetMin,
                                      p.targetMax,
                                    ),
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: l.remove,
                              onPressed: () =>
                                  setState(() => _plan.removeAt(i)),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        Wrap(
                          spacing: 12,
                          children: [
                            _Stepper(
                              label: l.setsCount(p.sets),
                              onMinus: p.sets > 1
                                  ? () => setState(
                                      () => _plan[i] = p.copyWith(
                                        sets: p.sets - 1,
                                      ),
                                    )
                                  : null,
                              onPlus: p.sets < 10
                                  ? () => setState(
                                      () => _plan[i] = p.copyWith(
                                        sets: p.sets + 1,
                                      ),
                                    )
                                  : null,
                            ),
                            _Stepper(
                              label: l.restSeconds(p.restSec),
                              onMinus: p.restSec > 15
                                  ? () => setState(
                                      () => _plan[i] = p.copyWith(
                                        restSec: p.restSec - 15,
                                      ),
                                    )
                                  : null,
                              onPlus: p.restSec < 600
                                  ? () => setState(
                                      () => _plan[i] = p.copyWith(
                                        restSec: p.restSec + 15,
                                      ),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          OutlinedButton.icon(
            onPressed: _add,
            icon: const Icon(Icons.add),
            label: Text(l.addExercises),
          ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.onMinus,
    required this.onPlus,
  });
  final String label;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onMinus,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 72),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          onPressed: onPlus,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}

/// Targeted warm-up drills for the user's flagged joints.
class WarmUpCard extends StatelessWidget {
  const WarmUpCard({super.key, required this.joints});
  final List<Joint> joints;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.secondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_fire_department_outlined,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l.warmUpTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final j in joints)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('• ${l.joint(j)}: ${l.warmUp(j)}'),
            ),
        ],
      ),
    );
  }
}
