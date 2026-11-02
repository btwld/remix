"""Things: silhouette pairs whose outer shape names the object."""
from __future__ import annotations

import math

from shapely import affinity

from source.glyphs.kit import arc, framed, soften_concave, stroke, tokens
from source.primitives import (
    circle, polygon, ring, round_all, round_convex, rounded_hull, rounded_rect, stadium_line, union,
)
from source.seams import CUT_JOIN, GAP_TARGET


def _diagonal(geom, n, tip_x, tip_y):
    """Lay a shape built along +x so its origin lands on the tip and it rises to the upper right."""
    return affinity.translate(affinity.rotate(geom, -45, origin=(0, 0)), tip_x, tip_y)


# Tip point, half width, length, the shoulder, the tip radius, and where the eraser starts.
_EDIT = {
    12: ((1.3, 10.7), 2.1, 12.6, 3.0, 0.6, 9.4),
    16: ((1.8, 14.2), 2.8, 16.6, 4.0, 0.9, 12.4),
    24: ((2.93, 21.07), 3.75, 24.4, 5.75, 1.2, 18.6),
}


def edit(n, appearance):
    # A pencil on one diagonal: a round tip, parallel sides, a soft eraser end.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    (x, y), half, length, shoulder, tip_r, eraser = _EDIT[n]
    end = min(R, half)
    side = CUT_JOIN[n]
    body = rounded_hull(
        (tip_r, 0, tip_r),
        (shoulder, -half + side, side),
        (shoulder, half - side, side),
        (length - end, -half + end, end),
        (length - end, half - end, end),
    )
    if outlined:
        drawn = union(ring(body, w), stadium_line(eraser, -half, eraser, half, w).intersection(body))
    else:
        cut = stadium_line(eraser, -half - w, eraser, half + w, GAP_TARGET[n])
        drawn = round_convex(body.difference(cut), CUT_JOIN[n])
    return _diagonal(drawn, n, x, y)


def copy(n, appearance):
    # The rear sheet stays a contour in both styles, so filled never becomes two blocks.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    front, rear, radius = {
        12: ((4.0, 4.0, 11.0, 11.0), [(1.5, 7.5), (1.5, 1.5), (7.5, 1.5)], 1.1),
        16: ((5.5, 5.5, 14.5, 14.5), [(2.25, 10.0), (2.25, 2.25), (10.0, 2.25)], 1.65),
        24: ((8.0, 8.0, 21.0, 21.0), [(4.0, 14.5), (4.0, 4.0), (14.5, 4.0)], 2.4),
    }[n]
    return union(framed(rounded_rect(*front, R), w, outlined), stroke(rear, w, radius))


def trash(n, appearance):
    w, t, p, outlined, R, acute = tokens(n, appearance)
    bump, lid, top, tx0, tx1, bx0, bx1, bottom, soft, marks = {
        12: ((4.5, 1.5, 7.5), (1.5, 2.5, 10.5), 4.0, 2.5, 9.5, 3.0, 9.0, 11.0, 0.6, ()),
        16: ((6.0, 2.25, 10.0), (2.25, 3.75, 13.75), 6.0, 3.25, 12.75, 3.75, 12.25, 14.5, 0.9, ()),
        24: ((9.0, 3.0, 15.0), (3.0, 5.0, 21.0), 8.0, 4.5, 19.5, 5.0, 19.0, 22.0, 1.2,
             ((10.0, 13.0, 16.5), (14.0, 13.0, 16.5))),
    }[n]
    body = rounded_hull(
        (tx0 + soft, top + soft, soft),
        (tx1 - soft, top + soft, soft),
        (bx1 - R, bottom - R, R),
        (bx0 + R, bottom - R, R),
    )
    cuts = [stadium_line(x, y0, x, y1, w) for x, y0, y1 in marks]
    return union(
        stadium_line(bump[0], bump[1], bump[2], bump[1], w),
        stadium_line(lid[0], lid[1], lid[2], lid[1], w),
        framed(body, w, outlined, cuts),
    )


def filter_(n, appearance):
    # One funnel. The stem is exactly two contours wide, so the ring leaves it solid.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    x0, x1, top, sx0, sx1, neck, bottom, soft = {
        12: (1.0, 11.0, 1.0, 5.0, 7.0, 5.5, 11.0, 0.9),
        16: (1.5, 14.5, 1.5, 6.5, 9.5, 8.0, 14.5, 1.3),
        24: (2.5, 21.5, 2.0, 10.0, 14.0, 11.75, 22.0, 1.75),
    }[n]
    funnel = polygon([(x0, top), (x1, top), (sx1, neck), (sx1, bottom), (sx0, bottom), (sx0, neck)])
    shape = soften_concave(round_convex(funnel, soft), soft)
    return ring(shape, w) if outlined else shape


def _clipped_square(x0, y0, x1, y1, R, acute, cut):
    tangent = acute * math.tan(math.pi / 8)
    fx, fy = x1 - cut, y0 + cut
    return rounded_hull(
        (x0 + R, y0 + R, R),
        (fx - tangent, y0 + acute, acute),
        (x1 - acute, fy + tangent, acute),
        (x1 - R, y1 - R, R),
        (x0 + R, y1 - R, R),
    )


def save(n, appearance):
    # A disk: clipped corner, shutter slot, label window. Not a bookmark or a download.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    box_, cut, shutter, rail, rail_r, window = {
        12: ((1.0, 1.0, 11.0, 11.0), 2.75, (3.5, 6.0, 3.5), (3.5, 8.5, 7.5, 11.0), 0.5, (3.0, 7.5, 9.0, 10.0, 0.4)),
        16: ((1.5, 1.5, 14.5, 14.5), 3.5, (5.5, 8.5, 5.75), (5.0, 11.0, 9.75, 14.5), 0.75, (5.0, 10.0, 11.0, 13.0, 0.6)),
        24: ((3.0, 3.0, 21.0, 21.0), 5.0, (8.0, 13.0, 8.0), (7.0, 17.0, 14.0, 21.0), 1.0, (7.5, 14.0, 16.5, 19.0, 1.0)),
    }[n]
    shape = _clipped_square(*box_, R, acute, cut)
    slot = stadium_line(shutter[0], shutter[2], shutter[1], shutter[2], w)
    if outlined:
        a, b, y, end = rail
        label = stroke([(a, end), (a, y), (b, y), (b, end)], w, rail_r).intersection(shape)
        return union(ring(shape, w), label, slot)
    return shape.difference(union(slot, rounded_rect(*window)))


def folder(n, appearance):
    # A tabbed silhouette. The filled master stays solid: the tab already names it.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    x0, x1, top, shoulder, bottom, tab_top, tab_end, tab_foot, tab_r = {
        12: (1.0, 11.0, 2.0, 4.0, 10.0, 2.0, 5.25, 6.75, 0.5),
        16: (1.5, 14.5, 2.5, 5.0, 13.5, 2.5, 7.0, 9.0, 0.7),
        24: (2.0, 22.0, 3.5, 7.5, 20.5, 3.5, 10.5, 13.0, 1.0),
    }[n]
    body = rounded_rect(x0, shoulder, x1, bottom, R)
    tab = rounded_hull(
        (x0 + R, tab_top + R, R),
        (tab_end - tab_r, tab_top + tab_r, tab_r),
        (tab_foot - tab_r, shoulder + R - tab_r, tab_r),
        (x0 + R, shoulder + R, R),
    )
    shape = soften_concave(union(body, tab), {12: 0.6, 16: 0.9, 24: 1.2}[n])
    return ring(shape, w) if outlined else shape


def bookmark(n, appearance):
    # A ribbon: soft top corners, two round points, and a V notch that stays open.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    x0, x1, top, bottom, notch, point = {
        12: (2.5, 9.5, 1.0, 11.53, 2.75, 0.5),
        16: (3.5, 12.5, 1.5, 15.23, 3.5, 0.7),
        24: (5.0, 19.0, 2.0, 22.95, 5.0, 1.0),
    }[n]
    ribbon = polygon([(x0, top), (x1, top), (x1, bottom), ((x0 + x1) / 2, bottom - notch), (x0, bottom)])
    head = rounded_rect(x0, top, x1, bottom + 2 * R, R)
    shape = soften_concave(round_convex(ribbon, point).intersection(head), point)
    return ring(shape, w) if outlined else shape


def chat(n, appearance):
    # A bubble and its tail. The content line appears only where it has room.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    bubble, tail, line = {
        12: ((1.0, 1.0, 11.0, 8.5), [(3.0, 7.0), (3.0, 11.69), (6.75, 7.0)], None),
        16: ((1.5, 1.5, 14.5, 11.5), [(4.25, 10.0), (4.25, 15.36), (9.0, 10.0)], None),
        24: ((2.5, 3.0, 21.5, 17.5), [(6.5, 15.0), (6.5, 22.35), (13.5, 15.0)], (8.0, 16.0, 10.25)),
    }[n]
    tip = {12: 0.45, 16: 0.65, 24: 0.95}[n]
    shape = soften_concave(union(rounded_rect(*bubble, R), round_convex(polygon(tail), tip)), tip)
    marks = [] if line is None else [stadium_line(line[0], line[2], line[1], line[2], w)]
    return framed(shape, w, outlined, marks)


def bell(n, appearance):
    # A dome flaring to a rim, with a detached clapper. No warning punctuation.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    dome, rim, soft, crown, clapper = {
        12: ((6.0, 4.0, 3.0), (1.5, 10.5, 9.0), 0.9, None, (4.75, 7.25, 10.5)),
        16: ((8.0, 6.6, 4.0), (2.5, 13.5, 11.5), 1.25, (2.25, 3.0), (6.5, 9.5, 13.75)),
        24: ((12.0, 10.0, 6.0), (4.5, 19.5, 18.0), 1.6, (3.0, 4.5), (10.0, 14.0, 21.0)),
    }[n]
    body = rounded_hull(
        dome,
        (rim[0] + soft, rim[2] - soft, soft),
        (rim[1] - soft, rim[2] - soft, soft),
    )
    parts = [framed(body, w, outlined), stadium_line(clapper[0], clapper[2], clapper[1], clapper[2], w)]
    if crown is not None:
        parts.append(stadium_line(n / 2, crown[0], n / 2, crown[1], w))
    return union(*parts)


def lock(n, appearance):
    # An open-countered shackle on a body. Only 24 has room for a keyhole.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    body, xs, arch_y, leg_end, keyhole = {
        12: ((2.0, 5.0, 10.0, 11.0), (3.5, 8.5), 4.0, 5.5, None),
        16: ((2.5, 7.0, 13.5, 14.5), (5.0, 11.0), 5.25, 7.75, None),
        24: ((4.0, 10.0, 20.0, 22.0), (7.0, 17.0), 8.0, 11.0, (15.0, 17.0)),
    }[n]
    a, b = xs
    shackle = stroke([(a, leg_end), *arc((a + b) / 2, arch_y, (b - a) / 2, 180, 360), (b, leg_end)], w)
    marks = [] if keyhole is None else [stadium_line(n / 2, keyhole[0], n / 2, keyhole[1], w)]
    return union(shackle, framed(rounded_rect(*body, R), w, outlined, marks))


def shield(n, appearance):
    # Broad shoulders and straight sides tapering to one round point. Status belongs in the text beside it.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    x0, x1, top, bottom, shoulder, belly, belly_y, tip = {
        12: (2.0, 10.0, 1.0, 11.0, 1.6, 2.4, 5.75, 0.85),
        16: (3.0, 13.0, 1.5, 14.5, 2.4, 3.2, 7.75, 1.15),
        24: (4.0, 20.0, 2.5, 21.5, 3.4, 4.8, 11.75, 1.7),
    }[n]
    shape = rounded_hull(
        (x0 + shoulder, top + shoulder, shoulder),
        (x1 - shoulder, top + shoulder, shoulder),
        (x1 - belly, belly_y, belly),
        (n / 2, bottom - tip, tip),
        (x0 + belly, belly_y, belly),
    )
    return framed(shape, w, outlined)


# Tooth count, outer radius, body radius, tooth width, hub radius per style, root softening.
_GEAR = {
    12: (6, 5.0, 3.65, 2.1, {'outline': 2.1, 'filled': 1.2}, 0.45),
    16: (8, 6.5, 4.9, 2.5, {'outline': 2.85, 'filled': 1.6}, 0.5),
    24: (8, 10.0, 7.6, 3.6, {'outline': 4.6, 'filled': 2.6}, 0.8),
}


def gear(n, appearance):
    # Teeth grow straight out of one body, unlike Sun's detached rays. The hub is the only counter.
    teeth, outer, body, width, hubs, soft = _GEAR[n]
    c = n / 2
    parts = [circle(c, c, body)]
    for i in range(teeth):
        a = math.radians(360 / teeth * i - 90)
        reach = outer - width / 2
        parts.append(stadium_line(c, c, c + reach * math.cos(a), c + reach * math.sin(a), width))
    shape = soften_concave(union(*parts), soft)
    return shape.difference(circle(c, c, hubs[appearance]))


def play(n, appearance):
    # Pointing right and shifted right of the canvas centre, so its mass balances. Never mirrored.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    x0, x1, top, bottom = {12: (2.5, 10.5, 1.5, 10.5), 16: (3.5, 13.5, 2.0, 14.0), 24: (6.0, 21.0, 3.0, 21.0)}[n]
    shape = rounded_hull(
        (x0 + acute, top + acute, acute),
        (x1 - acute, n / 2, acute),
        (x0 + acute, bottom - acute, acute),
    )
    return framed(shape, w, outlined)


def box_(n, appearance):
    # A package seen from above a corner: a hexagon with three faces meeting at the centre.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    top, bottom, x0, x1, upper, lower, soft = {
        12: (1.0, 11.0, 1.75, 10.25, 3.5, 8.5, 1.0),
        16: (1.5, 14.5, 2.4, 13.6, 4.75, 11.25, 1.5),
        24: (2.0, 22.0, 3.5, 20.5, 7.0, 17.0, 2.0),
    }[n]
    c = n / 2
    inset = 0.75 * soft
    shape = rounded_hull(
        (c, top + soft, soft),
        (x1 - soft, upper + inset, soft),
        (x1 - soft, lower - inset, soft),
        (c, bottom - soft, soft),
        (x0 + soft, lower - inset, soft),
        (x0 + soft, upper + inset, soft),
    )
    arms = stroke([(x0 - w, upper - 0.59 * w), (c, c), (x1 + w, upper - 0.59 * w)], w)
    if outlined:
        spine = stroke([(c, c), (c, bottom)], w)
        return union(ring(shape, w), union(arms, spine).intersection(shape))
    # The filled spine stops short of the lower corner, so that corner keeps the shared outer bound.
    spine = stroke([(c, c), (c, bottom - 2 * w)], w)
    return round_convex(shape.difference(union(arms, spine)), CUT_JOIN[n])


def laptop(n, appearance):
    # A screen over a wider base, with the base floating at the gap target.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    screen, base, r = {
        12: ((2.0, 2.0, 10.0, 8.0), (1.5, 10.5, 9.5), 1.25),
        16: ((3.0, 2.75, 13.0, 10.25), (2.25, 13.75, 12.5), 1.75),
        24: ((4.0, 3.75, 20.0, 16.25), (3.0, 21.0, 19.25), 2.6),
    }[n]
    return union(framed(rounded_rect(*screen, r), w, outlined), stadium_line(base[0], base[2], base[1], base[2], w))


def smartphone(n, appearance):
    # Portrait, with a home indicator. The indicator is what separates it from an empty frame.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    frame, mark = {
        12: ((3.0, 1.0, 9.0, 11.0), (5.5, 6.5, 8.5)),
        16: ((3.5, 1.5, 12.5, 14.5), (7.25, 8.75, 10.75)),
        24: ((6.0, 2.0, 18.0, 22.0), (11.0, 13.0, 17.0)),
    }[n]
    return framed(rounded_rect(*frame, R), w, outlined, [stadium_line(mark[0], mark[2], mark[1], mark[2], w)])


def moon(n, appearance):
    # A crescent cut by one circle: rounded tips, never a star or a sun.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    outer, bite, tip = {
        12: ((6.13, 5.86, 4.85), (8.38, 3.56, 3.75), 0.45),
        16: ((8.16, 7.76, 6.3), (11.01, 4.66, 4.85), 0.65),
        24: ((12.28, 11.66, 9.65), (16.78, 6.96, 7.5), 1.0),
    }[n]
    shape = round_convex(circle(*outer).difference(circle(*bite)), tip)
    return ring(shape, w) if outlined else shape


def sun(n, appearance):
    # A round core and eight detached rays. The rays and bounds are shared; only the core fills.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    core, start, end = {12: (2.25, 3.75, 4.5), 16: (3.0, 5.25, 5.75), 24: (4.25, 7.25, 9.0)}[n]
    c = n / 2
    rays = []
    for i in range(8):
        a = math.radians(45 * i)
        rays.append(stadium_line(
            c + start * math.cos(a), c + start * math.sin(a),
            c + end * math.cos(a), c + end * math.sin(a), w))
    return union(framed(circle(c, c, core), w, outlined), *rays)


def heart(n, appearance):
    # Two lobes running into one round point, with a soft notch. Distinct from Star's five points.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    r, a, b, y, tip_y, tip, notch = {
        12: (2.85, 3.85, 8.15, 4.0, 9.95, 0.8, 0.4),
        16: (3.75, 5.25, 10.75, 5.75, 12.95, 1.15, 0.55),
        24: (5.6, 7.6, 16.4, 8.3, 19.6, 1.7, 0.85),
    }[n]
    point = circle(n / 2, tip_y, tip)
    lobes = [union(circle(x, y, r), point).convex_hull for x in (a, b)]
    shape = soften_concave(union(*lobes), notch)
    return ring(shape, w) if outlined else shape


def layers(n, appearance):
    # One sheet in plan, with the edges of more beneath. Only 24 has room for a second edge.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    x0, x1, top, bottom, soft, edges = {
        12: (1.0, 11.0, 1.0, 7.0, 0.75, (((1.5, 7.5), (6.0, 10.25)),)),
        16: (1.5, 14.5, 1.5, 9.0, 1.0, (((2.25, 9.75), (8.0, 13.5)),)),
        24: (3.0, 21.0, 2.0, 12.0, 1.4, (((3.75, 11.6), (12.0, 16.1)), ((3.75, 16.4), (12.0, 20.9)))),
    }[n]
    c, middle = n / 2, (top + bottom) / 2
    sheet = rounded_hull(
        (c, top + soft, soft), (x1 - soft, middle, soft),
        (c, bottom - soft, soft), (x0 + soft, middle, soft),
    )
    lines = [stroke([(ex, ey), (c, ay), (n - ex, ey)], w) for (ex, ey), (_, ay) in edges]
    return union(framed(sheet, w, outlined), *lines)


def cursor(n, appearance):
    # A pointer: one acute tip at the upper left and a notch opposite. Not centred by design.
    w, t, p, outlined, R, acute = tokens(n, appearance)
    points, join = {
        12: ([(1.6, 1.6), (10.85, 5.1), (6.85, 6.85), (5.1, 10.85)], 0.5),
        16: ([(2.45, 2.45), (14.2, 6.95), (9.05, 9.05), (6.95, 14.2)], 0.7),
        24: ([(3.9, 3.9), (21.1, 10.2), (13.4, 13.4), (10.2, 21.1)], 1.0),
    }[n]
    shape = round_all(polygon(points), join)
    return ring(shape, w) if outlined else shape


DRAWERS = {
    'edit': edit,
    'copy': copy,
    'trash': trash,
    'filter': filter_,
    'save': save,
    'folder': folder,
    'bookmark': bookmark,
    'chat': chat,
    'bell': bell,
    'lock': lock,
    'shield': shield,
    'gear': gear,
    'play': play,
    'box': box_,
    'laptop': laptop,
    'smartphone': smartphone,
    'moon': moon,
    'sun': sun,
    'heart': heart,
    'layers': layers,
    'cursor': cursor,
}
