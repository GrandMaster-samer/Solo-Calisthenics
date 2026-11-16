import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/units.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_l10n.dart';
import '../../planner/application/planner_controller.dart';
import '../../workout/application/active_session_controller.dart';
import '../data/analytics_repository.dart';
import 'vault_screen.dart';

final analyticsProvider = FutureProvider<AnalyticsData>((ref) {
  ref.watch(activeSessionProvider); // refresh after each workout
  return ref.watch(analyticsRepositoryProvider).load(now: ref.watch(clockProvider)());
});

/// Dashboard: consistency, strength gains and skill unlocks, plus the photo vault entry.
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final library = ref.watch(exerciseLibraryProvider);
    final data = ref.watch(analyticsProvider).value;
    final milestones = ref.watch(milestonesProvider).value ?? const [];
    final text = Theme.of(context).textTheme;
    final dates = MaterialLocalizations.of(context);

    Widget section(String title, [String? hint]) => Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              if (hint != null) Text(hint, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l.tabProgress)),
      body: data == null
          ? const SizedBox.shrink()
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Row(
                  children: [
                    Expanded(child: _StatTile(value: '${data.totalWorkouts}', label: l.statWorkouts)),
                    const SizedBox(width: 10),
                    Expanded(child: _StatTile(value: '${data.weekStreak}', label: l.statWeekStreak)),
                    const SizedBox(width: 10),
                    Expanded(child: _StatTile(value: '${milestones.length}', label: l.statUnlocks)),
                  ],
                ),
                section(l.chartWorkoutsTitle, l.chartLast8Weeks),
                _WeekBars(
                  key: const Key('chart-workouts'),
                  weeks: data.weeks,
                  value: (w) => w.workouts,
                  semanticUnit: l.statWorkouts,
                ),
                section(l.chartSetsTitle, l.chartLast8Weeks),
                _WeekBars(
                  key: const Key('chart-sets'),
                  weeks: data.weeks,
                  value: (w) => w.sets,
                  semanticUnit: l.chartSetsTitle,
                ),
                section(l.strengthTitle, l.strengthHint),
                if (data.trends.isEmpty)
                  Text(l.strengthEmpty, style: const TextStyle(color: AppColors.textSecondary))
                else
                  Card(
                    child: Column(
                      children: [
                        for (final t in data.trends.take(8))
                          Builder(builder: (context) {
                            final e = library.byId(t.exerciseId);
                            final unit = (e?.isHold ?? false) ? l.secondsUnit : l.repsUnit;
                            final up = t.change > 0;
                            return ListTile(
                              title: Text(e?.name.of(lang) ?? t.exerciseId),
                              subtitle: Text(
                                '${l.bestSetFromTo(t.firstBest, t.latestBest, unit)}'
                                '${l.listSeparator}${l.sessionsCount(t.sessions)}',
                              ),
                              // Direction is carried by the icon and the signed number, not by color alone.
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    up
                                        ? Icons.arrow_upward
                                        : (t.change < 0 ? Icons.arrow_downward : Icons.remove),
                                    size: 18,
                                    color: up
                                        ? AppColors.success
                                        : (t.change < 0 ? AppColors.warning : AppColors.textSecondary),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${t.change > 0 ? '+' : ''}${t.change}',
                                    textDirection: TextDirection.ltr,
                                    style: numericStyle(16, weight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                section(l.milestonesTitle),
                if (milestones.isEmpty)
                  Text(l.milestonesEmpty, style: const TextStyle(color: AppColors.textSecondary))
                else
                  Card(
                    child: Column(
                      children: [
                        for (final m in milestones.take(10))
                          ListTile(
                            leading: const Icon(Icons.lock_open, color: AppColors.primary),
                            title: Text(library.byId(m.exerciseId)?.name.of(lang) ?? m.exerciseId),
                            subtitle: Text(l.unlockedOn(westernDigits(dates.formatMediumDate(m.achievedAt)))),
                          ),
                      ],
                    ),
                  ),
                section(l.vaultTitle),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    key: const Key('open-vault'),
                    leading: const Icon(Icons.photo_library_outlined, color: AppColors.secondary),
                    title: Text(l.vaultOpen),
                    subtitle: Text(l.vaultHint),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute<void>(builder: (_) => const VaultScreen())),
                  ),
                ),
              ],
            ),
    );
  }
}

/// A headline number with its label. Not a chart: one value needs no axes.
class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        child: Column(
          children: [
            Text(value, style: numericStyle(30)),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

/// One measure per week as bars. Single series, so one hue and no legend; the
/// section title names it. Each bar is labeled with its value, and tapping a bar
/// shows the week it belongs to.
class _WeekBars extends StatefulWidget {
  const _WeekBars({super.key, required this.weeks, required this.value, required this.semanticUnit});
  final List<WeekStat> weeks;
  final int Function(WeekStat) value;
  final String semanticUnit;

  @override
  State<_WeekBars> createState() => _WeekBarsState();
}

class _WeekBarsState extends State<_WeekBars> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final dates = MaterialLocalizations.of(context);
    final values = [for (final w in widget.weeks) widget.value(w)];
    final maxValue = math.max(1, values.fold<int>(0, math.max));
    final selected = _selected;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 140,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < values.length; i++)
                    Expanded(
                      // The hit target is the full column, larger than the bar itself.
                      child: Semantics(
                        label: '${l.weekOf(westernDigits(dates.formatShortMonthDay(widget.weeks[i].weekStart)))}: '
                            '${values[i]} ${widget.semanticUnit}',
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => setState(() => _selected = _selected == i ? null : i),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (values[i] > 0)
                                  Text(
                                    '${values[i]}',
                                    style: numericStyle(
                                      12,
                                      weight: FontWeight.w600,
                                      color: selected == i ? AppColors.textPrimary : AppColors.textSecondary,
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Container(
                                  height: values[i] == 0 ? 2 : 104 * values[i] / maxValue,
                                  decoration: BoxDecoration(
                                    color: values[i] == 0
                                        ? AppColors.surfaceElevated
                                        : (selected == null || selected == i
                                            ? AppColors.primary
                                            : AppColors.primary.withValues(alpha: 0.45)),
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(height: 1, color: const Color(0xFF2A2F37)),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  westernDigits(dates.formatShortMonthDay(widget.weeks.first.weekStart)),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                Expanded(
                  child: Text(
                    selected == null
                        ? ''
                        : '${l.weekOf(westernDigits(dates.formatShortMonthDay(widget.weeks[selected].weekStart)))}: ${values[selected]}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Text(l.thisWeek, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
