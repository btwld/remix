// Screenshots the HeroUI dashboard demo: every destination at desktop width
// and Overview and Chat at phone width, in light and dark.
//
//   node tool/capture.mjs /absolute/app/build/web /absolute/output/dir
//
// Build first with `flutter build web --no-web-resources-cdn`. Playwright
// comes from the HeroUI web reference's pinned dependencies
// (`npm ci --ignore-scripts` in registry_source/tool/heroui_parity/chromium),
// as for open_code/heroui_fixture/capture.mjs; set CHROME_PATH to use a
// browser other than macOS Google Chrome.
import assert from 'node:assert/strict';
import {createServer} from 'node:http';
import {mkdir, readFile} from 'node:fs/promises';
import {createRequire} from 'node:module';
import path from 'node:path';

const [build, output] = process.argv.slice(2);
assert(
  build && output && path.isAbsolute(build) && path.isAbsolute(output),
  'Usage: node tool/capture.mjs /absolute/app/build/web /absolute/output/dir',
);
const captureTool = new URL(
  '../../../registry_source/tool/heroui_parity/chromium/',
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

const errors = [];
const named = (page, role, name) => page.getByRole(role, {name, exact: true});

/** Pointer input at the target's centre: semantics overlays can sit over it. */
async function click(page, target) {
  await target.waitFor({timeout: 30000});
  const box = await target.boundingBox();
  await page.mouse.click(box.x + box.width / 2, box.y + box.height / 2);
  await page.waitForTimeout(700);
}

async function open(browser, width, height) {
  const context = await browser.newContext({
    viewport: {width, height},
    deviceScaleFactor: 1,
    reducedMotion: 'reduce',
  });
  const page = await context.newPage();
  page.on('pageerror', (error) => errors.push(error.message));
  await page.goto(`http://127.0.0.1:${server.address().port}/`);
  await named(page, 'button', 'Open theme settings').waitFor({timeout: 60000});
  await page.waitForTimeout(1500);
  return page;
}

/** Repaints after the last change, with the pointer parked off every control. */
async function shot(page, name) {
  const {width, height} = page.viewportSize();
  await page.mouse.move(width - 1, height - 1);
  await page.waitForLoadState('networkidle');
  await page.waitForTimeout(1500);
  await page.screenshot({path: path.join(output, `${name}.png`)});
}

async function setDark(page) {
  await click(page, named(page, 'button', 'Use dark appearance'));
  await named(page, 'button', 'Use light appearance').waitFor({timeout: 10000});
}

/** Opens [destination], through the navigation sheet below 720 wide. */
async function go(page, destination) {
  if (page.viewportSize().width < 720) {
    await click(page, named(page, 'button', 'Open navigation'));
  }
  await click(page, named(page, 'button', destination));
}

/** Starts the permission scenario, so the chat shows every Agent surface. */
async function runChat(page) {
  await click(page, page.getByRole('button', {name: 'Run terminal checks'}));
  await page.waitForTimeout(2500);
}

const destinations = ['Overview', 'Chat', 'Customers', 'Orders', 'Settings'];

await mkdir(output, {recursive: true});
await new Promise((resolve) => server.listen(0, '127.0.0.1', resolve));
const browser = await chromium.launch({
  executablePath: process.env.CHROME_PATH ?? '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
  headless: true,
  args: ['--force-color-profile=srgb'],
});
try {
  for (const mode of ['light', 'dark']) {
    const page = await open(browser, 1440, 900);
    if (mode === 'dark') await setDark(page);
    for (const destination of destinations) {
      await go(page, destination);
      if (destination === 'Chat') await runChat(page);
      await shot(page, `${destination.toLowerCase()}-${mode}-1440x900`);
    }
    await page.context().close();
  }
  for (const mode of ['light', 'dark']) {
    const page = await open(browser, 390, 844);
    if (mode === 'dark') await setDark(page);
    await shot(page, `overview-${mode}-390x844`);
    await go(page, 'Chat');
    await runChat(page);
    await shot(page, `chat-${mode}-390x844`);
    await page.context().close();
  }
  assert.deepEqual(errors, [], 'The demo raised browser errors.');
  console.log(`Dashboard captures written to ${output}`);
} finally {
  await browser.close();
  await new Promise((resolve) => server.close(resolve));
}
