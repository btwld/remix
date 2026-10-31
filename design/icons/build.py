#!/usr/bin/env python3
"""Build every Vector UI family, then the shared comparison catalog.

Run from design/icons:

    python build.py

Family constructors stay in their own directories. This script does not
redraw one family from another's paths.
"""
from __future__ import annotations

import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
FAMILIES = ("outline", "rounded", "mono")


def main() -> None:
    for family in FAMILIES:
        print(f"=== build {family} ===", flush=True)
        subprocess.run(
            [sys.executable, "source/build.py"],
            cwd=ROOT / family,
            check=True,
        )
    from source.catalog import write_catalog

    path = write_catalog(ROOT)
    print(f"Wrote {path.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
