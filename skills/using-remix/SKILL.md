---
name: using-remix
description: >-
  Builds Flutter UI with the Remix component library: hand-styled `Remix*`
  widgets or an app-installed Vanilla or Fortal preset (`remix_cli`,
  `remix.yaml`, generated `<Prefix>Button`,
  `<Prefix>ThemeScope`/`<Prefix>Scope`). Use when setting up or updating
  preset items and registry pins, placing the theme scope, wiring overlays,
  dialogs, and toasts, choosing or styling components with stylers,
  variants, and tokens, restyling this app's installed recipes and theme, or
  building a Remix component gallery. Also use for UI requests in projects
  whose pubspec or `remix.yaml` references Remix. Not for authoring or
  publishing a reusable design-system registry (use
  `building-remix-design-system`) or for Flutter UI in projects without
  Remix.
---

# Using Remix

Build accessible Flutter interfaces with Remix behavior plus a hand-written
style, the compact Vanilla starter preset, or Fortal's Radix Themes-inspired
preset. To build a reusable design system for other applications and
publish it as a Remix registry, use `building-remix-design-system`;
restyling this application's own installed source stays here.

## Glossary

| Term | Meaning |
| --- | --- |
| preset | Vanilla or Fortal — the installed starter theme and recipes `remix_cli` copies into the app |
| prefix | The app-chosen name (`Ui`, `Fortal`, `Acme`, ...) substituted into every generated type; recorded in `remix.yaml` |
| recipe function | `<prefix>ButtonStyle(...)` — returns the component's `*Styler`, the source of truth for one component's look |
| generated widget | `<Prefix>Button` — the `@MixWidget` adapter that calls the recipe function and wraps a `Remix*` widget |
| `<item>_recipe` | A registry item bundling an unstyled agent surface (`activity`, `composer`, ...) with its preset-specific styler |

## Choose base Remix, Vanilla, or Fortal

Inspect `pubspec.yaml` and `remix.yaml` before assuming how a project is set
up; `remix.yaml`'s `preset` field records the choice already made. A project
has exactly one preset and prefix: `init` refuses a different one while
`remix.yaml` exists, and both presets install into the same `theme/` and
`components/` files. In a Vanilla project, restyle Vanilla recipes (even per
screen, with a nested themed scope) rather than adding Fortal.

| Need | Source and API |
| --- | --- |
| No generated source or codegen wanted | base `remix`; hand-write `Remix*` widgets and `*Styler`s |
| A compact, editable starter theme and recipes (CLI default) | `remix init --preset vanilla`; generated `<Prefix>Button` etc. wrap `Remix*` widgets, plus `<Prefix>ThemeScope`/`<Prefix>Tokens` |
| Ready-made Radix Themes-inspired visuals | `remix init --prefix Fortal --preset fortal`; `<Prefix>Scope` plus prefixed `<Prefix>*` widgets |
| Own brand in one app, want editable tokens and recipes | Vanilla, then customize — see [Customize installed source](#customize-installed-source) |

Both presets install editable application source, not a package dependency:
`remix_cli` copies analyzer-checked Dart from a pinned GitHub registry into
`lib/ui` (or `--ui-path`). Component recipes, enum variants, and tokens are
yours to edit; nothing here is vendor-fixed.

## Set up dependencies and imports

Base Remix, no preset:

```bash
flutter pub add remix
```

<!-- dart-excerpt: imports only -->

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
dart run remix_cli:remix init --prefix Fortal --preset fortal   # Radix Themes preset
```

<!-- dart-excerpt: imports only -->

```dart
import 'package:flutter/widgets.dart';
import 'ui/ui.dart';
```

`init` resolves the `registry-stable` branch of `btwld/remix` and pins
its full commit SHA into `remix.yaml` (schema 3); see [CLI](references/cli.md)
to move that pin later. `add` also pulls each
item's own `registryDependencies` (its `theme` item, etc.), so a fresh
project does not need a separate `add theme`. Import
`package:remix/remix.dart` too when the file also uses base `Remix*`
widgets, `*Styler` types, or Remix data classes the owned barrel does not
re-export.

`import 'ui/ui.dart'` is a relative import: it only resolves as written from
a file at the `lib/` root, such as `lib/main.dart`. A file nested deeper
needs `package:<app>/ui/ui.dart` (or the equivalent relative path) instead,
substituting the configured `--ui-path` if it is not `lib/ui`.

| Preset | Scope class | Theme values and mode | Generated widget | Recipe function | Tokens |
| --- | --- | --- | --- | --- | --- |
| Vanilla | `<Prefix>ThemeScope` | `<Prefix>ThemeData`, `<Prefix>ThemeMode` | `<Prefix>Button` | `<prefix>ButtonStyle` | `<Prefix>Tokens` |
| Fortal | `<Prefix>Scope` | `<Prefix>ThemeData`, `<Prefix>ThemeMode` | `<Prefix>Button` | `<prefix>ButtonStyle` | `<Prefix>Tokens` |

The prefix is independent of the preset; read both from `remix.yaml` and
substitute. Examples in this skill use `Ui` for Vanilla and `Fortal` for
Fortal.

## Place the theme scope

Both presets' generated scope takes `theme`, `darkTheme`, `mode`, and
`child`; Fortal's also takes `accent`, `gray`, `panelBackground`, `radius`,
`scaling`, `hasBackground`, `orderOfModifiers`. Do not pass `data`,
`brightness`, `lightTheme`, or `createScope` — the constructors don't accept
them.

Install the scope in `WidgetsApp.builder`, above the Navigator, so pushed
routes, dialogs, and overlays inherit it:

```dart
import 'package:flutter/widgets.dart';
import 'ui/ui.dart';

Widget app(Widget home) => WidgetsApp(
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
  home: home,
);
```

For the Vanilla preset the builder is
`(context, child) => UiThemeScope(child: child!)`, with the same optional
`theme`/`darkTheme`/`mode` (`UiThemeData`, `UiThemeMode`). Vanilla widgets
take their Remix widget's parameters (`UiButton.primary(label: ...,
onPressed: ...)`); their variants and sizes are the enums in the installed
recipe, for example `UiButtonVariant` and `UiButtonSize` in
`lib/ui/components/button.dart`. Read the installed file rather than
assuming Fortal's families — see [Vanilla](references/vanilla.md).

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

## Customize installed source

Installed source has three levels of override, in order of scope:

- **One instance** — pass `style:` to the generated widget; it merges last.
  State fragments merge by state, so an override that must beat the recipe's
  hover or pressed fill has to declare that state's fragment too
  (`.onHovered(...)`, `.onPressed(...)`) — a bare `.color(...)` only replaces
  the idle one.
- **A subtree** — retheme with `copyWith` or a preset config:

  ```dart
  import 'package:flutter/widgets.dart';
  import 'ui/ui.dart';

  Widget rethemed(Widget child) => UiThemeScope(
    theme: const UiThemeData.light().copyWith(primary: const Color(0xFF4F46E5)),
    child: child,
  );
  ```

  ```dart
  import 'package:flutter/widgets.dart';
  import 'ui/ui.dart';

  Widget rethemed(Widget child) => FortalScope(accent: .red, child: child);
  ```

- **App-wide** — edit `lib/ui/components/<item>.dart` or `lib/ui/theme/*`
  directly; it is application source, not a package. After changing a
  recipe's parameters, enums, or `@MixWidget` annotation, run
  `dart run build_runner build` to regenerate its `.g.dart`.

## Provide only the host capabilities in use

Remix composes inside the caller's host; do not invent an app, scaffold, or
overlay-host wrapper.

| UI | Caller must provide |
| --- | --- |
| Ordinary widgets | Normal inherited Flutter services for that subtree |
| Generated widgets or recipes | The preset's scope plus normal Flutter services |
| Menu, select, popover, tooltip | An `Overlay`; use `Overlay.wrap` when no navigator is needed |
| Text field / text area once focused | An `Overlay` for selection handles; a routed `WidgetsApp` provides one, a builder-only host needs `Overlay.wrap` |
| `showRemixDialog`/`showRemixAlertDialog` | A caller-owned `Navigator` |
| `showRemixToast`/`RemixToast` | One `RemixToastScope` above the app's `Navigator`, inside the same builder, below the theme scope |

```dart
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'ui/ui.dart';

Widget builder(BuildContext context, Widget? child) => FortalScope(
  child: Overlay.wrap(
    child: RemixToastScope(style: fortalToastStyle(), child: child!),
  ),
);
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
3. Prefer `style:` on the generated widget (`FortalButton(style: ...)`,
   `UiButton(style: ...)`) to override the preset's recipe when the preset is
   the baseline. Use a preset's styler function (`fortalButtonStyle(...)`,
   `uiButtonStyle(...)`) directly on a `Remix*` widget only when the
   composition itself differs from the generated widget.
4. Build a `*Styler` from scratch when the design should not use either
   preset.

```dart
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

final submitStyle = ButtonStyler()
    .color(const Color(0xFF3E63DD))
    .padding(.horizontal(16))
    .padding(.vertical(10))
    .borderRadius(.circular(6))
    .labelColor(const Color(0xFFFFFFFF))
    .onHovered(ButtonStyler().color(const Color(0xFF3358D4)));

Widget submitButton(VoidCallback submit) =>
    RemixButton(label: 'Submit', style: submitStyle, onPressed: submit);
```

```dart
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'ui/ui.dart';

Widget saveButton(VoidCallback save) => RemixButton(
  label: 'Save',
  onPressed: save,
  style: fortalButtonStyle(variant: .solid)
      .padding(.horizontal(32))
      .borderRadius(.circular(8)),
);
```

Do not infer that every component shares the same variants or sizes: the
installed recipe's enum in `lib/ui/components/<name>.dart` is authoritative,
since that source is owned and may be edited.
[The Fortal catalog](https://github.com/btwld/remix/blob/main/docs/fortal/catalog.mdx)
describes the unedited upstream family.

## Preserve behavioral roots

- `RemixTabs` is the behavioral root; style it with `FortalTabBar`,
  `FortalTab`, and `FortalTabView` — there is no `FortalTabs`.
- Keep `RemixRadioGroup`, `RemixCheckboxGroup`, and `RemixAccordionGroup` as
  roots around their preset-styled children.
- `RemixAccordionGroup.controller` is required; see
  [Components](references/components.md#navigation) for Menu and Tabs.

## Route to references

Read only the references needed for the task:

| Task | Reference |
| --- | --- |
| Moving registry pins, adopting new source, other registries, old `remix.yaml` files | [CLI](references/cli.md) |
| Behavior rules for a component category and doc links | [Components](references/components.md) |
| Fortal scope/config, typography, and token rules | [Fortal](references/fortal.md) |
| Vanilla tokens, theme values, and per-component rules | [Vanilla](references/vanilla.md) |
| Fluent styling, state/context variants, animation, callable styles | [Styling](references/styling.md) |
| Reference apps, product examples, variant matrices, and showcase audits | [Reference showcases](references/reference-showcases.md) |
| A reusable design system published as a Remix registry | `building-remix-design-system` |

## Verify the result

- Keep imports aligned with the selected source layer and configured prefix.
- Confirm preset content and route/overlay builders sit below the theme
  scope, and a `RemixToastScope` sits below it too when toasts are used.
- Confirm overlays and dialogs have the required caller-owned host
  capability.
- After editing a recipe's parameters, enums, or `@MixWidget` annotation, run
  `dart run build_runner build` and confirm the regenerated `.g.dart` looks
  right.
- For showcases, verify product examples follow the
  [product-example rules](references/reference-showcases.md#product-examples)
  and coverage galleries follow the
  [coverage-gallery rules](references/reference-showcases.md#coverage-galleries)
  instead of forcing one policy onto both.
- Run the project's formatter, analyzer, and relevant Flutter tests.
