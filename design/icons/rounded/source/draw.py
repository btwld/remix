"""Author the Rounded icons from Rounded primitives, and dispatch every concept.

Native 12 / 16 / 24 masters. Outline and filled. No Outline path reuse. The calibration drawings
that set the grammar stay here; the other concepts live in source/glyphs/, grouped by construction.
"""
from __future__ import annotations

import math

from shapely import affinity, set_precision
from shapely.geometry import box

from source.glyphs import direction, frames, marks, objects
from source.glyphs.kit import tokens as _tokens
from source.primitives import (
    circle, clean, polygon, polyline_capsule, ring, round_all, round_convex,
    rounded_hull, rounded_rect, stadium_line, union,
)
from source.seams import (
    CANONICAL_IDS, CUT_JOIN, FONT_EXACT_GRID, FONT_EXACT_MASTERS, GAP_TARGET, LINK_BOLD_WIDTH, QUAD_SEGS,
    STAR_JOIN, UnknownIconError,
)


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
    # One rounded pentagon: acute gable, softer shoulders, CORNER_TOKEN feet.
    if n == 12:
        x0, x1, top, shoulder, bottom = 1.0, 11.0, 1.0, 5.1, 11.0
        door = rounded_rect(5.0, 8.0, 7.0, 11.12, 0.65)
    elif n == 16:
        # Narrower, lower door so the 16 outline still reads as a house, not an arch.
        x0, x1, top, shoulder, bottom = 2.0, 14.0, 1.5, 6.9, 14.5
        door = rounded_rect(7.0, 11.5, 9.0, 14.62, 0.7)
    else:
        x0, x1, top, shoulder, bottom = 3.0, 21.0, 2.0, 10.3, 22.0
        door = rounded_rect(10.0, 15.0, 14.0, 22.18, 1.35)
    c = n / 2
    shape = rounded_hull(
        (c, top + acute, acute),
        (x0 + acute, shoulder, acute),
        (x1 - acute, shoulder, acute),
        (x0 + R, bottom - R, R),
        (x1 - R, bottom - R, R),
    )
    return round_convex(_doorway(shape, door, w, outlined), CUT_JOIN[n])


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


def _user(n, appearance):
    w, t, p, outlined, R, acute = _tokens(n, appearance)
    # Dome torso: broad shoulder circles over small base corners.
    if n == 12:
        head = circle(6.0, 3.3, 2.2)
        x0, x1, top, bottom, shoulder = 2.0, 10.0, 6.5, 11.0, 2.2
    elif n == 16:
        head = circle(8.0, 4.45, 2.85)
        x0, x1, top, bottom, shoulder = 2.5, 13.5, 8.8, 14.5, 2.8
    else:
        head = circle(12.0, 6.55, 4.15)
        x0, x1, top, bottom, shoulder = 4.0, 20.0, 12.7, 22.0, 4.6
    body = rounded_hull(
        (x0 + shoulder, top + shoulder, shoulder),
        (x1 - shoulder, top + shoulder, shoulder),
        (x0 + acute, bottom - acute, acute),
        (x1 - acute, bottom - acute, acute),
    )
    if outlined:
        return union(ring(head, w), ring(body, w))
    return union(head, body)


def _file(n, appearance):
    w, t, p, outlined, R, acute = _tokens(n, appearance)
    # A page taller than wide. fold is the leg of the turned-down corner.
    if n == 12:
        x0, x1, y0, y1, fold = 2.0, 10.0, 1.0, 11.0, 3.25
        lines = ()
    elif n == 16:
        x0, x1, y0, y1, fold = 2.5, 13.5, 1.5, 14.5, 4.25
        lines = ()
    else:
        x0, x1, y0, y1, fold = 4.0, 20.0, 2.0, 22.0, 6.0
        # Two unequal left-aligned lines, so the page does not read as file-minus.
        lines = ((9.0, 15.0, 12.75), (9.0, 12.5, 16.75))
    tangent = acute * math.tan(math.pi / 8)
    fx, fy = x1 - fold, y0 + fold
    shape = rounded_hull(
        (x0 + R, y0 + R, R),
        (fx - tangent, y0 + acute, acute),
        (x1 - acute, fy + tangent, acute),
        (x1 - R, y1 - R, R),
        (x0 + R, y1 - R, R),
    )
    crease = [(fx, y0 - w), (fx, fy), (x1 + w, fy)]
    marks = [stadium_line(a, y, b, y, w) for a, b, y in lines]
    if outlined:
        # The turned-down corner is solid: as a counter it would be a sub-pixel pocket.
        ear = union(polygon(crease), polyline_capsule(crease, w)).intersection(shape)
        return union(ring(shape, w), ear, *marks)
    page = round_convex(shape.difference(polyline_capsule(crease, GAP_TARGET[n])), CUT_JOIN[n])
    return page.difference(union(*marks)) if marks else page


def _calendar(n, appearance):
    w, t, p, outlined, R, acute = _tokens(n, appearance)
    # Tabs and header rail carry the contour weight. A date row only fits at 24.
    if n == 12:
        x0, x1, y0, y1, tab_x, tab_top, rail_y = 1.0, 11.0, 3.0, 11.0, (3.5, 8.5), 1.0, 5.5
        marks = ()
    elif n == 16:
        x0, x1, y0, y1, tab_x, tab_top, rail_y = 1.5, 14.5, 3.5, 14.5, (4.75, 11.25), 1.5, 7.25
        marks = ()
    else:
        x0, x1, y0, y1, tab_x, tab_top, rail_y = 3.0, 21.0, 5.0, 22.0, (8.0, 16.0), 2.0, 10.0
        marks = tuple(rounded_rect(x, 14.0, x + 2.0, 16.0, 0.7) for x in (7.0, 11.0, 15.0))
    body = rounded_rect(x0, y0, x1, y1, R)
    tabs = [stadium_line(x, tab_top + w / 2, x, y0 + w / 2, w) for x in tab_x]
    rail = box(x0 - 1, rail_y - w / 2, x1 + 1, rail_y + w / 2).intersection(body)
    if outlined:
        return union(ring(body, w), rail, *tabs, *marks)
    return union(round_convex(body.difference(union(rail, *marks)), CUT_JOIN[n]), *tabs)


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
    # The apex circle sits on the top keyline, so its radius recedes nothing.
    # At 12 and 16 the glyph is centred on a pixel column, so the mark paints one solid column.
    if n == 12:
        c, half, top, bottom = 5.5, 5.25, 1.0, 11.0
        stem = stadium_line(c, 5.0, c, 6.5, 1.0)
        dot = circle(c, 8.5, 0.5)
    elif n == 16:
        c, half, top, bottom = 7.5, 6.9, 1.5, 14.5
        stem = stadium_line(c, 7.02, c, 7.975, 1.35)
        dot = circle(c, 10.825, 0.675)
    else:
        c, half, top, bottom = 12.0, 10.2, 2.0, 22.0
        stem = stadium_line(c, 9.9, c, 12.9, 1.8)
        dot = circle(c, 16.9, 1.1)
    shape = rounded_hull(
        (c, top + acute, acute),
        (c - half + acute, bottom - acute, acute),
        (c + half - acute, bottom - acute, acute),
    )
    marks = union(stem, dot)
    if outlined:
        return union(ring(shape, w), marks)
    return shape.difference(marks)


def _chain_link(start, end, centerline_r, t):
    """A closed capsule ring along the x axis."""
    return stadium_line(start, 0, end, 0, 2 * centerline_r + t).difference(
        stadium_line(start, 0, end, 0, 2 * centerline_r - t))


def _link(n, appearance):
    w, t, p, outlined, R, acute = _tokens(n, appearance)
    # Two capsule rings on one 45-degree axis, woven: each crosses over the other once.
    t = w if outlined else LINK_BOLD_WIDTH[n]
    centerline_r, outer, inner = {12: (2.0, 3.54, 0.5), 16: (2.75, 4.24, 0.7), 24: (4.0, 7.07, 1.4)}[n]
    gap = {12: 0.65, 16: 0.9, 24: 1.25}[n]
    a = _chain_link(inner, outer, centerline_r, t)
    b = _chain_link(-outer, -inner, centerline_r, t)
    over_a = a.buffer(gap, quad_segs=QUAD_SEGS).intersection(box(-n, 0, n, n))
    over_b = b.buffer(gap, quad_segs=QUAD_SEGS).intersection(box(-n, -n, n, 0))
    woven = union(
        round_convex(a.difference(over_b), CUT_JOIN[n]),
        round_convex(b.difference(over_a), CUT_JOIN[n]),
    )
    return affinity.translate(affinity.rotate(woven, -45, origin=(0, 0)), n / 2, n / 2)


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
    'user': _user,
    'file': _file,
    'calendar': _calendar,
    'sliders': _sliders,
    'warning': _warning,
    'link': _link,
    'branch': _branch,
    'star': _star,
    **direction.DRAWERS,
    **marks.DRAWERS,
    **frames.DRAWERS,
    **objects.DRAWERS,
}


def draw(icon_id: str, master: int, appearance: str):
    """Return Shapely geometry for one Rounded drawing. Raises on unknown inputs."""
    if icon_id not in CANONICAL_IDS:
        raise UnknownIconError(f'Unknown Rounded icon {icon_id!r}')
    g = clean(_DRAWERS[icon_id](master, appearance))
    if (icon_id, master, appearance) in FONT_EXACT_MASTERS:
        g = set_precision(g, FONT_EXACT_GRID, mode='valid_output')
    if g is None or g.is_empty or not g.is_valid:
        raise ValueError(f'Invalid geometry {icon_id}/{appearance}/{master}')
    minx, miny, maxx, maxy = g.bounds
    if minx < -1e-6 or miny < -1e-6 or maxx > master + 1e-6 or maxy > master + 1e-6:
        raise ValueError(
            f'Artwork outside canvas {icon_id}/{appearance}/{master}: {g.bounds}')
    return g
