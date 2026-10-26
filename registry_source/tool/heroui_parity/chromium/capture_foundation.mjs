// Actual upstream React/CSS evidence; never import Flutter implementation values.
//
// Avatar, Badge, Surface, Separator, Typography, Kbd, Skeleton, Spinner, Link,
// CloseButton and ButtonGroup, rendered from foundation.jsx: every case at four
// widths in light and dark, hover/pressed/focus states, RTL geometry, and
// animation samples. Writes reference/heroui_3_2_6/chromium/foundation.json.
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
const screenshots = path.join(root, 'registry_source/tool/heroui_parity/chromium/out/foundation');
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
// Cases that run animations; sampled at fixed times with the animation paused.
const MOTION_IDS = ['spinner-accent-md', 'skeleton-shimmer', 'skeleton-pulse', 'skeleton-nested',
  'skeleton-nested-child'];
const MOTION_TIMES = [0, 250, 500, 750, 1500];
const RTL_IDS = ['avatar-group-clip-md', 'avatar-group-clip-md-0', 'avatar-group-clip-md-1',
  'badge-anchored-top-right', 'button-group-outline-md-horizontal-first',
  'button-group-outline-md-horizontal-last', 'typography-align-start', 'typography-align-end'];

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

async function stateMatrix() {
  const out = {};
  for (const id of ['link', 'close-button', 'button-group-outline-md-horizontal-first']) {
    const el = page.getByTestId(id);
    await el.hover();
    out[`${id}-hover`] = await measure(el);
    await page.mouse.down();
    out[`${id}-pressed`] = await measure(el);
    await page.mouse.up();
    await page.mouse.move(0, 0);
    await page.keyboard.press('Tab');
    await el.focus();
    out[`${id}-focus`] = await measure(el);
    await el.blur();
  }
  return out;
}

/** Animation keyframes and timing, plus measurements at fixed times, for each animated case. */
async function motionSamples() {
  await page.emulateMedia({reducedMotion: 'no-preference'});
  const result = {};
  for (const id of MOTION_IDS) {
    const el = page.getByTestId(id);
    const animation = await el.evaluate(node => node.getAnimations({subtree: true}).map(a => ({
      name: a.animationName,
      keyframes: a.effect.getKeyframes(),
      timing: a.effect.getTiming(),
    })));
    const samples = [];
    for (const time of MOTION_TIMES) {
      await el.evaluate((node, time) => {
        for (const a of node.getAnimations({subtree: true})) {
          a.pause();
          a.currentTime = time;
        }
      }, time);
      samples.push({time, measurement: await measure(el)});
    }
    result[id] = {animation, samples};
  }
  await page.emulateMedia({reducedMotion: 'reduce'});
  result.reduced = {};
  for (const id of ['spinner-accent-md', 'skeleton-shimmer', 'skeleton-pulse']) {
    result.reduced[id] = await measure(page.getByTestId(id));
  }
  return result;
}

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
  });
  page = await context.newPage();
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  await page.goto(server.resolvedUrls.local[0] + 'foundation.html');
  await page.getByTestId('avatar-default-default-md').waitFor();
  await page.evaluate(() => document.fonts.ready);
  await page.getByTestId('avatar-image-content').waitFor();
  await page.getByTestId('avatar-failed-fallback').waitFor();

  for (const mode of MODES) {
    await page.emulateMedia({colorScheme: mode, reducedMotion: 'reduce'});
    await page.evaluate(mode => {
      document.documentElement.className = mode;
      document.documentElement.dataset.theme = mode;
      document.documentElement.dir = 'ltr';
    }, mode);
    // Pause existing animations at their first frame for stable geometry and paint.
    await page.evaluate(() => {
      for (const a of document.getAnimations()) {
        a.pause();
        a.currentTime = 0;
      }
    });
    const viewports = {};
    for (const width of WIDTHS) {
      await page.setViewportSize({width, height: 1100});
      viewports[width] = await matrix();
    }
    const states = await stateMatrix();

    // A pending close button stays focusable but does not activate; a Link
    // activates on Enter, not Space; a button's own isDisabled overrides its
    // ButtonGroup, and buttons nested deeper do not inherit the group.
    const counter = async () => Number(await page.getByTestId('activation-count').textContent());
    const pending = page.getByTestId('close-button-pending');
    await pending.focus();
    const before = await counter();
    assert.equal(await pending.evaluate(el => el === document.activeElement), true);
    await page.keyboard.press('Enter');
    assert.equal(await counter(), before);
    assert.equal(await pending.getAttribute('aria-disabled'), 'true');
    const link = page.getByTestId('link');
    await link.focus();
    await page.keyboard.press('Enter');
    assert.equal(await counter(), before + 1);
    await page.keyboard.press('Space');
    assert.equal(await counter(), before + 1);
    assert.equal(await page.getByTestId('link-disabled').getAttribute('aria-disabled'), 'true');
    assert.equal(await page.getByTestId('button-group-inherited-disabled').isDisabled(), true);
    assert.equal(await page.getByTestId('button-group-explicit-override').isDisabled(), false);
    assert.equal(await page.getByTestId('button-group-nested').isDisabled(), false);
    assert.equal(await page.getByTestId('avatar-image').getByText('Fallback').count(), 0);
    assert.match(await page.getByTestId('avatar-group-clip-md').textContent(), /\+2/);
    assert.match(await page.getByTestId('avatar-group-explicit-count').textContent(), /More/);
    assert.equal(await page.getByTestId('spinner-accent-md').getAttribute('role'), 'status');

    await setDirection('rtl');
    const rtl = {};
    for (const id of RTL_IDS) rtl[id] = await measure(page.getByTestId(id));
    await setDirection('ltr');
    const motion = await motionSamples();

    data.modes[mode] = {
      viewports,
      states,
      rtl,
      motion,
      behavior: {
        avatarFallbackRemovedOnLoad: true,
        avatarFailureFallback: true,
        avatarGroupTruncation: true,
        avatarGroupExplicitCount: true,
        pendingCloseFocusable: true,
        pendingCloseSuppressed: true,
        linkEnterActivation: true,
        linkSpaceNotActivation: true,
        disabledLinkSemantics: true,
        buttonGroupDisabledInherited: true,
        buttonGroupExplicitOverride: true,
        buttonGroupNestedNotInherited: true,
        spinnerStatus: true,
      },
    };
    await page.screenshot({path: path.join(screenshots, `${mode}.png`), fullPage: true});
  }

  assert.deepEqual(errors, [], 'upstream foundation runtime errors');
  data.environment = {
    browser: browser.version(),
    platform: process.platform,
    deviceScaleFactor: 1,
    colorProfile: 'sRGB',
    viewports: WIDTHS,
    react: lock.packages['node_modules/react'].version,
    reactAriaComponents: lock.packages['node_modules/react-aria-components'].version,
    tailwind: lock.packages['node_modules/tailwindcss'].version,
    fonts: await page.evaluate(() => ({
      body: getComputedStyle(document.body).fontFamily,
      rootSize: getComputedStyle(document.documentElement).fontSize,
      hover: matchMedia('(hover: hover)').matches,
      pointer: matchMedia('(pointer: fine)').matches,
    })),
  };
  await writeFile(path.join(reference, 'chromium/foundation.json'), JSON.stringify(data, null, 2) + '\n');
  console.log(`foundation: ${Object.keys(data.modes.light.viewports[1024]).length} cases, ` +
    `8 viewport/mode matrices. Chrome ${browser.version()}.`);
} finally {
  await browser?.close();
  await server?.close();
}
