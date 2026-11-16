import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../profile/application/profile_controller.dart';
import '../data/progress_repository.dart';
import '../domain/progression_engine.dart';
import '../domain/weekly_planner.dart';
import 'progression_service.dart';

final progressRepositoryProvider = Provider((ref) => ProgressRepository(ref.watch(databaseProvider)));
final progressionServiceProvider = Provider(
  (ref) => ProgressionService(ref.watch(progressRepositoryProvider), ref.watch(exerciseLibraryProvider)),
);

/// Current level in every chain (placed from the profile where nothing is stored yet).
/// Works without a weekly plan, so the skill tree is always available.
final chainStatesProvider = FutureProvider<Map<String, ChainState>>((ref) async {
  final profile = ref.watch(profileProvider).profile;
  final stored = await ref.watch(progressRepositoryProvider).chainStates();
  if (profile == null) return stored;
  return WeeklyPlanner.placeMissing(stored, ref.watch(exerciseLibraryProvider), profile);
});

final milestonesProvider = FutureProvider<List<Milestone>>((ref) {
  ref.watch(chainStatesProvider);
  return ref.watch(progressRepositoryProvider).milestones();
});

class PlannerState {
  const PlannerState({required this.config, required this.week, required this.completedDays, required this.today});
  final PlanConfig config;
  final WeekPlan week;

  /// Plan day indexes already trained this week.
  final Set<int> completedDays;
  final DateTime today;

  /// Today's planned day if it is still open, else the next open day this week.
  PlannedDay? get nextDay {
    final open = week.days.where((d) => !completedDays.contains(d.index)).toList();
    if (open.isEmpty) return null;
    return open.where((d) => d.weekday == today.weekday).firstOrNull ??
        open.where((d) => d.weekday > today.weekday).firstOrNull ??
        open.first;
  }
}

final plannerProvider = AsyncNotifierProvider<PlannerController, PlannerState?>(PlannerController.new);

class PlannerController extends AsyncNotifier<PlannerState?> {
  @override
  Future<PlannerState?> build() async {
    final repo = ref.watch(progressRepositoryProvider);
    final profile = ref.watch(profileProvider); // rebuild when injuries or stats change
    final states = await ref.watch(chainStatesProvider.future);
    var config = await repo.planConfig();
    if (config == null || profile.profile == null) return null;

    final now = ref.read(clockProvider)();
    if (DeloadPolicy.isDue(now, config)) {
      // Scheduled lighter week: starts on this week's Monday.
      config = config.copyWith(lastDeloadStart: () => DeloadPolicy.mondayOf(now));
      await repo.savePlanConfig(config);
    }
    final week = WeeklyPlanner.build(
      config: config,
      library: ref.watch(exerciseLibraryProvider),
      profile: profile.profile!,
      injuries: profile.injuries,
      states: states,
      weekStart: DeloadPolicy.mondayOf(now),
      isDeload: DeloadPolicy.isActive(now, config.lastDeloadStart),
    );
    final done = await ref.watch(workoutRepositoryProvider).completedPlanDays(DeloadPolicy.weekKey(now));
    return PlannerState(config: config, week: week, completedDays: done, today: now);
  }

  /// Creates or changes the plan. Keeps the start date and deload history on edits.
  Future<void> configure({
    required int daysPerWeek,
    required int sessionMinutes,
    required Set<String> focusSkills,
    required int deloadEveryWeeks,
  }) async {
    final repo = ref.read(progressRepositoryProvider);
    final existing = await repo.planConfig();
    await repo.savePlanConfig(PlanConfig(
      daysPerWeek: daysPerWeek,
      sessionMinutes: sessionMinutes,
      focusSkills: focusSkills,
      deloadEveryWeeks: deloadEveryWeeks,
      startedAt: existing?.startedAt ?? ref.read(clockProvider)(),
      lastDeloadStart: existing?.lastDeloadStart,
    ));
    // Persist the placement so later profile edits do not silently move the user.
    final states = await ref.read(chainStatesProvider.future);
    final stored = await repo.chainStates();
    for (final s in states.values) {
      if (!stored.containsKey(s.chainId)) await repo.saveChainState(s, now: ref.read(clockProvider)());
    }
    ref.invalidateSelf();
    await future;
  }
}
