// Actual upstream React/CSS evidence; never import Flutter implementation values.
//
// Tooltip, Modal, Accordion, Disclosure, Slider, Toast, Alert, ProgressBar,
// Meter and Table, rendered from families2.jsx. Writes
// reference/heroui_3_2_6/chromium/families2.json.
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
const screenshots = path.join(root, 'registry_source/tool/heroui_parity/chromium/out/families2');
await mkdir(screenshots, {recursive: true});

const MODES = ['light', 'dark'];
const WIDTHS = [375, 640, 768, 1024];
// The Flutter recipe tests pump a 768 high view, so overlay geometry that
// depends on the viewport (placement, cover, full) is captured at that height.
const HEIGHT = 768;

const PROPS = ['height', 'minHeight', 'maxHeight', 'width', 'minWidth', 'maxWidth',
  'paddingTop', 'paddingRight', 'paddingBottom', 'paddingLeft',
  'marginTop', 'marginRight', 'marginBottom', 'marginLeft', 'gap',
  'borderRadius', 'borderTopWidth', 'borderRightWidth', 'borderBottomWidth', 'borderLeftWidth',
  'borderColor', 'borderBottomColor', 'backgroundColor', 'color', 'opacity',
  'fontSize', 'fontFamily', 'fontWeight', 'fontStyle', 'lineHeight', 'letterSpacing',
  'textAlign', 'whiteSpace', 'boxShadow', 'outlineStyle', 'outlineColor', 'outlineWidth',
  'outlineOffset', 'transform', 'translate', 'rotate', 'scale', 'cursor', 'display', 'position',
  'overflow', 'alignItems', 'justifyContent', 'flexDirection', 'top', 'right', 'bottom', 'left',
  'zIndex', 'borderCollapse', 'borderSpacing', 'backdropFilter', 'transitionDuration', 'pointerEvents'];
const PSEUDO_PROPS = ['content', 'display', 'position', 'width', 'height', 'top', 'right', 'bottom',
  'left', 'insetInlineStart', 'backgroundColor', 'borderRadius', 'boxShadow', 'transform', 'rotate', 'scale',
  'opacity', 'marginInlineStart'];

let server, browser, page;

/** Rect and computed styles of one element, or of its pseudo-element. */
function measure(locator, pseudo) {
  return locator.evaluate((el, {props, pseudoProps, pseudo}) => {
    const r = el.getBoundingClientRect();
    const p = el.parentElement.getBoundingClientRect();
    if (pseudo) {
      const s = getComputedStyle(el, pseudo);
      const px = value => (/^-?[\d.]+px$/.test(value) ? parseFloat(value) : null);
      // A pseudo-element with no generated content has no box.
      const generated = s.content !== 'none' && s.content !== 'normal';
      return {
        tag: pseudo,
        rect: {width: generated ? px(s.width) : 0, height: generated ? px(s.height) : 0},
        styles: Object.fromEntries(pseudoProps.map(k => [k, s[k]])),
      };
    }
    const s = getComputedStyle(el);
    return {
      tag: el.tagName,
      text: el.textContent.trim().slice(0, 80),
      rect: {x: r.x, y: r.y, width: r.width, height: r.height, parentX: r.x - p.x, parentY: r.y - p.y},
      styles: Object.fromEntries(props.map(k => [k, s[k]])),
      attributes: Object.fromEntries([...el.attributes]
        .filter(a => (a.name.startsWith('data-') || a.name.startsWith('aria-') || ['role', 'disabled', 'slot'].includes(a.name))
          && !a.value.includes('react-aria'))
        .map(a => [a.name, a.value])),
    };
  }, {props: PROPS, pseudoProps: PSEUDO_PROPS, pseudo});
}

async function record(out, id, locator, pseudo) {
  assert.equal(await locator.count(), 1, `${id}: expected exactly one match, found ${await locator.count()}`);
  out[id] = await measure(locator, pseudo);
}

/** Records [suffix, locator, pseudo?] slots under `${prefix}-${suffix}`. */
async function recordSlots(out, prefix, slots) {
  for (const [suffix, locator, pseudo] of slots) await record(out, `${prefix}-${suffix}`, locator, pseudo);
}

const slot = (kase, name) => page.locator(`[data-case="${kase}"] [data-slot="${name}"]`);

async function settle(locator) {
  await locator.waitFor();
  await page.waitForFunction(el => !el.hasAttribute('data-entering') && !el.hasAttribute('data-exiting'),
    await locator.elementHandle());
  let previous, stable = 0;
  for (let attempt = 0; attempt < 40 && stable < 3; attempt++) {
    const current = JSON.stringify(await locator.boundingBox());
    stable = current === previous ? stable + 1 : 0;
    previous = current;
    await page.waitForTimeout(30);
  }
  assert(stable >= 3, 'overlay bounds did not settle');
}

const restPointer = () => page.mouse.move(0, 0);

// ---- Static cases (measured at every viewport) ------------------------------

async function accordion(out) {
  for (const variant of ['default', 'surface']) {
    const k = `accordion-${variant}`;
    const item = i => slot(k, 'accordion-item').nth(i);
    const inItem = (i, sel) => item(i).locator(sel);
    await recordSlots(out, k, [
      ['root', slot(k, 'accordion')],
      ['open-item', item(0)],
      ['open-heading', slot(k, 'accordion-heading').nth(0)],
      ['open-trigger', slot(k, 'accordion-trigger').nth(0)],
      ['open-indicator', slot(k, 'accordion-indicator').nth(0)],
      ['open-panel', slot(k, 'accordion-panel').nth(0)],
      ['open-body', slot(k, 'accordion-body').nth(0)],
      ['open-body-inner', inItem(0, '.accordion__body-inner')],
      ['open-separator', item(0), '::after'],
      ['closed-item', item(1)],
      ['closed-trigger', slot(k, 'accordion-trigger').nth(1)],
      ['closed-indicator', slot(k, 'accordion-indicator').nth(1)],
      ['closed-separator', item(1), '::after'],
      ['last-item', item(2)],
      ['last-trigger', slot(k, 'accordion-trigger').nth(2)],
      ['last-separator', item(2), '::after'],
    ]);
  }
  await recordSlots(out, 'accordion-disabled', [
    ['item', slot('accordion-disabled', 'accordion-item').nth(0)],
    ['trigger', slot('accordion-disabled', 'accordion-trigger').nth(0)],
  ]);
}

async function disclosure(out) {
  for (const state of ['closed', 'open', 'disabled', 'button-closed', 'button-open']) {
    const k = `disclosure-${state}`;
    const slots = [
      ['root', slot(k, 'disclosure')],
      ['heading', slot(k, 'disclosure-heading')],
      ['trigger', page.locator(`[data-case="${k}"] [data-slot="disclosure-heading"] button`)],
      ['indicator', slot(k, 'disclosure-indicator')],
      ['content', slot(k, 'disclosure-content')],
    ];
    // A collapsed body is laid out only while the panel's height transition settles.
    if (state.endsWith('open')) slots.push(['body', slot(k, 'disclosure-body')]);
    await recordSlots(out, k, slots);
  }
}

async function slider(out) {
  for (const state of ['min', 'mid', 'max', 'bare', 'disabled']) {
    const k = `slider-${state}`;
    const slots = [
      ['root', slot(k, 'slider')],
      ['track', slot(k, 'slider-track')],
      ['fill', slot(k, 'slider-fill')],
      ['thumb', slot(k, 'slider-thumb')],
      ['thumb-pill', slot(k, 'slider-thumb'), '::after'],
    ];
    if (state !== 'bare') {
      slots.splice(1, 0, ['label', slot(k, 'label')], ['output', slot(k, 'slider-output')]);
    }
    await recordSlots(out, k, slots);
  }
}

async function alert(out) {
  for (const status of ['default', 'accent', 'success', 'warning', 'danger']) {
    for (const short of [false, true]) {
      const k = `alert-${status}${short ? '-short' : ''}`;
      const slots = [
        ['root', slot(k, 'alert-root')],
        ['indicator', slot(k, 'alert-indicator')],
        ['icon', slot(k, 'alert-default-icon')],
        ['content', slot(k, 'alert-content')],
        ['title', slot(k, 'alert-title')],
      ];
      if (!short) slots.push(['description', slot(k, 'alert-description')]);
      await recordSlots(out, k, slots);
    }
  }
}

async function bars(out, family, rootSlot, outputSlot, outputs) {
  const combos = [];
  for (const color of ['default', 'accent', 'success', 'warning', 'danger']) {
    for (const size of ['sm', 'md', 'lg']) combos.push(`${color}-${size}`);
  }
  if (family === 'progress') for (const size of ['sm', 'md', 'lg']) combos.push(`indeterminate-${size}`);
  for (const combo of combos) {
    const k = `${family}-${combo}`;
    const slots = [
      ['root', slot(k, rootSlot)],
      ['label', slot(k, 'label')],
      ['track', slot(k, `${rootSlot}-track`)],
      ['fill', slot(k, `${rootSlot}-fill`)],
    ];
    if (outputs && !combo.startsWith('indeterminate')) slots.splice(2, 0, ['output', slot(k, outputSlot)]);
    await recordSlots(out, k, slots);
  }
}

async function table(out) {
  for (const id of ['primary', 'secondary', 'primary-select', 'secondary-select']) {
    const k = `table-${id}`;
    const select = id.endsWith('select');
    const columns = slot(k, 'table-column');
    const rows = slot(k, 'table-row');
    const cell = (row, column) => rows.nth(row).locator('[data-slot="table-cell"]').nth(column);
    const lastColumn = select ? 3 : 2;
    const nameColumn = select ? 1 : 0;
    const slots = [
      ['root', slot(k, 'table')],
      ['scroll', slot(k, 'table-scroll-container')],
      ['content', slot(k, 'table-content')],
      ['header', slot(k, 'table-header')],
      ['column-start', columns.nth(0)],
      ['column-start-separator', columns.nth(0), '::after'],
      ['column-sort', columns.nth(nameColumn)],
      ['column-end', columns.nth(lastColumn + 0)],
      ['sort-header', slot(k, 'table-sortable-column-header')],
      ['sort-indicator', slot(k, 'table-sortable-column-indicator')],
      ['body', slot(k, 'table-body')],
      // Rows 0..3 of the body; the header row has no table-row slot.
      ['row-first', rows.nth(0)],
      ['row-last', rows.nth(3)],
      ['cell-top-start', cell(0, 0)],
      ['cell-top-end', cell(0, lastColumn)],
      ['cell-mid', cell(2, nameColumn)],
      ['cell-bottom-start', cell(3, 0)],
      ['cell-bottom-end', cell(3, lastColumn)],
      ['footer', slot(k, 'table-footer')],
    ];
    if (select) slots.push(['row-selected', page.locator(`[data-case="${k}"] [data-slot="table-row"][data-selected="true"]`)],
      ['cell-selected', page.locator(`[data-case="${k}"] [data-slot="table-row"][data-selected="true"] [data-slot="table-cell"]`).nth(nameColumn)]);
    await recordSlots(out, k, slots);
  }
}

// ---- Overlay cases ------------------------------------------------------------

const TOOLTIPS = [
  ['default', 'top'], ['top', 'top'], ['bottom', 'bottom'], ['left', 'left'],
  ['right', 'right'], ['arrow', 'top'], ['long', 'top'],
];

async function tooltips(out) {
  for (const [id, placement] of TOOLTIPS) {
    const k = `tooltip-${id}`;
    const trigger = page.locator(`[data-case="${k}"] button`);
    await trigger.scrollIntoViewIfNeeded();
    await trigger.hover();
    const tip = page.locator('[role="tooltip"]');
    await settle(tip);
    assert.equal(await tip.getAttribute('data-placement'), placement, `${k} placement`);
    const triggerBox = await trigger.boundingBox();
    const tipBox = await tip.boundingBox();
    const prefix = `${k}-open`;
    await record(out, `${prefix}-trigger`, trigger);
    await record(out, `${prefix}-content`, tip);
    await record(out, `${prefix}-text`, tip.locator('p'));
    // Offset of the tooltip from the trigger's top-left, independent of scroll.
    if (id === 'arrow') await record(out, `${prefix}-arrow`, tip.locator('[data-slot="overlay-arrow"]'));
    for (const key of ['trigger', 'content', 'text', 'arrow']) {
      const base = out[`${prefix}-${key}`];
      if (!base) continue;
      base.rect.x -= triggerBox.x;
      base.rect.y -= triggerBox.y;
    }
    await restPointer();
    await tip.waitFor({state: 'detached'});
  }
}

const MODALS = ['xs-auto', 'sm-auto', 'md-auto', 'lg-auto', 'cover-auto', 'full-auto', 'md-center',
  'md-top', 'md-bottom', 'md-icon', 'scroll-inside', 'scroll-outside', 'backdrop-blur', 'backdrop-transparent'];

async function modals(out) {
  for (const id of MODALS) {
    const k = `modal-${id}`;
    const trigger = page.locator(`[data-modal-trigger="${id}"]`);
    await trigger.scrollIntoViewIfNeeded();
    await trigger.click();
    const backdrop = page.locator(`[data-case="${k}"]`);
    await settle(page.locator(`[data-case="${k}"] [data-slot="modal-container"]`));
    const inside = name => backdrop.locator(`[data-slot="${name}"]`);
    const slots = [
      ['backdrop', backdrop],
      ['container', inside('modal-container')],
      ['dialog', inside('modal-dialog')],
      ['header', inside('modal-header')],
      ['heading', inside('modal-heading')],
      ['body', inside('modal-body')],
      ['footer', inside('modal-footer')],
      ['close', inside('modal-close-trigger')],
    ];
    if (id === 'md-icon') slots.push(['icon', inside('modal-icon')]);
    await recordSlots(out, k, id.startsWith('backdrop-') ? slots.slice(0, 3) : slots);
    await page.keyboard.press('Escape');
    await backdrop.waitFor({state: 'detached'});
    await restPointer();
  }
}

const TOASTS = ['default', 'accent', 'success', 'warning', 'danger', 'single'];

async function toastSlots(out, kind) {
  await page.evaluate(kind => window.f2.addToast(kind), kind);
  const toast = page.locator('[data-slot="toast"]');
  await settle(toast);
  const inside = name => toast.locator(`[data-slot="${name}"]`);
  const k = `toast-${kind}`;
  const slots = [
    ['root', toast],
    ['indicator', inside('toast-indicator')],
    ['icon', inside('toast-default-icon')],
    ['content', inside('toast-content')],
    ['title', inside('toast-title')],
    ['close', inside('toast-close')],
    ['close-icon', inside('toast-close').locator('[data-slot="close-button-icon"]')],
  ];
  if (kind !== 'single') slots.push(['description', inside('toast-description')], ['action', inside('toast-action-button')]);
  await recordSlots(out, k, slots);
  return {k, toast, inside};
}

async function clearToasts() {
  await page.evaluate(() => window.f2.clearToasts());
  await page.locator('[data-slot="toast"]').waitFor({state: 'detached'});
}

async function toasts(out) {
  for (const kind of TOASTS) {
    await toastSlots(out, kind);
    await clearToasts();
  }
}

// ---- Interaction states (1024 wide) --------------------------------------------

async function keyboardFocus(locator) {
  await page.keyboard.press('Tab');
  await locator.focus();
}

async function states(out) {
  const trigger = (k, i) => slot(k, 'accordion-trigger').nth(i);
  for (const variant of ['default', 'surface']) {
    const k = `accordion-${variant}`;
    await trigger(k, 1).hover();
    await record(out, `${k}-hover-trigger`, trigger(k, 1));
    await restPointer();
  }
  await keyboardFocus(trigger('accordion-default', 1));
  await record(out, 'accordion-default-focus-trigger', trigger('accordion-default', 1));
  await trigger('accordion-default', 1).blur();

  const disclosureTrigger = page.locator('[data-case="disclosure-closed"] button');
  await keyboardFocus(disclosureTrigger);
  await record(out, 'disclosure-closed-focus-trigger', disclosureTrigger);
  await disclosureTrigger.blur();

  const thumb = slot('slider-mid', 'slider-thumb');
  await keyboardFocus(thumb.locator('input'));
  await recordSlots(out, 'slider-mid-focus', [['thumb', thumb], ['thumb-pill', thumb, '::after']]);
  await thumb.locator('input').blur();
  const box = await thumb.boundingBox();
  await page.mouse.move(box.x + box.width / 2, box.y + box.height / 2);
  await page.mouse.down();
  assert.equal(await thumb.getAttribute('data-dragging'), 'true');
  await recordSlots(out, 'slider-mid-drag', [['thumb', thumb], ['thumb-pill', thumb, '::after']]);
  await page.mouse.up();
  await restPointer();

  await toastSlots({}, 'default');
  const toast = page.locator('[data-slot="toast"]');
  await toast.hover();
  await recordSlots(out, 'toast-default-hover', [
    ['root', toast], ['close', toast.locator('[data-slot="toast-close"]')]]);
  await toast.locator('[data-slot="toast-close"]').hover();
  await record(out, 'toast-default-close-hover-close', toast.locator('[data-slot="toast-close"]'));
  await restPointer();
  await clearToasts();

  for (const variant of ['primary', 'secondary']) {
    const k = `table-${variant}`;
    const rows = slot(k, 'table-row');
    const cell = rows.nth(1).locator('[data-slot="table-cell"]').nth(0);
    await cell.hover();
    await recordSlots(out, `${k}-hover`, [['row', rows.nth(1)], ['cell', cell]]);
    await restPointer();
    const sortColumn = slot(k, 'table-column').nth(0);
    await sortColumn.hover();
    await record(out, `${k}-hover-column-sort`, sortColumn);
    await restPointer();
  }
  const selectedRow = page.locator('[data-case="table-primary-select"] [data-slot="table-row"]').nth(2);
  await selectedRow.locator('[data-slot="table-cell"]').nth(1).hover();
  await recordSlots(out, 'table-primary-select-hover', [
    ['row', selectedRow], ['cell', selectedRow.locator('[data-slot="table-cell"]').nth(1)]]);
  await restPointer();
}

/** Colors down one pixel column across the header/body boundary of each table variant. */
async function headerRuleProbes() {
  const probes = {};
  for (const variant of ['primary', 'secondary']) {
    const k = `table-${variant}`;
    const header = slot(k, 'table-header');
    // A column away from the rounded corners and the column separators.
    const firstCell = slot(k, 'table-row').nth(0).locator('[data-slot="table-cell"]').nth(1);
    await header.scrollIntoViewIfNeeded();
    const headerBox = await header.boundingBox();
    const cellBox = await firstCell.boundingBox();
    const x = Math.floor(cellBox.x + cellBox.width - 12);
    const clip = {x, y: Math.floor(headerBox.y) - 2, width: 1, height: Math.ceil(headerBox.height) + 52};
    const png = (await page.screenshot({clip})).toString('base64');
    const pixels = await page.evaluate(async ({png, height}) => {
      const image = new Image();
      image.src = `data:image/png;base64,${png}`;
      await image.decode();
      const canvas = document.createElement('canvas');
      canvas.width = 1; canvas.height = height;
      const ctx = canvas.getContext('2d');
      ctx.drawImage(image, 0, 0);
      return Array.from({length: height}, (_, y) => [...ctx.getImageData(0, y, 1, 1).data]);
    }, {png, height: clip.height});
    probes[variant] = {
      headerTop: headerBox.y, headerBottom: headerBox.y + headerBox.height,
      firstBodyCellTop: cellBox.y, clipTop: clip.y, pixels,
    };
  }
  return probes;
}

// ---- Run ------------------------------------------------------------------------

async function openPage(mode) {
  await page.goto(server.resolvedUrls.local[0] + 'families2.html');
  await page.waitForSelector('[data-case="table-primary"] table');
  await page.evaluate(() => document.fonts.ready);
  await page.emulateMedia({colorScheme: mode, reducedMotion: 'reduce'});
  await page.evaluate(mode => {
    document.documentElement.className = mode;
    document.documentElement.dataset.theme = mode;
  }, mode);
  await restPointer();
}

const data = {schema: 1, upstream: source.commit, environment: {}, modes: {}};
try {
  server = await createServer({root: here, server: {host: '127.0.0.1', port: 0}});
  await server.listen();
  browser = await chromium.launch({
    executablePath: process.env.CHROME_PATH || '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
    headless: true, args: ['--force-color-profile=srgb'],
  });
  const context = await browser.newContext({viewport: {width: 1024, height: HEIGHT}, deviceScaleFactor: 1, reducedMotion: 'reduce'});
  page = await context.newPage();
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  page.on('console', message => { if (message.type() === 'error' && !/404/.test(message.text())) errors.push(message.text()); });

  for (const mode of MODES) {
    await openPage(mode);
    const viewports = {};
    for (const width of WIDTHS) {
      await page.setViewportSize({width, height: HEIGHT});
      await restPointer();
      const out = {};
      await accordion(out);
      await disclosure(out);
      await slider(out);
      await alert(out);
      await bars(out, 'progress', 'progress-bar', 'progress-bar-output', true);
      await bars(out, 'meter', 'meter', 'meter-output', true);
      await table(out);
      await tooltips(out);
      await modals(out);
      await toasts(out);
      viewports[width] = out;
    }
    await page.setViewportSize({width: 1024, height: HEIGHT});
    await openPage(mode);
    const stateCases = {};
    await states(stateCases);
    const probes = {tableHeaderRule: await headerRuleProbes()};
    await page.screenshot({path: path.join(screenshots, `${mode}.png`), fullPage: true});
    data.modes[mode] = {viewports, states: stateCases, probes};
  }
  assert.deepEqual(errors, [], 'families2 runtime errors');
  data.environment = {
    browser: browser.version(), platform: process.platform, deviceScaleFactor: 1, colorProfile: 'sRGB',
    viewports: WIDTHS, viewportHeight: HEIGHT, reducedMotion: 'reduce',
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
  await writeFile(path.join(reference, 'chromium/families2.json'), JSON.stringify(data, null, 2) + '\n');
  const light = data.modes.light;
  console.log(`families2: ${Object.keys(light.viewports[1024]).length} cases per viewport, ` +
    `${Object.keys(light.states).length} states, 8 viewport/mode matrices. Chrome ${browser.version()}.`);
} finally {
  await browser?.close();
  await server?.close();
}
