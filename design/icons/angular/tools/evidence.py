#!/usr/bin/env python3
"""Bind validation evidence to exact inputs, outputs, and the local toolchain.

Fingerprints detect stale evidence and accidental report edits. They are not
signatures and do not authenticate a reviewer or protect against a malicious
maintainer who can rewrite both evidence and code. No report stamps itself.
"""
from __future__ import annotations
import argparse
import hashlib
import importlib.metadata
import json
import platform
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INPUT_DIRS = ('source', 'catalog', 'tests', 'tools', 'packages', 'generated', 'docs', '.github')
INPUT_FILES = ('Makefile', 'generated-sha256.json', 'LICENSE', 'CONTRIBUTING.md', 'README.md')
PACKAGES = ('shapely', 'CairoSVG', 'cairocffi', 'cffi', 'Pillow', 'jsonschema',
            'jsonschema-specifications', 'referencing', 'rpds-py', 'attrs',
            'cssselect2', 'tinycss2', 'webencodings', 'defusedxml', 'playwright',
            'pyee', 'greenlet', 'typing_extensions', 'pycparser', 'numpy')


def digest_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def canonical_digest(value: object) -> str:
    return digest_bytes(json.dumps(value, sort_keys=True, separators=(',', ':'), ensure_ascii=False).encode())


def input_hashes(root: Path) -> dict[str, str]:
    """Additions and removals are part of the hash; do not trust an old file list."""
    paths: set[Path] = set()
    for directory in INPUT_DIRS:
        for path in (root / directory).rglob('*'):
            if any(x in ('__pycache__', 'node_modules', '.pytest_cache') for x in path.parts):
                continue
            if path.suffix in ('.pyc', '.pyo'):
                continue
            if path.is_symlink():
                raise ValueError('Evidence inputs may not be symlinks: '+str(path))
            if path.is_file():
                paths.add(path)
    paths.update(root / name for name in INPUT_FILES if (root / name).is_file())
    for pattern in ('requirements*.txt', '*lock*', 'pyproject.toml', 'package.json'):
        paths.update(p for p in root.glob(pattern) if p.is_file())
    return {str(path.relative_to(root)): digest_bytes(path.read_bytes()) for path in sorted(paths)}


def toolchain() -> dict:
    versions = {}
    for name in PACKAGES:
        try:
            versions[name] = importlib.metadata.version(name)
        except importlib.metadata.PackageNotFoundError:
            versions[name] = 'not-installed'
    try:
        node = subprocess.run(['node', '--version'], capture_output=True, text=True, check=True, timeout=10).stdout.strip()
    except (OSError, subprocess.SubprocessError):
        node = 'not-installed'
    try:
        import cairocffi
        cairo = cairocffi.cairo_version_string()
    except (ImportError, OSError):
        cairo = 'not-installed'
    try:
        import shapely
        geos = shapely.geos_version_string
    except (ImportError, AttributeError):
        geos = 'not-installed'
    return {'python': platform.python_version(), 'implementation': platform.python_implementation(),
            'system': platform.system(), 'machine': platform.machine(),
            'node': node, 'cairo': cairo, 'geos': geos, 'pythonPackages': versions}


def snapshot(root: Path = ROOT) -> dict:
    files = input_hashes(root)
    runtime = toolchain()
    return {'schemaVersion': 1, 'inputFiles': files, 'inputSha256': canonical_digest(files),
            'toolchain': runtime, 'toolchainSha256': canonical_digest(runtime)}


def differences(before: dict, after: dict) -> list[str]:
    a, b = before.get('inputFiles', {}), after.get('inputFiles', {})
    changed = [p for p in sorted(a.keys() | b.keys()) if a.get(p) != b.get(p)]
    if before.get('toolchainSha256') != after.get('toolchainSha256'):
        changed.append('[toolchain]')
    return changed


def stamp_report(report: dict, before: dict, root: Path = ROOT) -> dict:
    after = snapshot(root)
    changed = differences(before, after)
    output = {key: value for key, value in report.items() if key != 'evidence'}
    if changed:
        output['status'] = 'failed'
        output['inputChangesDuringRun'] = changed
    output['evidence'] = {**after, 'inputsStableDuringRun': not changed,
                          'reportSha256': canonical_digest(output)}
    return output


def verify_report(report: dict, current: dict) -> tuple[bool, list[str]]:
    evidence = report.get('evidence')
    if not isinstance(evidence, dict):
        return False, ['missing evidence envelope']
    problems = []
    if evidence.get('schemaVersion') != 1:
        problems.append('unknown evidence format')
    if evidence.get('inputsStableDuringRun') is not True:
        problems.append('inputs changed during test')
    if evidence.get('inputSha256') != canonical_digest(evidence.get('inputFiles', {})):
        problems.append('corrupt input index')
    if evidence.get('toolchainSha256') != canonical_digest(evidence.get('toolchain', {})):
        problems.append('corrupt toolchain index')
    changed = differences(evidence, current)
    if changed:
        problems.append('stale inputs: '+', '.join(changed[:8])+(' …' if len(changed)>8 else ''))
    if evidence.get('inputSha256') != current['inputSha256']:
        problems.append('input fingerprint mismatch')
    payload = {key: value for key, value in report.items() if key != 'evidence'}
    if evidence.get('reportSha256') != canonical_digest(payload):
        problems.append('report payload changed after test')
    return not problems, problems


def write_report(path: Path, report: dict, before: dict, root: Path = ROOT) -> dict:
    stamped = stamp_report(report, before, root)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(stamped, indent=2)+'\n', encoding='utf-8')
    return stamped


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='command', required=True)
    cap = sub.add_parser('capture'); cap.add_argument('--output', type=Path, required=True)
    stamp = sub.add_parser('stamp'); stamp.add_argument('--start-file', type=Path, required=True); stamp.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    if args.command == 'capture':
        args.output.write_text(json.dumps(snapshot(), indent=2)+'\n', encoding='utf-8')
        return 0
    report = json.loads(args.report.read_text(encoding='utf-8'))
    before = json.loads(args.start_file.read_text(encoding='utf-8'))
    result = write_report(args.report, report, before)
    return 1 if result['status'] == 'failed' else 0

if __name__ == '__main__':
    raise SystemExit(main())
