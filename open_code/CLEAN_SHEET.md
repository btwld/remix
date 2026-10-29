# Clean-sheet decision: application-owned UI on Remix

## The problem

Remix ships behavior without prescribing an application's design language.
Applications can start with the Vanilla or Fortal registry preset, then own the
installed theme and component recipes without maintaining forwarding wrappers
by hand.

## Decision

`remix_cli` installs authored theme and component source into the application.
`@MixWidget` generates forwarding adapters there, against the consumer's
resolved Remix and Mix versions. Applications edit visual recipes while Remix
retains rendering, behavior and accessibility machinery.

Theme and component dependencies are declared by registry items. The CLI
resolves each requested dependency closure in a stable order, adds compatible
hosted dependencies, exports authored files and generates the declared parts.
Compound components can declare several `@MixWidget` adapters in one file;
Agent surfaces install their domain source and opt-in recipe bundles. See the
current catalog in `docs/open-code.mdx` and the [preset contract](PRESETS.md).

## Ownership boundary

| Remix owns | The application owns |
|---|---|
| Rendering and layout machinery | Semantic tokens and light/dark values |
| Pointer, keyboard, focus, and feedback behavior | Button variants, sizes, and visual recipe |
| Accessibility semantics | Theme, recipe, and instance customization |
| Loading and disabled interaction rules | Installed authored files |
| Naked UI delegation | The generated adapter committed by the app |
| Mix specs, stylers, variants, and resolution | |

Installed component recipes use the public `package:remix/remix.dart` surface;
they do not copy Remix internals or import the private authoring package.
The optional chart item also imports the public `package:mix_chart/mix_chart.dart`
surface for its data, rendering, interaction, and semantics contract.

## Why generation is part of the consumer

The recipe is a normal function returning `ButtonStyler`:

```dart
@MixWidget(target: RemixButton.new)
ButtonStyler acmeButtonStyle({
  AcmeButtonVariant variant = .primary,
  AcmeButtonSize size = .medium,
  ButtonStyler style = const ButtonStyler.create(),
}) { /* recipe */ }
```

The generator combines the recipe parameters with the complete safe
`RemixButton` constructor surface. A non-nullable variant enum also produces
named constructors such as `AcmeButton.destructive`.

Default-all forwarding is intentional. A handwritten wrapper or parameter
allowlist can silently miss a new Remix capability. Regeneration instead turns
constructor changes into generated diffs that an application can review.

Two target parameters are not exposed as ordinary overrides:

- `style` is supplied by the recipe. The recipe's own `style` argument merges
  last and is the application-level override.
- `styleSpec` bypasses style resolution, including the recipe and its tokens,
  so it is not a useful visual customization hook here.

Generated source is not bundled in the registry. It is emitted from the
consumer's resolved Remix and generator versions, then compared with a
committed Acme fixture in this repository to make drift visible.

## Registry and installer boundaries

Registry content publishes independently on GitHub, and a project pins full
revisions in `remix.yaml`. Schema 3 is the only readable shape, so every read
goes through a pin the project recorded. See [the registry contract](REGISTRIES.md)
for namespaces, dependency resolution, updates and source ownership.

The installer still protects application source:

- existing authored files are preserved on normal runs;
- `--diff` is read-only;
- `--overwrite` applies only to the item explicitly requested;
- dependency declarations that already resolve compatibly are preserved;
- validation and dependency failures happen before authored-source writes;
- generation targets the parts declared by resolved items, plus every
  already-installed adapter, so adding one item cannot delete another
  item's generated part.

## Dependency cost

Runtime dependencies are `remix` and `mix_annotations`. Mix and Naked UI arrive
through Remix, which avoids choosing a direct Mix version that Remix was not
compiled against. Installing the optional chart item adds `mix_chart` directly;
it never adds the authoring source package. Development dependencies are `build_runner` and
`mix_generator`.

Chart is deliberately one item with three adapters. `mix_chart` owns the hard
chart contract. The installed file owns presentation and resolves theme
tokens only: `background`, `foreground`, `mutedForeground`, `border`, `radius`,
and the five `chart1`-`chart5` entries the chart item added to the vocabulary.
A theme installed before those five existed does not carry them, and authored
files are preserved on normal runs, so such a theme needs them added by hand.

The recurring costs are visible:

- recipe, Remix constructor, or generator changes require regeneration;
- Remix prerelease changes can rewrite the generated adapter;
- the installed layer intentionally relies on Remix's Mix re-export;
- compact 32/36/40px sizes suit web density but are below common mobile touch
  target guidance, so adopting apps must make their own density decision.

## Verification and release boundary

The supported presets share the ownership and derivation contract in
[PRESETS.md](PRESETS.md). Checkout consumer checks validate unshipped source;
hosted consumer checks validate published dependency floors. Neither a local
workspace override nor a successful checkout test certifies hosted minimum-version
compatibility. [RELEASING.md](RELEASING.md) defines the publication order and
required checks.

## Agent source distribution

Both catalogs include eight domain-specific Agent surfaces. Unlike visual
`@MixWidget` recipes, these copy the private authoring package's
(`registry_source/lib/src/agent`) behavior and empty anatomy specs into the
application, and each preset styles them through recipes authored in its own
source tree. They still compose public Remix primitives; they do not copy Remix internals or introduce a
private runtime dependency. Applications own the installed domain behavior as
well as its appearance. The scope of future source-update diffs includes that
behavior.

The supported Mix spec-styler builder is opt-in, so these installs enable it
for their source paths in consumer `build.yaml`. This is a deliberate extension
to the original recipe-only, no-build-config contract. Existing configuration
is preserved, conflicts are rejected during preflight, and configuration changes
appear in dry-run/diff. Registry schema and preset selection are unchanged.
