// Actual upstream React/CSS evidence; never import Flutter implementation values.
//
// Menu, rendered from menu.jsx: every slot per item variant, mode, and width,
// at rest and after a keyboard interaction. Writes
// reference/heroui_3_2_6/chromium/menu_visual.json.
import {createServer} from 'vite';
import {chromium} from 'playwright-core';
import {readFile, writeFile, mkdir} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {fileURLToPath} from 'node:url';
import path from 'node:path';
import assert from 'node:assert/strict';

const here = path.dirname(fileURLToPath(import.meta.url));
const reference = path.resolve(here, '../../../reference/heroui_3_2_6');
const out = path.join(here, 'out/menu');
await mkdir(out, {recursive: true});
const source = JSON.parse(await readFile(path.join(reference, 'sources.json')));

const WIDTHS = [375, 1024];
const MODES = ['light', 'dark'];
const VARIANTS = ['default', 'danger'];
const STYLES = [
  'backgroundColor', 'color', 'borderRadius', 'padding', 'gap', 'fontSize', 'fontWeight',
  'lineHeight', 'boxShadow', 'outline', 'transitionDuration', 'opacity',
];
const FIXTURE_FILES = ['menu.html', 'menu.jsx', 'menu.css', 'capture_menu.mjs'];

const sha256 = bytes => createHash('sha256').update(bytes).digest('hex');
const nextFrame = page => page.evaluate(
  () => new Promise(resolve => requestAnimationFrame(() => requestAnimationFrame(resolve))));

const data = {upstream: source.commit, cases: [], errors: []};
let server;
let browser;

/** Runs in the page: the rect, attributes, and computed styles of each element. */
function measureElements(elements, styles) {
  return elements.map(el => {
    const computed = getComputedStyle(el);
    const r = el.getBoundingClientRect();
    return {
      slot: el.getAttribute('data-slot'),
      role: el.getAttribute('role'),
      text: el.textContent,
      rect: {x: r.x, y: r.y, width: r.width, height: r.height},
      checked: el.getAttribute('aria-checked'),
      disabled: el.getAttribute('aria-disabled'),
      focused: document.activeElement === el,
      styles: Object.fromEntries(styles.map(k => [k, computed[k]])),
    };
  });
}

/** Records one state of the mounted fixture: a screenshot and every slot's measurements. */
async function record(page, {width, mode, variant, state}) {
  const screenshot = `${mode}-${width}-${variant}-${state}.png`;
  const bytes = await page.screenshot({path: path.join(out, screenshot)});
  const measurements = await page.locator('[data-slot], [role^="menuitem"]').evaluateAll(measureElements, STYLES);
  const items = measurements.filter(el => el.role?.startsWith('menuitem'));
  assert.equal(items.length, 4);
  assert(items.every(el => el.rect.height >= 36));
  assert(items[1].rect.y > items[0].rect.y, 'Compiled vertical option layout required');

  data.cases.push({
    mode, width, variant, state,
    screenshot: `out/menu/${screenshot}`,
    sha256: sha256(bytes),
    measurements,
  });
}

/** One viewport, mode, and variant: mount, record at rest, interact, record again. */
async function capture(width, mode, variant) {
  const context = await browser.newContext({
    viewport: {width, height: 500},
    deviceScaleFactor: 1,
    reducedMotion: 'reduce',
    colorScheme: mode,
  });
  const page = await context.newPage();
  page.on('pageerror', error => data.errors.push(error.message));
  await page.goto(server.resolvedUrls.local[0] + 'menu.html');
  await page.waitForFunction(() => window.menuFixture);
  await page.evaluate(({mode, variant}) => {
    document.documentElement.className = mode;
    document.documentElement.dataset.theme = mode;
    document.body.style.padding = '24px';
    document.body.style.background = 'var(--background)';
    document.getElementById('root').style.width = '320px';
    window.menuFixture.mount({
      itemVariant: variant,
      selectionMode: 'single',
      defaultSelectedKeys: ['a'],
      disabledKeys: ['b'],
    });
    document.querySelectorAll('#before,#after').forEach(el => el.style.display = 'none');
  }, {mode, variant});
  await page.evaluate(() => document.fonts.ready);
  await page.mouse.move(0, 0);
  await nextFrame(page);

  await record(page, {width, mode, variant, state: 'rest'});
  const apple = page.locator('[role^=menuitem]').filter({hasText: 'Apple'});
  await apple.focus();
  await apple.press('ArrowDown');
  await nextFrame(page);
  await record(page, {width, mode, variant, state: 'keyboard-cherry'});
  await context.close();
}

try {
  server = await createServer({root: here, server: {host: '127.0.0.1', port: 0}});
  await server.listen();
  browser = await chromium.launch({
    executablePath: process.env.CHROME_PATH || '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
    headless: true,
    args: ['--force-color-profile=srgb'],
  });
  for (const width of WIDTHS) {
    for (const mode of MODES) {
      for (const variant of VARIANTS) await capture(width, mode, variant);
    }
  }
  assert.deepEqual(data.errors, []);
  data.browser = browser.version();
  data.environment = {deviceScaleFactor: 1, reducedMotion: 'reduce', colorProfile: 'sRGB', hostWidth: 320};
  data.hashes = Object.fromEntries(await Promise.all(FIXTURE_FILES.map(
    async file => [file, sha256(await readFile(path.join(here, file)))])));
  await writeFile(path.join(reference, 'chromium/menu_visual.json'), JSON.stringify(data, null, 2) + '\n');
  console.log(`menu: ${data.cases.length} cases.`);
} finally {
  await browser?.close();
  await server?.close();
}
