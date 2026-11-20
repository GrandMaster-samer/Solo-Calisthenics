import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:video_player/video_player.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/units.dart';
import '../../../l10n/app_l10n.dart';
import '../../exercises/presentation/library_screen.dart';
import '../application/cloud_providers.dart';
import '../data/clip_source.dart';
import '../domain/cloud_backend.dart';

/// Builds the player for a clip link. Overridden in tests, where there is no video engine.
final clipPlayerBuilderProvider = Provider<Widget Function(Uri url)>(
  (ref) =>
      (url) => _ClipPlayer(url: url),
);

/// Athlete side of coach review: send a clip, read feedback. Coaches also get the inbox.
class CoachHubScreen extends ConsumerStatefulWidget {
  const CoachHubScreen({super.key});

  @override
  ConsumerState<CoachHubScreen> createState() => _CoachHubScreenState();
}

class _CoachHubScreenState extends ConsumerState<CoachHubScreen> {
  String? _exerciseId;
  File? _clip;
  final _note = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _purge();
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  /// Retention rule: clips older than 30 days are removed whenever this screen opens.
  Future<void> _purge() async {
    final backend = ref.read(cloudBackendProvider);
    if (backend?.currentUser == null) return;
    try {
      final removed = await backend!.purgeExpiredClips(
        now: ref.read(clockProvider)(),
      );
      if (removed > 0) {
        ref.invalidate(mySubmissionsProvider);
        ref.invalidate(reviewQueueProvider);
      }
    } on Object {
      // Offline or temporarily unavailable: try again next time.
    }
  }

  Future<void> _pickExercise() async {
    final ids = await Navigator.of(context).push<List<String>>(
      MaterialPageRoute(builder: (_) => const LibraryScreen(pickMode: true)),
    );
    if (ids != null && ids.isNotEmpty) setState(() => _exerciseId = ids.last);
  }

  Future<void> _pickClip({required bool camera}) async {
    final l = AppL10n.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final clip = await ref.read(clipSourceProvider).pick(camera: camera);
      if (clip != null && mounted) setState(() => _clip = clip);
    } on ClipTooLongException {
      messenger.showSnackBar(
        SnackBar(content: Text(l.clipTooLong(CloudLimits.maxClipSeconds))),
      );
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(l.clipFailed)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _send() async {
    final l = AppL10n.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final backend = ref.read(cloudBackendProvider)!;
    final clip = _clip!;
    setState(() => _busy = true);
    try {
      await backend.submitClip(
        clip: clip,
        exerciseId: _exerciseId!,
        note: _note.text.trim(),
      );
      if (clip.existsSync()) {
        clip.deleteSync(); // the uploaded copy is the only one kept
      }
      ref.invalidate(mySubmissionsProvider);
      ref.invalidate(reviewQueueProvider);
      _note.clear();
      if (mounted) {
        setState(() {
          _clip = null;
          _exerciseId = null;
        });
      }
      messenger.showSnackBar(SnackBar(content: Text(l.clipSent)));
    } on CloudFileTooLargeException {
      messenger.showSnackBar(
        SnackBar(content: Text(l.clipTooLong(CloudLimits.maxClipSeconds))),
      );
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(l.cloudFailed)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final library = ref.watch(exerciseLibraryProvider);
    final backend = ref.watch(cloudBackendProvider);
    final user = ref.watch(cloudUserProvider).value;
    final submissions = ref.watch(mySubmissionsProvider).value ?? const [];
    final queue = ref.watch(reviewQueueProvider).value ?? const [];
    final dates = MaterialLocalizations.of(context);
    final text = Theme.of(context).textTheme;

    Widget body;
    if (backend == null || user == null) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.rate_review_outlined,
                size: 56,
                color: AppColors.secondary,
              ),
              const SizedBox(height: 12),
              Text(l.coachSignInNeeded, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              if (backend != null)
                FilledButton.icon(
                  key: const Key('coach-sign-in'),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    try {
                      await backend.signInWithGoogle();
                    } on Object {
                      messenger.showSnackBar(
                        SnackBar(content: Text(l.cloudFailed)),
                      );
                    }
                  },
                  icon: const Icon(Icons.login),
                  label: Text(l.signInGoogle),
                ),
            ],
          ),
        ),
      );
    } else {
      body = ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (user.isCoach)
            Card(
              color: AppColors.surfaceElevated,
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                key: const Key('open-coach-inbox'),
                leading: const Icon(
                  Icons.inbox_outlined,
                  color: AppColors.primary,
                ),
                title: Text(l.coachInbox),
                subtitle: Text(l.coachInboxWaiting(queue.length)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const CoachInboxScreen(),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            l.clipNewTitle,
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            l.clipRules(
              CloudLimits.maxClipSeconds,
              CloudLimits.clipRetentionDays,
            ),
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            key: const Key('clip-exercise'),
            onPressed: _busy ? null : _pickExercise,
            icon: const Icon(Icons.fitness_center),
            label: Text(
              _exerciseId == null
                  ? l.clipChooseExercise
                  : library.byId(_exerciseId!)!.name.of(lang),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('clip-record'),
                  onPressed: _busy ? null : () => _pickClip(camera: true),
                  icon: const Icon(Icons.videocam_outlined),
                  label: Text(l.clipRecord),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('clip-gallery'),
                  onPressed: _busy ? null : () => _pickClip(camera: false),
                  icon: const Icon(Icons.video_library_outlined),
                  label: Text(l.clipChoose),
                ),
              ),
            ],
          ),
          if (_clip != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(l.clipReady)),
                ],
              ),
            ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('clip-note'),
            controller: _note,
            maxLength: 500,
            maxLines: 3,
            minLines: 1,
            decoration: InputDecoration(labelText: l.clipNote),
          ),
          if (_busy) const LinearProgressIndicator(),
          const SizedBox(height: 8),
          FilledButton.icon(
            key: const Key('clip-send'),
            onPressed: _busy || _clip == null || _exerciseId == null
                ? null
                : _send,
            icon: const Icon(Icons.send),
            label: Text(l.clipSend),
          ),
          const SizedBox(height: 28),
          Text(
            l.feedbackInbox,
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          if (submissions.isEmpty)
            Text(
              l.feedbackEmpty,
              style: const TextStyle(color: AppColors.textSecondary),
            )
          else
            for (final s in submissions)
              Card(
                key: Key('submission-${s.id}'),
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              library.byId(s.exerciseId)?.name.of(lang) ??
                                  s.exerciseId,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          // Status has an icon and a word, not only a color.
                          Icon(
                            s.status == SubmissionStatus.reviewed
                                ? Icons.mark_chat_read_outlined
                                : Icons.schedule,
                            size: 18,
                            color: s.status == SubmissionStatus.reviewed
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            s.status == SubmissionStatus.reviewed
                                ? l.statusReviewed
                                : l.statusWaiting,
                          ),
                        ],
                      ),
                      Text(
                        westernDigits(dates.formatMediumDate(s.createdAt)),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      if (s.note.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(s.note),
                        ),
                      if (s.feedback != null) ...[
                        const Divider(height: 20),
                        Text(
                          l.coachSays,
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(s.feedback!),
                      ],
                    ],
                  ),
                ),
              ),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(l.coachReview)),
      body: body,
    );
  }
}

/// Coach side: clips waiting for review.
class CoachInboxScreen extends ConsumerWidget {
  const CoachInboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final library = ref.watch(exerciseLibraryProvider);
    final queue = ref.watch(reviewQueueProvider).value ?? const [];
    final dates = MaterialLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.coachInbox)),
      body: queue.isEmpty
          ? Center(
              child: Text(
                l.coachInboxEmpty,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final s in queue)
                  Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      key: Key('queue-${s.id}'),
                      leading: const Icon(
                        Icons.play_circle_outline,
                        color: AppColors.secondary,
                      ),
                      title: Text(
                        library.byId(s.exerciseId)?.name.of(lang) ??
                            s.exerciseId,
                      ),
                      subtitle: Text(
                        '${westernDigits(dates.formatMediumDate(s.createdAt))}'
                        '${s.note.isEmpty ? '' : '\n${s.note}'}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ReviewScreen(submission: s),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

/// Coach side: watch one clip and write the feedback. Sending deletes the clip.
class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key, required this.submission});
  final Submission submission;

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  final _feedback = TextEditingController();
  late final Future<Uri> _url = ref
      .read(cloudBackendProvider)!
      .clipUrl(widget.submission);
  bool _busy = false;

  @override
  void dispose() {
    _feedback.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final l = AppL10n.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await ref
          .read(cloudBackendProvider)!
          .sendFeedback(widget.submission.id, _feedback.text.trim());
      ref.invalidate(reviewQueueProvider);
      ref.invalidate(mySubmissionsProvider);
      if (mounted) Navigator.of(context).pop();
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(l.cloudFailed)));
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final s = widget.submission;
    final name =
        ref.watch(exerciseLibraryProvider).byId(s.exerciseId)?.name.of(lang) ??
        s.exerciseId;
    final player = ref.watch(clipPlayerBuilderProvider);
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: ColoredBox(
                color: Colors.black,
                child: FutureBuilder<Uri>(
                  future: _url,
                  builder: (context, snap) => snap.hasData
                      ? player(snap.data!)
                      : Center(
                          child: snap.hasError
                              ? Text(
                                  l.clipUnavailable,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                )
                              : const CircularProgressIndicator(),
                        ),
                ),
              ),
            ),
          ),
          if (s.note.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              l.clipNote,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            Text(s.note),
          ],
          const SizedBox(height: 16),
          TextField(
            key: const Key('feedback-field'),
            controller: _feedback,
            maxLength: 2000,
            minLines: 4,
            maxLines: 10,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: l.feedbackWrite,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.feedbackDeletesClip,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            key: const Key('feedback-send'),
            onPressed: _busy || _feedback.text.trim().isEmpty ? null : _send,
            icon: const Icon(Icons.send),
            label: Text(l.feedbackSend),
          ),
        ],
      ),
    );
  }
}

class _ClipPlayer extends StatefulWidget {
  const _ClipPlayer({required this.url});
  final Uri url;

  @override
  State<_ClipPlayer> createState() => _ClipPlayerState();
}

class _ClipPlayerState extends State<_ClipPlayer> {
  late final VideoPlayerController _controller =
      VideoPlayerController.networkUrl(widget.url);
  bool _ready = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _controller.setLooping(true);
    _controller
        .initialize()
        .then((_) {
          if (mounted) setState(() => _ready = true);
          _controller.play();
        })
        .catchError((Object _) {
          if (mounted) setState(() => _failed = true);
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    if (_failed) {
      return Center(
        child: Text(
          l.clipUnavailable,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }
    if (!_ready) return const Center(child: CircularProgressIndicator());
    return GestureDetector(
      onTap: () => setState(
        () => _controller.value.isPlaying
            ? _controller.pause()
            : _controller.play(),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          if (!_controller.value.isPlaying)
            Icon(
              Icons.play_arrow,
              size: 64,
              color: Colors.white,
              semanticLabel: l.clipPlay,
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: VideoProgressIndicator(_controller, allowScrubbing: true),
          ),
        ],
      ),
    );
  }
}
