#!/usr/bin/env python3
"""Render native 12/16/24 raster proofs for Rounded, at 4x, 2x, and 1x, on light and dark."""
from __future__ import annotations

import io
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont
import cairosvg

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from source.seams import APPEARANCES, CANONICAL_IDS, LABELS, MASTERS

FONT = next(
    path for path in (
        '/usr/share/fonts/liberation-sans/LiberationSans-Regular.ttf',
        '/System/Library/Fonts/Supplemental/Arial.ttf',
    ) if Path(path).exists()
)
INK = '#1b1612'
PAPER = '#f6f1ea'
SCALES = (4, 2, 1)


def _svg_png(path: Path, color: str, scale: int) -> Image.Image:
    txt = path.read_text().replace('currentColor', color)
    n = int(path.parent.name)
    b = cairosvg.svg2png(bytestring=txt.encode(), output_width=n * scale, output_height=n * scale)
    return Image.open(io.BytesIO(b)).convert('RGBA')


def sheet(out: Path, names=CANONICAL_IDS, dark: bool = False) -> None:
    """One row per concept: each master and style at 4x, 2x, and 1x."""
    bg = '#14110f' if dark else PAPER
    ink = '#f6f1ea' if dark else INK
    rule = '#4d453e' if dark else '#8a7f74'
    columns = {12: 128, 16: 164, 24: 220}
    W, row_h = 170 + 2 * sum(columns.values()) + 20, 118
    H = 92 + len(names) * row_h
    im = Image.new('RGB', (W, H), bg)
    d = ImageDraw.Draw(im)
    font = ImageFont.truetype(FONT, 20)
    small = ImageFont.truetype(FONT, 13)
    label = ImageFont.truetype(FONT, 16)
    d.text((24, 18), 'ROUNDED / NATIVE OPTICAL DRAWINGS', font=font, fill=ink)
    x = 170
    for n in MASTERS:
        d.text((x, 54), f'{n} px / outline, filled / 4x, 2x, 1x', font=small, fill=ink)
        x += 2 * columns[n]
    for row, name in enumerate(names):
        y = 88 + row * row_h
        d.line((24, y, W - 24, y), fill=rule, width=1)
        d.text((24, y + 40), LABELS[name], font=label, fill=ink)
        x = 170
        for n in MASTERS:
            for appearance in APPEARANCES:
                svg = ROOT / 'generated' / 'rounded' / appearance / str(n) / f'{name}.svg'
                cursor = x
                for scale in SCALES:
                    pic = _svg_png(svg, ink, scale)
                    im.paste(pic, (cursor, y + (row_h - n * scale) // 2), pic)
                    cursor += n * scale + 6
                x += columns[n]
    out.parent.mkdir(parents=True, exist_ok=True)
    im.save(out)


def compare_sheet(out: Path, master: int = 24) -> None:
    """Family comparison, for the concepts that Outline has drawn in this checkout."""
    outline = ROOT.parents[2] / 'design' / 'icons' / 'outline' / 'generated' / 'outline'
    names = [n for n in CANONICAL_IDS if (outline / 'outline' / str(master) / f'{n}.svg').is_file()]
    scale = 4 if master == 24 else 6
    cell = master * scale
    W, row_h = 1100, max(110, cell + 16)
    H = 80 + len(names) * row_h
    im = Image.new('RGB', (W, H), PAPER)
    d = ImageDraw.Draw(im)
    font = ImageFont.truetype(FONT, 18)
    small = ImageFont.truetype(FONT, 12)
    d.text((24, 18), f'OUTLINE {master} vs ROUNDED {master}  (Outline is read-only)', font=font, fill=INK)
    for i, cap in enumerate(['Outline outline', 'Rounded outline', 'Outline filled', 'Rounded filled']):
        d.text((260 + i * 200, 48), cap, font=small, fill=INK)
    for row, name in enumerate(names):
        y = 72 + row * row_h
        d.text((24, y + 40), LABELS[name], font=ImageFont.truetype(FONT, 15), fill=INK)
        specs = [
            (outline / 'outline' / str(master) / f'{name}.svg', INK),
            (ROOT / 'generated' / 'rounded' / 'outline' / str(master) / f'{name}.svg', INK),
            (outline / 'filled' / str(master) / f'{name}.svg', INK),
            (ROOT / 'generated' / 'rounded' / 'filled' / str(master) / f'{name}.svg', INK),
        ]
        for i, (path, color) in enumerate(specs):
            pic = _svg_png(path, color, scale)
            im.paste(pic, (260 + i * 200, y + (row_h - cell) // 2), pic)
    out.parent.mkdir(parents=True, exist_ok=True)
    im.save(out)


if __name__ == '__main__':
    sheet(ROOT / 'docs' / 'proof' / 'rounded-native.png')
    sheet(ROOT / 'docs' / 'proof' / 'rounded-native-dark.png', dark=True)
    compare_sheet(ROOT / 'docs' / 'proof' / 'outline-vs-rounded-24.png', 24)
    compare_sheet(ROOT / 'docs' / 'proof' / 'outline-vs-rounded-12.png', 12)
    print('Wrote native and comparison raster proofs')
