#!/usr/bin/env python3
"""Run the Vector UI icon pack check suite.

From design/icons:

    python tools/run_checks.py

Pack tests cover the sibling layout, the Warning visible-label rule, and
the shared catalog. Each family then runs the check suite recovered with it.
"""
from __future__ import annotations

import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    env = os.environ.copy()
    # Outline's Node adapter calls $PYTHON, then `python`. Point it at this
    # interpreter so the suite does not depend on a `python` binary name.
    env["PYTHON"] = sys.executable
    steps = (
        ("pack", [sys.executable, "-m", "unittest", "tests.test_pack", "-v"], ROOT),
        ("outline", [sys.executable, "tools/run_checks.py"], ROOT / "outline"),
        ("rounded", [sys.executable, "tools/run_checks.py"], ROOT / "rounded"),
        (
            "mono",
            [sys.executable, "-m", "unittest", "tests.test_pilot", "-v"],
            ROOT / "mono",
        ),
    )
    for name, command, cwd in steps:
        print(f"\n=== {name} ===", flush=True)
        result = subprocess.run(command, cwd=cwd, env=env)
        if result.returncode != 0:
            print(f"{name} checks failed with exit {result.returncode}", file=sys.stderr)
            return result.returncode
    print("\nAll Vector UI icon checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
