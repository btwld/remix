#!/usr/bin/env python3
"""Rebuild in a clean temporary tree, without altering reviewed product files."""
from __future__ import annotations
import hashlib
import json
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
R = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(R))
from tools.evidence import snapshot, write_report


def main() -> int:
    before = snapshot(R)
    destination = R / 'reports/rebuild.json'
    destination.write_text('{"status":"running"}\n')
    report = {'status':'failed', 'cleanBuild':False,
              'comparison':'SHA-256 of clean-tree rebuild against existing products'}
    try:
        expected = json.loads((R/'generated-sha256.json').read_text())
        for rel, digest in expected.items():
            if hashlib.sha256((R/rel).read_bytes()).hexdigest() != digest:
                raise ValueError('Existing product differs from checksum: '+rel)
        with tempfile.TemporaryDirectory(prefix='vector-ui-clean-') as directory:
            target = Path(directory)/'project'
            shutil.copytree(R, target, ignore=shutil.ignore_patterns('.git','__pycache__','node_modules','reports','review','qa','FILE-MANIFEST.sha256'))
            shutil.rmtree(target/'generated')
            shutil.rmtree(target/'docs/catalog')
            shutil.rmtree(target/'packages/web/icons')
            for rel in ['packages/web/data.mjs','packages/web/usage-data.mjs','docs/OPTICAL-REVIEW.md','docs/usage-restrictions.md','generated-sha256.json']:
                (target/rel).unlink(missing_ok=True)
            (target/'docs/catalog').mkdir(parents=True)
            result = subprocess.run([sys.executable, 'source/build.py'], cwd=target, capture_output=True, text=True, timeout=120)
            if result.returncode:
                raise ValueError('Clean build failed: '+result.stderr[-4000:])
            actual = json.loads((target/'generated-sha256.json').read_text())
            changed = sorted(key for key in expected.keys()|actual.keys() if expected.get(key) != actual.get(key))
            if changed:
                raise ValueError('Rebuild changed products: '+', '.join(changed))
        report.update(status='passed', cleanBuild=True, productsCompared=len(expected), baselineSVGsPreserved=198)
    except (OSError, ValueError, subprocess.SubprocessError) as exc:
        report['error'] = str(exc)
    stamped = write_report(destination, report, before, R)
    print(json.dumps({k:v for k,v in stamped.items() if k!='evidence'}, indent=2))
    return 0 if stamped['status']=='passed' else 1

if __name__=='__main__':
    raise SystemExit(main())
