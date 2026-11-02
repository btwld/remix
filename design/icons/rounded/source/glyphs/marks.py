"""Open marks and letterforms: weight pairs on shared centerlines, with no enclosing frame."""
from __future__ import annotations

import math

from source.glyphs.kit import reflect_x, reflect_y, stroke, tokens
from source.primitives import circle, polygon, ring, round_all, rounded_hull, rounded_rect, stadium_line, union
from source.seams import CUT_JOIN


# Three rows. The 12 outline rows sit on pixel rows inside the filled 2 px rows.
_ROWS = {
    12: {'outline': (2.5, 5.5, 8.5), 'filled': (3.0, 6.0, 9.0)},
    16: {'outline': (4.0, 8.0, 12.0), 'filled': (4.0, 8.0, 12.0)},
    24: {'outline': (6.0, 12.0, 18.0), 'filled': (6.0, 12.0, 18.0)},
}


def menu(n, appearance):
    w, t, p, outlined, R, acute = tokens(n, appearance)
    return union(*(stadium_line(p + t / 2, y, n - p - t / 2, y, t) for y in _ROWS[n][appearance]))


def more(n, appearance):
    # Three round dots in both styles: a ring this small would close. Filled means larger.
    r, inset = {
        (12, 'outline'): (1.0, 2.0), (12, 'filled'): (1.3, 2.0),
        (16, 'outline'): (1.25, 3.0), (16, 'filled'): (1.6, 3.0),
        (24, 'outline'): (1.75, 5.0), (24, 'filled'): (2.4, 5.0),
    }[(n, appearance)]
    return union(*(circle(x, n / 2, r) for x in (inset, n / 2, n - inset)))


def dot(n, appearance):
    # Solid in both styles and well inside the keyline, so it cannot read as Circle.
    r = {
        (12, 'outline'): 1.5, (12, 'filled'): 2.0,
        (16, 'outline'): 2.0, (16, 'filled'): 2.75,
        (24, 'outline'): 3.0, (24, 'filled'): 4.0,
    }[(n, appearance)]
    return circle(n / 2, n / 2, r)


def minus(n, appearance):
    w, t, p, outlined, R, acute = tokens(n, appearance)
    y = 5.5 if n == 12 and outlined else n / 2
    return stadium_line(p + t / 2, y, n - p - t / 2, y, t)


def check(n, appearance):
    w, t, p, outlined, R, acute = tokens(n, appearance)
    # One asymmetric bend: the long arm rises past the short arm's start.
    return stroke({
        12: [(2.25, 6.25), (4.75, 8.75), (9.75, 3.25)],
        16: [(3.0, 8.375), (6.25, 11.625), (13.0, 4.375)],
        24: [(4.25, 12.75), (9.25, 17.75), (19.75, 6.25)],
    }[n], t)


def close(n, appearance):
    w, t, p, outlined, R, acute = tokens(n, appearance)
    a = {12: 2.5, 16: 3.25, 24: 5.0}[n]
    b = n - a
    return union(stroke([(a, a), (b, b)], t), stroke([(a, b), (b, a)], t))


def activity(n, appearance):
    w, t, p, outlined, R, acute = tokens(n, appearance)
    return stroke({
        12: [(1.5, 6.0), (3.25, 6.0), (4.75, 2.25), (7.25, 9.75), (8.75, 6.0), (10.5, 6.0)],
        16: [(2.25, 8.0), (4.75, 8.0), (6.75, 3.0), (9.25, 13.0), (11.25, 8.0), (13.75, 8.0)],
        24: [(3.0, 12.0), (7.0, 12.0), (10.0, 4.5), (14.0, 19.5), (17.0, 12.0), (21.0, 12.0)],
    }[n], t)


def chart(n, appearance):
    w, t, p, outlined, R, acute = tokens(n, appearance)
    xs, tops, bottom = {
        (12, 'outline'): ((1.5, 5.5, 9.5), (7.5, 4.5, 1.5), 10.5),
        (12, 'filled'): ((2.0, 6.0, 10.0), (8.0, 5.0, 2.0), 10.0),
        (16, 'outline'): ((3.0, 8.0, 13.0), (10.0, 6.0, 2.25), 13.75),
        (16, 'filled'): ((3.0, 8.0, 13.0), (10.0, 6.25, 2.75), 13.25),
        (24, 'outline'): ((5.0, 12.0, 19.0), (14.0, 8.0, 3.0), 21.0),
        (24, 'filled'): ((5.0, 12.0, 19.0), (14.5, 8.5, 3.5), 20.5),
    }[(n, appearance)]
    return union(*(stadium_line(x, top, x, bottom, t) for x, top in zip(xs, tops)))


def pause(n, appearance):
    w, t, p, outlined, R, acute = tokens(n, appearance)
    xs, y0, y1 = {
        (12, 'outline'): ((3.5, 8.5), 2.5, 9.5), (12, 'filled'): ((4.0, 8.0), 3.0, 9.0),
        (16, 'outline'): ((5.0, 11.0), 3.25, 12.75), (16, 'filled'): ((5.0, 11.0), 3.5, 12.5),
        (24, 'outline'): ((8.0, 16.0), 4.0, 20.0), (24, 'filled'): ((8.0, 16.0), 4.5, 19.5),
    }[(n, appearance)]
    return union(*(stadium_line(x, y0, x, y1, t) for x in xs))


# Inner and outer centerline radii, and stroke. Segments stop short of the centre, unlike Sun's disc.
_LOADER = {
    (12, 'outline'): (3.3, 4.5, 1.0), (12, 'filled'): (3.3, 4.25, 1.5),
    (16, 'outline'): (4.6, 5.75, 1.5), (16, 'filled'): (4.6, 5.5, 2.0),
    (24, 'outline'): (6.55, 9.0, 2.0), (24, 'filled'): (6.55, 8.5, 3.0),
}


def loader(n, appearance):
    inner, outer, t = _LOADER[(n, appearance)]
    c = n / 2
    parts = []
    for i in range(8):
        a = math.radians(45 * i - 90)
        parts.append(stadium_line(
            c + inner * math.cos(a), c + inner * math.sin(a),
            c + outer * math.cos(a), c + outer * math.sin(a), t))
    return union(*parts)


def _corner_brackets(n, t, inset, reach, radius):
    top_left = stroke([(inset, inset + reach), (inset, inset), (inset + reach, inset)], t, radius)
    top_right = reflect_x(top_left, n)
    return [top_left, top_right, reflect_y(top_left, n), reflect_y(top_right, n)]


def focus(n, appearance):
    w, t, p, outlined, R, acute = tokens(n, appearance)
    inset, reach, radius, r = {
        (12, 'outline'): (1.5, 2.5, 0.75, 1.1), (12, 'filled'): (2.0, 2.25, 0.9, 1.5),
        (16, 'outline'): (2.25, 3.25, 1.1, 1.5), (16, 'filled'): (2.75, 3.0, 1.25, 2.0),
        (24, 'outline'): (3.0, 5.0, 1.5, 2.25), (24, 'filled'): (3.5, 4.75, 1.75, 3.0),
    }[(n, appearance)]
    return union(*_corner_brackets(n, t, inset, reach, radius), circle(n / 2, n / 2, r))


def group(n, appearance):
    # Selection handles around two objects: an arrange command, never people.
    bracket, inset, reach, radius, a0, a1, b0, b1, r = {
        (12, 'outline'): (1.0, 1.5, 1.75, 0.6, 3.75, 5.5, 6.5, 8.25, 0.55),
        (12, 'filled'): (1.5, 1.75, 1.5, 0.7, 3.75, 5.75, 6.25, 8.25, 0.6),
        (16, 'outline'): (1.5, 2.25, 2.25, 1.0, 5.0, 7.5, 8.5, 11.0, 0.8),
        (16, 'filled'): (2.0, 2.5, 2.0, 1.1, 4.9, 7.6, 8.4, 11.1, 0.85),
        (24, 'outline'): (2.0, 3.0, 4.0, 1.5, 7.5, 11.5, 12.5, 16.5, 1.2),
        (24, 'filled'): (3.0, 3.5, 3.75, 1.75, 7.25, 11.5, 12.5, 16.75, 1.3),
    }[(n, appearance)]
    return union(
        *_corner_brackets(n, bracket, inset, reach, radius),
        rounded_rect(a0, a0, a1, a1, r),
        rounded_rect(b0, b0, b1, b1, r),
    )


# Both chevrons and the slash. The filled strokes stay under the action width at 12 and 16,
# where the full width would leave no room for three parts on the canvas.
_CODE = {
    (12, 'outline'): (1.0, (3.25, 3.0), (1.5, 6.0), (6.75, 2.0), (5.25, 10.0)),
    (12, 'filled'): (1.5, (3.1, 3.25), (1.75, 6.0), (6.35, 2.25), (5.65, 9.75)),
    (16, 'outline'): (1.5, (4.25, 5.0), (2.25, 8.0), (9.0, 2.5), (7.0, 13.5)),
    (16, 'filled'): (2.0, (4.1, 5.0), (2.5, 8.0), (8.6, 3.0), (7.4, 13.0)),
    (24, 'outline'): (2.0, (6.5, 7.0), (3.0, 12.0), (14.0, 3.5), (10.0, 20.5)),
    (24, 'filled'): (3.0, (6.25, 7.5), (3.5, 12.0), (13.25, 4.0), (10.75, 20.0)),
}


def code(n, appearance):
    t, (arm_x, arm_y), apex, top, bottom = _CODE[(n, appearance)]
    left = stroke([(arm_x, arm_y), apex, (arm_x, n - arm_y)], t)
    return union(left, reflect_x(left, n), stroke([top, bottom], t))


def _bowl(x0, y0, x1, y1, stem_radius, bowl_radius):
    return rounded_hull(
        (x0 + stem_radius, y0 + stem_radius, stem_radius),
        (x1 - bowl_radius, y0 + bowl_radius, bowl_radius),
        (x1 - bowl_radius, y1 - bowl_radius, bowl_radius),
        (x0 + stem_radius, y1 - stem_radius, stem_radius),
    )


# Left, top, bottom, upper and lower bowl right edges, and the two stem-side joins.
_BOLD = {12: (2.0, 1.0, 11.0, 8.5, 10.0), 16: (3.0, 1.5, 14.5, 11.5, 13.0), 24: (4.75, 3.0, 21.0, 17.25, 19.25)}


def bold(n, appearance):
    # An authored B: two bowls on a shared stem. Heavier strokes keep both counters open.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    x0, y0, y1, upper, lower = _BOLD[n]
    # The upper counter is the smaller one, as in a drawn letter.
    middle = y0 + (y1 - y0) * 0.46 if outlined else (y0 + y1) / 2
    join = {12: 0.6, 16: 0.9, 24: 1.2}[n]
    a = _bowl(x0, y0, upper, middle + t / 2, join, (middle + t / 2 - y0) / 2 - 1e-3)
    b = _bowl(x0, middle - t / 2, lower, y1, join, (y1 - middle + t / 2) / 2 - 1e-3)
    return union(ring(a, t), ring(b, t))


def type_(n, appearance):
    # An authored T. Downward serifs at 16 and 24 keep it a letter rather than a pole.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    if n == 12:
        y, x0, x1, c, bottom = (1.5, 1.5, 9.5, 5.5, 10.5) if outlined else (2.0, 2.0, 10.0, 6.0, 10.0)
        return union(stadium_line(x0, y, x1, y, t), stadium_line(c, y, c, bottom, t))
    y, x0, drop, bottom, foot = {
        (16, 'outline'): (2.25, 2.25, 2.0, 13.75, 2.0),
        (16, 'filled'): (2.75, 2.75, 1.75, 13.25, 2.0),
        (24, 'outline'): (3.0, 4.0, 3.5, 21.0, 3.0),
        (24, 'filled'): (3.5, 4.5, 3.0, 20.5, 3.0),
    }[(n, appearance)]
    c, x1 = n / 2, n - x0
    return union(
        stroke([(x0, y + drop), (x0, y), (x1, y), (x1, y + drop)], t),
        stadium_line(c, y, c, bottom, t),
        stadium_line(c - foot, bottom, c + foot, bottom, t),
    )


def _sparkle(cx, cy, arm, outlined, t, waist, join):
    if outlined:
        return union(stadium_line(cx - arm, cy, cx + arm, cy, t), stadium_line(cx, cy - arm, cx, cy + arm, t))
    points = []
    for i in range(8):
        a = math.radians(45 * i)
        r = arm if i % 2 == 0 else waist
        points.append((cx + r * math.cos(a), cy + r * math.sin(a)))
    return round_all(polygon(points), join)


def wand(n, appearance):
    # The stick is a plain capsule; the sparkle is what says assisted, in both styles.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    if n == 12:
        stick = ((2.0, 10.0), (6.25, 5.75)) if outlined else ((2.0, 10.0), (5.5, 6.5))
        sparks = [(8.75, 3.25, 1.75 if outlined else 2.25)]
    elif n == 16:
        stick = ((2.5, 13.5), (8.5, 7.5)) if outlined else ((2.75, 13.25), (7.75, 8.25))
        sparks = [(11.75, 4.25, 2.0 if outlined else 2.75)]
    else:
        stick = ((3.5, 20.5), (13.0, 11.0)) if outlined else ((3.5, 20.5), (12.0, 12.0))
        sparks = [(17.0, 6.5, 3.5) if outlined else (16.75, 6.75, 4.5), (19.5, 15.25, 1.5) if outlined else (19.5, 15.5, 2.5)]
    (a, b), (c, d) = stick
    x, y, arm = sparks[0]
    parts = [stadium_line(a, b, c, d, t), _sparkle(x, y, arm, outlined, w if outlined else t, 0.5 * arm, CUT_JOIN[n])]
    if len(sparks) > 1:
        # Crossed strokes this short close into a blob, so the outline accent is a dot.
        x, y, arm = sparks[1]
        parts.append(circle(x, y, 1.4) if outlined else _sparkle(x, y, arm, False, t, 0.5 * arm, CUT_JOIN[n]))
    return union(*parts)


DRAWERS = {
    'menu': menu,
    'more': more,
    'minus': minus,
    'check': check,
    'close': close,
    'activity': activity,
    'chart': chart,
    'pause': pause,
    'dot': dot,
    'loader': loader,
    'focus': focus,
    'group': group,
    'code': code,
    'bold': bold,
    'type': type_,
    'wand': wand,
}
