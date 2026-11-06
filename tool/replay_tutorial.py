"""Replay the settings tutorial on a real Flutter SDK and regenerate its assets.

    python3 tool/replay_tutorial.py --flutter <path/to/flutter> [--work <dir>] [--skip-web-build]

Stdlib only. Network access and PUB_CACHE come from the caller's environment.
Every marked block of docs/tutorials/settings-screen.mdx runs in tutorial
order, in fresh projects that install hosted packages. The replay writes:

- docs/assets/remix-cli-tutorial/*.png, the screenshots the tutorial shows;
- docs/assets/remix-cli-tutorial/sample-projects.zip, both finished samples;
- tool/tutorial_evidence.json, which tool/check_tutorial_assets.py verifies.

Authored application files (lib/main.dart and both test files per sample)
are inputs in tool/tutorial_samples. The replay copies them into the sample
projects and the archive. To change the samples, edit the tutorial or an
authored file and rerun; never hand-edit evidence.

Evidence shape:

    replay: {date, flutter, dart, remix, remix_cli, remix_ui_fonts,
             registry_revision, sdk_floor, host, web_build}
    archive_sha256: str
    screenshots: [{file, sha256, bytes, scene}]
    source: [{preset, main_sha256, test_sha256, theme_test_sha256}]
    first_render_source_sha256: str, the lib/main.dart written from first-main
    code_blocks: {block id: {language, sha256}}
    cli_sources: {files: {archive path: sha256 of lib/ui before customization},
                  edits: {archive path: {from, to}}}
    commands: [{block, label, directory, exit_code}], exit_code null when skipped
"""

import argparse
import collections
import datetime
import hashlib
import io
import json
import os
from pathlib import Path
import platform
import re
import shutil
import subprocess
import tempfile
import zipfile

ROOT = Path(__file__).resolve().parents[1]
ASSETS = "docs/assets/remix-cli-tutorial"
EVIDENCE = "tool/tutorial_evidence.json"
TUTORIAL = "docs/tutorials/settings-screen.mdx"
ARCHIVE = "sample-projects.zip"
CAPTURE = ROOT / "tool/tutorial_capture"
BLOCK = re.compile(r"\{/\* tutorial-source: ([\w-]+) \*/\}\n\n```(\w+)\n([\s\S]*?)\n```")

FLUTTER_FLOOR = "3.44"
DART_FLOOR = "3.12"
SDK_FLOOR = f"^{DART_FLOOR}.0"
SAMPLES = {"default": "remix_default_demo", "fortal": "remix_fortal_demo"}
AUTHORED = ["lib/main.dart", "test/workflow_test.dart", "test/theme_modes_test.dart"]
AUTHORED_ROOT = Path("tool/tutorial_samples")
ARCHIVED_FILES = [".gitignore", ".metadata", "analysis_options.yaml", "pubspec.lock",
                  "pubspec.yaml", "remix.ownership.json", "remix.yaml"]
ARCHIVED_DIRS = ["lib", "test", "web"]
BUTTON = "lib/ui/components/button.dart"
BUTTON_EDIT = ("minHeight: AcmeTokens.controlMd,", "minHeight: 44.0,")
Screenshot = collections.namedtuple("Screenshot", "preset harness scene description")
SCREENSHOTS = {
    "first-render.png": Screenshot("default", "first_render_test.dart", "first",
                                   "first-main AcmeApp on the Vanilla light theme"),
    "launchpad-vanilla.png": Screenshot("default", "launchpad_test.dart", "launchpad",
                                        "Vanilla SampleApp, initial light state, "
                                        "44-pixel medium Button"),
    "saved.png": Screenshot("default", "launchpad_test.dart", "saved",
                            "Vanilla after entering Launchpad Studio, clearing the weekly "
                            "summary, and one completed save"),
    "launchpad-fortal-dark.png": Screenshot("fortal", "launchpad_test.dart", "dark",
                                            "Fortal SampleApp, Mar accent, after Use dark theme"),
}
Block = collections.namedtuple("Block", "id language code")


def sha256(data):
    return hashlib.sha256(data).hexdigest()


def tutorial_blocks(source):
    return [Block(*match) for match in BLOCK.findall(source)]


def archive_path(preset, relative):
    return f"{preset}_demo/{Path(relative).as_posix()}"


def read_authored(root=ROOT):
    return {(preset, path): (root / AUTHORED_ROOT / preset / path).read_bytes()
            for preset in SAMPLES for path in AUTHORED}


class Replay:
    def __init__(self, flutter, work, skip_web_build):
        self.work = work
        self.cwd = work
        self.skip_web_build = skip_web_build
        self.env = {**os.environ, "CI": "true",
                    "PATH": f"{flutter.parent}{os.pathsep}{os.environ.get('PATH', '')}"}
        self.authored = read_authored()
        self.log = work / "replay.log"
        self.commands = []
        self.cli_files = {}
        self.edits = {}
        self.screenshots = {}
        self.first_render_sha256 = None

    def sample(self, preset):
        return self.work / SAMPLES[preset]

    def record(self, block, label, cwd, exit_code):
        directory = os.path.relpath(cwd, self.work)
        self.commands.append({"block": block, "label": label, "directory": directory,
                              "exit_code": exit_code})
        print(f"[{block}] {directory}$ {label} -> {exit_code}", flush=True)

    def run(self, block, line, cwd):
        result = subprocess.run(["bash", "-c", line], cwd=cwd, env=self.env, text=True,
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        with self.log.open("a") as log:
            log.write(f"\n$ {line}  # {cwd}\n{result.stdout}")
        self.record(block, line, cwd, result.returncode)
        if result.returncode:
            raise SystemExit(f"{line} failed in {cwd}:\n{result.stdout}")
        return result.stdout

    def run_lines(self, block, code, cwd):
        for line in filter(None, map(str.strip, code.splitlines())):
            skipped = line.startswith("flutter run") or (
                self.skip_web_build and line.startswith("flutter build web"))
            if skipped:
                self.record(block, line, cwd, None)
            elif line.startswith("cd "):
                target = (cwd / line[3:]).resolve()
                if not target.is_dir():
                    raise SystemExit(f"{line}: no such directory from {cwd}")
                self.record(block, line, cwd, 0)
                cwd = target
            else:
                self.run(block, line, cwd)
        return cwd

    def author(self, preset, path):
        target = self.sample(preset) / path
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(self.authored[(preset, path)])

    def record_cli_output(self, preset):
        sample = self.sample(preset)
        for path in sorted((sample / "lib/ui").rglob("*.dart")):
            self.cli_files[archive_path(preset, path.relative_to(sample))] = sha256(path.read_bytes())

    def capture(self, file):
        shot = SCREENSHOTS[file]
        sample = self.sample(shot.preset)
        tests = sample / "test"
        created = not tests.exists()
        tests.mkdir(exist_ok=True)
        copies = [tests / "capture.dart", tests / shot.harness]
        for copy in copies:
            shutil.copyfile(CAPTURE / copy.name, copy)
        command = (f"flutter test test/{shot.harness} --dart-define=TUTORIAL_SCENE={shot.scene} "
                   f"--dart-define=TUTORIAL_CAPTURE_OUT=../{file}")
        try:
            self.run("capture", command, sample)
        finally:
            for copy in copies:
                copy.unlink()
            if created:
                tests.rmdir()
        data = (self.work / file).read_bytes()
        self.screenshots[file] = {"file": file, "sha256": sha256(data), "bytes": len(data),
                                  "scene": shot.description}


def default_step(replay, block, language, code):
    if language != "bash":
        raise SystemExit(f"No replay step for {language} block {block}")
    replay.cwd = replay.run_lines(block, code, replay.cwd)


def render_first(replay, block, language, code):
    sample = replay.sample("default")
    main = sample / "lib/main.dart"
    main.write_text(code + "\n")
    replay.first_render_sha256 = sha256(main.read_bytes())
    replay.run(block, "flutter analyze", sample)
    replay.capture("first-render.png")


def install_screen(replay, block, language, code):
    default_step(replay, block, language, code)
    replay.record_cli_output("default")
    replay.author("default", "lib/main.dart")


def customize_button(replay, block, language, code):
    path = replay.sample("default") / BUTTON
    before = code.replace(BUTTON_EDIT[1], BUTTON_EDIT[0])
    text = path.read_text()
    if before == code or text.count(before) != 1:
        raise SystemExit(f"{BUTTON}: the installed medium arm differs from the {block} block")
    text = text.replace(before, code)
    if text.count(code) != 1:
        raise SystemExit(f"{BUTTON}: the {block} block is ambiguous after the edit")
    path.write_text(text)
    replay.edits[archive_path("default", BUTTON)] = {"from": before, "to": code}


def install_fortal(replay, block, language, code):
    default_step(replay, block, language, code)
    replay.record_cli_output("fortal")
    replay.author("fortal", "lib/main.dart")


def prepare_tests(replay, block, language, code):
    for preset in SAMPLES:
        for path in AUTHORED[1:]:
            replay.author(preset, path)
        (replay.sample(preset) / "analysis_options.yaml").write_text(code + "\n")


def validate_samples(replay, block, language, code):
    for preset in SAMPLES:
        sample = replay.sample(preset)
        pubspec = sample / "pubspec.yaml"
        text, count = re.subn(r"^(environment:\n  sdk: )\S+", rf"\g<1>{SDK_FLOOR}",
                              pubspec.read_text(), flags=re.MULTILINE)
        if count != 1:
            raise SystemExit(f"{pubspec}: no environment sdk constraint to set")
        pubspec.write_text(text)
        replay.run(block, "flutter pub get", sample)
        replay.run_lines(block, code, sample)


STEPS = {
    "first-main": render_first,
    "install-screen": install_screen,
    "customize-button": customize_button,
    "install-fortal": install_fortal,
    "analysis-options": prepare_tests,
    "validate-sample": validate_samples,
}


def locked_version(sample, package):
    lock = (sample / "pubspec.lock").read_text()
    match = re.search(rf'^  {package}:\n(?:    .*\n)*?    version: "([^"]+)"', lock, re.MULTILINE)
    if not match:
        raise SystemExit(f"{sample.name}/pubspec.lock: {package} is not locked")
    return match.group(1)


def agreed_across_samples(replay, read):
    values = {preset: read(replay.sample(preset)) for preset in SAMPLES}
    if len(set(values.values())) != 1:
        raise SystemExit(f"Samples disagree: {values}")
    return next(iter(values.values()))


def registry_revision(sample):
    match = re.search(r'revision: "([a-f0-9]{40})"', (sample / "remix.yaml").read_text())
    if not match:
        raise SystemExit(f"{sample.name}/remix.yaml: no registry revision")
    return match.group(1)


def readme(info):
    return f"""# Remix CLI tutorial samples

The Vanilla and Fortal Launchpad samples from the Remix settings-screen tutorial.
`default_demo` holds the Vanilla project; `fortal_demo` holds the Fortal project.
Callbacks use local state and send no requests.

1. Use Flutter {FLUTTER_FLOOR} or newer, which bundles Dart {DART_FLOOR}. Check with `flutter --version`.
2. Open `default_demo` or `fortal_demo`.
3. Run `flutter pub get`, `flutter analyze`, and `flutter test`.
4. Run `flutter run -d chrome` to open the application in a browser.

Packages resolve from pub.dev: remix {info['remix']}, remix_ui_fonts {info['remix_ui_fonts']},
and the development-only remix_cli {info['remix_cli']}. `remix.yaml` pins the component
registry to revision {info['registry_revision']}.

`lib/main.dart` is the application. `lib/ui` holds the recipes the CLI installed and
the adapters it generated; an ordinary `remix add` preserves your edits there. The
Vanilla medium Button `minHeight` is changed from `AcmeTokens.controlMd` (36) to `44.0`.
Each `pubspec.yaml` declares `sdk: {info['sdk_floor']}`, the floor the tutorial states,
in place of the constraint `flutter create` wrote on the replay SDK.

Replayed {info['date']} with Flutter {info['flutter']}.
"""


def build_archive(replay, info):
    entries = {"README.md": readme(info).encode()}
    for preset in SAMPLES:
        sample = replay.sample(preset)
        paths = [sample / name for name in ARCHIVED_FILES]
        paths += [path for directory in ARCHIVED_DIRS
                  for path in (sample / directory).rglob("*") if path.is_file()]
        for path in paths:
            entries[archive_path(preset, path.relative_to(sample))] = path.read_bytes()
    date = datetime.date.fromisoformat(info["date"])
    buffer = io.BytesIO()
    with zipfile.ZipFile(buffer, "w") as archive:
        for name in sorted(entries):
            entry = zipfile.ZipInfo(name, (date.year, date.month, date.day, 12, 0, 0))
            entry.compress_type = zipfile.ZIP_DEFLATED
            entry.create_system = 3
            entry.external_attr = 0o644 << 16
            archive.writestr(entry, entries[name])
    return buffer.getvalue()


def toolchain(replay):
    output = replay.run("replay", "flutter --version --machine", replay.work)
    version = json.loads(output[output.index("{"):output.rindex("}") + 1])
    return version["frameworkVersion"], version["dartSdkVersion"].split()[0]


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--flutter", required=True, type=Path, help="path to the flutter executable")
    parser.add_argument("--work", type=Path, help="empty directory for the replayed projects")
    parser.add_argument("--skip-web-build", action="store_true",
                        help="skip flutter build web when the web SDK cannot be fetched")
    args = parser.parse_args()
    flutter = args.flutter.resolve()
    if not flutter.is_file():
        raise SystemExit(f"{flutter}: not a flutter executable")
    work = (args.work or Path(tempfile.mkdtemp(prefix="remix-tutorial-replay-"))).resolve()
    work.mkdir(parents=True, exist_ok=True)
    if any(work.iterdir()):
        raise SystemExit(f"{work}: the replay needs an empty directory")
    print(f"Replaying in {work}; command output goes to {work / 'replay.log'}", flush=True)

    replay = Replay(flutter, work, args.skip_web_build)
    flutter_version, dart_version = toolchain(replay)
    blocks = tutorial_blocks((ROOT / TUTORIAL).read_text())
    missing = set(STEPS) - {block.id for block in blocks}
    if missing:
        raise SystemExit(f"Tutorial lost blocks the replay depends on: {sorted(missing)}")
    for block in blocks:
        STEPS.get(block.id, default_step)(replay, *block)
    for file in SCREENSHOTS:
        if file not in replay.screenshots:
            replay.capture(file)

    info = {
        "date": datetime.date.today().isoformat(),
        "flutter": flutter_version,
        "dart": dart_version,
        "remix": agreed_across_samples(replay, lambda sample: locked_version(sample, "remix")),
        "remix_cli": agreed_across_samples(
            replay, lambda sample: locked_version(sample, "remix_cli")),
        "remix_ui_fonts": agreed_across_samples(
            replay, lambda sample: locked_version(sample, "remix_ui_fonts")),
        "registry_revision": agreed_across_samples(replay, registry_revision),
        "sdk_floor": SDK_FLOOR,
        "host": f"{platform.system()} {platform.release()} ({platform.machine()})",
        "web_build": "skipped" if args.skip_web_build else "release",
    }
    archive = build_archive(replay, info)
    assets = ROOT / ASSETS
    for file in SCREENSHOTS:
        shutil.copyfile(work / file, assets / file)
    (assets / ARCHIVE).write_bytes(archive)
    evidence = {
        "replay": info,
        "archive_sha256": sha256(archive),
        "screenshots": [replay.screenshots[file] for file in SCREENSHOTS],
        "source": [{"preset": preset,
                    "main_sha256": sha256(replay.authored[(preset, "lib/main.dart")]),
                    "test_sha256": sha256(replay.authored[(preset, "test/workflow_test.dart")]),
                    "theme_test_sha256": sha256(
                        replay.authored[(preset, "test/theme_modes_test.dart")])}
                   for preset in SAMPLES],
        "first_render_source_sha256": replay.first_render_sha256,
        "code_blocks": {block.id: {"language": block.language, "sha256": sha256(block.code.encode())}
                        for block in blocks},
        "cli_sources": {"files": replay.cli_files, "edits": replay.edits},
        "commands": replay.commands,
    }
    (ROOT / EVIDENCE).write_text(json.dumps(evidence, indent=2) + "\n")
    print(f"Wrote {len(SCREENSHOTS)} screenshots, {ARCHIVE}, and {EVIDENCE} from {work}.")


if __name__ == "__main__":
    main()
