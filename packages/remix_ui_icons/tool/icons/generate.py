#!/usr/bin/env python3
"""Regenerate every remix_ui_icons artifact from the manifest and the masters.

    uv run --frozen --project packages/remix_ui_icons/tool/icons \\
        python packages/remix_ui_icons/tool/icons/generate.py [--check]

Steps: validate the design/icons SVG masters against the manifest, assign
codepoints from the append-only lock, compile RemixIcons.otf with GlyphPact,
then write the Dart libraries, the migration guide, and the generated blocks
of the README and CHANGELOG. `--check` writes nothing and fails on any drift.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

import codegen
import docs
import font
import lock
from manifest import PACKAGE_ROOT, TOOL_ROOT, Manifest, load_manifest
from sources import load_sources

FONT_PATH = PACKAGE_ROOT / "lib" / "src" / "generated" / "fonts" / "RemixIcons.otf"
REPORT_PATH = TOOL_ROOT / "font-report.json"
API_PATH = TOOL_ROOT / "public_api.txt"


def _json(value: object) -> bytes:
    return (json.dumps(value, indent=2, ensure_ascii=False) + "\n").encode("utf-8")


def artifacts(manifest: Manifest) -> dict[Path, bytes]:
    sources = load_sources(manifest)
    seeded = lock.seed(manifest, sources, lock.read_lock())
    build = font.build_font(manifest, sources, seeded)
    codepoints = lock.codepoints(build.lock)
    svgs = {source.glyph.source: source.data for source in sources}

    files: dict[Path, bytes] = {
        lock.LOCK_PATH: _json(build.lock),
        FONT_PATH: build.font,
        REPORT_PATH: _json(font.report_summary(build)),
        API_PATH: ("\n".join(codegen.public_api(manifest)) + "\n").encode("utf-8"),
        PACKAGE_ROOT / "MIGRATION.md": docs.migration(manifest).encode("utf-8"),
    }
    for library in codegen.libraries(manifest, codepoints, svgs):
        files[PACKAGE_ROOT / library.path] = library.source.encode("utf-8")

    readme = PACKAGE_ROOT / "README.md"
    files[readme] = docs.replace_block(
        readme.read_text(encoding="utf-8"), "coverage", docs.coverage_table(manifest)
    ).encode("utf-8")
    changelog = PACKAGE_ROOT / "CHANGELOG.md"
    files[changelog] = docs.replace_block(
        docs.replace_block(
            changelog.read_text(encoding="utf-8"), "1.0.0", docs.changelog_block(manifest)
        ),
        "1.0.0-aliases",
        docs.alias_table(manifest),
    ).encode("utf-8")
    return files


def main_check() -> int:
    return run(check=True)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="fail on drift; write nothing")
    return run(check=parser.parse_args().check)


def run(*, check: bool) -> int:
    manifest = load_manifest()
    files = artifacts(manifest)
    stale = [
        path
        for path, data in files.items()
        if not path.exists() or path.read_bytes() != data
    ]
    if check:
        if stale:
            for path in stale:
                print(f"stale: {path.relative_to(PACKAGE_ROOT)}", file=sys.stderr)
            print(
                "Generated icon artifacts are out of date. Run "
                "`dart run melos run icons:generate`.",
                file=sys.stderr,
            )
            return 1
        print(f"{len(files)} generated icon artifacts are current.")
        return 0

    generated = PACKAGE_ROOT / "lib" / "src" / "generated"
    expected = {path for path in files if generated in path.parents}
    for path in generated.rglob("*"):
        if path.is_file() and path not in expected:
            path.unlink()
            print(f"removed {path.relative_to(PACKAGE_ROOT)}")
    for path, data in files.items():
        if path in stale:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(data)
            print(f"wrote {path.relative_to(PACKAGE_ROOT)}")
    print(f"{len(manifest.glyphs)} glyphs; {len(stale)} of {len(files)} artifacts changed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
