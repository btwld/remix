import * as colors from '@radix-ui/colors';
import fs from 'node:fs/promises';
import { renderSwatches } from './swatches.mjs';

const root = new URL('.', import.meta.url);
const lock = JSON.parse(await fs.readFile(new URL('package-lock.json', root)));
const dependency = lock.packages['node_modules/@radix-ui/colors'];
const installed = JSON.parse(await fs.readFile(new URL('node_modules/@radix-ui/colors/package.json', root)));
if (installed.version !== dependency.version) {
  throw new Error('Installed Radix version differs from the lockfile. Run npm ci.');
}
const pairs = {
  orla: { accent: 'gray', neutral: 'gray' },
  mar: { accent: 'teal', neutral: 'sage' },
  ceu: { accent: 'blue', neutral: 'slate' },
  serra: { accent: 'gold', neutral: 'olive' },
  sol: { accent: 'amber', neutral: 'sand' },
  duna: { accent: 'brown', neutral: 'sand' },
  caju: { accent: 'orange', neutral: 'sand' },
};
const families = [...new Set(Object.values(pairs).flatMap(p => [p.accent, p.neutral]))].sort();
const scales = {};
for (const family of families) {
  scales[family] = {};
  for (const mode of ['light', 'dark']) {
    const name = family + (mode === 'dark' ? 'Dark' : '');
    const opaque = colors[name];
    const alpha = colors[name + 'A'];
    if (Object.keys(opaque).length !== 12 || Object.keys(alpha).length !== 12) {
      throw new Error(`${name}: expected twelve opaque and alpha steps`);
    }
    scales[family][mode] = {
      solid: Array.from({ length: 12 }, (_, i) => opaque[`${family}${i + 1}`]),
      alpha: Array.from({ length: 12 }, (_, i) => alpha[`${family}A${i + 1}`]),
    };
  }
}
const license = await fs.readFile(new URL('node_modules/@radix-ui/colors/LICENSE', root), 'utf8');
const snapshot = {
  source: {
    package: '@radix-ui/colors',
    version: dependency.version,
    integrity: dependency.integrity,
    repository: 'https://github.com/radix-ui/colors',
    license: 'MIT',
    licenseText: license,
    colorSpace: 'sRGB',
    alphaEncoding: '#RRGGBBAA; opaque alpha entries may use #RRGGBB',
  },
  pairs,
  scales,
};
for (const [target, output] of [
  [new URL('../../../specs/fortal_radix_colors.json', root), JSON.stringify(snapshot, null, 2) + '\n'],
  [new URL('../../../../docs/assets/fortal-theme-swatches.svg', root), renderSwatches(snapshot)],
]) {
  if (process.argv.includes('--check')) {
    if (await fs.readFile(target, 'utf8') !== output) {
      throw new Error(`${target.pathname} is stale. Run npm run extract.`);
    }
  } else {
    await fs.writeFile(target, output);
  }
}
console.log(process.argv.includes('--check')
  ? 'Fortal Radix snapshot and documentation swatches are current.'
  : 'Extracted the pinned Radix color scales, license and documentation swatches.');
