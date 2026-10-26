// Screenshots the installed gallery in light and dark, at desktop and phone
// widths, plus its overlays.
//
//   node capture.mjs /absolute/app/build/web /absolute/output/dir
//
// Build the retained app first with `flutter build web --no-web-resources-cdn`.
// Playwright comes from the HeroUI web reference's pinned dependencies
// (`npm ci --ignore-scripts` in registry_source/tool/heroui_parity/chromium);
// set CHROME_PATH to use a browser other than macOS Google Chrome.
import assert from 'node:assert/strict';
import {createServer} from 'node:http';
import {mkdir, readFile} from 'node:fs/promises';
import {createRequire} from 'node:module';
import path from 'node:path';

const [build, output] = process.argv.slice(2);
assert(
  build && output && path.isAbsolute(build) && path.isAbsolute(output),
  'Usage: node capture.mjs /absolute/app/build/web /absolute/output/dir',
);
const captureTool = new URL(
  '../../registry_source/tool/heroui_parity/chromium/',
  import.meta.url,
);
const {chromium} = createRequire(captureTool)('playwright-core');

const types = {
  '.html': 'text/html',
  '.js': 'text/javascript',
  '.mjs': 'text/javascript',
  '.json': 'application/json',
  '.wasm': 'application/wasm',
  '.css': 'text/css',
  '.ttf': 'font/ttf',
  '.otf': 'font/otf',
  '.png': 'image/png',
};
const server = createServer(async (request, response) => {
  const name = new URL(request.url, 'http://localhost').pathname;
  const file = path.resolve(build, name === '/' ? 'index.html' : `.${name}`);
  if (!file.startsWith(`${build}/`)) return void response.writeHead(403).end();
  try {
    const bytes = await readFile(file);
    response
      .writeHead(200, {'Content-Type': types[path.extname(file)] ?? 'application/octet-stream'})
      .end(bytes);
  } catch {
    response.writeHead(404).end();
  }
});

/**
 * Lets the canvas repaint after a resize or a state change. Spinners and
 * skeletons animate forever, so there is no still frame to wait for; fonts ship
 * with the app, so glyphs are ready at first paint.
 */
async function settle(page) {
  await page.waitForLoadState('networkidle');
  await page.waitForTimeout(1200);
}

/** The gallery's scroll extent, read from its semantics tree. */
const contentHeight = (page) =>
  page.evaluate(() =>
    Math.max(...[...document.querySelectorAll('flt-semantics')].map((el) => el.scrollHeight)),
  );

async function open(browser, width, height) {
  const context = await browser.newContext({
    viewport: {width, height},
    deviceScaleFactor: 1,
    reducedMotion: 'reduce',
  });
  const page = await context.newPage();
  page.on('pageerror', (error) => errors.push(error.message));
  await page.goto(`http://127.0.0.1:${server.address().port}/`);
  await page.locator('flt-semantics-placeholder').waitFor({state: 'attached', timeout: 60000});
  await page.locator('flt-semantics-placeholder').evaluate((el) => el.click());
  await page.getByRole('switch', {name: 'Dark mode', exact: true}).waitFor({timeout: 60000});
  return page;
}

/** Scrolls the gallery with the wheel until [target] sits in the viewport's upper half. */
async function reveal(page, target) {
  const {height, width} = page.viewportSize();
  await page.mouse.move(width / 2, height / 2);
  for (let attempt = 0; attempt < 30; attempt++) {
    const box = await target.boundingBox();
    if (box && box.y > 80 && box.y < height / 2) return box;
    await page.mouse.wheel(0, box ? box.y - height / 3 : 400);
    await page.waitForTimeout(250);
  }
  throw new Error('Could not scroll the target into view.');
}

async function shot(page, name, options = {}) {
  await settle(page);
  await page.screenshot({path: path.join(output, `${name}.png`), ...options});
}

const errors = [];
const named = (page, role, name) => page.getByRole(role, {name, exact: true});

/** Pointer input at the target's centre: semantics overlays can sit over it. */
async function press(page, target) {
  const box = await reveal(page, target);
  await page.mouse.click(box.x + box.width / 2, box.y + box.height / 2);
}

async function hover(page, target) {
  const box = await reveal(page, target);
  await page.mouse.move(box.x + box.width / 2, box.y + box.height / 2);
}

const overlays = {
  select: (page) => press(page, named(page, 'button', 'Fruit primary')),
  dropdown: (page) => press(page, named(page, 'button', 'Actions')),
  popover: (page) => press(page, named(page, 'button', 'Open popover')),
  tooltip: (page) => hover(page, named(page, 'button', 'Hover me')),
  modal: (page) => press(page, named(page, 'button', 'Open modal')),
  toast: (page) => press(page, named(page, 'button', 'Show toast')),
};

await mkdir(output, {recursive: true});
await new Promise((resolve) => server.listen(0, '127.0.0.1', resolve));
const browser = await chromium.launch({
  executablePath: process.env.CHROME_PATH ?? '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
  headless: true,
  args: ['--force-color-profile=srgb'],
});
try {
  for (const width of [1024, 375]) {
    const page = await open(browser, width, 900);
    for (const mode of ['light', 'dark']) {
      if (mode === 'dark') {
        const toggle = named(page, 'switch', 'Dark mode');
        for (let attempt = 0; attempt < 5; attempt++) {
          if ((await toggle.getAttribute('aria-checked')) === 'true') break;
          const box = await toggle.boundingBox();
          await page.mouse.click(box.x + box.width / 2, box.y + box.height / 2);
          await page.waitForTimeout(500);
        }
        assert.equal(await toggle.getAttribute('aria-checked'), 'true', 'Dark mode did not switch on.');
      }
      // A viewport as tall as the content captures the whole scroll view.
      await page.setViewportSize({width, height: Math.ceil(await contentHeight(page))});
      await shot(page, `gallery-${mode}-${width}`);

      await page.setViewportSize({width, height: width === 1024 ? 768 : 700});
      const wanted = width === 1024 ? Object.keys(overlays) : ['modal'];
      for (const name of wanted) {
        await overlays[name](page);
        await page.waitForTimeout(600);
        await shot(page, `overlay-${name}-${mode}-${width}`);
        await page.keyboard.press('Escape');
        await page.mouse.move(0, 0);
        if (name === 'toast') {
          // Toasts pause their timer while the page is inactive; close it.
          const close = await named(page, 'button', 'Dismiss notification').boundingBox();
          await page.mouse.click(close.x + close.width / 2, close.y + close.height / 2);
        }
        await page.waitForTimeout(600);
      }
      await page.mouse.wheel(0, -20000);
      await page.waitForTimeout(800);
    }
    await page.context().close();
  }
  assert.deepEqual(errors, [], 'The gallery raised browser errors.');
  console.log(`Gallery captures written to ${output}`);
} finally {
  await browser.close();
  await new Promise((resolve) => server.close(resolve));
}
