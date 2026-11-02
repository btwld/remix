"""Directional doubles, authored letters and source brackets."""
from __future__ import annotations

import math

from shapely import affinity
from shapely.geometry import box

from ..baseline import BOLD, OUTLINE, P, U, line, ring
from .common import CANVAS, icon, rects

# A chevron's own arm spans, matching the single Chevron drawings exactly.
CHEVRON = {12: [(0, 2.5), (3.5, 6), (0, 9.5)], 16: [(0, 3.5), (4.5, 8), (0, 12.5)], 24: [(0, 5), (7, 12), (0, 19)]}
CHEVRON_PITCH = {12: (3, 4.25), 16: (4.5, 5.75), 24: (5.75, 7.5)}


@icon('chevrons-right', 'chevrons-left')
def chevrons(name, n, outlined):
    t = OUTLINE[n] if outlined else BOLD[n]
    pitch = CHEVRON_PITCH[n][0 if outlined else 1]
    pair = U(*[line([(x + d, y) for x, y in CHEVRON[n]], t) for d in (0, pitch)])
    # Center what is painted: the mitred tip reaches further than the arm ends.
    pair = affinity.translate(pair, n / 2 - (pair.bounds[0] + pair.bounds[2]) / 2)
    return affinity.rotate(pair, 180, origin=(n / 2, n / 2)) if name == 'chevrons-left' else pair


@icon('type')
def type_(_, n, outlined):
    # An authored roman T: a head with short drops and a foot, so it cannot be
    # mistaken for a Plus or an Arrow up. 12 px odd-width strokes sit on 5-6.
    spec = {
        12: {True: ((1, 1, 10, 2), (1, 1, 2, 3), (9, 1, 10, 3), (5, 1, 6, 10), (3, 9, 8, 10)),
             False: ((1, 1, 11, 3), (1, 1, 3, 4), (9, 1, 11, 4), (5, 1, 7, 11), (3, 9, 9, 11))},
        16: {True: ((2, 2, 14, 3.5), (2, 2, 3.5, 5.5), (12.5, 2, 14, 5.5), (7.25, 2, 8.75, 14), (5, 12.5, 11, 14)),
             False: ((2, 2, 14, 4.5), (2, 2, 4.5, 6), (11.5, 2, 14, 6), (6.5, 2, 9.5, 14), (4.5, 11.5, 11.5, 14))},
        24: {True: ((4, 3, 20, 5), (4, 3, 6, 8), (18, 3, 20, 8), (11, 3, 13, 21), (8, 19, 16, 21)),
             False: ((4, 3, 20, 6), (4, 3, 7, 9), (17, 3, 20, 9), (10, 3, 14, 21), (7, 18, 17, 21))},
    }[n][outlined]
    return U(*rects(*spec))


# Silhouette, waist rail, and the filled form's two narrow counters. Lower bowl
# is deliberately larger, as it is in a drawn capital. No font outline is used.
BOLD_B = {
    12: ([(3, 1), (7, 1), (8, 2), (8, 4), (7, 5), (7, 6), (9, 8), (9, 10), (8, 11), (3, 11)], (3, 5, 7, 6),
         ((5, 3, 6, 4), (5, 7, 7, 9))),
    16: ([(3.5, 2), (10, 2), (11.5, 3.5), (11.5, 5.5), (10, 7), (10, 8.5), (12.5, 11), (12.5, 12.5), (11, 14), (3.5, 14)], (3.5, 7, 10, 8.5),
         ((6.5, 4, 9, 5.5), (6.5, 9.5, 10, 11.5))),
    24: ([(5, 3), (15, 3), (18, 6), (18, 8), (16, 10), (16, 12), (19, 15), (19, 18), (16, 21), (5, 21)], (5, 10, 16, 12),
         ((9, 6, 14, 8), (9, 14, 15, 18))),
}


@icon('bold')
def bold(_, n, outlined):
    points, rail, counters = BOLD_B[n]
    shape = P(points)
    if outlined:
        return U(ring(shape, OUTLINE[n]), box(*rail).intersection(shape))
    return shape.difference(U(*rects(*counters)))


# Stroke, bracket arm and slash lean per weight. Both brackets are one mirrored
# drawing, and the slash is symmetric about the canvas center.
CODE = {
    12: {True: (1, 2, 1), False: (1.25, 1.75, .75)},
    16: {True: (1.5, 2, 1), False: (1.75, 2, 1)},
    24: {True: (2, 4.25, 1.5), False: (2.5, 3.75, 1)},
}


@icon('code')
def code(_, n, outlined):
    t, arm, lean = CODE[n][outlined]
    a, z = CANVAS[n]
    c = n / 2
    # The mitred tip lands on the keyline, so both brackets stay within the padding.
    tip = a + t * math.sqrt(2) / 2
    left = line([(tip + arm, c - arm), (tip, c), (tip + arm, c + arm)], t)
    right = affinity.scale(left, -1, 1, origin=(c, c))
    # The slash is squared off on the row grid, as a stem terminal would be.
    run = 2 * lean / (z - a)
    slash = line([(c + lean + run, a - 1), (c - lean - run, z + 1)], t).intersection(box(0, a, n, z))
    return U(left, right, slash)
