"""Author the 12 Soft calibration icons from Soft primitives.

Native 12 / 16 / 24 masters. Outline and filled. No Angular path reuse.
"""
from __future__ import annotations

import math

from shapely import affinity

from source.primitives import (
    circle, clean, polygon, polyline_capsule, ring, round_all, round_convex,
    rounded_rect, stadium_line, union,
)
from source.seams import (
    ACUTE_JOIN, BOLD_WIDTH, CANONICAL_IDS, CORNER_TOKEN, MASTERS, OUTLINE_WIDTH,
    PADDING, STAR_JOIN, UnknownAppearanceError, UnknownIconError, UnknownMasterError,
)


def _tokens(n: int, appearance: str):
    if n not in MASTERS:
        raise UnknownMasterError(f'No native Soft master {n}')
    if appearance not in ('outline', 'filled'):
        raise UnknownAppearanceError(f'Unknown appearance {appearance!r}')
    w = OUTLINE_WIDTH[n]
    t = w if appearance == 'outline' else BOLD_WIDTH[n]
    return w, t, PADDING[n], appearance == 'outline', CORNER_TOKEN[n], ACUTE_JOIN[n]


def _doorway(shape, door, w, outlined):
    door = door.intersection(shape)
    if door.is_empty:
        raise ValueError('door missed the house')
    if not outlined:
        return shape.difference(door)
    shell = ring(shape, w)
    arch = door.buffer(w, quad_segs=8, cap_style=1, join_style=1).difference(door)
    return union(shell, arch).intersection(shape).difference(door)


def _home(n, appearance):
    w, t, p, outlined, R, acute = _tokens(n, appearance)
    if n == 12:
        roof = round_convex(polygon([(6, 1.15), (11.05, 5.85), (0.95, 5.85)]), acute)
        body = rounded_rect(1.35, 5.15, 10.65, 11, R)
        door = rounded_rect(4.9, 8.35, 7.1, 11.12, 0.65)
    elif n == 16:
        # Narrower, lower door so the 16 outline still reads as a house, not an arch.
        roof = round_convex(polygon([(8, 1.35), (14.9, 7.7), (1.1, 7.7)]), acute)
        body = rounded_rect(2.0, 6.9, 14.0, 14.5, R)
        door = rounded_rect(7.05, 11.7, 8.95, 14.62, 0.7)
    else:
        roof = round_convex(polygon([(12, 1.85), (22.2, 11.3), (1.8, 11.3)]), acute)
        body = rounded_rect(3.9, 10.0, 20.1, 22.0, R)
        door = rounded_rect(9.85, 15.4, 14.15, 22.18, 1.35)
    shape = union(roof, body)
    return _doorway(shape, door, w, outlined)


def _search(n, appearance):
    w, t, p, outlined, R, acute = _tokens(n, appearance)
    if n == 12:
        cx, cy, ro, end = 4.55, 4.55, 3.55, (10.45, 10.45)
    elif n == 16:
        cx, cy, ro, end = 6.15, 6.15, 4.85, (14.35, 14.35)
    else:
        cx, cy, ro, end = 9.15, 9.15, 7.15, (21.2, 21.2)
    lens = circle(cx, cy, ro)
    hole = circle(cx, cy, ro - t)
    start = (cx + (ro - t * 0.15) * 0.68, cy + (ro - t * 0.15) * 0.68)
    handle = stadium_line(start[0], start[1], end[0], end[1], t)
    return union(lens.difference(hole), handle.difference(hole))


def _plus(n, appearance):
    w, t, p, outlined, R, acute = _tokens(n, appearance)
    c = n / 2
    r = t / 2
    # Endpoints sit inset by the cap radius so the capsule stays on the pad.
    return union(
        stadium_line(c, p + r, c, n - p - r, t),
        stadium_line(p + r, c, n - p - r, c, t),
    )


def _arrow_right(n, appearance):
    w, t, p, outlined, R, acute = _tokens(n, appearance)
    c = n / 2
    if n == 12:
        # Longer chevron so filled 2 px round joins still read as a tip, not a blob.
        shaft = stadium_line(1.4, c, 6.0, c, t)
        head = polyline_capsule([(4.15, 2.35), (10.7, c), (4.15, 9.65)], t)
    elif n == 16:
        shaft = stadium_line(2.0, c, 10.4, c, t)
        head = polyline_capsule([(6.6, 3.05), (13.7, c), (6.6, 12.95)], t)
    else:
        shaft = stadium_line(3.0, c, 16.2, c, t)
        head = polyline_capsule([(10.6, 4.8), (20.2, c), (10.6, 19.2)], t)
    return union(shaft, head)


def _user(n, appearance):
    w, t, p, outlined, R, acute = _tokens(n, appearance)
    if n == 12:
        head = circle(6.0, 3.35, 2.2)
        body = rounded_rect(1.2, 6.55, 10.8, 11.0, R)
    elif n == 16:
        head = circle(8.0, 4.45, 2.85)
        body = rounded_rect(1.7, 8.7, 14.3, 14.5, R)
    else:
        head = circle(12.0, 6.55, 4.15)
        body = rounded_rect(3.4, 12.7, 20.6, 22.0, 4.5)
    if outlined:
        return union(ring(head, w), ring(body, w))
    return union(head, body)


def _file(n, appearance):
    w, t, p, outlined, R, acute = _tokens(n, appearance)
    if n == 12:
        # Moderate dog-ear: large enough to read as a fold after CORNER_TOKEN,
        # small enough that the page does not become a pentagon-tag.
        shape = round_convex(
            polygon([(1.4, 1.2), (7.45, 1.2), (10.7, 4.45), (10.7, 10.8), (1.4, 10.8)]),
            R)
        fold = (7.65, 1.4, 10.5, 4.25)
        mark = None
    elif n == 16:
        shape = round_convex(
            polygon([(2.0, 1.5), (10.05, 1.5), (14.35, 5.8), (14.35, 14.5), (2.0, 14.5)]),
            R)
        fold = (10.2, 1.7, 14.15, 5.65)
        mark = None
    else:
        shape = round_convex(
            polygon([(3.9, 2.0), (15.15, 2.0), (20.15, 7.0), (20.15, 22.0), (3.9, 22.0)]),
            R)
        fold = (15.35, 2.25, 19.9, 6.8)
        mark = rounded_rect(8.0, 13.1, 16.0, 15.1, 1.0)
    crease = stadium_line(*fold, w).intersection(shape)
    if outlined:
        g = union(ring(shape, w), crease)
        return union(g, mark) if mark is not None else g
    return shape.difference(mark) if mark is not None else shape


def _calendar(n, appearance):
    w, t, p, outlined, R, acute = _tokens(n, appearance)
    if n == 12:
        body = rounded_rect(1.15, 3.15, 10.85, 11.0, R)
        tabs = union(
            stadium_line(3.5, 1.35, 3.5, 4.2, 1.35),
            stadium_line(8.5, 1.35, 8.5, 4.2, 1.35),
        )
        marks = rounded_rect(4.85, 6.35, 7.15, 8.55, 0.7)
    elif n == 16:
        body = rounded_rect(1.7, 4.15, 14.3, 14.5, R)
        tabs = union(
            stadium_line(4.7, 1.7, 4.7, 5.5, 1.8),
            stadium_line(11.3, 1.7, 11.3, 5.5, 1.8),
        )
        marks = union(
            rounded_rect(4.7, 8.15, 7.15, 10.5, 0.85),
            rounded_rect(8.85, 8.15, 11.3, 10.5, 0.85),
        )
    else:
        body = rounded_rect(3.0, 5.2, 21.0, 21.5, R)
        tabs = union(
            stadium_line(7.5, 2.2, 7.5, 7.2, 2.6),
            stadium_line(16.5, 2.2, 16.5, 7.2, 2.6),
        )
        marks = union(
            rounded_rect(7.0, 12.0, 10.3, 15.2, 1.15),
            rounded_rect(13.7, 12.0, 17.0, 15.2, 1.15),
        )
    if outlined:
        return union(ring(body, w), tabs, marks)
    return union(body, tabs).difference(marks)


def _sliders(n, appearance):
    w, t, p, outlined, R, acute = _tokens(n, appearance)
    if n == 12:
        controls, d, pad = [(3.5, 3.5), (8.5, 8.5)], 3.0, 1.0
    elif n == 16:
        controls, d, pad = [(5.0, 4.5), (11.0, 11.5)], 4.5, 1.6
    else:
        controls, d, pad = [(8.0, 7.0), (16.0, 17.0)], 6.0, 2.5
    parts = []
    for x, y in controls:
        knob = circle(x, y, d / 2)
        rail = stadium_line(pad + w / 2, y, n - pad - w / 2, y, w).difference(knob)
        parts.append(rail)
        parts.append(ring(knob, w) if outlined else knob)
    return union(*parts)


def _warning(n, appearance):
    w, t, p, outlined, R, acute = _tokens(n, appearance)
    if n == 12:
        shape = round_convex(polygon([(6.0, 1.25), (11.15, 10.8), (0.85, 10.8)]), R)
        stem = stadium_line(6.0, 4.85, 6.0, 6.55, 0.9)
        dot = circle(6.0, 8.35, 0.55)
    elif n == 16:
        shape = round_convex(polygon([(8.0, 1.45), (14.9, 14.4), (1.1, 14.4)]), R)
        stem = stadium_line(8.0, 6.05, 8.0, 8.85, 1.15)
        dot = circle(8.0, 11.15, 0.85)
    else:
        shape = round_convex(polygon([(12.0, 2.0), (22.2, 21.45), (1.8, 21.45)]), R)
        stem = stadium_line(12.0, 8.4, 12.0, 12.6, 1.55)
        dot = circle(12.0, 16.15, 1.1)
    marks = union(stem, dot)
    if outlined:
        return union(ring(shape, w), marks)
    return shape.difference(marks)


def _chain_link(cx, cy, length, thick, stroke, angle):
    r = thick / 2
    outer = rounded_rect(cx - length / 2, cy - r, cx + length / 2, cy + r, r)
    inner_len = length - 2 * stroke
    inner_th = thick - 2 * stroke
    if inner_len <= 0.8 or inner_th <= 0.8:
        raise ValueError('chain link hole collapsed')
    ir = inner_th / 2
    inner = rounded_rect(cx - inner_len / 2, cy - ir, cx + inner_len / 2, cy + ir, ir)
    g = outer.difference(inner)
    return affinity.rotate(g, angle, origin=(cx, cy))


def _link(n, appearance):
    w, t, p, outlined, R, acute = _tokens(n, appearance)
    if n == 12:
        # Diagonal interlocking rings: horizontal pair read as infinity/peanut.
        r_out = 2.95
        a = ring(circle(3.85, 5.2, r_out), t)
        b = ring(circle(8.15, 6.8, r_out), t)
        return union(a, b)
    if n == 16:
        a = _chain_link(5.4, 8.0, 9.8, 6.4, t, 32)
        b = _chain_link(10.6, 8.0, 9.8, 6.4, t, -32)
    else:
        a = _chain_link(8.15, 12.0, 15.2, 9.2, t, 36)
        b = _chain_link(15.85, 12.0, 15.2, 9.2, t, -36)
    return union(a, b)


def _branch(n, appearance):
    w, t, p, outlined, R, acute = _tokens(n, appearance)
    if n == 12:
        r = 1.55
        left, top, bot = (2.7, 6.0), (9.3, 2.7), (9.3, 9.3)
        jx = 6.0
    elif n == 16:
        r = 2.15
        left, top, bot = (3.6, 8.0), (12.4, 3.6), (12.4, 12.4)
        jx = 8.0
    else:
        r = 3.05
        left, top, bot = (5.1, 12.0), (18.9, 5.1), (18.9, 18.9)
        jx = 12.0
    nodes = [circle(*left, r), circle(*top, r), circle(*bot, r)]
    rails = polyline_capsule(
        [(left[0] + r, left[1]), (jx, left[1]), (jx, top[1]), (top[0] - r, top[1])], w)
    rails = union(rails, polyline_capsule([(jx, left[1]), (jx, bot[1]), (bot[0] - r, bot[1])], w))
    node_union = union(*nodes)
    rails = rails.difference(node_union)
    drawn_nodes = [ring(nd, w) if outlined else nd for nd in nodes]
    return union(rails, *drawn_nodes)


def _star(n, appearance):
    w, t, p, outlined, R, acute = _tokens(n, appearance)
    c = n / 2
    rr = STAR_JOIN[n]
    if n == 12:
        r_out, r_in, cy = 5.5, 2.5, 6.1
    elif n == 16:
        r_out, r_in, cy = 7.3, 3.35, 8.15
    else:
        r_out, r_in, cy = 10.9, 5.1, 12.2
    pts = []
    for i in range(10):
        r = r_out if i % 2 == 0 else r_in
        a = -math.pi / 2 + i * math.pi / 5
        pts.append((c + r * math.cos(a), cy + r * math.sin(a)))
    shape = round_all(polygon(pts), rr)
    return ring(shape, w) if outlined else shape


_DRAWERS = {
    'home': _home,
    'search': _search,
    'plus': _plus,
    'arrow-right': _arrow_right,
    'user': _user,
    'file': _file,
    'calendar': _calendar,
    'sliders': _sliders,
    'warning': _warning,
    'link': _link,
    'branch': _branch,
    'star': _star,
}


def draw(icon_id: str, master: int, appearance: str):
    """Return Shapely geometry for one Soft drawing. Raises on unknown inputs."""
    if icon_id not in CANONICAL_IDS:
        raise UnknownIconError(f'Unknown Soft icon {icon_id!r}')
    if icon_id not in _DRAWERS:
        raise UnknownIconError(f'Soft icon {icon_id!r} is not drawn in this pilot')
    g = clean(_DRAWERS[icon_id](master, appearance))
    if g is None or g.is_empty or not g.is_valid:
        raise ValueError(f'Invalid geometry {icon_id}/{appearance}/{master}')
    minx, miny, maxx, maxy = g.bounds
    if minx < -1e-6 or miny < -1e-6 or maxx > master + 1e-6 or maxy > master + 1e-6:
        raise ValueError(
            f'Artwork outside canvas {icon_id}/{appearance}/{master}: {g.bounds}')
    return g
