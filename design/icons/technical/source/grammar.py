"""Technical construction tokens and primitives.

Plates are chamfered rectangles. Bars have square-cut terminals.
No round caps, no curves, no live SVG strokes.
"""
from __future__ import annotations
import math
from shapely.geometry import Polygon, box
from shapely.ops import unary_union

from source.contract import MASTERS, UnavailableMaster

OUTLINE = {12: 1.0, 16: 1.5, 24: 2.0}
HEAVY = {12: 2.0, 16: 2.5, 24: 3.0}
CHAMFER = {12: 1.0, 16: 1.5, 24: 2.0}
PAD = {12: 1.0, 16: 1.5, 24: 2.0}
GAP = {12: 1.0, 16: 1.5, 24: 2.0}

# Plus uses a tighter keyline than PAD so it is not an Angular pad-to-pad copy.
PLUS_INSET = {12: 2.0, 16: 2.5, 24: 3.0}

# Dense junction/knob plates cannot take the full chamfer token without
# collapsing the outline ring. Keys are (icon_id, native_size).
CHAMFER_OVERRIDE = {
    ("sliders", 12): 0.75,
    ("sliders", 16): 1.0,
    ("sliders", 24): 1.5,
    ("branch", 12): 0.75,
    ("branch", 16): 1.0,
    ("branch", 24): 1.5,
}


def tokens(n):
    if n not in MASTERS:
        raise UnavailableMaster(n)
    return {
        "n": n,
        "outline": OUTLINE[n],
        "heavy": HEAVY[n],
        "chamfer": CHAMFER[n],
        "pad": PAD[n],
        "gap": GAP[n],
        "plus_inset": PLUS_INSET[n],
        "center": n / 2.0,
    }


def part_chamfer(icon_id, n):
    """Chamfer actually used for this part. Differs from tokens()['chamfer']
    only when CHAMFER_OVERRIDE records a collapse-avoiding reduction.
    """
    if n not in MASTERS:
        raise UnavailableMaster(n)
    return CHAMFER_OVERRIDE.get((icon_id, n), CHAMFER[n])


def contour_width(n, appearance, pair_model):
    """Stroke token for the requested appearance.

    Silhouette objects always use the outline token for the shell (filled is
    a solid plate). Weight-pair open glyphs use outline vs heavy.
    """
    t = tokens(n)
    if pair_model == "weight":
        return t["outline"] if appearance == "outline" else t["heavy"]
    return t["outline"]


def union(*geoms):
    return unary_union([g for g in geoms if g is not None and not g.is_empty])


def polygon(points):
    g = Polygon(points)
    if not g.is_valid:
        raise ValueError("Invalid polygon %s" % (points,))
    return g


def plate(x0, y0, x1, y1, cut):
    """Axis-aligned rectangle with 45° corner cuts. Degenerate cut → box."""
    width = x1 - x0
    height = y1 - y0
    if width <= 0 or height <= 0:
        raise ValueError("plate requires positive size")
    c = min(float(cut), width / 2.0 - 0.05, height / 2.0 - 0.05)
    if c < 0.05:
        return box(x0, y0, x1, y1)
    return polygon(
        [
            (x0 + c, y0),
            (x1 - c, y0),
            (x1, y0 + c),
            (x1, y1 - c),
            (x1 - c, y1),
            (x0 + c, y1),
            (x0, y1 - c),
            (x0, y0 + c),
        ]
    )


def chamfer_polygon(points, cut):
    """Replace each vertex with a two-point plate chamfer along the edges."""
    pts = list(points)
    n = len(pts)
    out = []
    for i in range(n):
        prev, cur, nxt = pts[i - 1], pts[i], pts[(i + 1) % n]
        v1 = (prev[0] - cur[0], prev[1] - cur[1])
        v2 = (nxt[0] - cur[0], nxt[1] - cur[1])
        l1 = math.hypot(*v1)
        l2 = math.hypot(*v2)
        if l1 < 1e-9 or l2 < 1e-9:
            out.append(cur)
            continue
        c1 = min(cut, l1 * 0.45)
        c2 = min(cut, l2 * 0.45)
        out.append((cur[0] + v1[0] / l1 * c1, cur[1] + v1[1] / l1 * c1))
        out.append((cur[0] + v2[0] / l2 * c2, cur[1] + v2[1] / l2 * c2))
    return polygon(out)


def bar(p0, p1, weight):
    """Square-cut stroke: rectangle aligned to the segment, ends perpendicular."""
    dx = p1[0] - p0[0]
    dy = p1[1] - p0[1]
    length = math.hypot(dx, dy)
    if length < 1e-9:
        raise ValueError("bar requires a non-zero length")
    ux, uy = dx / length, dy / length
    nx, ny = -uy * weight / 2.0, ux * weight / 2.0
    return polygon(
        [
            (p0[0] + nx, p0[1] + ny),
            (p0[0] - nx, p0[1] - ny),
            (p1[0] - nx, p1[1] - ny),
            (p1[0] + nx, p1[1] + ny),
        ]
    )


def ring(poly, width):
    inner = poly.buffer(-width, join_style=2, mitre_limit=4)
    if inner.is_empty:
        raise ValueError("ring collapsed; contour wider than plate")
    g = poly.difference(inner)
    if g.is_empty or not g.is_valid:
        raise ValueError("ring produced empty geometry")
    return g


def chamfered_frame(points, cut, width):
    """Outline for acute plates (warning). Chamfer the outer shell; inset the
    unchamfered source so the inner contour does not collapse at the apex.
    """
    source = polygon(points)
    outer = chamfer_polygon(points, cut)
    inner = source.buffer(-width, join_style=2, mitre_limit=4)
    if inner.is_empty:
        raise ValueError("chamfered_frame inner collapsed")
    g = outer.difference(inner)
    if g.is_empty or not g.is_valid:
        raise ValueError("chamfered_frame produced empty geometry")
    return g


def edge_angles_deg(poly, snap=0.5):
    """Exterior edge angles in [0, 180), snapped. Used by grammar tests."""
    coords = list(poly.exterior.coords)
    angles = []
    for (x0, y0), (x1, y1) in zip(coords, coords[1:]):
        deg = math.degrees(math.atan2(y1 - y0, x1 - x0)) % 180.0
        angles.append(round(deg / snap) * snap)
    return angles
