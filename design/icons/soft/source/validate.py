"""Curve-aware path parser for the Soft pilot.

Angular's parser rejects curves. Soft requires this module: construction uses
round caps/joins and circular nodes, and serialized files may contain A/C/Q.

Flattening is a measurement implementation with a declared 0.05 px flatness.
Unknown commands fail closed. This is not a general SVG sanitizer.
"""
from __future__ import annotations

import math
import re
import xml.etree.ElementTree as ET

from shapely.geometry import GeometryCollection, LineString, Point, Polygon

from source.seams import FLATTEN_TOLERANCE_PX, MASTERS, VALIDATOR_PATH_COMMANDS

TOKEN = re.compile(r'[MLCQAZ]|-?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?')
SAFE_PATH = re.compile(r'[MLCQAZ0-9.eE+\-\s]+')


def _num(token: str) -> float:
    try:
        v = float(token)
    except ValueError as exc:
        raise ValueError('Expected a number') from exc
    if not math.isfinite(v):
        raise ValueError('Non-finite coordinate')
    return v


def _flat_enough(p0, p1, p2, p3, tol) -> bool:
    line = LineString([p0, p3])
    if line.length == 0:
        return max(math.dist(p0, p1), math.dist(p0, p2)) <= tol
    return line.distance(Point(p1)) <= tol and line.distance(Point(p2)) <= tol


def flatten_cubic(p0, p1, p2, p3, tol=FLATTEN_TOLERANCE_PX, depth=0) -> list[tuple[float, float]]:
    if depth > 12 or _flat_enough(p0, p1, p2, p3, tol):
        return [p3]
    p01 = _mid(p0, p1); p12 = _mid(p1, p2); p23 = _mid(p2, p3)
    p012 = _mid(p01, p12); p123 = _mid(p12, p23); p0123 = _mid(p012, p123)
    return flatten_cubic(p0, p01, p012, p0123, tol, depth + 1) + flatten_cubic(p0123, p123, p23, p3, tol, depth + 1)


def _mid(a, b):
    return ((a[0] + b[0]) / 2, (a[1] + b[1]) / 2)


def flatten_quadratic(p0, p1, p2, tol=FLATTEN_TOLERANCE_PX) -> list[tuple[float, float]]:
    c1 = (p0[0] + 2 / 3 * (p1[0] - p0[0]), p0[1] + 2 / 3 * (p1[1] - p0[1]))
    c2 = (p2[0] + 2 / 3 * (p1[0] - p2[0]), p2[1] + 2 / 3 * (p1[1] - p2[1]))
    return flatten_cubic(p0, c1, c2, p2, tol)


def flatten_arc(p0, rx, ry, phi_deg, large, sweep, p1, tol=FLATTEN_TOLERANCE_PX) -> list[tuple[float, float]]:
    """SVG endpoint-to-center conversion, then sample to declared sagitta."""
    x1, y1 = p0; x2, y2 = p1
    if rx == 0 or ry == 0 or p0 == p1:
        return [p1]
    rx, ry = abs(rx), abs(ry)
    phi = math.radians(phi_deg % 360)
    cos_p, sin_p = math.cos(phi), math.sin(phi)
    dx = (x1 - x2) / 2
    dy = (y1 - y2) / 2
    x1p = cos_p * dx + sin_p * dy
    y1p = -sin_p * dx + cos_p * dy
    lam = (x1p * x1p) / (rx * rx) + (y1p * y1p) / (ry * ry)
    if lam > 1:
        s = math.sqrt(lam)
        rx, ry = rx * s, ry * s
    num = rx * rx * ry * ry - rx * rx * y1p * y1p - ry * ry * x1p * x1p
    den = rx * rx * y1p * y1p + ry * ry * x1p * x1p
    coef = math.sqrt(max(0.0, num / den))
    if large == sweep:
        coef = -coef
    cxp = coef * (rx * y1p) / ry
    cyp = coef * -(ry * x1p) / rx
    cx = cos_p * cxp - sin_p * cyp + (x1 + x2) / 2
    cy = sin_p * cxp + cos_p * cyp + (y1 + y2) / 2

    def angle(ux, uy, vx, vy):
        dot = ux * vx + uy * vy
        n = math.hypot(ux, uy) * math.hypot(vx, vy)
        if n == 0:
            return 0.0
        a = math.acos(max(-1.0, min(1.0, dot / n)))
        if ux * vy - uy * vx < 0:
            a = -a
        return a

    theta1 = angle(1, 0, (x1p - cxp) / rx, (y1p - cyp) / ry)
    dtheta = angle((x1p - cxp) / rx, (y1p - cyp) / ry, (-x1p - cxp) / rx, (-y1p - cyp) / ry)
    if sweep == 0 and dtheta > 0:
        dtheta -= 2 * math.pi
    elif sweep == 1 and dtheta < 0:
        dtheta += 2 * math.pi
    radius = max(rx, ry)
    segs = max(4, int(math.ceil(abs(dtheta) / max(1e-6, 2 * math.acos(max(0.0, 1 - tol / max(radius, 1e-6)))))))
    pts = []
    for i in range(1, segs + 1):
        t = theta1 + dtheta * i / segs
        x = cos_p * rx * math.cos(t) - sin_p * ry * math.sin(t) + cx
        y = sin_p * rx * math.cos(t) + cos_p * ry * math.sin(t) + cy
        pts.append((x, y))
    return pts


def parse_path(d: str):
    if not isinstance(d, str) or not SAFE_PATH.fullmatch(d):
        raise ValueError('Unsupported or unsafe Soft path syntax')
    tokens = TOKEN.findall(d)
    if ''.join(tokens) != re.sub(r'\s+', '', d):
        raise ValueError('Unparsed path content')
    i = 0
    g = GeometryCollection()
    rings: list[Polygon] = []

    def take(n):
        nonlocal i
        if i + n > len(tokens):
            raise ValueError('Incomplete command arguments')
        vals = [_num(t) for t in tokens[i:i + n]]
        i += n
        return vals

    while i < len(tokens):
        if tokens[i] != 'M':
            raise ValueError('Expected M')
        i += 1
        x, y = take(2)
        pts = [(x, y)]
        start = (x, y)
        current = (x, y)
        while True:
            if i >= len(tokens):
                raise ValueError('Missing Z')
            cmd = tokens[i]
            if cmd not in VALIDATOR_PATH_COMMANDS:
                raise ValueError('Unsupported path command: ' + cmd)
            if cmd == 'Z':
                i += 1
                break
            if cmd == 'M':
                raise ValueError('New subpath requires Z before the next M')
            i += 1
            if cmd == 'L':
                x, y = take(2)
                pts.append((x, y))
                current = (x, y)
            elif cmd == 'C':
                x1, y1, x2, y2, x, y = take(6)
                pts.extend(flatten_cubic(current, (x1, y1), (x2, y2), (x, y)))
                current = (x, y)
            elif cmd == 'Q':
                x1, y1, x, y = take(4)
                pts.extend(flatten_quadratic(current, (x1, y1), (x, y)))
                current = (x, y)
            elif cmd == 'A':
                rx, ry, rot, large, sweep, x, y = take(7)
                if large not in (0, 1) or sweep not in (0, 1):
                    raise ValueError('Arc flags must be 0 or 1')
                pts.extend(flatten_arc(current, rx, ry, rot, int(large), int(sweep), (x, y)))
                current = (x, y)
            else:
                raise ValueError('Unsupported path command: ' + cmd)
        if current != start:
            pts.append(start)
        cleaned = [pts[0]]
        for p in pts[1:]:
            if math.hypot(p[0] - cleaned[-1][0], p[1] - cleaned[-1][1]) > 1e-9:
                cleaned.append(p)
        if len(cleaned) < 3:
            raise ValueError('Degenerate ring')
        poly = Polygon(cleaned)
        if not poly.is_valid or poly.area <= 0:
            raise ValueError('Invalid ring')
        rings.append(poly)
        g = g.symmetric_difference(poly)
    if g.is_empty or not g.is_valid:
        raise ValueError('Empty or invalid final geometry')
    return g


def parse_svg(text: str):
    """Accept only the standalone Soft SVG export format."""
    if not isinstance(text, str) or len(text.encode('utf-8')) > 262144:
        raise ValueError('SVG must be a UTF-8 string under 256 KiB')
    if '<!' in text or '<?' in text:
        raise ValueError('No entities/doctype in icon SVG')
    try:
        parser = ET.XMLParser(target=ET.TreeBuilder(insert_comments=True, insert_pis=True))
        root = ET.fromstring(text, parser=parser)
    except (ET.ParseError, TypeError) as exc:
        raise ValueError('Malformed SVG XML') from exc
    ns = '{http://www.w3.org/2000/svg}'
    if [el.tag for el in root.iter()] != [ns + 'svg', ns + 'title', ns + 'path']:
        raise ValueError('Expected SVG namespace and exact svg/title/path structure')
    allowed = {
        ns + 'svg': {'width', 'height', 'viewBox', 'fill', 'fill-rule', 'role', 'focusable'},
        ns + 'title': set(),
        ns + 'path': {'d'},
    }
    for el in root.iter():
        if set(el.attrib) != allowed[el.tag]:
            raise ValueError('Unexpected or missing attributes on ' + el.tag)
        if (el.tag != ns + 'title' and (el.text or '').strip()) or (el.tail or '').strip():
            raise ValueError('Unexpected mixed content')
    for key, value in {'fill': 'currentColor', 'fill-rule': 'evenodd', 'role': 'img', 'focusable': 'false'}.items():
        if root.get(key) != value:
            raise ValueError('Invalid root attribute value: ' + key)
    title, path = list(root)
    if not (title.text or '').strip():
        raise ValueError('Unnamed standalone SVG')
    try:
        vb = [float(v) for v in root.attrib['viewBox'].split()]
    except ValueError as exc:
        raise ValueError('Invalid viewBox') from exc
    valid = next((n for n in MASTERS if vb == [0.0, 0.0, float(n), float(n)]), None)
    if valid is None:
        raise ValueError('Invalid viewBox')
    if root.get('width') != str(valid) or root.get('height') != str(valid):
        raise ValueError('Invalid native size')
    geometry = parse_path(path.attrib['d'])
    if min(geometry.bounds) < -1e-6 or max(geometry.bounds) > valid + 1e-6:
        raise ValueError('Artwork outside the native canvas')
    return valid, path.attrib['d'], geometry
