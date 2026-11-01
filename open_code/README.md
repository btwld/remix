# Application-owned Remix UI

`remix_cli` installs editable preset source into your app. Remix retains
rendering, interaction and accessibility; you own the theme, recipes and
installed Agent behavior. Choose one preset: neutral **Vanilla**, **Fortal**
with its own visual contract, or **HeroUI** following HeroUI web 3.2.6.
Rationale lives in [ARCHITECTURE.md](../ARCHITECTURE.md).

## Install the CLI in a project

```shell
flutter pub add 'dev:remix_cli:^1.0.0-beta.1'
dart run remix_cli:remix init --prefix Acme --preset vanilla
dart run remix_cli:remix add button
```

Use `--preset fortal` for Fortal or `--preset heroui` for HeroUI at initialization.
Preset, prefix and UI path
are chosen once; `Ui` and `lib/ui` are defaults. `Remix` and `Mix` are reserved
prefixes. Each `add` installs only the requested item and its dependency closure.
`init` pins `registry-stable` to a full GitHub commit in `remix.yaml`; commit it
alongside the app lockfile, which pins the project-local CLI separately.

The resulting Vanilla layout is:

```text
lib/ui/
  ui.dart                    managed exports
  theme/                     owned tokens, values, scope and effects
  components/button.dart     owned recipe; edit this
  components/button.g.dart   consumer-generated adapter; regenerate this
```

For a component's names and parameters, read the installed recipe and enums.
Import `ui/ui.dart` from a file at the `lib/` root; nested files need the
corresponding package or relative import. See the [catalog](../docs/open-code.mdx)
for items, including charts, icons, dashboard composition and Agent bundles.

Contributors using an unreleased CLI can install it from a checkout:

```shell
dart pub add "dev:remix_cli@{path: /path/to/remix/packages/remix_cli}"
```

If the registry's required runtime floor is not published yet, use an explicit
checkout override for development. Only [hosted release checks](RELEASING.md)
establish that published packages satisfy the floor; a local override does not.

## Host requirements

Install the generated theme in the existing host's builder, above its Navigator,
so routes and overlays inherit tokens. See the [complete setup](../skills/using-remix/SKILL.md#place-the-theme-scope).

| Feature | Caller provides |
| --- | --- |
| Preset widgets | The preset's theme scope and normal Flutter services |
| Menus, select, popover, tooltip, focused text fields | `Overlay`; routed hosts supply one, otherwise use `Overlay.wrap` |
| Dialog helpers | `Navigator` |
| Toasts | `RemixToastScope` below the theme and above the Navigator, with an overlay |

`RemixCheckboxGroup`, `RemixRadioGroup`, `RemixTabs` and
`RemixAccordionGroup` are behavioral roots with no registry item; import them
from `package:remix/remix.dart` around the installed styled children.

## Customization

Use a named constructor for a fixed variant (`AcmeButton.primary`); use
`variant:` for runtime selection. Pass `style:` for an instance override, a
nested theme for a subtree, or edit recipes/theme files for app-wide changes.
State fragments merge by state: replacing an idle fill does not replace hover
or pressed fills. See [styling](../skills/using-remix/references/styling.md).

After changing recipe parameters, enums, annotations, Remix or the generator,
regenerate and review the adapter:

```shell
dart run build_runner build --build-filter=lib/ui/components/button.g.dart
```

Commit authored and generated source. A normal `add` preserves existing authored
files and includes already-installed adapters in generation.

## Source ownership

Commit `remix.ownership.json` with `remix.yaml` and the installed source. It
reserves authored and generated targets across separate installs, so another
registry cannot silently preserve or overwrite a different owner's recipe.
Disjoint additive registries remain supported. Existing files from CLI beta.0
or earlier need explicit provenance verification and `--adopt`; see the
[migration instructions](REGISTRIES.md#existing-source-without-an-ownership-record).

Updating a pin and adopting source are separate operations:

```shell
dart run remix_cli:remix registry update @remix
dart run remix_cli:remix add button --diff
dart run remix_cli:remix add button --overwrite
```

`--diff` is read-only and requires Git. `--overwrite` replaces only named items,
never their customized dependencies. If an update requires a newer theme, name
`theme` explicitly too, after reviewing its diff. Restoring a pin does not
restore installed source; use the app's version control for that.

For additional registries and retired configurations, use the
[registry contract](REGISTRIES.md).

## Styling a package on top of the catalog

Agent's `composer_recipe` installs behavior plus a bundle of parent and child
stylers. Pass the bundle's `style`, `surfaceStyle`, `fieldStyle`, `submitStyle`
and `stopStyle` to the installed composer; child controls resolve their own
interactive states. See [Agent usage](../registry_source/docs/agent/README.md).
Agent installs also enable the scoped spec-styler builder in consumer
`build.yaml`; incompatible existing configuration fails preflight.

## Charts without Fortal

`add chart` installs three adapters backed by `mix_chart`. Import that package
directly for data models, supply finite chart dimensions and keep existing
themes' `chart1`–`chart5` tokens current. The owned barrel does not re-export
`mix_chart`. `add icons` installs an editable alias set backed by `remix_ui_icons`.

## Material boundary

`material:check` rejects Material imports/exports, `material_ui` dependencies
and `uses-material-design` in owned runtime/icon/font/preset source. It does
not inspect transitive dependencies: Mix retains Material integration and
optional charts use `mix_chart`/`fl_chart` ([Mix #1021](https://github.com/btwld/mix/issues/1021)).

## Repository proof

[REGISTRIES.md](REGISTRIES.md#repository-consumers) lists workspace consumers
and derivation checks. [RELEASING.md](RELEASING.md) defines checkout, hosted and
published-CLI gates; these prove different boundaries.

## Item catalog

Vanilla and Fortal: `theme`, `icons`, `chart`, `accordion`, `app_bar`, `avatar`,
`badge`, `button`, `callout`, `card`, `checkbox`, `dashboard_demo`,
`dashboard_shell`, `data_list`, `data_table`, `dialog`, `disclosure`, `divider`,
`icon_button`, `link`, `menu`, `popover`, `progress`, `radio`, `segmented_control`,
`select`, `sidebar`, `sidebar_layout`, `skeleton`, `slider`, `spinner`, `switch`,
`tabs`, `textfield`, `toast`, `toggle`, `toggle_group`, `tooltip`.

Fortal also: `base_button`, `code`, `heading`, `kbd`, `text`, `typography`.

HeroUI follows HeroUI's names, adding `alert`, `avatar_group`, `breadcrumbs`,
`button_group`, `checkbox_group`, `chip`, `close_button`, `dropdown`,
`field_layout`, `input_group`, `modal`, `radio_group`, `search_field`,
`separator`, `surface`, `switch_group`, `table`, `textarea`, `toggle_button`,
and `toggle_button_group` to shared names such as `button` and `select`.
It includes no Agent, dashboard, chart or icons items. Its installed-source
gallery is `open_code/heroui_fixture`; see [Presets](PRESETS.md).

Vanilla and Fortal Agent source: `activity`, `answer`, `composer`, `execution`, `message`,
`permission`, `plan`, `transcript`; shared `models` and `support` install
transitively. Styled bundles: `activity_recipe`, `answer_recipe`,
`composer_recipe`, `execution_recipe`, `message_recipe`, `permission_recipe`,
`plan_recipe`, `transcript_recipe`.
