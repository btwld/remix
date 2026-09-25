#!/usr/bin/env python3
"""Run Soft pilot checks from the pilot root."""
from __future__ import annotations
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    r = subprocess.run([sys.executable, '-m', 'unittest', 'tests.test_pilot', '-v'], cwd=ROOT)
    return r.returncode


if __name__ == '__main__':
    raise SystemExit(main())
