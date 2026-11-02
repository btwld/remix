"""Registry and shared measurements for the product constructors."""
from __future__ import annotations

from shapely.geometry import MultiPolygon, Polygon, box

REGISTRY = {}
CANVAS = {12: (1, 11), 16: (1.5, 14.5), 24: (2, 22)}


def icon(*names):
    """Register one constructor, called as fn(name, n, outlined), per concept."""
    def register(fn):
        for name in names:
            if name in REGISTRY:
                raise ValueError(f'Duplicate constructor: {name}')
            REGISTRY[name] = fn
        return fn
    return register


def _clean_ring(ring_):
    points = list(ring_.coords)[:-1]
    changed = True
    while changed:
        changed = False
        for i in range(len(points)):
            (ax, ay), (bx, by), (cx, cy) = points[i - 1], points[i], points[(i + 1) % len(points)]
            if abs((bx - ax) * (cy - by) - (by - ay) * (cx - bx)) < 1e-6:
                del points[i]
                changed = True
                break
    return points


def without_collinear_vertices(geometry):
    """Export only real corners.

    A boolean union leaves extra vertices along straight edges. The font compiler
    drops them, and Cairo samples a pixel row differently once a vertex falls inside
    it, so a leftover vertex makes the SVG and its font glyph rasterize differently.
    """
    polygons = list(geometry.geoms) if isinstance(geometry, MultiPolygon) else [geometry]
    cleaned = [Polygon(_clean_ring(p.exterior), [_clean_ring(hole) for hole in p.interiors]) for p in polygons]
    return cleaned[0] if len(cleaned) == 1 else MultiPolygon(cleaned)


def rects(*specs):
    """Axis-aligned rectangles given as (x0, y0, x1, y1)."""
    return [box(*spec) for spec in specs]
