"""Measured regressions for the 2026-11-01 shape corrections.

These measure exported paths and native rasters. They guard construction and
pixel behavior; they do not establish recognition or design approval.
"""
import hashlib
import io
import json
import math
import sys
import unittest
from pathlib import Path

import cairosvg
from PIL import Image
from shapely import affinity
from shapely.geometry import MultiPolygon, Point, Polygon, box

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from source.outline import baseline
from tests.geometry.paths import parse_path

REG = json.loads((ROOT / 'generated/registry.json').read_text())['paths']
MASTERS = (12, 16, 24)
STYLES = ('outline', 'filled')
GAP = {12: 1, 16: 1.5, 24: 2}
CONTOUR = {12: 1, 16: 1.5, 24: 2}
LEDGER_CONCEPTS = {
    'arrow-down', 'arrow-left', 'arrow-right', 'arrow-up', 'arrow-up-right', 'bell', 'calendar', 'chart',
    'chat', 'copy', 'download', 'file', 'folder', 'help', 'home', 'link', 'lock', 'menu', 'more', 'pause',
    'refresh', 'search', 'terminal', 'upload', 'user', 'warning',
}


def geometry(icon, style, n):
    return parse_path(REG[icon][style][str(n)])


def polygons(g):
    # An intersection can also return the shared edges; only areas are parts.
    return [part for part in getattr(g, 'geoms', [g]) if isinstance(part, Polygon)]


def rings(g):
    for polygon in polygons(g):
        yield polygon.exterior
        yield from polygon.interiors


def edges(g):
    for ring_ in rings(g):
        coords = list(ring_.coords)
        yield from zip(coords, coords[1:])


def axis_edges(g):
    """Yield (position, length) for each axis-aligned edge."""
    for (x0, y0), (x1, y1) in edges(g):
        if abs(x0 - x1) < 1e-6:
            yield x0, abs(y1 - y0)
        elif abs(y0 - y1) < 1e-6:
            yield y0, abs(x1 - x0)


def alpha(icon, style, n):
    svg = f'<svg xmlns="http://www.w3.org/2000/svg" width="{n}" height="{n}" viewBox="0 0 {n} {n}" fill="#000" fill-rule="evenodd"><path d="{REG[icon][style][str(n)]}"/></svg>'
    return Image.open(io.BytesIO(cairosvg.svg2png(bytestring=svg.encode()))).convert('RGBA').getchannel('A')


def on_grid(value, step):
    return abs(value / step - round(value / step)) < 1e-3


def holes(g):
    return [Polygon(hole) for polygon in polygons(g) for hole in polygon.interiors]


def split_outline(g):
    """Return the largest part and the remaining separated marks."""
    parts = sorted(polygons(g), key=lambda part: part.area, reverse=True)
    return parts[0], parts[1:]


class LedgerScope(unittest.TestCase):
    def test_revisions_touch_exactly_the_decided_concepts(self):
        ledger = json.loads((ROOT / 'tests/fixtures/shape-revision-2026-11-01.json').read_text())['files']
        self.assertEqual({path.rsplit('/', 1)[1][:-4] for path in ledger}, LEDGER_CONCEPTS)

    def test_readme_does_not_embed_the_historical_capture(self):
        readme = (ROOT / 'README.md').read_text()
        self.assertNotRegex(readme, r'!\[[^\]]*\]\(review/')
        self.assertIn('historical capture', readme)

    def test_inventory_is_not_expanded(self):
        self.assertEqual(len(REG), 48)
        for icon in REG:
            self.assertEqual(set(REG[icon]), set(STYLES))
            for style in STYLES:
                self.assertEqual(set(REG[icon][style]), {'12', '16', '24'})


class WarningGapContract(unittest.TestCase):
    def test_outline_marks_clear_the_frame_at_every_target(self):
        for n in MASTERS:
            frame, marks = split_outline(geometry('warning', 'outline', n))
            with self.subTest(master=n):
                self.assertEqual(len(marks), 2)
                self.assertGreaterEqual(min(frame.distance(mark) for mark in marks), GAP[n] - .002)

    def test_filled_punctuation_meets_width_and_silhouette_clearance(self):
        for n in MASTERS:
            g = geometry('warning', 'filled', n)
            openings = holes(g)
            with self.subTest(master=n):
                self.assertEqual(len(openings), 2)
                for opening in openings:
                    self.assertGreaterEqual(opening.bounds[2] - opening.bounds[0], GAP[n] - .002)
                    self.assertGreaterEqual(g.exterior.distance(opening), GAP[n] - .002)
                self.assertGreaterEqual(openings[0].distance(openings[1]), GAP[n] - .002)

    def test_met_targets_hold_their_measured_values(self):
        for n, clearance in ((12, 1), (16, 1.5), (24, 2)):
            frame, marks = split_outline(geometry('warning', 'outline', n))
            with self.subTest(master=n, style='outline'):
                self.assertAlmostEqual(min(frame.distance(mark) for mark in marks), clearance, delta=.015)
        # Width and height of the negative dot, then the stem.
        for n, dot, stem in ((16, (1.5, 1.5), (1.5, 4)), (24, (2, 2), (2, 6))):
            openings = sorted(holes(geometry('warning', 'filled', n)), key=lambda part: part.bounds[3] - part.bounds[1])
            sizes = [(round(p.bounds[2] - p.bounds[0], 4), round(p.bounds[3] - p.bounds[1], 4)) for p in openings]
            with self.subTest(master=n, style='filled'):
                self.assertEqual(sizes, [dot, stem])

    def test_stem_to_dot_gap_meets_target_except_the_registered_master(self):
        registered = {e['nativeSize']: e for e in json.loads((ROOT / 'catalog/exceptions.json').read_text()) if e['rule'] == 'mark-internal-gap'}
        self.assertEqual(set(registered), {16})
        for n in MASTERS:
            _, marks = split_outline(geometry('warning', 'outline', n))
            gap = marks[0].distance(marks[1])
            with self.subTest(master=n):
                if n in registered:
                    self.assertAlmostEqual(gap, registered[n]['measuredApprox'], delta=.002)
                    self.assertGreaterEqual(gap, 1 - .002)
                else:
                    self.assertGreaterEqual(gap, GAP[n] - .002)

    def test_mark_reads_as_exclamation_not_colon(self):
        for n in MASTERS:
            for style in STYLES:
                g = geometry('warning', style, n)
                parts = holes(g) if style == 'filled' else split_outline(g)[1]
                dot, stem = sorted(parts, key=lambda part: part.bounds[3] - part.bounds[1])
                with self.subTest(master=n, style=style):
                    self.assertGreater(stem.bounds[3] - stem.bounds[1], dot.bounds[3] - dot.bounds[1])
                    self.assertLess(stem.bounds[3], dot.bounds[1])
                    self.assertAlmostEqual(stem.centroid.x, dot.centroid.x, delta=.002)

    def test_triangle_silhouette_is_preserved_and_centered_on_its_mark(self):
        for n in MASTERS:
            for style in STYLES:
                g = geometry('warning', style, n)
                outer = polygons(g)[0] if style == 'filled' else split_outline(g)[0]
                coords = list(outer.exterior.coords)[:-1]
                with self.subTest(master=n, style=style):
                    self.assertEqual(len(coords), 3)
                    x0, _, x1, _ = outer.bounds
                    self.assertAlmostEqual(min(coords, key=lambda p: p[1])[0], (x0 + x1) / 2, delta=.002)
                    parts = holes(g) if style == 'filled' else split_outline(g)[1]
                    self.assertAlmostEqual(parts[0].centroid.x, (x0 + x1) / 2, delta=.002)

    def test_one_pixel_outline_mark_renders_at_full_strength(self):
        for n, column in ((12, 5), (16, 7)):
            pixels = alpha('warning', 'outline', n)
            strengths = [pixels.getpixel((column, y)) for y in range(n)]
            with self.subTest(master=n):
                self.assertEqual(sum(value == 255 for value in strengths[6:n - 3]), {12: 2, 16: 3}[n])
                self.assertEqual(pixels.getpixel((column - 1, 7 if n == 12 else 9)), 0)
                self.assertEqual(pixels.getpixel((column + 1, 7 if n == 12 else 9)), 0)
                self.assertEqual(pixels.getpixel((column, 7 if n == 12 else 10)), 0)

    def test_constructor_parts_match_the_export(self):
        for n in MASTERS:
            for style in STYLES:
                shape, marks = baseline.warning_parts(n, style)
                built = shape.difference(marks) if style == 'filled' else baseline.ring(shape, CONTOUR[n]).union(marks)
                with self.subTest(master=n, style=style):
                    self.assertLess(built.symmetric_difference(geometry('warning', style, n)).area, .02)


class LinkChain(unittest.TestCase):
    def test_same_open_two_part_topology_at_every_master(self):
        for n in MASTERS:
            for style in STYLES:
                g = geometry('link', style, n)
                with self.subTest(master=n, style=style):
                    self.assertEqual(len(polygons(g)), 2)
                    self.assertEqual(holes(g), [])

    def test_hooks_interlock_on_the_diagonal(self):
        for n in MASTERS:
            for style in STYLES:
                a, b = polygons(geometry('link', style, n))
                with self.subTest(master=n, style=style):
                    # One hook in each opposite quadrant of the rising diagonal.
                    low, high = sorted((a, b), key=lambda part: part.centroid.x)
                    self.assertLess(low.centroid.x, n / 2)
                    self.assertGreater(low.centroid.y, n / 2)
                    self.assertGreater(high.centroid.x, n / 2)
                    self.assertLess(high.centroid.y, n / 2)
                    # Each hook's tip enters the other's mouth: part of its stroke
                    # lies inside the other hook's convex hull.
                    self.assertGreater(a.intersection(b.convex_hull).area, .25 * CONTOUR[n] ** 2)
                    self.assertGreater(b.intersection(a.convex_hull).area, .25 * CONTOUR[n] ** 2)
                    self.assertLess(a.distance(b), n / 4)

    def test_hooks_are_exact_rotations(self):
        for n in MASTERS:
            for style in STYLES:
                g = geometry('link', style, n)
                with self.subTest(master=n, style=style):
                    self.assertLess(g.symmetric_difference(affinity.rotate(g, 180, origin=(n / 2, n / 2))).area, .01)

    def test_hooks_never_nearly_touch(self):
        minimum = {'outline': GAP, 'filled': {12: .9, 16: 1.1, 24: GAP[24]}}
        for n in MASTERS:
            for style in STYLES:
                a, b = polygons(geometry('link', style, n))
                with self.subTest(master=n, style=style):
                    self.assertGreaterEqual(a.distance(b), minimum[style][n] - .002)

    def test_filled_24_is_visibly_heavier_than_outline(self):
        ratio = geometry('link', 'filled', 24).area / geometry('link', 'outline', 24).area
        self.assertGreaterEqual(ratio, 1.4)

    def test_filled_24_mouth_stays_open(self):
        # The clear width between one hook's arms, measured at the middle of the link.
        # 4 px still leaves 2.5 px when the 24 px master is displayed at 15 px.
        self.assertGreaterEqual(2 * Point(17, 7).distance(geometry('link', 'filled', 24)), 4)

    def test_filled_24_edges_stay_on_the_half_pixel_grid(self):
        for position, length in axis_edges(geometry('link', 'filled', 24)):
            if length >= .5:
                self.assertTrue(on_grid(position, .5), position)

    def test_stays_in_the_angular_vocabulary(self):
        for n in MASTERS:
            for style in STYLES:
                for (x0, y0), (x1, y1) in edges(geometry('link', style, n)):
                    angle = math.degrees(math.atan2(y1 - y0, x1 - x0)) % 45
                    with self.subTest(master=n, style=style):
                        self.assertLess(min(angle, 45 - angle), .2)

    def test_two_hooks_survive_native_12_px_outline(self):
        pixels = alpha('link', 'outline', 12)
        seen, components = set(), 0
        for start in [(x, y) for y in range(12) for x in range(12)]:
            if start in seen or pixels.getpixel(start) < 96:
                continue
            components += 1
            stack = [start]
            while stack:
                x, y = stack.pop()
                if (x, y) in seen or not (0 <= x < 12 and 0 <= y < 12) or pixels.getpixel((x, y)) < 96:
                    continue
                seen.add((x, y))
                stack += [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1), (x + 1, y + 1), (x - 1, y - 1), (x + 1, y - 1), (x - 1, y + 1)]
        self.assertEqual(components, 2)


class LinkExceptionRegister(unittest.TestCase):
    @staticmethod
    def records():
        return [e for e in json.loads((ROOT / 'catalog/exceptions.json').read_text()) if e['icon'] == 'link']

    @staticmethod
    def gap(style, n):
        a, b = polygons(geometry('link', style, n))
        return a.distance(b)

    def test_register_matches_every_hook_gap_below_target(self):
        below = {(n, style) for n in MASTERS for style in STYLES if self.gap(style, n) < GAP[n] - .002}
        self.assertEqual({(e['nativeSize'], e['appearance']) for e in self.records()}, below)

    def test_filled_12_and_16_are_really_below_target_and_24_is_not(self):
        self.assertLess(self.gap('filled', 12), GAP[12] - .002)
        self.assertLess(self.gap('filled', 16), GAP[16] - .002)
        self.assertGreaterEqual(self.gap('filled', 24), GAP[24])
        self.assertEqual({e['nativeSize'] for e in self.records()}, {12, 16})

    def test_records_use_the_general_targets_and_current_bytes(self):
        for record in self.records():
            n = record['nativeSize']
            path = ROOT / f'generated/outline/filled/{n}/link.svg'
            with self.subTest(master=n):
                self.assertEqual(record['target'], GAP[n])
                self.assertAlmostEqual(record['measuredApprox'], self.gap('filled', n), delta=.001)
                self.assertEqual(record['geometrySha256'], hashlib.sha256(path.read_bytes()).hexdigest())

    def test_records_add_no_label_rule_or_approval(self):
        restrictions = json.loads((ROOT / 'catalog/restrictions.json').read_text())['records']
        self.assertNotIn('link', {r['icon'] for r in restrictions})
        review = next(i for i in json.loads((ROOT / 'catalog/icons.json').read_text())['icons'] if i['id'] == 'link')['review']
        self.assertNotIn('usageRestriction', review)
        self.assertEqual(review['usage'], 'Use the action name on the enclosing control; 12 px is for labeled information.')
        for record in self.records():
            with self.subTest(master=record['nativeSize']):
                self.assertEqual(record['permittedUse'], 'name-on-enclosing-control')
                self.assertNotIn('restrictionId', record)
                self.assertIsNone(record['owner'])
                self.assertIsNone(record['reviewer'])
                self.assertIn('owner-review-pending', record['status'])


class CalendarHeaderRail(unittest.TestCase):
    FRAME = {12: (1, 3, 11, 11), 16: (2, 3, 14, 14), 24: (3, 5, 21, 21)}
    RAIL = {12: 5, 16: 6, 24: 9}

    def test_outline_rail_runs_the_full_frame_at_contour_weight(self):
        for n in MASTERS:
            x0, y0, x1, y1 = self.FRAME[n]
            top, w = self.RAIL[n], CONTOUR[n]
            g = geometry('calendar', 'outline', n)
            rail = box(x0, top, x1, top + w)
            with self.subTest(master=n):
                self.assertAlmostEqual(g.intersection(rail).area, rail.area, delta=.01)
                self.assertLess(g.intersection(box(x0 + w, y0 + w, x1 - w, top)).area, .01)
                self.assertGreaterEqual(top - (y0 + w), GAP[n] - .002)
                self.assertLess(g.intersection(box(x0 + w, top + w, x1 - w, top + w + GAP[n])).area, .01)

    def test_filled_rail_is_a_negative_slit_inside_the_silhouette(self):
        for n in MASTERS:
            x0, y0, x1, y1 = self.FRAME[n]
            top, w = self.RAIL[n], CONTOUR[n]
            g = geometry('calendar', 'filled', n)
            with self.subTest(master=n):
                self.assertLess(g.intersection(box(x0 + w, top, x1 - w, top + w)).area, .01)
                self.assertAlmostEqual(g.intersection(box(x0, top, x0 + w, top + w)).area, w * w, delta=.01)
                self.assertEqual(len(polygons(g)), 1)

    def test_square_silhouette_has_no_cut_corner(self):
        for n in MASTERS:
            for style in STYLES:
                x0, y0, x1, y1 = self.FRAME[n]
                g = geometry('calendar', style, n)
                with self.subTest(master=n, style=style):
                    for x, y in ((x0, y0), (x1, y0), (x0, y1), (x1, y1)):
                        self.assertLess(g.distance(Point(x, y)), .001)
                    for (ax, ay), (bx, by) in edges(g):
                        self.assertTrue(abs(ax - bx) < 1e-6 or abs(ay - by) < 1e-6, 'Calendar is rectilinear')

    def test_bindings_are_contour_weight(self):
        for n in MASTERS:
            x0, y0, x1, _ = self.FRAME[n]
            above = geometry('calendar', 'outline', n).intersection(box(0, 0, n, y0))
            with self.subTest(master=n):
                parts = polygons(above)
                self.assertEqual(len(parts), 2)
                for part in parts:
                    self.assertAlmostEqual(part.bounds[2] - part.bounds[0], CONTOUR[n], delta=.002)
                self.assertAlmostEqual((parts[0].centroid.x + parts[1].centroid.x) / 2, n / 2, delta=.002)

    def test_date_mark_policy(self):
        for n in MASTERS:
            frame, marks = split_outline(geometry('calendar', 'outline', n))
            openings = holes(geometry('calendar', 'filled', n))
            with self.subTest(master=n):
                if n == 12:
                    self.assertEqual(marks, [])
                    self.assertEqual(openings[1:], [])
                else:
                    self.assertEqual(len(marks), 1)
                    # One off-center date cannot form a mirrored pair of "eyes".
                    self.assertGreater(marks[0].centroid.x, n / 2 + GAP[n])
                    self.assertGreaterEqual(frame.distance(marks[0]), GAP[n] - .002)


class TerminalPrompt(unittest.TestCase):
    def parts(self, n):
        frame, marks = split_outline(geometry('terminal', 'outline', n))
        cursor, prompt = sorted(marks, key=lambda part: part.convex_hull.area - part.area)
        return frame, prompt, cursor

    def test_frame_is_a_square_window_in_both_styles(self):
        for n in MASTERS:
            for style in STYLES:
                g = geometry('terminal', style, n)
                outer = polygons(g)[0] if style == 'filled' else self.parts(n)[0]
                with self.subTest(master=n, style=style):
                    self.assertEqual(len(outer.exterior.coords), 5)
                    if style == 'filled':
                        self.assertEqual(len(outer.interiors), 2)

    def test_marks_clear_the_frame(self):
        for n in MASTERS:
            frame, prompt, cursor = self.parts(n)
            with self.subTest(master=n):
                self.assertGreaterEqual(frame.distance(prompt), GAP[n] - .002)
                self.assertGreaterEqual(frame.distance(cursor), GAP[n] - .002)
                self.assertGreater(prompt.distance(cursor), 0)

    def test_prompt_is_open_and_visibly_a_chevron_at_native_size(self):
        for n in MASTERS:
            for style in STYLES:
                g = geometry('terminal', style, n)
                prompt = sorted(holes(g), key=lambda part: part.convex_hull.area - part.area)[-1] if style == 'filled' else self.parts(n)[1]
                x0, y0, x1, y1 = prompt.bounds
                mouth = Point(x0, (y0 + y1) / 2)
                with self.subTest(master=n, style=style):
                    # The point between the arms must be clear of the stroke.
                    self.assertGreaterEqual(mouth.distance(prompt), CONTOUR[n] * .6)
                    self.assertGreater(y1 - y0, CONTOUR[n] * 3.3)

    def test_prompt_mouth_is_lighter_than_its_apex_on_small_masters(self):
        for n, mouth_x, apex_x, row in ((12, 3, 5, 6), (16, 4, 6, 8)):
            for style in STYLES:
                pixels = alpha('terminal', style, n)
                mouth, apex = pixels.getpixel((mouth_x, row)), pixels.getpixel((apex_x, row))
                with self.subTest(master=n, style=style):
                    self.assertGreaterEqual(abs(apex - mouth), 96)

    def test_cursor_is_balanced_in_the_lower_right_of_the_field(self):
        for n in MASTERS:
            frame, prompt, cursor = self.parts(n)
            inner = Polygon(frame.interiors[0])
            with self.subTest(master=n):
                self.assertAlmostEqual(inner.bounds[2] - cursor.bounds[2], GAP[n], delta=.002)
                self.assertAlmostEqual(inner.bounds[3] - cursor.bounds[3], GAP[n], delta=.002)
                self.assertGreater(cursor.bounds[2] - cursor.bounds[0], cursor.bounds[3] - cursor.bounds[1])
                self.assertAlmostEqual(cursor.bounds[3], prompt.bounds[3], delta=.6)


class FileContent(unittest.TestCase):
    def test_24_uses_two_unequal_left_aligned_lines(self):
        for style in STYLES:
            g = geometry('file', style, 24)
            lines = sorted(holes(g) if style == 'filled' else split_outline(g)[1], key=lambda part: part.bounds[1])
            with self.subTest(style=style):
                self.assertEqual(len(lines), 2)
                self.assertAlmostEqual(lines[0].bounds[0], lines[1].bounds[0], delta=.002)
                self.assertLess(lines[1].bounds[2] - lines[1].bounds[0], (lines[0].bounds[2] - lines[0].bounds[0]) * .75)
                self.assertGreaterEqual(lines[1].bounds[1] - lines[0].bounds[3], GAP[24] - .002)

    def test_24_lines_clear_the_page(self):
        frame, lines = split_outline(geometry('file', 'outline', 24))
        for part in lines:
            self.assertGreaterEqual(frame.distance(part), GAP[24] - .002)

    def test_small_masters_stay_plain(self):
        for n in (12, 16):
            with self.subTest(master=n):
                self.assertEqual(len(polygons(geometry('file', 'outline', n))), 1)
                self.assertEqual(holes(geometry('file', 'filled', n)), [])


class HelpHook(unittest.TestCase):
    def test_16_stem_is_centered_over_the_dot(self):
        _, marks = split_outline(geometry('help', 'outline', 16))
        dot, hook = sorted(marks, key=lambda part: part.area)
        stem = hook.intersection(box(0, 8.25, 16, 16))
        self.assertFalse(stem.is_empty)
        self.assertAlmostEqual(stem.centroid.x, dot.centroid.x, delta=.1)
        self.assertGreaterEqual(hook.distance(dot), GAP[16] - .002)


class GridPolicy(unittest.TestCase):
    def test_no_axis_aligned_edge_lands_on_thirds_anywhere(self):
        # Quarter-pixel edges are the accepted ±0.25 centered stems. Anything finer
        # means a 24 px coordinate was scaled without a native decision.
        for icon in REG:
            for style in STYLES:
                for n in MASTERS:
                    with self.subTest(icon=icon, style=style, master=n):
                        for position, length in axis_edges(geometry(icon, style, n)):
                            if length >= .25:
                                self.assertTrue(on_grid(position, .25), position)

    def test_1px_shafts_share_one_crisp_line(self):
        for icon, axis in (('arrow-left', 'row'), ('arrow-right', 'row'), ('arrow-up', 'column'), ('arrow-down', 'column'), ('download', 'column'), ('upload', 'column')):
            pixels = alpha(icon, 'outline', 12)
            line_ = [pixels.getpixel((x, 5) if axis == 'row' else (5, x)) for x in range(12)]
            beside = [pixels.getpixel((x, 6) if axis == 'row' else (6, x)) for x in range(12)]
            with self.subTest(icon=icon):
                self.assertGreaterEqual(sum(value == 255 for value in line_), 5)
                self.assertLessEqual(sum(value == 255 for value in beside), 2)

    def test_pause_bars_are_mirrored_and_share_a_phase(self):
        for n in MASTERS:
            for style in STYLES:
                a, b = polygons(geometry('pause', style, n))
                ax0, ay0, ax1, ay1 = a.bounds
                bx0, by0, bx1, by1 = b.bounds
                with self.subTest(master=n, style=style):
                    self.assertAlmostEqual(ax0 + bx1, n, delta=.002)
                    self.assertAlmostEqual(ax1 - ax0, bx1 - bx0, delta=.002)
                    self.assertTrue(on_grid(ax0, 1 if n == 12 else .5))
                    self.assertTrue(on_grid(ax1, 1 if n == 12 else .5))

    def test_repeated_16_px_elements_render_at_equal_weight(self):
        for icon, axis in (('menu', 'row'), ('chart', 'column'), ('more', 'column')):
            for style in STYLES:
                g = geometry(icon, style, 16)
                parts = polygons(g)
                fractions = {round(part.bounds[1 if axis == 'row' else 0] % 1, 3) for part in parts}
                with self.subTest(icon=icon, style=style):
                    self.assertEqual(len(parts), 3)
                    self.assertEqual(len(fractions), 1)
                    self.assertTrue(on_grid(parts[0].bounds[1 if axis == 'row' else 0], .5))

    def test_16_px_objects_sit_on_the_half_pixel_grid(self):
        centered_stems = {'lock': 'filled'}
        for icon in ('bell', 'chat', 'copy', 'file', 'folder', 'home', 'lock', 'user', 'terminal', 'calendar'):
            for style in STYLES:
                with self.subTest(icon=icon, style=style):
                    for position, length in axis_edges(geometry(icon, style, 16)):
                        if centered_stems.get(icon) == style and on_grid(position, .25) and length <= 2.5:
                            continue
                        if length >= .75:
                            self.assertTrue(on_grid(position, .5), position)

    def test_12_px_outline_objects_sit_on_whole_pixels(self):
        for icon in ('calendar', 'chat', 'file', 'folder', 'home', 'lock', 'search', 'terminal', 'user'):
            with self.subTest(icon=icon):
                for position, length in axis_edges(geometry(icon, 'outline', 12)):
                    if length >= 1:
                        self.assertTrue(on_grid(position, 1), position)

    def test_refresh_12_outline_strokes_render_at_full_strength(self):
        pixels = alpha('refresh', 'outline', 12)
        self.assertEqual([pixels.getpixel((x, 10)) for x in range(4, 8)], [255] * 4)
        self.assertEqual([pixels.getpixel((1, y)) for y in range(4, 8)], [255] * 4)

    def test_search_12_lens_walls_render_at_equal_strength(self):
        pixels = alpha('search', 'outline', 12)
        walls = [pixels.getpixel((1, 5)), pixels.getpixel((8, 5)), pixels.getpixel((5, 1)), pixels.getpixel((5, 8))]
        self.assertEqual(walls, [255] * 4)
        self.assertEqual(len(geometry('search', 'outline', 12).interiors), 1)
        lens = Polygon(geometry('search', 'outline', 12).interiors[0])
        self.assertEqual(len(lens.exterior.coords) - 1, 8, 'Keep the octagonal lens')


if __name__ == '__main__':
    unittest.main(verbosity=2)
