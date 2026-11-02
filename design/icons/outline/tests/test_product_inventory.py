"""The 29 product concepts: identity, safety and independent construction.

These read exported registry paths and native rasters, never constructor
coordinates. They guard semantics and construction; they do not establish
recognition or design approval.
"""
import io
import json
import math
import sys
import unittest
from pathlib import Path

import cairosvg
from PIL import Image
from shapely import affinity, maximum_inscribed_circle
from shapely.geometry import LineString, Point, Polygon, box

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from tests.geometry.paths import parse_path

CATALOG = json.loads((ROOT / 'catalog/icons.json').read_text())
ICONS = {icon['id']: icon for icon in CATALOG['icons']}
CONTRACT = json.loads((ROOT / 'tests/fixtures/product-inventory-2026-11-01.json').read_text())['concepts']
NEW = [concept['id'] for concept in CONTRACT if not concept['existing']]
REG = json.loads((ROOT / 'generated/registry.json').read_text())['paths']
MASTERS = (12, 16, 24)
STYLES = ('outline', 'filled')
GAP = {12: 1, 16: 1.5, 24: 2}
PADDING = dict(GAP)
ALL = [(icon, style, n) for icon in NEW for style in STYLES for n in MASTERS]


def geometry(icon, style, n):
    return parse_path(REG[icon][style][str(n)])


def parts(g):
    return sorted((p for p in getattr(g, 'geoms', [g]) if isinstance(p, Polygon)), key=lambda p: (p.bounds[0], p.bounds[1]))


def holes(g):
    return [Polygon(hole) for p in parts(g) for hole in p.interiors]


def size(p):
    x0, y0, x1, y1 = p.bounds
    return x1 - x0, y1 - y0


def alpha(icon, style, n, scale=1):
    svg = f'<svg xmlns="http://www.w3.org/2000/svg" width="{n}" height="{n}" viewBox="0 0 {n} {n}" fill="#000" fill-rule="evenodd"><path d="{REG[icon][style][str(n)]}"/></svg>'
    png = cairosvg.svg2png(bytestring=svg.encode(), output_width=n * scale, output_height=n * scale)
    return Image.open(io.BytesIO(png)).convert('RGBA').getchannel('A')


def mirrored(g, n):
    return affinity.scale(g, -1, 1, origin=(n / 2, n / 2))


def overlap(a, b):
    return a.intersection(b).area / a.union(b).area


class InventoryContract(unittest.TestCase):
    def test_contract_rows_govern_the_catalog(self):
        self.assertEqual(len(CONTRACT), 77)
        self.assertEqual(len(NEW), 29)
        for concept in CONTRACT:
            with self.subTest(icon=concept['id']):
                icon = ICONS[concept['id']]
                self.assertEqual(icon['label'], concept['label'])
                self.assertEqual(icon['category'], concept['category'])
                self.assertEqual(icon['meaning'], concept['meaning'])

    def test_new_concepts_are_original_and_pending_review(self):
        for name in NEW:
            with self.subTest(icon=name):
                icon = ICONS[name]
                self.assertEqual(icon['stage'], 'product-addition')
                self.assertEqual(icon['provenance']['method'], 'original-construction-with-family-primitives')
                self.assertTrue(icon['provenance']['source'].startswith('source/outline/product/'))
                self.assertTrue((ROOT / icon['provenance']['source']).is_file())
                self.assertIs(icon['provenance']['externalArtworkUsed'], False)
                self.assertEqual(icon['review']['recognition'], 'not-user-tested')
                self.assertEqual(icon['review']['independentApproval'], 'pending')
                self.assertEqual(icon['aliases'], [])

    def test_no_restriction_or_exception_record_was_added(self):
        restrictions = json.loads((ROOT / 'catalog/restrictions.json').read_text())['records']
        exceptions = json.loads((ROOT / 'catalog/exceptions.json').read_text())
        self.assertEqual({r['icon'] for r in restrictions}, {'warning'})
        self.assertFalse({e['icon'] for e in exceptions} & set(NEW))
        self.assertTrue(all(not ICONS[name]['review']['exceptions'] for name in NEW))


class SharedConstruction(unittest.TestCase):
    def test_drawings_stay_inside_the_keyline(self):
        for icon, style, n in ALL:
            x0, y0, x1, y1 = geometry(icon, style, n).bounds
            with self.subTest(icon=icon, style=style, master=n):
                self.assertGreaterEqual(min(x0, y0), PADDING[n] - .01)
                self.assertLessEqual(max(x1, y1), n - PADDING[n] + .01)

    def test_separated_parts_clear_the_gap_target(self):
        for icon, style, n in ALL:
            pieces = parts(geometry(icon, style, n))
            # Group's filled pair and Sun's rays are separated parts like any other.
            distances = [a.distance(b) for i, a in enumerate(pieces) for b in pieces[i + 1:]]
            with self.subTest(icon=icon, style=style, master=n):
                if distances:
                    self.assertGreaterEqual(min(distances), GAP[n] - .002)

    def test_no_microscopic_counters(self):
        for icon, style, n in ALL:
            for hole in holes(geometry(icon, style, n)):
                diameter = 2 * maximum_inscribed_circle(hole, tolerance=.0005).length
                with self.subTest(icon=icon, style=style, master=n):
                    self.assertGreaterEqual(diameter, .9 * GAP[n])

    def test_counters_stay_open_in_native_and_retina_rasters(self):
        for icon, style, n in ALL:
            g = geometry(icon, style, n)
            for scale in (1, 2):
                pixels = alpha(icon, style, n, scale)
                for hole in holes(g):
                    # A frame's counter can hold a mark, so test the space actually left open.
                    space = hole.difference(g)
                    for free in parts(space):
                        widest = maximum_inscribed_circle(free, tolerance=.001)
                        if 2 * widest.length < 2 / scale:
                            continue  # Narrower than two device pixels: it can straddle them. Its width is measured above.
                        x, y = widest.coords[0]
                        with self.subTest(icon=icon, style=style, master=n, scale=scale):
                            self.assertLess(pixels.getpixel((int(x * scale), int(y * scale))), 128)

    def test_axis_edges_follow_the_native_grid(self):
        for icon, style, n in ALL:
            step = 1 if n == 12 and style == 'outline' and icon in ('table', 'dashboard', 'smartphone', 'group', 'type', 'square') else .25
            for p in parts(geometry(icon, style, n)):
                for ring_ in (p.exterior, *p.interiors):
                    coords = list(ring_.coords)
                    for (ax, ay), (bx, by) in zip(coords, coords[1:]):
                        position = ax if abs(ax - bx) < 1e-6 else ay if abs(ay - by) < 1e-6 else None
                        if position is None or math.hypot(bx - ax, by - ay) < step:
                            continue
                        with self.subTest(icon=icon, style=style, master=n, position=position):
                            self.assertAlmostEqual(position / step, round(position / step), delta=.005)

    def test_styles_differ_and_filled_carries_more_ink(self):
        for icon in NEW:
            for n in MASTERS:
                a, b = geometry(icon, 'outline', n), geometry(icon, 'filled', n)
                with self.subTest(icon=icon, master=n):
                    self.assertGreaterEqual(b.area / a.area, 1.1)
                    self.assertGreater(a.symmetric_difference(b).area / b.area, .1)

    def test_silhouette_pairs_share_their_bounds(self):
        for icon in NEW:
            if ICONS[icon]['pairModel'] != 'silhouette':
                continue
            for n in MASTERS:
                a, b = geometry(icon, 'outline', n), geometry(icon, 'filled', n)
                with self.subTest(icon=icon, master=n):
                    self.assertTrue(all(abs(x - y) < .002 for x, y in zip(a.bounds, b.bounds)))

    def test_small_masters_are_not_scaled_24_px_drawings(self):
        # A plain shape has no detail to vary. Its native decisions are the keyline and
        # the contour token, and 1 and 2 px keep exactly the 12:24 ratio, so these drawings
        # coincide with a scaled 24 px. Everything else carries its own master decisions.
        proportional = {('circle', 'outline', 12), ('circle', 'filled', 12), ('ban', 'outline', 12), ('square', 'filled', 16)}
        for icon, style, n in ALL:
            if n == 24 or (icon, style, n) in proportional:
                continue
            scaled = affinity.scale(geometry(icon, style, 24), n / 24, n / 24, origin=(0, 0))
            actual = geometry(icon, style, n)
            with self.subTest(icon=icon, style=style, master=n):
                self.assertGreater(actual.symmetric_difference(scaled).area / actual.area, .03)

    def test_every_new_drawing_differs_from_every_other_icon_at_its_size(self):
        # At least four contour-squares of ink change, so no concept repeats a neighbour.
        for icon, style, n in ALL:
            mine = geometry(icon, style, n)
            for other in REG:
                if other != icon:
                    with self.subTest(icon=icon, other=other, style=style, master=n):
                        self.assertGreater(mine.symmetric_difference(geometry(other, style, n)).area, 4 * GAP[n] ** 2)


class StatusAndShapes(unittest.TestCase):
    STATUS = ('check-circle', 'close-circle', 'ban')

    def test_status_marks_share_infos_frame_and_nothing_else(self):
        for n in MASTERS:
            frame = parse_path(REG['info']['outline'][str(n)])
            for icon in self.STATUS:
                with self.subTest(icon=icon, master=n):
                    self.assertTrue(all(abs(x - y) < .002 for x, y in zip(frame.bounds, geometry(icon, 'outline', n).bounds)))

    def test_status_marks_clear_the_frame(self):
        for n in MASTERS:
            for icon in ('check-circle', 'close-circle'):
                pieces = sorted(parts(geometry(icon, 'outline', n)), key=lambda p: p.area, reverse=True)
                with self.subTest(icon=icon, master=n):
                    self.assertEqual(len(pieces), 2)
                    self.assertGreaterEqual(pieces[0].distance(pieces[1]), GAP[n] - .002)

    def test_status_marks_keep_distinct_structure(self):
        for n in MASTERS:
            with self.subTest(master=n):
                # Close is one cross with four-fold symmetry; Check is an asymmetric single arm.
                close = holes(geometry('close-circle', 'filled', n))[0]
                check = holes(geometry('check-circle', 'filled', n))[0]
                self.assertLess(close.symmetric_difference(affinity.rotate(close, 90, origin=(n / 2, n / 2))).area, .02)
                self.assertGreater(check.symmetric_difference(affinity.rotate(check, 90, origin=(n / 2, n / 2))).area, 1)
                # Ban's negative slash divides the solid; the others keep one silhouette.
                self.assertEqual(len(parts(geometry('ban', 'filled', n))), 2)
                self.assertEqual(len(parts(geometry('check-circle', 'filled', n))), 1)
                self.assertEqual(len(parts(geometry('close-circle', 'filled', n))), 1)

    def test_ban_slash_falls_left_to_right(self):
        for n in MASTERS:
            g = geometry('ban', 'outline', n)
            self.assertLess(abs(g.intersection(Point(n / 2, n / 2).buffer(.2)).area - Point(n / 2, n / 2).buffer(.2).area), .01)
            self.assertLess(g.distance(Point(n * .35, n * .35)), .01)
            self.assertGreater(g.distance(Point(n * .65, n * .35)), .25 * GAP[n])

    def test_circle_square_and_dot_are_three_shapes(self):
        for n in MASTERS:
            circle, square, dot = (geometry(i, 'filled', n) for i in ('circle', 'square', 'dot'))
            with self.subTest(master=n):
                self.assertEqual(len(circle.exterior.coords) - 1, 8)
                self.assertEqual(len(square.exterior.coords) - 1, 4)
                self.assertEqual(len(dot.exterior.coords) - 1, 8)
                edges = [LineString(pair).length for pair in zip(circle.exterior.coords, circle.exterior.coords[1:])]
                self.assertLess(max(edges) / min(edges), 1.25, 'Facets stay close to regular')
                self.assertLess(size(dot)[0], .55 * size(circle)[0], 'Dot is optically separate from Circle')
                self.assertEqual(len(holes(geometry('circle', 'outline', n))), 1)
                self.assertEqual(len(holes(geometry('square', 'outline', n))), 1)
                # Dot stays solid in both styles; Filled is the heavier of the two.
                self.assertEqual(holes(geometry('dot', 'outline', n)), [])
                self.assertGreater(dot.area, geometry('dot', 'outline', n).area)

    def test_loader_is_a_segmented_ring_with_a_visible_rotation(self):
        for n in MASTERS:
            for style in STYLES:
                g = geometry('loader', style, n)
                with self.subTest(master=n, style=style):
                    self.assertEqual(len(parts(g)), 7)
                    self.assertEqual(holes(g), [])
                    self.assertGreater(g.distance(Point(n / 2, n / 2)), n * .15, 'A ring has an empty center')
                    self.assertGreater(g.symmetric_difference(affinity.rotate(g, 45, origin=(n / 2, n / 2))).area, .1 * g.area)

    def test_activity_is_one_pulse_on_a_baseline(self):
        for n in MASTERS:
            for style in STYLES:
                g = geometry('activity', style, n)
                self.assertEqual(len(parts(g)), 1)
                self.assertEqual(holes(g), [])
                x0, y0, x1, y1 = g.bounds
                left = g.intersection(box(x0, 0, x0 + .25, n))
                right = g.intersection(box(x1 - .25, 0, x1, n))
                with self.subTest(master=n, style=style):
                    self.assertAlmostEqual(left.centroid.y, right.centroid.y, delta=.01)
                    # The first peak rises before the fall: a pulse, not a Chart.
                    self.assertLess(g.intersection(box(x0, 0, (x0 + x1) / 2, n)).centroid.y, g.intersection(box((x0 + x1) / 2, 0, x1, n)).centroid.y)


class DirectionAndText(unittest.TestCase):
    def test_chevrons_reuse_the_native_chevron_exactly(self):
        for n in MASTERS:
            for style in STYLES:
                single = geometry('chevron-right', style, n)
                pieces = parts(geometry('chevrons-right', style, n))
                with self.subTest(master=n, style=style):
                    self.assertEqual(len(pieces), 2)
                    for piece in pieces:
                        moved = affinity.translate(single, piece.bounds[0] - single.bounds[0], piece.bounds[1] - single.bounds[1])
                        self.assertLess(moved.symmetric_difference(piece).area, .02)

    def test_chevrons_left_is_the_exact_rotation(self):
        for n in MASTERS:
            for style in STYLES:
                right = affinity.rotate(geometry('chevrons-right', style, n), 180, origin=(n / 2, n / 2))
                with self.subTest(master=n, style=style):
                    self.assertLess(right.symmetric_difference(geometry('chevrons-left', style, n)).area, .02)

    def test_chevrons_paint_centered(self):
        for n in MASTERS:
            for style in STYLES:
                x0, _, x1, _ = geometry('chevrons-right', style, n).bounds
                with self.subTest(master=n, style=style):
                    self.assertAlmostEqual(x0 + x1, n, delta=.01)

    def test_alignment_edges_and_mirror(self):
        for n in MASTERS:
            for style in STYLES:
                left, center, right = (parts(geometry(i, style, n)) for i in ('align-left', 'align-center', 'align-right'))
                menu = parts(geometry('menu', style, n))
                with self.subTest(master=n, style=style):
                    self.assertGreaterEqual(len(left), 3)
                    self.assertEqual(len({round(p.bounds[0], 3) for p in left}), 1)
                    self.assertEqual(len({round(p.bounds[2], 3) for p in right}), 1)
                    self.assertEqual(len({round(p.centroid.x, 3) for p in center}), 1)
                    self.assertLess(mirrored(geometry('align-left', style, n), n).symmetric_difference(geometry('align-right', style, n)).area, .02)
                    # Unequal rows are what separates alignment from Menu's equal bars.
                    self.assertGreater(len({round(size(p)[0], 3) for p in left}), 1)
                    self.assertEqual(len({round(size(p)[0], 3) for p in menu}), 1)

    def test_paragraph_detail_is_only_at_24(self):
        for n, rows in ((12, 3), (16, 3), (24, 4)):
            for icon in ('align-left', 'align-center', 'align-right'):
                for style in STYLES:
                    with self.subTest(icon=icon, master=n, style=style):
                        self.assertEqual(len(parts(geometry(icon, style, n))), rows)

    def test_type_is_a_t_with_head_and_foot(self):
        for n in MASTERS:
            for style in STYLES:
                g = geometry('type', style, n)
                x0, y0, x1, y1 = g.bounds
                top = g.intersection(box(0, y0, n, y0 + .4)).bounds
                bottom = g.intersection(box(0, y1 - .4, n, y1)).bounds
                middle = g.intersection(box(0, (y0 + y1) / 2 - .2, n, (y0 + y1) / 2 + .2)).bounds
                with self.subTest(master=n, style=style):
                    self.assertEqual(len(parts(g)), 1)
                    self.assertEqual(holes(g), [])
                    self.assertGreater(top[2] - top[0], bottom[2] - bottom[0], 'The head is wider than the foot')
                    self.assertGreater(bottom[2] - bottom[0], middle[2] - middle[0], 'The foot is wider than the stem')
                    # Unlike Plus, nothing crosses at mid-height and the head has drops.
                    self.assertLess(middle[2] - middle[0], (x1 - x0) * .4)

    def test_bold_is_a_two_bowl_b(self):
        for n in MASTERS:
            for style in STYLES:
                g = geometry('bold', style, n)
                counters = sorted(holes(g), key=lambda p: p.bounds[1])
                with self.subTest(master=n, style=style):
                    self.assertEqual(len(parts(g)), 1)
                    self.assertEqual(len(counters), 2)
                    self.assertLess(counters[0].bounds[3], counters[1].bounds[1])
                    self.assertGreater(counters[1].area, counters[0].area, 'The lower bowl is larger')
                    # The left edge is one straight stem, the right has a waist notch.
                    self.assertAlmostEqual(g.intersection(box(0, 0, g.bounds[0] + .25, n)).area, .25 * size(g)[1], delta=.05)
                    middle = (counters[0].bounds[3] + counters[1].bounds[1]) / 2
                    self.assertLess(g.intersection(box(0, middle - .1, n, middle + .1)).bounds[2], g.bounds[2] - .4)
            self.assertLess(sum(h.area for h in holes(geometry('bold', 'filled', n))), sum(h.area for h in holes(geometry('bold', 'outline', n))))


class NearestNeighbours(unittest.TestCase):
    def test_code_is_frameless_brackets_and_a_slash_not_a_terminal(self):
        for n in MASTERS:
            for style in STYLES:
                code = geometry('code', style, n)
                pieces = parts(code)
                terminal = geometry('terminal', style, n)
                left, slash, right = pieces
                with self.subTest(master=n, style=style):
                    self.assertEqual(len(pieces), 3)
                    self.assertEqual(holes(code), [], 'Code has no window or counter')
                    self.assertTrue(holes(terminal) or any(p.interiors for p in parts(terminal)), 'Terminal keeps its window')
                    self.assertLess(mirrored(left, n).symmetric_difference(right).area, .02)
                    # Rising slash: its top is right of its bottom.
                    top = slash.intersection(box(0, slash.bounds[1], n, slash.bounds[1] + .5)).centroid.x
                    bottom = slash.intersection(box(0, slash.bounds[3] - .5, n, slash.bounds[3])).centroid.x
                    self.assertGreater(top, bottom)
                    self.assertGreater(size(slash)[1], size(left)[1], 'The slash is taller than a bracket')
                    self.assertAlmostEqual(left.bounds[0] + right.bounds[2], n, delta=.01)

    def test_dashboard_panels_are_unequal_where_grid_is_uniform(self):
        for n in MASTERS:
            for style in STYLES:
                panels = parts(geometry('dashboard', style, n))
                cells = parts(geometry('grid', style, n))
                columns = sorted({round(p.bounds[0], 3) for p in panels})
                with self.subTest(master=n, style=style):
                    self.assertEqual(len(panels), 4)
                    self.assertEqual(len(columns), 2)
                    self.assertEqual(len({round(size(p)[1], 3) for p in panels}), 2)
                    self.assertEqual(len({round(size(p)[1], 3) for p in cells}), 1)
                    self.assertEqual(len({round(size(p)[0], 3) for p in panels}), 1)
                    # Staggered: tall over short on the left, short over tall on the right.
                    left = sorted((p for p in panels if round(p.bounds[0], 3) == columns[0]), key=lambda p: p.bounds[1])
                    right = sorted((p for p in panels if round(p.bounds[0], 3) == columns[1]), key=lambda p: p.bounds[1])
                    self.assertGreater(size(left[0])[1], size(left[1])[1])
                    self.assertLess(size(right[0])[1], size(right[1])[1])
                    for a, b in ((left[0], left[1]), (right[0], right[1]), (left[0], right[0])):
                        self.assertGreaterEqual(a.distance(b), GAP[n] - .002)

    def test_group_is_selection_not_people_and_not_focus(self):
        for n in MASTERS:
            for style in STYLES:
                g = geometry('group', style, n)
                focus = geometry('focus', style, n)
                a, z = g.bounds[0], g.bounds[2]
                c = n / 2
                sides = [box(c - .25, a, c + .25, a + .5), box(c - .25, z - .5, c + .25, z), box(a, c - .25, a + .5, c + .25), box(z - .5, c - .25, z, c + .25)]
                with self.subTest(master=n, style=style):
                    # Selection dashes on every side at mid-length. Focus has corners only.
                    self.assertTrue(all(g.intersects(side) for side in sides))
                    self.assertFalse(any(focus.intersects(side) for side in sides))
                    self.assertEqual(len(parts(g)), 8 + (2 if style == 'outline' else 1))
                    # No person: User's head and shoulders share almost no ink with it.
                    self.assertLess(overlap(g, geometry('user', style, n)), .35)
                    # Its objects sit on the falling diagonal, off Focus's center mark.
                    objects = [p for p in parts(g) if p.distance(Point(c, c)) < n / 4]
                    self.assertTrue(objects)
                    upper_left = min(objects, key=lambda p: p.bounds[0]).bounds
                    lower_right = max(objects, key=lambda p: p.bounds[2]).bounds
                    self.assertLess(upper_left[0], c - n / 8)
                    self.assertLess(upper_left[1], c - n / 8)
                    self.assertGreater(lower_right[2], c + n / 8)
                    self.assertGreater(lower_right[3], c + n / 8)

    def test_group_filled_objects_overlap_and_outline_objects_stay_apart(self):
        for n in MASTERS:
            c = n / 2
            self.assertEqual(len([p for p in parts(geometry('group', 'filled', n)) if p.distance(Point(c, c)) < n / 8]), 1)
            self.assertEqual(len([p for p in parts(geometry('group', 'outline', n)) if p.distance(Point(c, c)) < n / 4]), 2)

    def test_devices_have_opposite_orientation_and_different_structure(self):
        for n in MASTERS:
            for style in STYLES:
                laptop, phone = geometry('laptop', style, n), geometry('smartphone', style, n)
                screen, base = sorted(parts(laptop), key=lambda p: p.bounds[1])
                with self.subTest(master=n, style=style):
                    self.assertGreater(size(laptop)[0], size(laptop)[1])
                    self.assertLess(size(phone)[0], size(phone)[1])
                    self.assertGreater(size(base)[0], size(screen)[0], 'A laptop base is wider than its screen')
                    self.assertGreaterEqual(screen.distance(base), GAP[n] - .002)
                    self.assertLess(overlap(laptop, phone), .7)
            home = sorted(parts(geometry('smartphone', 'outline', n)), key=lambda p: p.area)[0]
            with self.subTest(master=n):
                self.assertGreater(home.centroid.y, n * .6, 'The home mark sits low')
                self.assertAlmostEqual(home.centroid.x, n / 2, delta=.01)
                self.assertEqual(len(holes(geometry('smartphone', 'filled', n))), 1)

    def test_box_shows_three_faces_and_layers_shows_a_stack(self):
        for n in MASTERS:
            self.assertEqual(len(holes(geometry('box', 'outline', n))), 3)
            self.assertEqual(len(parts(geometry('box', 'filled', n))), 3)
            for style in STYLES:
                sheets = sorted(parts(geometry('layers', style, n)), key=lambda p: p.bounds[1])
                with self.subTest(master=n, style=style):
                    self.assertEqual(len(sheets), 3 if n == 24 else 2)
                    self.assertEqual(bool(sheets[0].interiors), style == 'outline')
                    for lower in sheets[1:]:
                        self.assertEqual(len(lower.interiors), 0)
                        # The lower sheets are open V strokes that stay under the top sheet.
                        self.assertGreater(lower.bounds[3], sheets[0].bounds[3])
                    for a, b in zip(sheets, sheets[1:]):
                        self.assertGreaterEqual(a.distance(b), GAP[n] - .002)

    def test_input_has_a_tall_i_beam_breaking_an_open_field(self):
        for n in MASTERS:
            for style in STYLES:
                pieces = parts(geometry('input', style, n))
                beam = max(pieces, key=lambda p: size(p)[1])
                field = [p for p in pieces if p is not beam]
                with self.subTest(master=n, style=style):
                    self.assertEqual(len(pieces), 3)
                    self.assertEqual(holes(geometry('input', style, n)), [])
                    self.assertLess(field[0].bounds[2], beam.bounds[0] + 1e-6)
                    self.assertGreater(field[1].bounds[0], beam.bounds[2] - 1e-6)
                    self.assertGreater(size(beam)[1], 1.25 * size(field[1])[1])
                    self.assertGreater(size(field[1])[0], 2 * size(field[0])[0], 'The insertion point sits at the start')
                    for part in field:
                        self.assertGreaterEqual(part.distance(beam), GAP[n] - .002)

    def test_table_is_one_frame_with_a_header_and_cells(self):
        for n in MASTERS:
            outline = geometry('table', 'outline', n)
            filled = geometry('table', 'filled', n)
            cells = sorted(holes(filled), key=lambda p: (p.bounds[1], p.bounds[0]))
            top = sorted(holes(outline), key=lambda p: p.bounds[1])[0]
            with self.subTest(master=n):
                self.assertEqual(len(parts(outline)), 1)
                self.assertEqual(len(holes(outline)), 5)
                self.assertEqual(len(parts(filled)), 1)
                self.assertEqual(len(cells), 4)
                # The header spans both columns, and is solid in Filled.
                self.assertGreater(size(top)[0], 1.8 * size(cells[0])[0])
                self.assertGreaterEqual(cells[0].bounds[1] - filled.bounds[1], 2 * GAP[n])

    def test_sun_and_moon_are_opposites_with_no_shared_structure(self):
        for n in MASTERS:
            for style in STYLES:
                sun, moon = geometry('sun', style, n), geometry('moon', style, n)
                with self.subTest(master=n, style=style):
                    self.assertEqual(len(parts(sun)), 9, 'A hub and eight rays')
                    self.assertEqual(len(parts(moon)), 1)
                    self.assertLess(overlap(sun, moon), .5)
            # The pair differs in the hub: open in Outline, solid and no smaller in Filled.
            self.assertEqual(len(holes(geometry('sun', 'outline', n))), 1)
            self.assertGreaterEqual(max(size(p)[0] for p in parts(geometry('sun', 'filled', n))), max(size(p)[0] for p in parts(geometry('sun', 'outline', n))))
            self.assertEqual(holes(geometry('sun', 'filled', n)), [])

    def test_moon_is_a_crescent_symmetric_about_the_falling_diagonal(self):
        for n in MASTERS:
            for style in STYLES:
                g = geometry('moon', style, n)
                flipped = affinity.affine_transform(g, [0, -1, -1, 0, n, n])
                solid = Polygon(parts(geometry('moon', 'filled', n))[0].exterior)
                with self.subTest(master=n, style=style):
                    self.assertLess(g.symmetric_difference(flipped).area, .02)
                    self.assertLess(solid.area / solid.convex_hull.area, .85, 'The bite is a real concavity')
                    self.assertFalse(solid.contains(Point(n * .75, n * .25)), 'The bite faces upper right')

    def test_heart_is_mirrored_with_a_top_notch(self):
        for n in MASTERS:
            for style in STYLES:
                g = geometry('heart', style, n)
                x0, y0, x1, y1 = g.bounds
                with self.subTest(master=n, style=style):
                    self.assertLess(g.symmetric_difference(mirrored(g, n)).area, .02)
                    self.assertFalse(g.contains(Point(n / 2, y0 + .05)), 'The lobes meet in a notch')
                    bottom = g.intersection(box(0, y1 - .2, n, y1)).bounds
                    self.assertLess(bottom[2] - bottom[0], 1, 'It ends in one point')
                    self.assertLess(overlap(g, geometry('star', style, n)), .75)

    def test_cursor_keeps_its_crisp_edges_and_tail(self):
        for n in MASTERS:
            outline, filled = geometry('cursor', 'outline', n), geometry('cursor', 'filled', n)
            coords = list(parts(filled)[0].exterior.coords)
            directions = {round(math.degrees(math.atan2(by - ay, bx - ax)) % 180, 3) for (ax, ay), (bx, by) in zip(coords, coords[1:])}
            with self.subTest(master=n):
                self.assertIn(90.0, directions, 'A true vertical edge')
                self.assertIn(45.0, directions, 'A true 45° leading edge')
                self.assertEqual(len(holes(outline)), 1, 'The head is open in Outline; the tail stays solid')
                self.assertEqual(holes(filled), [])
                self.assertLess(overlap(filled, geometry('arrow-up-right', 'filled', n)), .3)
                # A real tail: painted ink reaches the bottom beyond the left wing.
                self.assertGreater(filled.intersection(box(0, filled.bounds[3] - .25, n, filled.bounds[3])).bounds[0], filled.bounds[0] + n / 8)

    def test_wand_has_a_rising_rod_a_separate_spark_and_sized_accents(self):
        for n, accents in ((12, 0), (16, 1), (24, 2)):
            for style in STYLES:
                pieces = parts(geometry('wand', style, n))
                rod = next(p for p in pieces if p.centroid.x < n / 2 and p.centroid.y > n / 2)
                others = [p for p in pieces if p is not rod]
                spark = max(others, key=lambda p: p.area)
                with self.subTest(master=n, style=style):
                    self.assertEqual(len(pieces), 2 + accents)
                    self.assertAlmostEqual(size(rod)[0], size(rod)[1], delta=.02)
                    self.assertGreater(spark.centroid.x, n / 2)
                    self.assertLess(spark.centroid.y, n / 2)
                    self.assertGreaterEqual(rod.distance(spark), GAP[n] - .002)
                    # Plus in Outline; a concave sparkle in Filled, so it cannot read as a hammer.
                    self.assertLess(spark.area / spark.convex_hull.area, .75)


if __name__ == '__main__':
    unittest.main(verbosity=2)
