/**
 * Stage 4 — Verify determinism.
 *
 * Re-runs Dart generation (and, when a fresh extract is present, normalization)
 * into a scratch directory via each script's `--out` flag and diffs the result
 * against the committed artifacts. Any difference exits non-zero so CI fails on
 * a dirty diff. Re-running from the same source lock must be byte-identical.
 *
 * The generation check only needs the committed normalized snapshot, so it runs
 * in CI without installing the upstream npm packages. All checks are read-only:
 * nothing under the repository is written.
 *
 * Run:  node registry_source/tool/carbon/verify_generated.mjs
 */
import { execFileSync } from 'node:child_process';
import { readFileSync, existsSync, readdirSync, mkdtempSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const __dirname = dirname(fileURLToPath(import.meta.url));
const repoTokens = join(__dirname, 'tokens', 'carbon-tokens.normalized.json');
const sourceLockPath = join(__dirname, 'upstream', 'carbon-source-lock.json');
const npmLockPath = join(__dirname, 'upstream', 'package-lock.json');
const generatedDir = join(
  __dirname,
  '..',
  '..',
  'lib',
  'src',
  'carbon',
  'theme',
  'generated',
);

let failures = 0;
function fail(msg) {
  console.error(`  ✗ ${msg}`);
  failures += 1;
}
function ok(msg) {
  console.log(`  ✓ ${msg}`);
}

/** Runs a check block and prints its ✓ only if the block itself added no failures. */
function stage(okMessage, block) {
  const before = failures;
  block();
  if (failures === before) ok(okMessage);
}

// --- 1. Generation is deterministic from the committed snapshot ---
{
  const scratch = mkdtempSync(join(tmpdir(), 'carbon-verify-gen-'));
  try {
    stage('all generated Dart files are reproducible from the snapshot', () => {
      execFileSync(
        'node',
        [join(__dirname, 'generate_tokens.mjs'), '--out', scratch],
        { stdio: 'pipe' },
      );
      const committed = readdirSync(generatedDir).filter((f) => f.endsWith('.dart')).sort();
      const regen = readdirSync(scratch).filter((f) => f.endsWith('.dart')).sort();
      if (committed.join(',') !== regen.join(',')) {
        fail(`generated file set differs:\n    committed: ${committed}\n    regen:     ${regen}`);
      }
      for (const file of committed) {
        const a = readFileSync(join(generatedDir, file), 'utf8');
        const b = existsSync(join(scratch, file)) ? readFileSync(join(scratch, file), 'utf8') : '';
        if (a !== b) fail(`generated ${file} is not byte-identical to a fresh regeneration`);
      }
    });
  } finally {
    rmSync(scratch, { recursive: true, force: true });
  }
}

// --- 2. Generated files carry provenance and no unparsed CSS units ---
stage('every generated file carries provenance and contains no unparsed CSS', () => {
  const cssUnit = /\b\d+(?:\.\d+)?(rem|vw|em)\b|cubic-bezier|rgba?\(/;
  for (const file of readdirSync(generatedDir).filter((f) => f.endsWith('.dart'))) {
    const text = readFileSync(join(generatedDir, file), 'utf8');
    if (!text.includes('SPDX-License-Identifier: Apache-2.0')) {
      fail(`${file} is missing SPDX license provenance`);
    }
    if (!text.includes('IBM Carbon')) {
      fail(`${file} is missing Carbon source attribution`);
    }
    // Ignore comment/doc lines; only code lines must be free of raw CSS units.
    const codeLines = text.split('\n').filter((l) => !l.trimStart().startsWith('//'));
    const offender = codeLines.find((l) => cssUnit.test(l));
    if (offender) fail(`${file} contains an unparsed CSS unit/expression: ${offender.trim()}`);
  }
});

// --- 3. Snapshot provenance and npm integrity match the pinned source lock ---
stage('normalized provenance and npm integrity match the source lock', () => {
  const snapshot = JSON.parse(readFileSync(repoTokens, 'utf8'));
  const sourceLock = JSON.parse(readFileSync(sourceLockPath, 'utf8'));
  const npmLock = JSON.parse(readFileSync(npmLockPath, 'utf8'));
  const provenance = snapshot.provenance;

  for (const field of [
    'carbonCommit',
    'carbonCommitDate',
    'license',
    'extractionSchemaVersion',
  ]) {
    if (provenance[field] !== sourceLock[field]) {
      fail(`snapshot ${field} does not match the source lock`);
    }
  }
  if (JSON.stringify(provenance.packages) !== JSON.stringify(sourceLock.pinnedVersions)) {
    fail('snapshot package versions do not match the source lock');
  }

  for (const [name, version] of Object.entries(sourceLock.pinnedVersions)) {
    const installed = npmLock.packages[`node_modules/${name}`];
    const integrity = sourceLock.integrity[name];
    if (!installed || installed.version !== version) {
      fail(`${name} ${version} is not pinned in package-lock.json`);
      continue;
    }
    if (!integrity
        || integrity.version !== installed.version
        || integrity.resolved !== installed.resolved
        || integrity.integrity !== installed.integrity) {
      fail(`${name} integrity does not match package-lock.json`);
    }
  }
});

// --- 4. Normalization is deterministic (only when raw extract is present) ---
{
  const rawPath = join(__dirname, 'build', 'raw-tokens.json');
  if (existsSync(rawPath)) {
    const scratch = mkdtempSync(join(tmpdir(), 'carbon-verify-norm-'));
    try {
      stage('normalized snapshot is reproducible from build/raw-tokens.json', () => {
        const scratchOut = join(scratch, 'carbon-tokens.normalized.json');
        execFileSync(
          'node',
          [join(__dirname, 'normalize_tokens.mjs'), '--out', scratchOut],
          { stdio: 'pipe' },
        );
        if (readFileSync(repoTokens, 'utf8') !== readFileSync(scratchOut, 'utf8')) {
          fail('committed snapshot differs from re-normalization (stale or non-deterministic)');
        }
      });
    } finally {
      rmSync(scratch, { recursive: true, force: true });
    }
  } else {
    console.log('  · skipped normalization check (no build/raw-tokens.json; run extract first)');
  }
}

if (failures) {
  console.error(`\nverify: FAILED (${failures} problem${failures === 1 ? '' : 's'})`);
  process.exit(1);
}
console.log('\nverify: OK — token generation is deterministic and provenance is intact');
