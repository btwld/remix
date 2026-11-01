#!/usr/bin/env python3
"""Prove a release build keeps exactly the glyphs an application refers to.

    uv run --frozen --project packages/remix_ui_icons/tool/icons \\
        python packages/remix_ui_icons/tool/icons/tree_shake.py --flutter FLUTTER

Creates a throwaway web application that depends on this checkout's
remix_ui_icons, refers to a handful of glyphs in every way the API allows,
runs `flutter build web --release`, and then reads the font that shipped:

- Flutter must log that RemixIcons.otf was tree-shaken. A family with no
  recorded glyphs, or a non-const IconData, would ship the font whole.
- The shipped font must hold exactly the referenced glyphs (plus the space
  the web engine measures with). A glyph referenced through the facade, a
  deprecated alias, or a const RemixIconSet must survive; anything else must
  be gone.
"""

from __future__ import annotations

import argparse
import io
import json
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

from fontTools.ttLib import TTFont

import lock
from manifest import PACKAGE_ROOT, load_manifest

APP = """\
import 'package:flutter/widgets.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';
import 'package:remix_ui_icons/sized.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Known only at runtime, so the set's every master must survive.
    final size = MediaQuery.sizeOf(context).width > 600 ? 24.0 : 12.0;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        children: [
          const Icon(OutlineIcons.search),
          const Icon(RoundedIcons.homeFilled16),
          const Icon(RemixIcons.close),
          // ignore: deprecated_member_use
          const Icon(RemixIcons.cross2),
          Icon(OutlineIconSets.chevronDown.at(size), size: size),
        ],
      ),
    );
  }
}
"""

# The glyphs APP refers to, as manifest source paths.
EXPECTED = (
    "outline/outline/24/search.svg",
    "rounded/filled/16/home.svg",
    "outline/outline/24/close.svg",
    "outline/outline/12/chevron-down.svg",
    "outline/outline/16/chevron-down.svg",
    "outline/outline/24/chevron-down.svg",
)
SPACE = 0x20
SHAKEN = re.compile(
    r'Font asset "[^"]*RemixIcons\.otf" was tree-shaken, reducing it from (\d+) to (\d+) bytes'
)


def _run(command: list[str], cwd: Path) -> str:
    print("$ " + " ".join(command), flush=True)
    result = subprocess.run(command, cwd=cwd, capture_output=True, text=True)
    output = result.stdout + result.stderr
    if result.returncode != 0:
        print(output, file=sys.stderr)
        raise SystemExit(f"{command[0]} exited with {result.returncode}")
    return output


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--flutter", default="flutter", help="the flutter executable")
    parser.add_argument("--keep", type=Path, help="copy the built app here")
    args = parser.parse_args()

    manifest = load_manifest()
    codepoints = lock.codepoints(lock.read_lock())
    expected = {codepoints[source] for source in EXPECTED}

    version = json.loads(_run([args.flutter, "--version", "--machine"], PACKAGE_ROOT))
    print(f"Flutter {version['frameworkVersion']}, Dart {version['dartSdkVersion']}")

    with tempfile.TemporaryDirectory(prefix="remix-icons-shake-") as temporary:
        app = Path(temporary) / "tree_shake_app"
        _run(
            [args.flutter, "create", "--platforms=web", "--empty", "--project-name",
             "tree_shake_app", str(app)],
            PACKAGE_ROOT,
        )
        (app / "pubspec.yaml").write_text(
            "name: tree_shake_app\n"
            "publish_to: none\n"
            "environment:\n"
            "  sdk: '>=3.11.0 <4.0.0'\n"
            "dependencies:\n"
            "  flutter:\n"
            "    sdk: flutter\n"
            "  remix_ui_icons:\n"
            f"    path: {json.dumps(str(PACKAGE_ROOT))}\n"
            "flutter:\n"
            "  uses-material-design: false\n",
            encoding="utf-8",
        )
        (app / "lib" / "main.dart").write_text(APP, encoding="utf-8")
        shutil.rmtree(app / "test", ignore_errors=True)
        _run([args.flutter, "pub", "get"], app)
        log = _run([args.flutter, "build", "web", "--release"], app)

        match = SHAKEN.search(log)
        if match is None:
            print(log, file=sys.stderr)
            raise SystemExit("The build did not report tree-shaking RemixIcons.otf.")
        before, after = int(match[1]), int(match[2])
        print(match[0])

        shipped = app / "build" / "web" / "assets" / "packages" / manifest.package
        shipped = shipped / "lib" / "src" / "generated" / "fonts" / "RemixIcons.otf"
        font = TTFont(io.BytesIO(shipped.read_bytes()))
        kept = set(font.getBestCmap())
        if args.keep:
            shutil.copytree(app / "build" / "web", args.keep, dirs_exist_ok=True)

    missing = expected - kept
    extra = kept - expected - {SPACE}
    print(
        f"Kept {len(kept - {SPACE})} of {len(codepoints)} glyphs; "
        f"{before} -> {after} bytes ({(before - after) / before:.1%} smaller)."
    )
    if missing or extra:
        raise SystemExit(
            "The shipped font does not hold exactly the referenced glyphs: missing "
            f"{sorted(hex(c) for c in missing)}, unexpected {sorted(hex(c) for c in extra)}"
        )
    print("Tree shaking kept exactly the referenced glyphs.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
