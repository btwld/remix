"""Technical 12-icon construction. Independent drawings per native master.

Skeletons follow the grammar spec. Paths are not Angular copies and are not
scaled from another master after expansion.
"""
from __future__ import annotations
import math
from shapely.geometry import box

from source.contract import PAIR_MODEL, resolve
from source.grammar import (
    bar,
    chamfer_polygon,
    chamfered_frame,
    contour_width,
    part_chamfer,
    plate,
    polygon,
    ring,
    tokens,
    union,
)


def draw(icon_id, n, appearance, pack="technical"):
    resolve(pack, icon_id, appearance, n)
    fn = DRAW[icon_id]
    g = fn(n, appearance)
    if g is None or g.is_empty or not g.is_valid:
        raise ValueError("Invalid geometry %s/%s/%s" % (icon_id, appearance, n))
    minx, miny, maxx, maxy = g.bounds
    if minx < -1e-6 or miny < -1e-6 or maxx > n + 1e-6 or maxy > n + 1e-6:
        raise ValueError("Out of canvas %s/%s/%s %s" % (icon_id, appearance, n, g.bounds))
    return g


def _t(n, appearance, icon_id):
    tok = tokens(n)
    w = contour_width(n, appearance, PAIR_MODEL[icon_id])
    return tok, w, appearance == "outline"


def _obj(shape, width, outlined):
    return ring(shape, width) if outlined else shape


def _home(n, appearance):
    tok, w, outlined = _t(n, appearance, "home")
    c, cut = tok["center"], tok["chamfer"]
    if n == 12:
        roof = polygon([(6, 1), (10, 5), (2, 5)])
        body = polygon([(3, 5), (9, 5), (9, 10), (8, 11), (4, 11), (3, 10)])
        door = box(5, 8, 7, 11)
    elif n == 16:
        roof = polygon([(8, 1.5), (14, 7.5), (2, 7.5)])
        body = polygon([(4, 7.5), (12, 7.5), (12, 13), (10.5, 14.5), (5.5, 14.5), (4, 13)])
        door = box(6.5, 10.5, 9.5, 14.5)
    else:
        roof = polygon([(12, 2), (21, 11), (3, 11)])
        body = polygon([(5, 11), (19, 11), (19, 20), (17, 22), (7, 22), (5, 20)])
        door = box(10, 16, 14, 22)
    shape = union(roof, body)
    if not outlined:
        return shape.difference(door)
    shell = ring(shape, w)
    jamb = box(door.bounds[0] - w, door.bounds[1] - w, door.bounds[2] + w, n)
    frame = jamb.difference(door)
    return union(shell, frame).intersection(shape).difference(door)


def _search(n, appearance):
    tok, w, outlined = _t(n, appearance, "search")
    if n == 12:
        lens = plate(1, 1, 8, 8, 1)
        handle = bar((6.5, 6.5), (10.5, 10.5), w)
    elif n == 16:
        lens = plate(1.5, 1.5, 11, 11, 1.5)
        handle = bar((9.5, 9.5), (14, 14), w)
    else:
        lens = plate(2, 2, 16, 16, 2)
        handle = bar((13.5, 13.5), (21.5, 21.5), w)
    return union(ring(lens, w), handle)


def _plus(n, appearance):
    tok, w, outlined = _t(n, appearance, "plus")
    c, inset = tok["center"], tok["plus_inset"]
    return union(
        box(c - w / 2, inset, c + w / 2, n - inset),
        box(inset, c - w / 2, n - inset, c + w / 2),
    )


def _arrow_right(n, appearance):
    tok, w, outlined = _t(n, appearance, "arrow-right")
    c = tok["center"]
    if n == 12:
        shaft = bar((1.5, c), (7, c), w)
        head = union(bar((6.5, 2.5), (10, 6), w), bar((6.5, 9.5), (10, 6), w))
    elif n == 16:
        shaft = bar((2, c), (9.5, c), w)
        head = union(bar((8.5, 3.5), (13.5, 8.5), w), bar((8.5, 12.5), (13.5, 8.5), w))
    else:
        shaft = bar((3, c), (14, c), w)
        head = union(bar((13, 5), (20, 12), w), bar((13, 19), (20, 12), w))
    return union(shaft, head)


def _user(n, appearance):
    tok, w, outlined = _t(n, appearance, "user")
    cut = tok["chamfer"]
    if n == 12:
        head = plate(4, 1, 8, 5, 1)
        body = chamfer_polygon([(2, 6.5), (10, 6.5), (11, 11), (1, 11)], 1)
    elif n == 16:
        head = plate(5.5, 1.5, 10.5, 6.5, 1.5)
        body = chamfer_polygon([(3.5, 8.5), (12.5, 8.5), (14.5, 14.5), (1.5, 14.5)], 1.5)
    else:
        head = plate(8, 2, 16, 10, 2)
        body = chamfer_polygon([(5, 13), (19, 13), (22, 22), (2, 22)], 2)
    return union(_obj(head, w, outlined), _obj(body, w, outlined))


def _file(n, appearance):
    tok, w, outlined = _t(n, appearance, "file")
    if n == 12:
        shape = polygon(
            [(3, 1), (7, 1), (10, 4), (10, 10), (9, 11), (3, 11), (2, 10), (2, 2)]
        )
        content = None
    elif n == 16:
        shape = polygon(
            [
                (3 + 1.5, 1.5),
                (9.5, 1.5),
                (13, 5),
                (13, 13),
                (11.5, 14.5),
                (3 + 1.5, 14.5),
                (3, 13),
                (3, 3),
            ]
        )
        content = None
    else:
        shape = polygon(
            [(6, 2), (14, 2), (20, 8), (20, 20), (18, 22), (6, 22), (4, 20), (4, 4)]
        )
        content = box(8, 14, 16, 16)
    g = _obj(shape, w, outlined)
    if content is None:
        return g
    return union(g, content) if outlined else g.difference(content)


def _calendar(n, appearance):
    tok, w, outlined = _t(n, appearance, "calendar")
    cut = min(tok["chamfer"], 1.5 if n == 16 else tok["chamfer"])
    if n == 12:
        body = plate(1, 3.5, 11, 11, 1)
        tabs = union(box(3, 1, 4, 4.5), box(8, 1, 9, 4.5))
        marks = box(5, 6.5, 7, 8.5)
        header = None
    elif n == 16:
        body = plate(2, 4.5, 14, 14.5, 1.5)
        tabs = union(box(4.5, 1.5, 6, 5.5), box(10, 1.5, 11.5, 5.5))
        marks = union(box(5, 8.5, 7, 10.5), box(9, 8.5, 11, 10.5))
        header = None
    else:
        body = plate(3, 6, 21, 22, 2)
        tabs = union(box(7, 2, 9, 8), box(15, 2, 17, 8))
        header = box(5, 8, 19, 10)
        marks = union(box(7, 13, 10, 16), box(14, 13, 17, 16))
    if outlined:
        parts = [ring(body, w), tabs, marks]
        if header is not None:
            parts.append(header)
        return union(*parts)
    holes = marks if header is None else union(header, marks)
    return union(body, tabs).difference(holes)


def _sliders(n, appearance):
    tok, w, outlined = _t(n, appearance, "sliders")
    if n == 12:
        rows = (3.5, 8.5)
        knobs = ((3.5, 3.5), (8.5, 8.5))
        size, pad = 3.0, 1.0
    elif n == 16:
        rows = (4.5, 11.5)
        knobs = ((5, 4.5), (11, 11.5))
        size, pad = 4.5, 1.5
    else:
        rows = (8, 16)
        knobs = ((8, 8), (16, 16))
        size, pad = 6.0, 2.0
    cut = part_chamfer("sliders", n)
    parts = []
    for (kx, ky), y in zip(knobs, rows):
        knob = plate(kx - size / 2, ky - size / 2, kx + size / 2, ky + size / 2, cut)
        rail = box(pad, y - w / 2, n - pad, y + w / 2).difference(knob)
        parts.append(rail)
        parts.append(ring(knob, w) if outlined else knob)
    return union(*parts)


def _warning(n, appearance):
    tok, w, outlined = _t(n, appearance, "warning")
    cut = tok["chamfer"]
    # Punctuation sits in the wide lower third so it is not jammed into the
    # apex. Outline mark-to-frame gap is still recorded after measurement.
    spec = WARNING_GEOMETRY[n]
    pts = spec["pts"]
    marks = union(*[box(*b) for b in spec["marks"]])
    if outlined:
        return union(chamfered_frame(pts, cut, w), marks)
    return chamfer_polygon(pts, cut).difference(marks)


def _link(n, appearance):
    tok, w, outlined = _t(n, appearance, "link")
    cut = tok["chamfer"]
    if n == 12:
        left = plate(1, 3.5, 7, 8.5, 1)
        right = plate(5, 3.5, 11, 8.5, 1)
    elif n == 16:
        left = plate(1.5, 4.5, 9.5, 11.5, 1.5)
        right = plate(6.5, 4.5, 14.5, 11.5, 1.5)
    else:
        left = plate(2, 7, 14, 17, 2)
        right = plate(10, 7, 22, 17, 2)
    # Weight pair: heavier contour, never filled loops.
    return union(ring(left, w), ring(right, w))


def _branch(n, appearance):
    tok, w, outlined = _t(n, appearance, "branch")
    # Rails keep the outline token in both appearances (pipes, not blobs).
    rail_w = tok["outline"]
    cut = part_chamfer("branch", n)
    if n == 12:
        left = plate(1, 4.5, 4, 7.5, cut)
        top = plate(8, 1, 11, 4, cut)
        bot = plate(8, 8, 11, 11, cut)
        rails = union(
            bar((4, 6), (6, 6), rail_w),
            bar((6, 2.5), (6, 9.5), rail_w),
            bar((6, 2.5), (8, 2.5), rail_w),
            bar((6, 9.5), (8, 9.5), rail_w),
        )
    elif n == 16:
        left = plate(1.5, 5.75, 6, 10.25, cut)
        top = plate(11.5, 1.5, 16, 6, cut)
        bot = plate(11.5, 10, 16, 14.5, cut)
        rails = union(
            bar((6, 8), (8.5, 8), rail_w),
            bar((8.5, 3.75), (8.5, 12.25), rail_w),
            bar((8.5, 3.75), (11.5, 3.75), rail_w),
            bar((8.5, 12.25), (11.5, 12.25), rail_w),
        )
    else:
        left = plate(2, 9, 8, 15, cut)
        top = plate(16, 2, 22, 8, cut)
        bot = plate(16, 16, 22, 22, cut)
        rails = union(
            bar((8, 12), (12, 12), rail_w),
            bar((12, 5), (12, 19), rail_w),
            bar((12, 5), (16, 5), rail_w),
            bar((12, 19), (16, 19), rail_w),
        )
    nodes = (left, top, bot)
    pipes = rails.difference(union(*nodes))
    drawn = [_obj(node, w, outlined) for node in nodes]
    return union(pipes, *drawn)


def _star(n, appearance):
    tok, w, outlined = _t(n, appearance, "star")
    c = tok["center"]
    if n == 12:
        r_out, r_in = 5.0, 2.05
    elif n == 16:
        r_out, r_in = 6.6, 2.55
    else:
        r_out, r_in = 10.0, 3.85
    pts = []
    rot = -math.pi / 2
    for i in range(10):
        r = r_out if i % 2 == 0 else r_in
        a = rot + i * math.pi / 5
        pts.append((c + r * math.cos(a), c + r * math.sin(a)))
    shape = polygon(pts)
    return _obj(shape, w, outlined)


# Construction constants shared with the exception measurer (one source of truth).
WARNING_GEOMETRY = {
    12: {
        "pts": [(6, 1), (11, 11), (1, 11)],
        "marks": [(5.5, 6.5, 6.5, 7.5), (5.5, 8.5, 6.5, 9.0)],
    },
    16: {
        "pts": [(8, 1.5), (14.5, 14.5), (1.5, 14.5)],
        "marks": [(7.25, 9.85, 8.75, 10.85), (7.25, 11.5, 8.75, 12.4)],
    },
    24: {
        "pts": [(12, 2), (22, 22), (2, 22)],
        "marks": [(11, 13.5, 13, 15.5), (11, 16.75, 13, 18.5)],
    },
}


DRAW = {
    "home": _home,
    "search": _search,
    "plus": _plus,
    "arrow-right": _arrow_right,
    "user": _user,
    "file": _file,
    "calendar": _calendar,
    "sliders": _sliders,
    "warning": _warning,
    "link": _link,
    "branch": _branch,
    "star": _star,
}
