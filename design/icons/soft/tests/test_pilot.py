"""Seam tests for the Soft 12-icon calibration pilot."""
from __future__ import annotations

import hashlib
import io
import json
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from source.draw import draw
from source.lookup import icon_svg, icon_svg_for_display, select_master
from source.seams import (
    APPEARANCES, CANONICAL_IDS, CORNER_TOKEN, CrossPackFallbackError, MASTERS,
    MASTER_SELECTION, PAIR_MODEL, PRODUCT_PATH_COMMANDS, STAR_JOIN,
    UnknownAppearanceError, UnknownIconError, UnknownMasterError,
)
from source.validate import parse_path, parse_svg

try:
    import jsonschema
    from PIL import Image
    import cairosvg
except ImportError as exc:  # pragma: no cover
    raise SystemExit('Install pilot requirements first') from exc

REPO = ROOT.parents[2]
ANGULAR = REPO / 'design' / 'icons' / 'angular'


class ContractTests(unittest.TestCase):
    def test_schema_and_matrix(self):
        cat = json.loads((ROOT / 'catalog' / 'icons.json').read_text())
        jsonschema.validate(cat, json.loads((ROOT / 'catalog' / 'schemas' / 'catalog.schema.json').read_text()))
        ids = [m['id'] for m in cat['icons']]
        self.assertEqual(ids, list(CANONICAL_IDS))
        self.assertEqual(cat['counts'], {'icons': 12, 'drawings': 72})
        self.assertFalse(cat['public'])
        self.assertEqual(cat['pack'], 'soft')
        for meta in cat['icons']:
            self.assertEqual(meta['pairModel'], PAIR_MODEL[meta['id']])
            self.assertEqual(
                meta['availability'],
                {'soft': {'appearances': ['outline', 'filled'], 'opticalSizes': [12, 16, 24]}},
            )

    def test_72_svgs_and_inventory(self):
        inv = json.loads((ROOT / 'generated' / 'inventory.json').read_text())
        files = {str(p.relative_to(ROOT / 'generated')) for p in (ROOT / 'generated' / 'soft').rglob('*.svg')}
        self.assertEqual(len(inv), 72)
        self.assertEqual(len(files), 72)
        self.assertEqual({r['path'] for r in inv}, files)
        expected = {f'soft/{a}/{n}/{i}.svg' for i in CANONICAL_IDS for a in APPEARANCES for n in MASTERS}
        self.assertEqual(files, expected)

    def test_no_silent_fallback(self):
        icon_svg('home', appearance='outline', master=24)
        with self.assertRaises(UnknownIconError):
            icon_svg('gear', appearance='outline', master=24)
        with self.assertRaises(UnknownAppearanceError):
            icon_svg('home', appearance='solid', master=24)
        with self.assertRaises(UnknownMasterError):
            icon_svg('home', appearance='outline', master=18)
        with self.assertRaises(UnknownMasterError):
            select_master(13)
        with self.assertRaises(UnknownMasterError):
            select_master(11)
        with self.assertRaises(CrossPackFallbackError):
            icon_svg('home', appearance='outline', master=24, pack='angular')
        with self.assertRaises(CrossPackFallbackError):
            icon_svg_for_display('home', appearance='outline', size=16, pack='rounded')
        for size, master in MASTER_SELECTION.items():
            self.assertEqual(select_master(size), master)

    def test_warning_visible_label_is_concept_level(self):
        rec = json.loads((ROOT / 'catalog' / 'restrictions.json').read_text())['records'][0]
        self.assertEqual(rec['icon'], 'warning')
        self.assertEqual(rec['pack'], 'soft')
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

    def test_soft_paths_are_not_angular_copies(self):
        ang_reg = json.loads((ANGULAR / 'generated' / 'registry.json').read_text())['paths']
        soft_reg = json.loads((ROOT / 'generated' / 'registry.json').read_text())['paths']
        for icon_id in CANONICAL_IDS:
            for a in APPEARANCES:
                for n in MASTERS:
                    self.assertNotEqual(
                        soft_reg[icon_id][a][str(n)],
                        ang_reg[icon_id][a][str(n)],
                        f'{icon_id}/{a}/{n} matched Angular path data',
                    )

    def test_draw_source_does_not_import_angular(self):
        src = (ROOT / 'source' / 'draw.py').read_text()
        self.assertNotIn('design/icons/angular', src)
        self.assertNotIn('baseline.draw', src)
        self.assertNotIn('angular.baseline', src)

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
        for icon_id in ('search', 'link'):
            for n in MASTERS:
                outline = draw(icon_id, n, 'outline')
                filled = draw(icon_id, n, 'filled')
                self.assertGreater(filled.area, outline.area)
                for g in (outline, filled):
                    holes = []
                    for p in (list(g.geoms) if g.geom_type == 'MultiPolygon' else [g]):
                        holes.extend(p.interiors)
                    self.assertTrue(holes, f'{icon_id} lost its open counters at {n}')

    def test_corner_token_is_wired_into_drawers(self):
        src = (ROOT / 'source' / 'draw.py').read_text()
        self.assertIn('CORNER_TOKEN', src)
        self.assertIn('ACUTE_JOIN', src)
        self.assertIn('STAR_JOIN', src)
        self.assertEqual(CORNER_TOKEN, {12: 1.6, 16: 2.4, 24: 3.4})
        self.assertEqual(STAR_JOIN, {12: 0.65, 16: 0.85, 24: 1.0})

    def test_star_mass_is_not_thirty_percent_light(self):
        ang = parse_svg((ANGULAR / 'generated' / 'angular' / 'filled' / '24' / 'star.svg').read_text())[2]
        soft = draw('star', 24, 'filled')
        self.assertGreater(soft.area / (24 * 24), 0.24)
        self.assertGreater(soft.area / ang.area, 0.85)

    def test_products_export_mlz_only(self):
        styles = json.loads((ROOT / 'catalog' / 'styles.json').read_text())
        self.assertEqual(styles['soft']['productPathCommands'], list(PRODUCT_PATH_COMMANDS))
        for svg in (ROOT / 'generated' / 'soft').rglob('*.svg'):
            text = svg.read_text()
            d = text.split(' d="', 1)[1].split('"', 1)[0]
            self.assertRegex(d, r'^[MLZ0-9.\-\s]+$', msg=str(svg))
            self.assertNotRegex(d, r'[CQA]')


def box_x(x0, x1, n):
    from shapely.geometry import box
    return box(x0, 0, x1, n)


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
        # fail closed by ignoring A/C/Q the way Angular's parser would.
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

    def test_parser_rejects_unsafe_and_angular_only_is_not_required(self):
        for d in ['M0 0H10Z', 'M0 0V10Z', 'M0 0LNaN 2Z', 'M0 0L1 1', 'M0 0L0 0L0 0Z', 'M0 0L1 1Z<script>']:
            with self.subTest(d=d), self.assertRaises(ValueError):
                parse_path(d)
        base = (ROOT / 'generated' / 'soft' / 'outline' / '24' / 'home.svg').read_text()
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
    def test_angular_svg_hashes_unchanged(self):
        frozen = json.loads((ANGULAR / 'generated-sha256.json').read_text())
        checked = 0
        for rel, expected in frozen.items():
            if not rel.startswith('generated/angular/') or not rel.endswith('.svg'):
                continue
            actual = hashlib.sha256((ANGULAR / rel).read_bytes()).hexdigest()
            self.assertEqual(actual, expected, rel)
            checked += 1
        self.assertEqual(checked, 288)

    def test_rebuild_is_deterministic(self):
        first = json.loads((ROOT / 'generated' / 'sha256.json').read_text())
        from source.build import build
        build()
        second = json.loads((ROOT / 'generated' / 'sha256.json').read_text())
        self.assertEqual(first, second)


if __name__ == '__main__':
    unittest.main(verbosity=2)
