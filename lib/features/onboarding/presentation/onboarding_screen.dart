import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/app_info.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/units.dart';
import '../../../core/widgets/labels.dart';
import '../../../l10n/app_l10n.dart';
import '../../profile/application/profile_controller.dart';
import '../../profile/domain/profile.dart';
import '../../settings/application/settings_controller.dart';

enum _Step { welcome, stats, experience, baseline, joints }

/// First-run profiling. Also reused from Settings (with [editing]) to change the profile.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key, this.editing = false});
  final bool editing;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _statsForm = GlobalKey<FormState>();
  final _baselineForm = GlobalKey<FormState>();
  late final List<_Step> _steps = widget.editing
      ? _Step.values.sublist(1)
      : _Step.values;
  int _index = 0;
  bool _accepted = false;
  bool _saving = false;

  final _birthYear = TextEditingController();
  final _height = TextEditingController();
  final _feet = TextEditingController();
  final _inches = TextEditingController();
  final _weight = TextEditingController();
  final _pushUps = TextEditingController();
  final _pullUps = TextEditingController();
  final _deadHang = TextEditingController();
  final _plank = TextEditingController();
  late WeightUnit _weightUnit;
  late HeightUnit _heightUnit;
  Experience? _experience;
  final Map<Joint, Severity> _severity = {};
  final Map<Joint, bool> _isCurrent = {};

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    _weightUnit = settings.weightUnit;
    _heightUnit = settings.heightUnit;
    final state = ref.read(profileProvider);
    final p = state.profile;
    if (p != null) {
      _birthYear.text = '${p.birthYear}';
      _setHeightFields(p.heightCm);
      _setWeightField(p.weightKg);
      _experience = p.experience;
      _pushUps.text = p.maxPushUps?.toString() ?? '';
      _pullUps.text = p.maxPullUps?.toString() ?? '';
      _deadHang.text = p.maxDeadHangSec?.toString() ?? '';
      _plank.text = p.maxPlankSec?.toString() ?? '';
      for (final i in state.injuries) {
        _severity[i.joint] = i.severity;
        _isCurrent[i.joint] = i.isCurrent;
      }
    }
  }

  @override
  void dispose() {
    for (final c in [
      _birthYear,
      _height,
      _feet,
      _inches,
      _weight,
      _pushUps,
      _pullUps,
      _deadHang,
      _plank,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _setHeightFields(double cm) {
    _height.text = '${cm.round()}';
    final fi = Units.cmToFeetInches(cm);
    _feet.text = '${fi.feet}';
    _inches.text = '${fi.inches}';
  }

  void _setWeightField(double kg) {
    final v = _weightUnit == WeightUnit.kg ? kg : Units.kgToLb(kg);
    _weight.text = v.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
  }

  double? _parse(String s) => double.tryParse(s.trim().replaceAll(',', '.'));

  double? get _heightCm {
    if (_heightUnit == HeightUnit.cm) return _parse(_height.text);
    final ft = int.tryParse(_feet.text.trim());
    final inch = _parse(_inches.text.isEmpty ? '0' : _inches.text);
    return ft == null || inch == null ? null : Units.feetInchesToCm(ft, inch);
  }

  double? get _weightKg {
    final v = _parse(_weight.text);
    return v == null
        ? null
        : (_weightUnit == WeightUnit.kg ? v : Units.lbToKg(v));
  }

  void _switchHeightUnit(HeightUnit unit) {
    final cm = _heightCm;
    setState(() => _heightUnit = unit);
    if (cm != null) _setHeightFields(cm);
  }

  void _switchWeightUnit(WeightUnit unit) {
    final kg = _weightKg;
    setState(() => _weightUnit = unit);
    if (kg != null) _setWeightField(kg);
  }

  _Step get _step => _steps[_index];

  bool get _canContinue => switch (_step) {
    _Step.welcome => _accepted,
    _Step.experience => _experience != null,
    _ => true,
  };

  Future<void> _next() async {
    FocusScope.of(context).unfocus();
    if (_step == _Step.stats && !_statsForm.currentState!.validate()) return;
    if (_step == _Step.baseline && !_baselineForm.currentState!.validate()) {
      return;
    }
    if (_index < _steps.length - 1) {
      setState(() => _index++);
    } else {
      await _finish();
    }
  }

  Future<void> _finish() async {
    setState(() => _saving = true);
    final profile = UserProfile(
      birthYear: int.parse(_birthYear.text.trim()),
      heightCm: _heightCm!,
      weightKg: _weightKg!,
      experience: _experience!,
      maxPushUps: int.tryParse(_pushUps.text.trim()),
      maxPullUps: int.tryParse(_pullUps.text.trim()),
      maxDeadHangSec: int.tryParse(_deadHang.text.trim()),
      maxPlankSec: int.tryParse(_plank.text.trim()),
    );
    final injuries = [
      for (final j in Joint.values)
        if (_severity[j] != null)
          Injury(
            joint: j,
            severity: _severity[j]!,
            isCurrent: _isCurrent[j] ?? true,
          ),
    ];
    await ref
        .read(settingsProvider.notifier)
        .change(
          (s) => s.copyWith(weightUnit: _weightUnit, heightUnit: _heightUnit),
        );
    await ref.read(profileProvider.notifier).save(profile, injuries);
    if (mounted && widget.editing) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final isLast = _index == _steps.length - 1;
    return Scaffold(
      appBar: AppBar(
        leading: _index > 0
            ? BackButton(onPressed: () => setState(() => _index--))
            : (widget.editing ? const CloseButton() : null),
        title: Text(widget.editing ? l.editProfile : l.appName),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: (_index + 1) / _steps.length),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: switch (_step) {
                  _Step.welcome => _welcome(l),
                  _Step.stats => _stats(l),
                  _Step.experience => _experienceStep(l),
                  _Step.baseline => _baseline(l),
                  _Step.joints => _joints(l),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  if (_step == _Step.baseline)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 12),
                      child: TextButton(
                        onPressed: () {
                          for (final c in [
                            _pushUps,
                            _pullUps,
                            _deadHang,
                            _plank,
                          ]) {
                            c.clear();
                          }
                          setState(() => _index++);
                        },
                        child: Text(l.skip),
                      ),
                    ),
                  Expanded(
                    child: FilledButton(
                      key: const Key('onboarding-next'),
                      onPressed: _canContinue && !_saving ? _next : null,
                      child: Text(
                        isLast
                            ? (widget.editing ? l.save : l.finishSetup)
                            : l.continueLabel,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title(String title, String subtitle) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall
            ?.copyWith(fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 8),
      Text(subtitle, style: const TextStyle(color: AppColors.textSecondary)),
      const SizedBox(height: 24),
    ],
  );

  Widget _welcome(AppL10n l) {
    final localeCode = Localizations.localeOf(context).languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Image.asset(
              AppInfo.logoFull,
              key: const Key('welcome-logo'),
              height: 116,
              semanticLabel: l.appName,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        ),
        _title(l.welcomeTitle, l.welcomeBody),
        Text(l.language, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'en', label: Text('English')),
            ButtonSegment(value: 'ar', label: Text('العربية')),
          ],
          selected: {localeCode},
          onSelectionChanged: (s) => ref
              .read(settingsProvider.notifier)
              .change((c) => c.copyWith(localeCode: () => s.first)),
        ),
        const SizedBox(height: 24),
        _DisclaimerCard(text: l.disclaimerBody, title: l.disclaimerTitle),
        const SizedBox(height: 8),
        CheckboxListTile(
          key: const Key('accept-disclaimer'),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          value: _accepted,
          onChanged: (v) => setState(() => _accepted = v ?? false),
          title: Text(l.disclaimerAccept),
        ),
      ],
    );
  }

  String? _range(AppL10n l, double? v, double min, double max) =>
      v == null || v < min || v > max ? l.invalidValue : null;

  Widget _stats(AppL10n l) {
    final thisYear = ref.read(clockProvider)().year;
    final digits = [FilteringTextInputFormatter.digitsOnly];
    final decimal = [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))];
    return Form(
      key: _statsForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(l.statsTitle, l.statsBody),
          TextFormField(
            key: const Key('birth-year'),
            controller: _birthYear,
            keyboardType: TextInputType.number,
            inputFormatters: digits,
            decoration: InputDecoration(labelText: l.birthYear),
            validator: (v) =>
                _range(l, _parse(v ?? ''), 1900, thisYear.toDouble()),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                Text(l.height, style: Theme.of(context).textTheme.titleSmall),
                SegmentedButton<HeightUnit>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(value: HeightUnit.cm, label: Text(l.unitCm)),
                    ButtonSegment(
                      value: HeightUnit.ftIn,
                      label: Text(l.unitFtIn),
                    ),
                  ],
                  selected: {_heightUnit},
                  onSelectionChanged: (s) => _switchHeightUnit(s.first),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (_heightUnit == HeightUnit.cm)
            TextFormField(
              key: const Key('height-cm'),
              controller: _height,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: decimal,
              decoration: InputDecoration(
                labelText: l.height,
                suffixText: l.unitCm,
              ),
              validator: (_) => _range(l, _heightCm, 50, 272),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _feet,
                    keyboardType: TextInputType.number,
                    inputFormatters: digits,
                    decoration: InputDecoration(labelText: l.feet),
                    validator: (_) => _range(l, _heightCm, 50, 272),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _inches,
                    keyboardType: TextInputType.number,
                    inputFormatters: digits,
                    decoration: InputDecoration(labelText: l.inches),
                    validator: (v) =>
                        _range(l, _parse((v ?? '').isEmpty ? '0' : v!), 0, 11),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                Text(l.weight, style: Theme.of(context).textTheme.titleSmall),
                SegmentedButton<WeightUnit>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(value: WeightUnit.kg, label: Text(l.unitKg)),
                    ButtonSegment(value: WeightUnit.lb, label: Text(l.unitLb)),
                  ],
                  selected: {_weightUnit},
                  onSelectionChanged: (s) => _switchWeightUnit(s.first),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            key: const Key('weight'),
            controller: _weight,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: decimal,
            decoration: InputDecoration(
              labelText: l.weight,
              suffixText: _weightUnit == WeightUnit.kg ? l.unitKg : l.unitLb,
            ),
            validator: (_) => _range(l, _weightKg, 20, 400),
          ),
        ],
      ),
    );
  }

  Widget _experienceStep(AppL10n l) {
    String describe(Experience e) => switch (e) {
      Experience.beginner => l.expBeginnerDesc,
      Experience.intermediate => l.expIntermediateDesc,
      Experience.advanced => l.expAdvancedDesc,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(l.experienceTitle, l.experienceBody),
        for (final e in Experience.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: _experience == e
                      ? AppColors.primary
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                key: Key('experience-${e.name}'),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                selected: _experience == e,
                title: Text(
                  l.experience(e),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(describe(e)),
                trailing: _experience == e
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                onTap: () => setState(() => _experience = e),
              ),
            ),
          ),
      ],
    );
  }

  Widget _baseline(AppL10n l) {
    Widget field(
      TextEditingController c,
      String label,
      String suffix,
      int max,
    ) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(labelText: label, suffixText: suffix),
        validator: (v) => (v == null || v.trim().isEmpty)
            ? null
            : _range(l, _parse(v), 0, max.toDouble()),
      ),
    );
    return Form(
      key: _baselineForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(l.baselineTitle, l.baselineBody),
          field(_pushUps, l.maxPushUps, l.repsUnit, 500),
          field(_pullUps, l.maxPullUps, l.repsUnit, 200),
          field(_deadHang, l.maxDeadHang, l.secondsUnit, 1800),
          field(_plank, l.maxPlank, l.secondsUnit, 3600),
        ],
      ),
    );
  }

  Widget _joints(AppL10n l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(l.jointsTitle, l.jointsBody),
        for (final j in Joint.values)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.joint(j),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      ChoiceChip(
                        key: Key('joint-${j.name}-none'),
                        label: Text(l.noIssue),
                        selected: _severity[j] == null,
                        onSelected: (_) => setState(() => _severity.remove(j)),
                      ),
                      for (final s in Severity.values)
                        ChoiceChip(
                          key: Key('joint-${j.name}-${s.name}'),
                          label: Text(l.severity(s)),
                          selected: _severity[j] == s,
                          selectedColor: switch (s) {
                            Severity.mild => AppColors.secondary,
                            Severity.moderate => AppColors.warning,
                            Severity.severe => AppColors.error,
                          },
                          onSelected: (_) => setState(() => _severity[j] = s),
                        ),
                    ],
                  ),
                  if (_severity[j] != null)
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l.injuryCurrent),
                      subtitle: Text(l.injuryCurrentHint),
                      value: _isCurrent[j] ?? true,
                      onChanged: (v) => setState(() => _isCurrent[j] = v),
                    ),
                ],
              ),
            ),
          ),
        Text(
          l.jointsRules,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 12),
        _DisclaimerCard(text: l.disclaimerBody, title: l.disclaimerTitle),
      ],
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard({required this.title, required this.text});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warning),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.health_and_safety_outlined,
            color: AppColors.warning,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
