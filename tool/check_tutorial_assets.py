"""Check the tutorial's recorded assets and downloadable source without extraction.

Run from any directory with Python 3; no third-party packages are required.
This verifies recorded evidence, not a fresh Flutter replay or visual review.
"""

import hashlib
import json
from pathlib import Path
import re
import zipfile

from prepare_docs_site import SOURCE_TAG


def check_sample_api(samples, prefix):
    """Catch an archived app using enum members absent from its installed API."""
    enums = {}
    paths = [name for name in samples.namelist()
             if name.startswith(prefix + "lib/ui/") and name.endswith(".dart")]
    for path in paths:
        for name, body in re.findall(r"enum (Acme\w+)\s*\{([^}]+)\}", samples.read(path).decode()):
            body = re.sub(r"//[^\n]*", "", body)
            enums[name] = set(re.findall(r"\b(\w+)\s*(?:,|$)", body.strip()))
    failures = []
    for path in samples.namelist():
        if not path.startswith(prefix) or not path.endswith(".dart") or "/lib/ui/" in path:
            continue
        for enum, member in re.findall(r"\b(Acme\w+)\.(\w+)", samples.read(path).decode()):
            if enum in enums and member not in enums[enum] | {"values"}:
                failures.append(f"{path}: {enum}.{member} is absent from the installed enum")
    return failures


def check_cli_sources(samples, receipt, replay):
    """Compare every installed Dart file with an independent fresh CLI receipt.

    The receipt is captured before app customization at the declared GitHub pin.
    Only the documented Vanilla medium-button height edit is reversible here.
    """
    failures = []
    for key, value in (("revision", replay["source_checkout"]),
                       ("cli", replay["cli"]), ("flutter", replay["flutter"]),
                       ("dart", replay["dart"])):
        if receipt.get(key) != value:
            failures.append(f"CLI source receipt {key} differs from replay evidence")
    actual = {name for name in samples.namelist()
              if re.match(r"(?:default|fortal)_demo/lib/ui/.*\.dart$", name)}
    expected = set(receipt["files"])
    if actual != expected:
        failures.append("Archived lib/ui file inventory differs from CLI output")
    for name in actual & expected:
        data = samples.read(name)
        edit = receipt.get("edits", {}).get(name)
        if edit:
            before, after = edit["from"].encode(), edit["to"].encode()
            if data.count(after) != 1:
                failures.append(f"{name}: documented CLI-source edit is absent or ambiguous")
                continue
            data = data.replace(after, before, 1)
        if hashlib.sha256(data).hexdigest() != receipt["files"][name]:
            failures.append(f"{name}: archived source differs from pinned CLI output")
    return failures


def check_assets(root):
    assets = root / "docs/assets/remix-cli-tutorial"
    evidence = json.loads((assets / "evidence.json").read_text())
    failures = []

    def check(label, data, expected):
        if hashlib.sha256(data).hexdigest() != expected:
            failures.append(f"{label}: SHA-256 differs from evidence.json")

    for screenshot in evidence["screenshots"]:
        data = (assets / screenshot["file"]).read_bytes()
        check(screenshot["file"], data, screenshot["sha256"])
        if len(data) != screenshot["bytes"]:
            failures.append(f"{screenshot['file']}: recorded size differs")

    archive = assets / "sample-projects.zip"
    check(archive.name, archive.read_bytes(), evidence["archive_sha256"])
    receipt_data = (assets / "cli-source-evidence.json").read_bytes()
    if "replay" in evidence:
        check("CLI source receipt", receipt_data, evidence["replay"]["cli_source_evidence_sha256"])
    with zipfile.ZipFile(archive) as samples:
        if "replay" in evidence:
            failures.extend(check_cli_sources(samples, json.loads(receipt_data), evidence["replay"]))
        for source in evidence["source"]:
            prefix = source["preset"] + "_demo/"
            failures.extend(check_sample_api(samples, prefix))
            if "replay" in evidence:
                toolchain = json.loads(samples.read(prefix + ".fvmrc"))
                if toolchain.get("flutter") != evidence["replay"]["flutter"]:
                    failures.append(f"{prefix}.fvmrc: SDK differs from replay evidence")
                config = samples.read(prefix + "remix.yaml").decode()
                revision = re.search(r'revision: "([a-f0-9]{40})"', config)
                if not revision or revision.group(1) != evidence["replay"]["source_checkout"]:
                    failures.append(f"{prefix}remix.yaml: revision differs from replay evidence")
            for path, key in (("lib/main.dart", "main_sha256"),
                              ("test/workflow_test.dart", "test_sha256")):
                check(prefix + path, samples.read(prefix + path), source[key])

    return failures


def check_content(root):
    failures = []
    recorded = json.loads((root / "docs/assets/remix-cli-tutorial/code-evidence.json").read_text())
    native = root / "docs/tutorials/settings-screen.mdx"
    source = native.read_text()
    blocks = re.findall(
        r"\{/\* tutorial-source: ([\w-]+) \*/\}\n\n```(\w+)\n([\s\S]*?)\n```",
        source,
    )
    if not blocks:
        failures.append("Native tutorial has no checked code blocks")
    if len(blocks) != len(re.findall(r"^```\w+", source, re.MULTILINE)):
        failures.append("Every native tutorial code block needs a tutorial-source marker")
    for block_id, language, code in blocks:
        expected = recorded.get(block_id, {})
        if expected.get("language") != language or expected.get("sha256") != hashlib.sha256(code.encode()).hexdigest():
            failures.append(f"Native tutorial code block {block_id} differs from recorded evidence")
    if {block[0] for block in blocks} != set(recorded):
        failures.append("Native tutorial is missing a recorded code block")
    expected_sources = {(preset, file) for preset in ["default", "fortal"]
                        for file in ["lib/main.dart", "test/workflow_test.dart"]}
    if set(SOURCE_TAG.findall(source)) != expected_sources:
        failures.append("Tutorial must include both complete applications and both test files")
    if "<TutorialSource" in SOURCE_TAG.sub("", source):
        failures.append("Unsupported tutorial source include")

    # Keep original capture provenance independent of the current replay pin.
    evidence = json.loads((root / "docs/assets/remix-cli-tutorial/evidence.json").read_text())
    # The commands and downloaded projects use the same reviewed revision.
    replay_pin = evidence["replay"]["source_checkout"]
    pin = re.search(r"git -C remix-review checkout ([a-f0-9]{40})", source)
    if not pin or pin.group(1) != replay_pin:
        failures.append("Native tutorial checkout pin differs from recorded evidence")

    registry_pins = re.findall(r"registry update @remix --ref ([a-f0-9]{40})", source)
    if registry_pins != [replay_pin] * 2:
        failures.append("Native tutorial registry command pins differ from replay evidence")

    for page in [native, root / "docs/index.mdx", root / "docs/getting-started.mdx",
                 root / "docs/guides/styling-components.mdx"]:
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


def main():
    root = Path(__file__).resolve().parents[1]
    failures = check_assets(root) + check_content(root)

    if failures:
        raise SystemExit("Tutorial asset drift:\n" + "\n".join(failures))
    print("Tutorial assets, pinned CLI source receipts, sample sources, code excerpts, pins, and content links passed.")


if __name__ == "__main__":
    main()
