"""The Flutter reference must stay independent of the compiled font and cmap."""
from __future__ import annotations

import io
import json
import tempfile
import unittest
from pathlib import Path

import cairosvg
from fontTools.ttLib import TTFont
from PIL import Image, ImageChops, ImageStat

from manifest import load_manifest
from raster import glyph_svg
from reference import REFERENCE_EM, write_reference
from sources import Source


class ReferenceTest(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.directory = Path(self.temporary.name)
        # The test needs no generated font or codepoint lock.
        glyph = load_manifest().glyphs[0]
        self.source = Source(glyph, Path(glyph.source), (
            '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" '
            'viewBox="0 0 24 24" fill="currentColor" fill-rule="evenodd">'
            '<path d="M2 2L22 2L22 22L2 22ZM8 8L8 16L16 16L16 8Z"/>'
            '</svg>'
        ).encode())

    def build(self):
        write_reference([self.source], self.directory)
        return json.loads((self.directory / 'source-reference.json').read_text())

    def test_maps_source_identity_to_an_independent_codepoint(self):
        metadata = self.build()
        font = TTFont(self.directory / 'source-reference.otf')
        self.assertEqual(metadata['codepoints'], {self.source.glyph.source: 0xE000})
        self.assertEqual(set(font.getBestCmap()), {0xE000})
        self.assertEqual(font['head'].unitsPerEm, REFERENCE_EM)

    def test_contours_preserve_the_svg_and_its_counter(self):
        metadata = self.build()
        font = TTFont(self.directory / 'source-reference.otf')
        rendered = glyph_svg(font, metadata['codepoints'][self.source.glyph.source], 24)
        def alpha(data):
            return Image.open(io.BytesIO(cairosvg.svg2png(
                bytestring=data, output_width=96, output_height=96,
            ))).getchannel('A')
        expected, actual = alpha(self.source.data), alpha(rendered)
        self.assertEqual(actual.getpixel((48, 48)), 0)
        self.assertEqual(actual.getpixel((16, 16)), 255)
        self.assertLess(ImageStat.Stat(ImageChops.difference(actual, expected)).mean[0], .1)

    def test_canvas_includes_the_baseline_even_for_positive_ink_bounds(self):
        self.build()
        font = TTFont(self.directory / 'source-reference.otf')
        self.assertEqual(font['CFF '].cff.topDictIndex[0].FontBBox, [0, 0, REFERENCE_EM, REFERENCE_EM])
        self.assertEqual(font['hhea'].descent, 0)
        self.assertEqual(font['hhea'].ascent, REFERENCE_EM)

    def test_build_is_reproducible(self):
        self.build()
        first = (self.directory / 'source-reference.otf').read_bytes()
        self.build()
        self.assertEqual((self.directory / 'source-reference.otf').read_bytes(), first)

    def test_reference_tracks_source_changes_without_compiled_artifacts(self):
        before = self.build()
        first = (self.directory / 'source-reference.otf').read_bytes()
        self.source = Source(self.source.glyph, self.source.path,
                             self.source.data.replace(b'L22 2', b'L18 2'))
        after = self.build()
        self.assertNotEqual(first, (self.directory / 'source-reference.otf').read_bytes())
        self.assertNotEqual(before['family'], after['family'])

    def test_duplicate_and_empty_source_sets_fail(self):
        with self.assertRaisesRegex(ValueError, 'distinct source'):
            write_reference([], self.directory)
        with self.assertRaisesRegex(ValueError, 'unique'):
            write_reference([self.source, self.source], self.directory)
