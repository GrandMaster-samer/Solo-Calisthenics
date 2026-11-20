import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart' hide Feedback;
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/feedback.dart';
import '../../../core/platform/volume_buttons.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/units.dart';
import '../../../core/widgets/labels.dart';
import '../../../l10n/app_l10n.dart';
import '../../exercises/domain/exercise.dart';
import '../../exercises/presentation/exercise_detail_screen.dart';
import '../../exercises/presentation/exercise_illustration.dart';
import '../../planner/domain/progression_engine.dart';
import '../../profile/application/profile_controller.dart';
import '../../settings/application/settings_controller.dart';
import '../../settings/data/settings_repository.dart';
import '../application/active_session_controller.dart';
import '../domain/templates.dart';
import '../domain/workout_models.dart';
import 'workout_preview_screen.dart' show WarmUpCard;

/// The workout in progress: count reps, log sets, rest, repeat.
class ActiveSessionScreen extends ConsumerStatefulWidget {
  const ActiveSessionScreen({super.key});

  @override
  ConsumerState<ActiveSessionScreen> createState() =>
      _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends ConsumerState<ActiveSessionScreen>
    with WidgetsBindingObserver {
  Timer? _ticker;
  StreamSubscription<String>? _volumeSub;
  bool _capturing = false;
  bool _warmUpHidden = false;

  // Read once: `ref` must not be used in dispose().
  late final VolumeButtons _volume = ref.read(volumeButtonsProvider);

  /// Start of the running hold stopwatch, or null when idle.
  DateTime? _holdStart;

  ActiveSessionController get _controller =>
      ref.read(activeSessionProvider.notifier);
  WorkoutSession? get _session => ref.read(activeSessionProvider).value;
  DateTime _now() => ref.read(clockProvider)();
  Feedback get _feedback {
    final s = ref.read(settingsProvider);
    return Feedback(haptics: s.haptics, sound: s.sound);
  }

  RestText get _restText {
    final l = AppL10n.of(context);
    return (title: l.restOverTitle, body: l.restOverBody);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setWakelock(true);
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) => _tick());
    if (_volume.isSupported) {
      _volumeSub = _volume.presses.listen(
        _onVolumePress,
        onError: (Object _) {},
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    _volumeSub?.cancel();
    _volume.setCapture(false);
    _setWakelock(false);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _tick();
  }

  /// Keeps the screen on during the workout. Best effort: ignored where unsupported.
  Future<void> _setWakelock(bool on) async {
    try {
      await (on ? WakelockPlus.enable() : WakelockPlus.disable());
    } on Object {
      // No wakelock on this platform (or in tests).
    }
  }

  void _tick() {
    if (!mounted) return;
    final s = _session;
    if (s == null) return;
    final resting = s.restEndsAt != null;
    if (resting && s.restRemaining(_now()) == 0) {
      _feedback.restOver();
      _controller.completeRest();
    }
    _syncVolumeCapture(s);
    if (resting || _holdStart != null) setState(() {});
  }

  /// Volume buttons count reps only while a rep-based set is on screen.
  void _syncVolumeCapture(WorkoutSession s) {
    final library = ref.read(exerciseLibraryProvider);
    final ex = s.current == null ? null : library.byId(s.current!.exerciseId);
    final want =
        ref.read(settingsProvider).volumeButtons &&
        s.restEndsAt == null &&
        !s.allComplete &&
        ex != null &&
        !ex.isHold;
    if (want != _capturing) {
      _capturing = want;
      _volume.setCapture(want);
    }
  }

  void _onVolumePress(String button) {
    final s = _session;
    if (s == null || !_capturing) return;
    if (button == 'up') {
      _count(1);
    } else if (s.pendingCount > 0) {
      _count(-1);
    }
  }

  void _count(int delta) {
    final s = _session;
    if (s == null) return;
    _feedback.count();
    _controller.setPendingCount(s.pendingCount + delta);
  }

  Future<void> _log(int value, LogMethod method) async {
    if (value <= 0) return;
    _feedback.setSaved();
    setState(() => _holdStart = null);
    await _controller.logSet(value, method, _restText);
  }

  Future<void> _manualEntry(bool isHold) async {
    final l = AppL10n.of(context);
    final controller = TextEditingController();
    final value = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isHold ? l.enterSeconds : l.enterReps),
        content: TextField(
          key: const Key('manual-field'),
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          style: numericStyle(40),
          textAlign: TextAlign.center,
          onSubmitted: (v) => Navigator.pop(context, int.tryParse(v)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          TextButton(
            key: const Key('manual-save'),
            onPressed: () =>
                Navigator.pop(context, int.tryParse(controller.text)),
            child: Text(l.save),
          ),
        ],
      ),
    );
    if (value != null && value > 0) await _log(value, LogMethod.manual);
  }

  void _toggleHold() {
    final start = _holdStart;
    if (start == null) {
      _feedback.count();
      setState(() => _holdStart = _now());
    } else {
      final seconds = _now().difference(start).inSeconds;
      if (seconds >= 1) {
        _log(seconds, LogMethod.timer);
      } else {
        setState(() => _holdStart = null);
      }
    }
  }

  Future<void> _finish(WorkoutSession s) async {
    final l = AppL10n.of(context);
    if (!s.allComplete && s.totalSets > 0) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l.finishEarlyTitle),
          content: Text(l.finishEarlyBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.keepGoing),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l.finish),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }
    if (!mounted) return;
    final lang = Localizations.localeOf(context).languageCode;
    final library = ref.read(exerciseLibraryProvider);
    final changes = await _controller.finish();
    if (!mounted) return;
    if (changes.isNotEmpty) {
      String name(String? id) => library.byId(id ?? '')?.name.of(lang) ?? '';
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l.progressUpdateTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final c in changes)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(switch (c.action) {
                    ProgressionAction.advance => l.changeUnlocked(
                      name(c.newExerciseId),
                    ),
                    ProgressionAction.increaseTarget => l.changeGoalUp(
                      name(c.exerciseId),
                    ),
                    ProgressionAction.decreaseTarget => l.changeGoalDown(
                      name(c.exerciseId),
                    ),
                    ProgressionAction.regress => l.changeRegressed(
                      name(c.newExerciseId),
                    ),
                    ProgressionAction.repeat => '',
                  }),
                ),
            ],
          ),
          actions: [
            TextButton(
              key: const Key('progress-ok'),
              onPressed: () => Navigator.pop(context),
              child: Text(l.ok),
            ),
          ],
        ),
      );
      if (!mounted) return;
    }
    Navigator.of(context).pop();
  }

  Future<void> _discard() async {
    final l = AppL10n.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.discardTitle),
        content: Text(l.discardBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l.discard,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await _controller.discard();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final session = ref.watch(activeSessionProvider).value;
    if (session == null || session.current == null) {
      return Scaffold(appBar: AppBar(), body: const SizedBox.shrink());
    }
    final resting = session.restEndsAt != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(session.name),
        actions: [
          TextButton(
            key: const Key('finish-workout'),
            onPressed: () => _finish(session),
            child: Text(l.finish),
          ),
          PopupMenuButton<String>(
            onSelected: (_) => _discard(),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'discard', child: Text(l.discard)),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: session.allComplete
            ? _completeView(l, session)
            : resting
            ? _restView(l, session)
            : _logView(l, session),
      ),
    );
  }

  // ---- Shared pieces -------------------------------------------------------

  /// The most recently logged set in the whole session and the exercise it belongs to.
  ({SessionExercise exercise, SetLog set})? _lastLogged(WorkoutSession s) {
    ({SessionExercise exercise, SetLog set})? last;
    for (final e in s.exercises) {
      for (final set in e.sets) {
        if (last == null || !set.loggedAt.isBefore(last.set.loggedAt)) {
          last = (exercise: e, set: set);
        }
      }
    }
    return last;
  }

  Widget _effortPicker(AppL10n l, SetLog set) {
    final mode = ref.watch(settingsProvider.select((s) => s.effortMode));
    final isRir = mode == EffortMode.rir;
    return Column(
      children: [
        Text(
          isRir ? l.rirQuestion : l.rpeQuestion,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          alignment: WrapAlignment.center,
          children: [
            if (isRir)
              for (final v in [0, 1, 2, 3, 4])
                _EffortChip(
                  key: Key('rir-$v'),
                  label: v == 4 ? '4+' : '$v',
                  selected: set.rir == v,
                  onTap: () => _controller.setEffort(set.id, rir: v),
                )
            else
              for (final v in [6, 7, 8, 9, 10])
                _EffortChip(
                  key: Key('rpe-$v'),
                  label: '$v',
                  selected: set.rpe == v,
                  onTap: () => _controller.setEffort(set.id, rpe: v.toDouble()),
                ),
          ],
        ),
      ],
    );
  }

  Widget _header(
    AppL10n l,
    WorkoutSession s,
    SessionExercise ex,
    Exercise? def,
  ) {
    final lang = Localizations.localeOf(context).languageCode;
    final setNumber = (ex.sets.length + 1).clamp(1, ex.targetSets);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
      child: Row(
        children: [
          IconButton(
            tooltip: l.previousExercise,
            onPressed: s.currentIndex > 0
                ? () => _controller.goTo(s.currentIndex - 1)
                : null,
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: def == null
                  ? null
                  : () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ExerciseDetailScreen(
                          exerciseId: def.id,
                          showStart: false,
                        ),
                      ),
                    ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    Text(
                      def?.name.of(lang) ?? ex.exerciseId,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${l.setOf(setNumber, ex.targetSets)}  ·  ${l.target(def?.isHold ?? false, ex.targetMin, ex.targetMax)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: l.nextExercise,
            onPressed: s.currentIndex < s.exercises.length - 1
                ? () => _controller.goTo(s.currentIndex + 1)
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _loggedSets(AppL10n l, WorkoutSession s, SessionExercise ex) {
    if (ex.sets.isEmpty) return const SizedBox(height: 8);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 6,
              children: [
                for (final set in ex.sets)
                  Chip(
                    visualDensity: VisualDensity.compact,
                    label: Text(
                      '${set.value}',
                      style: numericStyle(14, weight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            key: const Key('undo-set'),
            tooltip: l.undoLastSet,
            onPressed: () => _controller.undoLastSet(s.currentIndex),
            icon: const Icon(Icons.undo),
          ),
        ],
      ),
    );
  }

  // ---- Logging view --------------------------------------------------------

  Widget _logView(AppL10n l, WorkoutSession s) {
    final ex = s.current!;
    final library = ref.watch(exerciseLibraryProvider);
    final def = library.byId(ex.exerciseId);
    final isHold = def?.isHold ?? false;
    final injuries = ref.watch(profileProvider.select((p) => p.injuries));
    final warmUp = s.totalSets == 0 && !_warmUpHidden
        ? TemplateBuilder.warmUpJoints(
            [
              for (final e in s.exercises)
                PlannedExercise(
                  exerciseId: e.exerciseId,
                  sets: 0,
                  targetMin: 0,
                  targetMax: 0,
                  restSec: 0,
                ),
            ],
            injuries,
            library,
          )
        : const <Never>[];

    final holdElapsed = _holdStart == null
        ? 0
        : _now().difference(_holdStart!).inSeconds;
    // What the quick "Done" button will save.
    final doneValue = isHold
        ? ex.targetMin
        : (s.pendingCount > 0
              ? s.pendingCount
              : (ex.sets.isNotEmpty ? ex.sets.last.value : ex.targetMin));

    return Column(
      children: [
        _header(l, s, ex, def),
        _loggedSets(l, s, ex),
        if (warmUp.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Stack(
              children: [
                WarmUpCard(joints: warmUp),
                PositionedDirectional(
                  top: 0,
                  end: 0,
                  child: IconButton(
                    tooltip: l.dismiss,
                    onPressed: () => setState(() => _warmUpHidden = true),
                    icon: const Icon(Icons.close, size: 20),
                  ),
                ),
              ],
            ),
          ),
        // Full-width tap zone: easy to hit with sweaty hands or a knuckle.
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                key: const Key('tap-zone'),
                onTap: isHold ? _toggleHold : () => _count(1),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isHold
                              ? Units.formatClock(holdElapsed)
                              : '${s.pendingCount}',
                          key: const Key('counter'),
                          style: numericStyle(
                            isHold ? 88 : 132,
                            color:
                                (isHold
                                    ? _holdStart != null
                                    : s.pendingCount > 0)
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isHold
                              ? (_holdStart == null
                                    ? l.tapToStartHold
                                    : l.tapToStopHold)
                              : (_capturing
                                    ? l.tapOrVolumeToCount
                                    : l.tapToCount),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              if (!isHold) ...[
                _SquareButton(
                  key: const Key('minus-one'),
                  tooltip: l.minusOne,
                  icon: Icons.remove,
                  onPressed: s.pendingCount > 0 ? () => _count(-1) : null,
                ),
                const SizedBox(width: 10),
              ],
              _SquareButton(
                key: const Key('manual-entry'),
                tooltip: isHold ? l.enterSeconds : l.enterReps,
                icon: Icons.dialpad,
                onPressed: () => _manualEntry(isHold),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 64,
                  child: FilledButton(
                    key: const Key('done-set'),
                    onPressed: _holdStart != null
                        ? null
                        : () => _log(
                            doneValue,
                            s.pendingCount > 0 && !isHold
                                ? LogMethod.tap
                                : LogMethod.done,
                          ),
                    child: FittedBox(
                      child: Text(
                        isHold
                            ? l.doneSeconds(doneValue)
                            : l.doneReps(doneValue),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---- Rest view -----------------------------------------------------------

  Widget _restView(AppL10n l, WorkoutSession s) {
    final lang = Localizations.localeOf(context).languageCode;
    final library = ref.watch(exerciseLibraryProvider);
    final remaining = s.restRemaining(_now());
    final total = s.restTotalSec ?? 0;
    final last = _lastLogged(s);
    final next = s.current!;
    final nextDef = library.byId(next.exerciseId);

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      l.rest,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(color: AppColors.secondary),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 196,
                      height: 196,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: total == 0
                                ? 0
                                : (remaining / total).clamp(0, 1).toDouble(),
                            strokeWidth: 10,
                            color: AppColors.secondary,
                            backgroundColor: AppColors.surfaceElevated,
                          ),
                          Center(
                            child: Text(
                              Units.formatClock(remaining),
                              key: const Key('rest-clock'),
                              style: numericStyle(60),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          key: const Key('rest-minus'),
                          onPressed: () => _controller.adjustRest(
                            -15,
                            _restText,
                            sessionExerciseId: last?.exercise.id,
                          ),
                          child: Text(l.minusSeconds(15)),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          key: const Key('rest-plus'),
                          onPressed: () => _controller.adjustRest(
                            15,
                            _restText,
                            sessionExerciseId: last?.exercise.id,
                          ),
                          child: Text(l.plusSeconds(15)),
                        ),
                      ],
                    ),
                  ],
                ),
                if (last != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: _effortPicker(l, last.set),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        if (nextDef != null) ...[
                          Container(
                            width: 92,
                            height: 62,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ExerciseIllustration(
                              key: const Key('next-illustration'),
                              exerciseId: nextDef.id,
                              color: AppColors.textPrimary,
                              semanticLabel: illustrationLabel(
                                context,
                                nextDef.name.of(lang),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: Text(
                            l.nextUp(
                              nextDef?.name.of(lang) ?? next.exerciseId,
                              l.setOf(
                                (next.sets.length + 1).clamp(
                                  1,
                                  next.targetSets,
                                ),
                                next.targetSets,
                              ),
                            ),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 64,
                      child: FilledButton(
                        key: const Key('skip-rest'),
                        onPressed: _controller.skipRest,
                        child: Text(l.skipRest),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---- Complete view -------------------------------------------------------

  Widget _completeView(AppL10n l, WorkoutSession s) {
    final last = _lastLogged(s);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.emoji_events_outlined,
            size: 72,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          Text(
            l.workoutComplete,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            l.setsLogged(s.totalSets),
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          if (last != null) ...[
            const SizedBox(height: 28),
            _effortPicker(l, last.set),
          ],
          const SizedBox(height: 28),
          SizedBox(
            height: 64,
            child: FilledButton(
              key: const Key('complete-finish'),
              onPressed: () => _finish(s),
              child: Text(l.finishWorkout),
            ),
          ),
          TextButton(
            onPressed: () =>
                _controller.undoLastSet(s.exercises.indexOf(last!.exercise)),
            child: Text(l.undoLastSet),
          ),
        ],
      ),
    );
  }
}

class _EffortChip extends StatelessWidget {
  const _EffortChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Material(
        color: selected ? AppColors.primary : AppColors.surfaceElevated,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              textDirection:
                  TextDirection.ltr, // keeps "4+" from flipping in Arabic
              style: numericStyle(
                18,
                color: selected ? AppColors.background : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });
  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: IconButton.filledTonal(
        tooltip: tooltip,
        style: IconButton.styleFrom(
          backgroundColor: AppColors.surfaceElevated,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 28),
      ),
    );
  }
}
