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

from source.catalog import FAMILIES, MASTERS, APPEARANCES, SHARED, render_catalog, svg_file

CONSTRUCTORS = (
    "soft/source/draw.py",
    "soft/source/primitives.py",
    "technical/source/icons.py",
    "technical/source/grammar.py",
    "technical/source/export.py",
)
FORBIDDEN = (
    "generated/angular",
    "baseline.draw",
    "source.angular",
    "angular.baseline",
)


def _json(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


class PackageTests(unittest.TestCase):
    def test_pack_is_private_bsd(self):
        package = _json(ROOT / "package.json")
        self.assertIs(package["private"], True)
        self.assertEqual(package["license"], "BSD-3-Clause")
        self.assertNotIn("publishConfig", package)
        web = _json(ROOT / "angular" / "packages" / "web" / "package.json")
        soft = _json(ROOT / "soft" / "package.json")
        self.assertIs(web["private"], True)
        self.assertIs(soft["private"], True)
        self.assertEqual(web["license"], "BSD-3-Clause")
        self.assertEqual(soft["license"], "BSD-3-Clause")

    def test_license_names_leo_farias(self):
        for path in (
            ROOT / "LICENSE",
            ROOT / "angular" / "LICENSE",
            ROOT / "soft" / "LICENSE",
            ROOT / "technical" / "LICENSE",
        ):
            text = path.read_text(encoding="utf-8")
            self.assertIn("BSD 3-Clause License", text)
            self.assertIn("Leo Farias", text)

    def test_families_are_siblings_and_not_a_dart_package(self):
        for family in FAMILIES:
            self.assertTrue((ROOT / family / "source").is_dir(), family)
        self.assertEqual(list(ROOT.rglob("pubspec.yaml")), [])

    def test_constructors_do_not_read_angular_paths(self):
        for relative in CONSTRUCTORS:
            text = (ROOT / relative).read_text(encoding="utf-8")
            for token in FORBIDDEN:
                self.assertNotIn(token, text, f"{relative} contains {token}")
        soft = _json(ROOT / "soft" / "catalog" / "styles.json")["soft"]
        self.assertIn("not offset Angular paths", soft["notAngularFilter"])


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
    def test_counts_and_angular_hashes(self):
        inventory = _json(ROOT / "angular" / "generated" / "inventory.json")
        self.assertEqual(len(inventory), 288)
        for row in inventory:
            path = ROOT / "angular" / "generated" / row["path"]
            digest = hashlib.sha256(path.read_bytes()).hexdigest()
            self.assertEqual(digest, row["sha256"], row["path"])
        self.assertEqual(len(list((ROOT / "soft" / "generated" / "soft").rglob("*.svg"))), 72)
        self.assertEqual(
            len(list((ROOT / "technical" / "generated" / "technical").rglob("*.svg"))),
            72,
        )

    def test_soft_and_technical_paths_differ_from_angular_and_each_other(self):
        registries = {
            "angular": _json(ROOT / "angular" / "generated" / "registry.json")["paths"],
            "soft": _json(ROOT / "soft" / "generated" / "registry.json")["paths"],
            "technical": _json(ROOT / "technical" / "generated" / "registry.json")["paths"],
        }
        for icon_id in SHARED:
            for appearance in APPEARANCES:
                for size in MASTERS:
                    angular = registries["angular"][icon_id][appearance][str(size)]
                    soft = registries["soft"][icon_id][appearance][str(size)]
                    technical = registries["technical"][icon_id][appearance][str(size)]
                    with self.subTest(icon=icon_id, appearance=appearance, size=size):
                        self.assertNotEqual(soft, angular)
                        self.assertNotEqual(technical, angular)
                        self.assertNotEqual(soft, technical)


class CatalogTests(unittest.TestCase):
    def test_catalog_matches_generator_and_shows_every_family(self):
        page = ROOT / "catalog" / "index.html"
        rendered = render_catalog(ROOT)
        self.assertEqual(page.read_text(encoding="utf-8"), rendered)
        self.assertIn("Visible text label required", rendered)
        self.assertIn("A tooltip or accessible name alone does not replace the visible label.", rendered)
        for family in ("Angular", "Soft", "Technical"):
            self.assertIn(family, rendered)
        for icon_id in SHARED:
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
