"""Arrows, chevrons, and transfers: one native arrow and one native chevron, reflected exactly."""
from __future__ import annotations

import math

from source.glyphs.kit import arc, reflect_x, right_to_down, right_to_up, stroke, tokens
from source.primitives import polyline_capsule, stadium_line, union
from source.seams import BOLD_WIDTH, GAP_TARGET


def arrow_right(n, appearance):
    w, t, p, outlined, R, acute = tokens(n, appearance)
    # The 1 px shaft sits on a pixel row: on the even canvas centre it paints two half rows.
    c = 5.5 if n == 12 and outlined else n / 2
    # One continuous shaft into a 45-degree head, spanning two thirds of the canvas.
    tail, tip, reach = {12: (1.5, 10.5, 4.0), 16: (2.25, 13.75, 5.25), 24: (3.0, 21.0, 8.0)}[n]
    return union(
        stadium_line(tail, c, tip, c, t),
        polyline_capsule([(tip - reach, c - reach), (tip, c), (tip - reach, c + reach)], t),
    )


def arrow_left(n, appearance):
    return reflect_x(arrow_right(n, appearance), n)


def arrow_up(n, appearance):
    return right_to_up(arrow_right(n, appearance), n)


def arrow_down(n, appearance):
    return right_to_down(arrow_right(n, appearance))


def arrow_up_right(n, appearance):
    w, t, p, outlined, R, acute = tokens(n, appearance)
    # A 90-degree corner on the shaft's own end. The 12 outline corner sits on a pixel crossing.
    if n == 12:
        corner, arm = (9.5, 2.5), 6.0 if outlined else 5.0
        if not outlined:
            corner = (9.0, 3.0)
        tail = (2.5, 9.5) if outlined else (3.0, 9.0)
    elif n == 16:
        corner, arm, tail = (12.5, 3.5), 7.5, (3.5, 12.5)
    else:
        corner, arm, tail = (18.0, 6.0), 11.0, (6.0, 18.0)
    x, y = corner
    return union(stroke([tail, corner], t), stroke([(x - arm, y), corner, (x, y + arm)], t))


# Apex x, back x, and half height. A chevron is a shorter field than an arrow.
_CHEVRON = {12: (7.5, 4.5, 3.0), 16: (10.0, 6.0, 4.0), 24: (15.0, 9.0, 6.0)}


def chevron_right(n, appearance):
    w, t, p, outlined, R, acute = tokens(n, appearance)
    apex, back, half = _CHEVRON[n]
    return stroke([(back, n / 2 - half), (apex, n / 2), (back, n / 2 + half)], t)


def chevron_left(n, appearance):
    return reflect_x(chevron_right(n, appearance), n)


def chevron_up(n, appearance):
    return right_to_up(chevron_right(n, appearance), n)


def chevron_down(n, appearance):
    return right_to_down(chevron_right(n, appearance))


def chevrons_right(n, appearance):
    w, t, p, outlined, R, acute = tokens(n, appearance)
    apex, back, half = _CHEVRON[n]
    reach = apex - back
    # Two 45-degree arms sit spacing / sqrt(2) apart, so the heavier pair still clears the gap target.
    spacing = (GAP_TARGET[n] + BOLD_WIDTH[n]) * math.sqrt(2) + 0.02
    first = (n - reach - spacing) / 2
    return union(*(
        stroke([(x, n / 2 - half), (x + reach, n / 2), (x, n / 2 + half)], t)
        for x in (first, first + spacing)
    ))


def chevrons_left(n, appearance):
    return reflect_x(chevrons_right(n, appearance), n)


# The cycle's centre and radius, how far the arc runs on past the circle, the head's arm length,
# and where the arc begins for each style, so a heavier head keeps the gap target from the tail.
_REFRESH = {
    12: (6.1, 6.25, 4.25, 1.5, 2.75, {'outline': 17, 'filled': 32}),
    16: (8.18, 8.25, 5.5, 1.75, 3.25, {'outline': 14, 'filled': 30}),
    24: (12.2, 12.5, 8.5, 3.0, 5.5, {'outline': 8, 'filled': 24}),
}


def refresh(n, appearance):
    w, t, p, outlined, R, acute = tokens(n, appearance)
    cx, cy, r, run, arm, starts = _REFRESH[n]
    path = arc(cx, cy, r, starts[appearance], 315)
    tip = (path[-1][0] + run * math.sqrt(0.5), path[-1][1] + run * math.sqrt(0.5))
    head = stroke([(tip[0], tip[1] - arm), tip, (tip[0] - arm, tip[1])], t)
    return union(stroke([*path, tip], t), head)


# Baseline y, arrow tip y, the other arrow end, baseline half width, head reach.
# Each style clears the baseline on its own: the 12 outline sits on pixel column 5.5.
_TRANSFER = {
    12: {'outline': (5.5, 10.5, 7.5, 1.5, 4.0, 3.25), 'filled': (6.0, 10.0, 7.0, 2.0, 4.0, 3.5)},
    16: {'outline': (8.0, 13.75, 9.75, 2.25, 5.5, 4.25), 'filled': (8.0, 13.25, 9.25, 2.75, 5.25, 4.25)},
    24: {'outline': (12.0, 21.0, 15.5, 3.0, 9.0, 6.5), 'filled': (12.0, 20.5, 14.5, 3.5, 8.5, 6.5)},
}


def _transfer(n, appearance, pointing_down):
    w, t, p, outlined, R, acute = tokens(n, appearance)
    x, base, near, far, half, reach = _TRANSFER[n][appearance]
    tip, tail = (near, far) if pointing_down else (far, near)
    back = reach if pointing_down else -reach
    return union(
        stadium_line(x - half, base, x + half, base, t),
        stadium_line(x, tail, x, tip, t),
        stroke([(x - reach, tip - back), (x, tip), (x + reach, tip - back)], t),
    )


def download(n, appearance):
    return _transfer(n, appearance, True)


def upload(n, appearance):
    return _transfer(n, appearance, False)


DRAWERS = {
    'arrow-right': arrow_right,
    'arrow-left': arrow_left,
    'arrow-up': arrow_up,
    'arrow-down': arrow_down,
    'arrow-up-right': arrow_up_right,
    'chevron-left': chevron_left,
    'chevron-right': chevron_right,
    'chevron-up': chevron_up,
    'chevron-down': chevron_down,
    'chevrons-left': chevrons_left,
    'chevrons-right': chevrons_right,
    'refresh': refresh,
    'upload': upload,
    'download': download,
}
