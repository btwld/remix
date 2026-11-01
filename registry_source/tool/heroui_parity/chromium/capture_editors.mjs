// Actual upstream React/CSS evidence; never import Flutter implementation values.
//
// InputGroup, TextArea and SearchField, rendered from editors.jsx: every case
// at four widths in light and dark, the empty and read-only clear buttons, and
// keyboard and pointer behavior. Writes reference/heroui_3_2_6/chromium/editors.json.
import {createServer} from 'vite';
import {chromium} from 'playwright-core';
import {readFile, mkdir, writeFile} from 'node:fs/promises';
import {fileURLToPath} from 'node:url';
import path from 'node:path';
import assert from 'node:assert/strict';
import {measureElement} from './measure.mjs';

const here = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(here, '../../../..');
const reference = path.join(root, 'registry_source/reference/heroui_3_2_6');
const source = JSON.parse(await readFile(path.join(reference, 'sources.json')));
const lock = JSON.parse(await readFile(path.join(here, 'package-lock.json')));
// Form and field hooks must share the same state-context module instance.
assert.equal(lock.packages['node_modules/react-stately'].version, '3.50.0');
for (const owner of ['react-aria', 'react-aria-components']) {
  assert.equal(lock.packages[`node_modules/${owner}/node_modules/react-stately`], undefined,
    `${owner} must share the root react-stately context`);
}
for (const pkg of source.packages) {
  assert.equal(lock.packages[`node_modules/${pkg.name}`].version, pkg.version);
  assert.equal(lock.packages[`node_modules/${pkg.name}`].integrity, pkg.integrity);
}
const screenshots = path.join(root, 'registry_source/tool/heroui_parity/chromium/out/editors');
await mkdir(screenshots, {recursive: true});

const MODES = ['light', 'dark'];
const WIDTHS = [375, 640, 768, 1024];
const PROPS = ['height', 'minHeight', 'width', 'minWidth', 'maxWidth',
  'paddingTop', 'paddingRight', 'paddingBottom', 'paddingLeft',
  'marginTop', 'marginRight', 'marginBottom', 'marginLeft', 'gap',
  'borderRadius', 'borderTopWidth', 'borderRightWidth', 'borderBottomWidth', 'borderLeftWidth',
  'borderColor', 'backgroundColor', 'color', 'opacity',
  'fontSize', 'fontFamily', 'fontWeight', 'fontStyle', 'lineHeight', 'letterSpacing', 'wordSpacing',
  'textAlign', 'textDecorationLine', 'textOverflow', 'whiteSpace',
  'boxShadow', 'outline', 'outlineOffset', 'transform', 'translate', 'scale',
  'transitionDuration', 'transitionProperty', 'animationDuration', 'animationName', 'animationTimingFunction',
  'cursor', 'objectFit', 'display', 'position', 'overflow', 'maskImage', 'maskSize'];
const PSEUDO_PROPS = ['content', 'width', 'height', 'backgroundImage', 'backgroundColor', 'animationName',
  'animationDuration', 'translate', 'transform', 'scale', 'opacity', 'mixBlendMode'];

const data = {schema: 1, upstream: source.commit, environment: {}, modes: {}};
let server, browser, page;

const measure = locator => measureElement(locator, PROPS, PSEUDO_PROPS);

/** Measures every element with a data-testid, keyed by that id. */
async function matrix() {
  const out = {};
  for (const element of await page.locator('[data-testid]').all()) {
    out[await element.getAttribute('data-testid')] = await measure(element);
  }
  return out;
}

const isFocused = locator => locator.evaluate(el => el === document.activeElement);

try {
  server = await createServer({root: here, server: {host: '127.0.0.1', port: 0}});
  await server.listen();
  browser = await chromium.launch({
    executablePath: process.env.CHROME_PATH || '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
    headless: true,
    args: ['--force-color-profile=srgb'],
  });
  const context = await browser.newContext({
    viewport: {width: 1024, height: 1100},
    deviceScaleFactor: 1,
    reducedMotion: 'reduce',
  });
  page = await context.newPage();
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  await page.goto(server.resolvedUrls.local[0] + 'editors.html');
  await page.getByTestId('interactive-search-input').waitFor();
  await page.evaluate(() => document.fonts.ready);

  for (const mode of MODES) {
    await page.reload();
    await page.getByTestId('interactive-search-input').waitFor();
    await page.evaluate(() => document.fonts.ready);
    await page.emulateMedia({colorScheme: mode, reducedMotion: 'reduce'});
    await page.evaluate(mode => {
      document.documentElement.className = mode;
      document.documentElement.dataset.theme = mode;
    }, mode);
    const viewports = {};
    for (const width of WIDTHS) {
      await page.setViewportSize({width, height: 1100});
      viewports[width] = await matrix();
    }

    const state = async () => JSON.parse(await page.getByTestId('state').textContent());

    // Enter submits the search, Escape clears it, and the clear button
    // restores focus to the input.
    const input = page.getByTestId('interactive-search-input');
    await input.focus();
    await page.keyboard.press('Enter');
    assert.equal((await state()).submitted, 'Find');
    await page.keyboard.press('Escape');
    assert.equal((await state()).value, '');
    const emptyClear = await measure(page.getByTestId('interactive-search-clear'));
    await input.fill('Again');
    await page.getByTestId('interactive-search-clear').click();
    assert.equal((await state()).value, '');
    assert.equal(await isFocused(input), true);

    // Escape does not clear a read-only field.
    const readonly = page.getByTestId('search-primary-intrinsic-readonly');
    const readonlyClear = await measure(page.getByTestId('search-primary-intrinsic-readonly-clear'));
    await readonly.locator('input').focus();
    await page.keyboard.press('Escape');
    assert.equal(await readonly.locator('input').inputValue(), 'Find');

    // Clicking an InputGroup prefix focuses its editor.
    await page.getByTestId('input-group-primary-intrinsic-input-prefix').click();
    assert.equal(await isFocused(page.getByTestId('input-group-primary-intrinsic-input-input')), true);
    await page.getByTestId('input-group-primary-intrinsic-textarea-prefix').click();
    const prefixFocusesTextarea = await isFocused(page.getByTestId('input-group-primary-intrinsic-textarea-input'));

    data.modes[mode] = {
      viewports,
      behavior: {
        enterSubmits: true,
        escapeClears: true,
        clearRestoresFocus: true,
        readonlyEscapeSuppressed: true,
        prefixFocusesInput: true,
        prefixFocusesTextarea,
      },
      emptyClear,
      readonlyClear,
    };
    await page.screenshot({path: path.join(screenshots, `${mode}.png`), fullPage: true});
  }

  assert.deepEqual(errors, []);
  data.environment = {
    browser: browser.version(),
    platform: process.platform,
    deviceScaleFactor: 1,
    colorProfile: 'sRGB',
    viewports: WIDTHS,
  };
  await writeFile(path.join(reference, 'chromium/editors.json'), JSON.stringify(data, null, 2) + '\n');
  console.log(`editors: ${Object.keys(data.modes.light.viewports[1024]).length} cases, ` +
    `8 viewport/mode matrices. Chrome ${browser.version()}.`);
} finally {
  await browser?.close();
  await server?.close();
}
