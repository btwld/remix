"""Build RemixIcons.otf with GlyphPact from the staged masters.

GlyphPact runs in a throwaway directory seeded with the committed lock, so it
compiles exactly the codepoints lock.py assigned. Only its font, lock, and a
summary of its report are kept; its Dart provider is discarded because the
public classes are generated from the manifest instead.
"""

from __future__ import annotations

import json
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path
from typing import Any

from manifest import Manifest
from sources import Source, stage

FONT_FILE = "fonts/RemixIcons.otf"
COPYRIGHT = "Vector UI icons. Copyright (c) 2026, Leo Farias. BSD 3-Clause License."

# GlyphPact rounds outlines to whole font units. We use 15360, a multiple
# of 48 (the least common multiple of the 12, 16, and 24 px masters), so
# one pixel of every master is a whole number of units:
# 640 at 24 px, 960 at 16 px, 1280 at 12 px. At 1000 units the masters drifted
# visibly from their drawings at 8x; see raster.py.
UNITS_PER_EM = 15360
# Keep the masters' own coordinates (up to four decimals) before that rounding.
PRECISION = 6


class FontError(Exception):
    """GlyphPact could not compile the masters losslessly."""


@dataclass(frozen=True)
class FontBuild:
    font: bytes
    lock: dict[str, Any]
    report: dict[str, Any]


def build_font(manifest: Manifest, sources: list[Source], seeded_lock: dict[str, Any]) -> FontBuild:
    with tempfile.TemporaryDirectory(prefix="remix-icons-") as temporary:
        root = Path(temporary)
        input_directory = root / "masters"
        output_directory = root / "out"
        stage(sources, input_directory)
        output_directory.mkdir()
        (output_directory / ".glyphpact.json").write_text(
            json.dumps({"schemaVersion": 1, "owner": "glyphpact"}) + "\n", encoding="utf-8"
        )
        (output_directory / "iconfont.lock.json").write_text(
            json.dumps(seeded_lock, indent=2, ensure_ascii=False) + "\n", encoding="utf-8"
        )
        config = {
            "input": str(input_directory),
            "output": str(output_directory),
            "fontFamily": manifest.font_family,
            "className": "RemixIconsFont",
            "fontPackage": manifest.package,
            "fontFile": FONT_FILE,
            "catalog": False,
            "startCodepoint": f"0x{manifest.start_codepoint:04X}",
            "unitsPerEm": UNITS_PER_EM,
            "padding": 0,
            "precision": PRECISION,
            "clipToViewBox": True,
            # Every master must convert exactly. A lossy or unrepresentable
            # drawing is a design defect to fix at the source, not to flatten.
            "policy": {"lossy": "error", "unrepresentable": "error"},
            "jobs": 1,
            "copyright": COPYRIGHT,
            "icons": {
                source.glyph.source: {
                    "name": source.glyph.lock_name,
                    "matchTextDirection": source.glyph.concept.rtl,
                }
                for source in sources
            },
        }
        config_path = root / "glyphpact.json"
        config_path.write_text(json.dumps(config, indent=2) + "\n", encoding="utf-8")
        result = subprocess.run(
            [sys.executable, "-m", "glyphpact", "--config", str(config_path), "--quiet"],
            capture_output=True,
            text=True,
        )
        if result.returncode != 0:
            raise FontError(
                f"GlyphPact failed with exit code {result.returncode}:\n"
                f"{result.stdout}{result.stderr}"
            )
        report = json.loads((output_directory / "iconfont.report.json").read_text(encoding="utf-8"))
        lock = json.loads((output_directory / "iconfont.lock.json").read_text(encoding="utf-8"))
        font = (output_directory / FONT_FILE).read_bytes()

    expected = len(sources)
    for key, value in (
        ("status", "success"),
        ("quality", "lossless"),
        ("glyphCount", expected),
        ("losslessGlyphCount", expected),
        ("approximatedGlyphCount", 0),
        ("skippedIconCount", 0),
        ("issueCount", 0),
    ):
        if report.get(key) != value:
            raise FontError(f"GlyphPact report {key} is {report.get(key)!r}, expected {value!r}")
    return FontBuild(font=font, lock=lock, report=report)


def report_summary(build: FontBuild) -> dict[str, Any]:
    """The committed record of the build: what compiled, and how exactly."""

    report = build.report
    return {
        "generator": report["generator"],
        "generatorVersion": report["generatorVersion"],
        "status": report["status"],
        "quality": report["quality"],
        "policy": report["policy"],
        "glyphCount": report["glyphCount"],
        "losslessGlyphCount": report["losslessGlyphCount"],
        "approximatedGlyphCount": report["approximatedGlyphCount"],
        "skippedIconCount": report["skippedIconCount"],
        "issueCount": report["issueCount"],
        "retiredCodepointCount": report["retiredCodepointCount"],
        "font": {
            key: report["font"][key]
            for key in ("file", "sha256", "bytes")
            if key in report.get("font", {})
        },
    }
