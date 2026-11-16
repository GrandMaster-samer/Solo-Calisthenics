import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../l10n/app_l10n.dart';
import '../../exercises/presentation/library_screen.dart';
import '../../progress/presentation/progress_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../skills/presentation/skill_tree_screen.dart';
import '../application/active_session_controller.dart';
import 'active_session_screen.dart';
import 'train_screen.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  /// If the app was closed mid-workout, go straight back into it.
  Future<void> _restoreSession() async {
    final session = await ref.read(activeSessionProvider.future);
    if (session == null || !mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ActiveSessionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: const [TrainScreen(), LibraryScreen(), SkillTreeScreen(), ProgressScreen(), SettingsScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.fitness_center),
            label: l.tabTrain,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            label: l.tabLibrary,
          ),
          NavigationDestination(icon: const Icon(Icons.account_tree_outlined), label: l.tabSkills),
          NavigationDestination(icon: const Icon(Icons.insights), label: l.tabProgress),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            label: l.tabSettings,
          ),
        ],
      ),
    );
  }
}
