#!/usr/bin/env python3
"""Authoring tool for assets/data/illustrations.json: one animated stick-figure
illustration per exercise, drawn by the app (no image files, no copyrighted media).

Run:  python3 tool/build_illustrations.py [preview.png]

A figure is a side view facing right. Each pose gives the absolute direction of every
body segment in degrees, screen style: 0 = right (forward), 90 = down, 180 = left,
270 / -90 = up. One body point is pinned to a world position (the anchor), e.g. the
hands on the bar. Contact points (feet on the floor, ...) are found with small solvers
below so they really touch. The app interpolates the angles between poses.
"""
import json, math, os, sys

L = dict(torso=48, shoulder=0.9, neck=5, head=8.5, upper=26, fore=24, thigh=38, shin=36, foot=11)
KEYS = ['torso', 'head', 'nu', 'nf', 'fu', 'ff', 'nt', 'ns', 'nft', 'ft', 'fs', 'fft']
C = -3.0  # y of a point resting on a surface at y=0 (accounts for line thickness)


def d(a):
    r = math.radians(a)
    return math.cos(r), math.sin(r)


def add(p, a, l):
    v = d(a)
    return p[0] + v[0] * l, p[1] + v[1] * l


def full(a):
    a = dict(a)
    a.setdefault('torso', -90)
    a.setdefault('head', a['torso'])
    a.setdefault('nu', 90)
    a.setdefault('nf', a['nu'])
    explicit_far_arm = 'fu' in a
    a.setdefault('fu', a['nu'])
    a.setdefault('ff', a['fu'] if explicit_far_arm else a['nf'])
    a.setdefault('nt', 90)
    a.setdefault('ns', a['nt'])
    a.setdefault('nft', a['ns'] - 90)
    explicit_far_leg = 'ft' in a or 'fs' in a
    a.setdefault('ft', a['nt'])
    a.setdefault('fs', a['ft'] if explicit_far_leg else a['ns'])
    a.setdefault('fft', a['fs'] - 90 if explicit_far_leg else a['nft'])
    return {k: round(float(a[k]), 2) for k in KEYS}


def fk(a):
    P = {'hip': (0.0, 0.0)}
    P['neck'] = add(P['hip'], a['torso'], L['torso'])
    P['shoulder'] = add(P['hip'], a['torso'], L['torso'] * L['shoulder'])
    P['head'] = add(P['neck'], a['head'], L['neck'] + L['head'])
    for s, u, f in (('near', 'nu', 'nf'), ('far', 'fu', 'ff')):
        P[s + 'Elbow'] = add(P['shoulder'], a[u], L['upper'])
        P[s + 'Hand'] = add(P[s + 'Elbow'], a[f], L['fore'])
    for s, t, sh, ft in (('near', 'nt', 'ns', 'nft'), ('far', 'ft', 'fs', 'fft')):
        P[s + 'Knee'] = add(P['hip'], a[t], L['thigh'])
        P[s + 'Ankle'] = add(P[s + 'Knee'], a[sh], L['shin'])
        P[s + 'Toe'] = add(P[s + 'Ankle'], a[ft], L['foot'])
    return P


def pose(anchor, at, **angles):
    a = full(angles)
    P = fk(a)
    tx, ty = at[0] - P[anchor][0], at[1] - P[anchor][1]
    return {'anchor': anchor, 'at': [round(at[0], 2), round(at[1], 2)], 'angles': a,
            'pts': {k: (v[0] + tx, v[1] + ty) for k, v in P.items()}}


def Y(name): return lambda p: p['pts'][name][1]
def X(name): return lambda p: p['pts'][name][0]


WARN = []


def solve(make, lo, hi, f, target, label=''):
    """Value of the parameter in [lo, hi] for which f(make(x)) == target."""
    n = 400
    xs = [lo + (hi - lo) * i / n for i in range(n + 1)]
    vs = [f(make(x)) - target for x in xs]
    for i in range(n):
        if vs[i] == 0:
            return make(xs[i])
        if vs[i] * vs[i + 1] < 0:
            a, b, fa = xs[i], xs[i + 1], vs[i]
            for _ in range(60):
                m = (a + b) / 2
                fm = f(make(m)) - target
                if fa * fm <= 0:
                    b = m
                else:
                    a, fa = m, fm
            return make((a + b) / 2)
    i = min(range(n + 1), key=lambda i: abs(vs[i]))
    WARN.append(f'{label}: no exact solution, off by {vs[i]:.1f}')
    return make(xs[i])


def ik(origin, target, l1, l2, bend):
    """Two-segment reach from origin to target; bend=+1/-1 picks the elbow/knee side."""
    dx, dy = target[0] - origin[0], target[1] - origin[1]
    dist = min(math.hypot(dx, dy), l1 + l2 - 1e-6)
    base = math.degrees(math.atan2(dy, dx))
    c = (l1 * l1 + dist * dist - l2 * l2) / (2 * l1 * dist)
    a1 = base - bend * math.degrees(math.acos(max(-1, min(1, c))))
    e = add(origin, a1, l1)
    a2 = math.degrees(math.atan2(target[1] - e[1], target[0] - e[0]))
    return a1, a2


def with_arm(anchor, at, angles, side, target, bend):
    """Pose whose (non-anchored) arm reaches target."""
    p = pose(anchor, at, **angles)
    a1, a2 = ik(p['pts']['shoulder'], target, L['upper'], L['fore'], bend)
    k = ('nu', 'nf') if side == 'near' else ('fu', 'ff')
    return pose(anchor, at, **{**angles, k[0]: a1, k[1]: a2})


def line(phi):
    """Straight body; phi = direction from the feet to the head."""
    return dict(torso=phi, nt=phi + 180, ns=phi + 180)


# ---------------------------------------------------------------- props
FLOOR = {'type': 'floor', 'y': 0}
def bar(x=0, y=0): return {'type': 'bar', 'x': x, 'y': y}
def wall(x): return {'type': 'wall', 'x': round(x, 1)}
def bench(x1, x2, y): return {'type': 'bench', 'x1': round(x1, 1), 'x2': round(x2, 1), 'y': round(y, 1), 'floor': 0}
def post(x, top): return {'type': 'post', 'x': round(x, 1), 'y': round(top, 1), 'floor': 0}
def low_bar(x, y): return {'type': 'lowBar', 'x': round(x, 1), 'y': round(y, 1), 'floor': 0}
def dip_bars(x1, x2, y): return {'type': 'dipBars', 'x1': x1, 'x2': x2, 'y': y}
def pad(x, y, w, h): return {'type': 'pad', 'x': round(x, 1), 'y': round(y, 1), 'w': w, 'h': h}
def band(x, y, to): return {'type': 'band', 'x': x, 'y': y, 'to': to}


E = {}


def ex(id, poses, props, hold=450, fwd=750, back=750, cover=None):
    """cover: index of the pose shown when not animating (default: the last one)."""
    E[id] = {'poses': poses, 'props': props, 'hold': hold, 'forward': fwd, 'back': back,
             'cover': len(poses) - 1 if cover is None else cover}


def pts(p, name): return p['pts'][name]


# ================================================================ PUSH
HAND = (0, C)


def floor_line(nu, nf, contact='nearToe', y=C, lo=-50, hi=50, label='', **extra):
    return solve(lambda phi: pose('nearHand', HAND, nu=nu, nf=nf, **line(phi), **extra), lo, hi, Y(contact), y, label)


TOP, BOTTOM = (90, 90), (152, 62)

# wall push-up: toes pinned, hands slide to a wall
A = pose('nearToe', (0, C), nu=0, nf=0, **line(-64))
W = pts(A, 'nearHand')[0]
B = solve(lambda phi: pose('nearToe', (0, C), nu=114, nf=-26, **line(phi)), -89, -40, X('nearHand'), W, 'wall_push_up')
ex('wall_push_up', [A, B], [FLOOR, wall(W + 3)])

A = solve(lambda phi: pose('nearHand', (0, -40 + C), nu=90, nf=90, **line(phi)), -60, 10, Y('nearToe'), C, 'incline')
B = solve(lambda phi: pose('nearHand', (0, -40 + C), nu=152, nf=62, **line(phi)), -60, 10, Y('nearToe'), C, 'incline')
ex('incline_push_up', [A, B], [FLOOR, bench(-14, 30, -40)])


def knee_pu(nu, nf):
    return solve(lambda phi: pose('nearHand', HAND, nu=nu, nf=nf, torso=phi, nt=phi + 180, ns=186, nft=186),
                 -60, 20, Y('nearKnee'), C, 'knee_push_up')


ex('knee_push_up', [knee_pu(*TOP), knee_pu(*BOTTOM)], [FLOOR])
ex('push_up', [floor_line(*TOP, label='push'), floor_line(*BOTTOM, label='push')], [FLOOR])
ex('diamond_push_up', [floor_line(100, 82, label='diamond'), floor_line(168, 66, label='diamond')], [FLOOR])
A = floor_line(*TOP, y=-40 + C, lo=-20, hi=40, label='decline')
B = floor_line(*BOTTOM, y=-40 + C, lo=-20, hi=40, label='decline')
tx = pts(A, 'nearToe')[0]
ex('decline_push_up', [A, B], [FLOOR, bench(tx - 30, tx + 8, -40)])


def archer(nu, nf):
    base = floor_line(nu, nf, label='archer')
    phi = base['angles']['torso']
    return solve(lambda t: pose('nearHand', HAND, nu=nu, nf=nf, fu=t, ff=t, **line(phi)), 0, 90, Y('farHand'), C, 'archer far')


ex('archer_push_up', [archer(*TOP), archer(*BOTTOM)], [FLOOR])
behind = dict(fu=125, ff=195)
ex('one_arm_push_up', [floor_line(*TOP, label='oap', **behind), floor_line(*BOTTOM, label='oap', **behind)], [FLOOR])

# ================================================================ DIPS
SUPPORT = dict(nu=90, nf=90, torso=-82, nt=98, ns=118, nft=118)
DIP_LOW = dict(nu=200, nf=86, torso=-52, nt=112, ns=152, nft=152)
ex('support_hold', [pose('nearHand', (0, 0), **SUPPORT)], [dip_bars(-38, 38, 0)])
ex('dip', [pose('nearHand', (0, 0), **SUPPORT), pose('nearHand', (0, 0), **DIP_LOW)],
   [dip_bars(-38, 38, 0)])
ex('negative_dip', [pose('nearHand', (0, 0), **SUPPORT), pose('nearHand', (0, 0), **DIP_LOW)],
   [dip_bars(-38, 38, 0)], fwd=1700, back=600)
SBD_TOP = dict(nu=90, nf=90, torso=-74, nt=100, ns=105, nft=105)
SBD_LOW = dict(nu=196, nf=74, torso=-40, nt=118, ns=125, nft=125)
ex('straight_bar_dip', [pose('nearHand', (0, 0), **SBD_TOP), pose('nearHand', (0, 0), **SBD_LOW)], [bar()])


def bench_dip(nu, nf, torso):
    return solve(lambda t: pose('nearHand', (0, -40 + C), nu=nu, nf=nf, torso=torso, nt=t, ns=t, nft=t - 90),
                 0, 80, Y('nearAnkle'), C, 'bench_dip')


ex('bench_dip', [bench_dip(100, 95, -88), bench_dip(174, 70, -84)], [FLOOR, bench(-48, 6, -40)])

# ================================================================ HSPU


def pike(torso, nu, nf, y=C, lo=95, hi=200):
    return solve(lambda t: pose('nearHand', HAND, torso=torso, nu=nu, nf=nf, nt=t, ns=t, nft=t - 70), lo, hi, Y('nearToe'), y, 'pike')


ex('pike_push_up', [pike(52, 56, 56), pike(66, 128, 52)], [FLOOR])
A, B = pike(74, 76, 76, y=-42 + C, lo=110, hi=230), pike(84, 132, 50, y=-42 + C, lo=110, hi=230)
tx = pts(A, 'nearToe')[0]
ex('elevated_pike_push_up', [A, B], [FLOOR, bench(tx - 30, tx + 8, -42)])

HS_TOP = dict(nu=90, nf=90, torso=86, head=90, nt=266, ns=266, nft=266)
HS_LOW = dict(nu=38, nf=142, torso=84, head=90, nt=266, ns=266, nft=266)
A, B = pose('nearHand', HAND, **HS_TOP), pose('nearHand', HAND, **HS_LOW)
wx = min(pts(p, k)[0] for p in (A, B) for k in ('nearToe', 'nearAnkle', 'nearKnee', 'hip')) - 5
ex('wall_hspu_negative', [A, B], [FLOOR, wall(wx)], fwd=1700, back=650)
ex('wall_hspu', [A, B], [FLOOR, wall(wx)])
STRAIGHT_HS = dict(nu=90, nf=90, torso=90, head=90, nt=270, ns=270, nft=270)
ex('freestanding_hspu', [pose('nearHand', HAND, **STRAIGHT_HS), pose('nearHand', HAND, **{**HS_LOW, 'torso': 90, 'nt': 270, 'ns': 270, 'nft': 270})], [FLOOR])

# ================================================================ PULL (hands on the bar at 0,0)
HANG = dict(nu=-87, nf=-87, torso=-90, nt=86, ns=88, nft=88)
PULL_TOP = dict(nu=74, nf=-98, torso=-98, head=-86, nt=82, ns=86, nft=86)
ex('dead_hang', [pose('nearHand', (0, 0), **HANG)], [bar()])
ex('scapular_pull_up', [pose('nearHand', (0, 0), **HANG),
                        pose('nearHand', (0, 0), **{**HANG, 'torso': -97, 'head': -84, 'nt': 82, 'ns': 82, 'nft': 82})], [bar()], fwd=500, back=500)
BAND_LEGS = dict(nt=96, ns=168, nft=168)
ex('band_assisted_pull_up', [pose('nearHand', (0, 0), **{**HANG, **BAND_LEGS}), pose('nearHand', (0, 0), **{**PULL_TOP, **BAND_LEGS})],
   [bar(), band(0, 0, 'nearAnkle')])
ex('negative_pull_up', [pose('nearHand', (0, 0), **PULL_TOP), pose('nearHand', (0, 0), **HANG)], [bar()], fwd=1800, back=650, cover=0)
ex('chin_up', [pose('nearHand', (0, 0), **HANG), pose('nearHand', (0, 0), **{**PULL_TOP, 'nu': 84, 'nf': -96})], [bar()])
ex('pull_up', [pose('nearHand', (0, 0), **HANG), pose('nearHand', (0, 0), **PULL_TOP)], [bar()])
LEGS_OUT = dict(nt=-2, ns=-2, nft=-2)
ex('l_sit_pull_up', [pose('nearHand', (0, 0), **{**HANG, **LEGS_OUT, 'torso': -96}),
                     pose('nearHand', (0, 0), **{**PULL_TOP, **LEGS_OUT, 'torso': -104})], [bar()])
ex('archer_pull_up', [pose('nearHand', (0, 0), **HANG), pose('nearHand', (0, 0), **{**PULL_TOP, 'fu': -35, 'ff': -35})], [bar()])

# ================================================================ ROWS (face up under a low bar)


def row(H, nu, nf, heel_y=C, far=None):
    extra = far or {}
    return solve(lambda phi: pose('nearHand', (0, -H), nu=nu, nf=nf, torso=phi, nt=phi + 180, ns=phi + 180, nft=phi + 270, **extra),
                 -89, 10, Y('nearAnkle'), heel_y, 'row')


ROW_LOW, ROW_TOP = (-90, -90), (128, -58)
ex('high_row', [row(98, *ROW_LOW), row(98, *ROW_TOP)], [FLOOR, low_bar(0, -98)])
ex('australian_row', [row(64, *ROW_LOW), row(64, *ROW_TOP)], [FLOOR, low_bar(0, -64)])
A, B = row(92, *ROW_LOW, heel_y=-40 + C), row(92, *ROW_TOP, heel_y=-40 + C)
tx = pts(A, 'nearAnkle')[0]
ex('elevated_row', [A, B], [FLOOR, low_bar(0, -92), bench(tx - 30, tx + 10, -40)])
ex('archer_row', [row(64, *ROW_LOW), row(64, *ROW_TOP, far=dict(fu=-40, ff=-40))], [FLOOR, low_bar(0, -64)])

# ================================================================ MUSCLE-UP (bar end-on at 0,0)
C2B = dict(nu=96, nf=-76, torso=-106, head=-92, nt=100, ns=104, nft=104)
HIGH = dict(nu=122, nf=8, torso=-96, head=-88, nt=96, ns=100, nft=100)
TRANS = dict(nu=196, nf=72, torso=-58, nt=112, ns=118, nft=118)
TOPSUP = dict(nu=90, nf=90, torso=-78, nt=100, ns=104, nft=104)
ARCH = dict(nu=-88, nf=-88, torso=-84, head=-84, nt=110, ns=118, nft=118)
KIP = dict(nu=-96, nf=-96, torso=-102, nt=58, ns=62, nft=62)


def bp(**a): return pose('nearHand', (0, 0), **a)


ex('chest_to_bar_pull_up', [bp(**HANG), bp(**C2B)], [bar()])
ex('high_pull_up', [bp(**HANG), bp(**HIGH)], [bar()])
ex('muscle_up_negative', [bp(**TOPSUP), bp(**TRANS), bp(**HIGH), bp(**HANG)], [bar()], fwd=900, back=450, cover=0)
ex('kipping_muscle_up', [bp(**ARCH), bp(**KIP), bp(**HIGH), bp(**TRANS), bp(**TOPSUP)], [bar()], fwd=420, back=420)
ex('strict_muscle_up', [bp(**HANG), bp(**C2B), bp(**HIGH), bp(**TRANS), bp(**TOPSUP)], [bar()], fwd=600, back=500)

# ================================================================ SQUAT (near ankle pinned, foot flat)
ANK = (0, -4)
STAND = dict(torso=-90, nt=90, ns=90, nft=3, nu=88, nf=88)
DEEP = dict(torso=-52, head=-62, nt=6, ns=112, nft=3, nu=-4, nf=-4)


def sq(**a): return pose('nearAnkle', ANK, **a)


ex('bodyweight_squat', [sq(**{**STAND, 'nu': 30, 'nf': 30}), sq(**DEEP)], [FLOOR])
B = sq(**{**DEEP, 'nu': 0, 'nf': 0})
P = pts(B, 'nearHand')
A = with_arm('nearAnkle', ANK, {**STAND, 'torso': -88}, 'near', (P[0], P[1] - 46), -1)
B = with_arm('nearAnkle', ANK, DEEP, 'near', P, -1)
ex('assisted_squat', [A, B], [FLOOR, post(P[0] + 3, -150)])
SPLIT_A = dict(torso=-90, nt=76, ns=94, nft=3, ft=112, fs=98, fft=50, nu=92, nf=92)
SPLIT_B = solve(lambda t: sq(torso=-88, nt=t, ns=100, nft=3, ft=97, fs=172, fft=120, nu=96, nf=96), -10, 60, Y('farKnee'), -5, 'split')
ex('split_squat', [sq(**SPLIT_A), SPLIT_B], [FLOOR])
# Bulgarian: rear foot on a bench behind
BA = sq(torso=-88, nt=80, ns=94, nft=3, ft=120, fs=150, fft=150, nu=92, nf=92)
BB = sq(torso=-80, nt=6, ns=104, nft=3, ft=104, fs=175, fft=175, nu=96, nf=96)
bx = min(pts(BA, 'farToe')[0], pts(BB, 'farToe')[0])
by = max(pts(BA, 'farToe')[1], pts(BB, 'farToe')[1])
ex('bulgarian_split_squat', [BA, BB], [FLOOR, bench(bx - 22, bx + 14, by + 3)])
# Cossack: seen from the front
ex('cossack_squat', [sq(torso=-90, nt=66, ns=96, nft=3, ft=118, fs=118, fft=200, nu=60, nf=-30),
                     sq(torso=-74, head=-84, nt=-8, ns=98, nft=3, ft=170, fs=170, fft=-90, nu=40, nf=-40)], [FLOOR])
# Shrimp: rear foot held behind, rear knee lowered to the floor
SA = dict(torso=-90, nt=90, ns=90, nft=3, ft=96, fs=200, fft=200, nu=60, nf=-10)
A = with_arm('nearAnkle', ANK, SA, 'far', None or (0, 0), 1) if False else None
A0 = sq(**SA)
A = with_arm('nearAnkle', ANK, SA, 'far', pts(A0, 'farAnkle'), -1)
SB = solve(lambda t: sq(torso=-48, head=-60, nt=t, ns=116, nft=3, ft=112, fs=192, fft=192, nu=10, nf=10), -10, 60, Y('farKnee'), C, 'shrimp')
B = with_arm('nearAnkle', ANK, {**SB['angles']}, 'far', pts(SB, 'farAnkle'), -1)
ex('shrimp_squat', [A, B], [FLOOR])
PIS_B = dict(torso=-58, head=-66, nt=4, ns=112, nft=3, ft=-4, fs=-4, fft=-94, nu=0, nf=0)
B0 = sq(**PIS_B)
P = pts(B0, 'nearHand')
B = with_arm('nearAnkle', ANK, PIS_B, 'near', P, -1)
A = with_arm('nearAnkle', ANK, dict(torso=-90, nt=90, ns=90, nft=3, ft=-14, fs=-14, fft=-104), 'near', (P[0], P[1] - 52), -1)
ex('assisted_pistol_squat', [A, B], [FLOOR, post(P[0] + 3, -150)])
ex('pistol_squat', [sq(torso=-90, nt=90, ns=90, nft=3, ft=-14, fs=-14, fft=-104, nu=4, nf=4), sq(**PIS_B)], [FLOOR])

# ================================================================ HINGE (lying face up, head to the right)


def bridge(nt, ns=95, nft=180, far=None, neck_y=-9):
    extra = far or {}
    return solve(lambda t: pose('nearAnkle', ANK, nt=nt, ns=ns, nft=nft, torso=t, head=0, nu=178, nf=178, **extra),
                 -40, 60, Y('neck'), neck_y, 'bridge')


ex('glute_bridge', [bridge(228), bridge(201)], [FLOOR])
ex('single_leg_glute_bridge', [bridge(228, far=dict(ft=228, fs=228, fft=228)), bridge(201, far=dict(ft=201, fs=201, fft=201))], [FLOOR])
SL_A = solve(lambda t: pose('nearAnkle', ANK, nt=t, ns=t, nft=t + 90, torso=t - 180, head=0, nu=178, nf=178), 150, 179, Y('neck'), -9, 'slide')
ex('hamstring_slide_curl', [SL_A, bridge(201, nft=185)], [FLOOR, pad(pts(SL_A, 'nearAnkle')[0], -2, 14, 4)], fwd=900, back=900)
KNEE = (0, C)
UPRIGHT = dict(nt=90, ns=180, nft=250, torso=-90, nu=72, nf=-62)


def nordic(lean, arms):
    return pose('nearKnee', KNEE, nt=90 + lean, ns=180, nft=250, torso=-90 + lean, head=-90 + lean, nu=arms[0], nf=arms[1])


A = nordic(0, (72, -62))
ank = pts(A, 'nearAnkle')
NPAD = pad(ank[0] - 2, ank[1] - 9, 12, 9)
ex('nordic_curl_negative', [A, nordic(62, (62, 62))], [FLOOR, NPAD], fwd=2000, back=700)
ex('nordic_curl', [A, nordic(74, (78, 78))], [FLOOR, NPAD], fwd=1200, back=900)

# ================================================================ CORE
LIE = dict(torso=0, head=0, nu=178, nf=178)
HIP_DOWN = (0, -8)
ex('lying_knee_raise', [pose('hip', HIP_DOWN, **LIE, nt=206, ns=168, nft=168), pose('hip', HIP_DOWN, **LIE, nt=272, ns=182, nft=182)], [FLOOR])
ex('lying_leg_raise', [pose('hip', HIP_DOWN, **LIE, nt=186, ns=186, nft=186), pose('hip', HIP_DOWN, **LIE, nt=272, ns=272, nft=272)], [FLOOR])
ex('hanging_knee_raise', [bp(**{**HANG, 'nt': 90, 'ns': 90, 'nft': 90}), bp(**{**HANG, 'torso': -94, 'nt': -28, 'ns': 82, 'nft': 82})], [bar()])
ex('hanging_leg_raise', [bp(**{**HANG, 'nt': 90, 'ns': 90, 'nft': 90}), bp(**{**HANG, 'torso': -98, 'nt': -6, 'ns': -6, 'nft': -6})], [bar()])
T2B = dict(nu=-82, nf=-84, torso=-128, head=-110, nt=-70, ns=-70, nft=-70)
ex('toes_to_bar', [bp(**{**HANG, 'nt': 90, 'ns': 90, 'nft': 90}), bp(**T2B)], [bar()])

ELB = (0, -5)


def plank(contact, **legs):
    return solve(lambda phi: pose('nearElbow', ELB, nu=90, nf=0, torso=phi, nt=phi + 180, **legs, **({} if 'ns' in legs else {'ns': phi + 180})),
                 -50, 10, Y(contact), C, 'plank')


ex('knee_plank', [plank('nearKnee', ns=184, nft=184)], [FLOOR])
ex('plank', [plank('nearToe')], [FLOOR])
SP = solve(lambda phi: pose('nearElbow', ELB, nu=90, nf=4, fu=-90, ff=-90, torso=phi, nt=phi + 180, ns=phi + 180, nft=phi + 180),
           -50, 10, Y('nearAnkle'), -5, 'side_plank')
ex('side_plank', [SP], [FLOOR])
ex('hollow_body_hold', [pose('hip', (0, -6), torso=-14, head=-14, nu=-12, nf=-12, nt=196, ns=196, nft=196)], [FLOOR])

# L-sit family: hands on the floor beside the hips
LS = dict(nu=90, nf=90, torso=-92)


def ls(**a): return pose('nearHand', HAND, **{**LS, **a})


FS = solve(lambda t: ls(nt=t, ns=t, nft=t - 90), -10, 30, Y('nearAnkle'), C, 'fs_lsit')
ex('foot_supported_l_sit', [FS], [FLOOR])
ex('tuck_l_sit', [ls(torso=-96, nt=-42, ns=46, nft=46)], [FLOOR])
ex('one_leg_l_sit', [ls(torso=-96, nt=-2, ns=-2, nft=-2, ft=-42, fs=46, fft=46)], [FLOOR])
ex('l_sit', [ls(torso=-96, nt=-3, ns=-3, nft=-3)], [FLOOR])
ex('v_sit', [ls(nu=78, nf=78, torso=-124, head=-104, nt=-48, ns=-48, nft=-48)], [FLOOR])

# Dragon flag: shoulders on a bench, hands gripping it behind the head
BENCH_Y = -40
SH = (0, BENCH_Y - 7)
GRIP = (22, BENCH_Y + C)


def flag(**a):
    return with_arm('shoulder', SH, {'head': 0, **a}, 'near', GRIP, 1)


ex('tuck_dragon_flag', [flag(torso=18, nt=-58, ns=190, nft=190), flag(torso=72, nt=-118, ns=165, nft=165)], [FLOOR, bench(-95, 32, BENCH_Y)])
FL_LOW = dict(torso=4, nt=184, ns=184, nft=184)
FL_HIGH = dict(torso=42, nt=222, ns=222, nft=222)
ex('dragon_flag_negative', [flag(**FL_HIGH), flag(**FL_LOW)], [FLOOR, bench(-95, 32, BENCH_Y)], fwd=1900, back=800, cover=0)
ex('dragon_flag', [flag(**FL_LOW), flag(**FL_HIGH)], [FLOOR, bench(-95, 32, BENCH_Y)], fwd=900, back=900)

# ================================================================ HANDSTAND
ex('crow_pose', [pose('nearHand', HAND, nu=72, nf=108, torso=28, head=22, nt=36, ns=172, nft=172)], [FLOOR])
WB = pose('nearHand', (16, C), **STRAIGHT_HS)
WX = min(pts(WB, k)[0] for k in ('nearToe', 'nearAnkle', 'hip', 'neck', 'head')) - 12
WA = solve(lambda phi: pose('nearHand', (112, C), nu=96, nf=96, torso=phi, nt=phi + 180, ns=phi + 180, nft=phi + 90), -20, 70, X('nearToe'), WX + 4, 'wall_walk')
MID = solve(lambda t: pose('nearHand', (58, C), nu=98, nf=98, torso=t, nt=t + 180, ns=t + 180, nft=t + 180), 30, 89, X('nearToe'), WX + 4, 'wall_walk mid')
ex('wall_walk', [WA, MID, WB], [FLOOR, wall(WX)], fwd=900, back=700)
CW = pose('nearHand', HAND, **{**STRAIGHT_HS, 'torso': 92, 'nt': 272, 'ns': 272, 'nft': 272})
ex('chest_to_wall_handstand', [CW], [FLOOR, wall(max(pts(CW, k)[0] for k in ('nearToe', 'neck', 'hip')) + 8)])
KICK = solve(lambda t: pose('nearHand', HAND, nu=94, nf=94, torso=40, head=70, nt=222, ns=222, nft=222, ft=t, fs=t, fft=t - 70),
             60, 200, Y('farToe'), C, 'kick')
ex('handstand_kick_up', [KICK, pose('nearHand', HAND, **STRAIGHT_HS)], [FLOOR], fwd=650, back=650)
ex('freestanding_handstand', [pose('nearHand', HAND, **STRAIGHT_HS)], [FLOOR])

# ================================================================ PLANCHE
ex('planche_lean', [floor_line(118, 118, label='lean')], [FLOOR])
ex('tuck_planche', [pose('nearHand', HAND, nu=104, nf=104, torso=4, head=8, nt=48, ns=186, nft=186)], [FLOOR])
ex('advanced_tuck_planche', [pose('nearHand', HAND, nu=108, nf=108, torso=0, head=6, nt=94, ns=182, nft=182)], [FLOOR])
ex('straddle_planche', [pose('nearHand', HAND, nu=111, nf=111, torso=3, head=8, nt=184, ns=184, nft=184, ft=172, fs=172, fft=172)], [FLOOR])
ex('full_planche', [pose('nearHand', HAND, nu=113, nf=113, torso=3, head=8, nt=183, ns=183, nft=183)], [FLOOR])

# ================================================================ FRONT LEVER (face up below the bar)
FLA = dict(nu=250, nf=250, torso=0, head=0)
ex('tuck_front_lever', [bp(**FLA, nt=-62, ns=182, nft=182)], [bar()])
ex('advanced_tuck_front_lever', [bp(**FLA, nt=-92, ns=180, nft=180)], [bar()])
ex('one_leg_front_lever', [bp(**FLA, nt=180, ns=180, nft=180, ft=-92, fs=180, fft=180)], [bar()])
ex('straddle_front_lever', [bp(**FLA, nt=176, ns=176, nft=176, ft=188, fs=188, fft=188)], [bar()])
ex('front_lever', [bp(**FLA, nt=180, ns=180, nft=180)], [bar()])


# ================================================================ output
def main():
    root = os.path.join(os.path.dirname(__file__), '..')
    seed = json.load(open(os.path.join(root, 'assets', 'data', 'exercises.json'), encoding='utf-8'))
    ids = [e['id'] for e in seed['exercises']]
    missing = [i for i in ids if i not in E]
    extra = [i for i in E if i not in ids]
    assert not missing and not extra, (missing, extra)
    out = {'version': 1, 'lengths': {k: v for k, v in L.items()}, 'illustrations': {}}
    for i in ids:
        e = E[i]
        out['illustrations'][i] = {
            'hold': e['hold'], 'forward': e['forward'], 'back': e['back'], 'cover': e['cover'], 'props': e['props'],
            'poses': [{'anchor': p['anchor'], 'at': p['at'], 'angles': p['angles']} for p in e['poses']],
        }
    with open(os.path.join(root, 'assets', 'data', 'illustrations.json'), 'w', encoding='utf-8') as f:
        json.dump(out, f, separators=(',', ':'))
    for w in WARN:
        print('WARN', w)
    print(len(out['illustrations']), 'illustrations')
    if len(sys.argv) > 1:
        preview(ids, seed, sys.argv[1])


def preview(ids, seed, path):
    from PIL import Image, ImageDraw
    names = {e['id']: e['name']['en'] for e in seed['exercises']}
    cw, ch, cols = 230, 170, 8
    rows = (len(ids) + cols - 1) // cols
    img = Image.new('RGB', (cw * cols, ch * rows), (14, 15, 18))
    dr = ImageDraw.Draw(img)
    for n, i in enumerate(ids):
        e = E[i]
        ox, oy = (n % cols) * cw, (n // cols) * ch
        xs, ys = [], []
        for p in e['poses']:
            for k, v in p['pts'].items():
                xs.append(v[0]); ys.append(v[1])
        for pr in e['props']:
            for k in ('x', 'x1', 'x2'):
                if k in pr: xs.append(pr[k])
            for k in ('y',):
                if k in pr: ys.append(pr[k])
        x0, x1, y0, y1 = min(xs) - 15, max(xs) + 15, min(ys) - 15, max(ys) + 8
        s = min((cw - 10) / (x1 - x0), (ch - 26) / (y1 - y0))
        T = lambda p: (ox + 5 + (p[0] - x0) * s, oy + 20 + (p[1] - y0) * s)
        for pr in e['props']:
            t, c = pr['type'], (90, 98, 110)
            if t == 'floor': dr.line([T((x0, pr['y'])), T((x1, pr['y']))], fill=c, width=2)
            if t == 'wall': dr.line([T((pr['x'], 0)), T((pr['x'], y0))], fill=c, width=4)
            if t == 'bar':
                q = T((pr['x'], pr['y'])); dr.ellipse([q[0] - 4, q[1] - 4, q[0] + 4, q[1] + 4], fill=c); dr.line([q, (q[0], oy + 18)], fill=c, width=2)
            if t == 'lowBar' or t == 'post':
                q = T((pr['x'], pr['y'])); dr.line([q, T((pr['x'], 0))], fill=c, width=3); dr.ellipse([q[0] - 4, q[1] - 4, q[0] + 4, q[1] + 4], fill=c)
            if t == 'bench':
                dr.rectangle([T((pr['x1'], pr['y'])), T((pr['x2'], pr['y'] + 6))], fill=c)
                dr.line([T((pr['x1'] + 6, pr['y'])), T((pr['x1'] + 6, 0))], fill=c, width=3); dr.line([T((pr['x2'] - 6, pr['y'])), T((pr['x2'] - 6, 0))], fill=c, width=3)
            if t == 'dipBars':
                dr.line([T((pr['x1'], pr['y'])), T((pr['x2'], pr['y']))], fill=c, width=4)
                for xx in (pr['x1'], pr['x2']): dr.line([T((xx, pr['y'])), T((xx, pr['floor']))], fill=c, width=3)
            if t == 'pad': dr.rectangle([T((pr['x'] - pr['w'] / 2, pr['y'] - pr['h'] / 2)), T((pr['x'] + pr['w'] / 2, pr['y'] + pr['h'] / 2))], fill=c)
            if t == 'band':
                for p in e['poses']:
                    dr.line([T((pr['x'], pr['y'])), T(p['pts'][pr['to']])], fill=(255, 138, 61), width=1)
        np = len(e['poses'])
        for j, p in enumerate(e['poses']):
            col = (242, 244, 247) if j == np - 1 else ((90, 98, 110) if j == 0 else (0, 160, 200))
            P = {k: T(v) for k, v in p['pts'].items()}
            w = max(2, int(5 * s))
            far = tuple(int(c * 0.55) for c in col)
            for a, b in (('shoulder', 'farElbow'), ('farElbow', 'farHand'), ('hip', 'farKnee'), ('farKnee', 'farAnkle'), ('farAnkle', 'farToe')):
                dr.line([P[a], P[b]], fill=far, width=w)
            for a, b in (('hip', 'neck'), ('hip', 'nearKnee'), ('nearKnee', 'nearAnkle'), ('nearAnkle', 'nearToe'), ('shoulder', 'nearElbow'), ('nearElbow', 'nearHand')):
                dr.line([P[a], P[b]], fill=col, width=w)
            r = L['head'] * s
            dr.ellipse([P['head'][0] - r, P['head'][1] - r, P['head'][0] + r, P['head'][1] + r], fill=col)
        dr.text((ox + 4, oy + 3), f'{n + 1}. {names[i]}', fill=(198, 255, 61))
    img.save(path)


if __name__ == '__main__':
    main()
