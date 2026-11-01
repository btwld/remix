// Actual upstream React/CSS evidence; never import Flutter implementation values.
//
// Button, Chip, Card, TextField and Popover, rendered from fixture.jsx: every
// theme token resolved to sRGB, every component at four widths in light and
// dark, hover/pressed/focus states, pending and popover behavior, RTL and
// motion samples, and the same components under custom accent and radius
// overrides. Writes reference/heroui_3_2_6/chromium/measurements.json and
// tokens.json.
// Run `npm ci && npm run generate`; CHROME_PATH selects another Chrome binary.
import {createServer} from 'vite';
import {chromium} from 'playwright-core';
import {readFile, mkdir, writeFile} from 'node:fs/promises';
import {fileURLToPath} from 'node:url';
import path from 'node:path';
import assert from 'node:assert/strict';

const here = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(here, '../../../..');
const output = path.join(root, 'registry_source/reference/heroui_3_2_6/chromium');
const screenshots = path.join(root, 'registry_source/tool/heroui_parity/chromium/out/screenshots');
const source = JSON.parse(await readFile(path.join(root, 'registry_source/reference/heroui_3_2_6/sources.json')));
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

const MODES = ['light', 'dark'];
const WIDTHS = [375, 640, 768, 1024];
const BUTTON_VARIANTS = ['primary', 'secondary', 'tertiary', 'outline', 'ghost', 'danger', 'danger-soft'];
// Applied on top of the theme in the custom-theme pass.
const OVERRIDES = {
  '--accent': '#b43af2',
  '--accent-foreground': '#ffffee',
  '--danger': 'rgb(170 34 102 / 0.8)',
  '--radius': '20px',
};
const CUSTOM_THEME_CASES = [
  'button-primary-md', 'button-danger-soft-md', 'chip-soft-accent-md', 'card-default', 'input-primary-rest',
];

const PROPS = ['height', 'minHeight', 'width', 'minWidth', 'paddingTop', 'paddingRight', 'paddingBottom',
  'paddingLeft', 'gap', 'borderRadius', 'borderWidth', 'borderColor', 'backgroundColor', 'color', 'opacity',
  'fontSize', 'fontFamily', 'fontWeight', 'lineHeight', 'letterSpacing', 'boxShadow', 'outline',
  'outlineOffset', 'transform', 'transitionDuration', 'transitionProperty', 'animationDuration', 'cursor'];

const themeCss = await Promise.all(['default/variables.css', 'shared/theme.css'].map(file =>
  readFile(path.join(here, 'node_modules/@heroui/styles/dist/themes', file), 'utf8')));
const tokenNames = [...new Set(themeCss[0].match(/--[a-z][a-z0-9-]*(?=\s*:)/g))].sort();

await mkdir(output, {recursive: true});
await mkdir(screenshots, {recursive: true});

let server, browser, page;

/** Tag, size, computed styles, and data-/aria-/disabled attributes of one element. */
function measure(locator) {
  return locator.evaluate((el, props) => {
    const style = getComputedStyle(el);
    const rect = el.getBoundingClientRect();
    return {
      tag: el.tagName,
      rect: {width: rect.width, height: rect.height},
      styles: Object.fromEntries(props.map(k => [k, style[k]])),
      attributes: Object.fromEntries([...el.attributes]
        .filter(a => a.name.startsWith('data-') || a.name.startsWith('aria-') || a.name === 'disabled')
        .map(a => [a.name, a.value])),
    };
  }, PROPS);
}

/** Waits for the popover to finish entering and for its bounds to stop moving. */
async function settledPopover() {
  const content = page.getByTestId('popover-content');
  await content.waitFor();
  // The element can be attached before its entering frame (opacity 0, scale .9)
  // ends, even with reduced motion, so measure only the settled anatomy.
  await page.waitForFunction(() => {
    const el = document.querySelector('[data-testid="popover-content"]');
    return el && !el.hasAttribute('data-entering') &&
      !el.hasAttribute('data-exiting') && getComputedStyle(el).opacity === '1';
  });
  let previous;
  let stable = 0;
  for (let attempt = 0; attempt < 30; attempt++) {
    const current = JSON.stringify(await content.boundingBox());
    stable = current === previous ? stable + 1 : 0;
    previous = current;
    if (stable >= 2) return content;
    await page.waitForTimeout(50);
  }
  throw new Error('Popover bounds did not settle before measurement');
}

/** Every theme token as `{raw, resolved, rgba, rgbaFloat}`; non-colors keep only `raw`. */
const readTokens = () => page.evaluate(names => {
  const style = getComputedStyle(document.documentElement);
  const swatch = document.createElement('span');
  document.body.append(swatch);
  const canvas = document.createElement('canvas');
  canvas.width = canvas.height = 1;
  const ctx = canvas.getContext('2d', {colorSpace: 'srgb'});
  const values = {};
  for (const name of names) {
    const raw = style.getPropertyValue(name).trim();
    if (!raw) throw new Error(`Unresolved token ${name}`);
    const result = {raw};
    if (CSS.supports('color', raw)) {
      swatch.style.color = `var(${name})`;
      result.resolved = getComputedStyle(swatch).color;
      ctx.clearRect(0, 0, 1, 1);
      ctx.fillStyle = result.resolved;
      ctx.fillRect(0, 0, 1, 1);
      result.rgba = [...ctx.getImageData(0, 0, 1, 1).data];
      // float16 avoids the 8-bit canvas quantization of translucent colors.
      try {
        result.rgbaFloat = [...ctx.getImageData(0, 0, 1, 1, {colorSpace: 'srgb', pixelFormat: 'rgba-float16'}).data];
      } catch {
        // Float16 readback is optional; the 8-bit channels remain.
      }
    }
    values[name.slice(2)] = result;
  }
  swatch.remove();
  return values;
}, tokenNames);

const setDirection = direction => page.evaluate(direction => {
  document.documentElement.dir = direction;
}, direction);

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
    colorScheme: 'light',
  });
  page = await context.newPage();
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  await page.goto(server.resolvedUrls.local[0]);
  await page.getByTestId('button-primary-md').waitFor();
  await page.evaluate(() => document.fonts.ready);

  const data = {
    schema: 1,
    upstream: source.commit,
    environment: {
      browser: browser.version(),
      platform: process.platform,
      deviceScaleFactor: 1,
      colorProfile: 'sRGB',
      react: lock.packages['node_modules/react'].version,
      reactAriaComponents: lock.packages['node_modules/react-aria-components'].version,
      tailwind: lock.packages['node_modules/tailwindcss'].version,
      reducedMotion: 'reduce',
      viewports: WIDTHS,
    },
    modes: {},
  };

  for (const mode of MODES) {
    await page.emulateMedia({colorScheme: mode});
    await page.evaluate(mode => {
      document.documentElement.className = mode;
      document.documentElement.dataset.theme = mode;
    }, mode);
    await page.waitForTimeout(100);
    const tokens = await readTokens();

    const viewports = {};
    for (const width of WIDTHS) {
      await page.setViewportSize({width, height: 1100});
      const components = {};
      for (const element of await page.locator('[data-testid]').all()) {
        components[await element.getAttribute('data-testid')] = await measure(element);
      }
      viewports[width] = components;
    }
    await page.screenshot({path: path.join(screenshots, `${mode}-1024.png`), fullPage: true});

    const states = {};
    for (const variant of BUTTON_VARIANTS) {
      const button = page.getByTestId(`button-${variant}-md`);
      await button.hover();
      states[`${variant}-hover`] = await measure(button);
      await page.mouse.down();
      states[`${variant}-pressed`] = await measure(button);
      await page.mouse.up();
      await page.mouse.move(0, 0);
      await page.keyboard.press('Tab');
      await button.focus();
      states[`${variant}-focus`] = await measure(button);
      await button.blur();
    }
    const invalid = page.getByTestId('input-primary-invalid');
    await invalid.focus();
    states['input-invalid-focus'] = await measure(invalid);
    await invalid.blur();

    // A pending button stays focusable but does not activate.
    const pending = page.getByTestId('button-pending');
    await pending.focus();
    assert.equal(await pending.evaluate(el => document.activeElement === el), true);
    await page.keyboard.press('Enter');
    assert.equal(await page.getByTestId('button-counter').textContent(), 'Count 0');
    assert.equal(await pending.getAttribute('aria-disabled'), 'true');

    // The popover is a dialog that traps focus, closes on Escape and on an
    // outside click, and returns focus to its trigger.
    const trigger = page.getByTestId('popover-trigger');
    await trigger.click();
    await page.getByTestId('popover-content').waitFor();
    states['popover-open'] = await measure(await settledPopover());
    assert.equal(await page.getByRole('dialog').count(), 1);
    await page.keyboard.press('Tab');
    const focusInside = await page.getByRole('dialog').evaluate(el => el.contains(document.activeElement));
    assert.equal(focusInside, true);
    await page.keyboard.press('Escape');
    await page.getByTestId('popover-content').waitFor({state: 'hidden'});
    assert.equal(await trigger.evaluate(el => document.activeElement === el), true);
    await trigger.click();
    await page.getByTestId('popover-content').waitFor();
    await page.mouse.click(2, 2);
    await page.getByTestId('popover-content').waitFor({state: 'hidden'});

    await setDirection('rtl');
    states['rtl-button-leading'] = await measure(page.getByTestId('button-leading'));
    await setDirection('ltr');
    await page.emulateMedia({reducedMotion: 'no-preference'});
    states['motion-button'] = await measure(page.getByTestId('button-primary-md'));
    await page.emulateMedia({reducedMotion: 'reduce'});

    data.modes[mode] = {
      tokens,
      viewports,
      states,
      behavior: {
        pendingFocusable: true,
        pendingActivationSuppressed: true,
        popoverDialog: true,
        popoverFocusInside: true,
        popoverEscapeDismissal: true,
        popoverOutsideDismissal: true,
        popoverFocusRestored: true,
      },
    };
  }

  data.customThemes = {};
  for (const mode of MODES) {
    await page.emulateMedia({colorScheme: mode});
    await page.evaluate(({mode, overrides}) => {
      document.documentElement.className = mode;
      document.documentElement.dataset.theme = mode;
      for (const [name, value] of Object.entries(overrides)) {
        document.documentElement.style.setProperty(name, value);
      }
    }, {mode, overrides: OVERRIDES});
    await page.mouse.move(0, 0);
    const tokens = await readTokens();
    const components = {};
    for (const id of CUSTOM_THEME_CASES) components[id] = await measure(page.getByTestId(id));
    await page.getByTestId('popover-trigger').click();
    await page.getByTestId('popover-content').waitFor();
    components['popover-content'] = await measure(await settledPopover());
    await page.keyboard.press('Escape');
    await page.getByTestId('popover-content').waitFor({state: 'hidden'});
    data.customThemes[mode] = {overrides: OVERRIDES, tokens, components};
  }

  assert.deepEqual(errors, [], 'Upstream fixture browser errors');
  data.environment.fonts = await page.evaluate(() => ({
    rootSize: getComputedStyle(document.documentElement).fontSize,
    body: getComputedStyle(document.body).fontFamily,
    hover: matchMedia('(hover: hover)').matches,
    pointer: matchMedia('(pointer: fine)').matches,
  }));
  const cdp = await context.newCDPSession(page);
  await cdp.send('DOM.enable');
  await cdp.send('CSS.enable');
  for (let attempt = 0; attempt < 3; attempt++) {
    try {
      const {root: doc} = await cdp.send('DOM.getDocument');
      const {nodeId} = await cdp.send('DOM.querySelector', {
        nodeId: doc.nodeId,
        selector: '[data-testid="button-primary-md"]',
      });
      data.environment.resolvedFonts = (await cdp.send('CSS.getPlatformFontsForNode', {nodeId})).fonts;
      break;
    } catch (error) {
      if (attempt === 2) throw error;
    }
  }

  const tokensByMode = Object.fromEntries(Object.entries(data.modes).map(([mode, value]) => [mode, value.tokens]));
  await writeFile(path.join(output, 'measurements.json'), JSON.stringify(data, null, 2) + '\n');
  await writeFile(path.join(output, 'tokens.json'), JSON.stringify(tokensByMode, null, 2) + '\n');
  console.log(`generate: ${tokenNames.length} tokens, 8 viewport/mode matrices, custom themes. ` +
    `Chrome ${data.environment.browser}.`);
} finally {
  await browser?.close();
  await server?.close();
}
