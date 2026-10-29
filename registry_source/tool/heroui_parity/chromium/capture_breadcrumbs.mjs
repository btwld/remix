// Actual upstream React/CSS evidence; never import Flutter implementation values.
//
// Breadcrumbs, rendered from breadcrumbs.jsx: item rects and the list gap at
// rest and with keyboard focus, per mode, width, and direction. Writes
// reference/heroui_3_2_6/chromium/breadcrumbs_visual.json.
import {createServer} from 'vite';
import {chromium} from 'playwright-core';
import {readFile, writeFile, mkdir} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {fileURLToPath} from 'node:url';
import path from 'node:path';
import assert from 'node:assert/strict';

const here = path.dirname(fileURLToPath(import.meta.url));
const reference = path.resolve(here, '../../../reference/heroui_3_2_6');
const out = path.join(here, 'out/breadcrumbs');
await mkdir(out, {recursive: true});

const WIDTHS = [375, 1024];
const MODES = ['light', 'dark'];
const DIRECTIONS = ['ltr', 'rtl'];
const FIXTURE_FILES = ['breadcrumbs.html', 'breadcrumbs.css', 'breadcrumbs.jsx', 'capture_breadcrumbs.mjs'];

const sha256 = bytes => createHash('sha256').update(bytes).digest('hex');

const errors = [];
const visual = [];
let server;
let browser;

try {
  server = await createServer({root: here, server: {host: '127.0.0.1', port: 0}});
  await server.listen();
  browser = await chromium.launch({
    executablePath: process.env.CHROME_PATH || '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
    headless: true,
    args: ['--force-color-profile=srgb'],
  });
  const page = await browser.newPage({
    viewport: {width: 1024, height: 300},
    deviceScaleFactor: 1,
    reducedMotion: 'reduce',
  });
  page.on('pageerror', error => errors.push(error.message));
  await page.goto(server.resolvedUrls.local[0] + 'breadcrumbs.html');
  await page.waitForFunction(() => window.breadcrumbsFixture);

  const mount = props => page.evaluate(props => window.breadcrumbsFixture.mount(props), props);
  const snapshot = () => page.evaluate(() => window.breadcrumbsFixture.snapshot());
  const links = page.locator('[data-slot=link]');
  /** Screenshots the page and records the fixture's state under [stateName]. */
  const capture = async (entry, stateName) => {
    const file = `${entry.mode}-${entry.width}-${entry.direction}-${stateName}.png`;
    const bytes = await page.screenshot({path: path.join(out, file)});
    visual.push({...entry, stateName, file, sha256: sha256(bytes), state: await snapshot()});
  };

  for (const width of WIDTHS) {
    for (const mode of MODES) {
      for (const direction of DIRECTIONS) {
        await page.setViewportSize({width, height: 300});
        await mount({mode, direction});
        await page.mouse.move(0, 0);
        await page.evaluate(() => document.fonts.ready);
        await page.waitForTimeout(100);
        await capture({width, mode, direction}, 'rest');

        // Shift+Tab back onto the first link so it shows keyboard focus.
        await links.first().focus();
        await page.keyboard.press('Tab');
        await page.keyboard.press('Shift+Tab');
        await page.waitForTimeout(100);
        await capture({width, mode, direction}, 'keyboard');
      }
    }
  }

  assert.deepEqual(errors, []);
  for (const {state} of visual) {
    assert.equal(state.root.tag, 'OL');
    assert.equal(state.root.gap, '6px');
    assert.equal(state.items[0].fontSize, '14px');
    assert.equal(state.items[0].lineHeight, '20px');
    assert.equal(state.items[0].separator.rect.width, 12);
  }

  const hashes = Object.fromEntries(await Promise.all(FIXTURE_FILES.map(
    async file => [file, sha256(await readFile(path.join(here, file)))])));
  const sources = JSON.parse(await readFile(path.join(reference, 'sources.json')));
  const lock = JSON.parse(await readFile(path.join(here, 'package-lock.json')));
  assert.equal(lock.packages['node_modules/@heroui/react'].version, '3.2.6');
  await writeFile(path.join(reference, 'chromium/breadcrumbs_visual.json'), JSON.stringify({
    upstream: sources.commit,
    dependency: '@heroui/react@3.2.6',
    browser: browser.version(),
    hashes,
    visual,
  }, null, 2) + '\n');
  console.log(`breadcrumbs: ${visual.length} captures.`);
} finally {
  await browser?.close();
  await server?.close();
}
