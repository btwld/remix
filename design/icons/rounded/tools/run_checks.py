#!/usr/bin/env python3
"""Run the Rounded checks from the family root."""
from __future__ import annotations
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    r = subprocess.run([sys.executable, '-m', 'unittest', 'discover', '-s', 'tests', '-t', '.', '-v'], cwd=ROOT)
    return r.returncode


if __name__ == '__main__':
    raise SystemExit(main())
