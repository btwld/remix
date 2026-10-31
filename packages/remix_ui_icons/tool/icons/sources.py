"""Validate the Vector UI SVG masters and stage them for GlyphPact.

Every glyph's drawing lives at
`design/icons/<family>/generated/<family>/<style>/<master>/<concept>.svg`.
The masters are already filled outlines: one `currentColor` path with an
even-odd fill rule and no strokes, so nothing needs expanding before the font
build. That is asserted here rather than assumed, so a future stroked drawing
fails loudly instead of compiling into a hairline glyph.
"""

from __future__ import annotations

import hashlib
import re
import xml.etree.ElementTree as ElementTree
from dataclasses import dataclass
from pathlib import Path

from manifest import Glyph, Manifest

SVG_NAMESPACE = "http://www.w3.org/2000/svg"
_ALLOWED_ROOT_ATTRIBUTES = {
    "width",
    "height",
    "viewBox",
    "fill",
    "fill-rule",
    "role",
    "focusable",
}
_ALLOWED_PATH_ATTRIBUTES = {"d"}
_PATH_COMMANDS = re.compile(r"[MLHVCSQTAZmlhvcsqtaz]")


class SourceError(Exception):
    """A drawing does not meet the font build's input contract."""


@dataclass(frozen=True)
class Source:
    glyph: Glyph
    path: Path
    data: bytes

    @property
    def sha256(self) -> str:
        return hashlib.sha256(self.data).hexdigest()

    @property
    def path_data(self) -> str:
        root = ElementTree.fromstring(self.data)
        return " ".join(
            element.attrib["d"] for element in root.iter(f"{{{SVG_NAMESPACE}}}path")
        )


def family_directory(manifest: Manifest, family: str) -> Path:
    return manifest.source_root / family / "generated" / family


def source_path(manifest: Manifest, glyph: Glyph) -> Path:
    return family_directory(manifest, glyph.family.key).parent / glyph.source


def _fail(path: Path, message: str) -> None:
    raise SourceError(f"{path}: {message}")


def validate_svg(path: Path, master: int) -> bytes:
    data = path.read_bytes()
    try:
        root = ElementTree.fromstring(data)
    except ElementTree.ParseError as error:
        _fail(path, f"is not well-formed XML ({error})")
    if root.tag != f"{{{SVG_NAMESPACE}}}svg":
        _fail(path, "root element must be an SVG <svg>")
    unknown = set(root.attrib) - _ALLOWED_ROOT_ATTRIBUTES
    if unknown:
        _fail(path, f"unexpected root attributes {sorted(unknown)}")
    expected = f"0 0 {master} {master}"
    if root.attrib.get("viewBox") != expected:
        _fail(path, f"viewBox must be {expected!r} for the {master} px master")
    for dimension in ("width", "height"):
        if root.attrib.get(dimension) != str(master):
            _fail(path, f"{dimension} must be {master}")
    if root.attrib.get("fill") != "currentColor":
        _fail(path, "must paint with fill=\"currentColor\" only")
    if root.attrib.get("fill-rule", "nonzero") not in ("evenodd", "nonzero"):
        _fail(path, "fill-rule must be evenodd or nonzero")

    paths = 0
    for element in root:
        tag = element.tag.removeprefix(f"{{{SVG_NAMESPACE}}}")
        if tag == "title":
            continue
        if tag != "path":
            _fail(path, f"only <title> and <path> children are allowed, found <{tag}>")
        unknown = set(element.attrib) - _ALLOWED_PATH_ATTRIBUTES
        if unknown:
            # Rules out stroke, stroke-width, fill overrides, opacity, transforms,
            # and colors: the only paint is the root's currentColor fill.
            _fail(path, f"<path> may only carry d, found {sorted(unknown)}")
        if len(element):
            _fail(path, "<path> must not have children")
        _validate_path_data(path, element.attrib.get("d", ""))
        paths += 1
    if paths == 0:
        _fail(path, "has no <path>")
    if b"stroke" in data:
        _fail(path, "uses a stroke; outline it into a filled path first")
    return data


def _validate_path_data(path: Path, data: str) -> None:
    commands = _PATH_COMMANDS.findall(data)
    if not commands or commands[0] not in "Mm":
        _fail(path, "path data must start with a moveto")
    # Every subpath is closed: each moveto after the first follows a closepath,
    # and the data ends with one. An open subpath would fill differently in a
    # font than in a browser.
    for previous, command in zip(commands, commands[1:]):
        if command in "Mm" and previous not in "Zz":
            _fail(path, "every subpath must end with Z before the next moveto")
    if commands[-1] not in "Zz":
        _fail(path, "the last subpath must end with Z")


def load_sources(manifest: Manifest) -> list[Source]:
    """Validate every manifest glyph's drawing and that nothing else exists."""

    sources = []
    expected: dict[str, set[Path]] = {}
    for glyph in manifest.glyphs:
        path = source_path(manifest, glyph)
        if not path.is_file():
            raise SourceError(
                f"{glyph.family.class_name}.{glyph.member} has no drawing at {path}"
            )
        sources.append(Source(glyph, path, validate_svg(path, glyph.master)))
        expected.setdefault(glyph.family.key, set()).add(path)

    for family in manifest.families:
        directory = family_directory(manifest, family.key)
        found = set(directory.rglob("*.svg"))
        extra = sorted(found - expected.get(family.key, set()))
        if extra:
            raise SourceError(
                f"{directory} has drawings the manifest does not list: "
                + ", ".join(str(path.relative_to(directory)) for path in extra[:10])
            )
    return sources


def stage(sources: list[Source], directory: Path) -> None:
    """Copy each drawing byte for byte to its glyph's GlyphPact source path."""

    for source in sources:
        target = directory / source.glyph.source
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(source.data)
