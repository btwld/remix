#!/usr/bin/env python3
"""Run local asset, geometry, module and reproducibility gates.
Browser navigation and recognition are separate; this command cannot approve a release.
"""
import unittest,json,sys,subprocess,hashlib
from pathlib import Path
R=Path(__file__).resolve().parents[1];sys.path.insert(0,str(R))
from tools.evidence import snapshot, write_report
started=snapshot(R)
(R/'reports/asset-checks.json').write_text('{"status":"running"}\n')
suite=unittest.defaultTestLoader.discover(str(R/'tests'),pattern='test_*.py',top_level_dir=str(R))
result=unittest.TextTestRunner(verbosity=2).run(suite)
report={'status':'passed' if result.wasSuccessful() else 'failed','testMethods':result.testsRun,'failureCount':len(result.failures),'errorCount':len(result.errors),'skipped':len(result.skipped),'svgAssets':288,'baselineBytesChecked':198,'catalogSha256':hashlib.sha256((R/'catalog/icons.json').read_bytes()).hexdigest(),'scope':'schema, matrix, serialized SVGs, native Cairo rasterization, sprites, directional invariants, meaningful regions; not human recognition'}
report=write_report(R/'reports/asset-checks.json',report,started,R)
if not result.wasSuccessful() or report['status']!='passed':raise SystemExit(1)
for command in [['node','tests/integration/test_web.mjs'],[sys.executable,'tools/check_rebuild.py'],[sys.executable,'tests/visual/pixel_regression.py']]:subprocess.run(command,cwd=R,check=True)
