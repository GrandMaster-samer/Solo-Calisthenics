import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_l10n.dart';
import '../domain/illustration.dart';

/// Switch for the looping figure animations (off in tests, where a looping
/// animation would keep the frame scheduler busy forever).
final animateIllustrationsProvider = Provider<bool>((ref) => true);

/// The drawn guide for an exercise: a stick figure moving through one rep (or
/// holding the position, for static holds), with the equipment it uses.
///
/// With [animate] false, or when the system asks to reduce motion, it shows the
/// cover pose, with the starting position as a faint ghost when [ghost] is set.
class ExerciseIllustration extends ConsumerStatefulWidget {
  const ExerciseIllustration({
    super.key,
    required this.exerciseId,
    this.animate = true,
    this.ghost = true,
    this.color = AppColors.primary,
    this.semanticLabel,
  });

  final String exerciseId;
  final bool animate;
  final bool ghost;
  final Color color;
  final String? semanticLabel;

  @override
  ConsumerState<ExerciseIllustration> createState() =>
      _ExerciseIllustrationState();
}

class _ExerciseIllustrationState extends ConsumerState<ExerciseIllustration>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  void _sync(Illustration? ill, bool animate) {
    final wanted = animate && ill != null && !ill.isStatic;
    if (!wanted) {
      _controller?.dispose();
      _controller = null;
      return;
    }
    final duration = Duration(milliseconds: ill.loopMs);
    if (_controller == null) {
      _controller = AnimationController(vsync: this, duration: duration)
        ..repeat();
    } else if (_controller!.duration != duration) {
      _controller!
        ..duration = duration
        ..repeat();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final set = ref.watch(exerciseLibraryProvider).illustrations;
    final ill = set[widget.exerciseId];
    final animate =
        widget.animate &&
        ref.watch(animateIllustrationsProvider) &&
        !(MediaQuery.maybeDisableAnimationsOf(context) ?? false);
    _sync(ill, animate);
    if (ill == null) return const SizedBox.shrink();
    final bounds = ill.bounds(set.lengths);

    CustomPaint painter(FigurePose pose, {FigurePose? ghost}) => CustomPaint(
      size: Size.infinite,
      painter: IllustrationPainter(
        illustration: ill,
        lengths: set.lengths,
        bounds: bounds,
        pose: pose,
        ghost: ghost,
        color: widget.color,
      ),
    );

    final controller = _controller;
    final Widget child;
    if (controller == null) {
      final cover = ill.poses[ill.cover];
      final start = ill.cover == 0 ? ill.poses.last : ill.poses.first;
      child = painter(
        cover,
        ghost: widget.ghost && !ill.isStatic ? start : null,
      );
    } else {
      child = AnimatedBuilder(
        animation: controller,
        builder: (context, _) =>
            painter(ill.poseAt(controller.value * ill.loopMs)),
      );
    }
    return Semantics(
      image: true,
      label: widget.semanticLabel,
      excludeSemantics: true,
      child: RepaintBoundary(child: child),
    );
  }
}

/// Small still drawing for lists.
class ExerciseThumbnail extends StatelessWidget {
  const ExerciseThumbnail({
    super.key,
    required this.exerciseId,
    this.width = 64,
    this.height = 44,
  });
  final String exerciseId;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(3),
      child: ExerciseIllustration(
        exerciseId: exerciseId,
        animate: false,
        ghost: false,
        color: AppColors.textPrimary,
      ),
    );
  }
}

/// Accessible name for an illustration.
String illustrationLabel(BuildContext context, String exerciseName) =>
    AppL10n.of(context).illustrationOf(exerciseName);

class IllustrationPainter extends CustomPainter {
  IllustrationPainter({
    required this.illustration,
    required this.lengths,
    required this.bounds,
    required this.pose,
    required this.color,
    this.ghost,
  });

  final Illustration illustration;
  final FigureLengths lengths;
  final Rect bounds;
  final FigurePose pose;
  final FigurePose? ghost;
  final Color color;

  static const _propColor = Color(0xFF6E7784);
  static const _farFactor = 0.5;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || bounds.isEmpty) return;
    final scale = math.min(
      size.width / bounds.width,
      size.height / bounds.height,
    );
    final dx = (size.width - bounds.width * scale) / 2 - bounds.left * scale;
    final dy = (size.height - bounds.height * scale) / 2 - bounds.top * scale;
    Offset w(Offset p) => Offset(p.dx * scale + dx, p.dy * scale + dy);
    double px(double units) => math.max(1.4, units * scale);

    final joints = pose.joints(lengths);
    _paintProps(canvas, size, w, px, joints);
    final g = ghost;
    if (g != null) {
      _paintFigure(
        canvas,
        g.joints(lengths),
        w,
        px,
        AppColors.textSecondary.withValues(alpha: 0.28),
        AppColors.textSecondary.withValues(alpha: 0.18),
      );
    }
    _paintFigure(
      canvas,
      joints,
      w,
      px,
      color,
      Color.lerp(color, AppColors.background, _farFactor)!,
    );
  }

  void _paintProps(
    Canvas canvas,
    Size size,
    Offset Function(Offset) w,
    double Function(double) px,
    Map<String, Offset> joints,
  ) {
    final stroke = Paint()
      ..color = _propColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = px(3.5);
    final fill = Paint()..color = _propColor;
    final thin = Paint()
      ..color = _propColor.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = px(2.5);
    for (final prop in illustration.props) {
      switch (prop.type) {
        case 'floor':
          final y = w(Offset(0, prop['y'])).dy;
          canvas.drawLine(
            Offset(0, y),
            Offset(size.width, y),
            stroke..strokeWidth = px(3),
          );
          stroke.strokeWidth = px(3.5);
        case 'bar':
          final c = w(Offset(prop['x'], prop['y']));
          canvas.drawLine(c, Offset(c.dx, 0), thin);
          canvas.drawCircle(c, px(6), fill);
        case 'lowBar' || 'post':
          final c = w(Offset(prop['x'], prop['y']));
          canvas.drawLine(c, w(Offset(prop['x'], prop['floor'])), thin);
          canvas.drawCircle(c, px(prop.type == 'lowBar' ? 5 : 3), fill);
        case 'wall':
          final x = w(Offset(prop['x'], 0)).dx;
          final floor = illustration.props
              .where((p) => p.type == 'floor')
              .firstOrNull;
          final bottom = floor == null
              ? size.height
              : w(Offset(0, floor['y'])).dy;
          canvas.drawRect(Rect.fromLTRB(x - px(2), 0, x + px(2), bottom), fill);
        case 'bench':
          final top = w(Offset(prop['x1'], prop['y']));
          final right = w(Offset(prop['x2'], prop['y'] + 6));
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromPoints(top, right),
              Radius.circular(px(2)),
            ),
            fill,
          );
          final floorY = w(Offset(0, prop['floor'])).dy;
          for (final x in [prop['x1'] + 7, prop['x2'] - 7]) {
            final p = w(Offset(x, prop['y'] + 6));
            canvas.drawLine(p, Offset(p.dx, floorY), stroke);
          }
        case 'dipBars':
          final a = w(Offset(prop['x1'], prop['y']));
          final b = w(Offset(prop['x2'], prop['y']));
          canvas.drawLine(a, Offset(a.dx, size.height), thin);
          canvas.drawLine(b, Offset(b.dx, size.height), thin);
          canvas.drawLine(a, b, stroke..strokeWidth = px(5));
          stroke.strokeWidth = px(3.5);
        case 'pad':
          final r = Rect.fromCenter(
            center: w(Offset(prop['x'], prop['y'])),
            width: prop['w'] * px(1),
            height: prop['h'] * px(1),
          );
          canvas.drawRRect(
            RRect.fromRectAndRadius(r, Radius.circular(px(2))),
            fill,
          );
        case 'band':
          final to = joints[prop.to];
          if (to == null) break;
          canvas.drawLine(
            w(Offset(prop['x'], prop['y'])),
            w(to),
            Paint()
              ..color = AppColors.warning.withValues(alpha: 0.9)
              ..strokeWidth = px(2),
          );
      }
    }
  }

  void _paintFigure(
    Canvas canvas,
    Map<String, Offset> j,
    Offset Function(Offset) w,
    double Function(double) px,
    Color main,
    Color far,
  ) {
    Paint limb(Color c, double units) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = px(units);

    void chain(List<String> names, Paint paint) {
      final path = Path()..moveTo(w(j[names.first]!).dx, w(j[names.first]!).dy);
      for (final n in names.skip(1)) {
        final p = w(j[n]!);
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, paint);
    }

    // Far side first, so the near side is drawn over it.
    final farPaint = limb(far, 6);
    chain(['shoulder', 'farElbow', 'farHand'], farPaint);
    chain(['hip', 'farKnee', 'farAnkle', 'farToe'], farPaint);
    final mainLimb = limb(main, 6.5);
    chain(['hip', 'nearKnee', 'nearAnkle', 'nearToe'], mainLimb);
    chain(['hip', 'neck'], limb(main, 9));
    canvas.drawCircle(w(j['head']!), px(lengths.head), Paint()..color = main);
    chain(['shoulder', 'nearElbow', 'nearHand'], mainLimb);
  }

  @override
  bool shouldRepaint(IllustrationPainter old) =>
      old.pose != pose ||
      old.ghost != ghost ||
      old.color != color ||
      old.illustration != illustration;
}
