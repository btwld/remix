// Actual upstream React/CSS evidence; never import Flutter implementation values.
//
// Checkbox, Radio, Switch and their groups, rendered from selection.jsx: every
// case at four widths in light and dark, hover/pressed/focus states, RTL
// geometry, animation samples, and keyboard and pointer behavior. Writes
// reference/heroui_3_2_6/chromium/selection.json.
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
const screenshots = path.join(root, 'registry_source/tool/heroui_parity/chromium/out/selection');
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
// Cases measured under hover, press, and keyboard focus, each from a fresh page.
const STATE_IDS = ['checkbox-primary-rest', 'checkbox-primary-selected', 'checkbox-primary-invalid-selected',
  'switch-md-rest', 'switch-md-selected', 'radio-primary-vertical-rest-a', 'radio-primary-vertical-rest-b'];
const RTL_IDS = ['switch-md-rest-control', 'switch-md-rest-thumb', 'switch-md-selected-control',
  'switch-md-selected-thumb', 'checkbox-primary-rest-description', 'radio-primary-horizontal-rest'];
const MOTION_TIMES = [0, 75, 150, 250, 300, 500];

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

const state = async () => JSON.parse(await page.getByTestId('state').textContent());

async function reload() {
  await page.reload();
  await page.getByTestId('interactive-checkbox-control').waitFor();
}

const applyTheme = mode => page.evaluate(mode => {
  document.documentElement.className = mode;
  document.documentElement.dataset.theme = mode;
}, mode);

const setDirection = direction => page.evaluate(direction => {
  document.documentElement.dir = direction;
}, direction);

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
  await page.goto(server.resolvedUrls.local[0] + 'selection.html');
  await page.getByTestId('interactive-checkbox-control').waitFor();
  await page.evaluate(() => document.fonts.ready);

  for (const mode of MODES) {
    await reload();
    await page.evaluate(() => document.fonts.ready);
    await page.emulateMedia({colorScheme: mode, reducedMotion: 'reduce'});
    await applyTheme(mode);
    const viewports = {};
    for (const width of WIDTHS) {
      await page.setViewportSize({width, height: 1100});
      viewports[width] = await matrix();
    }

    const states = {};
    for (const id of STATE_IDS) {
      await reload();
      await applyTheme(mode);
      await page.getByTestId(`${id}-content`).hover();
      states[`${id}-hover`] = await measure(page.getByTestId(`${id}-control`));
      await page.mouse.down();
      states[`${id}-pressed`] = await measure(page.getByTestId(`${id}-control`));
      await page.mouse.up();

      await reload();
      await applyTheme(mode);
      await page.mouse.move(0, 0);
      const input = page.getByTestId(id).locator('input');
      await page.keyboard.press('Tab');
      await input.focus();
      assert.equal(await isFocused(input), true, id);
      states[`${id}-focus`] = {
        control: await measure(page.getByTestId(`${id}-control`)),
        content: await measure(page.getByTestId(`${id}-content`)),
        input: await measure(input),
      };
      await input.blur();
    }

    // A checkbox toggles on Space, not on Enter or a click on its description;
    // clicking an indeterminate checkbox selects it and stays indeterminate.
    const check = page.getByTestId('interactive-checkbox');
    await check.locator('input').focus();
    await page.keyboard.press('Enter');
    assert.equal((await state()).check, false);
    await page.keyboard.press('Space');
    assert.equal((await state()).check, true);
    await page.getByTestId('interactive-checkbox-description').click();
    assert.equal((await state()).check, true);
    await page.getByTestId('interactive-mixed-content').click();
    assert.equal((await state()).mixed, true);
    assert.equal(await page.getByTestId('interactive-mixed').locator('input').evaluate(el => el.indeterminate), true);

    // Read-only controls stay focusable and ignore Space.
    for (const id of ['checkbox-primary-readonly', 'switch-md-readonly']) {
      const input = page.getByTestId(id).locator('input');
      await input.focus();
      assert.equal(await isFocused(input), true);
      await page.keyboard.press('Space');
      assert.equal(await input.isChecked(), false);
      assert.equal(await input.isDisabled(), false);
    }

    const toggle = page.getByTestId('interactive-switch').locator('input');
    await toggle.focus();
    await page.keyboard.press('Enter');
    const switchEnter = (await state()).toggle;
    await page.keyboard.press('Space');
    assert.equal((await state()).toggle, !switchEnter);
    await page.getByTestId('interactive-switch-description').click();
    assert.equal((await state()).toggle, !switchEnter);

    const radio = page.getByTestId('radio-primary-vertical-rest');
    await radio.locator('input').first().focus();
    await page.keyboard.press('ArrowDown');
    assert.equal(await radio.locator('input').nth(1).isChecked(), true);

    await setDirection('rtl');
    const rtl = {};
    for (const id of RTL_IDS) rtl[id] = await measure(page.getByTestId(id));
    await setDirection('ltr');

    // Click each control with motion enabled, then sample its animations at fixed times.
    await page.emulateMedia({reducedMotion: 'no-preference'});
    const motion = {};
    for (const id of ['interactive-checkbox', 'interactive-switch']) {
      await page.getByTestId(`${id}-content`).click();
      const el = page.getByTestId(id);
      const animations = await el.evaluate(node => node.getAnimations({subtree: true}).map(a => ({
        name: a.animationName,
        keyframes: a.effect.getKeyframes(),
        timing: a.effect.getTiming(),
      })));
      const mark = id.endsWith('switch') ? '-thumb' : '-indicator';
      const samples = [];
      for (const time of MOTION_TIMES) {
        await el.evaluate((node, time) => {
          for (const a of node.getAnimations({subtree: true})) {
            a.pause();
            a.currentTime = time;
          }
        }, time);
        samples.push({
          time,
          control: await measure(page.getByTestId(`${id}-control`)),
          indicator: await measure(page.getByTestId(id + mark)),
        });
      }
      motion[id] = {animations, samples};
    }

    data.modes[mode] = {
      viewports,
      states,
      rtl,
      motion,
      behavior: {
        checkboxEnterDoesNotToggle: true,
        checkboxSpaceToggles: true,
        descriptionDoesNotToggle: true,
        indeterminateIndependent: true,
        readonlyFocusable: true,
        readonlySuppressed: true,
        radioArrowsSelect: true,
        switchEnterToggles: switchEnter,
        switchSpaceToggles: true,
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
    react: lock.packages['node_modules/react'].version,
    reactAriaComponents: lock.packages['node_modules/react-aria-components'].version,
    tailwind: lock.packages['node_modules/tailwindcss'].version,
  };
  await writeFile(path.join(reference, 'chromium/selection.json'), JSON.stringify(data, null, 2) + '\n');
  console.log(`selection: ${Object.keys(data.modes.light.viewports[1024]).length} cases, ` +
    `8 viewport/mode matrices. Chrome ${browser.version()}.`);
} finally {
  await browser?.close();
  await server?.close();
}
