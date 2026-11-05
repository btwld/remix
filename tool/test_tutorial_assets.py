import hashlib
import io
import json
from pathlib import Path
import re
import shutil
import tempfile
import unittest
import zipfile

from check_tutorial_assets import check_assets, check_content, check_sample_api
from prepare_docs_site import expand_sources, prepare
from replay_tutorial import ARCHIVE, ASSETS, EVIDENCE, TUTORIAL


class TutorialAssetTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        source = Path(__file__).resolve().parents[1]
        shutil.copytree(source / "docs", self.root / "docs")
        (self.root / "tool").mkdir()
        shutil.copytree(source / "tool/tutorial_samples", self.root / "tool/tutorial_samples")
        shutil.copyfile(source / EVIDENCE, self.root / EVIDENCE)
        self.assets = self.root / ASSETS
        self.archive = self.assets / ARCHIVE
        self.tutorial = self.root / TUTORIAL

    def edit_evidence(self, change):
        path = self.root / EVIDENCE
        evidence = json.loads(path.read_text())
        change(evidence)
        path.write_text(json.dumps(evidence))

    def rewrite_archive(self, change, extra=None):
        buffer = io.BytesIO()
        with zipfile.ZipFile(self.archive) as original, zipfile.ZipFile(buffer, "w") as changed:
            for name in original.namelist():
                changed.writestr(name, change(name, original.read(name)))
            for name, data in (extra or {}).items():
                changed.writestr(name, data)
        self.archive.write_bytes(buffer.getvalue())
        digest = hashlib.sha256(buffer.getvalue()).hexdigest()
        self.edit_evidence(lambda evidence: evidence.update(archive_sha256=digest))

    def assertFailure(self, failures, fragment):
        self.assertTrue(any(fragment in error for error in failures), failures)

    def test_reviewed_content_and_assets_pass(self):
        self.assertEqual(check_assets(self.root) + check_content(self.root), [])

    def test_screenshot_corruption_fails(self):
        evidence = json.loads((self.root / EVIDENCE).read_text())
        (self.assets / evidence["screenshots"][0]["file"]).write_bytes(b"changed")
        self.assertFailure(check_assets(self.root), "SHA-256 differs")

    def test_authored_tree_drift_fails(self):
        path = self.root / "tool/tutorial_samples/default/lib/main.dart"
        path.write_bytes(path.read_bytes() + b"\n")
        self.assertFailure(check_assets(self.root),
                           "tool/tutorial_samples/default/lib/main.dart differs")

    def test_archived_source_hash_drift_fails(self):
        self.edit_evidence(lambda evidence: evidence["source"][0].update(main_sha256="0" * 64))
        self.assertFailure(check_assets(self.root), "main.dart")

    def test_unknown_accent_member_fails_independently_of_hashes(self):
        with zipfile.ZipFile(self.archive) as original:
            buffer = io.BytesIO()
            with zipfile.ZipFile(buffer, "w") as changed:
                for name in original.namelist():
                    data = original.read(name)
                    if name == "fortal_demo/lib/main.dart":
                        data = data.replace(b"AcmeAccentColor.mar", b"AcmeAccentColor.violet")
                    changed.writestr(name, data)
        with zipfile.ZipFile(buffer) as samples:
            self.assertFailure(check_sample_api(samples, "fortal_demo/"), "AcmeAccentColor.violet")

    def test_enhanced_enum_values_are_installed_api(self):
        buffer = io.BytesIO()
        with zipfile.ZipFile(buffer, "w") as changed:
            changed.writestr("fortal_demo/lib/ui/theme/theme_data.dart",
                             "enum AcmeScaling {\n  @Deprecated('x') small(0.9),\n  large(1.1);\n\n"
                             "  static const medium = small;\n}\n")
            changed.writestr("fortal_demo/test/scale_test.dart",
                             "final a = AcmeScaling.small; final b = AcmeScaling.large; final c = AcmeScaling.huge;")
        with zipfile.ZipFile(buffer) as samples:
            failures = check_sample_api(samples, "fortal_demo/")
        self.assertEqual(failures, ["fortal_demo/test/scale_test.dart: AcmeScaling.huge is absent from the installed enum"])

    def test_theme_constructor_drift_fails_after_rehashing_archive(self):
        def change(name, data):
            if name == "fortal_demo/lib/ui/theme/theme_scope.dart":
                self.assertIn(b"this.theme,", data)
                return data.replace(b"this.theme,", b"required this.data,", 1)
            return data
        self.rewrite_archive(change)
        failures = check_assets(self.root)
        self.assertFailure(failures, "theme_scope.dart: archived source differs from CLI output")
        self.assertFalse(any(f"{ARCHIVE}: SHA-256" in error for error in failures))

    def test_registry_revision_drift_fails(self):
        self.edit_evidence(lambda evidence: evidence["replay"].update(registry_revision="0" * 40))
        self.assertFailure(check_assets(self.root), "remix.yaml: revision differs")

    def test_sdk_floor_drift_fails(self):
        self.edit_evidence(lambda evidence: evidence["replay"].update(sdk_floor="^3.13.7"))
        self.assertFailure(check_assets(self.root), "sdk constraint differs from the documented floor")

    def test_overrides_file_in_archive_fails(self):
        overrides = b"dependency_overrides:\n  remix:\n    path: ../remix\n"
        self.rewrite_archive(lambda name, data: data,
                             {"default_demo/pubspec_overrides.yaml": overrides})
        self.assertFailure(check_assets(self.root), "pubspec_overrides.yaml")

    def test_path_dependency_fails(self):
        def change(name, data):
            if name == "fortal_demo/pubspec.yaml":
                changed = re.sub(rb"remix_cli: \S+", b"remix_cli:\n    path: ../remix_cli", data)
                self.assertNotEqual(changed, data)
                return changed
            return data
        self.rewrite_archive(change)
        self.assertFailure(check_assets(self.root), "fortal_demo/pubspec.yaml: path dependency")

    def test_stray_json_in_served_assets_fails(self):
        (self.assets / "evidence.json").write_text("{}")
        self.assertFailure(check_assets(self.root), "may only serve PNG screenshots")

    def test_unrecorded_screenshot_fails(self):
        (self.assets / "extra.png").write_bytes(b"png")
        self.assertFailure(check_assets(self.root), "PNG files differ from evidence")

    def test_unreferenced_screenshot_fails(self):
        text = self.tutorial.read_text()
        changed = re.sub(r"!\[[^\]]*\]\(/assets/remix-cli-tutorial/saved\.png\)\n", "", text)
        self.assertNotEqual(changed, text)
        self.tutorial.write_text(changed)
        self.assertFailure(check_assets(self.root), "image references differ")

    def test_native_command_drift_fails(self):
        self.tutorial.write_text(self.tutorial.read_text().replace("--dry-run", "--overwrite"))
        self.assertFailure(check_content(self.root), "code block")

    def test_first_render_source_drift_fails(self):
        self.edit_evidence(lambda evidence: evidence.update(first_render_source_sha256="0" * 64))
        self.assertFailure(check_content(self.root), "First-render source")

    def test_checkout_install_phrase_fails(self):
        for page, phrase in [("docs/getting-started.mdx", "git clone"),
                             (TUTORIAL, "/path/to/remix"),
                             (TUTORIAL, "pubspec_overrides.yaml")]:
            with self.subTest(page=page, phrase=phrase):
                path = self.root / page
                original = path.read_text()
                path.write_text(original + f"\nRun `{phrase}` first.\n")
                self.assertFailure(check_content(self.root), f"checkout install step {phrase!r}")
                path.write_text(original)

    def test_sdk_floor_statement_drift_fails(self):
        path = self.root / "docs/getting-started.mdx"
        path.write_text(path.read_text().replace("Flutter 3.44 or newer", "Flutter 3.47 or newer"))
        self.assertFailure(check_content(self.root), "getting-started.mdx: SDK floor differs")

    def test_missing_download_fails(self):
        self.archive.unlink()
        self.assertFailure(check_content(self.root), ARCHIVE)

    def test_no_excerpts_cannot_pass(self):
        self.tutorial.write_text("---\ntitle: Empty\n---\n")
        self.assertFailure(check_content(self.root), "no checked code blocks")

    def test_unmarked_excerpt_fails(self):
        self.tutorial.write_text(
            self.tutorial.read_text().replace("{/* tutorial-source: preview-button */}", ""))
        self.assertFailure(check_content(self.root), "needs a tutorial-source marker")

    def test_missing_source_panel_fails(self):
        self.tutorial.write_text(self.tutorial.read_text().replace(
            '<TutorialSource preset="default" file="lib/main.dart" />', ''))
        self.assertFailure(check_content(self.root), "both complete applications")

    def test_panels_use_exact_downloaded_source(self):
        with zipfile.ZipFile(self.archive) as archive:
            for preset in ["default", "fortal"]:
                for file in ["lib/main.dart", "test/workflow_test.dart"]:
                    rendered = expand_sources(f'<TutorialSource preset="{preset}" file="{file}" />', archive)
                    self.assertIn(archive.read(f"{preset}_demo/{file}").decode().rstrip("\n"), rendered)
                    self.assertTrue(rendered.startswith('```dart title='))

    def test_unknown_source_include_is_rejected(self):
        with self.assertRaises(ValueError):
            expand_sources('<TutorialSource preset="default" file="../../secrets" />', None)

    def test_staging_is_repeatable_and_preserves_authoring_source(self):
        source = Path(__file__).resolve().parents[1]
        shutil.copyfile(source / "docs.json", self.root / "docs.json")
        shutil.copytree(source / "apps/demo/lib/components", self.root / "apps/demo/lib/components")
        before = self.tutorial.read_bytes()
        prepare(self.root)
        staged = self.root / "apps/docs/.generated/content/tutorials/settings-screen.mdx"
        first = staged.read_bytes()
        prepare(self.root)
        self.assertEqual(staged.read_bytes(), first)
        self.assertEqual(self.tutorial.read_bytes(), before)
        self.assertNotIn(b"<TutorialSource", first)
        self.assertIn(b"class _WorkspacePageState", first)
        button = (staged.parents[1] / "components/button.mdx").read_text()
        self.assertIn('title="Button" cases=', button)
        self.assertIn('<Tab value="Preview" keepMounted>', button)
        self.assertIn((source / "apps/demo/lib/components/button.dart").read_text().rstrip(), button)
        navigation = json.loads((self.root / "apps/docs/.generated/content/meta.json").read_text())
        # Explicit links keep the overview separate from its same-named folder.
        sidebar = json.loads((self.root / "docs.json").read_text())["sidebar"]
        all_links = list(navigation["pages"])
        for folder in staged.parents[1].glob("nav-*/meta.json"):
            category = json.loads(folder.read_text())
            self.assertFalse(category["defaultOpen"])
            self.assertIn(folder.parent.name, navigation["pages"])
            all_links.extend(category["pages"])
        for group in sidebar:
            for item in group["pages"]:
                self.assertEqual(all_links.count(f"[{item['title']}]({item['href']})"), 1)
        self.assertFalse((self.root / "apps/docs/public/assets/remix-cli-tutorial/tutorial.js").exists())
        served = self.root / "apps/docs/public/assets/remix-cli-tutorial"
        self.assertEqual([path.name for path in served.glob("*.json")], [])


if __name__ == "__main__":
    unittest.main()
