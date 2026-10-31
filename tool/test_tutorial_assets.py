"""Regression tests for the recorded-evidence and documentation drift gate."""

import hashlib
import io
import json
from pathlib import Path
import shutil
import tempfile
import unittest

from check_tutorial_assets import check_assets, check_content, check_sample_api
from prepare_docs_site import expand_sources, prepare
import zipfile


class TutorialAssetTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        source = Path(__file__).resolve().parents[1]
        # Isolate mutations from the user's checkout and preserve real fixtures.
        shutil.copytree(source / "docs", self.root / "docs")

    def test_reviewed_content_and_assets_pass(self):
        self.assertEqual(check_assets(self.root) + check_content(self.root), [])

    def test_screenshot_corruption_fails(self):
        assets = self.root / "docs/assets/remix-cli-tutorial"
        evidence = json.loads((assets / "evidence.json").read_text())
        (assets / evidence["screenshots"][0]["file"]).write_bytes(b"changed")
        self.assertTrue(any("SHA-256 differs" in error for error in check_assets(self.root)))

    def test_archived_source_hash_drift_fails(self):
        path = self.root / "docs/assets/remix-cli-tutorial/evidence.json"
        evidence = json.loads(path.read_text())
        evidence["source"][0]["main_sha256"] = "0" * 64
        path.write_text(json.dumps(evidence))
        self.assertTrue(any("main.dart" in error for error in check_assets(self.root)))

    def test_unknown_accent_member_fails_independently_of_hashes(self):
        archive = self.root / "docs/assets/remix-cli-tutorial/sample-projects.zip"
        with zipfile.ZipFile(archive) as original:
            buffer = io.BytesIO()
            with zipfile.ZipFile(buffer, "w") as changed:
                for name in original.namelist():
                    data = original.read(name)
                    if name == "fortal_demo/lib/main.dart":
                        data = data.replace(b"AcmeAccentColor.mar", b"AcmeAccentColor.violet")
                    changed.writestr(name, data)
        with zipfile.ZipFile(buffer) as samples:
            self.assertTrue(any("AcmeAccentColor.violet" in error
                                for error in check_sample_api(samples, "fortal_demo/")))

    def test_historical_theme_constructor_drift_fails_after_rehashing_archive(self):
        archive = self.root / "docs/assets/remix-cli-tutorial/sample-projects.zip"
        buffer = io.BytesIO()
        with zipfile.ZipFile(archive) as original, zipfile.ZipFile(buffer, "w") as changed:
            for name in original.namelist():
                data = original.read(name)
                if name == "fortal_demo/lib/ui/theme/theme_scope.dart":
                    self.assertIn(b"this.theme,", data)
                    data = data.replace(b"this.theme,", b"required this.data,", 1)
                changed.writestr(name, data)
        archive.write_bytes(buffer.getvalue())
        evidence_path = archive.parent / "evidence.json"
        evidence = json.loads(evidence_path.read_text())
        evidence["archive_sha256"] = hashlib.sha256(buffer.getvalue()).hexdigest()
        evidence_path.write_text(json.dumps(evidence))
        failures = check_assets(self.root)
        self.assertTrue(any("theme_scope.dart" in error and "pinned CLI output" in error for error in failures))
        self.assertFalse(any("sample-projects.zip: SHA-256" in error for error in failures))

    def test_cli_source_receipt_must_use_replay_pin(self):
        assets = self.root / "docs/assets/remix-cli-tutorial"
        path = assets / "cli-source-evidence.json"
        receipt = json.loads(path.read_text())
        receipt["revision"] = "0" * 40
        path.write_text(json.dumps(receipt))
        evidence_path = assets / "evidence.json"
        evidence = json.loads(evidence_path.read_text())
        evidence["replay"]["cli_source_evidence_sha256"] = hashlib.sha256(path.read_bytes()).hexdigest()
        evidence_path.write_text(json.dumps(evidence))
        self.assertTrue(any("receipt revision" in error for error in check_assets(self.root)))

    def test_archived_sdk_pin_drift_fails(self):
        path = self.root / "docs/assets/remix-cli-tutorial/evidence.json"
        evidence = json.loads(path.read_text())
        evidence["replay"]["flutter"] = "3.47.9"
        path.write_text(json.dumps(evidence))
        self.assertTrue(any("SDK differs" in error for error in check_assets(self.root)))

    def test_native_command_drift_fails(self):
        path = self.root / "docs/tutorials/settings-screen.mdx"
        path.write_text(path.read_text().replace("--dry-run", "--overwrite"))
        self.assertTrue(any("code block" in error for error in check_content(self.root)))

    def test_missing_download_fails(self):
        (self.root / "docs/assets/remix-cli-tutorial/sample-projects.zip").unlink()
        self.assertTrue(any("sample-projects.zip" in error for error in check_content(self.root)))

    def test_no_excerpts_cannot_pass(self):
        path = self.root / "docs/tutorials/settings-screen.mdx"
        path.write_text("---\ntitle: Empty\n---\n")
        self.assertTrue(any("no checked code blocks" in error for error in check_content(self.root)))

    def test_unmarked_excerpt_fails(self):
        path = self.root / "docs/tutorials/settings-screen.mdx"
        path.write_text(path.read_text().replace("{/* tutorial-source: preview-button */}", ""))
        self.assertTrue(any("needs a tutorial-source marker" in error for error in check_content(self.root)))

    def test_capture_pin_drift_fails(self):
        path = self.root / "docs/assets/remix-cli-tutorial/evidence.json"
        evidence = json.loads(path.read_text())
        evidence.get("replay", evidence)["source_checkout"] = "0" * 40
        path.write_text(json.dumps(evidence))
        self.assertTrue(any("checkout pin" in error for error in check_content(self.root)))

    def test_missing_source_panel_fails(self):
        path = self.root / "docs/tutorials/settings-screen.mdx"
        path.write_text(path.read_text().replace('<TutorialSource preset="default" file="lib/main.dart" />', ''))
        self.assertTrue(any("both complete applications" in error for error in check_content(self.root)))

    def test_panels_use_exact_downloaded_source(self):
        with zipfile.ZipFile(self.root / "docs/assets/remix-cli-tutorial/sample-projects.zip") as archive:
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
        page = self.root / "docs/tutorials/settings-screen.mdx"
        before = page.read_bytes()
        prepare(self.root)
        staged = self.root / "apps/docs/.generated/content/tutorials/settings-screen.mdx"
        first = staged.read_bytes()
        prepare(self.root)
        self.assertEqual(staged.read_bytes(), first)
        self.assertEqual(page.read_bytes(), before)
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


if __name__ == "__main__":
    unittest.main()
