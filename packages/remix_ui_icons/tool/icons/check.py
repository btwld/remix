#!/usr/bin/env python3
"""Verify remix_ui_icons against its manifest, lock, masters, and last release.

    uv run --frozen --project packages/remix_ui_icons/tool/icons \\
        python packages/remix_ui_icons/tool/icons/check.py \\
        [--base-lock FILE] [--flutter FLUTTER]

1. Every generated artifact is current (`generate.py --check`).
2. The codepoint lock is append-only: codepoints are unique, none is reserved,
   every manifest glyph has one, and, given `--base-lock`, no earlier entry
   was deleted or moved.
3. The generated Dart declares every manifest glyph at its locked codepoint,
   every deprecated alias resolves to a facade member, and the main library
   does not reach the opt-in libraries.
4. Every glyph in RemixIcons.otf matches its SVG master (raster.py).
5. No member of the last released API is removed without a major version.
6. With `--flutter`, every glyph also renders through Flutter to its SVG
   (tool/icons/flutter/glyph_render_test.dart).
"""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

import yaml

import codegen
import generate
import lock
import raster
from manifest import PACKAGE_ROOT, TOOL_ROOT, Manifest, load_manifest
from sources import load_sources

RELEASED_API_PATH = TOOL_ROOT / "released_api.txt"


def _version(text: str) -> tuple[int, int, int]:
    match = re.match(r"(\d+)\.(\d+)\.(\d+)", text)
    if match is None:
        raise ValueError(f"Unparseable version {text!r}")
    major, minor, patch = (int(part) for part in match.groups())
    return major, minor, patch


def is_breaking(previous: str, current: str) -> bool:
    """Whether `current` is a breaking release after `previous`, as pub reads
    caret constraints: a new major, or a new minor while the major is 0."""

    old, new = _version(previous), _version(current)
    if old[0] == 0:
        return new[0] > 0 or new[1] > old[1]
    return new[0] > old[0]


def check_api(manifest: Manifest) -> list[str]:
    lines = RELEASED_API_PATH.read_text(encoding="utf-8").splitlines()
    released_version = next(
        line.removeprefix("version: ") for line in lines if line.startswith("version: ")
    )
    released = {line for line in lines if line and not line.startswith(("#", "version: "))}
    current = set(codegen.public_api(manifest))
    removed = sorted(released - current)
    version = yaml.safe_load((PACKAGE_ROOT / "pubspec.yaml").read_text(encoding="utf-8"))["version"]
    if removed and not is_breaking(released_version, version):
        return [
            f"{len(removed)} members of the released {released_version} API are removed in "
            f"{version}, which is not a major version: {', '.join(removed[:10])}. Keep them "
            "as @Deprecated aliases until the next major."
        ]
    return []


def check_dart(manifest: Manifest, codepoints: dict[str, int]) -> list[str]:
    problems = []
    generated = PACKAGE_ROOT / "lib" / "src" / "generated"
    declaration = re.compile(
        r"static const IconData (\w+) = IconData\(\s*(0x[0-9A-F]+),\s*fontFamily: _fontFamily,"
        r"\s*fontPackage: _fontPackage,(\s*matchTextDirection: true,)?\s*\);"
    )
    for family in manifest.families:
        source = (generated / f"{family.key}_icons.dart").read_text(encoding="utf-8")
        if "@staticIconProvider\nabstract final class " + family.class_name not in source:
            problems.append(f"{family.class_name} must be an @staticIconProvider abstract final class")
        declared = {
            match[1]: (int(match[2], 16), bool(match[3])) for match in declaration.finditer(source)
        }
        glyphs = manifest.glyphs_of(family)
        for glyph in glyphs:
            expected = (codepoints[glyph.source], glyph.concept.rtl)
            if declared.get(glyph.member) != expected:
                problems.append(
                    f"{family.class_name}.{glyph.member} is {declared.get(glyph.member)}, "
                    f"expected codepoint 0x{expected[0]:04X}, matchTextDirection {expected[1]}"
                )
        extra = declared.keys() - {glyph.member for glyph in glyphs}
        if extra:
            problems.append(f"{family.class_name} declares unlisted glyphs {sorted(extra)}")
        if "Map<" in source:
            problems.append(f"{family.class_name} must not build a runtime lookup map")

    facade = (generated / "remix_icons.dart").read_text(encoding="utf-8")
    default = manifest.default_family
    members = dict(re.findall(r"static const IconData (\w+) =\s*(\w+\.\w+);", facade))
    for glyph in manifest.glyphs_of(default):
        if members.get(glyph.member) != f"{default.class_name}.{glyph.member}":
            problems.append(f"RemixIcons.{glyph.member} must be {default.class_name}.{glyph.member}")
    deprecated = {
        alias: target
        for target, alias in re.findall(
            r"@Deprecated\('Use RemixIcons\.(\w+)\. Removed in 2\.0\.0\.'\)\s*"
            r"static const IconData (\w+) =",
            facade,
        )
    }
    for alias in manifest.deprecated_aliases:
        if deprecated.get(alias.name) != alias.target:
            problems.append(f"RemixIcons.{alias.name} must be a @Deprecated alias of {alias.target}")
        if members.get(alias.name) != f"{default.class_name}.{alias.target}":
            problems.append(f"RemixIcons.{alias.name} must resolve to {default.class_name}.{alias.target}")
    expected_members = len(manifest.glyphs_of(default)) + len(manifest.deprecated_aliases)
    if len(members) != expected_members:
        problems.append(f"RemixIcons declares {len(members)} members, expected {expected_members}")

    barrel = (PACKAGE_ROOT / "lib" / "remix_ui_icons.dart").read_text(encoding="utf-8")
    reached = [barrel] + [
        (PACKAGE_ROOT / "lib" / path).read_text(encoding="utf-8")
        for path in re.findall(r"^export '([^']+)';", barrel, re.M)
    ]
    for text in reached:
        directives = re.findall(r"^(?:import|export) '([^']+)'", text, re.M)
        if any(
            name in directive
            for directive in directives
            for name in ("icons_index", "icon_sets", "sized.dart")
        ):
            problems.append(
                "remix_ui_icons.dart reaches an opt-in library; importing it would keep "
                "every glyph in a release build"
            )
            break

    pubspec = yaml.safe_load((PACKAGE_ROOT / "pubspec.yaml").read_text(encoding="utf-8"))
    fonts = pubspec.get("flutter", {}).get("fonts", [])
    if fonts != [
        {"family": manifest.font_family, "fonts": [{"asset": "lib/src/generated/fonts/RemixIcons.otf"}]}
    ]:
        problems.append("pubspec.yaml must register exactly the RemixIcons font with one asset")
    notices = (PACKAGE_ROOT / "THIRD_PARTY_NOTICES.md").read_text(encoding="utf-8")
    license_text = (manifest.source_root / "LICENSE").read_text(encoding="utf-8")
    if license_text.strip() not in notices:
        problems.append("THIRD_PARTY_NOTICES.md must reproduce design/icons/LICENSE")
    return problems


def check_flutter_render(flutter: str, sources: list) -> list[str]:
    with tempfile.TemporaryDirectory(prefix="remix-icon-rasters-") as directory:
        raster.write_rasters(sources, Path(directory), scale=4)
        result = subprocess.run(
            [flutter, "test", "tool/icons/flutter"],
            cwd=PACKAGE_ROOT,
            env={**os.environ, "REMIX_ICONS_RASTERS": directory},
        )
    return [] if result.returncode == 0 else ["Flutter rendering differs from the SVG masters"]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--base-lock", type=Path, help="an earlier codepoints.lock.json")
    parser.add_argument("--flutter", help="also render every glyph with this flutter")
    args = parser.parse_args()

    manifest = load_manifest()
    problems: list[str] = []

    print("Checking generated artifacts...", flush=True)
    if generate.main_check() != 0:
        problems.append("Generated icon artifacts are out of date")

    print("Checking the codepoint lock...", flush=True)
    current_lock = lock.read_lock()
    base = None
    if args.base_lock is not None:
        base = json.loads(args.base_lock.read_text(encoding="utf-8"))
    problems += lock.check(manifest, current_lock, base)
    codepoints = lock.codepoints(current_lock)

    print("Checking the generated Dart...", flush=True)
    problems += check_dart(manifest, codepoints)

    print("Comparing every glyph with its SVG master...", flush=True)
    sources = load_sources(manifest)
    font = generate.FONT_PATH.read_bytes()
    comparisons = raster.compare_all(manifest, sources, font, codepoints)
    failures = [comparison for comparison in comparisons if not comparison.passed]
    problems += [comparison.describe() for comparison in failures]
    for scale in raster.SCALES:
        measured = [c for c in comparisons if c.scale == scale]
        print(
            f"  {len(measured)} comparisons at {scale}x: worst mean alpha delta "
            f"{max(c.mean for c in measured):.3f}, worst peak {max(c.maximum for c in measured)}"
        )

    print("Checking the API against the last release...", flush=True)
    problems += check_api(manifest)

    if args.flutter:
        print("Rendering every glyph through Flutter...", flush=True)
        problems += check_flutter_render(args.flutter, sources)

    if problems:
        print(f"\nremix_ui_icons check failed ({len(problems)} problems):", file=sys.stderr)
        for problem in problems:
            print(f"- {problem}", file=sys.stderr)
        return 1
    print(
        f"remix_ui_icons verified: {len(manifest.glyphs)} glyphs, "
        f"{len(manifest.deprecated_aliases)} deprecated aliases, "
        f"{len(comparisons)} raster comparisons."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
