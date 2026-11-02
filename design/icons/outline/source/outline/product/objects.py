"""Devices, containers and interface objects."""
from __future__ import annotations

from shapely.geometry import box

from ..baseline import OUTLINE, P, U, line, octagon, ring
from .common import icon, rects

# Center, left and right walls, top apex and bottom. Slopes are 2:1. The 12 px carton
# is a pixel narrower, so its center seam is a crisp column on 5.5.
CARTON = {12: (5.5, 1, 10, 1, 11), 16: (8, 2, 14, 1.5, 14.5), 24: (12, 3, 21, 2, 22)}


@icon('box')
def box_(_, n, outlined):
    c, x0, x1, top, bottom = CARTON[n]
    w = OUTLINE[n]
    half = x1 - c
    shoulder, center = top + half / 2, top + half
    # The bottom apex is flat at seam width, so the seam never shortens one style.
    hip = bottom - (half - w / 2) / 2
    outer = P([(c, top), (x1, shoulder), (x1, hip), (c + w / 2, bottom), (c - w / 2, bottom), (x0, hip), (x0, shoulder)])
    seams = U(line([(x0 - 2, shoulder - 1), (c, center), (x1 + 2, shoulder - 1)], w), box(c - w / 2, center, c + w / 2, bottom + 1))
    return U(ring(outer, w), seams.intersection(outer)) if outlined else outer.difference(seams)


LAYERS = {
    12: {'top': [(6, 1), (11, 3.5), (6, 6), (1, 3.5)], 'rows': {True: (8.25,), False: (8.75,)}},
    16: {'top': [(8, 1.5), (14.5, 4.75), (8, 8), (1.5, 4.75)], 'rows': {True: (11.5,), False: (11.75,)}},
    24: {'top': [(12, 2), (22, 7), (12, 12), (2, 7)], 'rows': {True: (15.5, 20), False: (15.5, 20.25)}},
}


@icon('layers')
def layers(_, n, outlined):
    spec = LAYERS[n]
    top = P(spec['top'])
    a, z = top.bounds[0], top.bounds[2]
    c = n / 2
    half = (z - a) / 2
    t = OUTLINE[n] if outlined else {12: 1.5, 16: 2, 24: 2.25}[n]
    sheets = []
    for apex in spec['rows'][outlined]:
        stroke = line([(a - 2, apex - half / 2 - 1), (c, apex), (z + 2, apex - half / 2 - 1)], t)
        sheets.append(stroke.intersection(box(a, 0, z, n)))
    return U(ring(top, OUTLINE[n]) if outlined else top, *sheets)


@icon('laptop')
def laptop(_, n, outlined):
    screen, base, w = {12: ((2, 2, 10, 8), [(1, 9), (11, 9), (10, 10), (2, 10)], 1),
                       16: ((3, 3, 13, 11), [(1.5, 12.5), (14.5, 12.5), (13, 14), (3, 14)], 1.5),
                       24: ((4, 3, 20, 16), [(2, 18), (22, 18), (20, 20), (4, 20)], 2)}[n]
    glass = box(*screen)
    return U(ring(glass, w) if outlined else glass, P(base))


@icon('smartphone')
def smartphone(_, n, outlined):
    # A home mark low in the body: a square pixel block at 12 px, a bar above that.
    body, mark = {12: ((3, 1, 9, 11, 1), (5, 7, 7, 9)),
                  16: ((4, 1.5, 12, 14.5, 1.5), (7, 10, 9, 11.5)),
                  24: ((6, 2, 18, 22, 2), (10, 16, 14, 18))}[n]
    shape = octagon(*body)
    home = box(*mark)
    return U(ring(shape, OUTLINE[n]), home) if outlined else shape.difference(home)


@icon('input')
def input_(_, n, outlined):
    # The I-beam breaks the field, so the frame is two open brackets and the
    # insertion point remains the tallest thing in the drawing.
    field, stem, serif, top, bottom, clear = {
        12: ((1, 3, 11, 9), (4, 5), 1.0, 1, 11, 1),
        16: ((1.5, 4.5, 14.5, 11.5), (5, 6.5), 1.5, 1.5, 14.5, 1.5),
        24: ((2, 6, 22, 18), (7, 9), 2.0, 2, 22, 2)}[n]
    w = OUTLINE[n]
    x0, x1 = stem
    lane = box(x0 - clear, field[1] - 1, x1 + clear, field[3] + 1)
    frame = box(*field)
    body = (ring(frame, w) if outlined else frame).difference(lane)
    beam = U(box(x0, top, x1, bottom), *rects((x0 - serif, top, x1 + serif, top + w), (x0 - serif, bottom - w, x1 + serif, bottom)))
    return U(body, beam)


# Frame, header rail, optional row rule, and column rule. Positive at contour
# weight in Outline; in Filled the header stays solid and the cells are cut out.
TABLE = {12: ((1, 1, 11, 11), (4, 5), (7, 8), (5, 6)),
         16: ((1.5, 1.5, 14.5, 14.5), (5, 6.5), (9, 10.5), (7.25, 8.75)),
         24: ((3, 3, 21, 21), (7, 9), (13, 15), (11, 13))}


@icon('table')
def table(_, n, outlined):
    frame_box, rail, row, column = TABLE[n]
    x0, y0, x1, y1 = frame_box
    w = OUTLINE[n]
    frame = box(*frame_box)
    if outlined:
        return U(ring(frame, w), box(x0, rail[0], x1, rail[1]), box(x0, row[0], x1, row[1]), box(column[0], rail[1], column[1], y1))
    cells = [box(a, b, c, d) for a, c in ((x0 + w, column[0]), (column[1], x1 - w))
             for b, d in ((rail[1], row[0]), (row[1], y1 - w))]
    return frame.difference(U(*cells))


# Staggered columns: tall over short, then short over tall. Panels differ in size
# so the overview cannot be mistaken for Grid's four equal cells.
DASHBOARD = {12: ((1, 1, 5, 6), (1, 8, 5, 11), (7, 1, 11, 4), (7, 6, 11, 11)),
             16: ((1.5, 1.5, 7, 8), (1.5, 10, 7, 14.5), (9, 1.5, 14.5, 6), (9, 8, 14.5, 14.5)),
             24: ((3, 3, 11, 13), (3, 15, 11, 21), (13, 3, 21, 9), (13, 11, 21, 21))}


@icon('dashboard')
def dashboard(_, n, outlined):
    panels = rects(*DASHBOARD[n])
    return U(*[ring(panel, OUTLINE[n]) if outlined else panel for panel in panels])


# Marching-ants frame with two selected objects. Focus has only corners and a
# center mark; here the side dashes say "selection" and the pair says "group".
GROUP = {12: {'edge': (1, 11), 'arm': 2, 'dash': (5, 7), 't': 1, True: ((3, 3, 5, 5), (7, 7, 9, 9)), False: ((3, 3, 7, 7), (5, 5, 9, 9))},
         16: {'edge': (1.5, 14.5), 'arm': 3, 'dash': (6, 10), 't': 1.5, True: ((4.5, 4.5, 7, 7), (9, 9, 11.5, 11.5)), False: ((4.5, 4.5, 9, 9), (7, 7, 11.5, 11.5))},
         24: {'edge': (2, 22), 'arm': 5, 'dash': (9, 15), 't': 2, True: ((6, 6, 11, 11), (13, 13, 18, 18)), False: ((6, 6, 13, 13), (11, 11, 18, 18))}}


@icon('group')
def group(_, n, outlined):
    spec = GROUP[n]
    a, z = spec['edge']
    arm, (d0, d1) = spec['arm'], spec['dash']
    t, objects = spec['t'], spec[outlined]
    frame = []
    for x, y, sx, sy in ((a, a, 1, 1), (z, a, -1, 1), (a, z, 1, -1), (z, z, -1, -1)):
        frame.append(box(min(x, x + sx * arm), min(y, y + sy * t), max(x, x + sx * arm), max(y, y + sy * t)))
        frame.append(box(min(x, x + sx * t), min(y, y + sy * arm), max(x, x + sx * t), max(y, y + sy * arm)))
    frame += rects((d0, a, d1, a + t), (d0, z - t, d1, z), (a, d0, a + t, d1), (z - t, d0, z, d1))
    return U(*frame, *rects(*objects))
