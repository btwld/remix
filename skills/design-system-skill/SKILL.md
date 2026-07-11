---
name: remix-design-system
description: Playbook for creating a new design-system package on top of Remix (Mix + Naked UI), the way packages/carbon implements IBM Carbon. Use this skill whenever the user wants to build, port, or scaffold a design system or theme package in this monorepo — e.g. "implement Material/Polaris/Fluent/Spectrum/Base on Remix", "create a new design system package", "add a token pipeline for <system>", "add a themed component to <system package>", or "wrap Remix components in <brand> styling". Also trigger for questions about the token extraction pipeline, design-token generation, theme scopes, or component recipes for any Remix-based design system other than Fortal itself.
---

# Building a Design System Package on Remix

This skill encodes the architecture proven by `packages/carbon` (IBM Carbon on
Remix). The result of following it is a sibling package under `packages/` that:

- reuses **Naked UI** for interaction behavior, **Mix** for styling mechanics,
  and **Remix** for component machinery — and adds only the target system's
  design decisions on top;
- generates its entire token surface from **pinned upstream sources**
  (never hand-copied values), reproducibly and CI-enforced;
- exposes an idiomatic public API in the *target system's* vocabulary, not
  Remix's or Fortal's.

**`packages/carbon` is the living reference implementation.** When in doubt,
read the corresponding carbon file and adapt. Do not clone Fortal and swap
colors — Fortal is a hand-authored theme *inside* remix; new design systems are
generated, standalone packages.

## Architecture at a glance

```
naked_ui        interaction primitives (focus, press, semantics, keyboard)
   ↑
mix             styling engine, tokens, MixScope, variants
   ↑
remix           reusable component machinery (RemixButtonStyler, specs, widgets)
   ↑
<your package>  generated tokens + <System>Scope + component recipes/facades
                exposes ONLY <System>* widgets and tokens publicly
```

Three layers per package, mirroring carbon:

| Layer | Path | Contents |
| --- | --- | --- |
| Tokens | `lib/src/tokens/` | hand-written shared types + `generated/*.g.dart` (committed) |
| Foundation | `lib/src/foundation/` | `<System>Scope`, theme enum, contextual scopes, type/motion helpers |
| Components | `lib/src/components/<name>/` | one recipe/facade per component + worksheet in `specs/components/` |

The pipeline that produces `generated/` lives in `tool/` (Node) and is
**development-only** — consumers never need Node, npm, or network.

## Workflow

Work through the phases in order. Each phase ends with something verifiable.

### Phase 0 — Pin sources and record decisions

1. Identify the official machine-readable token sources (npm packages, JSON
   releases, published theme files). Pin **exact versions** and, when the
   upstream is a repo, a commit SHA. No caret ranges, no "latest".
2. Record in an ADR (`docs/adr/0001-…`): dependency strategy, what the first
   release covers, what is explicitly out of scope, font/icon strategy, and
   naming/trademark constraints. Copy the shape of
   `packages/carbon/docs/adr/0001-carbon-token-pipeline.md`.
3. Decide the theme model up front: how many themes, whether the system uses
   role-based tokens (Carbon), numbered scales (Radix/Fortal), or something
   else. **Preserve the target system's model** — never translate it into
   another system's concepts.

### Phase 1 — Package scaffold

Create `packages/<name>/` with `pubspec.yaml`, `analysis_options.yaml`,
`README.md`, `CHANGELOG.md`, `LICENSE`, `NOTICE`, `.gitignore`, `lib/<name>.dart`.

Non-obvious requirements (each one bit carbon):

- `publish_to: none` **while `remix` is a path dependency** — otherwise the
  analyzer emits a fatal `invalid_dependency` warning. Leave a comment saying
  when to remove it.
- Add the package to the **root `pubspec.yaml`** in *two* places: the
  `workspace:` list and the `melos: packages:` globs. Nested members
  (`packages/<name>/example`) must be listed explicitly — `packages/*` does
  **not** cross path separators, so melos scripts silently skip them.
- `NOTICE` must carry upstream attribution (license of the design system,
  font licenses, trademark disclaimer). Match the upstream's license terms —
  carbon's tokens are Apache-2.0, so `packages/carbon` is Apache-2.0.
- Exclude `tool/` from Dart analysis and gitignore `tool/build/`,
  `tool/**/node_modules/`.
- The main entry point (`lib/<name>.dart`) must **not** re-export the full
  Remix or Mix API — export only your scopes, tokens, and components.

### Phase 2 — Token pipeline

Read `references/token-pipeline.md` before writing any pipeline code, then
model on `packages/carbon/tool/`. The contract:

- Four stages: **extract → normalize → generate → verify**, all Node
  (`tool/*.mjs`), sharing helpers from `tool/lib/convert.mjs`.
- The normalized JSON snapshot **and** the generated Dart are **committed**.
- Regeneration from the same source lock is **byte-identical**, and
  `verify_generated.mjs` is **read-only** (every writer takes `--out`).
- Every generated file carries provenance headers (source, versions, commit,
  SPDX license) and contains **no unparsed CSS units**.
- Add a GitHub workflow (copy `.github/workflows/carbon_tokens.yml`) that runs
  the verifier — it needs only Node, no npm install. Docs may only claim "CI
  enforced" once this file exists.

### Phase 3 — Foundation runtime

Read `references/foundation-patterns.md`, then model on
`packages/carbon/lib/src/foundation/`. The essentials:

- `<System>Scope` resolves the generated token maps into a `MixScope`.
  **Memoize the per-theme base map** (top-level cache, `Map.unmodifiable`) so
  repeated scope rebuilds return the identical instance — Mix dependents then
  short-circuit equality checks. Rebuilding ~hundreds of map entries per
  ancestor rebuild is real, measured waste.
- Any typed overrides object needs **value equality** (`==`/`hashCode`), or
  the scope's `updateShouldNotify` always fires.
- Everything the scope configures must be **readable back from context**
  (e.g. `overridesOf(context)`) so helpers like fluid type resolvers can honor
  it without re-plumbing at every call site. A setting that only affects half
  the system (carbon's fontFamily initially reached fixed styles but not fluid
  ones or button labels) is a bug.
- Contextual scopes (`of`/`maybeOf` pattern): provide `maybeOf` whenever a
  component has its own default that differs from the scope's default —
  carbon's Button defaults to `lg` while the layout scope defaults to `md`,
  and only `maybeOf` can distinguish "no scope" from "scope chose default".
- Runtime lookups keyed by name must **throw `ArgumentError` in all build
  modes** on unknown input — an assert-plus-silent-fallback ships typos to
  production as wrong-but-plausible rendering.
- If the system has an indexed/leveled concept (Carbon's layers), generate the
  index mechanically (`carbonIndexedRoleFamilies`) and add a test asserting
  the hand-written enum covers every generated entry — carbon's hand-written
  switch was missing 4 families at first review.

### Phase 4 — Components

Read `references/component-playbook.md` **before the first component** — it
contains the Remix/Mix behavioral gotchas that produced real bugs in carbon
(loading-state styling, focus-ring layout shift, and others).

Per component:

1. Write the worksheet `specs/components/<component>.yaml` first (template in
   the playbook). It is the reviewable bridge between the upstream spec and
   the Flutter code: anatomy, kinds, sizes, states, exact tokens, non-token
   measurements *with upstream sources*, and approved approximations.
2. Apply the **wrapper decision rule**: generate a `@MixWidget` wrapper only
   when the target system's anatomy matches the Remix component, the public
   API reads in the target vocabulary, and no Remix-only types leak. Otherwise
   write a hand-written facade (a `StatelessWidget` that builds a
   `Remix*Styler` recipe and calls it) — carbon's Button is the model.
3. Style **through tokens, never copied values**: `token()` inside styler
   chains, `TextStyler().style(textToken.mix())` for text styles,
   `token.resolve(context)` for direct widget use. A hand-copied measurement
   "kept in sync" with a token is a drift bug waiting to be found.
4. **Memoize recipes.** Styler chains are pure functions of a few enums;
   cache them in a top-level `Map<(kind, size, …), Styler>` keyed by records.

### Phase 5 — Tests, example, docs

- **Token tests**: inventory counts against the baseline, per-theme spot
  values, cached-and-unmodifiable base maps, override behavior, partial-theme
  omissions preserved (never fabricate a missing upstream value).
- **Drift tests**: every hand-written enum that mirrors generated data gets a
  coverage test against the generated structure.
- **Widget tests**: one regression test per state that has distinct visuals —
  including **loading** (assert the container color is the kind's fill, not
  the disabled treatment) and **default size without any scope** (assert the
  measured height). Spinners animate forever: use `tester.pump(duration)`,
  never `pumpAndSettle`, in loading tests.
- **Example app**: must consume the package's own token system for its chrome
  (`token.resolve(context)`), never hand-picked palette values — the example
  is the first pattern adopters copy.
- Docs claims must match code. If the README promises something ("CI
  enforced", "applies to every text style"), verify the mechanism exists.

### Definition of done (per release)

- `dart analyze <pkg> <pkg>/example` clean (package root included — catches
  pubspec lints).
- `flutter test` green, including the regression matrix above.
- `node tool/verify_generated.mjs` passes; a full fresh
  extract→normalize→generate leaves `git status` clean.
- Worksheets exist for every shipped component; approximations documented.
- NOTICE/LICENSE/attribution complete; no temporary claims in docs.

## Quick pitfall index

Full explanations in `references/component-playbook.md`. The ten that caused
real bugs or review findings in carbon:

1. `RemixButton` folds `loading` into the **disabled** widget-state — style
   loading via the disabled variant, parameterized by a `loading` flag.
2. Focus rings via `borderAll` shift layout and clobber the kind's border —
   paint them with `foregroundDecoration` instead.
3. Mix tokens override `==` → they **cannot be const-map keys**; emit
   generated maps as **top-level `final`s**, not per-call functions.
4. `num.clamp()` returns `num` — add `.toInt()` before indexing.
5. `pumpAndSettle` never settles while a spinner animates.
6. melos/workspace globs don't cross path separators — list nested example
   packages explicitly.
7. Path dependency without `publish_to: none` = fatal analyzer warning.
8. Upstream color strings may use CSS Color 4 syntax (`rgb(141 141 141 / 30%)`)
   — parse both legacy and modern forms.
9. Version pins must have **one** source of truth (derive provenance from the
   upstream `package.json`, don't restate versions in scripts).
10. Never use `Date.now()`/randomness in generation — byte-identical output is
    the invariant that makes verification possible.
