"""Enclosed status marks, plain shapes and progress symbols."""
from __future__ import annotations

from shapely import affinity
from shapely.geometry import box

from ..additions import frame_and_mark
from ..baseline import OUTLINE, U, line, octagon, ring
from .common import CANVAS, icon

# Regular facets: a Circle has no content to protect, so its flats and diagonals
# match. Info's frame keeps its longer flats to give enclosed marks a field.
CIRCLE_CUT = {12: 3, 16: 4, 24: 6}


def regular_octagon(n):
    a, z = CANVAS[n]
    return octagon(a, a, z, z, CIRCLE_CUT[n])


def enclosed(n, outlined, mark, negative=None):
    """Info's frame carrying a positive mark, or a negative one in the solid."""
    outer = frame_and_mark('info', n)[0]
    if outlined:
        return U(ring(outer, OUTLINE[n]), mark)
    return outer.difference(mark if negative is None else negative)


@icon('circle')
def circle(_, n, outlined):
    shape = regular_octagon(n)
    return ring(shape, OUTLINE[n]) if outlined else shape


@icon('square')
def square(_, n, outlined):
    # Corners carry more visual mass than chamfers, so the square sits a step
    # inside Circle's keyline and the two read as one size.
    a, z = {12: (2, 10), 16: (2, 14), 24: (3, 21)}[n]
    shape = box(a, a, z, z)
    return ring(shape, OUTLINE[n]) if outlined else shape


@icon('dot')
def dot(_, n, outlined):
    # Always solid: the meaning is a small dot, and Circle owns the hollow form.
    a, z, cut = {12: ((4, 7, .75), (4, 8, 1)),
                 16: ((5.5, 10.5, 1.25), (4.5, 11.5, 1.75)),
                 24: ((9, 15, 1.75), (7, 17, 2.75))}[n][0 if outlined else 1]
    return octagon(a, a, z, z, cut)


@icon('check-circle')
def check_circle(_, n, outlined):
    pts = {12: [(3.5, 5.75), (5, 7.25), (8.5, 3.75)],
           16: [(5.25, 7.75), (7.25, 9.75), (10.75, 6.25)],
           24: [(7, 11.5), (10.5, 15), (17, 8.5)]}[n]
    return enclosed(n, outlined, line(pts, OUTLINE[n]), line(pts, {12: 1.5, 16: 1.75, 24: 2.5}[n]))


@icon('close-circle')
def close_circle(_, n, outlined):
    a, z = {12: (4, 8), 16: (5.25, 10.75), 24: (7.5, 16.5)}[n]

    def cross(w):
        return U(line([(a, a), (z, z)], w), line([(a, z), (z, a)], w))
    return enclosed(n, outlined, cross(OUTLINE[n]), cross({12: 1.5, 16: 1.75, 24: 2.5}[n]))


@icon('ban')
def ban(_, n, outlined):
    outer = frame_and_mark('info', n)[0]
    w = OUTLINE[n]
    if outlined:
        return U(ring(outer, w), line([(0, 0), (n, n)], w).intersection(outer))
    # The negative slash divides the solid into two parts.
    return outer.difference(line([(-1, -1), (n + 1, n + 1)], {12: 1.5, 16: 2, 24: 2.5}[n]))


# Contour token, heavier token and the clear gap between facets. Cuts run through
# the octagon's vertices, so one ring construction serves both weights. The gap
# meets the general target and opens up at 24 px, where the facets are long.
LOADER = {12: (1, 1.5, 1), 16: (1.5, 2, 1.5), 24: (2, 2.5, 2.5)}


@icon('loader')
def loader(_, n, outlined):
    regular, heavier, gap = LOADER[n]
    t = regular if outlined else heavier
    c = n / 2
    cut = box(c - gap / 2, -2, c + gap / 2, c)
    spokes = [affinity.rotate(cut, 22.5 + 45 * k, origin=(c, c)) for k in range(8)]
    facets = ring(regular_octagon(n), t).difference(U(*spokes)).geoms
    # The upper right facet is omitted so the ring does not look identical at each
    # 45° step: a caller's rotation stays visible, and it cannot read as a Circle.
    kept = [f for f in facets if not (f.centroid.x > c + n / 8 and f.centroid.y < c - n / 8)]
    return U(*kept)


ACTIVITY_PEAKS = {12: {True: (2, 9), False: (2, 10)}, 16: {True: (3, 13), False: (2, 14)}, 24: {True: (4, 20), False: (3, 21)}}


@icon('activity')
def activity(_, n, outlined):
    t = OUTLINE[n] if outlined else {12: 1.5, 16: 2.5, 24: 3}[n]
    pts = {12: [(1, 5.5), (3, 5.5), (4.5, 2.5), (7.5, 8.5), (9, 5.5), (11, 5.5)] if outlined
           else [(1, 6), (3, 6), (4.5, 3), (7.5, 9), (9, 6), (11, 6)],
           16: [(1.5, 8), (4.25, 8), (6.125, 4.25), (9.875, 11.75), (11.75, 8), (14.5, 8)],
           24: [(2, 12), (5.5, 12), (8.75, 5.5), (15.25, 18.5), (18.5, 12), (22, 12)]}[n]
    # The mitred peaks are cut flat on the pixel grid. A full mitre ends in a sliver
    # thinner than a pixel, which a font rasterizer's edge coverage turns into a stray
    # pixel outside the drawing.
    top, bottom = ACTIVITY_PEAKS[n][outlined]
    return line(pts, t).intersection(box(0, top, n, bottom))
