# Tokens reference

How to get a design system's token set out of any source — code, Figma,
websites, PDFs, screenshots, or only a brand brief — and keep every value
traceable. This is a strategy, not a toolchain: a missing tool changes how a
value is read and how much confidence it carries, never what must be
extracted.

## Table of Contents

- [The critical set](#1-the-critical-set)
- [Invariants](#2-invariants)
- [Classify sources](#3-classify-sources-per-domain)
- [Where values land](#4-where-values-land)
- [Extraction modes](#5-extraction-modes)
- [Conflicts and upgrades](#6-conflicts-and-upgrades)
- [What not to build](#7-what-not-to-build)

## 1. The critical set

Extraction is done when this is filled, or a gap is explicitly marked.

| Domain | Minimum |
| --- | --- |
| Color | every named role per theme mode; the raw palette if the system has one; hover/pressed/disabled colors — these are tokens, not effects to guess |
| Spacing | every scale step with exact values; component paddings that are off the scale |
| Sizes | control heights per size name, icon sizes, breakpoints |
| Typography | families and weights; every named text style (size, line height, letter spacing, weight) |
| Motion | durations, easing curves, which interactions animate at all |
| Shape and elevation | radii and shadows **only if the system defines them**; absence is a finding |

Per component (feeds the worksheet): anatomy, variants, sizes and the
default, every state with distinct visuals, the tokens each state consumes,
non-token measurements with their source, and keyboard/focus/RTL behavior.

## 2. Invariants

1. **One meeting point.** Every source converges on `specs/tokens.yaml`. The
   Dart theme is checked against it, never against the original source.
2. **Inventory before values.** List every token name and every component's
   variants, sizes, and states first; then fill values. Gaps become explicit
   (`status: missing-in-source`), never silent absences.
3. **Every value is traceable**: a citation (page, node link, URL and date,
   image and coordinates, brief section) and a confidence —
   `specified` (stated by the source), `derived` (computed by a documented
   rule), `measured` (sampled from a rendering), `assumed` (a judgment call,
   also listed in a worksheet's approximations), or `designed` (chosen from a
   brief, rationale in the ADR).
4. **Pin what can be pinned; hash and date the rest**: exact versions and
   commits for code; file versions, sha256, and retrieval dates for documents
   and images; URL, date, and viewport for anything rendered.
5. **Never fabricate.** No invented scale steps, no guessed hover colors, no
   theme modes the source does not define. Absence is data.

## 3. Classify sources per domain

Colors may come from a better source than spacing, so classify each domain
separately and take the highest tier available for it.

| Tier | You have | Mode | Default confidence |
| --- | --- | --- | --- |
| 1 | machine-readable values (token package, tokens JSON, CSS custom properties) | re-runnable extraction script | specified |
| 2 | a queryable source (design-tool API, a page you can inspect programmatically) | re-runnable harvest against a pinned version | specified / derived |
| 3 | a readable document (PDF, brand book, docs prose) | transcription with citations | specified |
| 4 | images only | measurement with a recorded method | measured |
| — | a brief or verbal description | authored design | designed / derived |

**Degrade gracefully.** When the environment lacks what a tier needs (no
browser automation, no API token), treat the source as the next tier down and
record that, so a later pass can upgrade it.

**Upgrade opportunistically.** Before manual work, look for a hidden higher
tier: sites often ship tokens as CSS custom properties, design files usually
have an export or API, vendors often publish a tokens package.

## 4. Where values land

```yaml
# specs/tokens.yaml
sources:
  - id: brandbook
    type: pdf
    title: Brand Guidelines v2.3
    sha256: "…"
    retrieved: 2026-07-11
modes: [light, dark]
color:
  interactivePrimary:
    light: {value: "#0B5FFF", cite: "brandbook p.14", confidence: specified}
    dark: {value: "#4589FF", cite: "brandbook p.15", confidence: specified}
  interactivePrimaryHover:
    light: {status: missing-in-source}
spacing:
  step04: {value: 12, cite: "brandbook p.20", confidence: specified}
```

- **Tier 1 and 2** sources get a small extraction script that writes this
  file: exact pinned versions read from one manifest (never restated in the
  script), inventory-count assertions so upstream drift fails loudly, and
  deterministic output (sorted keys, no timestamps or randomness).
- **Tier 3, 4, and briefs** are authored into this file by hand; human review
  of it against the source is the extraction test.
- **The Dart theme holds the values**: `theme_data.dart` constructors in the
  shape of `references/components.md` §1. A test in the authoring package
  reads `specs/tokens.yaml` (a `yaml` dev dependency) and asserts every entry
  equals the corresponding `ThemeData` value per mode, and that every token
  identity has an entry. Hand-copy while the inventory is small; when it runs
  to hundreds of values (full palettes), generate the value file from the
  YAML with a deterministic script that has a `--check` mode, like
  derivation.
- Normalize while writing: colors as `#RRGGBB` or `#AARRGGBB`, rem converted
  once by a stated base, durations in milliseconds, curves as four numbers.
  Parse both legacy and CSS Color 4 color syntax (`rgb(141 141 141 / 30%)`),
  and reject NaN.
- Keep provenance in `specs/`, not in shipped Dart comments: shipped source
  must not contain the authoring word (`references/registry.md` §3).

## 5. Extraction modes

**Tier 1.** Import the official package as executable code rather than
regex-parsing Sass or TypeScript; resolved exports are the only faithful
values. Record the package lock's integrity hashes with the version.

**Tier 2.** Pin the file version or API revision. Prefer declared values
(variables, styles) over computed ones; when reading computed values, record
the viewport and capture each state. For fluid systems, harvest at several
widths. In design files, variables usually map to color and type; spacing
usually lives in frame layout values. Cite node links.

**Tier 3.** Read end to end for the inventory pass, then transcribe with page
citations. Print-only values (CMYK, Pantone) need an official digital mapping;
otherwise they are `assumed`.

**Tier 4.** Lossless images only. Calibrate scale against an element of known
size and record it. Sample flat regions away from edges and take the dominant
value of a patch. Snap spacing to a grid only when independent measurements
agree, and keep both raw and snapped values. Every state needs its own
capture.

**Brief.** Commit the brief verbatim (`docs/brief.md`) so every `designed`
value can cite it. Ask first when the user is available: brand colors, modes,
density, typefaces, existing assets (a logo alone pins brand hues). Decide the
full inventory before values. Prefer documented rules — a perceptually even
ramp from the brand color, a modular type scale, a 4px spacing base — so
values are `derived`; reserve `designed` for genuine taste calls.

## 6. Conflicts and upgrades

- **Precedence** when sources disagree: shipped code → design-tool source →
  docs prose → PDF → screenshots. Record any deliberate deviation in the ADR
  and keep the losing citation visible.
- **Upgrading a source** is its own change: bump the pin, re-run extraction,
  review the `specs/tokens.yaml` diff, update the Dart values and inventory
  assertions deliberately, and re-run component tests. Changed `measured` or
  `assumed` values after a tier upgrade are corrections; changed `specified`
  values are transcription bugs.

## 7. What not to build

- OCR or vision pipelines for a document of a few dozen tokens: cited
  transcription is faster and reviewable.
- A generic multi-source extraction framework. Each harvester is a small
  script for one source.
- Completeness the source does not support. Ship what it defines, mark the
  rest missing, extend when evidence appears.
