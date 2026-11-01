# Adding a first-party preset

This is the maintainer path for adding another design language beside Vanilla
and Fortal. It is not the third-party `@namespace` workflow, and it does not
make an unimplemented preset available to consumers.

Read the [design-system skill](../skills/building-remix-design-system/SKILL.md)
and, when porting a web library, its
[porting guide](../skills/building-remix-design-system/references/reference-parity.md).
Use [PRESETS.md](PRESETS.md) for the current distribution contract and
[RELEASING.md](RELEASING.md) for publication.

## Architecture to retain

- Author under `registry_source/lib/src/<preset>/` in the existing private
  workspace package. Do not publish a new runtime theme package.
- Reuse Remix rendering and Naked UI behavior. The preset holds token values,
  variants, `@MixWidget` recipes over Remix widgets, and thin compositions.
  It never reimplements gestures, focus, keyboard, semantics, or form state.
- Target the exported Remix components. Compose families that have no Remix
  widget from Remix widgets and Mix primitives; defer those that would need
  behavior Remix lacks. A shared-library API is a separate change: general to
  every preset, additive, tested, documented, and recorded in the preset's ADR
  (see the porting guide's extension order).
- Generate every catalog, template, and the registry index with
  `tool/build_registry.dart`. Do not hand-edit `registry/` outputs.
- Keep one preset and one app-chosen prefix per consumer. A new preset must
  not change existing Vanilla/Fortal tokens, APIs, installed files, or pins.
- Reuse the builder and checkout harness. Neither a second generator nor a
  public local-registry feature is necessary.

The CLI's preset argument is not a hardcoded two-value enum:
`packages/remix_cli/lib/src/project_config.dart` validates its identifier,
and `installer.dart` (through `registry_source.dart`) validates it against
the official index at initialization.
The builder's `presetSpecs` and the consumer harness explicitly enumerate
implemented presets. Adding another requires those integrations; it does
not inherently require a configuration-schema change.

## Gate 1 — Source and scope

Before recipes, create a scope/source ADR under
`registry_source/docs/adr/<preset>/` and a pinned reference under
`registry_source/reference/<upstream>_<version>/`.

Record the exact release and source hashes, license/notice evidence, theme
model, font/icon delivery, preset slug and authoring word, and the family map:
each upstream family as a Remix recipe, a composition, or deferred. Name
variant and size enums in the upstream vocabulary and keep Remix's parameter
names and shapes for everything else; document Dart name translations. Do not
borrow Fortal's design decisions. Use preset-specific worksheets
(`registry_source/specs/<preset>/tokens.json`, `components/<name>.yaml`); the
existing `specs/components/` worksheets describe shared Agent surfaces.

**Pass:** sources are reproducible and every family has a mapping.

## Gate 2 — Appearance evidence and theme

Create a small pinned fixture under `registry_source/tool/<preset>_parity/`,
following HeroUI's separation of reference artifacts, checker, and Flutter
tests. Fortal owns an independent specification checked by `fortal:check`.
For a CSS-first system, compile the upstream CSS, render the upstream
components, and record tokens and measurements for both modes, each variant and
size, the visual states, and both sides of each breakpoint. Keep the committed
evidence small.

Implement the token/theme/scope contract. Verify token values against the
evidence, equality, system/light/dark selection, nested scopes, and overlay
scope capture.

**Pass:** an installed theme resolves every token and the token test matches
the evidence.

## Gate 3 — Recipes

For each component, write its worksheet, then the `@MixWidget` recipe or
composition, regenerate adapters, and test: every variant × size × mode builds,
geometry matches the measurements, the focus ring does not shift layout, and
disabled/loading visuals match the worksheet. Merge caller overrides last.
Fonts and icons reach fresh consumers through declared packages or documented
setup.

**Pass:** each shipped item matches its worksheet, approximations are stated,
and a side-by-side capture of the installed gallery against the upstream
fixture has been reviewed.

## Gate 4 — Distribution and CI wiring

Complete these together before calling the new preset supported:

| Surface | Integration |
| --- | --- |
| `tool/build_registry.dart` | Add a `PresetSpec` and `presetSpecs` entry: authored root, type/value words, theme exports, dependency floors/detection, and any real shared items. Do not automatically inherit Agent/dashboard recipes. |
| `test/tool/build_registry_test.dart` | Verify prefix round trips, generated parts, dependency closure, source imports, and missing/stale outputs for the new preset. Extend Agent tests only if that preset includes Agent items. |
| `registry/index.yaml`, `registry/<preset>/` | Generate using the builder; review the resulting catalog and templates. |
| `tool/check_open_code.dart`, `test/tool/check_open_code_test.dart` | Add the preset contract, exact item coverage, argument handling, dependencies, installed-file inventory, and fixture expectations. Existing full-preset contracts assume their foundation items; inspect those assumptions for a smaller first catalog. |
| `analysis_options.yaml` | Exclude the pre-install fixture from root analysis: it has no dependencies until assembled. Its exact source must still pass the fresh-consumer analyzer and tests. |
| `open_code/<preset>_fixture/` | Add a minimal pre-install app with a different consumer prefix; install every shipped item and exercise theme, generation, imports, and rendering. |
| `pubspec.yaml` | Add the parity check to `ci:checks`, a `ci:open-code:<preset>` step to `ci`, and checkout/hosted coverage to the corresponding aggregate scripts. |
| `.github/workflows/ci.yaml` | Add the consumer job/matrix entry; `tool/check_ci_coverage.dart` must confirm CI and local gates agree. |
| `.github/workflows/registry.yml`, `open_code/RELEASING.md` | Extend the explicit remote candidate smoke commands before registry promotion and the published/hosted CLI verification examples. Updating the aggregate release check alone does not update this workflow's remote smoke list; the CI-coverage checker does not inspect it. |
| `tool/check_registry_icons.dart`, `tool/check_version_alignment.dart` | Inspect preset iteration and shared floors. Extend any hardcoded coverage; retain icon-placeholder and hosted-constraint guarantees. |
| Installed-source review app | Add a dedicated consumer or deliberately extend a review surface without replacing existing preset demos. If adding a workspace app, wire its pubspec/workspace entry, installed-source checks in `tool/check_consumer_apps.dart`, and applicable codegen/docs coverage. |
| `AGENTS.md`, `open_code/PRESETS.md`, `skills/using-remix/`, `docs/` | Document only implemented APIs, installation, source version, supported families, and deviations. Extend discovery/catalog generation where applicable; do not present the Fortal-only catalog as multi-preset coverage. |

Existing material-independence checks scan all of `registry_source/lib`; the
new preset belongs in that boundary. Derivation and docs checks do not replace
the new parity gate or fresh-consumer coverage.

## Validation sequence

Use the SDK pinned in `.fvmrc` (prefix with `fvm` when necessary). Existing
commands, run at the workspace root:

```shell
fvm dart run melos run generate
fvm dart run melos run open-code:registry:build
fvm dart run melos run open-code:registry:check
fvm dart run melos run docs:check
fvm dart run melos run ci:coverage:check
```

Run the new preset's focused parity/widget and checkout-consumer gates after
adding them; those commands do not exist merely because this checklist names
the pattern. Then run `fvm dart run melos run ci` for completion.

The checkout harness exercises unpushed authored output through the real CLI
flow with internal registry-source injection. Production `init` still resolves
`registry-stable`; updating to a development ref *after* `init` cannot bootstrap
a preset absent from the stable index. Use the harness before publication and
the remote/hosted checks in [RELEASING.md](RELEASING.md) at the release boundary.
Passing checkout checks alone does not establish published installability.

## Completion

A preset is ready when every advertised item has a worksheet with source
citations, passing recipe and token tests, generated distribution,
fresh-consumer coverage, a reviewed installed-source gallery, and CI coverage.
Report partial coverage as partial. Publishing and advancing registry refs are
separate from implementation; passing gates do not authorize publishing.
