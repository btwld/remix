// Pinned upstream range configuration; measurements never come from Flutter.
import {createServer} from 'vite';
import {chromium} from 'playwright-core';
import {readFile,writeFile,mkdir} from 'node:fs/promises';
import {fileURLToPath} from 'node:url';
import path from 'node:path';
import assert from 'node:assert/strict';
const here=path.dirname(fileURLToPath(import.meta.url));
const root=path.resolve(here,'../../../..');
const reference=path.join(root,'registry_source/reference/heroui_3_2_6');
const source=JSON.parse(await readFile(path.join(reference,'sources.json')));
const lock=JSON.parse(await readFile(path.join(here,'package-lock.json')));
for(const pkg of source.packages) {
  assert.equal(lock.packages[`node_modules/${pkg.name}`].version,pkg.version);
  assert.equal(lock.packages[`node_modules/${pkg.name}`].integrity,pkg.integrity);
}
const props=['backgroundColor','color','height','width','borderRadius','boxShadow','opacity','scale','transform','outlineStyle','outlineColor','outlineWidth','outlineOffset','fontFamily','fontSize','lineHeight','gap','left','top'];
const data={schema:1,upstream:source.commit,environment:{font:'Geist (repository TTFs)',rootSize:16,deviceScaleFactor:1,reducedMotion:'no-preference',colorProfile:'srgb'},modes:{}};
const server=await createServer({root:here,server:{host:'127.0.0.1',port:0,fs:{allow:[root]}}});
await server.listen();
const browser=await chromium.launch({executablePath:process.env.CHROME_PATH||'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',headless:true,args:['--force-color-profile=srgb']});
const out=process.env.SLIDER_CAPTURE_DIR || path.join(here,'out/range_slider');
await mkdir(out,{recursive:true});
const errors=[];
try {
  data.environment.browser=await browser.version();
  const page=await browser.newPage({viewport:{width:1024,height:768},deviceScaleFactor:1,reducedMotion:'no-preference'});
  page.on('pageerror',e=>errors.push(e.message));
  async function measure(locator,pseudo) {
    await page.waitForTimeout(300);
    return locator.evaluate((el,{props,pseudo})=>{
      const s=getComputedStyle(el,pseudo);const r=el.getBoundingClientRect();
      return {tag:pseudo||el.tagName.toLowerCase(),text:pseudo?'':el.textContent,rect:{width:pseudo?parseFloat(s.width):r.width,height:pseudo?parseFloat(s.height):r.height},styles:Object.fromEntries(props.map(k=>[k,s[k]]))};
    },{props,pseudo});
  }
  const base='[data-case="slider-range"]';
  const thumb=i=>page.locator(`${base} [data-slot="slider-thumb"]`).nth(i);
  async function slots() {
    const cases={};
    for(const [name,slot] of [['root','slider'],['track','slider-track'],['fill','slider-fill']]) cases[`slider-range-${name}`]=await measure(page.locator(`${base} [data-slot="${slot}"]`));
    for(const i of [0,1]) {
      cases[`slider-range-thumb${i}`]=await measure(thumb(i));
      cases[`slider-range-thumb${i}-pill`]=await measure(thumb(i),'::after');
    }
    cases['slider-range-disabled-root']=await measure(page.locator('[data-case="slider-range-disabled"] [data-slot="slider"]'));
    return cases;
  }
  for(const mode of ['light','dark']) {
    data.modes[mode]={viewports:{},states:{}};
    await page.emulateMedia({colorScheme:mode,reducedMotion:'no-preference'});
    for(const width of [375,1024]) {
      await page.setViewportSize({width,height:768});
      await page.goto(server.resolvedUrls.local[0]+'range_slider.html');
      await page.evaluate(mode=>{document.documentElement.className=mode;document.documentElement.dataset.theme=mode;},mode);
      await page.locator(`${base} [data-slot="slider-thumb"]`).first().waitFor();
      await page.evaluate(async()=>{await document.fonts.load('16px SliderGeist');await document.fonts.ready;if(!document.fonts.check('16px SliderGeist')) throw Error('Geist did not load');});
      data.modes[mode].viewports[width]=await slots();
    }
    await page.locator(base).screenshot({path:path.join(out,`${mode}-range-rest.png`)});
    for(const i of [0,1]) {
      await thumb(i).hover();
      data.modes[mode].states[`slider-range-hover-thumb${i}`]=await measure(thumb(i));
      await page.locator(base).screenshot({path:path.join(out,`${mode}-range-hover${i}.png`)});
      await page.mouse.move(1,1);
      // Keyboard modality before direct focus: upstream's visible-focus state.
      await page.keyboard.press('Tab');await thumb(i).locator('input').focus();
      data.modes[mode].states[`slider-range-focus-thumb${i}`]=await measure(thumb(i));
      await page.locator(base).screenshot({path:path.join(out,`${mode}-range-focus${i}.png`)});
      await thumb(i).locator('input').blur();
      const b=await thumb(i).boundingBox();await page.mouse.move(b.x+b.width/2,b.y+b.height/2);await page.mouse.down();
      await page.mouse.move(b.x+b.width/2+2,b.y+b.height/2);
      data.modes[mode].states[`slider-range-drag-thumb${i}-pill`]=await measure(thumb(i),'::after');
      await page.locator(base).screenshot({path:path.join(out,`${mode}-range-press${i}.png`)});
      await page.mouse.up();await page.locator('body').click({position:{x:1,y:1}});
    }
    await page.locator('[data-case="slider-range-disabled"]').screenshot({path:path.join(out,`${mode}-range-disabled.png`)});
    await page.evaluate(()=>{document.documentElement.dir='rtl';document.documentElement.style.fontSize='200%';});
    data.modes[mode].states['slider-range-rtl-root']=await measure(page.locator(`${base} [data-slot="slider"]`));
    await page.locator(base).screenshot({path:path.join(out,`${mode}-range-rtl-200.png`)});
  }
  assert.deepEqual(errors,[]);
  await writeFile(path.join(reference,'chromium/range_slider.json'),JSON.stringify(data,null,2)+'\n');
} finally {await browser.close();await server.close();}
