"""The manifest's usage rules agree with the Vector UI design contract.

The contract lives in three places in design/icons: each family's catalog
(`review.usage`, `review.usageRestriction`), Mono's `USAGE_LIMITS` in
mono/source/contract.py, and the pack and family READMEs. This test derives
which glyphs need a visible label from those sources and compares the result
with the manifest, so a contract change cannot silently leave the generated
`requiresLabel` metadata behind. Every distinct catalog usage text and Mono
limit must be classified below; a new one fails until it is.
"""

from __future__ import annotations

import ast
import json
import re
import unittest

from manifest import MASTERS, load_manifest

MANIFEST = load_manifest()
DESIGN = MANIFEST.source_root
ALL = frozenset(MASTERS)

# Catalog `review.usage` texts: (kind, masters it requires a label at).
CATALOG_USAGE = {
    # The general guidance every icon carries; not a per-icon requirement.
    "Use the action name on the enclosing control; 12 px is for labeled information.": None,
    # Direction, not labels: every concept is `rtl: false` in the manifest.
    "The application chooses left/right; artwork does not auto-mirror.": None,
    "Visible label required at 12 px; contextual label recommended at other sizes.": frozenset({12}),
    "Keep a visible label, especially at 12 px. This is a usage note, not the Warning restriction record.": ALL,
    "Visible text label required for outline and filled Warning at 12 / 16 / 24 px, including scaled uses of those masters.": ALL,
}
CATALOG_RESTRICTIONS = {"warning-visible-label": ALL}

# Mono's USAGE_LIMITS ids: (manifest rule kind, masters it applies at).
MONO_LIMITS = {
    "search-as-viewfinder": ("label-contextual", ALL),
    "cad-star-as-favorite": ("label-required", ALL),
    "plus-keyline-mixed-toolbar": ("note", ALL),
    "density-12-link-branch": ("label-required", frozenset({12})),
}

# Requirements stated only in prose: (source, quote, family, concept, masters).
PROSE = (
    ("rounded/README.md", "Branch and 12 px Link should keep a visible label", "rounded", "link", frozenset({12})),
    ("rounded/README.md", "Branch and 12 px Link should keep a visible label", "rounded", "branch", ALL),
)


def _normalize(text: str) -> str:
    return re.sub(r"\s+", " ", text)


def _catalog(family: str) -> list[dict]:
    return json.loads((DESIGN / family / "catalog" / "icons.json").read_text(encoding="utf-8"))["icons"]


def _mono_limits() -> tuple[dict, ...]:
    tree = ast.parse((DESIGN / "mono" / "source" / "contract.py").read_text(encoding="utf-8"))
    for node in tree.body:
        if isinstance(node, ast.Assign) and any(
            isinstance(target, ast.Name) and target.id == "USAGE_LIMITS" for target in node.targets
        ):
            return ast.literal_eval(node.value)
    raise AssertionError("mono/source/contract.py has no USAGE_LIMITS")


def _manifest_required() -> set[tuple[str, str, int]]:
    return {
        (glyph.family.key, glyph.concept.id, glyph.master)
        for glyph in MANIFEST.glyphs
        if glyph.requires_label
    }


class UsageContractTest(unittest.TestCase):
    def test_every_rule_quotes_its_source(self) -> None:
        for concept in MANIFEST.concepts:
            for rule in concept.usage:
                path = DESIGN / rule.source
                self.assertTrue(path.is_file(), f"{concept.id}: {rule.source} is missing")
                self.assertIn(
                    _normalize(rule.quote),
                    _normalize(path.read_text(encoding="utf-8")),
                    f"{concept.id}: {rule.source} no longer says {rule.quote!r}",
                )
                # A family-specific source can only ground that family's rules.
                owner = rule.source.split("/", 1)[0]
                if owner in {family.key for family in MANIFEST.families}:
                    self.assertEqual(rule.families, {owner}, f"{concept.id}: {rule.source}")

    def test_every_contract_text_is_classified(self) -> None:
        for family in MANIFEST.families:
            for icon in _catalog(family.key):
                review = icon.get("review", {})
                usage = review.get("usage")
                if usage:
                    self.assertIn(usage, CATALOG_USAGE, f"{family.key}.{icon['id']}: classify {usage!r}")
                restriction = review.get("usageRestriction")
                if restriction:
                    self.assertIn(restriction, CATALOG_RESTRICTIONS, f"{family.key}.{icon['id']}")
        self.assertEqual({limit["id"] for limit in _mono_limits()}, set(MONO_LIMITS))

    def test_required_labels_match_the_contract(self) -> None:
        expected: set[tuple[str, str, int]] = set()
        for family in MANIFEST.families:
            for icon in _catalog(family.key):
                review = icon.get("review", {})
                for masters in (
                    CATALOG_USAGE.get(review.get("usage")),
                    CATALOG_RESTRICTIONS.get(review.get("usageRestriction")),
                ):
                    expected |= {(family.key, icon["id"], master) for master in masters or ()}
        for limit in _mono_limits():
            kind, masters = MONO_LIMITS[limit["id"]]
            if kind == "label-required":
                expected |= {("mono", icon, master) for icon in limit["icons"] for master in masters}
        for source, quote, family, concept, masters in PROSE:
            self.assertIn(_normalize(quote), _normalize((DESIGN / source).read_text(encoding="utf-8")))
            expected |= {(family, concept, master) for master in masters}

        self.assertEqual(_manifest_required(), expected)

    def test_mono_limits_reach_the_metadata(self) -> None:
        notes = {
            (glyph.concept.id, glyph.master): glyph
            for glyph in MANIFEST.glyphs_of(MANIFEST.family("mono"))
            if glyph.style == "outline"
        }
        for limit in _mono_limits():
            kind, masters = MONO_LIMITS[limit["id"]]
            for icon in limit["icons"]:
                for master in MASTERS:
                    rules = [
                        rule
                        for rule in notes[(icon, master)].usage
                        if rule.source == "mono/source/contract.py" and rule.quote == limit["guidance"]
                    ]
                    if master in masters:
                        self.assertEqual([rule.kind for rule in rules], [kind], f"mono.{icon}@{master}")
                    else:
                        self.assertEqual(rules, [], f"mono.{icon}@{master}")

    def test_the_review_findings(self) -> None:
        # The independent review of #336 found these reported no label.
        glyphs = {
            glyph.member: glyph for glyph in MANIFEST.glyphs_of(MANIFEST.family("mono"))
        }
        for member in ("link12", "linkFilled12", "branch12", "branchFilled12"):
            self.assertTrue(glyphs[member].requires_label, member)
        for member in ("link16", "branch", "search", "plus12"):
            self.assertFalse(glyphs[member].requires_label, member)
        self.assertIn("crop, frame, or view tools", glyphs["search"].usage_notes[0])


if __name__ == "__main__":
    unittest.main()
