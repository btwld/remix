"""Load and validate tool/icons/manifest.yaml.

The manifest is the single source of truth for the remix_ui_icons API: which
concepts exist, in which families, under which Dart names, and what became of
every 0.1.x name. Codepoints are held separately in the append-only lock (see
lock.py), so editing this file can never move one.
"""

from __future__ import annotations

import re
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import yaml

TOOL_ROOT = Path(__file__).resolve().parent
PACKAGE_ROOT = TOOL_ROOT.parents[1]
REPOSITORY_ROOT = PACKAGE_ROOT.parents[1]
MANIFEST_PATH = TOOL_ROOT / "manifest.yaml"

STYLES = ("outline", "filled")
USAGE_KINDS = ("label-required", "label-contextual", "note")
MASTERS = (24, 16, 12)
LEGACY_STATUSES = ("exact", "partial", "removed")

_IDENTIFIER = re.compile(r"^[a-z][A-Za-z0-9]*$")
_CLASS = re.compile(r"^[A-Z][A-Za-z0-9]*$")
_CONCEPT_ID = re.compile(r"^[a-z][a-z0-9]*(-[a-z0-9]+)*$")
_VERSION = re.compile(r"^\d+\.\d+\.\d+(-[0-9A-Za-z.]+)?$")
_DART_RESERVED = frozenset(
    "abstract as assert async await base break case catch class const continue "
    "covariant default deferred do dynamic else enum export extends extension "
    "external factory false final finally for get hide if implements import in "
    "interface is late library mixin new null of on operator part required "
    "rethrow return sealed set show static super switch sync this throw true "
    "try typedef var void when while with yield hashCode runtimeType "
    "toString noSuchMethod".split()
)


class ManifestError(Exception):
    """The manifest is malformed or contradicts itself."""


def _require(condition: bool, message: str) -> None:
    if not condition:
        raise ManifestError(message)


def _keys(value: Any, label: str, required: set[str], optional: set[str] = frozenset()) -> dict:
    _require(isinstance(value, dict), f"{label} must be a mapping")
    missing = required - value.keys()
    unknown = value.keys() - required - optional
    _require(not missing, f"{label} is missing {sorted(missing)}")
    _require(not unknown, f"{label} has unknown keys {sorted(unknown)}")
    return value


def _codepoint(value: Any, label: str) -> int:
    _require(
        isinstance(value, str) and re.fullmatch(r"0x[0-9A-F]{4,6}", value) is not None,
        f"{label} must be a quoted uppercase hex string such as \"0xE200\"",
    )
    return int(value, 16)


def _identifier(value: Any, label: str, *, ours: bool = True) -> str:
    _require(
        isinstance(value, str) and _IDENTIFIER.fullmatch(value) is not None,
        f"{label} must be a lowerCamelCase Dart identifier, got {value!r}",
    )
    if ours:
        _require(value not in _DART_RESERVED, f"{label} {value!r} is reserved in Dart")
    return value


@dataclass(frozen=True)
class Family:
    key: str
    class_name: str
    label: str

    @property
    def sets_class_name(self) -> str:
        return self.class_name.removesuffix("Icons") + "IconSets"


@dataclass(frozen=True)
class UsageRule:
    """One supported-use rule from the design contract.

    `source` is a path below design/icons and `quote` the text there that
    grounds the rule, so test_usage.py can hold the two together.
    """

    families: frozenset[str]
    masters: frozenset[int]
    kind: str
    note: str
    source: str
    quote: str

    def applies_to(self, family: str, master: int) -> bool:
        return family in self.families and master in self.masters


@dataclass(frozen=True)
class Concept:
    id: str
    name: str
    label: str
    families: tuple[str, ...]
    tags: tuple[str, ...]
    rtl: bool
    usage: tuple[UsageRule, ...]
    since: str


@dataclass(frozen=True)
class Glyph:
    family: Family
    concept: Concept
    style: str
    master: int

    @property
    def member(self) -> str:
        """The constant's name on its family class, e.g. `searchFilled16`."""
        suffix = "Filled" if self.style == "filled" else ""
        size = "" if self.master == 24 else str(self.master)
        return f"{self.concept.name}{suffix}{size}"

    @property
    def source(self) -> str:
        """The glyph's path below the family's generated SVG directory."""
        return f"{self.family.key}/{self.style}/{self.master}/{self.concept.id}.svg"

    @property
    def lock_name(self) -> str:
        """A name unique across families, used in the codepoint lock."""
        member = self.member
        return f"{self.family.key}{member[:1].upper()}{member[1:]}"

    @property
    def usage(self) -> tuple[UsageRule, ...]:
        return tuple(
            rule
            for rule in self.concept.usage
            if rule.applies_to(self.family.key, self.master)
        )

    @property
    def requires_label(self) -> bool:
        """Whether this glyph must be shown with a visible text label."""
        return any(rule.kind == "label-required" for rule in self.usage)

    @property
    def usage_notes(self) -> tuple[str, ...]:
        """Every supported-use note for this glyph, in manifest order."""
        return tuple(dict.fromkeys(rule.note for rule in self.usage))


@dataclass(frozen=True)
class LegacyIcon:
    name: str
    codepoint: int
    status: str
    target: str | None
    lucide: str | None
    note: str | None


@dataclass(frozen=True)
class Reserved:
    first: int
    last: int
    reason: str


@dataclass(frozen=True)
class Manifest:
    package: str
    font_family: str
    start_codepoint: int
    source_root: Path
    # Provenance only: records the commit the masters were reviewed at. It is
    # validated for shape and never resolved, so generation and checks work
    # from a source archive or a shallow clone. Glyph bytes bind the drawings.
    source_revision: str
    reserved: tuple[Reserved, ...]
    families: tuple[Family, ...]
    concepts: tuple[Concept, ...]
    legacy: tuple[LegacyIcon, ...]

    @property
    def default_family(self) -> Family:
        return self.families[0]

    def family(self, key: str) -> Family:
        for family in self.families:
            if family.key == key:
                return family
        raise ManifestError(f"Unknown family {key!r}")

    @property
    def glyphs(self) -> tuple[Glyph, ...]:
        """Every glyph, in a stable family, concept, master, style order."""
        return tuple(
            Glyph(family, concept, style, master)
            for family in self.families
            for concept in self.concepts
            if family.key in concept.families
            for master in MASTERS
            for style in STYLES
        )

    def glyphs_of(self, family: Family) -> tuple[Glyph, ...]:
        return tuple(glyph for glyph in self.glyphs if glyph.family == family)

    @property
    def deprecated_aliases(self) -> tuple[LegacyIcon, ...]:
        """Exact 0.1.x matches whose name changed, kept on the facade."""
        members = {glyph.member for glyph in self.glyphs_of(self.default_family)}
        return tuple(
            icon
            for icon in sorted(self.legacy, key=lambda icon: icon.name)
            if icon.status == "exact" and icon.name not in members
        )

    def is_reserved(self, codepoint: int) -> bool:
        return any(item.first <= codepoint <= item.last for item in self.reserved)


def load_manifest(path: Path = MANIFEST_PATH) -> Manifest:
    raw = yaml.safe_load(path.read_text(encoding="utf-8"))
    root = _keys(
        raw,
        "manifest",
        {
            "schema",
            "package",
            "fontFamily",
            "startCodepoint",
            "source",
            "reserved",
            "families",
            "styles",
            "masters",
            "concepts",
            "legacy",
        },
    )
    _require(root["schema"] == 1, "Unsupported manifest schema")
    _require(tuple(root["styles"]) == STYLES, f"styles must be {list(STYLES)}")
    _require(tuple(root["masters"]) == MASTERS, f"masters must be {list(MASTERS)}")
    source = _keys(root["source"], "source", {"root", "revision"})
    _require(
        re.fullmatch(r"[0-9a-f]{40}", str(source["revision"])) is not None,
        "source.revision must be a full commit SHA",
    )

    reserved = []
    for index, item in enumerate(root["reserved"]):
        item = _keys(item, f"reserved[{index}]", {"first", "last", "reason"})
        first = _codepoint(item["first"], f"reserved[{index}].first")
        last = _codepoint(item["last"], f"reserved[{index}].last")
        _require(first <= last, f"reserved[{index}] is empty")
        reserved.append(Reserved(first, last, str(item["reason"])))
    start = _codepoint(root["startCodepoint"], "startCodepoint")
    _require(
        all(not item.first <= start <= item.last for item in reserved),
        "startCodepoint falls inside a reserved range",
    )

    families = []
    for key, value in _keys(root["families"], "families", set(root["families"] or {})).items():
        value = _keys(value, f"families.{key}", {"class", "label"})
        _require(re.fullmatch(r"[a-z]+", key) is not None, f"Invalid family key {key!r}")
        _require(
            isinstance(value["class"], str) and _CLASS.fullmatch(value["class"]) is not None,
            f"families.{key}.class must be an UpperCamelCase identifier",
        )
        _require(value["class"].endswith("Icons"), f"families.{key}.class must end in Icons")
        families.append(Family(key, value["class"], str(value["label"])))
    _require(families, "At least one family is required")
    family_keys = {family.key for family in families}

    concepts = []
    names: set[str] = set()
    for concept_id, value in (root["concepts"] or {}).items():
        label = f"concepts.{concept_id}"
        _require(_CONCEPT_ID.fullmatch(concept_id) is not None, f"{label} is not a kebab-case id")
        value = _keys(
            value,
            label,
            {"name", "label", "families", "tags", "rtl", "since"},
            {"usage"},
        )
        name = _identifier(value["name"], f"{label}.name")
        _require(name not in names, f"{label}.name {name!r} is not unique")
        names.add(name)
        concept_families = tuple(value["families"])
        _require(concept_families, f"{label}.families is empty")
        _require(
            set(concept_families) <= family_keys,
            f"{label}.families names an unknown family",
        )
        _require(
            list(concept_families) == [f for f in (f.key for f in families) if f in concept_families],
            f"{label}.families must follow the families order",
        )
        _require(
            families[0].key in concept_families,
            f"{label} must exist in the default {families[0].key} family",
        )
        usage = []
        for index, item in enumerate(value.get("usage", ())):
            rule_label = f"{label}.usage[{index}]"
            item = _keys(
                item,
                rule_label,
                {"families", "kind", "note", "source", "quote"},
                {"masters"},
            )
            rule_families = frozenset(item["families"])
            _require(
                rule_families and rule_families <= set(concept_families),
                f"{rule_label}.families must name families that draw {concept_id}",
            )
            rule_masters = frozenset(item.get("masters", MASTERS))
            _require(
                rule_masters and rule_masters <= set(MASTERS),
                f"{rule_label}.masters must be a subset of {list(MASTERS)}",
            )
            _require(item["kind"] in USAGE_KINDS, f"{rule_label}.kind must be one of {USAGE_KINDS}")
            for key in ("note", "source", "quote"):
                _require(
                    isinstance(item[key], str) and item[key].strip(),
                    f"{rule_label}.{key} must be text",
                )
            usage.append(
                UsageRule(
                    families=rule_families,
                    masters=rule_masters,
                    kind=item["kind"],
                    note=item["note"],
                    source=item["source"],
                    quote=item["quote"],
                )
            )
        _require(isinstance(value["rtl"], bool), f"{label}.rtl must be a boolean")
        _require(
            _VERSION.fullmatch(str(value["since"])) is not None,
            f"{label}.since must be a version",
        )
        tags = tuple(str(tag) for tag in value["tags"])
        concepts.append(
            Concept(
                id=concept_id,
                name=name,
                label=str(value["label"]),
                families=concept_families,
                tags=tags,
                rtl=value["rtl"],
                usage=tuple(usage),
                since=str(value["since"]),
            )
        )
    _require(concepts, "At least one concept is required")

    legacy = []
    codepoints: set[int] = set()
    for name, value in (root["legacy"] or {}).items():
        label = f"legacy.{name}"
        _identifier(name, label)
        value = _keys(value, label, {"codepoint", "status", "lucide"}, {"target", "note"})
        codepoint = _codepoint(value["codepoint"], f"{label}.codepoint")
        _require(codepoint not in codepoints, f"{label}.codepoint is not unique")
        codepoints.add(codepoint)
        _require(
            any(item.first <= codepoint <= item.last for item in reserved),
            f"{label}.codepoint must lie in a reserved range",
        )
        status = value["status"]
        _require(status in LEGACY_STATUSES, f"{label}.status must be one of {LEGACY_STATUSES}")
        target = value.get("target")
        if status == "removed":
            _require(target is None, f"{label} is removed and cannot have a target")
        else:
            _identifier(target, f"{label}.target")
        lucide = value["lucide"]
        if lucide is not None:
            _identifier(lucide, f"{label}.lucide", ours=False)
        note = value.get("note")
        _require(
            status != "partial" or note,
            f"{label} is partial and must say what differs in a note",
        )
        _require(
            lucide is not None or note,
            f"{label} has no Lucide equivalent and must explain why in a note",
        )
        legacy.append(LegacyIcon(name, codepoint, status, target, lucide, note))

    manifest = Manifest(
        package=str(root["package"]),
        font_family=str(root["fontFamily"]),
        start_codepoint=start,
        source_root=(TOOL_ROOT / str(source["root"])).resolve(),
        source_revision=str(source["revision"]),
        reserved=tuple(reserved),
        families=tuple(families),
        concepts=tuple(concepts),
        legacy=tuple(legacy),
    )
    _validate_members(manifest)
    return manifest


def _validate_members(manifest: Manifest) -> None:
    for family in manifest.families:
        members = [glyph.member for glyph in manifest.glyphs_of(family)]
        duplicates = sorted({member for member in members if members.count(member) > 1})
        _require(not duplicates, f"{family.class_name} has duplicate members {duplicates}")
        for member in members:
            _identifier(member, f"{family.class_name}.{member}")
    lock_names = [glyph.lock_name for glyph in manifest.glyphs]
    _require(len(lock_names) == len(set(lock_names)), "Glyph lock names are not unique")

    facade = {glyph.member for glyph in manifest.glyphs_of(manifest.default_family)}
    for icon in manifest.legacy:
        if icon.target is not None:
            _require(
                icon.target in facade,
                f"legacy.{icon.name}.target {icon.target!r} is not a "
                f"{manifest.default_family.class_name} member",
            )
        if icon.name in facade:
            # A 0.1.x name that survives verbatim must mean the same glyph, or
            # the facade would silently change what an old call site renders.
            _require(
                icon.status == "exact" and icon.target == icon.name,
                f"legacy.{icon.name} collides with the new RemixIcons.{icon.name}; "
                "mark it exact with itself as the target, or rename the concept",
            )
