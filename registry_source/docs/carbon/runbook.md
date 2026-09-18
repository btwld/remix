# Carbon registry implementation runbook

Status: ready to execute. This runbook implements
[ADR 0001](../adr/carbon/0001-carbon-preset.md). The historical source to lift
is repository commit `606bfbb36`, under `packages/remix_carbon/` in that tree.

No product decision blocks the first implementation slice. Treat the ownership,
handoff, dependency, and verification rules below as part of the implementation
contract.

## Goal and invariants

Applications can run:

```bash
dart run remix_cli:remix init --prefix Acme --preset carbon
dart run remix_cli:remix add button
```

and receive application-owned, prefixed source under `lib/ui/`. Remix remains
the behavior dependency. There is no `package:remix_carbon`.

Keep these invariants throughout the rollout:

- preset name: `carbon`;
- authoring prefix: `Carbide` / `carbide`;
- installed prefix: consumer-selected (`Acme` in the fixture);
- source: `registry_source/lib/src/carbon/`;
- derived templates: builder-owned, never hand-edited;
- v1 has no Agent extension, recipes, dashboards, dogfood-app install, chart
  dependency, or full icon package;
- applicable provenance and notices from `606bfbb36` and its pinned IBM Carbon
  inputs survive in both source and distributed templates.

The [component map](component-map.md) is the source of truth for later item
names and batches.

## Ownership and handoffs

| Track | Owns | Does not own |
| --- | --- | --- |
| Architect | Carbon ADR and durable runbook/component map under `registry_source/docs/` | source, tests, tools, CI, consumer docs |
| Kernel | Carbon authoring source and barrel, registry builder registration, builder regression tests, initial derived templates, required `registry_source` metadata | consumer checker, CI, public docs |
| CLI | bundled-preset recognition and CLI/installer registry tests | Carbon authoring source |
| Gates | `open_code/PRESETS.md`, consumer checker and tests, Carbon fixture, CI, dependency constraints, docs validator | component recipes |
| Docs | consumer-facing prose in `docs/open-code.mdx`, `packages/remix_cli/README.md`, and `open_code/README.md` | Dart and CI |
| Integrator | final registry regeneration, derived drift fixes, combined verification | new features |

Every worker begins from the preparation revision containing the Architect
artifacts. Kernel completes its source/API handoff first. CLI and Gates then
consume that exact Kernel revision. Integrate in this order:

```text
Kernel → CLI → Gates → Docs → Integrator verification
```

Do not merge a partial Wave 1 into `main`. Use no more than two workers beside
the coordinating agent in one session; start Docs after a worker slot opens.

## Wave 1 — theme and button vertical slice

### Kernel

1. Add `registry_source/lib/carbon.dart` and author:

   ```text
   registry_source/lib/src/carbon/
     theme/
       theme.dart
       theme_scope.dart
       theme_data.dart
       tokens.dart
     components/
       button.dart
       button.g.dart
   ```

2. Lift the theme and button behavior from
   `606bfbb36:packages/remix_carbon/`, adapting imports to the current Remix and
   Mix APIs. Use `Carbide` / `carbide` only as the replaceable prefix.
3. Support Carbon white and Gray 10 with real values for every token consumed
   by the button. Do not use placeholder colors as parity values.
4. Preserve `CarbideButtonKind`, curated `.only(...)` target forwarding,
   activation behavior, disabled suppression, loading-via-disabled treatment,
   and focus treatment.
5. Use a fixed 48 px height. Omit the public size parameter and icon-button
   implementation until their real foundation is available.
6. Declare only these installed dependency floors:
   - runtime: `remix: ^1.0.0-beta.10`, `mix_annotations`;
   - generator: `build_runner`, `mix_generator`.
7. Register `carbonPreset` with only the theme shared item and button recipe.
   Register `carbon: [carbonPreset]`; do not add an Agent extension, recipes,
   charts, icons, or composed Agent dependencies.
8. Preserve applicable historical and upstream attribution in the first copied
   source. Ensure it also appears in the derived templates.
9. From `registry_source`, generate the Mix adapter with `fvm dart`. From the
   repository root, run the registry builder. Commit no hand-authored template.

Kernel's focused builder regression test proves:

- `presetSpecs` contains `carbon`;
- the derived button contains `{{typePrefix}}Button` and
  `{{valuePrefix}}ButtonStyle`;
- no derived template contains the internal `Carbide` prefix;
- applicable provenance remains after prefix substitution.

### CLI

After the Kernel handoff exists:

1. Add `carbon` to `bundledPresets`.
2. Test loading the bundled Carbon registry.
3. Test that resolving `button` returns exactly `theme → button`.
4. Update hard-coded preset lists only when they mean every bundled preset;
   leave Fortal-specific behavior Fortal-specific.

### Gates

After Kernel has fixed the Wave 1 file and item inventory:

1. Create a minimal `open_code/carbon_fixture/` with `AcmeScope` and
   `AcmeButton`; do not copy dashboard or unrelated Fortal examples.
2. Make checker expectations preset-specific:
   - Carbon runtime dependencies: `remix`, `mix_annotations`;
   - Carbon generator dependencies: `build_runner`, `mix_generator`;
   - independently install and verify Carbon `button`;
   - preserve the existing independent default and Fortal checks;
   - require no Agent-specific `build.yaml` for Carbon while retaining the
     default/Fortal scoped Agent builder contract;
   - reject dashboard-focused Carbon checks during argument validation;
   - use an explicit Carbon theme/file inventory;
   - use no generated fixture snapshots initially.
3. Add Carbon to normal open-code checks, hosted release checks, the CI matrix,
   and dependency-constraint validation.
4. Change docs validation to enumerate bundled presets rather than hard-coding
   default and Fortal.
5. Add regressions proving Carbon passes without charts, icons, or Agent files,
   and that default/Fortal retain their current requirements.
6. Update `open_code/PRESETS.md` to show the third source directory and current
   initial slice, without claiming a complete catalog.

Gates exclusively owns these shared files and contracts. Other tracks leave
handoff notes instead of editing them.

### Docs

Document:

- `init --preset carbon`;
- `add button`;
- the supported white and Gray 10 themes;
- the initial fixed 48 px button;
- that this is an initial Carbon slice, not a complete catalog.

### Integrator

Regenerate templates once, resolve integration drift, and run the complete
verification below. Do not add components while closing the wave.

## Wave 2 — real Carbon foundation

Lift the pinned extraction, normalization, generation, and verification
pipeline from `606bfbb36`, together with its lock, reference data, and
foundation tests.

- Put the pipeline under `registry_source/tool/carbon/`.
- Generate standalone token libraries as ordinary `.dart` files under
  `registry_source/lib/src/carbon/theme/generated/`.
- Do not use `.g.dart` for token libraries. That suffix is reserved for
  build-runner-owned parts, excluded by the registry builder, and enforced by
  the generated-code checker.
- Keep the normalized snapshot, generator output, upstream versions, integrity
  hashes, Carbon repository commit, and license deterministic and reviewable.
- Run token extraction only for maintainers. Consumers never run Node.
- Add deterministic token verification to CI.
- Restore white, Gray 10, Gray 90, and Gray 100 plus layer, layout, type, and
  motion behavior.
- Restore optional button sizing while preserving 48 px as the default.
- Verify all four themes against pinned values and verify that an installed
  consumer receives every required token library.

## Later rollout

After Wave 2, follow [the component map](component-map.md), one component owner
per assigned file. Component owners lift the historical implementation, adapt
it to current Remix APIs, generate its Mix part in `registry_source`, and add
focused tests. They do not edit shared theme, builder, fixture inventory, or
derived templates. The Integrator owns those shared surfaces and registry
generation.

Native Carbon widgets, charts, publishing an icon package, and Agent/dashboard
integration are roadmap only. Each requires a separate executable contract
before dispatch and does not block Waves 1 or 2.

## Verification

Use `fvm dart` and `fvm flutter` throughout. The shell's unqualified Dart SDK is
too old.

From `registry_source`, after source changes:

```bash
fvm dart run build_runner build --delete-conflicting-outputs
fvm dart analyze
fvm flutter test test/carbon
```

Run the applicable focused widget/foundation tests even if their eventual paths
differ. Explicitly check button activation, disabled suppression, loading
treatment, focus behavior, and supported theme values.

From the repository root:

```bash
fvm dart run tool/build_registry.dart --check
fvm dart test test/tool/build_registry_test.dart test/tool/check_open_code_test.dart
fvm dart run tool/check_open_code.dart --preset carbon --source checkout
fvm dart run tool/check_dependency_constraints.dart
fvm dart run tool/check_ci_coverage.dart
fvm dart run tool/validate_docs.dart
fvm dart analyze
```

Also run the CLI test suite and the existing default/Fortal consumer gates
because CLI recognition and checker logic are shared.

## Acceptance

Wave 1 is complete when a fresh application installs and generates
`AcmeScope` and `AcmeButton`, analyzes, and passes fixture tests without direct
authoring-package, Mix, Naked UI, chart, icon, or Agent dependencies. `button`
resolves exactly to `theme → button`, and prefix substitution preserves IBM
Carbon provenance.

Wave 2 is complete when token regeneration is deterministic, all four themes
resolve to pinned values, contextual layout sizing works, and both registry
derivation and fresh-consumer tests pass with every required generated token
library installed.
