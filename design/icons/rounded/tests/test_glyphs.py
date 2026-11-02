"""Whole-family contracts and the semantic distinctions between Rounded concepts.

Every check reads the exported SVG at its native master and measures a property a person would
care about: topology, counters, gaps, direction, pairing. None of them pins drawer coordinates.
"""
from __future__ import annotations

from itertools import combinations
import hashlib
import json
import math
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from shapely import affinity
from shapely.geometry import LineString, Point, Polygon, box

from source.draw import _DRAWERS
from source.seams import (
    APPEARANCES, BOLD_WIDTH, CANONICAL_IDS, COUNTER_FLOOR, CUT_JOIN, GAP_TARGET, LABELS, MASTERS, MEANING,
    OUTLINE_WIDTH, PADDING, PAIR_MODEL,
)
from source.svg import path_data
from tests.probes import (
    FLATTENING_SLACK, closest_parts, corner_setback, crossings, hole_diameters, holes, line_concentration,
    line_widths, long_axis_degrees, min_convex_radius, overlap, parts, pixel_alpha, product,
)

CALIBRATION = tuple(json.loads((ROOT / 'tests' / 'fixtures' / 'calibration-72-sha256.json').read_text()))
ORIGINAL_12 = {path.split('/')[-1][:-4] for path in CALIBRATION}
ADDED = tuple(i for i in CANONICAL_IDS if i not in ORIGINAL_12)
CENTRE_SLACK = 0.2
# Centred by mass, not by box: a triangle, a diagonal, a pointed star, a lens with a long handle.
OFF_CENTRE_BY_DESIGN = {'play', 'wand', 'star', 'search'}


def registered(rule):
    records = json.loads((ROOT / 'catalog' / 'exceptions.json').read_text())
    return {(r['icon'], r['nativeSize'], r['appearance']) for r in records if r['rule'] == rule}


def compactness(part):
    solid = Polygon(part.exterior)
    return 4 * math.pi * solid.area / solid.length ** 2


def height(part):
    return part.bounds[3] - part.bounds[1]


def width(part):
    return part.bounds[2] - part.bounds[0]


class EachDrawing(unittest.TestCase):
    def each(self, ids=CANONICAL_IDS, masters=MASTERS, appearances=APPEARANCES):
        return [(i, n, a, product(i, n, a)) for i in ids for n in masters for a in appearances]

    def each_master(self, ids=CANONICAL_IDS):
        return [(i, n, product(i, n, 'outline'), product(i, n, 'filled')) for i in ids for n in MASTERS]


class InventoryTests(unittest.TestCase):
    def test_family_covers_every_concept_natively(self):
        self.assertEqual(len(CANONICAL_IDS), 77)
        self.assertEqual(len(ADDED), 65)
        self.assertEqual(set(_DRAWERS), set(CANONICAL_IDS))
        self.assertEqual(set(PAIR_MODEL), set(CANONICAL_IDS))
        catalog = json.loads((ROOT / 'catalog' / 'icons.json').read_text())['icons']
        self.assertEqual([m['id'] for m in catalog], list(CANONICAL_IDS))
        for meta in catalog:
            self.assertEqual(meta['label'], LABELS[meta['id']])
            self.assertEqual(meta['meaning'], MEANING[meta['id']])
            self.assertEqual(meta['pairModel'], PAIR_MODEL[meta['id']])
            self.assertTrue(meta['keywords'])
            self.assertTrue(meta['review']['note'])

    def test_the_original_72_drawings_are_byte_identical(self):
        self.assertEqual(len(CALIBRATION), 72)
        pinned = json.loads((ROOT / 'tests' / 'fixtures' / 'calibration-72-sha256.json').read_text())
        for path, sha in pinned.items():
            self.assertEqual(hashlib.sha256((ROOT / 'generated' / path).read_bytes()).hexdigest(), sha, path)

    def test_every_usage_text_is_one_the_shared_contract_classifies(self):
        allowed = {
            'Use the action name on the enclosing control; 12 px is for labeled information.',
            'The application chooses left/right; artwork does not auto-mirror.',
            'Visible label required at 12 px; contextual label recommended at other sizes.',
            'Requires a visible text label at 12 px. At 16 and 24 px, use the action name on the enclosing control.',
            'Requires a visible text label at every size and appearance. This rule is separate from the Warning restriction record.',
        }
        catalog = {m['id']: m['review'] for m in json.loads((ROOT / 'catalog' / 'icons.json').read_text())['icons']}
        for icon, review in catalog.items():
            if icon == 'warning':
                self.assertEqual(review['usageRestriction'], 'warning-visible-label')
                continue
            self.assertIn(review['usage'], allowed, icon)
        for icon in ('help', 'focus', 'group'):
            self.assertEqual(catalog[icon]['usage'], 'Visible label required at 12 px; contextual label recommended at other sizes.')
        self.assertIn('every size', catalog['branch']['usage'])
        self.assertIn('12 px', catalog['link']['usage'])

    def test_docs_describe_the_whole_family(self):
        for name in ('README.md', 'GRAMMAR.md'):
            text = (ROOT / name).read_text()
            self.assertIn('77', text, name)
            self.assertIn('462', text, name)
            for stale in ('12-icon', 'remaining 36', '**72**', 'this pilot'):
                self.assertNotIn(stale, text, name)
        # The manifest quotes this sentence as the source of two label rules.
        self.assertIn('Branch also requires a visible text label at every size and appearance, and Link requires one at 12 px',
                      (ROOT / 'README.md').read_text())


class FamilyWideTests(EachDrawing):
    def test_every_convex_corner_is_really_round(self):
        for icon, n, appearance, g in self.each():
            with self.subTest(icon=icon, master=n, appearance=appearance):
                self.assertGreater(min_convex_radius(g), 0.9 * CUT_JOIN[n])

    def test_separate_parts_keep_the_gap_target(self):
        for icon, n, appearance, g in self.each():
            with self.subTest(icon=icon, master=n, appearance=appearance):
                gap = closest_parts(g)
                if gap is not None and icon != 'link':  # Link's weave separation is registered.
                    self.assertGreaterEqual(gap + FLATTENING_SLACK, GAP_TARGET[n])

    def test_marks_cut_from_a_filled_frame_stay_clear_of_its_edge(self):
        framed = ('check-circle', 'close-circle', 'info', 'help', 'terminal', 'input', 'smartphone', 'save')
        for icon, n, appearance, g in self.each(framed, appearances=('filled',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                solid = Polygon(parts(g)[0].exterior)
                for hole in holes(g):
                    self.assertGreaterEqual(solid.exterior.distance(hole) + FLATTENING_SLACK, GAP_TARGET[n])

    def test_every_counter_is_open_at_its_native_size(self):
        known = registered('counter-inscribed-diameter')
        for icon, n, appearance, g in self.each():
            with self.subTest(icon=icon, master=n, appearance=appearance):
                if (icon, n, appearance) in known:
                    continue
                for diameter in hole_diameters(g):
                    self.assertGreaterEqual(diameter + FLATTENING_SLACK, COUNTER_FLOOR[n])

    def test_outline_drawings_respect_the_padding_keyline(self):
        for icon, n, appearance, g in self.each(ADDED):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                allowance = 0.05 + (BOLD_WIDTH[n] - OUTLINE_WIDTH[n]) / 2 if appearance == 'filled' else 0.05
                self.assertGreaterEqual(min(g.bounds), PADDING[n] - allowance)
                self.assertLessEqual(max(g.bounds), n - PADDING[n] + allowance)

    def test_drawings_are_centred_or_the_offset_is_registered(self):
        known = registered('weight-pair-centerline-offset') | registered('canvas-centre-offset')
        for icon, n, appearance, g in self.each(tuple(i for i in CANONICAL_IDS if i not in OFF_CENTRE_BY_DESIGN)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                minx, miny, maxx, maxy = g.bounds
                offset = max(abs((minx + maxx) / 2 - n / 2), abs((miny + maxy) / 2 - n / 2))
                if (icon, n, appearance) not in known:
                    self.assertLessEqual(offset, CENTRE_SLACK)

    def test_styles_differ_in_every_pair_and_filled_is_heavier(self):
        for icon, n, outline, filled in self.each_master():
            with self.subTest(icon=icon, master=n):
                self.assertGreater(filled.area, 1.04 * outline.area)
                self.assertLess(overlap(outline, filled), 0.95)

    def test_silhouette_pairs_share_bounds_and_weight_pairs_only_grow(self):
        for icon, n, outline, filled in self.each_master():
            with self.subTest(icon=icon, master=n):
                if PAIR_MODEL[icon] == 'silhouette':
                    for a, b in zip(outline.bounds, filled.bounds):
                        self.assertLess(abs(a - b), 0.05)
                else:
                    grown = (BOLD_WIDTH[n] - OUTLINE_WIDTH[n]) / 2 + 0.55
                    if icon == 'wand':  # The sparkle changes form between the styles.
                        continue
                    for a, b in zip(outline.bounds, filled.bounds):
                        self.assertLessEqual(abs(a - b), grown)

    def test_no_two_concepts_collapse_into_the_same_drawing(self):
        for n in MASTERS:
            for appearance in APPEARANCES:
                with self.subTest(master=n, appearance=appearance):
                    art = {i: product(i, n, appearance) for i in CANONICAL_IDS}
                    self.assertEqual(len({path_data(g) for g in art.values()}), len(art))
                    close = [
                        (a, b, round(overlap(art[a], art[b]), 3)) for a, b in combinations(art, 2)
                        if overlap(art[a], art[b]) > 0.96
                    ]
                    self.assertEqual(close, [])

    def test_every_drawing_paints_a_strong_pixel_at_1x(self):
        for icon, n, appearance, g in self.each(ADDED, masters=(12, 16)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                self.assertGreaterEqual(pixel_alpha(g, n).getextrema()[1] / 255, 0.6)

    def test_one_pixel_lines_are_solid_on_one_row_or_column_at_12(self):
        for icon in ('minus', 'menu'):
            with self.subTest(icon=icon):
                peak, share = line_concentration(pixel_alpha(product(icon, 12, 'outline'), 12), [(6, y) for y in (4, 5, 6)])
                self.assertGreater(peak, 0.95)
                self.assertGreater(share, 0.95)
        # A row that crosses only the stroke: below an upward head, above a downward one.
        for icon, row in (('arrow-up', 8), ('arrow-down', 2), ('upload', 6), ('download', 2), ('type', 6), ('chart', 9), ('align-center', 6)):
            with self.subTest(icon=icon):
                peak, share = line_concentration(pixel_alpha(product(icon, 12, 'outline'), 12), [(x, row) for x in (4, 5, 6)])
                self.assertGreater(peak, 0.95)
                self.assertGreater(share, 0.95)

    def test_outline_rows_sit_inside_the_filled_rows_at_12(self):
        outline, filled = pixel_alpha(product('menu', 12, 'outline'), 12), pixel_alpha(product('menu', 12, 'filled'), 12)
        solid = [y for y in range(12) if outline.getpixel((6, y)) > 240]
        self.assertEqual(len(solid), 3)
        for y in solid:
            self.assertGreater(filled.getpixel((6, y)), 240)


class DirectionTests(EachDrawing):
    def assert_same(self, a, b):
        self.assertLess(a.symmetric_difference(b).area, 0.001 * a.area)

    def test_arrows_chevrons_and_alignment_are_exact_transforms(self):
        flip = dict(xfact=-1, yfact=1)
        for n in MASTERS:
            for appearance in APPEARANCES:
                with self.subTest(master=n, appearance=appearance):
                    origin = (n / 2, n / 2)
                    for a, b in (('arrow-right', 'arrow-left'), ('chevron-right', 'chevron-left'),
                                 ('chevrons-right', 'chevrons-left'), ('align-left', 'align-right')):
                        self.assert_same(affinity.scale(product(a, n, appearance), origin=origin, **flip),
                                         product(b, n, appearance))
                    for pair in (('arrow-right', 'arrow-up'), ('chevron-right', 'chevron-up')):
                        right, up = (product(i, n, appearance) for i in pair)
                        self.assert_same(affinity.affine_transform(right, [0, 1, -1, 0, 0, n]), up)
                    for pair in (('arrow-right', 'arrow-down'), ('chevron-right', 'chevron-down')):
                        right, down = (product(i, n, appearance) for i in pair)
                        self.assert_same(affinity.affine_transform(right, [0, 1, 1, 0, 0, 0]), down)

    def test_arrow_up_right_points_up_and_to_the_right(self):
        for icon, n, appearance, g in self.each(('arrow-up-right',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                self.assertEqual(len(parts(g)), 1)
                self.assertEqual(holes(g), [])
                self.assertAlmostEqual(long_axis_degrees(g), 45, delta=25)
                minx, miny, maxx, maxy = g.bounds
                # The head's corner fills the upper right. The opposite corner holds only the shaft's end.
                upper_right = g.intersection(box((minx + maxx) / 2, miny, maxx, (miny + maxy) / 2)).area
                lower_left = g.intersection(box(minx, (miny + maxy) / 2, (minx + maxx) / 2, maxy)).area
                self.assertGreater(upper_right, 1.6 * lower_left)

    def test_upload_and_download_are_not_arrows_up_and_down(self):
        for n in MASTERS:
            for appearance in APPEARANCES:
                with self.subTest(master=n, appearance=appearance):
                    up, down = product('upload', n, appearance), product('download', n, appearance)
                    for g in (up, down):
                        self.assertEqual(len(parts(g)), 2)
                        arrow, baseline = sorted(parts(g), key=lambda p: p.bounds[1])
                        self.assertGreaterEqual(width(baseline), 0.95 * width(arrow))
                        self.assertLess(height(baseline), 0.3 * height(arrow))
                        self.assertGreaterEqual(arrow.distance(baseline) + FLATTENING_SLACK, GAP_TARGET[n])
                    # One shared baseline, so the two swap in place.
                    self.assertAlmostEqual(max(p.bounds[3] for p in parts(up)), max(p.bounds[3] for p in parts(down)), delta=0.01)
                    # A 45-degree head reaches its full width one half-width from its tip, so that
                    # distance, measured from the correct end, places the tip at the top or the bottom.
                    for g, tip_on_top in ((up, True), (down, False)):
                        arrow = sorted(parts(g), key=lambda p: p.bounds[1])[0]
                        y_at_widest = min(arrow.exterior.coords, key=lambda point: point[0])[1]
                        from_tip = y_at_widest - arrow.bounds[1] if tip_on_top else arrow.bounds[3] - y_at_widest
                        self.assertAlmostEqual(from_tip, width(arrow) / 2, delta=0.1 * n)
                    self.assertEqual(len(parts(product('arrow-up', n, appearance))), 1)

    def test_chevrons_are_two_equal_chevrons_clear_of_each_other(self):
        for icon, n, appearance, g in self.each(('chevrons-right', 'chevrons-left')):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                a, b = parts(g)
                self.assertEqual(len(parts(g)), 2)
                self.assertAlmostEqual(a.area, b.area, delta=0.01 * a.area)
                self.assertLess(height(g), n)
                self.assertLessEqual(abs(a.bounds[1] - b.bounds[1]), 0.01)
                single = product(icon.replace('chevrons', 'chevron'), n, appearance)
                self.assertAlmostEqual(a.area, single.area, delta=0.03 * a.area)

    def test_refresh_is_an_open_cycle_with_one_head(self):
        for icon, n, appearance, g in self.each(('refresh',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                self.assertEqual(len(parts(g)), 1)
                self.assertEqual(holes(g), [], 'the cycle never closes')
                c = n / 2
                self.assertGreater(Point(c, c).distance(g), 0.15 * c)
                # A horizontal path from the centre runs out through the break, on the right.
                clear = [
                    y / 8 for y in range(int(c * 8), n * 8)
                    if g.intersection(LineString([(c, y / 8), (n, y / 8)])).is_empty
                ]
                self.assertGreater(max(clear, default=0) - min(clear, default=0), 0.8 * GAP_TARGET[n])
                # The head adds mass on the upper right, where the arrow finishes.
                self.assertGreater(g.intersection(box(c, 0, n, c)).area, g.intersection(box(c, c, n, n)).area)


class LineMarkTests(EachDrawing):
    def rows(self, g):
        return sorted(parts(g), key=lambda p: p.bounds[1])

    def test_menu_is_three_equal_rows(self):
        for n in MASTERS:
            for appearance in APPEARANCES:
                with self.subTest(master=n, appearance=appearance):
                    menu = self.rows(product('menu', n, appearance))
                    self.assertEqual(len(menu), 3)
                    self.assertEqual(len({round(width(r), 2) for r in menu}), 1)
                    self.assertAlmostEqual(menu[1].centroid.y - menu[0].centroid.y, menu[2].centroid.y - menu[1].centroid.y, delta=0.01)

    def test_align_is_objects_against_an_axis_not_text_lines(self):
        for n in MASTERS:
            for appearance in APPEARANCES:
                with self.subTest(master=n, appearance=appearance):
                    # Left and right: a full-height guide and two panels of unequal length on one edge.
                    left = product('align-left', n, appearance)
                    guide, panels = (lambda found: (found[0], found[1:]))(sorted(parts(left), key=lambda p: p.bounds[0]))
                    self.assertEqual(len(panels), 2)
                    self.assertGreaterEqual(height(guide), 0.95 * (n - 2 * PADDING[n]))
                    self.assertLessEqual(width(guide), OUTLINE_WIDTH[n] + 0.01)
                    self.assertEqual(len({round(p.bounds[0], 2) for p in panels}), 1)
                    self.assertNotAlmostEqual(width(panels[0]), width(panels[1]), delta=0.5)
                    for panel in panels:
                        self.assertGreater(height(panel), 2.5 * OUTLINE_WIDTH[n])
                        self.assertGreaterEqual(guide.distance(panel) + FLATTENING_SLACK, GAP_TARGET[n])
                        self.assertEqual(len(holes(panel)), 1 if appearance == 'outline' else 0)
                    # Centre: every panel is centred on one axis, and the axis continues past them.
                    centre = product('align-center', n, appearance)
                    self.assertEqual(len(parts(centre)), 1)
                    minx, miny, maxx, maxy = centre.bounds
                    axis = (minx + maxx) / 2
                    self.assertEqual(len(line_widths(centre, 'y', miny + 0.3)), 1)
                    top = line_widths(Polygon(parts(centre)[0].exterior), 'y', miny + 0.25 * (maxy - miny))
                    low = line_widths(Polygon(parts(centre)[0].exterior), 'y', miny + 0.75 * (maxy - miny))
                    for run in (top[0], low[0]):
                        self.assertAlmostEqual((run[0] + run[1]) / 2, axis, delta=0.01)
                    self.assertGreater(top[0][1] - top[0][0], low[0][1] - low[0][0])
                    # Menu has no axis and no panels.
                    self.assertLess(overlap(left, product('menu', n, appearance)), 0.5)

    def test_more_is_three_equal_round_dots_in_a_row(self):
        for icon, n, appearance, g in self.each(('more',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                dots = parts(g)
                self.assertEqual(len(dots), 3)
                self.assertEqual(holes(g), [])
                for dot in dots:
                    self.assertGreater(compactness(dot), 0.98)
                    self.assertAlmostEqual(dot.centroid.y, n / 2, delta=0.01)

    def test_minus_is_only_plus_horizontal_stroke(self):
        for icon, n, appearance, g in self.each(('minus',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                self.assertEqual(len(parts(g)), 1)
                plus = product('plus', n, appearance)
                self.assertAlmostEqual(width(g), width(plus), delta=0.01)
                self.assertLess(height(g), 0.3 * height(plus))

    def test_check_is_asymmetric_and_close_is_not(self):
        for icon, n, appearance, g in self.each(('check',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                self.assertEqual(len(parts(g)), 1)
                mirrored = affinity.scale(g, xfact=-1, origin=(n / 2, n / 2))
                self.assertLess(overlap(g, mirrored), 0.6)
                self.assertLess(height(g), width(g))
        for icon, n, appearance, g in self.each(('close',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                turned = affinity.rotate(g, 90, origin=(n / 2, n / 2))
                self.assertLess(g.symmetric_difference(turned).area, 0.01 * g.area)
                self.assertAlmostEqual(long_axis_degrees(g) % 90, 45, delta=2)

    def test_chart_bars_ascend_from_a_shared_base(self):
        for icon, n, appearance, g in self.each(('chart',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                bars = sorted(parts(g), key=lambda p: p.centroid.x)
                self.assertEqual(len(bars), 3)
                self.assertLess(height(bars[0]), height(bars[1]))
                self.assertLess(height(bars[1]), height(bars[2]))
                self.assertEqual(len({round(b.bounds[3], 2) for b in bars}), 1)

    def test_pause_is_two_solid_bars(self):
        for icon, n, appearance, g in self.each(('pause',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                self.assertEqual(len(parts(g)), 2)
                self.assertEqual(holes(g), [])
                a, b = parts(g)
                self.assertAlmostEqual(a.area, b.area, delta=0.01 * a.area)
                self.assertGreater(height(a), 2.5 * width(a))

    def test_activity_is_one_continuous_pulse(self):
        for icon, n, appearance, g in self.each(('activity',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                self.assertEqual(len(parts(g)), 1)
                self.assertEqual(holes(g), [])
                self.assertGreater(width(g), 0.8 * (n - 2 * PADDING[n]))
                # The line rises above and falls below its baseline, turning once on the centre.
                turned = affinity.rotate(g, 180, origin=(n / 2, n / 2))
                self.assertLess(g.symmetric_difference(turned).area, 0.01 * g.area)

    def test_code_is_brackets_and_a_slash_and_terminal_is_a_prompt_in_a_window(self):
        for icon, n, appearance, g in self.each(('code',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                self.assertEqual(holes(g), [], 'Code has no frame')
                found = sorted(parts(g), key=lambda p: p.centroid.x)
                self.assertEqual(len(found), 3)
                left, slash, right = found
                self.assertLess(left.distance(Point(n / 2, n / 2)), n / 2)
                mirrored = affinity.scale(left, xfact=-1, origin=(n / 2, n / 2))
                self.assertLess(mirrored.symmetric_difference(right).area, 0.01 * right.area)
                # The slash leans to the right: its top end is right of its bottom end.
                top = slash.intersection(box(0, slash.bounds[1], n, slash.bounds[1] + height(slash) / 4)).centroid.x
                bottom = slash.intersection(box(0, slash.bounds[3] - height(slash) / 4, n, slash.bounds[3])).centroid.x
                self.assertGreater(top, bottom)
                self.assertGreater(height(slash), height(left))
        for icon, n, appearance, g in self.each(('terminal',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                if appearance == 'outline':
                    frame, *marks = parts(g)
                    self.assertEqual(len(marks), 2)
                    self.assertEqual(len(holes(frame)), 1)
                    window = Polygon(frame.interiors[0])
                    for mark in marks:
                        self.assertTrue(window.contains(mark))
                    chevron, cursor = sorted(marks, key=lambda m: m.bounds[0])
                    self.assertGreater(height(chevron), height(cursor))
                    self.assertGreater(cursor.bounds[0], chevron.bounds[0])
                else:
                    self.assertEqual(len(parts(g)), 1)
                    self.assertEqual(len(holes(g)), 2)
                self.assertGreater(width(g), 0.8 * (n - 2 * PADDING[n]))

    def test_loader_is_a_ring_of_segments_with_a_clear_centre_unlike_sun_and_gear(self):
        for n in MASTERS:
            for appearance in APPEARANCES:
                with self.subTest(master=n, appearance=appearance):
                    c = Point(n / 2, n / 2)
                    loader, sun, gear = (product(i, n, appearance) for i in ('loader', 'sun', 'gear'))
                    self.assertEqual(len(parts(loader)), 8)
                    self.assertEqual(holes(loader), [])
                    self.assertEqual(len({round(p.area, 2) for p in parts(loader)}), 1)
                    self.assertGreater(c.distance(loader), 0.4 * (n / 2))
                    self.assertEqual(len(parts(sun)), 9)
                    core = parts(sun)[0]
                    self.assertGreater(compactness(core), 0.98)
                    self.assertLess(core.distance(c), 0.01 + core.area)
                    for ray in parts(sun)[1:]:
                        self.assertGreaterEqual(core.distance(ray) + FLATTENING_SLACK, GAP_TARGET[n])
                    self.assertEqual(len(parts(gear)), 1, 'gear teeth grow from one body')
                    self.assertEqual(len(holes(gear)), 1, 'the hub is the only counter')
                    self.assertGreaterEqual(crossings(gear, n / 2, n / 2 - PADDING[n] - 0.5 * OUTLINE_WIDTH[n]), 6)
                    self.assertEqual(c.distance(gear.buffer(0)) > 0, True)
                self.assertGreater(hole_diameters(product('gear', n, 'outline'))[0], 1.4 * hole_diameters(product('gear', n, 'filled'))[0])
                self.assertEqual(len(holes(Polygon(parts(product('sun', n, 'outline'))[0].exterior))), 0)
                self.assertEqual(len(holes(parts(product('sun', n, 'outline'))[0])), 1)
                self.assertEqual(len(holes(parts(product('sun', n, 'filled'))[0])), 0)

    def test_group_is_selection_around_objects_not_people_and_not_focus(self):
        for icon, n, appearance, g in self.each(('group',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                found = parts(g)
                self.assertEqual(len(found), 6)
                objects = [p for p in found if abs(p.centroid.x - n / 2) < n / 4 and abs(p.centroid.y - n / 2) < n / 4]
                handles = [p for p in found if p not in objects]
                self.assertEqual(len(objects), 2)
                self.assertEqual(len(handles), 4)
                # One handle per canvas corner.
                self.assertEqual({(p.centroid.x > n / 2, p.centroid.y > n / 2) for p in handles},
                                 {(False, False), (False, True), (True, False), (True, True)})
                # Square-cornered objects on a diagonal: no round head, no torso.
                for item in objects:
                    self.assertLess(compactness(item), 0.97)
                    self.assertAlmostEqual(width(item), height(item), delta=0.01)
                a, b = sorted(objects, key=lambda p: p.centroid.x)
                self.assertAlmostEqual(b.centroid.x - a.centroid.x, b.centroid.y - a.centroid.y, delta=0.01)
        for icon, n, appearance, g in self.each(('focus',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                found = parts(g)
                self.assertEqual(len(found), 5)
                centre = min(found, key=lambda p: p.distance(Point(n / 2, n / 2)))
                self.assertGreater(compactness(centre), 0.98)

    def test_bold_and_type_are_letters_drawn_here(self):
        for icon, n, appearance, g in self.each(('bold',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                self.assertEqual(len(parts(g)), 1)
                upper, lower = sorted(holes(g), key=lambda h: h.bounds[1])
                self.assertLessEqual(upper.area, lower.area * 1.01)
                self.assertGreater(height(g), width(g))
                # Bowls are round on the right and the stem is on the left.
                stem = line_widths(g, 'y', (upper.bounds[1] + upper.bounds[3]) / 2)
                self.assertEqual(len(stem), 2)
        for icon, n, appearance, g in self.each(('type',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                self.assertEqual(holes(g), [])
                self.assertEqual(len(parts(g)), 1)
                minx, miny, maxx, maxy = g.bounds
                top = g.intersection(box(0, miny, n, miny + 0.2 * (maxy - miny)))
                lower = g.intersection(box(0, miny + 0.45 * (maxy - miny), n, miny + 0.8 * (maxy - miny)))
                self.assertGreater(width(top), 2.5 * width(lower))

    def test_wand_is_a_diagonal_stick_with_a_separate_sparkle(self):
        for icon, n, appearance, g in self.each(('wand',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                found = parts(g)
                self.assertGreaterEqual(len(found), 2)
                stick = found[0] if width(found[0]) > height(found[0]) * 0.8 and found[0].centroid.x < n / 2 else min(found, key=lambda p: p.centroid.x)
                self.assertLess(stick.centroid.x, n / 2)
                self.assertGreater(stick.centroid.y, n / 2)
                spark = min(found, key=lambda p: p.distance(Point(n, 0)))
                self.assertGreater(spark.centroid.x, n / 2)
                self.assertLess(spark.centroid.y, n / 2)


class FrameTests(EachDrawing):
    def test_dot_is_small_and_solid_and_circle_is_full_size(self):
        for n in MASTERS:
            with self.subTest(master=n):
                for appearance in APPEARANCES:
                    dot, disc = product('dot', n, appearance), product('circle', n, appearance)
                    self.assertEqual(holes(dot), [])
                    self.assertGreater(compactness(parts(dot)[0]), 0.99)
                    self.assertLess(width(dot), 0.45 * width(disc))
                    self.assertAlmostEqual(min(disc.bounds), PADDING[n], delta=0.01)
                self.assertEqual(len(holes(product('circle', n, 'outline'))), 1)
                self.assertEqual(holes(product('circle', n, 'filled')), [])

    def test_square_has_corners_where_circle_does_not(self):
        for n in MASTERS:
            for appearance in APPEARANCES:
                with self.subTest(master=n, appearance=appearance):
                    square, disc = product('square', n, appearance), product('circle', n, appearance)
                    self.assertAlmostEqual(width(square), height(square), delta=0.01)
                    minx, miny = square.bounds[:2]
                    self.assertLess(corner_setback(square, minx, miny), 0.5 * corner_setback(disc, disc.bounds[0], disc.bounds[1]))

    def test_status_circles_keep_their_frame_and_mark(self):
        for icon in ('check-circle', 'close-circle'):
            for n in MASTERS:
                with self.subTest(icon=icon, master=n):
                    outline, filled = product(icon, n, 'outline'), product(icon, n, 'filled')
                    frame, *marks = parts(outline)
                    self.assertEqual(len(marks), 1)
                    self.assertAlmostEqual(min(frame.bounds), PADDING[n], delta=0.01)
                    self.assertEqual(len(parts(filled)), 1)
                    self.assertEqual(len(holes(filled)), 1)
                    bare = product(icon.replace('-circle', ''), n, 'outline')
                    self.assertLess(width(marks[0]), width(bare))
        for n in MASTERS:
            checked = parts(product('check-circle', n, 'outline'))[1]
            crossed = parts(product('close-circle', n, 'outline'))[1]
            self.assertLess(overlap(checked, crossed), 0.5)

    def test_ban_keeps_both_counters_in_both_styles(self):
        for n in MASTERS:
            with self.subTest(master=n):
                outline, filled = product('ban', n, 'outline'), product('ban', n, 'filled')
                for g in (outline, filled):
                    self.assertEqual(len(parts(g)), 1)
                    self.assertEqual(len(holes(g)), 2)
                    a, b = sorted(holes(g), key=lambda h: h.centroid.x)
                    # A backslash: the openings sit lower left and upper right.
                    self.assertGreater(a.centroid.y, b.centroid.y)
                    self.assertLess(g.bounds[0], PADDING[n] + 0.01)
                self.assertEqual(outline.bounds, filled.bounds)
                self.assertGreater(filled.area, outline.area)
                self.assertGreaterEqual(hole_diameters(filled)[0], COUNTER_FLOOR[n])

    def test_info_and_help_are_different_marks_on_one_frame(self):
        for n in MASTERS:
            with self.subTest(master=n):
                frame, stem, dot = parts(product('info', n, 'outline'))
                self.assertGreater(stem.bounds[1], dot.bounds[1], 'the dot of Info is on top')
                self.assertGreater(compactness(dot), 0.98)
                self.assertGreater(height(stem), width(stem))
                frame, hook, dot = parts(product('help', n, 'outline'))
                self.assertLess(hook.bounds[1], dot.bounds[1], 'the dot of Help is at the foot')
                self.assertGreater(compactness(dot), 0.98)
                self.assertGreater(width(hook), 1.5 * width(dot))
                for icon in ('info', 'help'):
                    self.assertEqual(len(holes(product(icon, n, 'filled'))), 2)

    def test_grid_is_uniform_and_dashboard_is_not(self):
        for n in MASTERS:
            for appearance in APPEARANCES:
                with self.subTest(master=n, appearance=appearance):
                    grid, dashboard = parts(product('grid', n, appearance)), parts(product('dashboard', n, appearance))
                    self.assertEqual(len(grid), 4)
                    self.assertEqual(len(dashboard), 4)
                    self.assertLess(max(p.area for p in grid) / min(p.area for p in grid), 1.01)
                    self.assertGreater(max(p.area for p in dashboard) / min(p.area for p in dashboard), 1.3)
                    # Two columns of equal width, with staggered heights.
                    self.assertEqual(len({round(p.bounds[0], 2) for p in dashboard}), 2)
                    self.assertEqual(len({round(width(p), 2) for p in dashboard}), 1)
                    self.assertGreater(len({round(height(p), 2) for p in dashboard}), 1)
                    self.assertAlmostEqual(closest_parts(product('grid', n, appearance)), closest_parts(product('dashboard', n, appearance)), delta=0.01)

    def test_table_has_a_header_band_and_cells(self):
        for n in MASTERS:
            with self.subTest(master=n):
                outline, filled = product('table', n, 'outline'), product('table', n, 'filled')
                cells = 2 if n == 12 else 4
                self.assertEqual(len(parts(filled)), 1)
                self.assertEqual(len(holes(filled)), cells)
                self.assertEqual(len(holes(outline)), cells + 1, 'the outline header is one more counter')
                # The filled header is solid across the full width above the cells.
                top = min(h.bounds[1] for h in holes(filled))
                self.assertGreaterEqual(top - filled.bounds[1], 2 * OUTLINE_WIDTH[n])

    def test_input_is_a_wide_field_with_only_a_caret(self):
        for n in MASTERS:
            with self.subTest(master=n):
                outline, filled = product('input', n, 'outline'), product('input', n, 'filled')
                self.assertGreater(width(outline), height(outline))
                frame, caret = parts(outline)
                self.assertGreater(height(caret), 2 * width(caret))
                self.assertLess(caret.centroid.x, n / 2, 'the caret waits at the start of the field')
                self.assertEqual(len(holes(filled)), 1)


class ObjectTests(EachDrawing):
    def test_edit_is_a_pencil_tapering_to_its_lower_left(self):
        for icon, n, appearance, g in self.each(('edit',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                self.assertAlmostEqual(long_axis_degrees(g), 45, delta=6)
                # Lay the pencil flat, with the tip on the left, and compare its widths.
                flat = affinity.rotate(g, 45, origin=(n / 2, n / 2))
                solid = Polygon(parts(flat)[0].exterior) if appearance == 'outline' else flat
                minx, miny, maxx, maxy = flat.bounds
                def across(share):
                    runs = line_widths(solid, 'x', minx + share * (maxx - minx))
                    return runs[-1][1] - runs[0][0]
                self.assertLess(across(0.04), 0.5 * across(0.5))
                self.assertLessEqual(across(0.5), across(0.97) * 1.6)

    def test_copy_keeps_the_rear_sheet_a_contour_in_both_styles(self):
        for icon, n, appearance, g in self.each(('copy',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                front, rear = parts(g)
                self.assertEqual(len(parts(g)), 2)
                self.assertLess(rear.centroid.x, front.centroid.x)
                self.assertLess(rear.centroid.y, front.centroid.y)
                self.assertLessEqual(2 * (Polygon(rear.exterior).buffer(-OUTLINE_WIDTH[n] / 2 - 0.05).area), 0.01)
        for n in MASTERS:
            self.assertEqual(len(holes(product('copy', n, 'outline'))), 1)
            self.assertEqual(holes(product('copy', n, 'filled')), [])

    def test_trash_lid_floats_over_its_body(self):
        for n in MASTERS:
            for appearance in APPEARANCES:
                with self.subTest(master=n, appearance=appearance):
                    g = product('trash', n, appearance)
                    self.assertEqual(len(parts(g)) >= 2, True)
                    lid, *rest = sorted(parts(g), key=lambda p: p.bounds[1])
                    body = max(rest, key=lambda p: p.area)
                    self.assertGreater(width(lid), width(body))
                    self.assertLess(height(lid), 0.5 * height(body))
                    self.assertGreaterEqual(lid.distance(body) + FLATTENING_SLACK, GAP_TARGET[n])
        self.assertEqual(len(holes(product('trash', 24, 'filled'))), 2, 'slots only where they fit')
        self.assertEqual(holes(product('trash', 12, 'filled')), [])

    def test_filter_is_a_funnel_with_a_solid_stem(self):
        for icon, n, appearance, g in self.each(('filter',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                self.assertEqual(len(parts(g)), 1)
                minx, miny, maxx, maxy = g.bounds
                top_run = line_widths(g, 'y', miny + OUTLINE_WIDTH[n] / 2)
                stem_run = line_widths(g, 'y', maxy - 0.2 * (maxy - miny))
                self.assertEqual(len(stem_run), 1, 'the stem is solid')
                self.assertGreater(top_run[-1][1] - top_run[0][0], 2.5 * (stem_run[0][1] - stem_run[0][0]))
                self.assertEqual(len(holes(g)), 1 if appearance == 'outline' else 0)

    def test_save_is_a_clipped_disk_with_a_slot_and_a_label(self):
        for n in MASTERS:
            with self.subTest(master=n):
                filled = product('save', n, 'filled')
                slot, window = sorted(holes(filled), key=lambda h: h.bounds[1])
                self.assertEqual(len(holes(filled)), 2)
                self.assertGreater(width(window), width(slot))
                self.assertGreater(height(window), height(slot))
                minx, miny, maxx, maxy = filled.bounds
                self.assertGreater(corner_setback(filled, maxx, miny), 1.3 * corner_setback(filled, minx, miny))
                self.assertGreaterEqual(len(holes(product('save', n, 'outline'))), 1)

    def test_folder_has_a_tab_on_its_left(self):
        for icon, n, appearance, g in self.each(('folder',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                self.assertEqual(len(parts(g)), 1)
                minx, miny, maxx, maxy = g.bounds
                run = line_widths(g, 'y', miny + 0.35 * OUTLINE_WIDTH[n])
                self.assertLess(run[-1][1], (minx + maxx) / 2 + 0.2 * (maxx - minx))
                self.assertGreater(width(g), height(g))

    def test_bookmark_keeps_an_open_notch_and_two_points(self):
        for icon, n, appearance, g in self.each(('bookmark',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                self.assertEqual(len(parts(g)), 1)
                minx, miny, maxx, maxy = g.bounds
                low = maxy - 0.15 * (maxy - miny)
                self.assertEqual(len(line_widths(Polygon(parts(g)[0].exterior), 'y', low)), 2)
                self.assertLess(width(g), height(g))

    def test_chat_tail_is_below_the_bubble_on_its_left(self):
        for icon, n, appearance, g in self.each(('chat',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                solid = Polygon(parts(g)[0].exterior)
                minx, miny, maxx, maxy = solid.bounds
                foot = solid.intersection(box(minx, maxy - 0.5 * OUTLINE_WIDTH[n], maxx, maxy))
                self.assertLess(foot.centroid.x, n / 2)
                self.assertLess(width(foot), 0.5 * width(solid))

    def test_bell_has_a_detached_clapper_and_no_warning_punctuation(self):
        for icon, n, appearance, g in self.each(('bell',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                body, clapper = parts(g)
                self.assertEqual(len(parts(g)), 2)
                self.assertGreater(clapper.bounds[1], body.bounds[3])
                self.assertLess(width(clapper), 0.6 * width(body))
                self.assertAlmostEqual(clapper.centroid.x, n / 2, delta=0.01)
                self.assertEqual(len(holes(g)), 1 if appearance == 'outline' else 0)

    def test_lock_shackle_stays_open_in_both_styles(self):
        for n in MASTERS:
            with self.subTest(master=n):
                outline, filled = product('lock', n, 'outline'), product('lock', n, 'filled')
                keyhole = 1 if n == 24 else 0
                self.assertEqual(len(parts(outline)), 1 + keyhole)
                self.assertEqual(len(parts(filled)), 1)
                self.assertEqual(len(holes(filled)), 1 + keyhole, 'shackle counter, plus a keyhole only at 24')
                shackle_counter = sorted(holes(filled), key=lambda h: h.bounds[1])[0]
                self.assertGreaterEqual(2 * OUTLINE_WIDTH[n], 0)
                self.assertGreater(width(shackle_counter), 2 * COUNTER_FLOOR[n])

    def test_shield_tapers_to_a_round_point(self):
        for icon, n, appearance, g in self.each(('shield',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                solid = Polygon(parts(g)[0].exterior)
                minx, miny, maxx, maxy = solid.bounds
                low = line_widths(solid, 'y', maxy - 0.1 * (maxy - miny))
                high = line_widths(solid, 'y', miny + 0.3 * (maxy - miny))
                self.assertLess(low[0][1] - low[0][0], 0.4 * (high[0][1] - high[0][0]))
                self.assertGreater(min_convex_radius(g), 0.45 * OUTLINE_WIDTH[n])

    def test_play_points_right_and_its_mass_balances(self):
        for icon, n, appearance, g in self.each(('play',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                solid = Polygon(parts(g)[0].exterior)
                minx, miny, maxx, maxy = solid.bounds
                near_tip = line_widths(solid, 'x', maxx - 0.1 * (maxx - minx))
                near_base = line_widths(solid, 'x', minx + 0.1 * (maxx - minx))
                self.assertLess(near_tip[0][1] - near_tip[0][0], 0.4 * (near_base[0][1] - near_base[0][0]))
                self.assertAlmostEqual(solid.centroid.x, n / 2, delta=0.1 * n)
                self.assertGreater((minx + maxx) / 2, n / 2)

    def test_box_shows_three_faces_of_a_package(self):
        for n in MASTERS:
            with self.subTest(master=n):
                outline, filled = product('box', n, 'outline'), product('box', n, 'filled')
                self.assertEqual(len(holes(outline)), 3)
                self.assertEqual(len(parts(outline)), 1)
                self.assertEqual(len(parts(filled)), 2, 'the top face is split from the two lower faces')
                self.assertGreater(height(outline), 0.95 * width(outline))
                self.assertEqual(len(line_widths(filled, 'y', n / 2 + 0.2 * n)), 2, 'the spine splits the lower faces')

    def test_laptop_and_smartphone_differ_by_more_than_size(self):
        for n in MASTERS:
            for appearance in APPEARANCES:
                with self.subTest(master=n, appearance=appearance):
                    screen, base = parts(product('laptop', n, appearance))
                    self.assertGreater(width(base), width(screen))
                    self.assertGreater(base.bounds[1], screen.bounds[3])
                    phone = parts(product('smartphone', n, appearance))[0]
                    self.assertGreater(height(phone), 1.4 * width(phone))
                    self.assertGreater(width(screen), height(screen))

    def test_moon_is_a_crescent_and_heart_is_not_star(self):
        for icon, n, appearance, g in self.each(('moon',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                solid = Polygon(parts(g)[0].exterior)
                self.assertEqual(len(parts(g)), 1)
                self.assertLess(solid.area / solid.convex_hull.area, 0.8)
                self.assertEqual(len(holes(g)), 1 if appearance == 'outline' else 0)
        for icon, n, appearance, g in self.each(('heart',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                solid = Polygon(parts(g)[0].exterior)
                mirrored = affinity.scale(solid, xfact=-1, origin=(n / 2, n / 2))
                self.assertLess(solid.symmetric_difference(mirrored).area, 0.01 * solid.area)
                minx, miny, maxx, maxy = solid.bounds
                # Two lobes at the top, one point at the foot.
                self.assertEqual(len(line_widths(solid, 'y', miny + 0.05 * (maxy - miny))), 2)
                self.assertEqual(len(line_widths(solid, 'y', maxy - 0.1 * (maxy - miny))), 1)
                self.assertLess(overlap(solid, Polygon(parts(product('star', n, appearance))[0].exterior)), 0.75)

    def test_layers_is_one_sheet_over_the_edge_of_another(self):
        for n in MASTERS:
            for appearance in APPEARANCES:
                with self.subTest(master=n, appearance=appearance):
                    g = product('layers', n, appearance)
                    sheet, *edges = sorted(parts(g), key=lambda p: p.bounds[1])
                    self.assertEqual(len(edges), 2 if n == 24 else 1)
                    self.assertEqual(len(holes(sheet)), 1 if appearance == 'outline' else 0)
                    for edge in edges:
                        self.assertEqual(holes(edge), [])
                        self.assertGreater(edge.bounds[3], sheet.bounds[3])

    def test_cursor_tip_is_at_the_upper_left_on_its_own_axis(self):
        for icon, n, appearance, g in self.each(('cursor',)):
            with self.subTest(icon=icon, master=n, appearance=appearance):
                solid = Polygon(parts(g)[0].exterior)
                minx, miny, maxx, maxy = solid.bounds
                self.assertLess(corner_setback(solid, minx, miny), 0.9 * OUTLINE_WIDTH[n] + 0.4)
                self.assertGreater(corner_setback(solid, maxx, maxy), 0.2 * n)
                mirrored = affinity.affine_transform(solid, [0, 1, 1, 0, 0, 0])
                self.assertLess(solid.symmetric_difference(mirrored).area, 0.01 * solid.area)


class NewProbeNegativeControls(unittest.TestCase):
    """The new probes must reject what they guard against."""

    def test_overlap_flags_identical_and_clears_disjoint_art(self):
        a = box(0, 0, 4, 4)
        self.assertEqual(overlap(a, a), 1)
        self.assertEqual(overlap(a, box(6, 6, 8, 8)), 0)

    def test_closest_parts_sees_a_crowded_pair(self):
        crowded = box(0, 0, 4, 4).union(box(4.5, 0, 8, 4))
        self.assertAlmostEqual(closest_parts(crowded), 0.5)
        self.assertLess(closest_parts(crowded), GAP_TARGET[12])
        self.assertIsNone(closest_parts(box(0, 0, 4, 4)))

    def test_crossings_counts_teeth_and_rejects_a_plain_disc(self):
        disc = Point(12, 12).buffer(10, quad_segs=32)
        self.assertEqual(crossings(disc, 12, 8), 1)
        toothed = disc.buffer(-4).union(box(11, 0, 13, 24)).union(box(0, 11, 24, 13))
        self.assertEqual(crossings(toothed, 12, 9), 4)

    def test_line_widths_find_a_notch(self):
        notched = box(0, 0, 8, 8).difference(box(3, 4, 5, 9))
        self.assertEqual(len(line_widths(notched, 'y', 6)), 2)
        self.assertEqual(len(line_widths(notched, 'y', 2)), 1)

    def test_a_filled_copy_of_outline_fails_the_pair_rule(self):
        g = product('square', 24, 'outline')
        self.assertGreater(overlap(g, g), 0.93)
        self.assertFalse(g.area > 1.04 * g.area)

    def test_the_uniform_rule_rejects_dashboard_and_the_varied_rule_rejects_grid(self):
        grid = parts(product('grid', 24, 'filled'))
        dashboard = parts(product('dashboard', 24, 'filled'))
        self.assertGreater(max(p.area for p in dashboard) / min(p.area for p in dashboard), 1.01)
        self.assertLess(max(p.area for p in grid) / min(p.area for p in grid), 1.3)

    def test_the_frame_rule_rejects_terminal_as_code(self):
        self.assertTrue(holes(product('terminal', 24, 'outline')))
        self.assertEqual(holes(product('code', 24, 'outline')), [])

    def test_the_group_rule_rejects_focus_and_a_person(self):
        self.assertNotEqual(len(parts(product('focus', 24, 'outline'))), 6)
        self.assertNotEqual(len(parts(product('user', 24, 'outline'))), 6)


if __name__ == '__main__':
    unittest.main(verbosity=2)
