"""Serialize Soft geometry to standalone SVG.

Product paths are expanded evenodd M/L/Z polylines. Round caps/joins and
circles are flattened at construction quad_segs. Curve commands are accepted
by the validator as fail-closed infrastructure, not emitted by this module.
"""
from __future__ import annotations

import html

from shapely import set_precision
from shapely.geometry import MultiPolygon, Polygon

GRID = 0.0001


def fmt(x: float) -> str:
    if abs(x) < GRID / 2:
        x = 0.0
    return f'{x:.4f}'.rstrip('0').rstrip('.')


def _polygons(geom) -> list[Polygon]:
    snapped = set_precision(geom, grid_size=GRID, mode='valid_output')
    if snapped.is_empty:
        return []
    if isinstance(snapped, Polygon):
        parts = [snapped]
    elif isinstance(snapped, MultiPolygon):
        parts = list(snapped.geoms)
    else:
        parts = [p for p in snapped.geoms if isinstance(p, Polygon)]
    return [p for p in parts if p.is_valid and p.area > 0.02]


def path_data(geom) -> str:
    if not geom.is_valid:
        raise ValueError('Invalid output geometry')
    polys = _polygons(geom)
    if not polys:
        raise ValueError('No polygonal output')
    paths = []
    for poly in sorted(polys, key=lambda x: (x.bounds[0], x.bounds[1], -x.area)):
        for ring in [poly.exterior, *poly.interiors]:
            coords = list(ring.coords)[:-1]
            paths.append('M' + 'L'.join(f'{fmt(x)} {fmt(y)}' for x, y in coords) + 'Z')
    return ''.join(paths)


def svg_text(label: str, appearance: str, n: int, path: str) -> str:
    title = html.escape(f'{label} — {appearance}')
    return (
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{n}" height="{n}" '
        f'viewBox="0 0 {n} {n}" fill="currentColor" fill-rule="evenodd" '
        f'role="img" focusable="false">\n  <title>{title}</title>\n'
        f'  <path d="{path}"/>\n</svg>\n'
    )
