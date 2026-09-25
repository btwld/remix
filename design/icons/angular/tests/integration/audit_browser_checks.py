#!/usr/bin/env python3
"""Browser regressions for F01-F03. Content mode never implies URL integration.

Forced-colors ratios use screenshot pixels as well as computed control colors.
Grid validation compares SVG coordinate matrices, not decorative panel spacing.
Native proofs are checked at 1x and 2x device density for all 288 drawings.
"""
from __future__ import annotations
import argparse
import io
import json
import sys
import threading
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from PIL import Image
from playwright.sync_api import sync_playwright

R = Path(__file__).resolve().parents[2]
sys.path.insert(0,str(R))
from tools.evidence import snapshot, write_report
CAT=json.loads((R/'catalog/icons.json').read_text())
IDS=[item['id'] for item in CAT['icons']]
HTML=(R/'docs/catalog/index.html').read_text()


def luminance(rgb):
    values=[v/255 for v in rgb[:3]]
    linear=[v/12.92 if v<=.04045 else ((v+.055)/1.055)**2.4 for v in values]
    return sum(a*b for a,b in zip(linear,[.2126,.7152,.0722]))


def ratio(a,b):
    x,y=sorted([luminance(a),luminance(b)])
    return (y+.05)/(x+.05)


class Quiet(SimpleHTTPRequestHandler):
    def log_message(self,*args): pass


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--browser',choices=['chromium','firefox','webkit'],default='chromium')
    parser.add_argument('--mode',choices=['full','content'],default='full')
    parser.add_argument('--executable')
    args=parser.parse_args()
    before=snapshot(R);checks=[];loading=[];errors=[];contrasts=[]
    report={'status':'running','browser':args.browser,'mode':args.mode,'checks':checks,'loading':loading,'contrastSamples':contrasts}
    outfile=R/f'reports/audit-browser-{args.browser}-{args.mode}.json'
    outfile.write_text('{"status":"running"}\n')
    captures=R/'review/audit-patch';captures.mkdir(parents=True,exist_ok=True)
    server=ThreadingHTTPServer(('127.0.0.1',0),partial(Quiet,directory=str(R)))
    threading.Thread(target=server.serve_forever,daemon=True).start()
    url=f'http://127.0.0.1:{server.server_port}/docs/catalog/index.html'
    def check(name,ok,detail=None):
        checks.append({'check':name,'passed':bool(ok),**({'detail':detail} if detail is not None else {})})
        if not ok:raise AssertionError(name+': '+str(detail))
    try:
        with sync_playwright() as p:
            options={'headless':True}
            if args.executable: options['executable_path']=args.executable
            if args.browser=='chromium':options['args']=['--no-sandbox']
            browser=getattr(p,args.browser).launch(**options);report['browserVersion']=browser.version
            def load(page):
                if args.mode=='full':page.goto(url,wait_until='load',timeout=10000)
                else:page.set_content(HTML,wait_until='load')
                page.wait_for_function('window.__ICON_GUIDE_READY__===true')
                page.on('pageerror',lambda e:errors.append(str(e)))
                page.set_default_timeout(6000)
            for kind,target in [('http',url),('file',(R/'docs/catalog/index.html').as_uri())]:
                page=browser.new_page()
                try:
                    page.goto(target,timeout=7000,wait_until='load');page.wait_for_function('window.__ICON_GUIDE_READY__===true',timeout=5000)
                    loading.append({'context':kind,'status':'passed'})
                except Exception as exc:
                    loading.append({'context':kind,'status':'blocked-or-failed','error':str(exc).splitlines()[0]})
                finally:page.close()
            if args.mode=='full' and any(x['status']!='passed' for x in loading):
                raise RuntimeError('Full-mode audit requires successful HTTP and file loading')

            # Actual selected/unselected paths plus visible primary-action text.
            for scheme in ['light','dark']:
                context=browser.new_context(viewport={'width':1440,'height':1000},device_scale_factor=1,forced_colors='active',color_scheme=scheme,reduced_motion='reduce')
                page=context.new_page();load(page)
                check('forced-colors active '+scheme,page.evaluate('matchMedia("(forced-colors: active)").matches'))
                for app_index in range(2):
                    app=page.locator('.app').nth(app_index);toggle=app.locator('.favorite-toggle')
                    for selected in [False,True]:
                        if selected:toggle.click()
                        check(f'Favorite state {scheme}/{app_index}/{selected}',toggle.get_attribute('aria-pressed')==str(selected).lower())
                        # Screenshot: use painted icon area and an interior background pixel.
                        png=Image.open(io.BytesIO(toggle.screenshot())).convert('RGB')
                        bg=png.getpixel((5,5));pixels=[png.getpixel((x,y)) for y in range(13,31) for x in range(13,31)]
                        contrast=max(ratio(pixel,bg) for pixel in pixels)
                        contrasts.append({'control':'Favorite','scheme':scheme,'app':app_index,'selected':selected,'paintedContrast':round(contrast,3)})
                        check(f'painted star contrast {scheme}/{app_index}/{selected}',contrast>=3,round(contrast,3))
                        box=toggle.bounding_box()
                        check('fixed target '+scheme+str(app_index)+str(selected),abs(box['width']-44)<.01 and abs(box['height']-44)<.01,box)
                    toggle.focus();page.keyboard.press('Space')
                    check('keyboard deselect '+scheme+str(app_index),toggle.get_attribute('aria-pressed')=='false')
                    focus=toggle.evaluate('(e)=>({style:getComputedStyle(e).outlineStyle,width:getComputedStyle(e).outlineWidth,name:e.getAttribute("aria-label")})')
                    check('focus and stable name '+scheme+str(app_index),focus['style']!='none' and focus['width']=='3px' and focus['name']=='Favorite project',focus)
                    primary=app.locator('.action-primary')
                    png=Image.open(io.BytesIO(primary.screenshot())).convert('RGB');bg=png.getpixel((5,5))
                    # Text starts after the leading plus. Exclude borders and the icon.
                    text_pixels=[png.getpixel((x,y)) for y in range(12,min(32,png.height-4)) for x in range(44,png.width-8)]
                    count=sum(ratio(pixel,bg)>=4.5 for pixel in text_pixels)
                    contrast=max(ratio(pixel,bg) for pixel in text_pixels)
                    contrasts.append({'control':'Create item label','scheme':scheme,'app':app_index,'paintedContrast':round(contrast,3),'highContrastTextPixels':count})
                    check('primary label pixels '+scheme+str(app_index),count>=25 and contrast>=4.5,{'contrast':round(contrast,3),'pixels':count})
                page.locator('.favorite-toggle').first.click()
                page.locator('#interface').screenshot(path=str(captures/f'forced-{scheme}.png'))
                context.close()

            # Every concept/native master at both scales, both device densities.
            # Rendering assertions are independent of surrounding panel centering.
            proof_count=0;grid_count=0
            for dpr,width in [(1,375),(2,1440)]:
                context=browser.new_context(viewport={'width':width,'height':1000},device_scale_factor=dpr,reduced_motion='reduce')
                page=context.new_page();load(page)
                for name in IDS:
                    page.locator(f'.icon-card[data-icon="{name}"]').click()
                    if page.locator('#inspect-grid').get_attribute('aria-pressed')!='true':page.locator('#inspect-grid').click()
                    for n in (12,16,24):
                        page.locator('#inspect-size').select_option(str(n))
                        for zoom in (1,4):
                            page.locator('#inspect-zoom').select_option(str(zoom))
                            page.wait_for_function('''([name,n])=>{const cs=[...document.querySelectorAll('#native-proof canvas')];return cs.length===2&&cs.every(c=>c.dataset.ready==='true'&&c.dataset.icon===name&&+c.dataset.master===n)}''',arg=[name,n])
                            # Wait for the layout-alignment animation frame, not a guessed delay.
                            page.evaluate('()=>new Promise(resolve=>requestAnimationFrame(()=>requestAnimationFrame(resolve)))')
                            geometry=page.locator('.vector-frame').evaluate_all('''els=>els.map(frame=>{
                              const art=frame.querySelector('svg:not(.coordinate-grid)'),grid=frame.querySelector('.coordinate-grid');
                              const a=art.getScreenCTM(),g=grid.getScreenCTM(),r=frame.getBoundingClientRect();
                              return {matrix:[a.a,a.b,a.c,a.d,a.e,a.f],gridMatrix:[g.a,g.b,g.c,g.d,g.e,g.f],view:art.getAttribute('viewBox'),gridView:grid.getAttribute('viewBox'),step:+grid.dataset.cssStep,visible:getComputedStyle(grid).visibility,width:r.width,height:r.height};})''')
                            check(f'coordinate matrices {name}/{n}/{zoom}x/dpr{dpr}',all(
                                all(abs(a-b)<.001 for a,b in zip(row['matrix'],row['gridMatrix'])) and
                                row['view']==row['gridView']==f'0 0 {n} {n}' and
                                abs(row['matrix'][0]-zoom)<.001 and row['step']==zoom and
                                row['visible']=='visible' and row['width']==n*zoom and row['height']==n*zoom for row in geometry),geometry)
                            grid_count+=2
                            proof=page.locator('#native-proof canvas').evaluate_all('''cs=>cs.map(c=>{
                              const r=c.getBoundingClientRect(),data=c.getContext('2d').getImageData(0,0,c.width,c.height).data;
                              let visible=0;for(let i=3;i<data.length;i+=4)if(data[i])visible++;
                              return {x:r.x,y:r.y,w:r.width,h:r.height,pw:c.width,ph:c.height,alpha:visible,first:data[3],key:c.dataset.icon};})''')
                            check(f'native raster alignment {name}/{n}/{zoom}x/dpr{dpr}',all(
                                abs(row['x']*dpr-round(row['x']*dpr))<.01 and abs(row['y']*dpr-round(row['y']*dpr))<.01 and
                                row['pw']==n*dpr and row['ph']==n*dpr and row['w']==n and row['h']==n and row['alpha']>0 and row['first']==0 and row['key']==name for row in proof),proof)
                            proof_count+=2
                        if name=='warning':
                            for appearance in ['outline','filled']:
                                page.locator('#code-appearance').select_option(appearance)
                                text=page.locator('#inspect-usage').text_content()
                                check(f'Warning guidance {n}/{appearance}/dpr{dpr}','Visible text label required' in text and f'{n} px' in text and 'outline and filled' in text and 'does not replace' in text)
                    page.keyboard.press('Escape')
                # A fractional layout offset must not turn native proof into blurred placement.
                page.locator('.icon-card[data-icon="sliders"]').click()
                page.locator('#native-proof').evaluate('e=>e.style.position="relative"')
                page.locator('#native-proof').evaluate('e=>{e.style.left="0.25px";e.style.top="0.375px";}')
                page.evaluate('dispatchEvent(new Event("resize"))')
                page.wait_for_function('''()=>[...document.querySelectorAll('#native-proof canvas')].every(c=>{const r=c.getBoundingClientRect(),d=devicePixelRatio;return Math.abs(r.x*d-Math.round(r.x*d))<.01&&Math.abs(r.y*d-Math.round(r.y*d))<.01;})''')
                check('fractional container compensation dpr'+str(dpr),True)
                page.locator('#native-proof').evaluate('e=>{e.style.left="";e.style.top="";}');page.evaluate('dispatchEvent(new Event("resize"))')
                page.locator('#inspect-grid').click()
                check('grid can be hidden dpr'+str(dpr),page.locator('.coordinate-grid').evaluate_all('(els)=>els.every(e=>getComputedStyle(e).visibility==="hidden")'))
                page.locator('#inspect-grid').click();page.evaluate('()=>new Promise(requestAnimationFrame)')
                page.screenshot(path=str(captures/f'coordinate-inspector-{dpr}x.png'))
                page.keyboard.press('Escape');context.close()
            report['gridPairsChecked']=grid_count//2
            report['nativeRasterInstancesChecked']=proof_count

            context=browser.new_context(viewport={'width':320,'height':900},device_scale_factor=1,reduced_motion='reduce')
            page=context.new_page();load(page)
            for width in [320,375,768,1440]:
                page.set_viewport_size({'width':width,'height':1000})
                page.locator('.icon-card[data-icon="sliders"]').click()
                for n in [12,16,24]:
                    page.locator('#inspect-size').select_option(str(n));page.locator('#inspect-zoom').select_option('4')
                    fits=page.locator('#inspector').evaluate('e=>e.scrollWidth<=e.clientWidth+1')
                    check(f'inspector horizontal fit {width}/{n}',fits)
                page.keyboard.press('Escape')
            page.set_viewport_size({'width':375,'height':1100});page.locator('.icon-card[data-icon="warning"]').click()
            page.screenshot(path=str(captures/'warning-guidance-mobile.png'))
            page.keyboard.press('Escape')
            page.set_viewport_size({'width':1440,'height':1000});page.locator('#interface').screenshot(path=str(captures/'normal-interface.png'))
            page.locator('#catalog').scroll_into_view_if_needed() if page.locator('#catalog').count() else page.evaluate('scrollTo(0,0)')
            page.screenshot(path=str(captures/'catalog-desktop.png'))
            check('no JavaScript errors',not errors,errors)
            context.close();browser.close()
            report['status']='passed' if args.mode=='full' else 'partial-integration'
            report['scope']='Real hosted and file loading plus audit regressions' if args.mode=='full' else 'Injected HTML; audit interactions tested, HTTP/file integration not validated'
    except Exception as exc:
        report['status']='failed';report['error']=str(exc);print(str(exc),file=sys.stderr)
    finally:
        server.shutdown();server.server_close()
        report['checksPassed']=sum(c['passed'] for c in checks)
        report['checksFailed']=sum(not c['passed'] for c in checks)
        report=write_report(outfile,report,before,R)
    print(json.dumps({k:v for k,v in report.items() if k not in ['checks','evidence','contrastSamples']},indent=2))
    return 1 if report['status']=='failed' else 0

if __name__=='__main__':
    raise SystemExit(main())
