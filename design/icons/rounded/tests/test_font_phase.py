"""Every master must survive the font compiler's rounding at native size.

remix_ui_icons compiles each drawing to whole font units and compares the result with the source SVG
through CairoSVG. Rounding to the same grid here reproduces that comparison without a font toolchain:
it gave the same numbers as the compiled font for both masters that failed the gate. The limits are
the gate's own, from packages/remix_ui_icons/tool/icons/raster.py.
"""
from __future__ import annotations

import io
import re
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

import cairosvg
from PIL import Image, ImageChops
from shapely.geometry import MultiPolygon

from source.draw import draw
from source.seams import (
    APPEARANCES, CANONICAL_IDS, FONT_EXACT_GRID, FONT_EXACT_MASTERS, FONT_UNITS_PER_EM, MASTERS,
)
from tests.probes import min_convex_radius, product

MEAN_LIMIT = 0.5
PEAK_LIMIT = {1: 8, 8: 32}
COORDINATE = re.compile(r'(-?[\d.]+) (-?[\d.]+)')
BEFORE = ROOT / 'tests' / 'fixtures' / 'font-phase-before'


def path_of(text):
    return re.search(r' d="([^"]+)"', text)[1]


def alpha(d, n, scale):
    svg = (f'<svg xmlns="http://www.w3.org/2000/svg" width="{n}" height="{n}" viewBox="0 0 {n} {n}" '
           f'fill="#000" fill-rule="evenodd"><path d="{d}"/></svg>')
    png = cairosvg.svg2png(bytestring=svg.encode(), output_width=n * scale, output_height=n * scale)
    return Image.open(io.BytesIO(png)).convert('RGBA').getchannel('A')


def to_font_units(d, n):
    units = FONT_UNITS_PER_EM / n
    return COORDINATE.sub(lambda m: f'{round(float(m[1]) * units) / units:.9f} {round(float(m[2]) * units) / units:.9f}', d)


def rounding_delta(d, n, scale):
    """(mean, peak) alpha change at this scale when a path is rounded to whole font units."""
    delta = ImageChops.difference(alpha(d, n, scale), alpha(to_font_units(d, n), n, scale))
    return sum(delta.tobytes()) / (n * n * scale * scale), delta.getextrema()[1]


def svg_path(icon, n, appearance):
    return ROOT / 'generated' / 'rounded' / appearance / str(n) / f'{icon}.svg'


class FontPhaseTests(unittest.TestCase):
    def test_every_master_survives_font_unit_rounding(self):
        for icon in CANONICAL_IDS:
            for n in MASTERS:
                for appearance in APPEARANCES:
                    d = path_of(svg_path(icon, n, appearance).read_text())
                    for scale, peak_limit in PEAK_LIMIT.items():
                        with self.subTest(icon=icon, master=n, appearance=appearance, scale=scale):
                            mean, peak = rounding_delta(d, n, scale)
                            self.assertLessEqual(mean, MEAN_LIMIT)
                            self.assertLessEqual(peak, peak_limit)

    def test_the_probe_rejects_the_masters_that_failed_the_font_gate(self):
        for name, n, peak in (('play-outline-16', 16, 17), ('box-outline-16', 16, 11)):
            with self.subTest(master=name):
                d = path_of((BEFORE / f'{name}.svg').read_text())
                self.assertEqual(rounding_delta(d, n, 1)[1], peak)
                self.assertGreater(peak, PEAK_LIMIT[1])

    def test_exact_masters_have_nothing_left_to_round(self):
        self.assertEqual(FONT_EXACT_MASTERS, {('play', 16, 'outline'), ('box', 16, 'outline')})
        for icon, n, appearance in FONT_EXACT_MASTERS:
            with self.subTest(icon=icon):
                d = path_of(svg_path(icon, n, appearance).read_text())
                for value in (float(v) for pair in COORDINATE.findall(d) for v in pair):
                    self.assertAlmostEqual(value / FONT_EXACT_GRID, round(value / FONT_EXACT_GRID), delta=1e-6)
                units = FONT_UNITS_PER_EM / n
                self.assertEqual(FONT_EXACT_GRID * units, round(FONT_EXACT_GRID * units))
                self.assertEqual(rounding_delta(d, n, 1), (0, 0))
                self.assertEqual(rounding_delta(d, n, 8), (0, 0))

    def test_the_grid_is_exact_at_every_master(self):
        for n in MASTERS:
            units = FONT_EXACT_GRID * FONT_UNITS_PER_EM / n
            self.assertEqual(units, round(units), n)
        self.assertEqual(round(FONT_EXACT_GRID, 4), FONT_EXACT_GRID)

    def test_snapping_keeps_the_drawing(self):
        # Same topology and bounds as the pre-fix master, and the corners are still round.
        for name, icon in (('play-outline-16', 'play'), ('box-outline-16', 'box')):
            with self.subTest(icon=icon):
                from source.validate import parse_svg
                before = parse_svg((BEFORE / f'{name}.svg').read_text())[2]
                after = product(icon, 16, 'outline')
                count = lambda g: len(g.geoms) if isinstance(g, MultiPolygon) else 1
                holes = lambda g: sum(len(p.interiors) for p in (g.geoms if isinstance(g, MultiPolygon) else [g]))
                self.assertEqual(count(after), count(before))
                self.assertEqual(holes(after), holes(before))
                self.assertLess(after.symmetric_difference(before).area, 0.01 * before.area)
                self.assertLessEqual(max(abs(a - b) for a, b in zip(after.bounds, before.bounds)), FONT_EXACT_GRID)
                self.assertGreater(min_convex_radius(after), 0.4)
                self.assertEqual(draw(icon, 16, 'outline').is_valid, True)


class GeneratedFileTests(unittest.TestCase):
    def test_inventory_csv_uses_unix_line_endings(self):
        data = (ROOT / 'generated' / 'inventory.csv').read_bytes()
        self.assertNotIn(b'\r', data)
        self.assertEqual(data.count(b'\n'), 1 + 6 * len(CANONICAL_IDS))


if __name__ == '__main__':
    unittest.main(verbosity=2)
