"""The append-only codepoint lock.

`codepoints.lock.json` is GlyphPact's lock format, so GlyphPact honors every
assignment in it. This module owns allocation instead of GlyphPact so the
order is the manifest's (family, concept, master, style) rather than source
path order, and so the rules below hold whatever GlyphPact would do:

- A glyph keeps its codepoint for as long as the lock exists.
- A new glyph takes the next codepoint above every one ever assigned.
- A glyph that leaves the manifest moves to `retired`; it is never deleted,
  and its codepoint is never handed out again.
- Nothing is assigned inside a reserved range (the 0.1.x Radix glyphs).
"""

from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path
from typing import Any

from font import UNITS_PER_EM
from manifest import TOOL_ROOT, Manifest
from sources import Source

LOCK_PATH = TOOL_ROOT / "codepoints.lock.json"
GLYPHPACT_VERSION = "1.1.0"


class LockError(Exception):
    """The lock breaks an append-only rule."""


@dataclass(frozen=True)
class LockEntry:
    source: str
    name: str
    codepoint: int
    retired: bool


def _format(codepoint: int) -> str:
    return f"0x{codepoint:04X}"


def read_lock(path: Path = LOCK_PATH) -> dict[str, Any] | None:
    if not path.exists():
        return None
    return json.loads(path.read_text(encoding="utf-8"))


def entries(lock: dict[str, Any] | None) -> list[LockEntry]:
    if lock is None:
        return []
    return [
        LockEntry(glyph["source"], glyph["name"], int(glyph["codepoint"], 16), retired)
        for key, retired in (("glyphs", False), ("retired", True))
        for glyph in lock.get(key, [])
    ]


def seed(manifest: Manifest, sources: list[Source], lock: dict[str, Any] | None) -> dict[str, Any]:
    """The lock GlyphPact builds from: every current glyph already assigned.

    Existing assignments are kept verbatim. A glyph the lock has never seen
    takes the next codepoint above everything assigned so far.
    """

    previous = {entry.source: entry for entry in entries(lock)}
    by_source = {}
    if lock is not None:
        for glyph in (*lock.get("glyphs", []), *lock.get("retired", [])):
            by_source[glyph["source"]] = glyph
    used = [entry.codepoint for entry in previous.values()]
    next_codepoint = max([manifest.start_codepoint - 1, *used]) + 1

    current = {source.glyph.source for source in sources}
    glyphs = []
    for source in sources:
        glyph = source.glyph
        old = by_source.get(glyph.source)
        if old is not None:
            if old["name"] != glyph.lock_name:
                raise LockError(
                    f"{glyph.source} is locked as {old['name']}, but the manifest now "
                    f"names it {glyph.lock_name}. A rename is a new glyph: give the "
                    "drawing a new concept id and keep the old one as an alias."
                )
            codepoint = int(old["codepoint"], 16)
        else:
            while manifest.is_reserved(next_codepoint):
                next_codepoint += 1
            codepoint = next_codepoint
            next_codepoint += 1
        entry = {
            "source": glyph.source,
            "name": glyph.lock_name,
            "codepoint": _format(codepoint),
            "sourceSha256": source.sha256,
            "matchTextDirection": glyph.concept.rtl,
        }
        # GlyphPact recomputes the geometry digest; keep it only while the
        # drawing is unchanged so the lock records the current outline.
        if old is not None and old.get("sourceSha256") == source.sha256 and "geometrySha256" in old:
            entry["geometrySha256"] = old["geometrySha256"]
        glyphs.append(entry)

    retired = [
        glyph
        for source_path, glyph in sorted(by_source.items(), key=lambda item: item[0].encode("utf-8"))
        if source_path not in current
    ]
    return {
        "schemaVersion": 1,
        "generator": "glyphpact",
        "generatorVersion": GLYPHPACT_VERSION,
        "fontFamily": manifest.font_family,
        "className": "RemixIconsFont",
        "fontPackage": manifest.package,
        "startCodepoint": _format(manifest.start_codepoint),
        "unitsPerEm": UNITS_PER_EM,
        "glyphs": sorted(glyphs, key=lambda glyph: glyph["source"].encode("utf-8")),
        "retired": retired,
    }


def codepoints(lock: dict[str, Any]) -> dict[str, int]:
    """Active glyph source path to codepoint."""
    return {glyph["source"]: int(glyph["codepoint"], 16) for glyph in lock["glyphs"]}


def check(manifest: Manifest, lock: dict[str, Any], base: dict[str, Any] | None = None) -> list[str]:
    """Every append-only rule, against an optional earlier lock."""

    problems = []
    all_entries = entries(lock)
    seen: dict[int, str] = {}
    sources: set[str] = set()
    for entry in all_entries:
        if entry.codepoint in seen:
            problems.append(
                f"{_format(entry.codepoint)} is assigned to both {seen[entry.codepoint]} "
                f"and {entry.source}"
            )
        seen[entry.codepoint] = entry.source
        if entry.source in sources:
            problems.append(f"{entry.source} appears in the lock twice")
        sources.add(entry.source)
        if manifest.is_reserved(entry.codepoint):
            problems.append(f"{entry.source} uses reserved codepoint {_format(entry.codepoint)}")
        if entry.codepoint < manifest.start_codepoint:
            problems.append(f"{entry.source} is below startCodepoint")

    active = {entry.source: entry for entry in all_entries if not entry.retired}
    expected = {glyph.source: glyph for glyph in manifest.glyphs}
    for source, glyph in expected.items():
        if source not in active:
            problems.append(f"{glyph.family.class_name}.{glyph.member} has no active codepoint")
        elif active[source].name != glyph.lock_name:
            problems.append(f"{source} is locked as {active[source].name}, not {glyph.lock_name}")
    for source in active.keys() - expected.keys():
        problems.append(f"{source} is active in the lock but not in the manifest; retire it")

    if base is not None:
        current = {entry.source: entry for entry in all_entries}
        for old in entries(base):
            new = current.get(old.source)
            if new is None:
                problems.append(f"{old.source} ({_format(old.codepoint)}) was deleted from the lock")
            elif new.codepoint != old.codepoint:
                problems.append(
                    f"{old.source} moved from {_format(old.codepoint)} to {_format(new.codepoint)}"
                )
    return problems
