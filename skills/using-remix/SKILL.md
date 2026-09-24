---
name: using-remix
description: >-
  Use when building Flutter UI with the Remix component library or its
  installed Vanilla or Fortal preset theme: choosing base Remix vs a preset,
  setting up `remix_cli`, moving registry pins, placing the generated theme
  scope, composing overlays/routes/toasts, choosing components, or styling
  `Remix*` widgets with stylers, states, variants, recipes, and tokens. Also
  trigger when building or auditing a Remix/Fortal reference showcase or
  component gallery, for Remix/Fortal widget names, or for a UI request in a
  project that already contains `remix` or `remix.yaml`. Do not trigger for
  generic Flutter UI work when none of those are present or requested.
---

# Using Remix

Build accessible Flutter interfaces with Remix behavior plus a hand-written
style, the compact Vanilla starter preset, or Fortal's Radix Themes-inspired
preset. To build a reusable design system for other applications and
publish it as a Remix registry, use `building-remix-design-system`;
restyling this application's own installed source stays here.

## Choose base Remix, Vanilla, or Fortal

Inspect `pubspec.yaml` and `remix.yaml` before assuming how a project is set
up; `remix.yaml`'s `preset` field records the choice already made.

| Need | Source and API |
| --- | --- |
| Fully custom visual system, no starter theme | `remix` only; hand-write `Remix*` widgets and `*Styler`s |
| A compact, editable starter theme and recipes (CLI default) | `remix_cli --preset vanilla`; generated `<Prefix>Button` etc. wrap `Remix*` widgets, plus `<Prefix>ThemeScope`/`<Prefix>Tokens` |
| Ready-made Radix Themes-inspired visuals | `remix_cli --preset fortal`; `<Prefix>Scope` plus prefixed `<Prefix>*` widgets |
| Agent-run surfaces (composer, transcript, permission, plan, activity, answer, execution, message) | either preset's bare item (unstyled) plus its `<item>_recipe` for a styled bundle |
| A visual system unrelated to either preset | base `remix`; do not run `remix_cli` or initialize a preset |

Both presets install **editable application source**, not a package
dependency: `remix_cli` copies analyzer-checked Dart from a pinned GitHub
registry into `lib/ui` (or `--ui-path`). It is your source to edit —
component recipes, enum variants, and tokens are not vendor-fixed. Neither
preset adds any published theme package as a dependency.

## Set up dependencies and imports

Base Remix, no preset:

```bash
flutter pub add remix
```

```dart
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
```

With a preset, initialize the registry and add the items the app uses:

```bash
flutter pub add dev:remix_cli
dart run remix_cli:remix init                  # preset defaults to vanilla, prefix to Ui
dart run remix_cli:remix add button textfield
```

```bash
dart run remix_cli:remix init --preset fortal   # Radix Themes preset
```

```dart
import 'package:flutter/widgets.dart';
import 'ui/ui.dart';
```

`init` resolves the `registry-stable` branch of `conceptadev/remix` and pins
its full commit SHA into `remix.yaml` (schema 3). `add` also pulls each
item's own `registryDependencies` (its `theme` item, etc.), so a fresh
project does not need a separate `add theme`. Import
`package:remix/remix.dart` too when the file also uses base `Remix*`
widgets, `*Styler` types, or Remix data classes the owned barrel does not
re-export.

Examples in this skill use the `Ui` prefix for Vanilla and `Fortal` for the
Fortal preset, matching the project's own docs convention. Use the prefix
already recorded in an initialized project's `remix.yaml` instead.

## Move a registry pin

```bash
dart run remix_cli:remix registry update @remix                  # move to the newest promoted commit
dart run remix_cli:remix registry update @remix --ref <sha|branch>
dart run remix_cli:remix add button --diff                       # review what changed
dart run remix_cli:remix add button --overwrite                  # adopt the new source
```

`registry update` only rewrites the pin in `remix.yaml`; it never touches
installed files. Adopt new source item by item with `--diff` then
`--overwrite` — there is no automatic merge. `--overwrite` replaces the named
item's files wholesale, discarding local edits to them, and never touches a
dependency you have customized; re-apply deliberate edits from the diff.
Rolling back is `git checkout remix.yaml`, which restores the pin but not
installed source. `registry add @ns --repository
owner/repo --path registry --ref <ref>` registers a second registry
namespace under `@ns`.

`remix.yaml` schema 3 is the only readable configuration; an older file fails
to read with an explicit error. Recover a schema 1 or 2 project by deleting
`remix.yaml`, running `remix init` again with its old `--prefix`/`--preset`/
`--ui-path`, then re-adopting installed source with `add <item> --diff`.

## Place the theme scope

Both presets' generated scope takes `theme`, `darkTheme`, `mode`, and
`child`; Fortal's also takes `accent`, `gray`, `panelBackground`, `radius`,
`scaling`, `hasBackground`, `orderOfModifiers`. There is no `data`,
`brightness`, `lightTheme`, or `createScope` — those were removed.

Install the scope in `WidgetsApp.builder`, above the Navigator, so pushed
routes, dialogs, and overlays inherit it:

```dart
import 'package:flutter/widgets.dart';
import 'ui/ui.dart';

WidgetsApp(
  color: const Color(0xFFFFFFFF),
  pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
  ),
  builder: (context, child) => FortalScope(
    theme: const FortalThemeData.light(),
    darkTheme: const FortalThemeData.dark(),
    mode: FortalThemeMode.system,
    child: child!,
  ),
  home: const MyScreen(),
)
```

For the Vanilla preset the builder is
`(context, child) => UiThemeScope(child: child!)`, with the same optional
`theme`/`darkTheme`/`mode` (`UiThemeData`, `UiThemeMode`). Vanilla widgets
take their Remix widget's parameters (`UiButton.primary(label: ...,
onPressed: ...)`); their variants and sizes are the enums in the installed
recipe, for example `UiButtonVariant` and `UiButtonSize` in
`lib/ui/components/button.dart`. Read the installed file rather than
assuming Fortal's families.

- A root with neither `theme` nor `darkTheme` supplies the preset's light/dark
  defaults and follows the system.
- Supplying only `theme` uses that value in both modes; supplying only
  `darkTheme` keeps the inherited or default light theme.
- A nested scope with no `mode` inherits the parent's configured pair and
  active selection; an explicit nested `mode` selects from that inherited
  pair.
- The app owns mode preference and persistence. `mode: .system` reacts to
  platform brightness changes; no brightness observer is needed.
- The outermost Fortal scope also sets a courtesy `DefaultTextStyle` for bare
  Flutter `Text` (Radix `text3`, `gray-12`, regular weight, no pinned font
  family) — a fallback for ordinary text, not the source of Fortal
  typography's own token defaults. A nested scope re-scopes tokens only and
  does not restate that fallback.

## Provide only the host capabilities in use

Remix composes inside the caller's host; do not invent an app, scaffold, or
overlay-host wrapper.

| UI | Caller must provide |
| --- | --- |
| Ordinary widgets | Normal inherited Flutter services for that subtree |
| Preset widgets or recipes | The preset's scope plus normal Flutter services |
| Menu, select, popover, tooltip | An `Overlay`; use `Overlay.wrap` when no navigator is needed |
| `showRemixDialog`/`showRemixAlertDialog` | A caller-owned `Navigator` |
| `showRemixToast`/`RemixToast` | One `RemixToastScope` above the app's `Navigator`, inside the same builder, below the theme scope |

```dart
builder: (context, child) => FortalScope(
  child: Overlay.wrap(
    child: RemixToastScope(style: fortalToastStyle(), child: child!),
  ),
),
```

Feature code then calls
`showRemixToast(context, RemixToastData(title: 'Draft saved'))` from an event
callback; a per-toast `style:` merges over the scope's.

## Choose a styling path

1. Prefer a preset's named constructor for standard UI, e.g.
   `FortalButton.soft(...)` or `UiButton.primary(...)`, when the variant is
   fixed.
2. Use the unnamed preset constructor with `variant:` only when the variant
   is selected at runtime.
3. Start from the preset's styler function (`fortalButtonStyle(...)`,
   `uiButtonStyle(...)`) and pass the result to a `Remix*` widget when the
   preset is the baseline but the composition or styling needs overrides.
4. Build a `*Styler` from scratch when the design should not use either
   preset.

```dart
final submitStyle = ButtonStyler()
    .color(const Color(0xFF3E63DD))
    .padding(.horizontal(16))
    .padding(.vertical(10))
    .borderRadius(.circular(6))
    .labelColor(const Color(0xFFFFFFFF))
    .onHovered(ButtonStyler().color(const Color(0xFF3358D4)));

RemixButton(label: 'Submit', style: submitStyle, onPressed: submit)
```

```dart
RemixButton(
  label: 'Save',
  onPressed: save,
  style: fortalButtonStyle(variant: .solid)
      .padding(.horizontal(32))
      .borderRadius(.circular(8)),
)
```

Do not infer that every component shares the same variants or sizes; check
[the Fortal catalog](https://github.com/conceptadev/remix/blob/main/docs/fortal/catalog.mdx)
or the installed recipe's enum for the exact family.

## Preserve behavioral roots

- `RemixTabs` is the behavioral root; style it with `FortalTabBar`,
  `FortalTab`, and `FortalTabView` — there is no `FortalTabs`.
- Keep `RemixRadioGroup`, `RemixCheckboxGroup`, and `RemixAccordionGroup` as
  roots around their preset-styled children.
- `RemixAccordionGroup.controller` is required; Tabs and Menu manage
  optional controllers.

## Route to references

Read only the references needed for the task:

| Task | Reference |
| --- | --- |
| Behavior rules for a component category and doc links | [Components](references/components.md) |
| Fortal install, scope/config, typography, and token rules | [Fortal](references/fortal.md) |
| Fluent styling, state/context variants, animation, callable styles | [Styling](references/styling.md) |
| Reference apps, product examples, variant matrices, and showcase audits | [Reference showcases](references/reference-showcases.md) |
| A reusable design system published as a Remix registry | `building-remix-design-system` |

## Verify the result

- Keep imports aligned with the selected source layer and configured prefix.
- Confirm preset content and route/overlay builders sit below the theme
  scope, and a `RemixToastScope` sits below it too when toasts are used.
- Confirm overlays and dialogs have the required caller-owned host
  capability.
- For showcases, verify product examples and exhaustive coverage use their
  respective rules instead of forcing one abstraction or contrast policy onto
  both.
- Run the project's formatter, analyzer, and relevant Flutter tests.
