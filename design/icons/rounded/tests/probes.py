"""Measurement probes shared by the Rounded suites. They read exported SVG geometry, never drawer arguments."""
from __future__ import annotations

import hashlib
import io
from itertools import combinations
import math
from pathlib import Path

from PIL import Image
import cairosvg
from shapely import line_merge, maximum_inscribed_circle
from shapely.geometry import LineString, MultiPolygon, Point, Polygon, box

from source.seams import (
    APPEARANCES, BOLD_WIDTH, CENTRED_AXIS, COUNTER_FLOOR, GAP_TARGET, MASTERS, PAIR_MODEL,
    THINNED_FILLED_STROKE,
)
from source.svg import path_data, svg_text
from source.validate import parse_svg

ROOT = Path(__file__).resolve().parents[1]

# NegativeControlTests proves that each one fails on the defect it guards against.
FLATTENING_SLACK = 0.02  # Flattened arcs measure slightly under their nominal width.
MID_WIDTH_BLOB = 0.69  # A triangle at the full CORNER_TOKEN reaches this on every master.


def product(icon_id, n, appearance):
    path = ROOT / 'generated' / 'rounded' / appearance / str(n) / f'{icon_id}.svg'
    return parse_svg(path.read_text())[2]


def parts(g):
    return sorted(g.geoms if isinstance(g, MultiPolygon) else [g], key=lambda p: p.area, reverse=True)


def holes(g):
    return [Polygon(h) for p in parts(g) for h in p.interiors]


def convex_radii(ring):
    """Local convex radius at each vertex, as (x, y, radius).

    Walks each convex run until it has turned 30 degrees and divides the path
    length by the turn. An arc reports its radius; a sharp corner reports about 0.
    """
    pts = []
    for point in list(ring.coords)[:-1]:
        # Boolean noise leaves 0.001 px steps. They are not corners; a real one survives.
        if not pts or math.dist(pts[-1], point) > 0.01:
            pts.append(point)
    sign = 1 if ring.is_ccw else -1
    count = len(pts)

    def turn(i):
        ax, ay = pts[i - 1]
        bx, by = pts[i]
        cx, cy = pts[(i + 1) % count]
        return sign * math.atan2(
            (bx - ax) * (cy - by) - (by - ay) * (cx - bx),
            (bx - ax) * (cx - bx) + (by - ay) * (cy - by))

    turns = [turn(i) for i in range(count)]
    found = []
    for start in range(count):
        if turns[start] <= 1e-3:
            continue
        total, length, i = 0.0, 0.0, start
        for _ in range(count):
            total += turns[i]
            if turns[i] < -1e-3:
                total = 0.0
                break
            if total >= math.pi / 6:
                break
            j = (i + 1) % count
            length += math.dist(pts[i], pts[j])
            i = j
        if total >= math.pi / 6:
            bend = total - (turns[start] + turns[i]) / 2
            found.append((*pts[start], length / bend if bend > 1e-6 else 0.0))
    return found


def min_convex_radius(g, region=None):
    radii = []
    for part in parts(g):
        radii += [r for x, y, r in convex_radii(part.exterior)
                  if region is None or region.contains(Point(x, y))]
    return min(radii)


def corner_setback(g, x, y):
    """Distance from a bounding-box corner to the artwork: 0.414 R for an arc of radius R."""
    return g.distance(Point(x, y))


def mid_width_ratio(g, n):
    """Silhouette width halfway down, over the widest extent: 0.5 for a sharp triangle."""
    minx, miny, maxx, maxy = g.bounds
    middle = (miny + maxy) / 2
    solid = Polygon(parts(g)[0].exterior)
    return solid.intersection(LineString([(0, middle), (n, middle)])).length / (maxx - minx)


def counters(g, n):
    """Transparent regions enclosed at the GRAMMAR floor, as inscribed diameters.

    Air narrower than the floor counts as closed, so a slit does not merge two
    counters, and a pocket below the floor never registers as one.
    """
    floor = COUNTER_FLOOR[n]
    air = box(-4, -4, n + 4, n + 4).difference(g).buffer(-floor / 2)
    found = []
    for part in parts(air):
        if part.contains(Point(-2, -2)):
            continue
        region = part.buffer(floor / 2)
        found.append(2 * maximum_inscribed_circle(region).length)
    return sorted(found)


def hole_diameters(g):
    return sorted(2 * maximum_inscribed_circle(h).length for h in holes(g))


def narrowest_part(g):
    return min(2 * maximum_inscribed_circle(p).length for p in parts(g))


def stroke_width(g):
    return max(2 * maximum_inscribed_circle(p).length for p in parts(g))


def pixel_alpha(g, n):
    """Native 1x coverage, through the same CairoSVG path as the proofs."""
    text = svg_text('probe', 'outline', n, path_data(g)).replace('currentColor', '#000000')
    return Image.open(io.BytesIO(cairosvg.svg2png(bytestring=text.encode()))).convert('RGBA').getchannel('A')


def line_concentration(alpha, cells):
    """(peak coverage, peak share of the ink) across cells that lie in a line across a stroke."""
    values = [alpha.getpixel(cell) / 255 for cell in cells]
    return max(values), max(values) / sum(values)


def expected_register(geometry):
    """Below-target values, measured independently of source/build.py, as {id: (target, measured)}."""
    found = {}
    for n in MASTERS:
        for appearance in APPEARANCES:
            link = geometry('link', n, appearance)
            separation = parts(link)[0].distance(parts(link)[1])
            if separation < GAP_TARGET[n]:
                found[f'link-{appearance}-{n}-weave-separation'] = (GAP_TARGET[n], separation)
            if appearance == 'filled' and stroke_width(link) < BOLD_WIDTH[n] - FLATTENING_SLACK:
                found[f'link-filled-{n}-open-glyph-filled-width'] = (BOLD_WIDTH[n], stroke_width(link))
            branch = hole_diameters(geometry('branch', n, appearance))
            if branch and branch[0] < COUNTER_FLOOR[n] - FLATTENING_SLACK:
                found[f'branch-{appearance}-{n}-counter-inscribed-diameter'] = (COUNTER_FLOOR[n], branch[0])
            for icon, axis in CENTRED_AXIS.items():
                lo, hi = (0, 2) if axis == 'x' else (1, 3)
                bounds = geometry(icon, n, appearance).bounds
                offset = abs((bounds[lo] + bounds[hi]) / 2 - n / 2)
                if offset > 0.01:
                    rule = 'weight-pair-centerline-offset' if PAIR_MODEL[icon] == 'weight' else 'canvas-centre-offset'
                    found[f'{icon}-{appearance}-{n}-{rule}'] = (0, offset)
            if appearance == 'filled':
                for icon in THINNED_FILLED_STROKE:
                    width = narrowest_part(geometry(icon, n, appearance))
                    if width < BOLD_WIDTH[n] - FLATTENING_SLACK:
                        found[f'{icon}-filled-{n}-open-glyph-filled-width'] = (BOLD_WIDTH[n], width)
    return found


def register_problems(records, expected, sha_of):
    """Why a register does not describe the current artwork. Empty means it is fresh."""
    problems = []
    by_id = {r['id']: r for r in records}
    if len(by_id) != len(records):
        problems.append('duplicate id')
    for missing in expected.keys() - by_id.keys():
        problems.append(f'unregistered {missing}')
    for record in records:
        if record['id'] not in expected:
            problems.append(f'stale {record["id"]}')
            continue
        target, measured = expected[record['id']]
        if record['target'] != target or abs(record['measuredApprox'] - measured) > 0.001:
            problems.append(f'wrong measurement {record["id"]}')
        if record['geometrySha256'] != sha_of(record['icon'], record['nativeSize'], record['appearance']):
            problems.append(f'wrong hash {record["id"]}')
    return problems


def long_axis_degrees(g):
    """Direction of the artwork's long axis, in canvas degrees: 45 points up and to the right."""
    hull = list(g.convex_hull.exterior.coords)
    (ax, ay), (bx, by) = max(combinations(hull, 2), key=lambda pair: math.dist(*pair))
    return math.degrees(math.atan2(ay - by, bx - ax)) % 180


def artwork_sha(icon_id, n, appearance):
    path = ROOT / 'generated' / 'rounded' / appearance / str(n) / f'{icon_id}.svg'
    return hashlib.sha256(path.read_bytes()).hexdigest()


def closest_parts(g):
    """Smallest distance between two separate parts, or None for a single part."""
    found = parts(g)
    if len(found) < 2:
        return None
    return min(a.distance(b) for a, b in combinations(found, 2))


def overlap(a, b):
    """Shared ink over all ink: 1 for identical artwork, 0 for disjoint."""
    return a.intersection(b).area / a.union(b).area


def crossings(g, centre, radius):
    """How many separate ink runs a circle at this radius passes through."""
    line = Point(centre, centre).buffer(radius, quad_segs=64).exterior.intersection(g)
    if line.is_empty:
        return 0
    # The circle's own start point splits one run in two, so merge before counting.
    line = line_merge(line) if hasattr(line, 'geoms') else line
    return len(line.geoms) if hasattr(line, 'geoms') else 1


def line_widths(g, axis, at):
    """Ink runs along one horizontal (axis 'y') or vertical (axis 'x') scan line, as (start, end)."""
    minx, miny, maxx, maxy = g.bounds
    if axis == 'y':
        scan = LineString([(minx - 1, at), (maxx + 1, at)])
        index = 0
    else:
        scan = LineString([(at, miny - 1), (at, maxy + 1)])
        index = 1
    hit = g.intersection(scan)
    runs = list(hit.geoms) if hasattr(hit, 'geoms') else ([] if hit.is_empty else [hit])
    return sorted((run.bounds[index], run.bounds[index + 2]) for run in runs)
