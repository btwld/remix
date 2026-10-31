"""Compare every font glyph with the SVG it was compiled from.

Both sides go through the same rasterizer (CairoSVG): the source SVG as drawn,
and the glyph's CFF outline read back out of RemixIcons.otf and placed in the
master's viewBox. A glyph that is missing, mapped to the wrong codepoint,
shifted, mirrored, or simplified differently from its drawing fails here.

Each glyph is checked at its native master size, where the pack reviews its
pixels, and at 8x, where sub-pixel geometry differences become visible.
Outline glyphs are also checked against the pack's 288 reviewed native-pixel
snapshots, so this compares with the reviewed drawings, not only with
whatever the SVG says today.
"""

from __future__ import annotations

import io
from dataclasses import dataclass
from pathlib import Path

import cairosvg
from fontTools.pens.svgPathPen import SVGPathPen
from fontTools.ttLib import TTFont
from PIL import Image, ImageChops, ImageStat

from manifest import Glyph, Manifest
from sources import Source

# Native size uses the pack's own pixel-regression tolerance (design/icons/
# outline/tests/visual/pixel_regression.py), on alpha values in 0-255. At 8x
# the mean bound is the same, and a single magnified pixel may differ by up to
# 32/255: an edge displaced by 1/8 of a magnified pixel, or 1/64 of a native
# one. Font units are integers (1/640 px at the 24 px master, 1/1280 px at
# 12 px), which leaves residual edge differences of up to 18/255 at 8x.
MEAN_ALPHA_DELTA = 0.5
MAX_ALPHA_DELTA = {1: 8, 8: 32}
SCALES = (1, 8)


@dataclass(frozen=True)
class Comparison:
    glyph: Glyph
    scale: int
    reference: str
    mean: float
    maximum: int

    @property
    def passed(self) -> bool:
        return self.mean <= MEAN_ALPHA_DELTA and self.maximum <= MAX_ALPHA_DELTA[self.scale]

    def describe(self) -> str:
        return (
            f"{self.glyph.family.class_name}.{self.glyph.member} at "
            f"{self.glyph.master * self.scale} px vs {self.reference}: mean alpha delta "
            f"{self.mean:.3f} (max {MEAN_ALPHA_DELTA}), peak {self.maximum} "
            f"(max {MAX_ALPHA_DELTA[self.scale]})"
        )


def _alpha(svg: bytes, size: int) -> Image.Image:
    png = cairosvg.svg2png(bytestring=svg, output_width=size, output_height=size)
    return Image.open(io.BytesIO(png)).convert("RGBA").getchannel("A")


def glyph_svg(font: TTFont, codepoint: int, master: int) -> bytes:
    """The glyph's outline as an SVG in the master's coordinate space."""

    name = font.getBestCmap().get(codepoint)
    if name is None:
        raise KeyError(f"RemixIcons.otf has no glyph for 0x{codepoint:04X}")
    glyph_set = font.getGlyphSet()
    pen = SVGPathPen(glyph_set)
    glyph_set[name].draw(pen)
    units = font["head"].unitsPerEm
    ascent = font["hhea"].ascent
    scale = master / units
    return (
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{master}" height="{master}" '
        f'viewBox="0 0 {master} {master}">'
        f'<path transform="matrix({scale} 0 0 {-scale} 0 {ascent * scale})" '
        f'fill="#000" d="{pen.getCommands()}"/></svg>'
    ).encode("utf-8")


def _compare(glyph: Glyph, scale: int, reference: str, expected: Image.Image, actual: Image.Image) -> Comparison:
    if expected.size != actual.size:
        return Comparison(glyph, scale, reference, float("inf"), 255)
    delta = ImageChops.difference(expected, actual)
    return Comparison(
        glyph,
        scale,
        reference,
        ImageStat.Stat(delta).mean[0],
        delta.getextrema()[1],
    )


def compare_all(
    manifest: Manifest,
    sources: list[Source],
    font_bytes: bytes,
    codepoints: dict[str, int],
) -> list[Comparison]:
    font = TTFont(io.BytesIO(font_bytes))
    snapshots = manifest.source_root / "outline" / "tests" / "fixtures" / "native-pixels"
    results = []
    for source in sources:
        glyph = source.glyph
        rendered = glyph_svg(font, codepoints[glyph.source], glyph.master)
        for scale in SCALES:
            size = glyph.master * scale
            results.append(
                _compare(glyph, scale, "source SVG", _alpha(source.data, size), _alpha(rendered, size))
            )
        if glyph.family.key == "outline":
            snapshot = snapshots / f"{glyph.concept.id}-{glyph.style}-{glyph.master}.png"
            reference = f"reviewed snapshot {snapshot.name}"
            if not snapshot.is_file():
                results.append(Comparison(glyph, 1, reference, float("inf"), 255))
                continue
            expected = Image.open(snapshot).convert("RGBA").getchannel("A")
            results.append(_compare(glyph, 1, reference, expected, _alpha(rendered, glyph.master)))
    return results


def write_rasters(sources: list[Source], directory: Path, scale: int) -> None:
    """Write each source SVG as a PNG for the Flutter rendering test."""

    for source in sources:
        target = directory / source.glyph.source.removesuffix(".svg")
        target = target.with_name(target.name + ".png")
        target.parent.mkdir(parents=True, exist_ok=True)
        size = source.glyph.master * scale
        target.write_bytes(
            cairosvg.svg2png(bytestring=source.data, output_width=size, output_height=size)
        )
