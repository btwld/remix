"""Seam tests for the Technical calibration pilot.

Tests cover the contract, grammar primitives, drawings, generated matrix,
SVG safety, fail-closed lookup, rebuild, native rasters, and Angular lock.
They do not assert private vertex lists.
"""
from __future__ import annotations
import hashlib
import io
import json
import math
import shutil
import sys
import tempfile
import unittest
from pathlib import Path

from PIL import Image
import cairosvg
from shapely.geometry import MultiPolygon, Polygon

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from source.contract import (
    APPEARANCES,
    ICONS,
    IDS,
    MASTERS,
    PACK,
    PAIR_MODEL,
    UnavailableAppearance,
    UnavailableMaster,
    UnavailablePack,
    UnknownIcon,
    resolve,
    select_master,
)
from source.export import parse_path, parse_svg, path_data, svg_text
from source.grammar import CHAMFER, CHAMFER_OVERRIDE, bar, edge_angles_deg, part_chamfer, plate, tokens
from source.icons import draw
import jsonschema

ANGULAR = ROOT.parents[2] / "design/icons/angular"
GEN = ROOT / "generated"
INV_PATH = GEN / "inventory.json"


def inventory():
    return json.loads(INV_PATH.read_text())


class ContractTests(unittest.TestCase):
    def test_twelve_canonical_ids(self):
        expected = (
            "home",
            "search",
            "plus",
            "arrow-right",
            "user",
            "file",
            "calendar",
            "sliders",
            "warning",
            "link",
            "branch",
            "star",
        )
        self.assertEqual(IDS, expected)
        self.assertEqual(len(ICONS), 12)
        self.assertEqual(len(set(IDS)), 12)

    def test_pair_models_match_angular_concepts(self):
        self.assertEqual(PAIR_MODEL["home"], "silhouette")
        self.assertEqual(PAIR_MODEL["search"], "weight")
        self.assertEqual(PAIR_MODEL["plus"], "weight")
        self.assertEqual(PAIR_MODEL["arrow-right"], "weight")
        self.assertEqual(PAIR_MODEL["user"], "silhouette")
        self.assertEqual(PAIR_MODEL["file"], "silhouette")
        self.assertEqual(PAIR_MODEL["calendar"], "silhouette")
        self.assertEqual(PAIR_MODEL["sliders"], "silhouette")
        self.assertEqual(PAIR_MODEL["warning"], "silhouette")
        self.assertEqual(PAIR_MODEL["link"], "weight")
        self.assertEqual(PAIR_MODEL["branch"], "silhouette")
        self.assertEqual(PAIR_MODEL["star"], "silhouette")

    def test_resolve_fail_closed(self):
        self.assertEqual(resolve("technical", "home", "outline", 24), ("technical", "home", "outline", 24))
        with self.assertRaises(UnavailablePack):
            resolve("angular", "home", "outline", 24)
        with self.assertRaises(UnavailablePack):
            resolve("rounded", "home", "outline", 24)
        with self.assertRaises(UnknownIcon):
            resolve("technical", "gear", "outline", 24)
        with self.assertRaises(UnavailableAppearance):
            resolve("technical", "home", "duotone", 24)
        with self.assertRaises(UnavailableMaster):
            resolve("technical", "home", "outline", 14)
        with self.assertRaises(UnavailableMaster):
            resolve("technical", "home", "outline", 32)

    def test_display_master_mapping_does_not_invent_sizes(self):
        self.assertEqual(select_master(14), 16)
        self.assertEqual(select_master(20), 24)
        with self.assertRaises(UnavailableMaster):
            select_master(13)
        with self.assertRaises(UnavailableMaster):
            select_master(11)


class GrammarTests(unittest.TestCase):
    def test_tokens_match_spec(self):
        self.assertEqual(tokens(12)["outline"], 1)
        self.assertEqual(tokens(16)["outline"], 1.5)
        self.assertEqual(tokens(24)["outline"], 2)
        self.assertEqual(tokens(12)["heavy"], 2)
        self.assertEqual(tokens(24)["chamfer"], 2)
        with self.assertRaises(UnavailableMaster):
            tokens(14)

    def test_plate_is_45_degree_octagon(self):
        g = plate(0, 0, 10, 10, 2)
        self.assertEqual(len(list(g.exterior.coords)) - 1, 8)
        angles = set(edge_angles_deg(g))
        self.assertTrue(angles <= {0.0, 45.0, 90.0, 135.0})
        self.assertIn(45.0, angles)

    def test_bar_terminals_are_square_to_stroke(self):
        g = bar((0, 0), (10, 0), 2)
        minx, miny, maxx, maxy = g.bounds
        self.assertAlmostEqual(miny, -1)
        self.assertAlmostEqual(maxy, 1)
        self.assertAlmostEqual(minx, 0)
        self.assertAlmostEqual(maxx, 10)
        diag = bar((0, 0), (8, 8), 2)
        # 45° bar: ends are perpendicular to the segment.
        self.assertGreater(diag.area, 15)


class DrawTests(unittest.TestCase):
    def test_all_72_drawings_are_valid(self):
        for icon_id in IDS:
            for appearance in APPEARANCES:
                for n in MASTERS:
                    g = draw(icon_id, n, appearance)
                    self.assertTrue(g.is_valid and not g.is_empty)
                    self.assertGreaterEqual(min(g.bounds), -1e-6)
                    self.assertLessEqual(max(g.bounds), n + 1e-6)
                    d = path_data(g)
                    self.assertTrue(d.startswith("M") and d.endswith("Z"))
                    self.assertNotRegex(d, r"[AaCcQqSsTtHhVv]")

    def test_silhouette_pairs_share_bounds(self):
        for icon_id, model in PAIR_MODEL.items():
            if model != "silhouette":
                continue
            for n in MASTERS:
                a = draw(icon_id, n, "outline")
                b = draw(icon_id, n, "filled")
                self.assertTrue(all(abs(x - y) < 0.002 for x, y in zip(a.bounds, b.bounds)), icon_id)
                self.assertGreater(b.area, a.area, icon_id)

    def test_weight_pairs_keep_search_and_link_open(self):
        for icon_id in ("search", "link"):
            for appearance in APPEARANCES:
                for n in MASTERS:
                    g = draw(icon_id, n, appearance)
                    parts = list(g.geoms) if isinstance(g, MultiPolygon) else [g]
                    holes = [Polygon(h) for p in parts for h in p.interiors]
                    self.assertTrue(holes, "%s %s %s must keep an open counter" % (icon_id, appearance, n))

    def test_plus_twelve_outline_stays_canvas_centered(self):
        g = draw("plus", 12, "outline")
        self.assertAlmostEqual((g.bounds[0] + g.bounds[2]) / 2.0, 6.0, places=3)
        # 1px stem on even canvas: half-pixel edges, not Angular's 5–6 split.
        self.assertAlmostEqual(g.bounds[0], 2.0)
        self.assertAlmostEqual(g.bounds[2], 10.0)

    def test_plus_is_not_a_padded_angular_copy(self):
        g = draw("plus", 24, "outline")
        self.assertGreaterEqual(g.bounds[0], 2.5)

    def test_part_chamfer_overrides_are_declared(self):
        self.assertEqual(part_chamfer("sliders", 12), 0.75)
        self.assertEqual(part_chamfer("branch", 12), 0.75)
        self.assertEqual(part_chamfer("home", 12), CHAMFER[12])
        self.assertEqual(part_chamfer("sliders", 24), 1.5)
        self.assertLess(CHAMFER_OVERRIDE[("sliders", 12)], CHAMFER[12])


class AssetTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not INV_PATH.exists():
            raise unittest.SkipTest("generated inventory missing; run source/build.py")
        cls.inv = inventory()
        cls.reg = json.loads((GEN / "registry.json").read_text())["paths"]
        cls.cat = json.loads((ROOT / "catalog/icons.json").read_text())

    def test_matrix_is_exactly_72(self):
        files = {str(p.relative_to(GEN)) for p in (GEN / "technical").rglob("*.svg")}
        self.assertEqual(len(files), 72)
        self.assertEqual(len(self.inv), 72)
        self.assertEqual(self.cat["counts"], {"icons": 12, "drawings": 72})
        expected = {
            "technical/%s/%s/%s.svg" % (a, n, i)
            for i in IDS
            for a in APPEARANCES
            for n in MASTERS
        }
        self.assertEqual(files, expected)
        self.assertEqual({r["path"] for r in self.inv}, expected)

    def test_svg_safety_and_current_color(self):
        for row in self.inv:
            data = (GEN / row["path"]).read_text()
            n, d, g = parse_svg(data)
            self.assertEqual(n, row["master"])
            self.assertEqual(d, self.reg[row["id"]][row["appearance"]][str(n)])
            self.assertIn('fill="currentColor"', data)
            self.assertEqual(hashlib.sha256(data.encode()).hexdigest(), row["sha256"])

    def test_parser_rejects_curves_and_unsafe_markup(self):
        for d in ["M0 0C1 2 3 4 5 6Z", "M0 0Q1 2 3 4Z", "M0 0LNaN 2Z", "M0 0L1 1", "M0 0L1 1Z<script>"]:
            with self.assertRaises(ValueError):
                parse_path(d)
        base = (GEN / "technical/outline/24/home.svg").read_text()
        for bad in [
            base.replace("<path ", '<image href="https://example.invalid/a"/><path '),
            base.replace("<path ", "<script>alert(1)</script><path "),
            base.replace("<path ", '<path onclick="x()" '),
            base.replace('fill="currentColor"', 'fill="#fff"'),
            "<!DOCTYPE svg>" + base,
        ]:
            with self.assertRaises(ValueError):
                parse_svg(bad)

    def test_no_silent_pack_in_catalog(self):
        self.assertTrue(self.cat["packs"]["technical"]["available"])
        self.assertFalse(self.cat["packs"]["angular"]["available"])
        self.assertFalse(self.cat["packs"]["rounded"]["available"])
        self.assertFalse(self.cat["packs"]["soft"]["available"])
        self.assertFalse(self.cat["releaseApproval"]["promotedToPublicCatalog"])
        self.assertFalse(self.cat["releaseApproval"]["publicReleaseApproved"])

    def test_warning_visible_label_is_concept_level(self):
        rest = json.loads((ROOT / "catalog/restrictions.json").read_text())
        rec = rest["records"][0]
        self.assertEqual(rec["id"], "warning-visible-label")
        for n in MASTERS:
            for appearance in APPEARANCES:
                self.assertTrue(rec["sizes"][str(n)][appearance]["visibleLabelRequired"])

    def test_native_rasters_current_color_and_transparency(self):
        for row in self.inv:
            txt = (GEN / row["path"]).read_text().replace("currentColor", "#d90075")
            im = Image.open(io.BytesIO(cairosvg.svg2png(bytestring=txt.encode()))).convert("RGBA")
            n = row["master"]
            self.assertEqual(im.size, (n, n))
            alpha = im.getchannel("A")
            self.assertIsNotNone(alpha.getbbox())
            self.assertEqual(alpha.getpixel((0, 0)), 0)
            visible = [p for p in im.get_flattened_data() if p[3] >= 128]
            self.assertTrue(visible)
            self.assertTrue(all(max(abs(x - y) for x, y in zip(p[:3], (217, 0, 117))) <= 2 for p in visible))
            proof = ROOT / "proof/rasters" / row["appearance"] / str(n) / ("%s.png" % row["id"])
            self.assertTrue(proof.exists(), proof)

    def test_exceptions_match_construction(self):
        exceptions = json.loads((ROOT / "catalog/exceptions.json").read_text())
        ids = {e["id"] for e in exceptions}
        for (icon_id, n), used in CHAMFER_OVERRIDE.items():
            if abs(used - CHAMFER[n]) < 1e-9:
                continue
            self.assertIn("%s-chamfer-%s" % (icon_id, n), ids)
        self.assertIn("plus-12-outline-centered-odd-width", ids)
        styles = json.loads((ROOT / "catalog/styles.json").read_text())["technical"]
        override_ids = {o["exceptionId"] for o in styles["chamferPartOverrides"]}
        for (icon_id, n), used in CHAMFER_OVERRIDE.items():
            if abs(used - CHAMFER[n]) < 1e-9:
                continue
            self.assertIn("%s-chamfer-%s" % (icon_id, n), override_ids)
            row = next(o for o in styles["chamferPartOverrides"] if o["icon"] == icon_id and o["nativeSize"] == n)
            self.assertEqual(row["used"], used)
            self.assertEqual(row["declared"], CHAMFER[n])
        self.assertEqual(styles["oddWidthCentering"]["policy"], "canvas-center")

    def test_catalog_schema(self):
        schema = json.loads((ROOT / "catalog/schemas/pilot.schema.json").read_text())
        jsonschema.validate(self.cat, schema)

    def test_registry_has_no_sha_side_channel(self):
        for icon_id, appearances in self.reg.items():
            for appearance, masters in appearances.items():
                self.assertNotIn("_sha", masters)
                self.assertEqual(set(masters), {"12", "16", "24"})

    def test_proof_artifacts_are_built(self):
        proof = ROOT / "proof"
        for name in (
            "contact-sheet.png",
            "masters-12-4x.png",
            "masters-16-4x.png",
            "masters-24-4x.png",
            "angular-vs-technical-24.png",
            "index.html",
        ):
            self.assertTrue((proof / name).exists(), name)
        questions = json.loads((ROOT / "catalog/open-questions.json").read_text())["questions"]
        qids = {q["id"] for q in questions}
        self.assertEqual(
            qids,
            {
                "search-as-viewfinder",
                "cad-star-as-favorite",
                "plus-keyline-mixed-toolbar",
                "density-12-link-branch",
            },
        )

    def test_exceptions_are_recorded(self):
        exceptions = json.loads((ROOT / "catalog/exceptions.json").read_text())
        self.assertIsInstance(exceptions, list)
        self.assertTrue(any(e["id"].startswith("warning-gap-") for e in exceptions))
        for e in exceptions:
            self.assertEqual(e["pack"], "technical")


class DistinctFromAngularTests(unittest.TestCase):
    def test_technical_paths_differ_from_angular(self):
        if not INV_PATH.exists():
            self.skipTest("generated inventory missing")
        ang_reg = json.loads((ANGULAR / "generated/registry.json").read_text())["paths"]
        tech_reg = json.loads((GEN / "registry.json").read_text())["paths"]
        for icon_id in IDS:
            for appearance in APPEARANCES:
                for n in MASTERS:
                    a = ang_reg[icon_id][appearance][str(n)]
                    b = tech_reg[icon_id][appearance][str(n)]
                    self.assertNotEqual(
                        a,
                        b,
                        "%s %s %s Technical path equals Angular — grammar failed" % (icon_id, appearance, n),
                    )


class AngularLockTests(unittest.TestCase):
    def test_angular_svg_hashes_unchanged(self):
        inv = json.loads((ANGULAR / "generated/inventory.json").read_text())
        for row in inv:
            path = ANGULAR / "generated" / row["path"]
            actual = hashlib.sha256(path.read_bytes()).hexdigest()
            self.assertEqual(actual, row["sha256"], row["path"])

    def test_pilot_did_not_add_technical_under_angular(self):
        self.assertFalse((ANGULAR / "generated/technical").exists())
        self.assertFalse((ANGULAR / "generated/rounded").exists())


class RebuildTests(unittest.TestCase):
    def test_rebuild_is_deterministic(self):
        if not INV_PATH.exists():
            self.skipTest("generated inventory missing")
        before = json.loads(INV_PATH.read_text())
        hashes = {r["path"]: r["sha256"] for r in before}
        from source.build import build

        build()
        after = json.loads(INV_PATH.read_text())
        self.assertEqual({r["path"]: r["sha256"] for r in after}, hashes)
        self.assertEqual(len(after), 72)
        for name in (
            "proof/contact-sheet.png",
            "proof/masters-12-4x.png",
            "proof/masters-16-4x.png",
            "proof/masters-24-4x.png",
            "proof/angular-vs-technical-24.png",
        ):
            self.assertTrue((ROOT / name).exists(), name)


if __name__ == "__main__":
    unittest.main(verbosity=2)
