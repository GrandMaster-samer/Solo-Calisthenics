import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' show Offset, Rect;

/// Segment lengths of the drawn figure, in world units.
class FigureLengths {
  const FigureLengths({
    required this.torso,
    required this.shoulder,
    required this.neck,
    required this.head,
    required this.upper,
    required this.fore,
    required this.thigh,
    required this.shin,
    required this.foot,
  });

  factory FigureLengths.fromJson(Map<String, dynamic> j) {
    double v(String k) => (j[k] as num).toDouble();
    return FigureLengths(
      torso: v('torso'),
      shoulder: v('shoulder'),
      neck: v('neck'),
      head: v('head'),
      upper: v('upper'),
      fore: v('fore'),
      thigh: v('thigh'),
      shin: v('shin'),
      foot: v('foot'),
    );
  }

  final double torso;

  /// Where the arms attach, as a fraction of the torso from the hip.
  final double shoulder;
  final double neck;

  /// Head radius.
  final double head;
  final double upper;
  final double fore;
  final double thigh;
  final double shin;
  final double foot;
}

/// Segment directions in degrees (0 = forward/right, 90 = down) plus one body
/// point pinned to a world position. Keys: torso, head, nu/nf (near upper arm /
/// forearm), fu/ff (far arm), nt/ns/nft (near thigh / shin / foot), ft/fs/fft.
class FigurePose {
  const FigurePose({
    required this.anchor,
    required this.at,
    required this.angles,
  });

  factory FigurePose.fromJson(Map<String, dynamic> j) {
    final at = (j['at'] as List).cast<num>();
    return FigurePose(
      anchor: j['anchor'] as String,
      at: Offset(at[0].toDouble(), at[1].toDouble()),
      angles: {
        for (final e in (j['angles'] as Map<String, dynamic>).entries)
          e.key: (e.value as num).toDouble(),
      },
    );
  }

  static const angleKeys = [
    'torso',
    'head',
    'nu',
    'nf',
    'fu',
    'ff',
    'nt',
    'ns',
    'nft',
    'ft',
    'fs',
    'fft',
  ];

  final String anchor;
  final Offset at;
  final Map<String, double> angles;

  double operator [](String key) => angles[key] ?? 0;

  /// Straight-line interpolation of every angle and of the anchor position.
  static FigurePose lerp(FigurePose a, FigurePose b, double t) => FigurePose(
    anchor: a.anchor,
    at: Offset.lerp(a.at, b.at, t)!,
    angles: {for (final k in angleKeys) k: a[k] + (b[k] - a[k]) * t},
  );

  /// Joint positions in world units (y grows downward).
  Map<String, Offset> joints(FigureLengths l) {
    Offset dir(String k) {
      final r = this[k] * math.pi / 180;
      return Offset(math.cos(r), math.sin(r));
    }

    final p = <String, Offset>{'hip': Offset.zero};
    p['neck'] = dir('torso') * l.torso;
    p['shoulder'] = dir('torso') * (l.torso * l.shoulder);
    p['head'] = p['neck']! + dir('head') * (l.neck + l.head);
    p['nearElbow'] = p['shoulder']! + dir('nu') * l.upper;
    p['nearHand'] = p['nearElbow']! + dir('nf') * l.fore;
    p['farElbow'] = p['shoulder']! + dir('fu') * l.upper;
    p['farHand'] = p['farElbow']! + dir('ff') * l.fore;
    p['nearKnee'] = dir('nt') * l.thigh;
    p['nearAnkle'] = p['nearKnee']! + dir('ns') * l.shin;
    p['nearToe'] = p['nearAnkle']! + dir('nft') * l.foot;
    p['farKnee'] = dir('ft') * l.thigh;
    p['farAnkle'] = p['farKnee']! + dir('fs') * l.shin;
    p['farToe'] = p['farAnkle']! + dir('fft') * l.foot;
    final shift = at - (p[anchor] ?? Offset.zero);
    return {for (final e in p.entries) e.key: e.value + shift};
  }
}

/// Equipment drawn around the figure. Coordinates are world units.
class IllustrationProp {
  const IllustrationProp(this.type, this.values, {this.to});

  factory IllustrationProp.fromJson(Map<String, dynamic> j) =>
      IllustrationProp(j['type'] as String, {
        for (final e in j.entries)
          if (e.value is num) e.key: (e.value as num).toDouble(),
      }, to: j['to'] as String?);

  /// floor, bar, lowBar, post, wall, bench, dipBars, pad, band.
  final String type;
  final Map<String, double> values;

  /// For a band: the body point it is attached to.
  final String? to;

  double operator [](String key) => values[key] ?? 0;
}

/// One exercise's animated drawing: a loop that holds the first pose, moves through
/// the poses, holds the last one and moves back.
class Illustration {
  Illustration({
    required this.poses,
    required this.props,
    required this.holdMs,
    required this.forwardMs,
    required this.backMs,
    required this.cover,
  }) : assert(poses.isNotEmpty);

  factory Illustration.fromJson(Map<String, dynamic> j) {
    final poses = [
      for (final p in (j['poses'] as List).cast<Map<String, dynamic>>())
        FigurePose.fromJson(p),
    ];
    return Illustration(
      poses: poses,
      props: [
        for (final p
            in ((j['props'] as List?) ?? const []).cast<Map<String, dynamic>>())
          IllustrationProp.fromJson(p),
      ],
      holdMs: (j['hold'] as num?)?.toInt() ?? 450,
      forwardMs: (j['forward'] as num?)?.toInt() ?? 750,
      backMs: (j['back'] as num?)?.toInt() ?? 750,
      cover: ((j['cover'] as num?)?.toInt() ?? poses.length - 1).clamp(
        0,
        poses.length - 1,
      ),
    );
  }

  final List<FigurePose> poses;
  final List<IllustrationProp> props;
  final int holdMs;
  final int forwardMs;
  final int backMs;

  /// Index of the pose shown in still images.
  final int cover;

  bool get isStatic => poses.length < 2;

  int get loopMs =>
      isStatic ? 0 : 2 * holdMs + (poses.length - 1) * (forwardMs + backMs);

  static double _ease(double t) =>
      t < 0.5 ? 4 * t * t * t : 1 - math.pow(-2 * t + 2, 3) / 2;

  /// The pose [ms] milliseconds into the loop.
  FigurePose poseAt(double ms) {
    if (isStatic) return poses.first;
    final n = poses.length;
    var t = ms % loopMs;
    if (t < holdMs) return poses.first;
    t -= holdMs;
    final forward = (n - 1) * forwardMs;
    if (t < forward) {
      final i = t ~/ forwardMs;
      return FigurePose.lerp(
        poses[i],
        poses[i + 1],
        _ease((t - i * forwardMs) / forwardMs),
      );
    }
    t -= forward;
    if (t < holdMs) return poses.last;
    t -= holdMs;
    final i = (t ~/ backMs).clamp(0, n - 2);
    final from = n - 1 - i;
    return FigurePose.lerp(
      poses[from],
      poses[from - 1],
      _ease(((t - i * backMs) / backMs).clamp(0, 1)),
    );
  }

  /// World area that holds the figure in every pose plus the equipment, so the
  /// drawing never shifts or rescales while it moves.
  Rect bounds(FigureLengths l) {
    var minX = double.infinity,
        minY = double.infinity,
        maxX = -double.infinity,
        maxY = -double.infinity;
    void take(double x, double y) {
      minX = math.min(minX, x);
      maxX = math.max(maxX, x);
      minY = math.min(minY, y);
      maxY = math.max(maxY, y);
    }

    // Sample the whole loop: in-between poses can reach outside the key poses.
    final samples = isStatic ? 1 : 48;
    for (var i = 0; i < samples; i++) {
      for (final p in poseAt(loopMs * i / samples).joints(l).values) {
        take(p.dx, p.dy);
      }
    }
    final head = l.head + 4;
    minX -= head;
    maxX += head;
    minY -= head;
    maxY += head;
    for (final prop in props) {
      switch (prop.type) {
        case 'floor':
          take(minX, prop['y']);
        case 'bar' || 'lowBar' || 'post':
          take(prop['x'], prop['y']);
          if (prop.type != 'bar') take(prop['x'], prop['floor']);
        case 'wall':
          take(prop['x'], minY);
        case 'bench':
          take(prop['x1'], prop['y']);
          take(prop['x2'], prop['floor']);
        case 'dipBars':
          take(prop['x1'], prop['y']);
          take(prop['x2'], prop['y']);
        case 'pad':
          take(prop['x'] - prop['w'] / 2, prop['y'] - prop['h'] / 2);
          take(prop['x'] + prop['w'] / 2, prop['y'] + prop['h'] / 2);
      }
    }
    const margin = 6.0;
    return Rect.fromLTRB(
      minX - margin,
      minY - margin,
      maxX + margin,
      maxY + margin,
    );
  }
}

/// All illustrations, keyed by exercise id (assets/data/illustrations.json).
class IllustrationSet {
  const IllustrationSet({required this.lengths, required this.byExercise});

  static const assetPath = 'assets/data/illustrations.json';

  static const empty = IllustrationSet(
    lengths: FigureLengths(
      torso: 48,
      shoulder: 0.9,
      neck: 5,
      head: 8.5,
      upper: 26,
      fore: 24,
      thigh: 38,
      shin: 36,
      foot: 11,
    ),
    byExercise: {},
  );

  factory IllustrationSet.fromJsonString(String source) {
    final j = jsonDecode(source) as Map<String, dynamic>;
    return IllustrationSet(
      lengths: FigureLengths.fromJson(j['lengths'] as Map<String, dynamic>),
      byExercise: {
        for (final e in (j['illustrations'] as Map<String, dynamic>).entries)
          e.key: Illustration.fromJson(e.value as Map<String, dynamic>),
      },
    );
  }

  final FigureLengths lengths;
  final Map<String, Illustration> byExercise;

  Illustration? operator [](String exerciseId) => byExercise[exerciseId];
}
