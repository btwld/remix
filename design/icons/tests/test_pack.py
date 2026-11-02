"""Pack-level checks for the sibling Vector UI families.

Family geometry tests stay in each family. This module checks the shared
contract: one private package, distinct construction, the Warning label
rule, and the comparison catalog.
"""
from __future__ import annotations

import hashlib
import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

import sys

sys.path.insert(0, str(ROOT))

from source.catalog import FAMILIES, MASTERS, APPEARANCES, shared_ids, render_catalog, svg_file

CONSTRUCTORS = (
    "rounded/source/draw.py",
    "rounded/source/primitives.py",
)
FORBIDDEN = (
    "generated/outline",
    "baseline.draw",
    "source.outline",
    "outline.baseline",
)


def _json(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


class PackageTests(unittest.TestCase):
    def test_pack_is_private_bsd(self):
        package = _json(ROOT / "package.json")
        self.assertIs(package["private"], True)
        self.assertEqual(package["license"], "BSD-3-Clause")
        self.assertNotIn("publishConfig", package)
        web = _json(ROOT / "outline" / "packages" / "web" / "package.json")
        rounded = _json(ROOT / "rounded" / "package.json")
        self.assertIs(web["private"], True)
        self.assertIs(rounded["private"], True)
        self.assertEqual(web["license"], "BSD-3-Clause")
        self.assertEqual(rounded["license"], "BSD-3-Clause")

    def test_license_names_leo_farias(self):
        for path in (
            ROOT / "LICENSE",
            ROOT / "outline" / "LICENSE",
            ROOT / "rounded" / "LICENSE",
        ):
            text = path.read_text(encoding="utf-8")
            self.assertIn("BSD 3-Clause License", text)
            self.assertIn("Leo Farias", text)

    def test_families_are_siblings_and_not_a_dart_package(self):
        self.assertEqual(FAMILIES, ("outline", "rounded"))
        for family in FAMILIES:
            self.assertTrue((ROOT / family / "source").is_dir(), family)
        self.assertEqual(list(ROOT.rglob("pubspec.yaml")), [])

    def test_constructors_do_not_read_outline_paths(self):
        constructors = list(CONSTRUCTORS) + [str(p.relative_to(ROOT)) for p in (ROOT / "rounded/source/glyphs").rglob("*.py")]
        for relative in constructors:
            text = (ROOT / relative).read_text(encoding="utf-8")
            for token in FORBIDDEN:
                self.assertNotIn(token, text, f"{relative} contains {token}")
        rounded = _json(ROOT / "rounded" / "catalog" / "styles.json")["rounded"]
        self.assertIn("not offset Outline paths", rounded["notOutlineFilter"])


class WarningTests(unittest.TestCase):
    def test_visible_label_on_every_native_cell(self):
        for family in FAMILIES:
            records = _json(ROOT / family / "catalog" / "restrictions.json")["records"]
            record = next(item for item in records if item["id"] == "warning-visible-label")
            self.assertEqual(record["icon"], "warning")
            self.assertEqual(record["pack"], family)
            self.assertEqual(set(record["sizes"]), {"12", "16", "24"})
            for size in MASTERS:
                for appearance in APPEARANCES:
                    cell = record["sizes"][str(size)][appearance]
                    with self.subTest(family=family, size=size, appearance=appearance):
                        self.assertIs(cell["visibleLabelRequired"], True)
                        artwork = svg_file(ROOT, family, appearance, size, "warning")
                        digest = hashlib.sha256(artwork.read_bytes()).hexdigest()
                        self.assertEqual(cell["geometrySha256"], digest)


class GeometryTests(unittest.TestCase):
    def test_complete_inventory_matches_the_approved_product_scope(self):
        scope = _json(ROOT / "tests/fixtures/product-inventory.json")
        self.assertEqual(len(scope["concepts"]), 77)
        self.assertEqual(set(shared_ids(ROOT)), set(scope["concepts"]))

    def test_counts_and_outline_hashes(self):
        inventory = _json(ROOT / "outline" / "generated" / "inventory.json")
        self.assertEqual(len(inventory), 462)
        for row in inventory:
            path = ROOT / "outline" / "generated" / row["path"]
            digest = hashlib.sha256(path.read_bytes()).hexdigest()
            self.assertEqual(digest, row["sha256"], row["path"])
        self.assertEqual(len(list((ROOT / "rounded" / "generated" / "rounded").rglob("*.svg"))), 462)

    def test_rounded_paths_differ_from_outline(self):
        registries = {
            "outline": _json(ROOT / "outline" / "generated" / "registry.json")["paths"],
            "rounded": _json(ROOT / "rounded" / "generated" / "registry.json")["paths"],
        }
        for icon_id in shared_ids(ROOT):
            for appearance in APPEARANCES:
                for size in MASTERS:
                    outline = registries["outline"][icon_id][appearance][str(size)]
                    rounded = registries["rounded"][icon_id][appearance][str(size)]
                    with self.subTest(icon=icon_id, appearance=appearance, size=size):
                        self.assertNotEqual(rounded, outline)


class CatalogTests(unittest.TestCase):
    def test_catalog_matches_generator_and_shows_every_family(self):
        page = ROOT / "catalog" / "index.html"
        rendered = render_catalog(ROOT)
        self.assertEqual(page.read_text(encoding="utf-8"), rendered)
        self.assertIn("Visible text label required", rendered)
        self.assertIn("A tooltip or accessible name alone does not replace the visible label.", rendered)
        for family in ("Outline", "Rounded"):
            self.assertIn(family, rendered)
        for icon_id in shared_ids(ROOT):
            self.assertIn(f'id="{icon_id}"', rendered)
        for size in MASTERS:
            for appearance in APPEARANCES:
                for family in FAMILIES:
                    svg = svg_file(ROOT, family, appearance, size, "warning").read_text(encoding="utf-8").strip()
                    self.assertIn(svg, rendered)
        self.assertNotIn("fonts.googleapis", rendered)

    def test_catalog_mentions_publication_boundary(self):
        rendered = (ROOT / "catalog" / "index.html").read_text(encoding="utf-8")
        self.assertIn("not published to npm or pub.dev", rendered)
        self.assertIn("remix_ui_icons", rendered)
