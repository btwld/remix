# ADR 0001 — Carbon as an application-owned registry preset

Date: 2026-09-18. Status: accepted.

## Context

The repository previously contained `packages/remix_carbon`, a package-shaped
implementation of the IBM Carbon Design System. Its last complete source is
preserved at repository commit `606bfbb36`. The current distribution model is
the application-owned registry described by the
[Fortal registry-source ADR](../fortal/0002-registry-source.md): analyzed source
is authored once under `registry_source`, mechanically derived into bundled CLI
templates, and copied into each consuming application.

Carbon must use that model without recreating a `remix_carbon` package or
making the authoring package a consumer dependency. The implementation runbook
and item mapping are maintained beside this record:

- [Carbon implementation runbook](../../carbon/runbook.md)
- [Carbon component map](../../carbon/component-map.md)

## Decision

| Concern | Decision |
| --- | --- |
| Distribution | `carbon` is a third bundled `remix_cli` preset. Never restore `packages/remix_carbon`. |
| Authoring home | Carbon source lives under `registry_source/lib/src/carbon/`, with the public authoring barrel at `registry_source/lib/carbon.dart`. |
| Ownership | Installed source is owned by the consuming application. Consumers do not depend on an authoring package. |
| Authoring prefix | Source uses `Carbide` / `carbide`. The builder replaces that prefix with the consumer-selected prefix. |
| Installed prefix | The consumer chooses it. Fixtures use `Acme`, matching the Fortal fixture convention. |
| Item names | Reuse the existing registry catalog names (`button`, `switch`, `textfield`, and so on) when concepts align. Carbon-specific vocabulary remains in Dart APIs, such as button `kind`. |
| Templates | `packages/remix_cli/lib/src/registry/carbon/` is builder-owned output. It is never hand-edited. |
| Remix dependency | Installed Carbon source depends on hosted `remix: ^1.0.0-beta.10`. |
| Wave 1 runtime floors | Only `remix` and `mix_annotations`. |
| Wave 1 generator floors | Only `build_runner` and `mix_generator`. |
| Agent and dashboards | Out of v1. There is no Carbon Agent extension, recipe tree, `build.yaml`, dashboard shell, dashboard demo, or dogfood-app installation. |
| Icons | The full Carbon icon font is out of v1. Initial components use Remix path glyphs or `IconData`. Icon packaging is a later, separately contracted wave. |
| Native Carbon widgets | Follow Remix-mapped families. Use plain application-owned source, without `@MixWidget`, when Carbon anatomy does not match a Remix component. |

`Carbide` is deliberately an internal authoring word, not a product name. The
registry builder performs plain textual replacement, and `Carbon` / `carbon`
occurs legitimately in URLs, upstream package names, provenance text, and
design-system terminology. Using `Carbide` makes replacement collision-free.
Comments may call the design system Carbon but must use `Carbide` only when
naming an authoring identifier such as `CarbideButton`, `carbideButtonStyle`,
or `CarbideScope`.

```text
registry_source/lib/src/carbon/      analyzed source, Carbide prefix
        │  fvm dart run tool/build_registry.dart --preset carbon
        ▼
packages/remix_cli/lib/src/registry/carbon/
        registry.yaml + templates/**/*.tmpl
        │  remix init --preset carbon && remix add <item>
        ▼
consumer lib/ui/                     application-owned, chosen prefix
```

## Initial slice

Wave 1 contains only the Carbon theme required by `button` and the button
itself. It supports the official white and Gray 10 themes and supplies real
Carbon values for every token the button consumes. Placeholder colors must not
be described or tested as Carbon parity.

The initial button preserves the historical public kinds, curated
`widgetParameters: .only(...)` forwarding, loading treatment, and disabled
behavior. It has a fixed 48 px height. The contextual size parameter and icon
button wait for the real foundation in Wave 2 or a later mapped-component wave.

Wave 2 lifts the pinned token pipeline, reference data, provenance lock, and
foundation from `606bfbb36`. It restores all four themes and contextual
layout/type/motion behavior. Generated token libraries are ordinary `.dart`
files under `theme/generated/`, not `.g.dart`: `.g.dart` is reserved for
build-runner output and is excluded by the registry builder.

Later component and platform work follows the component map. Native widgets,
charts, icon-package publishing, and Agent/dashboard integration are roadmap
items that require their own executable contracts; they do not block Waves 1
and 2.

## Provenance and attribution

The implementation baseline is
`606bfbb36:packages/remix_carbon/`. The historical source records the official
Carbon repository at commit
`188d23202ec1092322dee92cf0df9d9958224ae4` (2026-08-13) and pins these upstream
packages:

| Source | Version |
| --- | --- |
| `@carbon/react` | 1.114.0 |
| `@carbon/styles` | 1.113.0 |
| `@carbon/themes` | 11.79.0 |
| `@carbon/colors` | 11.56.0 |
| `@carbon/layout` | 11.57.0 |
| `@carbon/type` | 11.65.0 |
| `@carbon/motion` | 11.50.0 |
| `@carbon/icons` | 11.86.0 |

Carbon-derived material is Apache-2.0. When source is first lifted, retain all
applicable copyright, license, attribution, modification, and trademark notices
from the historical package and its pinned upstream inputs. Those notices must
remain readable in the authored source and in distributed templates; prefix
substitution must not rewrite provenance. Token generation must retain the
upstream repository, commit, versions, integrity hashes, and license in its
committed lock or manifest.

IBM Plex is not bundled. Applications that supply it are responsible for its
SIL Open Font License obligations. “IBM”, “Carbon”, and “IBM Plex” are IBM
trademarks. This is an independent community implementation and is not endorsed
by or affiliated with IBM.

## Consequences

- Carbon follows the same single-source, analyzed, drift-checked distribution
  model as the other presets.
- A fresh consumer installs only the source and dependencies required by its
  selected items; it does not inherit charts, icons, Agent, or authoring-package
  dependencies.
- The small first slice can ship without weakening the default or Fortal
  consumer gates.
- Carbon parity is incremental and explicit. Wave 1 is not represented as a
  complete Carbon component catalog.
- Provenance is a property of both authoring source and generated distribution,
  not an optional documentation follow-up.
