# Source extraction — tokens from any kind of source

Not every design system ships executable tokens like Carbon. Sources arrive as
npm packages, Figma files, docs websites, PDFs, or just screenshots. **Do not
build a different pipeline per source.** The normalized snapshot
(`tool/tokens/<sys>-tokens.normalized.json`) is the universal meeting point —
only the *extract* stage varies, and every downstream stage (generate, verify,
foundation, components) is identical regardless of where values came from.

```
Tier 1  npm/JSON/CSS-vars   ─ extract_tokens.mjs (automated)      ┐
Tier 2  Figma / live site   ─ harvest script → authored file      ├─▶ normalized
Tier 3  PDF / brand book    ─ transcription  → authored file      │   snapshot
Tier 4  screenshots only    ─ measurement    → authored file      ┘      │
                                                            normalize/generate/verify
```

## Step 0 — Classify the source, per domain

Classify **each token domain separately** (colors, spacing, type, motion,
components). Mixed tiers are normal: colors from a website's CSS variables
(tier 1) + spacing measured from screenshots (tier 4) is fine. Always use the
highest tier available for each domain, and record the tier in the ADR.

| Tier | Source | Extraction | Trust |
| --- | --- | --- | --- |
| 1 | npm package, tokens JSON, CSS custom properties file | automated script, re-runnable | authoritative |
| 2 | Figma file (API access), live docs site | semi-automated harvest, re-runnable with review | authoritative-ish |
| 3 | PDF, brand book, docs prose | manual transcription with citations | stated, not verifiable mechanically |
| 4 | screenshots / exported images | manual measurement with methodology | measured, lowest confidence |

## The authored source file (tiers 2–4)

For anything that can't be re-extracted mechanically, the extract stage's
output is a **hand-authored, committed** file: `tool/authored/<sys>-authored-tokens.json`.
It replaces `build/raw-tokens.json` as normalize's input. Rules:

- Same role as raw extract output — normalize still does all unit conversion.
- **Every value carries a citation and a confidence level**:

```json
{
  "$schema": "<sys>-tokens/authored/v1",
  "provenance": {
    "sources": [
      {"id": "brandbook", "type": "pdf", "title": "Acme Brand Guidelines v2.3",
       "sha256": "…", "retrieved": "2026-07-11"},
      {"id": "btn-states", "type": "screenshot", "file": "sources/button-states@2x.png",
       "scale": 2, "origin": "vendor email 2026-07-02"}
    ]
  },
  "colors": {
    "interactivePrimary": {"value": "#0B5FFF", "cite": "brandbook p.14", "confidence": "specified"},
    "interactivePrimaryHover": {"value": "#0A54E0", "cite": "btn-states (120,44) flat region", "confidence": "measured"}
  },
  "spacing": {
    "sm": {"value": 8, "unit": "px", "cite": "brandbook p.22", "confidence": "specified"},
    "buttonPaddingX": {"value": 16, "unit": "px", "cite": "btn-states, 32px@2x / scale 2", "confidence": "measured"}
  }
}
```

Confidence enum — this is the honesty mechanism, keep it small:

- `specified` — stated verbatim in the source.
- `derived` — computed by a documented rule (e.g. rem→px, hover = darken step).
- `measured` — sampled/measured from an image or rendered page.
- `assumed` — a gap you filled with judgment. Every `assumed` value must also
  appear in the relevant component worksheet's `approximations`.

Verification for authored sources: the extract-determinism check doesn't
apply (there's nothing to re-run), so `verify_generated.mjs` instead lints the
authored file — every value has `cite` + `confidence`, no `assumed` without a
worksheet entry — and the generate-from-committed-files byte-identity check
runs unchanged. Human review of the authored file against the source *is* the
extraction test; keep the file diff-reviewable (sorted keys, one value per line).

## Step 1 — Inventory before values

With no upstream package to assert counts against, **author the inventory
first**: enumerate every token name per domain, and every component with its
variants/sizes/states, by reading the source end-to-end — *before* filling in
any value. Gaps become explicit entries (`"value": null, "status":
"missing-in-source"`), never silent absences. This replaces carbon's
"expected 234 roles" assertions: you assert against your own committed
inventory, and a reviewer can check the inventory against the source without
checking every value.

## Per-tier recipes

### Tier 1 — executable / machine-readable

Carbon's path; see `token-pipeline.md`. Also counts as tier 1: a published
tokens JSON (Style Dictionary output, `tokens.json` from a Figma tokens
plugin) or a stylesheet of CSS custom properties — fetch the file, pin its
URL + hash in the source lock, parse `--token: value;` declarations
mechanically.

### Tier 2a — Figma with API access

- Use the REST API (`/v1/files/:key/styles`, and the variables endpoints when
  the file uses Variables) with a read token. Record file key, node IDs, and
  the file's `version` in the source lock; re-harvest is then reproducible
  against that version.
- Variables usually map modes → your themes. Styles give color/type; spacing
  usually requires reading auto-layout values from the component frames
  themselves (`/v1/files/:key/nodes?ids=…`).
- Harvest into the authored-file schema with `cite` = the Figma node URL and
  `confidence: specified`.
- No API access → treat the Figma file as tier 4 (screenshots of it), but
  record node links as cites so values can be re-checked.

### Tier 2b — live website / docs styleguide

The best web source is the site's own CSS, not its prose:

1. Check the stylesheets for CSS custom properties first — if the site ships
   `--color-…`/`--spacing-…` variables, fetch + parse them (this is tier 1).
2. Otherwise harvest **computed styles** with the pre-installed Chromium via
   Playwright: navigate to the styleguide's component examples and read
   `getComputedStyle` for the properties you need; simulate states with
   `page.hover`/`:focus` where the styleguide renders them.
3. Record in the source lock: page URLs, retrieval date, **viewport size**
   (computed values freeze responsive behavior — harvest at multiple
   viewports if the system has fluid tokens), and browser version.
4. Mark values `derived` (computed by the browser) unless the page states
   them verbatim (`specified`).

### Tier 3 — PDF / brand book

- Read the PDF directly (the Read tool renders PDF pages) and transcribe token
  tables into the authored file with `cite: "<doc> p.<n>"`.
- Prefer stated hex/RGB values; print documents may show CMYK or
  Pantone — if only those exist, use the vendor's official digital
  equivalents and cite where the mapping came from, else mark `assumed`.
- Record the document version and a sha256 of the file in the source lock;
  commit the PDF under `tool/authored/sources/` only if licensing allows,
  else hash + origin reference.

### Tier 4 — screenshots only

Measurement methodology — record it once in the authored file's provenance
and follow it consistently:

- **Lossless originals only.** JPEG artifacts corrupt both colors and edges;
  request PNGs at a known scale (@2x preferred).
- **Calibrate the scale first**: find an element with a known size (stated
  1px border, a standard 16px icon) and derive the device-pixel ratio; divide
  all measurements by it. Record the calibration in provenance.
- **Colors**: sample flat fill regions ≥4px away from any edge (anti-aliasing
  bleeds); take the dominant value of a small patch, not a single pixel.
- **Spacing/sizes**: measure in raw pixels, convert by scale, then check
  whether the measurements agree on a base grid (4px/8px). Snap to the grid
  only when multiple measurements agree; record raw and snapped values.
- **States need their own captures** (hover, focus, active, disabled,
  loading). A state you have no capture for is a `missing-in-source` gap or
  an `assumed` value — never invent it silently.
- Commit the images under `tool/authored/sources/` (license permitting) and
  cite `file (x,y)` coordinates so any value can be re-sampled.

## Conflicts and upgrades

- **Precedence**: when sources disagree, default order is
  shipped code/CSS → design-tool source → docs prose → PDF → screenshots.
  Deviate only deliberately (some vendors' Figma is fresher than their site)
  and record the chosen order in the ADR. Cite the losing source in the
  value's `cite` too, so the conflict stays visible.
- **Upgrade path**: when a better tier appears later (the vendor publishes a
  tokens package), write the tier-1 extractor and diff its output against the
  authored file — every `measured`/`assumed` value that changes is expected;
  every `specified` value that changes is a transcription bug worth a
  post-mortem. Then retire the authored file for that domain.

## What NOT to build

Over-optimization warning signs — all of these are wrong for a first system:

- OCR/vision tooling to "automate" PDF or screenshot extraction. Hand-author:
  a brand book defines dozens of tokens, not hundreds; transcription with
  citations is faster and reviewable.
- A generic multi-source extraction framework. Each tier-1/2 harvester is a
  ~100-line script owned by one package.
- Fabricating scales the source doesn't define (a full 13-step spacing scale
  from three measured paddings). Ship the tokens the source defines; mark the
  rest `missing-in-source` and extend when evidence appears.
