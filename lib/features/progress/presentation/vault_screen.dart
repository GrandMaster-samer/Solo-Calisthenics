import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/units.dart';
import '../../../l10n/app_l10n.dart';
import '../../profile/application/profile_controller.dart';
import '../../security/data/app_lock.dart';
import '../../security/presentation/lock_gate.dart';
import '../../settings/application/settings_controller.dart';
import '../data/analytics_repository.dart';

final photosProvider = FutureProvider<List<PhotoInfo>>((ref) => ref.watch(analyticsRepositoryProvider).photos());
final photoBytesProvider =
    FutureProvider.family<Uint8List?, int>((ref, id) => ref.watch(analyticsRepositoryProvider).photoBytes(id));

/// Private progress photos. They are stored inside the encrypted database, never in
/// the phone gallery, and the screen sits behind the PIN when one is set.
class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  @override
  void initState() {
    super.initState();
    setSecureWindow(true); // no screenshots / recent-apps preview of the photos
  }

  @override
  void dispose() {
    setSecureWindow(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const LockGate(child: _VaultBody());
}

class _VaultBody extends ConsumerStatefulWidget {
  const _VaultBody();

  @override
  ConsumerState<_VaultBody> createState() => _VaultBodyState();
}

class _VaultBodyState extends ConsumerState<_VaultBody> {
  /// Photo ids picked for comparison, in tap order (at most two).
  final _selected = <int>[];

  Future<void> _add({required bool camera}) async {
    final l = AppL10n.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final Uint8List? bytes;
    try {
      bytes = await ref.read(photoPickerProvider)(camera: camera);
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(l.photoFailed)));
      return;
    }
    if (bytes == null || !mounted) return;
    final settings = ref.read(settingsProvider);
    final currentKg = ref.read(profileProvider).profile?.weightKg;
    final controller = TextEditingController(
      text: currentKg == null
          ? ''
          : (settings.weightUnit == WeightUnit.kg ? currentKg : Units.kgToLb(currentKg)).toStringAsFixed(1),
    );
    final save = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.photoWeightTitle),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
          decoration: InputDecoration(
            labelText: l.weight,
            helperText: l.optional,
            suffixText: settings.weightUnit == WeightUnit.kg ? l.unitKg : l.unitLb,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.cancel)),
          TextButton(
            key: const Key('photo-save'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.save),
          ),
        ],
      ),
    );
    if (save != true) return;
    final entered = double.tryParse(controller.text.trim().replaceAll(',', '.'));
    await ref.read(analyticsRepositoryProvider).addPhoto(
          bytes,
          takenAt: ref.read(clockProvider)(),
          weightKg: entered == null || entered <= 0
              ? null
              : (settings.weightUnit == WeightUnit.kg ? entered : Units.lbToKg(entered)),
        );
    ref.invalidate(photosProvider);
  }

  void _toggle(int id) => setState(() {
        if (!_selected.remove(id)) {
          if (_selected.length == 2) _selected.removeAt(0);
          _selected.add(id);
        }
      });

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final photos = ref.watch(photosProvider).value ?? const [];
    final hasPin = ref.watch(hasPinProvider).value ?? true;
    final dates = MaterialLocalizations.of(context);
    final byId = {for (final p in photos) p.id: p};
    _selected.removeWhere((id) => !byId.containsKey(id));

    return Scaffold(
      appBar: AppBar(
        title: Text(l.vaultTitle),
        actions: [
          IconButton(
            key: const Key('vault-add-gallery'),
            tooltip: l.photoFromGallery,
            onPressed: () => _add(camera: false),
            icon: const Icon(Icons.add_photo_alternate_outlined),
          ),
          IconButton(
            key: const Key('vault-add-camera'),
            tooltip: l.photoFromCamera,
            onPressed: () => _add(camera: true),
            icon: const Icon(Icons.photo_camera_outlined),
          ),
        ],
      ),
      bottomNavigationBar: _selected.length == 2
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: FilledButton.icon(
                  key: const Key('vault-compare'),
                  onPressed: () {
                    // Always show the older photo first.
                    final pair = [byId[_selected[0]]!, byId[_selected[1]]!]
                      ..sort((a, b) => a.takenAt.compareTo(b.takenAt));
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => CompareScreen(before: pair[0], after: pair[1])),
                    );
                  },
                  icon: const Icon(Icons.compare),
                  label: Text(l.compare),
                ),
              ),
            )
          : null,
      body: Column(
        children: [
          if (!hasPin)
            MaterialBanner(
              content: Text(l.vaultNoPin),
              leading: const Icon(Icons.lock_open, color: AppColors.warning),
              actions: [
                TextButton(
                  key: const Key('vault-set-pin'),
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute<bool>(builder: (_) => const PinSetupScreen())),
                  child: Text(l.setPin),
                ),
              ],
            ),
          Expanded(
            child: photos.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        l.vaultEmpty,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: photos.length,
                    itemBuilder: (context, i) {
                      final p = photos[i];
                      final order = _selected.indexOf(p.id);
                      return _PhotoTile(
                        key: Key('photo-${p.id}'),
                        photo: p,
                        caption: westernDigits(dates.formatMediumDate(p.takenAt)),
                        selectedOrder: order < 0 ? null : order + 1,
                        onTap: () => _toggle(p.id),
                        onDelete: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(l.photoDeleteTitle),
                              content: Text(l.photoDeleteBody),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.cancel)),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(l.delete, style: const TextStyle(color: AppColors.error)),
                                ),
                              ],
                            ),
                          );
                          if (ok != true) return;
                          await ref.read(analyticsRepositoryProvider).deletePhoto(p.id);
                          ref.invalidate(photosProvider);
                        },
                      );
                    },
                  ),
          ),
          if (photos.length >= 2 && _selected.length < 2)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(l.compareHint, style: const TextStyle(color: AppColors.textSecondary)),
            ),
        ],
      ),
    );
  }
}

class _PhotoImage extends ConsumerWidget {
  const _PhotoImage({required this.id, this.fit = BoxFit.cover, this.cacheWidth});
  final int id;
  final BoxFit fit;
  final int? cacheWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bytes = ref.watch(photoBytesProvider(id)).value;
    if (bytes == null) return const ColoredBox(color: AppColors.surfaceElevated);
    return Image.memory(
      bytes,
      fit: fit,
      cacheWidth: cacheWidth,
      gaplessPlayback: true,
      errorBuilder: (_, _, _) => const ColoredBox(
        color: AppColors.surfaceElevated,
        child: Center(child: Icon(Icons.broken_image_outlined, color: AppColors.textSecondary)),
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    super.key,
    required this.photo,
    required this.caption,
    required this.selectedOrder,
    required this.onTap,
    required this.onDelete,
  });
  final PhotoInfo photo;
  final String caption;
  final int? selectedOrder;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: selectedOrder != null ? AppColors.primary : Colors.transparent, width: 3),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _PhotoImage(id: photo.id, cacheWidth: 500),
                  if (selectedOrder != null)
                    PositionedDirectional(
                      top: 8,
                      start: 8,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.background,
                        child: Text('$selectedOrder', style: const TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 10),
              child: Row(
                children: [
                  Expanded(child: Text(caption, style: const TextStyle(fontSize: 13))),
                  IconButton(
                    tooltip: l.delete,
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline, size: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Two photos side by side, older first, with the time and weight between them.
class CompareScreen extends ConsumerWidget {
  const CompareScreen({super.key, required this.before, required this.after});
  final PhotoInfo before;
  final PhotoInfo after;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final unit = ref.watch(settingsProvider.select((s) => s.weightUnit));
    final dates = MaterialLocalizations.of(context);
    final days = after.takenAt.difference(before.takenAt).inDays;
    final a = before.weightKg, b = after.weightKg;
    String signedWeight(double kg) {
      final v = unit == WeightUnit.kg ? kg : Units.kgToLb(kg);
      return '‎${v >= 0 ? '+' : '−'}${v.abs().toStringAsFixed(1)} ${unit == WeightUnit.kg ? l.unitKg : l.unitLb}';
    }

    Widget side(PhotoInfo p, String label) => Expanded(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: InteractiveViewer(child: _PhotoImage(id: p.id, fit: BoxFit.contain)),
                  ),
                ),
              ),
              Text(label, style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w700)),
              Text(westernDigits(dates.formatMediumDate(p.takenAt))),
              Text(
                p.weightKg == null ? '—' : Units.formatWeight(p.weightKg!, unit),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l.compare)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                a != null && b != null ? '${l.daysApart(days)} · ${signedWeight(b - a)}' : l.daysApart(days),
                key: const Key('compare-summary'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Expanded(
              // Before is always on the left, after on the right, in both languages.
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(children: [side(before, l.before), side(after, l.after)]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
