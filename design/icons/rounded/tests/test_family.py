"""Seam, grammar, and register tests for the Rounded family."""
from __future__ import annotations

import hashlib
import io
import json
import math
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from shapely import affinity
from shapely.geometry import LineString, Point, Polygon, box

from source.draw import draw
from source.lookup import icon_svg, icon_svg_for_display, select_master
from source.seams import (
    ACUTE_JOIN, APPEARANCES, BOLD_WIDTH, CANONICAL_IDS, CORNER_TOKEN, COUNTER_FLOOR, CUT_JOIN,
    CrossPackFallbackError, GAP_TARGET, LINK_BOLD_WIDTH, MASTERS, MASTER_SELECTION, OUTLINE_WIDTH,
    PADDING, PAIR_MODEL, PRODUCT_PATH_COMMANDS, STAR_JOIN,
    UnknownAppearanceError, UnknownIconError, UnknownMasterError,
)
from tests.probes import (
    FLATTENING_SLACK, MID_WIDTH_BLOB, artwork_sha, corner_setback, counters, expected_register,
    hole_diameters, holes, line_concentration, long_axis_degrees, mid_width_ratio, min_convex_radius,
    parts, pixel_alpha, product, register_problems, stroke_width,
)
from source.primitives import polygon, round_convex, rounded_hull, stadium_line, union
from source.validate import parse_path, parse_svg

try:
    import jsonschema
    from PIL import Image
    import cairosvg
except ImportError as exc:  # pragma: no cover
    raise SystemExit('Install the family requirements first') from exc

REPO = ROOT.parents[2]
OUTLINE = REPO / 'design' / 'icons' / 'outline'


class ContractTests(unittest.TestCase):
    def test_schema_and_matrix(self):
        cat = json.loads((ROOT / 'catalog' / 'icons.json').read_text())
        jsonschema.validate(cat, json.loads((ROOT / 'catalog' / 'schemas' / 'catalog.schema.json').read_text()))
        ids = [m['id'] for m in cat['icons']]
        self.assertEqual(ids, list(CANONICAL_IDS))
        self.assertEqual(cat['counts'], {'icons': len(CANONICAL_IDS), 'drawings': 6 * len(CANONICAL_IDS)})
        self.assertFalse(cat['public'])
        self.assertEqual(cat['pack'], 'rounded')
        for meta in cat['icons']:
            self.assertEqual(meta['pairModel'], PAIR_MODEL[meta['id']])
            self.assertEqual(
                meta['availability'],
                {'rounded': {'appearances': ['outline', 'filled'], 'opticalSizes': [12, 16, 24]}},
            )

    def test_every_drawing_is_in_the_inventory(self):
        inv = json.loads((ROOT / 'generated' / 'inventory.json').read_text())
        files = {str(p.relative_to(ROOT / 'generated')) for p in (ROOT / 'generated' / 'rounded').rglob('*.svg')}
        self.assertEqual(len(inv), 6 * len(CANONICAL_IDS))
        self.assertEqual(len(files), 6 * len(CANONICAL_IDS))
        self.assertEqual({r['path'] for r in inv}, files)
        expected = {f'rounded/{a}/{n}/{i}.svg' for i in CANONICAL_IDS for a in APPEARANCES for n in MASTERS}
        self.assertEqual(files, expected)

    def test_no_silent_fallback(self):
        icon_svg('home', appearance='outline', master=24)
        with self.assertRaises(UnknownIconError):
            icon_svg('not-a-concept', appearance='outline', master=24)
        with self.assertRaises(UnknownAppearanceError):
            icon_svg('home', appearance='solid', master=24)
        with self.assertRaises(UnknownMasterError):
            icon_svg('home', appearance='outline', master=18)
        with self.assertRaises(UnknownMasterError):
            select_master(13)
        with self.assertRaises(UnknownMasterError):
            select_master(11)
        with self.assertRaises(CrossPackFallbackError):
            icon_svg('home', appearance='outline', master=24, pack='outline')
        with self.assertRaises(CrossPackFallbackError):
            icon_svg_for_display('home', appearance='outline', size=16, pack='another-family')
        for size, master in MASTER_SELECTION.items():
            self.assertEqual(select_master(size), master)
            self.assertEqual(icon_svg_for_display('home', appearance='outline', size=size, pack='rounded'),
                             icon_svg('home', appearance='outline', master=master, pack='rounded'))

    def test_warning_visible_label_is_concept_level(self):
        rec = json.loads((ROOT / 'catalog' / 'restrictions.json').read_text())['records'][0]
        self.assertEqual(rec['icon'], 'warning')
        self.assertEqual(rec['pack'], 'rounded')
        for n in ('12', '16', '24'):
            for a in APPEARANCES:
                cell = rec['sizes'][n][a]
                self.assertTrue(cell['visibleLabelRequired'])
                self.assertEqual(len(cell['geometrySha256']), 64)
                self.assertNotEqual(cell['geometrySha256'], 'pending-build')


class GeometryGrammarTests(unittest.TestCase):
    def test_plus_terminals_are_round(self):
        g = draw('plus', 24, 'outline')
        minx, miny, maxx, maxy = g.bounds
        sliver = g.intersection(box_x(minx, minx + 0.25, 24))
        height = sliver.bounds[3] - sliver.bounds[1]
        # Round cap of radius 1 tapers; a square 2 px cap would stay ~2 px tall.
        self.assertLess(height, 1.55)
        self.assertGreater(2.0 - height, 0.4)

    def test_search_lens_is_circular(self):
        g = draw('search', 24, 'outline')
        holes = []
        for p in (list(g.geoms) if g.geom_type == 'MultiPolygon' else [g]):
            holes.extend(__import__('shapely.geometry', fromlist=['Polygon']).Polygon(h) for h in p.interiors)
        self.assertTrue(holes)
        lens = max(holes, key=lambda h: h.area)
        compactness = 4 * 3.1415926535 * lens.area / (lens.length ** 2)
        self.assertGreater(compactness, 0.92)

    def test_rounded_paths_are_not_outline_copies(self):
        ang_reg = json.loads((OUTLINE / 'generated' / 'registry.json').read_text())['paths']
        rounded_reg = json.loads((ROOT / 'generated' / 'registry.json').read_text())['paths']
        # Outline's inventory may lag or lead this family; compare what both have drawn.
        for icon_id in sorted(set(CANONICAL_IDS) & set(ang_reg)):
            for a in APPEARANCES:
                for n in MASTERS:
                    self.assertNotEqual(
                        rounded_reg[icon_id][a][str(n)],
                        ang_reg[icon_id][a][str(n)],
                        f'{icon_id}/{a}/{n} matched Outline path data',
                    )

    def test_constructors_do_not_read_another_family(self):
        constructors = [ROOT / 'source' / 'draw.py', ROOT / 'source' / 'primitives.py',
                        *sorted((ROOT / 'source' / 'glyphs').glob('*.py'))]
        self.assertGreater(len(constructors), 5)
        for path in constructors:
            src = path.read_text()
            for forbidden in ('design/icons/outline', 'generated/outline', 'baseline.draw', 'outline.baseline',
                              'OUTLINE_ROOT_REL', 'open(', 'read_text', 'read_bytes', 'cairosvg', 'fontTools'):
                self.assertNotIn(forbidden, src, path.name)

    def test_silhouette_outer_bounds(self):
        for icon_id, model in PAIR_MODEL.items():
            if model != 'silhouette':
                continue
            for n in MASTERS:
                a = draw(icon_id, n, 'outline')
                b = draw(icon_id, n, 'filled')
                self.assertTrue(all(abs(x - y) < 0.05 for x, y in zip(a.bounds, b.bounds)), (icon_id, n, a.bounds, b.bounds))
                self.assertGreater(b.area, a.area)

    def test_weight_pairs_are_heavier_not_filled_holes(self):
        for n in MASTERS:
            outline = draw('search', n, 'outline')
            filled = draw('search', n, 'filled')
            self.assertGreater(filled.area, outline.area)
            for g in (outline, filled):
                holes = []
                for p in (list(g.geoms) if g.geom_type == 'MultiPolygon' else [g]):
                    holes.extend(p.interiors)
                self.assertTrue(holes, f'search lost its open counter at {n}')

    def test_token_hierarchy(self):
        for n in MASTERS:
            self.assertLess(STAR_JOIN[n], OUTLINE_WIDTH[n])
            self.assertGreater(ACUTE_JOIN[n], OUTLINE_WIDTH[n])
            self.assertLess(ACUTE_JOIN[n], CORNER_TOKEN[n])

    def test_star_mass_is_not_thirty_percent_light(self):
        ang = parse_svg((OUTLINE / 'generated' / 'outline' / 'filled' / '24' / 'star.svg').read_text())[2]
        rounded = draw('star', 24, 'filled')
        self.assertGreater(rounded.area / (24 * 24), 0.24)
        self.assertGreater(rounded.area / ang.area, 0.85)

    def test_products_export_mlz_only(self):
        styles = json.loads((ROOT / 'catalog' / 'styles.json').read_text())
        self.assertEqual(styles['rounded']['productPathCommands'], list(PRODUCT_PATH_COMMANDS))
        for svg in (ROOT / 'generated' / 'rounded').rglob('*.svg'):
            text = svg.read_text()
            d = text.split(' d="', 1)[1].split('"', 1)[0]
            self.assertRegex(d, r'^[MLZ0-9.\-\s]+$', msg=str(svg))
            self.assertNotRegex(d, r'[CQA]')


def box_x(x0, x1, n):
    from shapely.geometry import box
    return box(x0, 0, x1, n)


class NegativeControlTests(unittest.TestCase):
    """Each probe must reject the shape that the review actually found."""

    def setUp(self):
        self.triangle = polygon([(12, 2), (22, 21), (2, 21)])

    def test_radius_probe_rejects_sharp_and_expand_first_corners(self):
        self.assertLess(min_convex_radius(self.triangle), 0.05)
        # The recipe that shipped: it passes a radius of 2 and restores the sharp corner.
        expand_first = self.triangle.buffer(2, quad_segs=8).buffer(-2, quad_segs=8)
        self.assertLess(min_convex_radius(expand_first), 0.2)
        self.assertGreater(min_convex_radius(round_convex(self.triangle, 2)), 1.9)

    def test_radius_probe_reads_authored_radius(self):
        for r in (0.65, 1.25, 2.6):
            hull = rounded_hull((12, 2 + r, r), (2 + r, 21 - r, r), (22 - r, 21 - r, r))
            self.assertAlmostEqual(min_convex_radius(hull), r, delta=0.05 * r)

    def test_rounded_hull_fails_closed_on_a_swallowed_corner(self):
        with self.assertRaises(ValueError):
            rounded_hull((2, 2, 1), (10, 2, 1), (6, 10, 1), (6, 5, 1))

    def test_mid_width_probe_rejects_sharp_and_blob_triangles(self):
        self.assertAlmostEqual(mid_width_ratio(self.triangle, 24), 0.5, delta=0.01)
        for n, half, top, bottom in ((12, 5.25, 1.0, 11.0), (16, 6.9, 1.5, 14.5), (24, 10.2, 2.0, 22.0)):
            r, c = CORNER_TOKEN[n], n / 2
            blob = rounded_hull((c, top + r, r), (c - half + r, bottom - r, r), (c + half - r, bottom - r, r))
            self.assertGreaterEqual(mid_width_ratio(blob, n), MID_WIDTH_BLOB)

    def test_setback_rejects_near_square_page(self):
        near_square = box(3.9, 2, 20, 22).buffer(3.4).buffer(-3.4)
        self.assertLess(corner_setback(near_square, 3.9, 2), 0.05)

    def test_counter_probe_rejects_pockets_and_filled_holes(self):
        plate = box(2, 2, 22, 22)
        self.assertEqual(counters(plate, 24), [])
        pocket = plate.difference(Point(12, 12).buffer(0.7))
        self.assertEqual(counters(pocket, 24), [])
        window = plate.difference(Point(12, 12).buffer(1.2))
        self.assertAlmostEqual(counters(window, 24)[0], 2.4, delta=0.05)

    def test_axis_probe_rejects_the_former_bow(self):
        # The 16 master as reviewed: two stadiums splayed about the vertical.
        bow = union(
            affinity.rotate(stadium_line(2.3, 8, 8.5, 8, 6.4), 32, origin=(5.4, 8)),
            affinity.rotate(stadium_line(7.5, 8, 13.7, 8, 6.4), -32, origin=(10.6, 8)),
        )
        self.assertGreater(abs(long_axis_degrees(bow) - 45), 20)

    def test_gap_probes_reject_detached_arrow_and_crowded_warning(self):
        # The 24 outline as reviewed: the shaft stops short of the chevron.
        detached = union(stadium_line(3, 12, 16.2, 12, 2), LineString(
            [(10.6, 4.8), (20.2, 12), (10.6, 19.2)]).buffer(1, quad_segs=8))
        self.assertEqual(len(parts(detached)), 2)
        frame = self.triangle.difference(self.triangle.buffer(-2))
        crowded = stadium_line(12, 6.5, 12, 12, 1.55)
        self.assertLess(frame.distance(crowded), GAP_TARGET[24])


    def test_pixel_probe_rejects_a_mark_straddling_two_columns(self):
        straddling = pixel_alpha(stadium_line(6, 4, 6, 8, 0.9), 12)
        self.assertAlmostEqual(line_concentration(straddling, [(x, 6) for x in (4, 5, 6, 7)])[1], 0.5, delta=0.01)
        solid = pixel_alpha(stadium_line(5.5, 4, 5.5, 8, 1), 12)
        self.assertGreater(line_concentration(solid, [(x, 6) for x in (4, 5, 6)])[1], 0.95)

    def test_register_check_rejects_stale_and_tampered_records(self):
        records = json.loads((ROOT / 'catalog' / 'exceptions.json').read_text())
        expected = expected_register(product)
        sha = artwork_sha
        self.assertEqual(register_problems(records, expected, sha), [])
        self.assertTrue(register_problems(records[1:], expected, sha), 'missing record')
        altered = [dict(r) for r in records]
        altered[0]['measuredApprox'] += 0.05
        self.assertTrue(register_problems(altered, expected, sha), 'changed measurement')
        altered = [dict(r) for r in records]
        altered[0]['geometrySha256'] = '0' * 64
        self.assertTrue(register_problems(altered, expected, sha), 'old artwork hash')
        # Artwork that reaches its floor leaves the record stale, so it must come off the register.
        def opened(icon, n, appearance):
            if (icon, n, appearance) == ('branch', 16, 'outline'):
                return box(0, 0, 16, 16).difference(Point(8, 8).buffer(1, quad_segs=8))
            return product(icon, n, appearance)
        self.assertTrue(register_problems(records, expected_register(opened), sha), 'resolved value')

    def test_exception_schema_rejects_an_invented_approval_and_a_missing_measurement(self):
        schema = json.loads((ROOT / 'catalog' / 'schemas' / 'exceptions.schema.json').read_text())
        record = json.loads((ROOT / 'catalog' / 'exceptions.json').read_text())[0]
        jsonschema.validate([record], schema)
        with self.assertRaises(jsonschema.ValidationError):
            jsonschema.validate([{**record, 'owner': 'someone'}], schema)
        with self.assertRaises(jsonschema.ValidationError):
            jsonschema.validate([{k: v for k, v in record.items() if k != 'measuredApprox'}], schema)


class ShapeContractTests(unittest.TestCase):
    """Measured corner, topology and gap contracts on the exported products."""

    def check_each(self, icon_id, check):
        for n in MASTERS:
            for appearance in APPEARANCES:
                with self.subTest(icon=icon_id, master=n, appearance=appearance):
                    check(n, appearance, product(icon_id, n, appearance))

    def test_corrected_key_shapes_have_no_sharp_convex_corner(self):
        for icon_id in ('home', 'file', 'calendar', 'warning', 'link', 'user', 'arrow-right'):
            def check(n, appearance, g):
                self.assertGreater(min_convex_radius(g), 0.9 * CUT_JOIN[n])
            self.check_each(icon_id, check)

    def test_warning_apex_is_round_and_stays_on_its_keyline(self):
        def check(n, appearance, g):
            minx, miny, maxx, maxy = g.bounds
            self.assertAlmostEqual(miny, PADDING[n], delta=0.01)
            apex = box(0, miny, n, miny + ACUTE_JOIN[n])
            radius = min_convex_radius(g, apex)
            self.assertGreater(radius, 0.95 * ACUTE_JOIN[n])
            self.assertLess(radius, CORNER_TOKEN[n])
            # Rounder than a sharp triangle, short of the full object radius.
            self.assertGreater(mid_width_ratio(g, n), 0.55)
            self.assertLess(mid_width_ratio(g, n), MID_WIDTH_BLOB)
        self.check_each('warning', check)

    def test_home_roof_is_round_and_stays_on_its_keyline(self):
        def check(n, appearance, g):
            minx, miny, maxx, maxy = g.bounds
            self.assertAlmostEqual(miny, PADDING[n], delta=0.01)
            # round_convex resamples this arc for the door jambs, so the estimate reads low.
            self.assertGreater(min_convex_radius(g, box(0, miny, n, miny + ACUTE_JOIN[n])), 0.85 * ACUTE_JOIN[n])
            # The feet are the softer object corners.
            self.assertAlmostEqual(
                corner_setback(g, minx, maxy), (math.sqrt(2) - 1) * CORNER_TOKEN[n], delta=0.05)
        self.check_each('home', check)

    def test_file_page_corners_and_proportion(self):
        def check(n, appearance, g):
            minx, miny, maxx, maxy = g.bounds
            for corner in ((minx, miny), (minx, maxy), (maxx, maxy)):
                self.assertAlmostEqual(
                    corner_setback(g, *corner), (math.sqrt(2) - 1) * CORNER_TOKEN[n], delta=0.05)
            self.assertLess((maxx - minx) / (maxy - miny), 0.87)
            self.assertGreater((maxx - minx) / (maxy - miny), 0.75)
        self.check_each('file', check)

    def test_file_shows_a_turned_down_corner(self):
        for n in MASTERS:
            with self.subTest(master=n):
                outline, filled = product('file', n, 'outline'), product('file', n, 'filled')
                page, ear = parts(filled)[:2]
                self.assertGreaterEqual(page.distance(ear) + 1e-6, GAP_TARGET[n])
                # The ear sits in the page's upper right, inside the fold's silhouette.
                self.assertGreater(ear.centroid.x, page.centroid.x)
                self.assertLess(ear.centroid.y, page.centroid.y)
                self.assertGreater(ear.area, 0.2 * OUTLINE_WIDTH[n] * 3 * OUTLINE_WIDTH[n])
                # Outline carries the same ear as solid mass, leaving no pocket beside it.
                self.assertTrue(outline.contains(ear.centroid))
                self.assertEqual(len(holes(outline)), len(counters(outline, n)))

    def test_file_content_marks_are_two_unequal_left_aligned_lines_at_24_only(self):
        for n in (12, 16):
            self.assertEqual(len(holes(product('file', n, 'filled'))), 0)
            self.assertEqual(len(parts(product('file', n, 'outline'))), 1)
        filled = sorted(holes(product('file', 24, 'filled')), key=lambda h: h.bounds[1])
        self.assertEqual(len(filled), 2)
        top, lower = filled
        self.assertAlmostEqual(top.bounds[0], lower.bounds[0], delta=0.01)
        self.assertGreater(top.bounds[2], lower.bounds[2] + 1)
        self.assertGreaterEqual(top.distance(lower) + 1e-6, GAP_TARGET[24])
        outline_lines = sorted(parts(product('file', 24, 'outline'))[1:], key=lambda p: p.bounds[1])
        self.assertEqual(len(outline_lines), 2)
        for line in outline_lines:
            self.assertGreaterEqual(
                parts(product('file', 24, 'outline'))[0].distance(line) + 1e-6, GAP_TARGET[24])

    def test_warning_punctuation_meets_every_gap_target(self):
        for n in MASTERS:
            with self.subTest(master=n):
                target = GAP_TARGET[n]
                frame, *marks = parts(product('warning', n, 'outline'))
                self.assertEqual(len(marks), 2)
                self.assertGreaterEqual(frame.distance(marks[0]) + 1e-6, target)
                self.assertGreaterEqual(frame.distance(marks[1]) + 1e-6, target)
                self.assertGreaterEqual(marks[0].distance(marks[1]) + 1e-6, target)
                stem, dot = sorted(marks, key=lambda m: m.bounds[1])
                self.assertGreater(stem.bounds[3] - stem.bounds[1], 1.4 * (dot.bounds[3] - dot.bounds[1]))
                middle = (frame.bounds[0] + frame.bounds[2]) / 2
                self.assertAlmostEqual(stem.centroid.x, middle, delta=0.01)
                self.assertAlmostEqual(dot.centroid.x, middle, delta=0.01)
                filled = product('warning', n, 'filled')
                cut = holes(filled)
                self.assertEqual(len(cut), 2)
                self.assertGreaterEqual(cut[0].distance(cut[1]) + 1e-6, target)
                solid = Polygon(parts(filled)[0].exterior)
                for hole in cut:
                    self.assertGreaterEqual(solid.exterior.distance(hole) + 1e-6, target)

    def test_warning_punctuation_is_solid_on_one_column_at_small_masters(self):
        for n, share in ((12, 0.95), (16, 0.7)):
            for appearance in APPEARANCES:
                with self.subTest(master=n, appearance=appearance):
                    g = product('warning', n, appearance)
                    centre = int((g.bounds[0] + g.bounds[2]) / 2)
                    outline = product('warning', n, 'outline')
                    stem = sorted(parts(outline)[1:], key=lambda m: m.bounds[1])[0]
                    row = int((stem.bounds[1] + stem.bounds[3]) / 2)
                    alpha = pixel_alpha(g, n)
                    cells = [(x, row) for x in (centre - 1, centre, centre + 1)]
                    if appearance == 'filled':
                        # The mark is a cut, so measure the missing ink.
                        values = [1 - alpha.getpixel(c) / 255 for c in cells]
                        peak, ratio = max(values), max(values) / sum(values)
                    else:
                        peak, ratio = line_concentration(alpha, cells)
                    self.assertGreater(peak, 0.95)
                    self.assertGreater(ratio, share)

    def test_warning_gap_exceptions_stay_resolved_and_the_label_rule_remains(self):
        records = json.loads((ROOT / 'catalog' / 'exceptions.json').read_text())
        warning = [r for r in records if r['icon'] == 'warning']
        self.assertEqual({r['rule'] for r in warning}, {'canvas-centre-offset'})
        record = json.loads((ROOT / 'catalog' / 'restrictions.json').read_text())['records'][0]
        inventory = {
            (r['appearance'], r['master']): r['sha256']
            for r in json.loads((ROOT / 'generated' / 'inventory.json').read_text()) if r['id'] == 'warning'
        }
        for (appearance, n), sha in inventory.items():
            cell = record['sizes'][str(n)][appearance]
            self.assertTrue(cell['visibleLabelRequired'])
            self.assertEqual(cell['geometrySha256'], sha)
            self.assertEqual(
                cell['exceptionIds'],
                [r['id'] for r in warning if r['appearance'] == appearance and r['nativeSize'] == n])

    def test_exception_register_describes_the_current_artwork(self):
        records = json.loads((ROOT / 'catalog' / 'exceptions.json').read_text())
        jsonschema.validate(records, json.loads((ROOT / 'catalog' / 'schemas' / 'exceptions.schema.json').read_text()))
        self.assertEqual(register_problems(records, expected_register(product), artwork_sha), [])
        for record in records:
            self.assertIsNone(record['owner'])
            self.assertIsNone(record['reviewer'])

    def test_every_closed_counter_meets_the_floor_or_is_registered(self):
        registered = {
            (r['icon'], r['nativeSize'], r['appearance'])
            for r in json.loads((ROOT / 'catalog' / 'exceptions.json').read_text())
            if r['rule'] == 'counter-inscribed-diameter'
        }
        self.assertEqual(registered, {('branch', 16, 'outline')})
        for icon_id in CANONICAL_IDS:
            for n in MASTERS:
                for appearance in APPEARANCES:
                    with self.subTest(icon=icon_id, master=n, appearance=appearance):
                        for diameter in hole_diameters(product(icon_id, n, appearance)):
                            if (icon_id, n, appearance) not in registered:
                                self.assertGreaterEqual(diameter + FLATTENING_SLACK, COUNTER_FLOOR[n])

    def test_branch_keeps_three_nodes_and_its_label_rule(self):
        for n in MASTERS:
            with self.subTest(master=n):
                outline, filled = product('branch', n, 'outline'), product('branch', n, 'filled')
                self.assertEqual(len(parts(outline)), 1)
                self.assertEqual(len(parts(filled)), 1)
                self.assertEqual(holes(filled), [])
                nodes = sorted(holes(outline), key=lambda h: h.centroid.x)
                self.assertEqual(len(nodes), 3)
                for node in nodes:
                    self.assertGreater(4 * math.pi * node.area / node.length ** 2, 0.98)
                # One node on the left, two stacked symmetrically on the right.
                left, *right = nodes
                self.assertLess(left.centroid.x, right[0].centroid.x)
                self.assertAlmostEqual(right[0].centroid.x, right[1].centroid.x, delta=0.01)
                self.assertAlmostEqual(right[0].centroid.y + right[1].centroid.y, n, delta=0.01)
                self.assertAlmostEqual(left.centroid.y, n / 2, delta=0.01)
        meta = next(m for m in json.loads((ROOT / 'catalog' / 'icons.json').read_text())['icons'] if m['id'] == 'branch')
        self.assertIn('every size', meta['review']['usage'])

    def test_link_is_one_woven_chain_on_a_single_axis(self):
        def check(n, appearance, g):
            self.assertAlmostEqual(long_axis_degrees(g), 45, delta=1)
            self.assertEqual(len(parts(g)), 2)
            self.assertAlmostEqual(parts(g)[0].area, parts(g)[1].area, delta=0.01 * g.area)
            # A half turn carries one link onto the other, so neither master can splay.
            turned = affinity.rotate(g, 180, origin=(n / 2, n / 2))
            self.assertLess(turned.symmetric_difference(g).area, 0.01 * g.area)
            # The weave is a visible cut, not a hairline.
            self.assertGreaterEqual(parts(g)[0].distance(parts(g)[1]), 0.6 * OUTLINE_WIDTH[n] - 0.01)
        self.check_each('link', check)

    def test_link_keeps_three_transparent_counters(self):
        def check(n, appearance, g):
            found = counters(g, n)
            self.assertEqual(len(found), 3, found)
            self.assertGreaterEqual(found[0] + 0.02, COUNTER_FLOOR[n])
        self.check_each('link', check)

    def test_link_weight_pair_shares_a_centerline(self):
        for n in MASTERS:
            with self.subTest(master=n):
                outline, filled = product('link', n, 'outline'), product('link', n, 'filled')
                self.assertGreater(filled.area, outline.area)
                grown = (LINK_BOLD_WIDTH[n] - OUTLINE_WIDTH[n]) / 2
                self.assertAlmostEqual(filled.bounds[0], outline.bounds[0] - grown, delta=0.02)
                self.assertAlmostEqual(filled.bounds[2], outline.bounds[2] + grown, delta=0.02)

    def test_filled_link_12_stays_open_at_1x(self):
        ink = {n: product('link', n, 'filled').area / n ** 2 for n in MASTERS}
        # No denser than the 16 master: at 2 px it carried 38.2% ink and its lens barely cleared the floor.
        self.assertLessEqual(ink[12], ink[16])
        self.assertAlmostEqual(stroke_width(product('link', 12, 'filled')), LINK_BOLD_WIDTH[12], delta=FLATTENING_SLACK)
        self.assertGreater(product('link', 12, 'filled').area, 1.5 * product('link', 12, 'outline').area)
        self.assertGreaterEqual(counters(product('link', 12, 'filled'), 12)[0], 1.2)

    def test_arrow_12_outline_shaft_matches_its_head_at_1x(self):
        g = product('arrow-right', 12, 'outline')
        peak, ratio = line_concentration(pixel_alpha(g, 12), [(3, y) for y in range(3, 9)])
        self.assertGreater(peak, 0.95)
        self.assertGreater(ratio, 0.95)
        # That row is inside the filled partner's 2 px shaft, so switching style does not jump.
        filled = pixel_alpha(product('arrow-right', 12, 'filled'), 12)
        self.assertGreater(filled.getpixel((3, 5)) / 255, 0.95)
        self.assertGreater(filled.getpixel((3, 6)) / 255, 0.95)

    def test_arrow_is_continuous_with_one_head_angle(self):
        def check(n, appearance, g):
            self.assertEqual(len(parts(g)), 1)
            self.assertEqual(holes(g), [])
            t = OUTLINE_WIDTH[n] if appearance == 'outline' else BOLD_WIDTH[n]
            minx, miny, maxx, maxy = g.bounds
            # Outline 12 sits on a pixel row; expected_register holds it to the register.
            centre = 5.5 if (n, appearance) == (12, 'outline') else n / 2
            self.assertAlmostEqual((miny + maxy) / 2, centre, delta=0.01)
            tip = (maxx - t / 2, centre)
            top = [x for x, y in parts(g)[0].exterior.coords if y < miny + 1e-3]
            cap = (sum(top) / len(top), miny + t / 2)
            half_angle = math.degrees(math.atan2(tip[1] - cap[1], tip[0] - cap[0]))
            self.assertAlmostEqual(half_angle, 45, delta=1)
            # The notch between arm and shaft stays open at the arm's end.
            shaft_top = centre - t / 2
            column = g.intersection(LineString([(cap[0], 0), (cap[0], centre)]))
            arm = min(column.geoms, key=lambda s: s.bounds[1]) if hasattr(column, 'geoms') else column
            self.assertGreaterEqual(shaft_top - arm.bounds[3], GAP_TARGET[n])
        self.check_each('arrow-right', check)

    def test_calendar_tabs_and_rail_carry_contour_weight(self):
        def check(n, appearance, g):
            w = OUTLINE_WIDTH[n]
            minx, miny, maxx, maxy = g.bounds
            band = g.intersection(box(0, miny, n, miny + 0.8 * w))
            tabs = parts(band)
            self.assertEqual(len(tabs), 2)
            for tab in tabs:
                self.assertLessEqual(tab.bounds[2] - tab.bounds[0], w + 0.02)
            self.assertAlmostEqual(tabs[0].centroid.x + tabs[1].centroid.x, n, delta=0.02)
        self.check_each('calendar', check)

    def test_calendar_header_is_a_real_rail(self):
        for n in MASTERS:
            with self.subTest(master=n):
                w = OUTLINE_WIDTH[n]
                outline, filled = product('calendar', n, 'outline'), product('calendar', n, 'filled')
                header, lower = parts(filled)[1], parts(filled)[0]
                self.assertAlmostEqual(lower.bounds[1] - header.bounds[3], w, delta=0.02)
                for found in counters(outline, n)[:2]:
                    self.assertGreaterEqual(found + 0.02, COUNTER_FLOOR[n])
                self.assertGreaterEqual(len(counters(outline, n)), 2)

    def test_calendar_date_marks_reduce_with_the_master(self):
        self.assertEqual(len(holes(product('calendar', 12, 'filled'))), 0)
        self.assertEqual(len(holes(product('calendar', 16, 'filled'))), 0)
        row = sorted(holes(product('calendar', 24, 'filled')), key=lambda h: h.bounds[0])
        self.assertEqual(len(row), 3)
        for left, right in zip(row, row[1:]):
            self.assertGreaterEqual(left.distance(right) + 1e-6, GAP_TARGET[24])

    def test_user_keeps_circular_head_and_a_dome_torso(self):
        def check(n, appearance, g):
            torso = parts(g)[0]
            head = parts(g)[1]
            compact = 4 * math.pi * Polygon(head.exterior).area / head.exterior.length ** 2
            self.assertGreater(compact, 0.99)
            self.assertLess(head.bounds[3], torso.bounds[1])
            self.assertGreaterEqual(torso.distance(head) + 1e-6, GAP_TARGET[n] - 0.01)
            minx, miny, maxx, maxy = torso.bounds
            shoulder = torso.distance(Point(minx, miny))
            foot = torso.distance(Point(minx, maxy))
            # A pill has equal corners, so this ratio would be 1.
            self.assertGreater(shoulder, 1.3 * foot)
        self.check_each('user', check)

    def test_preserved_star_join_stays_smaller_than_acute(self):
        def check(n, appearance, g):
            self.assertLess(min_convex_radius(g), ACUTE_JOIN[n])
            self.assertGreater(min_convex_radius(g), 0.9 * STAR_JOIN[n])
        self.check_each('star', check)


class SvgSafetyTests(unittest.TestCase):
    def test_currentcolor_and_parser_roundtrip(self):
        inv = json.loads((ROOT / 'generated' / 'inventory.json').read_text())
        for r in inv:
            text = (ROOT / 'generated' / r['path']).read_text()
            n, d, g = parse_svg(text)
            self.assertEqual(n, r['master'])
            self.assertIn('fill="currentColor"', text)
            self.assertEqual(hashlib.sha256(text.encode()).hexdigest(), r['sha256'])
            self.assertGreaterEqual(min(g.bounds), -1e-6)
            self.assertLessEqual(max(g.bounds), n + 1e-6)

    def test_curve_aware_parser_accepts_arc_and_cubic(self):
        # Synthetic curves: product files are M/L/Z, but the validator must not
        # fail closed by ignoring A/C/Q the way Outline's parser would.
        arc = (
            'M18 12A6 6 0 0 1 12 18A6 6 0 0 1 6 12'
            'A6 6 0 0 1 12 6A6 6 0 0 1 18 12Z'
        )
        g = parse_path(arc)
        self.assertGreater(g.area, 100)
        cubic = 'M4 12C4 6 8 4 12 4C16 4 20 8 20 12C20 16 16 20 12 20C8 20 4 16 4 12Z'
        parse_path(cubic)
        quad = 'M2 10Q10 2 18 10Z'
        parse_path(quad)

    def test_parser_rejects_unsafe_and_outline_only_is_not_required(self):
        for d in ['M0 0H10Z', 'M0 0V10Z', 'M0 0LNaN 2Z', 'M0 0L1 1', 'M0 0L0 0L0 0Z', 'M0 0L1 1Z<script>']:
            with self.subTest(d=d), self.assertRaises(ValueError):
                parse_path(d)
        base = (ROOT / 'generated' / 'rounded' / 'outline' / '24' / 'home.svg').read_text()
        for bad in [
            base.replace('<path ', '<script>alert(1)</script><path '),
            base.replace('fill="currentColor"', 'fill="#fff"'),
            '<!DOCTYPE svg>' + base,
        ]:
            with self.assertRaises(ValueError):
                parse_svg(bad)

    def test_native_rasters(self):
        inv = json.loads((ROOT / 'generated' / 'inventory.json').read_text())
        for r in inv:
            with self.subTest(path=r['path']):
                txt = (ROOT / 'generated' / r['path']).read_text().replace('currentColor', '#c45c26')
                im = Image.open(io.BytesIO(cairosvg.svg2png(bytestring=txt.encode()))).convert('RGBA')
                self.assertEqual(im.size, (r['master'], r['master']))
                alpha = im.getchannel('A')
                self.assertIsNotNone(alpha.getbbox())
                self.assertEqual(alpha.getpixel((0, 0)), 0)


class IsolationTests(unittest.TestCase):
    def test_outline_svg_hashes_unchanged(self):
        frozen = json.loads((OUTLINE / 'generated-sha256.json').read_text())
        checked = 0
        expected_count = sum(1 for rel in frozen if rel.startswith('generated/outline/') and rel.endswith('.svg'))
        for rel, expected in frozen.items():
            if not rel.startswith('generated/outline/') or not rel.endswith('.svg'):
                continue
            actual = hashlib.sha256((OUTLINE / rel).read_bytes()).hexdigest()
            self.assertEqual(actual, expected, rel)
            checked += 1
        self.assertEqual(checked, expected_count)
        self.assertGreaterEqual(checked, 288)

    def test_rebuild_is_deterministic(self):
        first = json.loads((ROOT / 'generated' / 'sha256.json').read_text())
        from source.build import build
        build()
        second = json.loads((ROOT / 'generated' / 'sha256.json').read_text())
        self.assertEqual(first, second)


if __name__ == '__main__':
    unittest.main(verbosity=2)
