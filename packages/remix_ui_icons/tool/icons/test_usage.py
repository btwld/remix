"""The manifest's usage rules agree with the Vector UI design contract.

The contract lives in each family's catalog (`review.usage`,
`review.usageRestriction`) and the pack and family READMEs. This test derives
which glyphs need a visible label from those sources and compares the result
with the manifest, so a contract change cannot silently leave the generated
`requiresLabel` metadata behind. Every distinct catalog usage text must be classified below; a new one
fails until it is.
"""

from __future__ import annotations

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
    "Requires a visible text label at 12 px. At 16 and 24 px, use the action name on the enclosing control.": frozenset({12}),
    "Requires a visible text label at every size and appearance. This rule is separate from the Warning restriction record.": ALL,
}
CATALOG_USAGE.update({
    'Keep a visible action label: the wand does not say what the automatic action does.': ALL,
    'Pair with text that states the status; shape and color do not carry it alone. 12 px is for labeled information.': ALL,
    'A plain shape, not a control. Do not imply behavior; name any action on the enclosing control.': None,
    'Name the appearance on the enclosing control; this is not a generic status.': None,
    'Announce progress in text; the caller owns motion and reduced-motion behavior.': None,
})
CATALOG_RESTRICTIONS = {"warning-visible-label": ALL}

# Requirements stated only in prose: (source, quote, family, concept, masters).
PROSE = (
    ("rounded/README.md", "Branch also requires a visible text label at every size and appearance, and Link requires one at 12 px", "rounded", "link", frozenset({12})),
    ("rounded/README.md", "Branch also requires a visible text label at every size and appearance, and Link requires one at 12 px", "rounded", "branch", ALL),
)


def _normalize(text: str) -> str:
    return re.sub(r"\s+", " ", text)


def _catalog(family: str) -> list[dict]:
    return json.loads((DESIGN / family / "catalog" / "icons.json").read_text(encoding="utf-8"))["icons"]



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
        for source, quote, family, concept, masters in PROSE:
            self.assertIn(_normalize(quote), _normalize((DESIGN / source).read_text(encoding="utf-8")))
            expected |= {(family, concept, master) for master in masters}

        self.assertEqual(_manifest_required(), expected)




if __name__ == "__main__":
    unittest.main()
