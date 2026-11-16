import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../domain/profile.dart';

class ProfileState {
  const ProfileState({this.profile, this.injuries = const []});
  final UserProfile? profile;
  final List<Injury> injuries;

  bool get isOnboarded => profile != null;
}

/// Profile loaded before the first frame; overridden in main().
final initialProfileProvider = Provider<ProfileState>(
  (ref) => const ProfileState(),
);

final profileProvider = NotifierProvider<ProfileController, ProfileState>(
  ProfileController.new,
);

class ProfileController extends Notifier<ProfileState> {
  @override
  ProfileState build() => ref.read(initialProfileProvider);

  Future<void> save(UserProfile profile, List<Injury> injuries) async {
    await ref
        .read(profileRepositoryProvider)
        .save(profile, injuries, now: ref.read(clockProvider)());
    state = ProfileState(
      profile: profile,
      injuries: List.unmodifiable(injuries),
    );
  }
}
