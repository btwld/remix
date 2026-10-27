"""Soft geometry primitives.

These are the construction vocabulary. Icons are authored from circles,
stadiums, rounded rects, round-capped strokes, and round-joined polygons.
They are not offset/fillet filters applied to Angular paths.
"""
from __future__ import annotations

from shapely.geometry import LineString, Point, Polygon, box
from shapely.geometry.base import BaseGeometry
from shapely.ops import unary_union

from source.seams import QUAD_SEGS

CAP_ROUND = 1
JOIN_ROUND = 1


def union(*geoms: BaseGeometry) -> BaseGeometry:
    parts = [g for g in geoms if g is not None and not g.is_empty]
    if not parts:
        raise ValueError('empty union')
    return unary_union(parts)


def circle(cx: float, cy: float, r: float) -> BaseGeometry:
    if r <= 0:
        raise ValueError('circle radius must be positive')
    return Point(cx, cy).buffer(r, quad_segs=QUAD_SEGS, cap_style=CAP_ROUND, join_style=JOIN_ROUND)


def stadium_line(x0: float, y0: float, x1: float, y1: float, width: float) -> BaseGeometry:
    if width <= 0:
        raise ValueError('capsule width must be positive')
    if (x0, y0) == (x1, y1):
        return circle(x0, y0, width / 2)
    return LineString([(x0, y0), (x1, y1)]).buffer(
        width / 2, quad_segs=QUAD_SEGS, cap_style=CAP_ROUND, join_style=JOIN_ROUND)


def polyline_capsule(points: list[tuple[float, float]], width: float) -> BaseGeometry:
    if width <= 0:
        raise ValueError('capsule width must be positive')
    if len(points) < 2:
        raise ValueError('polyline needs two points')
    return LineString(points).buffer(
        width / 2, quad_segs=QUAD_SEGS, cap_style=CAP_ROUND, join_style=JOIN_ROUND)


def rounded_rect(x0: float, y0: float, x1: float, y1: float, r: float) -> BaseGeometry:
    if x1 <= x0 or y1 <= y0:
        raise ValueError('empty rounded rect')
    w, h = x1 - x0, y1 - y0
    r = min(max(r, 0.0), w / 2, h / 2)
    if r <= 0:
        return box(x0, y0, x1, y1)
    if abs(r - w / 2) < 1e-9 and abs(r - h / 2) < 1e-9:
        return circle((x0 + x1) / 2, (y0 + y1) / 2, r)
    if abs(r - h / 2) < 1e-9:
        y = (y0 + y1) / 2
        return stadium_line(x0 + r, y, x1 - r, y, 2 * r)
    if abs(r - w / 2) < 1e-9:
        x = (x0 + x1) / 2
        return stadium_line(x, y0 + r, x, y1 - r, 2 * r)
    return box(x0 + r, y0 + r, x1 - r, y1 - r).buffer(
        r, quad_segs=QUAD_SEGS, cap_style=CAP_ROUND, join_style=JOIN_ROUND)


def ring(poly: BaseGeometry, width: float) -> BaseGeometry:
    if width <= 0:
        raise ValueError('ring width must be positive')
    inner = poly.buffer(-width, quad_segs=QUAD_SEGS, cap_style=CAP_ROUND, join_style=JOIN_ROUND)
    if inner.is_empty:
        raise ValueError('ring collapsed; inner contour is empty')
    g = poly.difference(inner)
    if g.is_empty:
        raise ValueError('ring difference is empty')
    return g


def round_convex(poly: BaseGeometry, r: float) -> BaseGeometry:
    """Round convex corners by expanding then shrinking with round joins."""
    if r <= 0:
        return poly
    g = poly.buffer(r, quad_segs=QUAD_SEGS, cap_style=CAP_ROUND, join_style=JOIN_ROUND)
    g = g.buffer(-r, quad_segs=QUAD_SEGS, cap_style=CAP_ROUND, join_style=JOIN_ROUND)
    if g.is_empty or not g.is_valid:
        raise ValueError('round_convex collapsed')
    return g


def round_all(poly: BaseGeometry, r: float) -> BaseGeometry:
    """Round convex and concave corners. r must stay well below local feature size."""
    if r <= 0:
        return poly
    g = poly.buffer(r, quad_segs=QUAD_SEGS, cap_style=CAP_ROUND, join_style=JOIN_ROUND)
    g = g.buffer(-2 * r, quad_segs=QUAD_SEGS, cap_style=CAP_ROUND, join_style=JOIN_ROUND)
    g = g.buffer(r, quad_segs=QUAD_SEGS, cap_style=CAP_ROUND, join_style=JOIN_ROUND)
    if g.is_empty or not g.is_valid:
        raise ValueError('round_all collapsed')
    return g


def polygon(points: list[tuple[float, float]]) -> Polygon:
    g = Polygon(points)
    if not g.is_valid or g.area <= 0:
        raise ValueError('invalid polygon')
    return g


MIN_RING_AREA = 0.04


def clean(geom: BaseGeometry) -> BaseGeometry:
    """Drop sliver holes/parts left by round-join unions after decimal export."""
    g = geom.buffer(0)
    if g.is_empty:
        raise ValueError('clean collapsed geometry')
    parts = list(g.geoms) if g.geom_type == 'MultiPolygon' else [g]
    kept = []
    for part in parts:
        if not isinstance(part, Polygon) or part.area < MIN_RING_AREA:
            continue
        holes = [h for h in part.interiors if Polygon(h).area >= MIN_RING_AREA]
        kept.append(Polygon(part.exterior, holes))
    if not kept:
        raise ValueError('clean removed every part')
    return union(*kept) if len(kept) > 1 else kept[0]
