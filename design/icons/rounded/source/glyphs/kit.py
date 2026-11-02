"""Construction helpers shared by the Rounded glyph groups.

Everything here works in Rounded's own vocabulary: circles, round-capped strokes,
rounded hulls, and exact affine reflections. Nothing reads another family's paths.
"""
from __future__ import annotations

import math

from shapely import affinity

from source.primitives import circle, polyline_capsule, ring, rounded_rect, union
from source.seams import (
    ACUTE_JOIN, BOLD_WIDTH, CORNER_TOKEN, MASTERS, OUTLINE_WIDTH, PADDING, QUAD_SEGS,
    UnknownAppearanceError, UnknownMasterError,
)

# One arc step per 90 degrees of QUAD_SEGS, so drawn arcs flatten like buffered ones.
_ARC_STEP = 90 / QUAD_SEGS


def tokens(n: int, appearance: str):
    """(contour, active stroke, padding, is outline, object corner, acute join) for one drawing."""
    if n not in MASTERS:
        raise UnknownMasterError(f'No native Rounded master {n}')
    if appearance not in ('outline', 'filled'):
        raise UnknownAppearanceError(f'Unknown appearance {appearance!r}')
    w = OUTLINE_WIDTH[n]
    t = w if appearance == 'outline' else BOLD_WIDTH[n]
    return w, t, PADDING[n], appearance == 'outline', CORNER_TOKEN[n], ACUTE_JOIN[n]


def arc(cx: float, cy: float, r: float, start: float, end: float) -> list[tuple[float, float]]:
    """Centerline points from start to end, in degrees with y down, so increasing runs clockwise."""
    steps = max(2, math.ceil(abs(end - start) / _ARC_STEP))
    return [
        (cx + r * math.cos(math.radians(start + (end - start) * i / steps)),
         cy + r * math.sin(math.radians(start + (end - start) * i / steps)))
        for i in range(steps + 1)
    ]


def _fillet(a, b, c, r):
    """Replace vertex b with an arc of centerline radius r, tangent to both segments."""
    ux, uy = a[0] - b[0], a[1] - b[1]
    vx, vy = c[0] - b[0], c[1] - b[1]
    ul, vl = math.hypot(ux, uy), math.hypot(vx, vy)
    ux, uy, vx, vy = ux / ul, uy / ul, vx / vl, vy / vl
    angle = math.acos(max(-1.0, min(1.0, ux * vx + uy * vy)))
    setback = r / math.tan(angle / 2)
    if setback > min(ul, vl) + 1e-9:
        raise ValueError(f'fillet radius {r} does not fit at {b}')
    bx, by = ux + vx, uy + vy
    bl = math.hypot(bx, by)
    centre = (b[0] + bx / bl * r / math.sin(angle / 2), b[1] + by / bl * r / math.sin(angle / 2))
    first = (b[0] + ux * setback, b[1] + uy * setback)
    last = (b[0] + vx * setback, b[1] + vy * setback)
    start = math.degrees(math.atan2(first[1] - centre[1], first[0] - centre[0]))
    end = math.degrees(math.atan2(last[1] - centre[1], last[0] - centre[0]))
    delta = (end - start + 180) % 360 - 180
    return arc(centre[0], centre[1], r, start, start + delta)


def stroke(points, width: float, radius: float = 0.0):
    """A round-capped, round-joined stroke. A radius rounds the centerline's own corners as well."""
    if radius <= 0 or len(points) < 3:
        return polyline_capsule(list(points), width)
    line = [points[0]]
    for a, b, c in zip(points, points[1:], points[2:]):
        line.extend(_fillet(a, b, c, radius))
    line.append(points[-1])
    return polyline_capsule(line, width)


def soften_concave(geom, r: float):
    """Round concave junctions only: expanding first leaves the convex corners where they were."""
    return geom.buffer(r, quad_segs=QUAD_SEGS).buffer(-r, quad_segs=QUAD_SEGS)


def framed(shape, w: float, outlined: bool, marks=()):
    """A closed key shape. Outline: a contour ring with positive marks. Filled: solid, marks cut out."""
    marks = list(marks)
    if outlined:
        return union(ring(shape, w), *marks)
    return shape.difference(union(*marks)) if marks else shape


def panel(x0, y0, x1, y1, r, w, outlined):
    """A rounded panel: a contour ring in outline, solid in filled."""
    shape = rounded_rect(x0, y0, x1, y1, r)
    return ring(shape, w) if outlined else shape


def reflect_x(geom, n):
    """(x, y) -> (n - x, y). An exact reflection, so a stroke's pixel row is untouched."""
    return affinity.affine_transform(geom, [-1, 0, 0, 1, n, 0])


def reflect_y(geom, n):
    """(x, y) -> (x, n - y)."""
    return affinity.affine_transform(geom, [1, 0, 0, -1, 0, n])


def right_to_up(geom, n):
    """(x, y) -> (y, n - x). A drawing pointing right now points up, on the same pixel line."""
    return affinity.affine_transform(geom, [0, 1, -1, 0, 0, n])


def right_to_down(geom):
    """(x, y) -> (y, x). A reflection, so down shares up's pixel column instead of the opposite one."""
    return affinity.affine_transform(geom, [0, 1, 1, 0, 0, 0])


def disc(n):
    """The full circular frame on the padding keyline."""
    return circle(n / 2, n / 2, n / 2 - PADDING[n])
