#!/usr/bin/env python3
"""Render native 12/16/24 raster proofs for the Soft pilot."""
from __future__ import annotations

import io
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont
import cairosvg

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from source.seams import CANONICAL_IDS, LABELS

FONT = '/usr/share/fonts/liberation-sans/LiberationSans-Regular.ttf'
INK = '#1b1612'
PAPER = '#f6f1ea'


def _svg_png(path: Path, color: str, scale: int) -> Image.Image:
    txt = path.read_text().replace('currentColor', color)
    n = int(path.parent.name)
    b = cairosvg.svg2png(bytestring=txt.encode(), output_width=n * scale, output_height=n * scale)
    return Image.open(io.BytesIO(b)).convert('RGBA')


def sheet(out: Path, dark: bool = False) -> None:
    bg = '#14110f' if dark else PAPER
    ink = '#f6f1ea' if dark else INK
    names = list(CANONICAL_IDS)
    W, row_h = 1280, 118
    H = 92 + len(names) * row_h
    im = Image.new('RGB', (W, H), bg)
    d = ImageDraw.Draw(im)
    font = ImageFont.truetype(FONT, 20)
    small = ImageFont.truetype(FONT, 13)
    d.text((24, 18), 'SOFT / NATIVE OPTICAL DRAWINGS', font=font, fill=ink)
    for col, n in enumerate([12, 16, 24]):
        d.text((250 + col * 320, 54), f'{n} px / outline + filled / 4× + native', font=small, fill=ink)
    for row, name in enumerate(names):
        y = 88 + row * row_h
        d.line((24, y, W - 24, y), fill='#8a7f74', width=1)
        d.text((24, y + 40), LABELS[name], font=ImageFont.truetype(FONT, 16), fill=ink)
        for col, n in enumerate([12, 16, 24]):
            for j, appearance in enumerate(['outline', 'filled']):
                svg = ROOT / 'generated' / 'soft' / appearance / str(n) / f'{name}.svg'
                big = _svg_png(svg, ink, 4)
                native = _svg_png(svg, ink, 1)
                x = 250 + col * 320 + j * 140
                im.paste(big, (x, y + (row_h - n * 4) // 2), big)
                im.paste(native, (x + 110, y + 58), native)
    out.parent.mkdir(parents=True, exist_ok=True)
    im.save(out)


def compare_sheet(out: Path, master: int = 24) -> None:
    angular = ROOT.parents[2] / 'design' / 'icons' / 'angular' / 'generated' / 'angular'
    names = list(CANONICAL_IDS)
    scale = 4 if master == 24 else 6
    cell = master * scale
    W, row_h = 1100, max(110, cell + 16)
    H = 80 + len(names) * row_h
    im = Image.new('RGB', (W, H), PAPER)
    d = ImageDraw.Draw(im)
    font = ImageFont.truetype(FONT, 18)
    small = ImageFont.truetype(FONT, 12)
    d.text((24, 18), f'ANGULAR {master} vs SOFT {master}  (Angular is read-only)', font=font, fill=INK)
    for i, cap in enumerate(['Angular outline', 'Soft outline', 'Angular filled', 'Soft filled']):
        d.text((260 + i * 200, 48), cap, font=small, fill=INK)
    for row, name in enumerate(names):
        y = 72 + row * row_h
        d.text((24, y + 40), LABELS[name], font=ImageFont.truetype(FONT, 15), fill=INK)
        specs = [
            (angular / 'outline' / str(master) / f'{name}.svg', INK),
            (ROOT / 'generated' / 'soft' / 'outline' / str(master) / f'{name}.svg', INK),
            (angular / 'filled' / str(master) / f'{name}.svg', INK),
            (ROOT / 'generated' / 'soft' / 'filled' / str(master) / f'{name}.svg', INK),
        ]
        for i, (path, color) in enumerate(specs):
            pic = _svg_png(path, color, scale)
            im.paste(pic, (260 + i * 200, y + (row_h - cell) // 2), pic)
    out.parent.mkdir(parents=True, exist_ok=True)
    im.save(out)


if __name__ == '__main__':
    sheet(ROOT / 'docs' / 'proof' / 'soft-native.png')
    sheet(ROOT / 'docs' / 'proof' / 'soft-native-dark.png', dark=True)
    compare_sheet(ROOT / 'docs' / 'proof' / 'angular-vs-soft-24.png', 24)
    compare_sheet(ROOT / 'docs' / 'proof' / 'angular-vs-soft-12.png', 12)
    print('Wrote native and comparison raster proofs')
