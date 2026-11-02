"""Unit tests for the remix_ui_icons generator's rules.

    uv run --frozen --project packages/remix_ui_icons/tool/icons \\
        python -m unittest discover -s packages/remix_ui_icons/tool/icons -p 'test_*.py'
"""

from __future__ import annotations

import copy
import tempfile
import unittest
from dataclasses import replace
from pathlib import Path

import check
import codegen
import lock
from manifest import ManifestError, Reserved, _validate_members, load_manifest
from sources import Source, SourceError, validate_svg

MANIFEST = load_manifest()

SVG = (
    '<svg xmlns="http://www.w3.org/2000/svg" width="{size}" height="{size}" '
    'viewBox="0 0 {size} {size}" fill="currentColor" fill-rule="evenodd" role="img" '
    'focusable="false"><title>T</title><path d="{d}"{extra}/></svg>'
)


def _svg(d: str = "M1 1L5 1L5 5Z", size: int = 24, extra: str = "") -> bytes:
    return SVG.format(size=size, d=d, extra=extra).encode("utf-8")


def _sources(manifest=MANIFEST):
    return [Source(glyph, Path(glyph.source), _svg(size=glyph.master)) for glyph in manifest.glyphs]


class SvgValidationTest(unittest.TestCase):
    def validate(self, data: bytes, master: int = 24) -> None:
        with tempfile.NamedTemporaryFile(suffix=".svg") as file:
            file.write(data)
            file.flush()
            validate_svg(Path(file.name), master)

    def test_accepts_a_filled_closed_path(self) -> None:
        self.validate(_svg("M1 1L5 1L5 5ZM6 6L8 6L8 8Z"))

    def test_rejects_a_stroke(self) -> None:
        with self.assertRaisesRegex(SourceError, "may only carry d"):
            self.validate(_svg(extra=' stroke="currentColor"'))

    def test_rejects_an_open_subpath(self) -> None:
        with self.assertRaisesRegex(SourceError, "must end with Z"):
            self.validate(_svg("M1 1L5 1L5 5M6 6L8 6L8 8Z"))
        with self.assertRaisesRegex(SourceError, "last subpath"):
            self.validate(_svg("M1 1L5 1L5 5"))

    def test_rejects_a_viewbox_from_another_master(self) -> None:
        with self.assertRaisesRegex(SourceError, "viewBox"):
            self.validate(_svg(size=16), master=24)

    def test_rejects_another_paint(self) -> None:
        with self.assertRaisesRegex(SourceError, "currentColor"):
            self.validate(_svg().replace(b'fill="currentColor"', b'fill="#000"'))
        with self.assertRaisesRegex(SourceError, "may only carry d"):
            self.validate(_svg(extra=' fill="red"'))


class LockTest(unittest.TestCase):
    def test_assigns_new_glyphs_in_manifest_order_from_the_start(self) -> None:
        seeded = lock.seed(MANIFEST, _sources(), None)
        codepoints = lock.codepoints(seeded)
        ordered = [codepoints[glyph.source] for glyph in MANIFEST.glyphs]
        self.assertEqual(ordered, list(range(0xE200, 0xE368)) + list(range(0xE3B0, 0xE5E4)))
        self.assertEqual(lock.check(MANIFEST, seeded), [])

    def test_keeps_assignments_and_appends_above_everything_assigned(self) -> None:
        seeded = lock.seed(MANIFEST, _sources(), None)
        # Retire the first glyph: its codepoint must never be reused.
        retired_source = MANIFEST.glyphs[0].source
        glyphs = [glyph for glyph in seeded["glyphs"] if glyph["source"] != retired_source]
        retired = [glyph for glyph in seeded["glyphs"] if glyph["source"] == retired_source]
        previous = {**seeded, "glyphs": glyphs, "retired": retired}
        reseeded = lock.seed(MANIFEST, _sources(), previous)
        # The manifest still lists it, so it comes back at its old codepoint.
        self.assertEqual(lock.codepoints(reseeded), lock.codepoints(seeded))
        self.assertEqual(reseeded["retired"], [])

        dropped = [source for source in _sources() if source.glyph.source != retired_source]
        later = lock.seed(MANIFEST, dropped, seeded)
        self.assertEqual([glyph["source"] for glyph in later["retired"]], [retired_source])
        self.assertNotIn(retired_source, lock.codepoints(later))

    def test_new_glyphs_skip_reserved_ranges(self) -> None:
        manifest = replace(
            MANIFEST,
            reserved=(*MANIFEST.reserved, Reserved(0xE200, 0xE20F, "test")),
        )
        seeded = lock.seed(manifest, _sources(manifest), None)
        self.assertEqual(min(lock.codepoints(seeded).values()), 0xE210)

    def test_reports_a_deleted_or_moved_entry(self) -> None:
        base = lock.seed(MANIFEST, _sources(), None)
        current = copy.deepcopy(base)
        moved = current["glyphs"][0]
        moved["codepoint"] = "0xE3FF"
        deleted = current["glyphs"].pop(1)
        problems = lock.check(MANIFEST, current, base)
        self.assertTrue(any("moved from" in problem and moved["source"] in problem for problem in problems))
        self.assertTrue(any("was deleted" in problem and deleted["source"] in problem for problem in problems))

    def test_reports_duplicate_and_reserved_codepoints(self) -> None:
        current = lock.seed(MANIFEST, _sources(), None)
        current["glyphs"][1]["codepoint"] = current["glyphs"][0]["codepoint"]
        current["glyphs"][2]["codepoint"] = "0xE001"
        problems = lock.check(MANIFEST, current)
        self.assertTrue(any("assigned to both" in problem for problem in problems))
        self.assertTrue(any("reserved codepoint 0xE001" in problem for problem in problems))

    def test_refuses_to_rename_a_locked_glyph(self) -> None:
        seeded = lock.seed(MANIFEST, _sources(), None)
        seeded["glyphs"][0]["name"] = "outlineSomethingElse"
        with self.assertRaisesRegex(lock.LockError, "A rename is a new glyph"):
            lock.seed(MANIFEST, _sources(), seeded)


class ManifestTest(unittest.TestCase):
    def test_counts(self) -> None:
        self.assertEqual(len(MANIFEST.glyphs), 924)
        self.assertEqual(len(MANIFEST.legacy), 318)
        self.assertEqual(len(MANIFEST.deprecated_aliases), 31)
        statuses = [icon.status for icon in MANIFEST.legacy]
        self.assertEqual(
            (statuses.count("exact"), statuses.count("partial"), statuses.count("removed")),
            (76, 25, 217),
        )

    def test_member_names_follow_the_suffix_convention(self) -> None:
        members = [glyph.member for glyph in MANIFEST.glyphs_of(MANIFEST.default_family)][:6]
        self.assertEqual(members, ["home", "homeFilled", "home16", "homeFilled16", "home12", "homeFilled12"])

    def test_a_surviving_old_name_must_keep_its_meaning(self) -> None:
        legacy = list(MANIFEST.legacy)
        index = next(i for i, icon in enumerate(legacy) if icon.name == "check")
        legacy[index] = replace(legacy[index], status="partial", target="close", note="x")
        with self.assertRaisesRegex(ManifestError, "collides with the new RemixIcons.check"):
            _validate_members(replace(MANIFEST, legacy=tuple(legacy)))


class CodegenTest(unittest.TestCase):
    def test_calls_fit_on_one_line_or_split_one_argument_per_line(self) -> None:
        self.assertEqual(codegen._call("  ", "f", ["a", "b"], ";"), "  f(a, b);\n")
        long = codegen._call("  ", "static const IconData x = IconData", ["0xE200", "fontFamily: f" * 5], ";")
        self.assertTrue(long.endswith("  );\n"))
        self.assertIn("    0xE200,\n", long)

    def test_assignments_split_after_the_equals_sign(self) -> None:
        self.assertEqual(
            codegen._assignment("  ", "static const IconData arrowUpRightFilled12", "OutlineIcons.arrowUpRightFilled12"),
            "  static const IconData arrowUpRightFilled12 =\n      OutlineIcons.arrowUpRightFilled12;\n",
        )

    def test_public_api_lists_every_constant_and_alias(self) -> None:
        api = codegen.public_api(MANIFEST)
        self.assertIn("RemixIcons.magnifyingGlass", api)
        self.assertIn("RoundedIcons.starFilled12", api)
        self.assertIn("OutlineIconSets.searchFilled", api)
        self.assertEqual(len(api), len(set(api)))


class ApiGateTest(unittest.TestCase):
    def test_breaking_versions(self) -> None:
        self.assertTrue(check.is_breaking("0.1.0", "1.0.0-beta.1"))
        self.assertTrue(check.is_breaking("0.1.0", "0.2.0"))
        self.assertFalse(check.is_breaking("0.1.0", "0.1.1"))
        self.assertTrue(check.is_breaking("1.0.0", "2.0.0"))
        self.assertFalse(check.is_breaking("1.0.0-beta.1", "1.0.0"))
        self.assertFalse(check.is_breaking("1.0.0", "1.4.0"))


if __name__ == "__main__":
    unittest.main()
