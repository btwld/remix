"""Build a test-only reference font directly from the authored SVGs.

This does not read the compiled font, its codepoint lock, or GlyphPact output.
The independent cmap lets Flutter compare source and compiled contours through
the same platform text rasterizer. Cairo still checks compiled outline geometry
and reviewed snapshots separately.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

from fontTools.fontBuilder import FontBuilder
from fontTools.misc.roundTools import otRound
from fontTools.pens.boundsPen import BoundsPen
from fontTools.pens.t2CharStringPen import T2CharStringPen
from fontTools.pens.transformPen import TransformPen
from fontTools.svgLib.path import parse_path

from sources import Source

REFERENCE_EM = 15360


def write_reference(sources: list[Source], directory: Path) -> None:
    """Write an independent reference cmap and font beside the Cairo rasters."""
    if not sources or len(sources) > 0xF8FF - 0xE000 + 1:
        raise ValueError("Reference font needs 1–6400 distinct source drawings")
    if len({source.glyph.source for source in sources}) != len(sources):
        raise ValueError("Reference font source identities must be unique")
    digest = hashlib.sha256()
    for source in sources:
        digest.update(source.glyph.source.encode())
        digest.update(source.data)
    family = "RemixSourceReference" + digest.hexdigest()[:16]
    order = [".notdef"]
    charstrings = {".notdef": T2CharStringPen(REFERENCE_EM, None).getCharString()}
    metrics = {".notdef": (REFERENCE_EM, 0)}
    cmap = {}
    mapping = {}
    for index, source in enumerate(sources):
        name = f"source{index}"
        order.append(name)
        codepoint = 0xE000 + index
        cmap[codepoint] = name
        mapping[source.glyph.source] = codepoint
        scale = REFERENCE_EM / source.glyph.master
        transform = (scale, 0, 0, -scale, 0, REFERENCE_EM)
        pen = T2CharStringPen(REFERENCE_EM, None)
        parse_path(source.path_data, TransformPen(pen, transform))
        charstrings[name] = pen.getCharString()
        bounds = BoundsPen(None)
        parse_path(source.path_data, TransformPen(bounds, transform))
        if bounds.bounds is None:
            raise ValueError(f"Empty reference drawing: {source.glyph.source}")
        metrics[name] = (REFERENCE_EM, otRound(bounds.bounds[0]))

    builder = FontBuilder(REFERENCE_EM, isTTF=False)
    builder.setupGlyphOrder(order)
    builder.setupCharacterMap(cmap)
    builder.setupHorizontalMetrics(metrics)
    builder.setupHorizontalHeader(ascent=REFERENCE_EM, descent=0)
    builder.setupNameTable({
        "familyName": family,
        "styleName": "Regular",
        "uniqueFontIdentifier": family,
        "fullName": family + " Regular",
        "psName": family + "-Regular",
    })
    builder.setupOS2(
        sTypoAscender=REFERENCE_EM, sTypoDescender=0,
        usWinAscent=REFERENCE_EM, usWinDescent=0, usWeightClass=400,
        fsType=0, fsSelection=64, sCapHeight=REFERENCE_EM,
    )
    builder.setupPost()
    builder.setupCFF(
        family + "-Regular",
        {"FullName": family + " Regular", "FamilyName": family, "Weight": "Regular"},
        charstrings, {},
    )
    # An icon occupies the full em canvas, with its baseline at the bottom.
    # A tight positive-y ink bbox makes CoreText synthesize a descent, shifting
    # every reference glyph. Include the canvas origin rather than ink alone.
    builder.font.recalcBBoxes = False
    builder.font["CFF "].cff.topDictIndex[0].FontBBox = [0, 0, REFERENCE_EM, REFERENCE_EM]
    head = builder.font["head"]
    head.xMin = head.yMin = 0
    head.xMax = head.yMax = REFERENCE_EM
    head.created = head.modified = 2082844800  # 1970-01-01 in OpenType time.
    builder.font.recalcTimestamp = False
    directory.mkdir(parents=True, exist_ok=True)
    builder.save(directory / "source-reference.otf")
    (directory / "source-reference.json").write_text(
        json.dumps({"family": family, "codepoints": mapping}, sort_keys=True) + "\n",
        encoding="utf-8",
    )
