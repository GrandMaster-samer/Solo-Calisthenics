import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/units.dart';
import '../../../l10n/app_l10n.dart';
import '../../exercises/presentation/library_screen.dart';
import '../../planner/application/planner_controller.dart';
import '../../planner/domain/weekly_planner.dart';
import '../../planner/presentation/plan_setup_screen.dart';
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

String dayTypeName(AppL10n l, DayType t) => switch (t) {
  DayType.push => l.templatePush,
  DayType.pull => l.templatePull,
  DayType.legsCore => l.templateLegsCore,
  DayType.fullBody => l.templateFullBody,
  DayType.upper => l.dayUpper,
};

/// Home tab: this week's plan, resume, build-your-own and history.
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
    final planner = ref.watch(plannerProvider).value;
    final text = Theme.of(context).textTheme;
    final weekdays = l.weekdaysShort.split(',');

    void preview(String name, List<PlannedExercise> plan, {PlanLink? link}) =>
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) =>
                WorkoutPreviewScreen(name: name, initialPlan: plan, link: link),
          ),
        );

    void openDay(PlannerState p, PlannedDay day) => preview(
      dayTypeName(l, day.type),
      day.exercises,
      link: PlanLink(
        week: DeloadPolicy.weekKey(p.today),
        dayIndex: day.index,
        isDeload: p.week.isDeload,
      ),
    );

    void setupPlan() => Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const PlanSetupScreen()));

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

    String names(Iterable<PlannedExercise> plan) => plan
        .map((p) => library.byId(p.exerciseId)!.name.of(lang))
        .join(l.listSeparator);

    Widget sectionTitle(String t) =>
        Text(t, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700));

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
          if (planner == null) ...[
            // No plan yet: invite to create one, and offer the starter workouts meanwhile.
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.planPromoTitle,
                      style: text.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l.planPromoBody,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      key: const Key('create-plan'),
                      onPressed: setupPlan,
                      icon: const Icon(Icons.calendar_month),
                      label: Text(l.planCreate),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            sectionTitle(l.starterWorkouts),
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
                          plan.isEmpty ? l.templateEmpty : names(plan),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        enabled: plan.isNotEmpty,
                        onTap: () => preview(templateName(l, t), plan),
                      ),
                    ),
                  );
                },
              ),
          ] else ...[
            Row(
              children: [
                Expanded(child: sectionTitle(l.thisWeek)),
                if (planner.week.isDeload)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 4),
                    child: Chip(
                      key: const Key('deload-badge'),
                      avatar: const Icon(
                        Icons.battery_charging_full,
                        size: 18,
                        color: AppColors.warning,
                      ),
                      label: Text(l.deloadWeek),
                    ),
                  ),
                IconButton(
                  key: const Key('edit-plan'),
                  tooltip: l.planSetupTitle,
                  onPressed: setupPlan,
                  icon: const Icon(Icons.tune),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (planner.nextDay case final next?)
              Card(
                color: AppColors.surfaceElevated,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        next.weekday == planner.today.weekday
                            ? l.todaysWorkout
                            : l.nextWorkout,
                        style: const TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dayTypeName(l, next.type),
                        style: text.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(names(next.exercises)),
                      const SizedBox(height: 4),
                      Text(
                        l.aboutMinutes(next.estimatedMinutes),
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        key: const Key('start-planned'),
                        onPressed: next.exercises.isEmpty
                            ? null
                            : () => openDay(planner, next),
                        icon: const Icon(Icons.play_arrow),
                        label: Text(l.reviewAndStart),
                      ),
                    ],
                  ),
                ),
              )
            else
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.emoji_events_outlined,
                    color: AppColors.primary,
                  ),
                  title: Text(l.weekComplete),
                ),
              ),
            const SizedBox(height: 10),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (final day in planner.week.days)
                    ListTile(
                      key: Key('plan-day-${day.index}'),
                      leading: Icon(
                        planner.completedDays.contains(day.index)
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: planner.completedDays.contains(day.index)
                            ? AppColors.success
                            : AppColors.textSecondary,
                        semanticLabel: planner.completedDays.contains(day.index)
                            ? l.dayDone
                            : l.dayOpen,
                      ),
                      title: Text(
                        '${weekdays[day.weekday - 1]}${l.listSeparator}${dayTypeName(l, day.type)}',
                      ),
                      subtitle: Text(
                        names(day.exercises),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: day.exercises.isEmpty
                          ? null
                          : () => openDay(planner, day),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          OutlinedButton.icon(
            key: const Key('build-own'),
            onPressed: buildOwn,
            icon: const Icon(Icons.add),
            label: Text(l.buildYourOwn),
          ),
          const SizedBox(height: 28),
          sectionTitle(l.history),
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
                        '${westernDigits(MaterialLocalizations.of(context).formatMediumDate(h.startedAt))}'
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
