# ADR 0001 — Carbon token pipeline and package architecture

- Status: accepted
- Date: 2026-07-10
- Context: `packages/carbon` (Carbon for Flutter), Phase 0 / Phase 1

## Context

`carbon` implements the IBM Carbon Design System on top of the Remix 1.0 /
Naked UI / Mix foundations, without reusing Fortal's Radix-derived design
decisions. Carbon has a large token surface (234 color roles across four themes,
78 component tokens, fixed and fluid spacing and type, motion) that must be
faithful to official sources and reproducibly upgradeable.

## Decisions

### 1. Generate tokens from pinned official sources; commit the output

We do **not** hand-author the token surface. A four-stage pipeline
(extract → normalize → generate → verify) imports the official `@carbon/*` npm
packages at pinned versions, normalizes them into a repository-owned JSON
snapshot, and emits strongly-typed Dart.

- The normalized snapshot (`tool/tokens/carbon-tokens.normalized.json`) and the
  generated Dart (`lib/src/tokens/generated/`) are committed.
- Consumers need no Node, npm, network, or the Carbon repo.
- Upgrading Carbon is a dedicated change with visible snapshot + Dart diffs.

This directly addresses the Fortal drift problems called out in the brief
(hand-authored theme file, comment/value drift, shadow-stroke mismatch): the
values are mechanical output, and `tool/verify_generated.mjs` fails CI on any
non-deterministic or stale regeneration.

### 2. The generator is implemented in Node, not Dart

The brief sketches `generate_tokens.dart`. Because the extraction stage must
import the official Carbon **ES modules** (the only faithful source of resolved
values — safer than regex-parsing Sass/TypeScript), the whole pipeline is
Node-based. Implementing the emitter in Node too means one toolchain reproduces
every artifact, and the generation/verify stages run in CI without a Dart SDK.
The generated output is ordinary, reviewable Dart.

### 3. Preserve Carbon's model — do not translate into Fortal concepts

- Role-based themes (not Radix numbered scales): 234 roles resolved per theme.
- Contextual layer model: `CarbonLayer` maps aliases (`layer`, `field`,
  `borderSubtle`, …) to indexed role tokens for levels 1–3.
- Fluid spacing keeps its viewport unit; fluid type keeps per-breakpoint
  overrides; component tokens keep fallbacks and missing-theme omissions.
- No invented radius/elevation scale — Carbon's button radius is `0`.

### 4. Depend on Remix 1.0; prefer hand-written facades for divergent anatomy

`carbon → remix (path)`. Interaction behavior stays in one place. Components use
a generated `@MixWidget` wrapper only when Carbon and Remix anatomy match and the
public API reads as Carbon; otherwise a hand-written Carbon facade composes Remix
or Naked UI internally. The Button slice is a hand-written facade over
`RemixButtonStyler`, keeping the public API in Carbon terminology and avoiding
leaked Remix-only types. The main entry point does not re-export Remix or Mix.

An architecture checkpoint follows the Button, Text Input and Modal slices to
decide whether to keep depending on external Remix components or extract a
neutral shared component layer.

## Consequences

- Faithful, reproducible, upgradeable tokens with CI drift protection.
- One (Node) toolchain for token work; Dart/Flutter only for the library itself.
- Slightly more per-component work than a blanket generated wrapper, in exchange
  for a clean, Carbon-shaped public API.

## Follow-ups requiring product decisions (see brief §13)

- Approved Carbon Figma v11 kit node link (for goldens).
- IBM Plex font packaging strategy (bundled Latin core vs optional package vs
  consumer-provided).
- Icon packaging strategy.
- `carbon` pub.dev name availability and IBM trademark/attribution review.
