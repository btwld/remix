"""Check the tutorial's served assets and downloadable samples against replay evidence.

Run from any directory with Python 3; no third-party packages are required.
`tool/replay_tutorial.py` writes `tool/tutorial_evidence.json`; this checker
verifies recorded evidence, not a fresh Flutter replay or visual review.
"""

import json
from pathlib import Path
import re
import zipfile

from prepare_docs_site import SOURCE_TAG
from replay_tutorial import (ARCHIVE, ASSETS, DART_FLOOR, EVIDENCE, FLUTTER_FLOOR, TUTORIAL,
                             sha256, tutorial_blocks)

IMAGE = re.compile(r"\(/assets/remix-cli-tutorial/([\w.-]+\.png)\)")
CHECKOUT_INSTALL_PHRASES = ["/path/to/remix", "git clone", "pubspec_overrides.yaml"]
STATED_FLOOR = f"Flutter {FLUTTER_FLOOR} or newer, which bundles Dart {DART_FLOOR}"


def check_sample_api(samples, prefix):
    enums = {}
    paths = [name for name in samples.namelist()
             if name.startswith(prefix + "lib/ui/") and name.endswith(".dart")]
    for path in paths:
        for name, body in re.findall(r"enum (Acme\w+)\s*\{([^}]+)\}", samples.read(path).decode()):
            # Enhanced enums end their value list at `;` and may pass arguments.
            values = re.sub(r"\([^)]*\)", "", re.sub(r"//[^\n]*", "", body).split(";", 1)[0])
            enums[name] = {value.split()[-1] for value in values.split(",") if value.strip()}
    failures = []
    for path in samples.namelist():
        if not path.startswith(prefix) or not path.endswith(".dart") or "/lib/ui/" in path:
            continue
        for enum, member in re.findall(r"\b(Acme\w+)\.(\w+)", samples.read(path).decode()):
            if enum in enums and member not in enums[enum] | {"values"}:
                failures.append(f"{path}: {enum}.{member} is absent from the installed enum")
    return failures


def check_cli_sources(samples, cli_sources):
    failures = []
    actual = {name for name in samples.namelist()
              if re.match(r"(?:default|fortal)_demo/lib/ui/.*\.dart$", name)}
    expected = set(cli_sources["files"])
    if actual != expected:
        failures.append("Archived lib/ui file inventory differs from CLI output")
    for name in sorted(actual & expected):
        data = samples.read(name)
        edit = cli_sources["edits"].get(name)
        if edit:
            before, after = edit["from"].encode(), edit["to"].encode()
            if data.count(after) != 1:
                failures.append(f"{name}: recorded edit is absent or ambiguous")
                continue
            data = data.replace(after, before, 1)
        if sha256(data) != cli_sources["files"][name]:
            failures.append(f"{name}: archived source differs from CLI output")
    return failures


def check_sample(samples, source, replay):
    prefix = source["preset"] + "_demo/"
    failures = check_sample_api(samples, prefix)
    config = samples.read(prefix + "remix.yaml").decode()
    revision = re.search(r'revision: "([a-f0-9]{40})"', config)
    if not revision or revision.group(1) != replay["registry_revision"]:
        failures.append(f"{prefix}remix.yaml: revision differs from replay evidence")
    pubspec = samples.read(prefix + "pubspec.yaml").decode()
    if re.search(r"^\s+path:", pubspec, re.MULTILINE):
        failures.append(f"{prefix}pubspec.yaml: path dependency cannot resolve for readers")
    sdk = re.search(r"^environment:\n  sdk: (\S+)", pubspec, re.MULTILINE)
    if not sdk or sdk.group(1) != replay["sdk_floor"]:
        failures.append(f"{prefix}pubspec.yaml: sdk constraint differs from the documented floor")
    for path, key in (("lib/main.dart", "main_sha256"),
                      ("test/workflow_test.dart", "test_sha256"),
                      ("test/theme_modes_test.dart", "theme_test_sha256")):
        if sha256(samples.read(prefix + path)) != source[key]:
            failures.append(f"{prefix}{path}: SHA-256 differs from evidence")
    return failures


def check_assets(root):
    assets = root / ASSETS
    evidence = json.loads((root / EVIDENCE).read_text())
    failures = []

    recorded = {screenshot["file"] for screenshot in evidence["screenshots"]}
    served = {path.name for path in assets.iterdir()}
    pngs = {name for name in served if name.endswith(".png")}
    if served - pngs - {ARCHIVE}:
        failures.append(f"{ASSETS} may only serve PNG screenshots and {ARCHIVE}")
    if pngs != recorded:
        failures.append(f"{ASSETS}: PNG files differ from evidence screenshots")
    if set(IMAGE.findall((root / TUTORIAL).read_text())) != recorded:
        failures.append("Tutorial image references differ from evidence screenshots")
    for screenshot in evidence["screenshots"]:
        path = assets / screenshot["file"]
        if not path.is_file():
            continue
        data = path.read_bytes()
        if sha256(data) != screenshot["sha256"]:
            failures.append(f"{screenshot['file']}: SHA-256 differs from evidence")
        if len(data) != screenshot["bytes"]:
            failures.append(f"{screenshot['file']}: recorded size differs")

    archive = assets / ARCHIVE
    if sha256(archive.read_bytes()) != evidence["archive_sha256"]:
        failures.append(f"{ARCHIVE}: SHA-256 differs from evidence")
    with zipfile.ZipFile(archive) as samples:
        if any(name.endswith("pubspec_overrides.yaml") for name in samples.namelist()):
            failures.append(f"{ARCHIVE}: pubspec_overrides.yaml would replace hosted packages")
        failures.extend(check_cli_sources(samples, evidence["cli_sources"]))
        for source in evidence["source"]:
            failures.extend(check_sample(samples, source, evidence["replay"]))
    return failures


def check_links(root, page):
    failures = []
    for href in re.findall(r"\]\((/[^)]+)\)", page.read_text()):
        path = href.split("#", 1)[0].split("?", 1)[0]
        target = root / "docs" / path.lstrip("/")
        if path == "/":
            target = target / "index.mdx"
        elif not target.suffix:
            target = target.with_suffix(".mdx")
        if not target.is_file():
            failures.append(f"{page.relative_to(root)}: missing link target {href}")
    return failures


def check_content(root):
    failures = []
    evidence = json.loads((root / EVIDENCE).read_text())
    recorded = evidence["code_blocks"]
    native = root / TUTORIAL
    source = native.read_text()
    blocks = tutorial_blocks(source)
    if not blocks:
        failures.append("Native tutorial has no checked code blocks")
    if len(blocks) != len(re.findall(r"^```\w+", source, re.MULTILINE)):
        failures.append("Every native tutorial code block needs a tutorial-source marker")
    for block_id, language, code in blocks:
        expected = recorded.get(block_id, {})
        if expected.get("language") != language or expected.get("sha256") != sha256(code.encode()):
            failures.append(f"Native tutorial code block {block_id} differs from recorded evidence")
    if {block[0] for block in blocks} != set(recorded):
        failures.append("Native tutorial is missing a recorded code block")
    first = {block_id: code for block_id, _, code in blocks}.get("first-main", "")
    if sha256((first + "\n").encode()) != evidence["first_render_source_sha256"]:
        failures.append("First-render source differs from the captured application")
    expected_sources = {(preset, file) for preset in ["default", "fortal"]
                        for file in ["lib/main.dart", "test/workflow_test.dart"]}
    if set(SOURCE_TAG.findall(source)) != expected_sources:
        failures.append("Tutorial must include both complete applications and both test files")
    if "<TutorialSource" in SOURCE_TAG.sub("", source):
        failures.append("Unsupported tutorial source include")

    getting_started = root / "docs/getting-started.mdx"
    for page in [native, getting_started]:
        text = page.read_text()
        for phrase in CHECKOUT_INSTALL_PHRASES:
            if phrase in text:
                failures.append(f"{page.relative_to(root)}: checkout install step {phrase!r}")
        if STATED_FLOOR not in text:
            failures.append(f"{page.relative_to(root)}: SDK floor differs from the replay tool")
    for page in [native, root / "docs/index.mdx", getting_started,
                 root / "docs/guides/styling-components.mdx"]:
        failures.extend(check_links(root, page))
    return failures


def main():
    root = Path(__file__).resolve().parents[1]
    failures = check_assets(root) + check_content(root)

    if failures:
        raise SystemExit("Tutorial asset drift:\n" + "\n".join(failures))
    print("Tutorial screenshots, sample archive, CLI sources, code excerpts, and content links passed.")


if __name__ == "__main__":
    main()
