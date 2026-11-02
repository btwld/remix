"""Pictorial symbols with chamfered silhouettes."""
from __future__ import annotations

from shapely import affinity
from shapely.geometry import box

from ..baseline import OUTLINE, P, U, line, octagon, ring
from .common import icon, rects

HEART = {12: [(6, 11), (1, 6), (1, 3), (3, 1), (4, 1), (6, 3), (8, 1), (9, 1), (11, 3), (11, 6)],
         16: [(8, 14), (1.5, 7.5), (1.5, 4.5), (3.5, 2.5), (6, 2.5), (8, 4.5), (10, 2.5), (12.5, 2.5), (14.5, 4.5), (14.5, 7.5)],
         24: [(12, 21), (2, 11), (2, 6), (5, 3), (9, 3), (12, 6), (15, 3), (19, 3), (22, 6), (22, 11)]}


@icon('heart')
def heart(_, n, outlined):
    shape = P(HEART[n])
    return ring(shape, OUTLINE[n]) if outlined else shape


# A faceted crescent, symmetric about the descending canvas diagonal. Only
# octagon-family edges are used, so it belongs with Search and Info.
MOON = {12: [(5, 1), (4, 1), (1, 4), (1, 8), (4, 11), (8, 11), (11, 8), (11, 7), (8, 7), (5, 4)],
        16: [(6.5, 2), (5.5, 2), (2, 5.5), (2, 10.5), (5.5, 14), (10.5, 14), (14, 10.5), (14, 9.5), (9.5, 9.5), (6.5, 6.5)],
        24: [(9, 3), (8, 3), (3, 8), (3, 16), (8, 21), (16, 21), (21, 16), (21, 15), (14, 15), (9, 10)]}


@icon('moon')
def moon(_, n, outlined):
    shape = P(MOON[n])
    return ring(shape, OUTLINE[n]) if outlined else shape


# Hub half-size and chamfer, ray start and end, and diagonal ray end, each per
# weight. The filled hub is larger, which is what separates the pair: the ray
# weight stays at the crisp contour token.
SUN = {16: {True: (2.5, 1.25, 5, 6.5, 6.5), False: (3, 1.5, 5, 6.5, 6.5)},
       24: {True: (4, 2.5, 7, 10, 10), False: (5, 3, 7, 10, 10)}}


@icon('sun')
def sun(_, n, outlined):
    w = OUTLINE[n]
    if n == 12:
        # Built on the 5.5 center, where a 1 px ray is a full-strength pixel. Rays
        # shrink to single pixels; the pair differs in the hub, which stays open.
        hub = octagon(3, 3, 8, 8, 1.5)
        rays = rects((5, 1, 6, 2), (5, 9, 6, 10), (1, 5, 2, 6), (9, 5, 10, 6),
                     *[(x, y, x + 1, y + 1) for x in (2, 8) for y in (2, 8)])
        return U(ring(hub, w) if outlined else hub, *rays)
    half, cut, start, end, diagonal_end = SUN[n][outlined]
    c = n / 2
    hub = octagon(c - half, c - half, c + half, c + half, cut)
    axial = box(c - w / 2, c - end, c + w / 2, c - start)
    diagonal = box(c - w / 2, c - diagonal_end, c + w / 2, c - start)
    rays = [affinity.rotate(axial, 90 * k, origin=(c, c)) for k in range(4)]
    rays += [affinity.rotate(diagonal, 45 + 90 * k, origin=(c, c)) for k in range(4)]
    return U(ring(hub, w) if outlined else hub, *rays)


# Classic arrow pointer: a true vertical edge and a 45° leading edge, so both
# stay crisp. The tail is narrower than twice the contour, so it stays solid.
CURSOR = {12: [(2, 1), (9, 8), (6, 8), (7.5, 11), (5.5, 11), (4, 8), (2, 10)],
          16: [(3, 1.5), (12.5, 11), (8.5, 11), (10.5, 14.5), (8, 14.5), (6, 11), (3, 13.5)],
          24: [(5, 2), (20, 17), (14, 17), (17, 22), (13.5, 22), (10, 16.5), (5, 21)]}


@icon('cursor')
def cursor(_, n, outlined):
    shape = P(CURSOR[n])
    return ring(shape, OUTLINE[n]) if outlined else shape


def sparkle(cx, cy, reach, waist):
    """A four-point sparkle; its concave sides stop it reading as a hammer head."""
    return P([(cx, cy - reach), (cx + waist, cy - waist), (cx + reach, cy), (cx + waist, cy + waist),
              (cx, cy + reach), (cx - waist, cy + waist), (cx - reach, cy), (cx - waist, cy - waist)])


# Rod, main spark, and the small accent marks. 12 px carries no accents at all.
WAND = {12: {True: (1, [(1.5, 10.5), (6, 6)], (8.5, 3.5, 2.5), ()),
             False: (1.5, [(1.75, 10.25), (5.25, 6.75)], (8, 4, 3, 1), ())},
        16: {True: (1.5, [(2.25, 13.75), (8, 8)], (11.25, 4.75, 3.25), ((3, 3, 4.5, 4.5),)),
             False: (2.5, [(2.5, 13.5), (7, 9)], (10.5, 5.5, 4, 1.25), ((2.5, 2.5, 4.5, 4.5),))},
        24: {True: (2, [(3, 21), (12, 12)], (17, 7, 5), ((5, 5, 7, 7), (19, 17, 21, 19))),
             False: (3, [(3.5, 20.5), (10.5, 13.5)], (16, 8, 6, 1.5), ((4, 4, 7, 7), (18, 17, 21, 20)))}}


@icon('wand')
def wand(_, n, outlined):
    t, rod, spark, accents = WAND[n][outlined]
    if outlined:
        cx, cy, arm = spark
        star = U(box(cx - t / 2, cy - arm, cx + t / 2, cy + arm), box(cx - arm, cy - t / 2, cx + arm, cy + t / 2))
    else:
        star = sparkle(*spark)
    return U(line(rod, t), star, *rects(*accents))
