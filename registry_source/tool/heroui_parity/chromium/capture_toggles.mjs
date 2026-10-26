// Actual upstream React/CSS evidence; never import Flutter implementation values.
//
// ToggleButton and ToggleButtonGroup, rendered from toggles.jsx: every case at
// four widths in light and dark, RTL group geometry, and keyboard selection
// behavior. Writes reference/heroui_3_2_6/chromium/toggles.json.
import {createServer} from 'vite';
import {chromium} from 'playwright-core';
import {readFile, mkdir, writeFile} from 'node:fs/promises';
import {fileURLToPath} from 'node:url';
import path from 'node:path';
import assert from 'node:assert/strict';

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
const screenshots = path.join(root, 'registry_source/tool/heroui_parity/chromium/out/toggles');
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
const RTL_IDS = ['group-horizontal-joined-auto-md-a', 'group-horizontal-joined-auto-md-b',
  'group-horizontal-joined-auto-md-separator'];

const data = {schema: 1, upstream: source.commit, environment: {}, modes: {}};
let server, browser, page;

/** Rect, computed styles, pseudo-element styles, and attributes of one element. */
function measure(locator) {
  return locator.evaluate((el, {props, pseudoProps}) => {
    const style = getComputedStyle(el);
    const rect = el.getBoundingClientRect();
    const parent = el.parentElement.getBoundingClientRect();
    const pseudo = which => {
      const computed = getComputedStyle(el, which);
      return Object.fromEntries(pseudoProps.map(k => [k, computed[k]]));
    };
    return {
      tag: el.tagName,
      text: el.textContent,
      rect: {width: rect.width, height: rect.height, parentX: rect.x - parent.x, parentY: rect.y - parent.y},
      styles: Object.fromEntries(props.map(k => [k, style[k]])),
      before: pseudo('::before'),
      after: pseudo('::after'),
      attributes: Object.fromEntries([...el.attributes]
        .filter(a => a.name.startsWith('data-') || a.name.startsWith('aria-')
          || ['role', 'disabled', 'title', 'alt'].includes(a.name))
        .map(a => [a.name, a.value])),
    };
  }, {props: PROPS, pseudoProps: PSEUDO_PROPS});
}

/** Measures every element with a data-testid, keyed by that id. */
async function matrix() {
  const out = {};
  for (const element of await page.locator('[data-testid]').all()) {
    out[await element.getAttribute('data-testid')] = await measure(element);
  }
  return out;
}

/** The interactive group's selected keys, as rendered into the fixture's state output. */
const selected = async () => JSON.parse(await page.getByTestId('state').textContent());

const isFocused = id => page.getByTestId(id).evaluate(el => el === document.activeElement);

try {
  server = await createServer({root: here, server: {host: '127.0.0.1', port: 0}});
  await server.listen();
  const url = server.resolvedUrls.local[0] + 'toggles.html';
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
  await page.goto(url);
  await page.getByTestId('interactive-a').waitFor();
  await page.evaluate(() => document.fonts.ready);

  for (const mode of MODES) {
    await page.goto(url);
    await page.getByTestId('interactive-a').waitFor();
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

    // Arrows move focus without selecting; Space and Enter toggle; the
    // disabled button is skipped.
    await page.getByTestId('interactive-a').focus();
    await page.keyboard.press('ArrowRight');
    assert.equal(await isFocused('interactive-b'), true);
    assert.deepEqual(await selected(), ['a']);
    await page.keyboard.press('Space');
    assert.deepEqual(new Set(await selected()), new Set(['a', 'b']));
    await page.keyboard.press('ArrowRight');
    assert.equal(await isFocused('interactive-d'), true);
    await page.keyboard.press('Enter');
    assert.deepEqual(new Set(await selected()), new Set(['a', 'b', 'd']));

    // A required single-selection group cannot be emptied; picking another
    // button replaces the selection.
    await page.getByTestId('required-a').click();
    assert.equal(await page.getByTestId('required-a').getAttribute('data-selected'), 'true');
    await page.getByTestId('required-b').click();
    assert.equal(await page.getByTestId('required-a').getAttribute('data-selected'), null);
    assert.equal(await page.getByTestId('required-b').getAttribute('data-selected'), 'true');
    const nested = await measure(page.getByTestId('nested-child'));

    // The fixture switches to an Arabic locale for ?rtl, which reverses the arrow keys.
    await page.goto(url + '?rtl=1');
    await page.getByTestId('interactive-a').waitFor();
    await page.evaluate(mode => {
      document.documentElement.dir = 'rtl';
      document.documentElement.className = mode;
      document.documentElement.dataset.theme = mode;
    }, mode);
    const rtl = {};
    for (const id of RTL_IDS) rtl[id] = await measure(page.getByTestId(id));
    await page.getByTestId('interactive-b').focus();
    await page.keyboard.press('ArrowRight');
    assert.equal(await isFocused('interactive-a'), true);
    await page.evaluate(() => {
      document.documentElement.dir = 'ltr';
    });

    data.modes[mode] = {
      viewports,
      rtl,
      nested,
      behavior: {
        arrowsFocusWithoutSelection: true,
        multipleSelection: true,
        disabledSkipped: true,
        spaceToggles: true,
        enterToggles: true,
        requiredCannotDeselect: true,
        singleReplaces: true,
        rtlArrowsReversed: true,
      },
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
  await writeFile(path.join(reference, 'chromium/toggles.json'), JSON.stringify(data, null, 2) + '\n');
  console.log(`toggles: ${Object.keys(data.modes.light.viewports[1024]).length} cases, ` +
    `8 viewport/mode matrices. Chrome ${browser.version()}.`);
} finally {
  await browser?.close();
  await server?.close();
}
