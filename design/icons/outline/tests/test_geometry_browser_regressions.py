"""Geometry and browser-boundary regressions, including evidence freshness."""
from __future__ import annotations
import copy
import os
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
from tools.evidence import report_directory, snapshot, stamp_report, verify_report, differences
from source.restrictions import load_restrictions, usage_text, effective_catalog


class StrictSvgRegression(unittest.TestCase):
    def setUp(self):
        self.svg = (ROOT/'generated/outline/outline/24/home.svg').read_text()

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
        files=list((ROOT/'generated/outline').rglob('*.svg'))
        self.assertEqual(len(files),462)
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
        self.assertIn(expected,(ROOT/'docs/usage-restrictions.md').read_text())
        warning_notes=re.search(r'<details data-review="warning">(.*?)</details>',html,re.S)[1]
        self.assertNotIn('contextual label recommended at other sizes',warning_notes)

    def test_all_six_cells_have_visible_labels_and_exact_geometry(self):
        for n in (12,16,24):
            for a in ('outline','filled'):
                cell=self.record['sizes'][str(n)][a]
                with self.subTest(master=n,appearance=a):
                    self.assertIs(cell['visibleLabelRequired'],True)
                    expected=hashlib.sha256((ROOT/f'generated/outline/{a}/{n}/warning.svg').read_bytes()).hexdigest()
                    self.assertEqual(cell['geometrySha256'],expected)
                    self.assertIn(f'{n} px',usage_text(self.record,n))
        self.assertIsNone(self.record['owner']);self.assertIsNone(self.record['reviewer'])

    def test_warning_cells_name_only_their_own_active_exceptions(self):
        exceptions=json.loads((ROOT/'catalog/exceptions.json').read_text())
        own=[e for e in exceptions if e['icon']==self.record['icon']]
        self.assertEqual({e['id'] for e in own},{'warning-stem-dot-gap-16'})
        cells={(int(n),a):cell for n,appearances in self.record['sizes'].items() for a,cell in appearances.items()}
        for (n,a),cell in cells.items():
            with self.subTest(master=n,appearance=a):
                self.assertEqual(sorted(cell['exceptionIds']),sorted(e['id'] for e in own if (e['nativeSize'],e['appearance'])==(n,a)))
        for exception in own:
            cell=cells[(exception['nativeSize'],exception['appearance'])]
            self.assertEqual(exception['restrictionId'],self.record['id'])
            self.assertEqual(exception['geometrySha256'],cell['geometrySha256'])
            self.assertEqual(exception['permittedUse'],'visible-label-required')

    def test_exception_metrics_and_geometry_binding(self):
        exceptions=json.loads((ROOT/'catalog/exceptions.json').read_text())
        # The register is active-only: every record must still measure below its target.
        self.assertEqual({e['id'] for e in exceptions},{'warning-stem-dot-gap-16','link-filled-12-hook-gap','link-filled-16-hook-gap'})
        registered={i['id']:i['review']['exceptions'] for i in self.catalog['icons']}
        for icon,ids in registered.items():
            with self.subTest(catalog_icon=icon):
                self.assertEqual(sorted(ids),sorted(e['id'] for e in exceptions if e['icon']==icon))
        for exception in exceptions:
            icon,n,a=exception['icon'],exception['nativeSize'],exception['appearance']
            with self.subTest(exception=exception['id']):
                # Geometry cannot grant approval: no record may claim an owner or a passed review.
                self.assertIsNone(exception['owner']);self.assertIsNone(exception['reviewer'])
                self.assertIn('pending',exception['status'])
                self.assertTrue(exception['reason'].strip())
                path=ROOT/f"generated/{exception['pack']}/{a}/{n}/{icon}.svg"
                self.assertEqual(exception['geometrySha256'],hashlib.sha256(path.read_bytes()).hexdigest())
                g=parse_svg(path.read_text())[2]
                parts=sorted(list(g.geoms),key=lambda x:x.area,reverse=True)
                # Warning has a frame, a stem and a dot; a separated-part gap has exactly two parts.
                actual={'mark-internal-gap':lambda:parts[1].distance(parts[2]),
                        'meaningful-separated-part-gap':lambda:parts[0].distance(parts[1])}[exception['rule']]()
                self.assertAlmostEqual(actual,exception['measuredApprox'],delta=.015)
                # A value that reaches its target stops being an exception.
                self.assertLess(actual,exception['target']-.002)

    def test_legacy_pilot_artwork_matches_fixture_or_revision_ledger(self):
        # Legacy scope: the 48 pilot concepts and their 288 SVGs. The fixture and the
        # ledger are immutable history; later inventory is pinned by its own snapshots.
        original=json.loads((ROOT/'tests/fixtures/pilot1-sha256.json').read_text())
        self.assertEqual(len(original),288)
        ledger=json.loads((ROOT/'tests/fixtures/shape-revision-2026-11-01.json').read_text())['files']
        self.assertEqual(len(ledger),70)
        # Keep the immutable pilot fixture's historical keys; only map the moved paths.
        current={'angular/'+str(p.relative_to(ROOT/'generated/outline')):hashlib.sha256(p.read_bytes()).hexdigest() for p in (ROOT/'generated/outline').rglob('*.svg')}
        self.assertTrue(set(original)<=set(current))
        added={key.rsplit('/',1)[1][:-4] for key in set(current)-set(original)}
        self.assertEqual(added,{i['id'] for i in self.catalog['icons'] if i['stage']=='product-addition'})
        self.assertEqual(len(set(current)-set(original)),174)
        for key,digest in original.items():
            rel=key.split('/',1)[1]
            with self.subTest(path=rel):
                if rel in ledger:
                    self.assertEqual(ledger[rel]['from'],digest)
                    self.assertEqual(ledger[rel]['to'],current[key])
                    self.assertNotEqual(ledger[rel]['from'],ledger[rel]['to'])
                else:
                    self.assertEqual(current[key],digest)
        self.assertTrue(set(ledger)<={k.split('/',1)[1] for k in original})


class EvidenceFreshnessRegression(unittest.TestCase):
    def fixture(self,root):
        for name in ['source/outline/draw.py','source/build.py','tests/test_sample.py',
                     'tools/check.py','catalog/icons.json','requirements-dev.txt',
                     'generated/outline/outline/24/home.svg','docs/catalog/index.html',
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
            (report_directory(root)/'test.json').write_text('{}')
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
            external=Path(directory)/'evidence'
            env={**os.environ, 'VECTOR_UI_EVIDENCE_DIR':str(external)}
            reports=external/'outline'; reports.mkdir(parents=True)
            start=snapshot(root)
            filenames=['asset-checks.json','web-adapter.json','rebuild.json','pixel-regression.json']
            for name in filenames:
                report=stamp_report({'status':'passed','cleanBuild':True,'createdBaseline':False,'fixtureOnly':True},start,root)
                (reports/name).write_text(json.dumps(report))
            run=subprocess.run([sys.executable,'tools/release_gate.py'],cwd=root,capture_output=True,text=True,timeout=25,env=env)
            self.assertEqual(run.returncode,2)  # Governance stays closed.
            checks={c['check']:c['passed'] for c in json.loads((reports/'release-readiness.json').read_text())['checks']}
            self.assertTrue(all(checks['technical-'+f] for f in filenames))
            with (root/'source/build.py').open('a') as f:f.write('\nraise RuntimeError("disposable mutation")\n')
            run=subprocess.run([sys.executable,'tools/release_gate.py'],cwd=root,capture_output=True,text=True,timeout=25,env=env)
            self.assertEqual(run.returncode,2)
            checks={c['check']:c['passed'] for c in json.loads((reports/'release-readiness.json').read_text())['checks']}
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


class BrowserBoundaryRegression(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        from playwright.sync_api import sync_playwright
        cls.playwright = sync_playwright().start()
        cls.browser = cls.playwright.firefox.launch(headless=True)

    @classmethod
    def tearDownClass(cls):
        cls.browser.close()
        cls.playwright.stop()

    def test_winning_forced_colors_foreground(self):
        # Use the generated guide and its real toggle handler, including every
        # late stylesheet rule. Firefox has a palette where the old
        # HighlightText value is distinguishable.
        for scheme in ('light', 'dark'):
            with self.subTest(scheme=scheme):
                context = self.browser.new_context(forced_colors='active', color_scheme=scheme)
                try:
                    page = context.new_page()
                    page.set_content((ROOT/'docs/catalog/index.html').read_text())
                    page.wait_for_function('window.__ICON_GUIDE_READY__ === true')
                    self.assertTrue(page.evaluate("matchMedia('(forced-colors: active)').matches"))
                    toggle = page.get_by_role('button', name='Favorite project').first
                    toggle.click()
                    self.assertEqual(toggle.get_attribute('aria-pressed'), 'true')
                    colors = page.evaluate("""() => {
                        const probe = document.createElement('span');
                        probe.style.cssText = 'forced-color-adjust:none;color:CanvasText;color:contrast-color(Highlight)';
                        document.body.append(probe);
                        const expected = getComputedStyle(probe).color;
                        probe.style.color = 'HighlightText';
                        const previous = getComputedStyle(probe).color;
                        probe.remove();
                        return {expected, previous, controls: [...document.querySelectorAll(
                            '.favorite-toggle[aria-pressed="true"], .action-primary')].map(el => ({
                                color: getComputedStyle(el).color,
                                fill: getComputedStyle(el.querySelector('path')).fill
                            }))};
                    }""")
                    self.assertNotEqual(colors['expected'], colors['previous'], 'palette must distinguish the regression')
                    self.assertGreater(len(colors['controls']), 1)
                    for control in colors['controls']:
                        self.assertEqual(control['color'], colors['expected'])
                        self.assertEqual(control['fill'], colors['expected'])
                finally:
                    context.close()

    def test_raw_path_and_title_are_inert_text(self):
        # Exercise the public renderer in Node, then the actual HTML/SVG parser.
        # A raw-path escaping mutant still builds but changes this DOM at runtime.
        payloads = [
            '\"/><script>document.documentElement.dataset.injected="script"</script><path d="',
            '\" onload="document.documentElement.dataset.injected=1" data-attack="',
        ]
        script = """
            import {renderIcon} from './packages/web/render.mjs';
            const values = JSON.parse(process.argv[1]);
            console.log(JSON.stringify(values.map(value => renderIcon('custom','Custom',
                {outline: {24: value}}, {title: value}))));
        """
        result = subprocess.run(['node','--input-type=module','-e',script,json.dumps(payloads)],
                                cwd=ROOT, capture_output=True, text=True, check=True)
        for payload, markup in zip(payloads, json.loads(result.stdout), strict=True):
            with self.subTest(payload=payload):
                page = self.browser.new_page()
                try:
                    page.set_content(markup)
                    self.assertEqual(page.locator('svg > path').count(), 1)
                    self.assertEqual(page.locator('svg > title').text_content(), payload)
                    self.assertEqual(page.locator('svg').get_attribute('aria-label'), payload)
                    self.assertEqual(page.locator('svg > path').get_attribute('d'), payload)
                    self.assertEqual(page.locator('script, [onload], [data-attack]').count(), 0)
                    self.assertIsNone(page.locator('html').get_attribute('data-injected'))
                finally:
                    page.close()


if __name__=='__main__':
    unittest.main()
