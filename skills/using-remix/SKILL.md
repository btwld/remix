---
name: using-remix
description: >-
  Builds Flutter UI with the Remix component library: hand-styled `Remix*`
  widgets or an app-installed Vanilla, Fortal, or HeroUI preset (`remix_cli`,
  `remix.yaml`, generated `<Prefix>Button`,
  `<Prefix>Theme`). Use when setting up or updating
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

Inspect `pubspec.yaml`, `remix.yaml` and installed source first. Use this skill
for app UI and restyling owned source; use `building-remix-design-system` for a
reusable registry, and the `mix` skill for general styling syntax.

## Choose base Remix, Vanilla, Fortal, or HeroUI

| Need | Start with |
| --- | --- |
| Hand-written widgets, no source generation | `remix`; `Remix*` widgets and `*Styler`s |
| Neutral editable recipes | Vanilla (CLI default), then customize |
| Fortal's visual language | Fortal preset |
| HeroUI web 3.2.6 visuals | HeroUI preset; see [HeroUI](references/heroui.md) |

A project has one preset and prefix, recorded in `remix.yaml`. All presets
write the same theme/component paths; do not mix them. A prefix is independent
of the preset: `UiButton` can be Fortal. Read the installed enums instead of
assuming one preset's variants or sizes carry over.

## Set up dependencies and imports

For base widgets: `flutter pub add remix`, then import
`package:remix/remix.dart` and widgets-layer Flutter. For editable source:

```bash
flutter pub add dev:remix_cli
dart run remix_cli:remix init                  # vanilla, prefix Ui
dart run remix_cli:remix add button textfield
```

Choose Fortal at initialization with `init --prefix Fortal --preset fortal`.
`init` pins `registry-stable` to a full GitHub SHA in schema-3 `remix.yaml`.
`add` installs each item's dependency closure, including its theme.
[CLI](references/cli.md) owns pin updates and old-schema recovery.

Import the owned `ui/ui.dart` barrel from `lib/main.dart`; nested files need
`package:<app>/ui/ui.dart` or the corresponding relative path. Substitute the
configured `--ui-path`. Also import `package:remix/remix.dart` for base widgets,
stylers or data classes that the owned barrel does not export.

Recipes are `<prefix>ButtonStyle(...)` functions returning a `*Styler`;
`@MixWidget` generates `<Prefix>Button` adapters. Agent `<item>_recipe` items
instead bundle parent and child stylers for an installed domain surface.

## Place the theme scope

Install `<Prefix>Theme` in the host's builder, above its Navigator, so routes
and overlays inherit it. Both presets take `theme`, `darkTheme`, `mode`,
`child`; they do not take `data`, `brightness`, `lightTheme` or `createScope`.
For Fortal config options, see [Fortal](references/fortal.md#scope-and-theme-config).

```dart
import 'package:flutter/widgets.dart';
import 'ui/ui.dart';

Widget app(Widget home) => WidgetsApp(
  color: const Color(0xFFFFFFFF),
  pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
  ),
  builder: (context, child) => FortalTheme(
    theme: const FortalThemeData.light(),
    darkTheme: const FortalThemeData.dark(),
    mode: FortalThemeMode.system,
    child: child!,
  ),
  home: home,
);
```

For Vanilla use `UiTheme(child: child!)` in the same position, with optional
`UiThemeData` and `UiThemeMode`.

- Without a supplied pair, the root uses preset light/dark defaults and system mode.
- Only `theme` supplies both slots; only `darkTheme` retains the inherited or
  default light slot.
- An empty nested scope inherits the pair and selection. An explicit nested
  `mode` selects from that pair.
- The app owns preference/persistence. `.system` follows platform brightness;
  no brightness observer is needed.
- Fortal's root installs fallback text/icon styling (`gray12`, `text3`). A
  nested brightness/gray change recolors that fallback; components use tokens.

## Customize installed source

Use a named preset constructor for a fixed variant, and `variant:` for runtime
selection. Prefer `style:` on a generated widget when that preset is the
baseline; call its styler function on `Remix*` when composition differs. Build
stylers from scratch for a different visual language.

Override one instance with `style:` (merged last), a subtree with a nested theme,
or the whole app by editing owned recipes/theme. State fragments merge by state:
a hover/pressed override must supply that state's fragment; an idle fill cannot
replace it. See [Styling](references/styling.md) for canonical spellings and tokens,
and [Vanilla](references/vanilla.md)/[Fortal](references/fortal.md) for theme rules.

After changing recipe parameters, enums or annotations, run
`dart run build_runner build` and review the generated `.g.dart` diff.

## Provide only the host capabilities in use

Compose inside the existing host; the app owns routing and overlays.

| UI | Caller must provide |
| --- | --- |
| Ordinary widgets | Normal inherited Flutter services for that subtree |
| Generated widgets or recipes | The preset's theme scope plus normal Flutter services |
| Menu, select, popover, tooltip | An `Overlay`; use `Overlay.wrap` when no navigator is needed |
| Text field / text area once focused | An `Overlay` for selection handles; a routed `WidgetsApp` provides one, a builder-only host needs `Overlay.wrap` |
| `showRemixDialog`/`showRemixAlertDialog` | A caller-owned `Navigator` |
| `showRemixToast`/`RemixToast` | One `RemixToastScope` above the app's `Navigator`, inside the same builder, below the theme scope and an `Overlay.wrap` |

The toast scope requires an `Overlay` ancestor. The Navigator's own Overlay
is below the scope, so wrap it explicitly in the host's builder:

```dart
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'ui/ui.dart';

Widget builder(BuildContext context, Widget? child) => FortalTheme(
  child: Overlay.wrap(
    child: RemixToastScope(style: fortalToastStyle(), child: child!),
  ),
);
```

## Preserve behavioral roots

Keep `RemixTabs`, `RemixRadioGroup`, `RemixCheckboxGroup` and
`RemixAccordionGroup` around styled children. There is no `FortalTabs`.
`RemixAccordionGroup.controller` is required; Menu and Tabs have different
controller rules. See [Components](references/components.md#navigation).

## Route to references

| Task | Reference |
| --- | --- |
| Moving registry pins, adopting new source, other registries, old `remix.yaml` files | [CLI](references/cli.md) |
| Behavior rules for a component category and doc links | [Components](references/components.md) |
| Fortal scope/config, typography, and token rules | [Fortal](references/fortal.md) |
| Vanilla tokens, theme values, and per-component rules | [Vanilla](references/vanilla.md) |
| HeroUI recipes, compositions, theme overrides, and what is not included | [HeroUI](references/heroui.md) |
| Fluent styling, state/context variants, animation, callable styles | [Styling](references/styling.md) |
| Reference apps, product examples, variant matrices, and showcase audits | [Reference showcases](references/reference-showcases.md) |
| A reusable design system published as a Remix registry | `building-remix-design-system` |

## Verify the result

Check imports/prefix, theme placement over routes/overlays, required host
capabilities, and regenerated adapters. Run the project's formatter, analyzer
and relevant Flutter tests. For showcases, verify the distinct product and
coverage contracts in [Reference showcases](references/reference-showcases.md).
