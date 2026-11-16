import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_l10n.dart';
import '../../profile/application/profile_controller.dart';
import '../../profile/domain/profile.dart';
import '../application/planner_controller.dart';
import '../domain/weekly_planner.dart';

/// Create or change the weekly plan: training days, session length, skills, deload rhythm.
class PlanSetupScreen extends ConsumerStatefulWidget {
  const PlanSetupScreen({super.key});

  @override
  ConsumerState<PlanSetupScreen> createState() => _PlanSetupScreenState();
}

class _PlanSetupScreenState extends ConsumerState<PlanSetupScreen> {
  late int _days;
  late int _minutes;
  late Set<String> _skills;
  late int _deloadEvery;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final existing = ref.read(plannerProvider).value?.config;
    final experience = ref.read(profileProvider).profile?.experience ?? Experience.beginner;
    _days = existing?.daysPerWeek ?? 3;
    _minutes = existing?.sessionMinutes ?? 45;
    _deloadEvery = existing?.deloadEveryWeeks ?? 5;
    _skills = {
      ...?existing?.focusSkills,
      if (existing == null)
        ...switch (experience) {
          Experience.beginner => const <String>[],
          Experience.intermediate => const ['handstand', 'l_sit'],
          Experience.advanced => const ['handstand', 'muscle_up', 'front_lever'],
        },
    };
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref.read(plannerProvider.notifier).configure(
          daysPerWeek: _days,
          sessionMinutes: _minutes,
          focusSkills: _skills,
          deloadEveryWeeks: _deloadEvery,
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final library = ref.watch(exerciseLibraryProvider);
    Widget title(String t, [String? hint]) => Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              if (hint != null) Text(hint, style: const TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        );
    Widget chip<T>(T value, String label, bool selected, VoidCallback onTap, String keyPrefix) => ChoiceChip(
          key: Key('$keyPrefix-$value'),
          showCheckmark: false,
          label: Text(label),
          labelStyle: TextStyle(
            color: selected ? AppColors.background : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          selected: selected,
          onSelected: (_) => onTap(),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l.planSetupTitle)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton(
            key: const Key('save-plan'),
            onPressed: _saving ? null : _save,
            child: Text(l.planSave),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          title(l.planDaysPerWeek),
          Wrap(
            spacing: 8,
            children: [
              for (var d = PlanConfig.minDays; d <= PlanConfig.maxDays; d++)
                chip(d, '$d', _days == d, () => setState(() => _days = d), 'plan-days'),
            ],
          ),
          title(l.planSessionLength),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final m in PlanConfig.sessionLengths)
                chip(m, l.minutesShort(m), _minutes == m, () => setState(() => _minutes = m), 'plan-minutes'),
            ],
          ),
          title(l.planSkills, l.planSkillsHint),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final id in PlanConfig.skillChoices)
                chip(
                  id,
                  library.chains.where((c) => c.id == id).firstOrNull?.name.of(lang) ?? id,
                  _skills.contains(id),
                  () => setState(() => _skills.contains(id) ? _skills.remove(id) : _skills.add(id)),
                  'plan-skill',
                ),
            ],
          ),
          title(l.planDeload, l.planDeloadHint),
          Wrap(
            spacing: 8,
            children: [
              for (final w in const [4, 5, 6])
                chip(w, l.everyWeeks(w), _deloadEvery == w, () => setState(() => _deloadEvery = w), 'plan-deload'),
            ],
          ),
        ],
      ),
    );
  }
}
