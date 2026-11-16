import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/db/encrypted_connection.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_l10n.dart';
import '../../settings/application/settings_controller.dart';
import '../data/app_lock.dart';

/// Whether a PIN is set. Invalidate after setting or removing the PIN.
final hasPinProvider = FutureProvider<bool>((ref) => ref.watch(appLockProvider).hasPin());

/// Shows [child] only after the PIN (or biometrics) has been accepted.
/// Does nothing when no PIN is set or [enabled] is false.
class LockGate extends ConsumerStatefulWidget {
  const LockGate({
    super.key,
    required this.child,
    this.enabled = true,
    this.relockOnBackground = false,
    this.coverChild = false,
  });
  final Widget child;
  final bool enabled;

  /// Keep [child] alive underneath the lock screen instead of removing it, so
  /// navigation state survives a re-lock (used for the whole-app lock).
  final bool coverChild;

  /// Lock again whenever the app goes to the background (used for the whole-app lock).
  final bool relockOnBackground;

  @override
  ConsumerState<LockGate> createState() => _LockGateState();
}

class _LockGateState extends ConsumerState<LockGate> with WidgetsBindingObserver {
  bool _unlocked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (widget.relockOnBackground && state == AppLifecycleState.paused && _unlocked) {
      setState(() => _unlocked = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPin = ref.watch(hasPinProvider);
    if (!widget.enabled) {
      _unlocked = true; // turning the lock on later must not lock the open screen
      return widget.child;
    }
    // Content that was open before a PIN existed stays open: creating a PIN
    // must not lock the screen the user is looking at.
    if (hasPin.value == false) _unlocked = true;
    // If the keystore cannot be read, stay locked rather than fail open.
    final locked = !_unlocked && (hasPin.value ?? true);
    if (!locked) return widget.child;
    final lockScreen = hasPin.isLoading
        ? const Scaffold(body: SizedBox.shrink())
        : PinEntryScreen(onUnlocked: () => setState(() => _unlocked = true));
    if (!widget.coverChild) return lockScreen;
    return Stack(
      children: [
        // Still mounted, but not painted, not hit-testable and silent to screen readers.
        Offstage(child: TickerMode(enabled: false, child: widget.child)),
        Positioned.fill(child: lockScreen),
      ],
    );
  }
}

/// Full-screen PIN prompt with optional biometric unlock.
class PinEntryScreen extends ConsumerStatefulWidget {
  const PinEntryScreen({super.key, required this.onUnlocked});
  final VoidCallback onUnlocked;

  @override
  ConsumerState<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends ConsumerState<PinEntryScreen> {
  String _pin = '';
  String? _error;
  bool _busy = false;
  bool _biometricsAvailable = false;
  bool _confirmErase = false;

  /// Last resort when the PIN is forgotten: delete everything and start over.
  Future<void> _erase() async {
    final control = ref.read(appControlProvider);
    final lock = ref.read(appLockProvider);
    await ref.read(databaseProvider).close();
    await wipeAppData(file: control.databaseFile, keyStore: control.keyStore);
    await lock.clearPin();
    await control.restart();
  }

  @override
  void initState() {
    super.initState();
    _initBiometrics();
  }

  Future<void> _initBiometrics() async {
    if (!ref.read(settingsProvider).biometricUnlock) return;
    final available = await ref.read(appLockProvider).biometrics.isAvailable();
    if (!mounted || !available) return;
    setState(() => _biometricsAvailable = true);
    await _biometric();
  }

  Future<void> _biometric() async {
    final reason = AppL10n.of(context).unlockReason;
    if (await ref.read(appLockProvider).biometrics.authenticate(reason) && mounted) widget.onUnlocked();
  }

  Future<void> _submit() async {
    final l = AppL10n.of(context);
    final lock = ref.read(appLockProvider);
    final now = ref.read(clockProvider)();
    final wait = lock.lockoutRemaining(now);
    if (wait > Duration.zero) {
      setState(() {
        _pin = '';
        _error = l.pinLockedOut(wait.inSeconds + 1);
      });
      return;
    }
    setState(() => _busy = true);
    final ok = await lock.verify(_pin, now: now);
    if (!mounted) return;
    if (ok) {
      widget.onUnlocked();
    } else {
      final after = lock.lockoutRemaining(ref.read(clockProvider)());
      setState(() {
        _busy = false;
        _pin = '';
        _error = after > Duration.zero ? l.pinLockedOut(after.inSeconds) : l.pinWrong;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Scaffold(
      body: SafeArea(
        child: PinPad(
          title: l.enterPin,
          error: _error,
          pin: _pin,
          busy: _busy,
          onChanged: (p) => setState(() {
            _pin = p;
            _error = null;
          }),
          onSubmit: _submit,
          extra: Column(
            children: [
              if (_biometricsAvailable)
                TextButton.icon(
                  onPressed: _biometric,
                  icon: const Icon(Icons.fingerprint),
                  label: Text(l.useBiometrics),
                ),
              if (!_confirmErase)
                TextButton(
                  key: const Key('forgot-pin'),
                  onPressed: () => setState(() => _confirmErase = true),
                  child: Text(l.forgotPin, style: const TextStyle(color: AppColors.textSecondary)),
                )
              else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    l.forgotPinBody,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.warning),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(onPressed: () => setState(() => _confirmErase = false), child: Text(l.cancel)),
                    TextButton(
                      key: const Key('erase-all'),
                      onPressed: _erase,
                      child: Text(l.eraseEverything, style: const TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Creates or changes the PIN: enter it, then confirm it. Pops with true when saved.
class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  String _pin = '';
  String? _first;
  String? _error;
  bool _busy = false;

  Future<void> _submit() async {
    final l = AppL10n.of(context);
    if (!AppLock.isValidPin(_pin)) {
      setState(() => _error = l.pinTooShort(AppLock.minPinLength));
      return;
    }
    if (_first == null) {
      setState(() {
        _first = _pin;
        _pin = '';
      });
      return;
    }
    if (_first != _pin) {
      setState(() {
        _first = null;
        _pin = '';
        _error = l.pinMismatch;
      });
      return;
    }
    setState(() => _busy = true);
    await ref.read(appLockProvider).setPin(_pin);
    ref.invalidate(hasPinProvider);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.setPin)),
      body: SafeArea(
        child: PinPad(
          title: _first == null ? l.choosePin : l.confirmPin,
          subtitle: l.pinNoRecovery,
          error: _error,
          pin: _pin,
          busy: _busy,
          onChanged: (p) => setState(() {
            _pin = p;
            _error = null;
          }),
          onSubmit: _submit,
        ),
      ),
    );
  }
}

/// Numeric keypad with large keys. Digits are always Western and laid out
/// left-to-right, like a phone keypad, in both languages.
class PinPad extends StatelessWidget {
  const PinPad({
    super.key,
    required this.title,
    required this.pin,
    required this.onChanged,
    required this.onSubmit,
    this.subtitle,
    this.error,
    this.busy = false,
    this.extra,
  });
  final String title;
  final String? subtitle;
  final String? error;
  final String pin;
  final bool busy;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    Widget key(String label, {VoidCallback? onTap, IconData? icon, Key? k}) => Padding(
          padding: const EdgeInsets.all(6),
          child: SizedBox(
            width: 76,
            height: 64,
            child: Material(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                key: k,
                onTap: busy ? null : onTap,
                child: Center(
                  child: icon != null
                      ? Icon(icon, semanticLabel: label)
                      : Text(label, style: numericStyle(26, weight: FontWeight.w600)),
                ),
              ),
            ),
          ),
        );
    void add(String d) {
      if (pin.length < AppLock.maxPinLength) onChanged(pin + d);
    }

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, size: 40, color: AppColors.primary),
                const SizedBox(height: 12),
                Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      subtitle!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                const SizedBox(height: 20),
                Semantics(
                  label: l.pinDigitsEntered(pin.length),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < (pin.length < AppLock.minPinLength ? AppLock.minPinLength : pin.length); i++)
                        Container(
                          width: 14,
                          height: 14,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i < pin.length ? AppColors.primary : AppColors.surfaceElevated,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 36,
                  child: Center(
                    child: error == null
                        ? null
                        : Text(error!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.error)),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Column(
                    children: [
                      for (final row in const [
                        ['1', '2', '3'],
                        ['4', '5', '6'],
                        ['7', '8', '9'],
                      ])
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [for (final d in row) key(d, k: Key('pin-$d'), onTap: () => add(d))],
                        ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          key(
                            l.deleteDigit,
                            icon: Icons.backspace_outlined,
                            k: const Key('pin-back'),
                            onTap: pin.isEmpty ? null : () => onChanged(pin.substring(0, pin.length - 1)),
                          ),
                          key('0', k: const Key('pin-0'), onTap: () => add('0')),
                          key(
                            l.ok,
                            icon: Icons.check,
                            k: const Key('pin-ok'),
                            onTap: pin.length >= AppLock.minPinLength ? onSubmit : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (extra != null) Padding(padding: const EdgeInsets.only(top: 12), child: extra),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
