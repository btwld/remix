#!/usr/bin/env python3
"""Browser QA with honest loading boundaries.

Default --mode full requires real HTTP, file://, and module-consumer loading.
--mode content is an explicitly limited fallback for restricted environments;
it tests the embedded guide with set_content and reports integration as partial.
"""
from __future__ import annotations
import argparse,json,sys,hashlib,threading
from pathlib import Path
from functools import partial
from http.server import ThreadingHTTPServer,SimpleHTTPRequestHandler
from playwright.sync_api import sync_playwright,TimeoutError as PWTimeout
R=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(R))
from tools.evidence import snapshot, write_report
CAT=json.loads((R/'catalog/icons.json').read_text()); IDS=[i['id'] for i in CAT['icons']]
SOURCE=(R/'docs/catalog/index.html').read_text()

class Quiet(SimpleHTTPRequestHandler):
    def log_message(self,*args):pass


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--mode',choices=['full','content'],default='full')
    parser.add_argument('--browser',choices=['chromium','firefox','webkit'],default='chromium')
    parser.add_argument('--executable',default=None)
    args=parser.parse_args();started=snapshot(R);checks=[];errors=[];loading=[];downloads=[]
    report={'catalogHTMLSHA256':hashlib.sha256(SOURCE.encode()).hexdigest(),'browser':args.browser,'mode':args.mode,'status':'running','checks':checks,'loading':loading,'downloads':downloads}
    (R/f'reports/browser-{args.browser}-{args.mode}.json').write_text('{"status":"running"}\n')
    def check(name,ok,detail=None):
        checks.append({'check':name,'passed':bool(ok),**({'detail':detail} if detail else {})})
        if not ok:raise AssertionError(name+': '+str(detail))
    server=ThreadingHTTPServer(('127.0.0.1',0),partial(Quiet,directory=str(R)));thread=threading.Thread(target=server.serve_forever,daemon=True);thread.start();url=f'http://127.0.0.1:{server.server_port}/'
    try:
        with sync_playwright() as pw:
            engine=getattr(pw,args.browser);options={'headless':True}
            if args.executable:options['executable_path']=args.executable
            if args.browser=='chromium':options['args']=['--no-sandbox']
            browser=engine.launch(**options);report['browserVersion']=browser.version
            context=browser.new_context(viewport={'width':1440,'height':1000},device_scale_factor=1,accept_downloads=True,reduced_motion='reduce')
            page=context.new_page();page.set_default_timeout(5000)
            for kind,target in [('http',url+'docs/catalog/index.html'),('file',(R/'docs/catalog/index.html').as_uri())]:
                probe=context.new_page()
                try:
                    probe.goto(target,wait_until='load',timeout=10000);probe.wait_for_function('window.__ICON_GUIDE_READY__ === true',timeout=5000)
                    loading.append({'context':kind,'status':'passed'})
                except Exception as exc:
                    loading.append({'context':kind,'status':'blocked-or-failed','detail':str(exc).split('\n')[0].split(' at ')[0]})
                finally:probe.close()
            if args.mode=='full' and any(x['status']!='passed' for x in loading):raise RuntimeError('Required HTTP/file loading did not pass')
            def load(source=SOURCE):
                if args.mode=='full' and source==SOURCE:page.goto(url+'docs/catalog/index.html')
                else:
                    page.evaluate('window.__ICON_GUIDE_READY__=false')
                    page.set_content(source,wait_until='load')
                if source==SOURCE:page.wait_for_function('window.__ICON_GUIDE_READY__ === true')
            page.on('pageerror',lambda error:errors.append(str(error)))
            load();check('catalog cards',page.locator('.icon-card').count()==48)
            check('native drawings on cards',page.locator('.master-strip svg').count()==288)
            check('labeled appearance examples',page.locator('.sample-control').count()==96)
            check('size matrix concepts',page.locator('[data-matrix]').count()==48)
            check('per-icon review notes',page.locator('[data-review]').count()==48)
            # Compare all runtime SVG downloads to the exported files, not only counts.
            blobs=page.evaluate('''() => Object.fromEntries(window.VectorUIPilot.ids.flatMap(id => ['outline','filled'].flatMap(a => [12,16,24].map(n => [a+'/'+n+'/'+id+'.svg',window.VectorUIPilot.exported(id,a,n)]))))''')
            mismatch=[p for p,t in blobs.items() if t!=(R/'generated/angular'/p).read_text()]
            check('all 288 runtime SVG strings match files',len(blobs)==288 and not mismatch)
            page.locator('#new-only').click();check('pilot filter returns 15',page.locator('.icon-card:visible').count()==15)
            page.locator('#reset').click();page.locator('#search').fill('settings')
            shown=page.locator('.icon-card:visible').evaluate_all('(els)=>els.map(e=>e.dataset.icon).sort()')
            check('settings is a search keyword, not an alias',shown==['gear','sliders'],shown)
            page.locator('#search').fill('zz-no-icon');check('empty search state',page.locator('.icon-card:visible').count()==0 and page.locator('#empty').is_visible())
            page.locator('#empty-reset').click();check('reset shows all',page.locator('.icon-card:visible').count()==48)
            for cat in sorted({i['category'] for i in CAT['icons']}):
                page.locator('#category').select_option(cat)
                check('category '+cat,page.locator('.icon-card:visible').count()==sum(i['category']==cat for i in CAT['icons']))
            page.locator('#reset').click()
            for size in [12,14,16,20,24,32]:
                page.locator('#display-size').select_option(str(size));n=12 if size<=12 else 16 if size<=16 else 24
                boxes=page.locator('.card-live svg').evaluate_all('(els)=>els.map(e=>({width:e.getBoundingClientRect().width,view:e.getAttribute("viewBox")}))')
                check(f'preview {size}px uses {n}px master',all(abs(x['width']-size)<.01 and x['view']==f'0 0 {n} {n}' for x in boxes))
                sizes=page.locator('.icon-card').first.locator('.master-strip svg').evaluate_all('(els)=>els.map(e=>e.getAttribute("width"))')
                check(f'native strips unchanged at preview {size}px',sizes==['12','12','16','16','24','24'])
            page.locator('#display-size').select_option('32')
            for theme in ['light','dark','lime','cobalt']:
                page.locator('#theme').select_option(theme);check('surface '+theme,page.locator('#library').get_attribute('data-theme')==theme)
                page.keyboard.press('Tab');page.locator('.icon-card').first.focus();outline=page.locator('.icon-card').first.evaluate('(e)=>({c:getComputedStyle(e).outlineColor,w:getComputedStyle(e).outlineWidth,fg:getComputedStyle(e).color})')
                check('keyboard focus contrast inherited on '+theme,outline['w']=='3px' and outline['c']==outline['fg'],outline)
            page.locator('#theme').select_option('light')
            for width in [320,375,768,1440]:
                page.set_viewport_size({'width':width,'height':900})
                overflow=page.evaluate('document.documentElement.scrollWidth > innerWidth+1')
                check('no document overflow '+str(width),not overflow)
            page.set_viewport_size({'width':320,'height':850})
            for id in IDS:
                page.locator(f'.icon-card[data-icon="{id}"]').click()
                dims=page.locator('#inspect-pair').evaluate('''e=>{const r=e.getBoundingClientRect();return [...e.querySelectorAll('svg')].every(s=>{const b=s.getBoundingClientRect();return b.left>=r.left-.5&&b.right<=r.right+.5;})}''')
                check('320px inspector fits '+id,dims)
                page.keyboard.press('Escape');check('dialog closes '+id,not page.locator('#inspector').is_visible())
            page.set_viewport_size({'width':1440,'height':1000})
            page.locator('.icon-card[data-icon="help"]').click();page.locator('#inspect-size').select_option('16')
            for a in ['outline','filled']:
                try:
                    with page.expect_download(timeout=7000) as pending:page.locator(f'[data-download="{a}"]').click()
                    dl=pending.value;local=Path(dl.path());expected=(R/f'generated/angular/{a}/16/help.svg').read_bytes()
                    check('real download bytes '+a,local.read_bytes()==expected)
                    downloads.append({'appearance':a,'master':16,'status':'passed','filename':dl.suggested_filename})
                except PWTimeout:
                    downloads.append({'appearance':a,'master':16,'status':'blocked-or-unavailable'})
                    if args.mode=='full':raise
            page.locator('#code-appearance').select_option('filled');check('code view is selected appearance',page.locator('#code').input_value()==(R/'generated/angular/filled/16/help.svg').read_text())
            page.locator('#copy-svg').click();check('copy success or fallback is visible',bool(page.locator('#copy-status').text_content().strip()))
            page.keyboard.press('Escape')
            toggle=page.locator('.favorite-toggle').first;old=toggle.bounding_box();name=toggle.get_attribute('aria-label');toggle.focus();page.keyboard.press('Space')
            check('keyboard toggle selected',toggle.get_attribute('aria-pressed')=='true')
            check('toggle name stays stable',toggle.get_attribute('aria-label')==name)
            check('toggle box stays fixed',toggle.bounding_box()['width']==old['width'] and toggle.bounding_box()['height']==old['height'])
            page.keyboard.press('Space');check('toggle deselected',toggle.get_attribute('aria-pressed')=='false')
            page.locator('#example-size').select_option('12');page.locator('#example-theme').select_option('dark')
            check('all examples use chosen native size',page.locator('.example-icon svg[width="12"]').count()==96)
            # Explicit no-JavaScript view: static pairs/examples still exist.
            nojs=browser.new_context(java_script_enabled=False,viewport={'width':375,'height':900});np=nojs.new_page()
            if args.mode=='full':np.goto(url+'docs/catalog/index.html')
            else:np.set_content(SOURCE)
            check('noscript catalog complete',np.locator('.icon-card').count()==48)
            check('noscript examples complete',np.locator('.sample-control').count()==96)
            check('noscript notice',np.locator('noscript').is_visible());nojs.close()
            if args.mode=='full':
                consumer=context.new_page();consumer.goto(url+'tests/integration/consumer.html');consumer.wait_for_function('window.__CONSUMER_READY__===true')
                check('hosted ESM consumer renders',consumer.locator('svg').count()==3);consumer.locator('#favorite').click();check('hosted ESM consumer toggles',consumer.locator('#favorite').get_attribute('aria-pressed')=='true');consumer.close()
            else:loading.append({'context':'browser-esm-consumer','status':'not-tested-in-content-mode','detail':'Node isolated imports are checked separately.'})
            check('no guide JavaScript errors',not errors,errors)
            # Captures from the current source, not synthetic or prior images.
            load();page.set_viewport_size({'width':1440,'height':1050});page.screenshot(path=str(R/'review/catalog-desktop.png'))
            page.locator('#interface').screenshot(path=str(R/'review/interface-pairs.png'))
            page.set_viewport_size({'width':375,'height':900});page.evaluate('scrollTo(0,0)');page.screenshot(path=str(R/'review/catalog-mobile.png'))
            page.locator('#theme').select_option('cobalt');page.locator('.icon-card[data-icon="gear"]').click();page.screenshot(path=str(R/'review/inspector-mobile.png'));page.keyboard.press('Escape')
            page.set_viewport_size({'width':1440,'height':1100})
            for mode in ['all','new']:
                proof=(R/f'docs/catalog/proof-{mode}.html').read_text();page.set_content(proof)
                page.screenshot(path=str(R/('review/paired-icon-sheet.png' if mode=='all' else 'review/pilot-additions.png')),full_page=True)
            # Native matrix strips at 1x/2x on both high-contrast surfaces.
            paths=json.loads((R/'generated/registry.json').read_text())['paths']
            for dpr in [1,2]:
                for theme,bg,fg in [('light','#f9f7f2','#111210'),('dark','#101112','#f9f7f2')]:
                    nc=browser.new_context(viewport={'width':1050,'height':900},device_scale_factor=dpr);p=nc.new_page()
                    rows=''
                    for id in IDS:
                        cells=''.join(f'<span><svg width="{n}" height="{n}" viewBox="0 0 {n} {n}" fill="currentColor" fill-rule="evenodd"><path d="{paths[id][a][str(n)]}"/></svg></span>' for n in [12,16,24] for a in ['outline','filled'])
                        rows+=f'<div class="r"><b>{id}</b>{cells}</div>'
                    doc=f'<html><head><style>body{{background:{bg};color:{fg};font:12px monospace;margin:24px}}.r{{display:grid;grid-template-columns:230px repeat(6,110px);align-items:center;min-height:44px;border-bottom:1px solid #777}}span{{display:flex;justify-content:center}}</style></head><body><h1>Native SVGs / {theme} / {dpr}× pixels</h1><p>Columns: 12 outline / filled · 16 outline / filled · 24 outline / filled</p>{rows}</body></html>'
                    p.set_content(doc);p.screenshot(path=str(R/f'review/native-{theme}-{dpr}x.png'),full_page=True);nc.close()
            report['status']='passed' if args.mode=='full' else 'partial-integration'
            report['interactionChecksPassed']=sum(c['passed'] for c in checks)
            report['interactionChecksFailed']=sum(not c['passed'] for c in checks)
            report['scope']='Actual URL + local file + browser module consumer' if args.mode=='full' else 'Injected HTML in Chromium; URL/file/module loading not validated. Not equivalent to full browser integration.'
            browser.close()
    except Exception as exc:
        report['status']='failed';report['error']=str(exc);print(str(exc),file=sys.stderr)
    finally:
        server.shutdown();server.server_close()
        report=write_report(R/f'reports/browser-{args.browser}-{args.mode}.json',report,started,R)
    print(json.dumps({k:v for k,v in report.items() if k not in ['checks','evidence']},indent=2))
    return 1 if report['status']=='failed' else 0

if __name__=='__main__':raise SystemExit(main())
