"""Regression coverage for audit F02-F05; actual browser/color tests are separate."""
from __future__ import annotations
import copy
import hashlib
import json
import re
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from shapely.geometry import Polygon

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from tests.geometry.paths import parse_svg
from tools.evidence import snapshot, stamp_report, verify_report, differences
from source.restrictions import load_restrictions, usage_text, effective_catalog


class StrictSvgRegression(unittest.TestCase):
    def setUp(self):
        self.svg = (ROOT/'generated/angular/outline/24/home.svg').read_text()

    def test_root_overrides_are_rejected(self):
        attributes = {'opacity':'0','display':'none','visibility':'hidden',
            'color':'white','stroke':'red','stroke-width':'8','stroke-opacity':'0',
            'fill-opacity':'0','style':'display:none','transform':'scale(0)',
            'filter':'url(#hidden)','mask':'url(#mask)','clip-path':'url(#clip)',
            'onclick':'alert(1)','onload':'alert(1)','href':'https://invalid.test',
            'id':'unexpected','class':'hidden','preserveAspectRatio':'none',
            'overflow':'hidden','aria-hidden':'true'}
        for attr,value in attributes.items():
            with self.subTest(attribute=attr), self.assertRaises(ValueError):
                parse_svg(self.svg.replace('<svg ',f'<svg {attr}="{value}" ',1))

    def test_root_value_contract(self):
        for old,new in [('role="img"','role="none"'),('focusable="false"','focusable="true"'),
                        ('fill="currentColor"','fill="none"'),('fill-rule="evenodd"','fill-rule="nonzero"'),
                        ('width="24"','width="24px"'),('height="24"','height="0"'),
                        ('viewBox="0 0 24 24"','viewBox="0 0 NaN 24"'),
                        ('viewBox="0 0 24 24"','viewBox="1 0 24 24"'),
                        ('viewBox="0 0 24 24"','viewBox="0 0 20 20"')]:
            with self.subTest(value=new), self.assertRaises(ValueError):
                parse_svg(self.svg.replace(old,new))

    def test_per_element_allowlists_and_structure(self):
        bad = [self.svg.replace('<title>','<title style="display:none">'),
               self.svg.replace('<title>','<title id="unexpected">'),
               self.svg.replace('<path ','<path fill="none" '),
               self.svg.replace('<path ','<path opacity="0" '),
               self.svg.replace('xmlns="http://www.w3.org/2000/svg"','xmlns="urn:other"'),
               self.svg.replace('<path ','<path xmlns="urn:other" '),
               self.svg.replace('  <path','text <path'),
               self.svg.replace('</svg>','<g/></svg>'),
               self.svg.replace('<title>Home — outline</title>','<title> </title>'),
               self.svg.replace('<path','<!-- unexplained --> <path'),
               '<?xml-stylesheet href="https://invalid.test"?>'+self.svg,
               '<!DOCTYPE svg>'+self.svg]
        for index,text in enumerate(bad):
            with self.subTest(case=index), self.assertRaises(ValueError):
                parse_svg(text)

    def test_all_current_files_still_parse(self):
        files=list((ROOT/'generated/angular').rglob('*.svg'))
        self.assertEqual(len(files),288)
        for file in files:
            with self.subTest(file=str(file.relative_to(ROOT))):
                n,d,g=parse_svg(file.read_text())
                self.assertFalse(g.is_empty)


class RestrictionRegression(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.catalog=json.loads((ROOT/'catalog/icons.json').read_text())
        cls.records=load_restrictions(ROOT)
        cls.record=cls.records['warning-visible-label']

    def test_one_authoritative_usage_source(self):
        warning=next(i for i in self.catalog['icons'] if i['id']=='warning')
        self.assertNotIn('usage',warning['review'])
        self.assertEqual(warning['review']['usageRestriction'],'warning-visible-label')
        effective=effective_catalog(self.catalog,self.records)
        expected=usage_text(self.record)
        self.assertEqual(next(i for i in effective['icons'] if i['id']=='warning')['review']['usage'],expected)
        html=(ROOT/'docs/catalog/index.html').read_text()
        data=json.loads(re.search(r'<script type="application/json" id="icon-data">(.*?)</script>',html,re.S)[1])
        self.assertEqual(data['restrictions'],self.records)
        self.assertEqual(next(i for i in data['catalog']['icons'] if i['id']=='warning')['review']['usage'],expected)
        self.assertIn(expected,(ROOT/'docs/OPTICAL-REVIEW.md').read_text())
        self.assertIn(expected,(ROOT/'docs/usage-restrictions.md').read_text())
        warning_notes=re.search(r'<details data-review="warning">(.*?)</details>',html,re.S)[1]
        self.assertNotIn('contextual label recommended at other sizes',warning_notes)

    def test_all_six_cells_have_visible_labels_and_exact_geometry(self):
        for n in (12,16,24):
            for a in ('outline','filled'):
                cell=self.record['sizes'][str(n)][a]
                with self.subTest(master=n,appearance=a):
                    self.assertIs(cell['visibleLabelRequired'],True)
                    expected=hashlib.sha256((ROOT/f'generated/angular/{a}/{n}/warning.svg').read_bytes()).hexdigest()
                    self.assertEqual(cell['geometrySha256'],expected)
                    self.assertIn(f'{n} px',usage_text(self.record,n))
        self.assertIsNone(self.record['owner']);self.assertIsNone(self.record['reviewer'])

    def test_exception_metrics_and_geometry_binding(self):
        exceptions=json.loads((ROOT/'catalog/exceptions.json').read_text())
        self.assertEqual(len(exceptions),5)
        for exception in exceptions:
            n,a=exception['nativeSize'],exception['appearance']
            cell=self.record['sizes'][str(n)][a]
            self.assertIn(exception['id'],cell['exceptionIds'])
            self.assertEqual(exception['restrictionId'],self.record['id'])
            self.assertEqual(exception['geometrySha256'],cell['geometrySha256'])
            self.assertEqual(exception['permittedUse'],'visible-label-required')
            g=parse_svg((ROOT/f'generated/angular/{a}/{n}/warning.svg').read_text())[2]
            if a=='filled':
                holes=[Polygon(r) for r in g.interiors]
                sizes=sorted([(round(h.bounds[2]-h.bounds[0],4),round(h.bounds[3]-h.bounds[1],4)) for h in holes],key=lambda x:x[1])
                m=exception['punctuation']
                self.assertEqual(sizes,[(m['dotWidth'],m['dotHeight']),(m['stemWidth'],m['stemHeight'])])
                self.assertLess(m['stemWidth'],exception['target'])
            else:
                parts=sorted(list(g.geoms),key=lambda x:x.area,reverse=True)
                actual=min(parts[0].distance(part) for part in parts[1:])
                self.assertAlmostEqual(actual,exception['measuredApprox'],delta=.015)

    def test_entire_pilot_artwork_unchanged(self):
        original=json.loads((ROOT/'tests/fixtures/pilot1-sha256.json').read_text())
        self.assertEqual(len(original),288)
        current={str(p.relative_to(ROOT/'generated')):hashlib.sha256(p.read_bytes()).hexdigest() for p in (ROOT/'generated/angular').rglob('*.svg')}
        self.assertEqual(current,original)


class EvidenceFreshnessRegression(unittest.TestCase):
    def fixture(self,root):
        for name in ['source/angular/draw.py','source/build.py','tests/test_sample.py',
                     'tools/check.py','catalog/icons.json','requirements-dev.txt',
                     'generated/angular/outline/24/home.svg','docs/catalog/index.html',
                     '.github/workflows/test.yml','packages/web/render.mjs']:
            path=root/name;path.parent.mkdir(parents=True,exist_ok=True);path.write_text('fixture\n')

    def test_mutations_additions_and_removals_invalidate_evidence(self):
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory);self.fixture(root)
            start=snapshot(root);report=stamp_report({'status':'passed'},start,root)
            self.assertEqual(verify_report(report,snapshot(root)),(True,[]))
            for relative in start['inputFiles']:
                path=root/relative;old=path.read_bytes();path.write_bytes(old+b'mutation\n')
                with self.subTest(path=relative):
                    ok,_=verify_report(report,snapshot(root));self.assertFalse(ok)
                path.write_bytes(old)
            new=root/'source/new.py';new.write_text('addition')
            self.assertFalse(verify_report(report,snapshot(root))[0]);new.unlink()
            removed=root/'tests/test_sample.py';old=removed.read_bytes();removed.unlink()
            self.assertFalse(verify_report(report,snapshot(root))[0]);removed.write_bytes(old)
            # Reports and captures are outputs, not recursive inputs.
            (root/'reports').mkdir();(root/'reports/test.json').write_text('{}')
            self.assertTrue(verify_report(report,snapshot(root))[0])

    def test_unstamped_tampered_runtime_and_midrun_changes_fail(self):
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory);self.fixture(root);start=snapshot(root)
            report=stamp_report({'status':'failed','tests':0},start,root)
            report['status']='passed'
            self.assertFalse(verify_report(report,snapshot(root))[0])
            self.assertFalse(verify_report({'status':'passed'},snapshot(root))[0])
            good=stamp_report({'status':'passed'},start,root)
            current=copy.deepcopy(snapshot(root));current['toolchainSha256']='not-the-same-runtime'
            self.assertFalse(verify_report(good,current)[0])
            (root/'source/build.py').write_text('broken source')
            midrun=stamp_report({'status':'passed'},start,root)
            self.assertEqual(midrun['status'],'failed')
            self.assertFalse(midrun['evidence']['inputsStableDuringRun'])

    def test_real_release_gate_rejects_stale_success_reports(self):
        # Synthetic success reports belong ONLY to this disposable fixture.
        # The test asks whether the actual gate rejects stale status fields.
        with tempfile.TemporaryDirectory(prefix='stale-gate-fixture-') as directory:
            root=Path(directory)/'project'
            shutil.copytree(ROOT,root,ignore=shutil.ignore_patterns('.git','__pycache__','reports','review','qa','node_modules'))
            (root/'reports').mkdir()
            start=snapshot(root)
            filenames=['asset-checks.json','web-adapter.json','rebuild.json','pixel-regression.json']
            for name in filenames:
                report=stamp_report({'status':'passed','cleanBuild':True,'createdBaseline':False,'fixtureOnly':True},start,root)
                (root/'reports'/name).write_text(json.dumps(report))
            run=subprocess.run([sys.executable,'tools/release_gate.py'],cwd=root,capture_output=True,text=True,timeout=25)
            self.assertEqual(run.returncode,2)  # Governance stays closed.
            checks={c['check']:c['passed'] for c in json.loads((root/'reports/release-readiness.json').read_text())['checks']}
            self.assertTrue(all(checks['technical-'+f] for f in filenames))
            with (root/'source/build.py').open('a') as f:f.write('\nraise RuntimeError("disposable mutation")\n')
            run=subprocess.run([sys.executable,'tools/release_gate.py'],cwd=root,capture_output=True,text=True,timeout=25)
            self.assertEqual(run.returncode,2)
            checks={c['check']:c['passed'] for c in json.loads((root/'reports/release-readiness.json').read_text())['checks']}
            self.assertFalse(any(checks['technical-'+f] for f in filenames))


class SelectedStarContrastRegression(unittest.TestCase):
    def test_forced_colors_selected_icon_uses_contrast_color(self):
        css = (ROOT / 'source/web/catalog.css').read_text()
        block = css.split('@media (forced-colors: active)', 1)[1].split('@media', 1)[0]
        rule = block.split('button[aria-pressed="true"]', 1)[1].split('}', 1)[0]
        self.assertIn('color: CanvasText', rule)
        self.assertIn('contrast-color(Highlight)', rule)
        self.assertIn('background: Highlight', rule)
        self.assertNotIn('HighlightText', rule)
        primary = block.split('.action-primary', 1)[1].split('}', 1)[0]
        self.assertIn('color: CanvasText', primary)
        self.assertIn('contrast-color(Highlight)', primary)
        self.assertNotIn('HighlightText', primary)
        focus = block.split('button:focus', 1)[1].split('}', 1)[0]
        self.assertIn('outline: 3px solid Highlight', focus)
        page = (ROOT / 'docs/catalog/index.html').read_text()
        self.assertIn('color: CanvasText', page)
        self.assertIn('contrast-color(Highlight)', page)
        self.assertIn('aria-label="Favorite project"', page)
        self.assertIn('aria-pressed="false"', page)


if __name__=='__main__':
    unittest.main()
