import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_l10n.dart';
import '../../exercises/presentation/library_screen.dart';
import '../../profile/application/profile_controller.dart';
import '../application/active_session_controller.dart';
import '../domain/templates.dart';
import '../domain/workout_models.dart';
import 'active_session_screen.dart';
import 'workout_preview_screen.dart';

String templateName(AppL10n l, StarterTemplate t) => switch (t) {
  StarterTemplate.push => l.templatePush,
  StarterTemplate.pull => l.templatePull,
  StarterTemplate.legsCore => l.templateLegsCore,
  StarterTemplate.fullBody => l.templateFullBody,
};

/// Home tab: resume a workout, start a starter workout or build one, and see history.
class TrainScreen extends ConsumerWidget {
  const TrainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final library = ref.watch(exerciseLibraryProvider);
    final profile = ref.watch(profileProvider);
    final active = ref.watch(activeSessionProvider).value;
    final history = ref.watch(historyProvider).value ?? const [];
    final text = Theme.of(context).textTheme;

    void preview(String name, List<PlannedExercise> plan) =>
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => WorkoutPreviewScreen(name: name, initialPlan: plan),
          ),
        );

    Future<void> buildOwn() async {
      final ids = await Navigator.of(context).push<List<String>>(
        MaterialPageRoute(builder: (_) => const LibraryScreen(pickMode: true)),
      );
      if (ids == null || ids.isEmpty || !context.mounted) return;
      preview(l.customWorkout, [
        for (final id in ids)
          planPicked(library.byId(id)!, profile.injuries, library),
      ]);
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.appName)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (active != null) ...[
            Card(
              color: AppColors.surfaceElevated,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.primary),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.workoutInProgress,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      active.name,
                      style: text.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      l.setsLogged(active.totalSets),
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      key: const Key('resume-workout'),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const ActiveSessionScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: Text(l.resume),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
          Text(
            l.starterWorkouts,
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            l.starterWorkoutsHint,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          for (final t in StarterTemplate.values)
            Builder(
              builder: (context) {
                final plan = TemplateBuilder.build(
                  t,
                  library: library,
                  experience: profile.profile!.experience,
                  injuries: profile.injuries,
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      key: Key('template-${t.name}'),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      title: Text(
                        templateName(l, t),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        plan.isEmpty
                            ? l.templateEmpty
                            : plan
                                  .map(
                                    (p) => library
                                        .byId(p.exerciseId)!
                                        .name
                                        .of(lang),
                                  )
                                  .join(l.listSeparator),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      enabled: plan.isNotEmpty,
                      onTap: () => preview(templateName(l, t), plan),
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 4),
          OutlinedButton.icon(
            key: const Key('build-own'),
            onPressed: buildOwn,
            icon: const Icon(Icons.add),
            label: Text(l.buildYourOwn),
          ),
          const SizedBox(height: 28),
          Text(
            l.history,
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          if (history.isEmpty)
            Text(
              l.historyEmpty,
              style: const TextStyle(color: AppColors.textSecondary),
            )
          else
            Card(
              child: Column(
                children: [
                  for (final h in history)
                    ListTile(
                      leading: const Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                      ),
                      title: Text(h.name),
                      subtitle: Text(
                        '${MaterialLocalizations.of(context).formatMediumDate(h.startedAt)}'
                        '${l.listSeparator}${l.setsLogged(h.totalSets)}'
                        '${l.listSeparator}${l.minutesShort(h.duration.inMinutes < 1 ? 1 : h.duration.inMinutes)}',
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
