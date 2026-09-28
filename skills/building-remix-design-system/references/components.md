# Theme and components reference

The shapes a registry's installed source takes, and the Remix and Mix
behaviors that have produced real bugs. The sketches use the authoring word
`Acme` and agree with each other; the official Vanilla preset is the complete
reference
([theme](https://github.com/btwld/remix/tree/registry-stable/registry/vanilla/templates/theme),
[button](https://github.com/btwld/remix/blob/registry-stable/registry/vanilla/templates/button/button.dart.tmpl)).

## Table of Contents

- [Theme item](#1-theme-item)
- [Recipes](#2-recipes)
- [Pitfalls](#3-pitfalls)
- [Worksheet](#4-worksheet)
- [Tests](#5-tests)

## 1. Theme item

Three files, installed together as the `theme` item.

**`tokens.dart` — identities only.** A Mix token names a value; the active
`MixScope` supplies it. Ids use the value word so they render per consumer.

```dart
import 'package:remix/remix.dart';

abstract final class AcmeTokens {
  static const background = ColorToken('acme.color.background');
  static const text = ColorToken('acme.color.text');
  static const interactivePrimary = ColorToken(
    'acme.color.interactive-primary',
  );
  static const onInteractive = ColorToken('acme.color.on-interactive');
  static const hoverSurface = ColorToken('acme.color.hover-surface');
  static const pressedSurface = ColorToken('acme.color.pressed-surface');
  static const focus = ColorToken('acme.color.focus');
  static const radius = RadiusToken('acme.radius');
}
```

**`theme_data.dart` — values per mode.** An immutable class with one field per
token, `const` named constructors per mode, `copyWith`, value equality over
every field, and a `tokens` getter returning an unmodifiable
`Map<MixToken<Object?>, Object>`. Every token needs an entry: a recipe that
resolves a token missing from the active scope throws at runtime. Mix tokens
override `==`, so a `const` map keyed by them does not compile; build it at
runtime.

<!-- dart-excerpt: theme/theme_data.dart in the multi-file layout -->

```dart
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'tokens.dart';

enum AcmeThemeMode { system, light, dark }

@immutable
class AcmeThemeData {
  const AcmeThemeData.light()
    : brightness = Brightness.light,
      background = const Color(0xFFFFFFFF),
      text = const Color(0xFF1C1C1E),
      interactivePrimary = const Color(0xFF0B5FFF),
      onInteractive = const Color(0xFFFFFFFF),
      hoverSurface = const Color(0xFFF2F2F7),
      pressedSurface = const Color(0xFFE5E5EA),
      focus = const Color(0xFF0B5FFF),
      radius = const Radius.circular(4);

  final Brightness brightness;
  final Color background;
  final Color text;
  final Color interactivePrimary;
  final Color onInteractive;
  final Color hoverSurface;
  final Color pressedSurface;
  final Color focus;
  final Radius radius;

  Map<MixToken<Object?>, Object> get tokens =>
      Map<MixToken<Object?>, Object>.unmodifiable(<MixToken<Object?>, Object>{
        AcmeTokens.background: background,
        AcmeTokens.text: text,
        AcmeTokens.interactivePrimary: interactivePrimary,
        AcmeTokens.onInteractive: onInteractive,
        AcmeTokens.hoverSurface: hoverSurface,
        AcmeTokens.pressedSurface: pressedSurface,
        AcmeTokens.focus: focus,
        AcmeTokens.radius: radius,
      });

  // A .dark() constructor, a default constructor, copyWith, and == and
  // hashCode over every field, as in Vanilla's theme_data.dart.
}
```

**`theme_scope.dart` — installation.** Match Vanilla's contract so consumers
set up every Remix design system the same way:

- `AcmeThemeScope({theme, darkTheme, mode, child})`. `mode` selects between
  the pair; `system` reads `MediaQuery.maybePlatformBrightnessOf`, and a scope
  mounted above any `MediaQuery` supplies one with `MediaQuery.fromView`. An
  empty nested scope inherits the parent's pair and selection.
- It installs `AcmeTheme` (an `InheritedTheme`) and
  `MixScope(tokens: selected.tokens, child: child)` together.
- `AcmeTheme.of(context)` throws a `FlutterError` naming the missing scope;
  `AcmeTheme.maybeOf(context)` returns null. Provide both: only `maybeOf` can
  tell "no scope" from "scope chose its default".
- `AcmeTheme.wrap` rebuilds the `MixScope` as well as itself (see §3).
- `updateShouldNotify` compares every carried field; this is why theme data
  needs value equality.
- Consumers place the scope inside `WidgetsApp.builder`, above the Navigator.
  Document that in the README.

Add a token only with its value in every mode; add a mode only if the source
defines it. A single-mode system ships one constructor, and its scope falls
back to that theme for both slots; say in the README that `mode` has no
visible effect.

## 2. Recipes

A component is a top-level recipe function annotated with
`@MixWidget(target: Remix<Component>.new)`. The generator emits
`<Prefix><Component>` into the file's `.g.dart` part: a widget whose
constructor is the recipe's parameters plus the Remix widget's parameters,
and whose `build` calls the Remix widget with the resolved style.

<!-- dart-excerpt: components/button.dart in the multi-file layout -->

```dart
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';

part 'button.g.dart';

enum AcmeButtonVariant { primary, plain }

enum AcmeButtonSize { small, medium, large }

@MixWidget(target: RemixButton.new)
ButtonStyler acmeButtonStyle({
  AcmeButtonVariant variant = .primary,
  AcmeButtonSize size = .medium,
  bool loading = false,
  ButtonStyler style = const ButtonStyler.create(),
}) {
  return _base(_metricsFor(size))
      .merge(_variantStyle(variant))
      .onFocusVisible(_focusRing())
      .onDisabled(loading ? _loading() : _disabled())
      .merge(style);
}

typedef _Metrics = ({
  double minHeight,
  double paddingX,
  double gap,
  double labelSize,
  double iconSize,
});

_Metrics _metricsFor(AcmeButtonSize size) => switch (size) {
  .small => (
    minHeight: 28.0,
    paddingX: 12.0,
    gap: 6.0,
    labelSize: 13.0,
    iconSize: 14.0,
  ),
  .medium => (
    minHeight: 36.0,
    paddingX: 16.0,
    gap: 8.0,
    labelSize: 14.0,
    iconSize: 16.0,
  ),
  .large => (
    minHeight: 44.0,
    paddingX: 20.0,
    gap: 8.0,
    labelSize: 16.0,
    iconSize: 18.0,
  ),
};

ButtonStyler _base(_Metrics metrics) => ButtonStyler()
    .minHeight(metrics.minHeight)
    .padding(.horizontal(metrics.paddingX))
    .spacing(metrics.gap)
    .borderRadius(.all(AcmeTokens.radius()))
    .label(.fontSize(metrics.labelSize).fontWeight(FontWeight.w500))
    .icon(.size(metrics.iconSize))
    .spinner(.size(metrics.iconSize));

ButtonStyler _variantStyle(AcmeButtonVariant variant) => switch (variant) {
  .primary => _content(
    .color(AcmeTokens.interactivePrimary()),
    AcmeTokens.onInteractive(),
  ).onHovered(.color(_primaryHoverFill())).onPressed(
    .color(_primaryPressedFill()),
  ),
  .plain => _content(.color(_noFill), AcmeTokens.text())
      .onHovered(_content(.color(AcmeTokens.hoverSurface()), AcmeTokens.text()))
      .onPressed(
        _content(.color(AcmeTokens.pressedSurface()), AcmeTokens.text()),
      ),
};

/// One foreground for the label, the icons, and the spinner.
ButtonStyler _content(ButtonStyler style, Color foreground) => style
    .label(.color(foreground))
    .icon(.color(foreground))
    .spinner(.color(foreground));

/// Loading keeps the variant's visuals; only the focus ring is cleared.
ButtonStyler _loading() =>
    ButtonStyler().containerEffects(.outline(.style(.none)));

/// Declared last, so it wins over every other state fragment.
ButtonStyler _disabled() => ButtonStyler()
    .containerEffects(.outline(.style(.none)))
    .wrap(.opacity(0.5));

const _noFill = Color(0x00000000);
```

`_focusRing` and the `_primary*Fill` context tokens are in §3.

- **Return the target's own styler type**: `RemixButton` takes a
  `ButtonStyler`, `RemixBadge` a `BadgeStyler`. A styler's methods are in the
  `remix` package source, `lib/src/components/<name>/<name>.g.dart` (find the
  package root in `.dart_tool/package_config.json`); read them there instead
  of guessing.
- **Naming**: `lib/components/<name>.dart` holds `acme<Component>Style` and
  `part '<name>.g.dart'`; the generated widget is `Acme<Component>`. File
  names never contain the authoring word.
- **Variants**: keep the parameter named `variant` so the generator emits
  named constructors, and put the system's vocabulary in the enum:
  `AcmeBadgeTone { neutral, info }` gives `AcmeBadge.info(...)`. Size names
  come from the source; if it has none, record the chosen names in the ADR.
- Merge the caller's `style` **last** so one call site can override anything
  without forking the recipe.
- Style only through tokens: `AcmeTokens.x()` inside styler chains,
  `AcmeTokens.x.resolve(context)` in widget code. A copied value "kept in
  sync" with a token is drift waiting to happen.
- Vanilla does not cache recipe results; add a cache only when profiling
  shows the recipe is a cost.
- Display components (badge, card, callout) need only tokens, variants, and
  geometry; the state pitfalls in §3 apply to interactive components.

The `mix` skill's code-generation reference owns the rest of the `@MixWidget`
contract (`name`, `widgetParameters`, `factoryParameters`, generic targets).
Install it with `npx skills add btwld/mix --skill mix`; without it, read
`mix_widget_generator.dart` in the `mix_generator` package source.

**Hand-written facade instead** only when the public widget needs structure
the Remix widget cannot take, or a generated parameter would expose a
Remix-only type the target system has no word for. A facade is a
`StatelessWidget` in the target vocabulary that builds the recipe and passes
it to the Remix widget's `style`.

**No Remix widget for the component.** In order of preference:

1. Compose existing Remix widgets and Mix primitives (`Box`, `FlexBox`,
   `StyledText`, all re-exported by `remix`) in a facade.
2. Add behavior from Naked UI, declaring `naked_ui` on the item with the
   constraint `remix` uses.
3. Author a `@MixableSpec(target: ...)` spec. The CLI then writes the
   consumer's `build.yaml` to enable that generator; record this in the ADR
   and the README.

## 3. Pitfalls

Each of these has produced a real bug.

**Loading is the disabled state.** `RemixButton` passes
`enabled: enabled && !loading` to its Naked UI button, so `.onDisabled`
styles loading too. If the system's loading button keeps its variant visuals,
declare `bool loading = false` on the recipe and branch the disabled fragment
on it. With `target: RemixButton.new`, a recipe parameter with the same name
and type as a target parameter becomes one widget field passed to both, so
the recipe and `RemixButton` always agree. A different type for the same name
fails generation.

**Focus rings: outline effects, not borders.** `.onFocused(.border(...))`
replaces the variant's border and shifts layout by the border width. Paint the
ring outside the box on keyboard focus only:

<!-- dart-excerpt: continuation of components/button.dart -->

```dart
ButtonStyler _focusRing() => ButtonStyler().containerEffects(
  .outline(
    .color(
      AcmeTokens.focus(),
    ).width(2.0).strokeAlign(BorderSide.strokeAlignInside),
  ).outlineOffset(2.0),
);
```

**Derived colors: `ContextToken`, not `withValues`.**
`AcmeTokens.interactivePrimary().withValues(alpha: 0.9)` records a Mix directive that
survives every later merge, so a caller who replaces the hover fill still gets
the alpha on top. Resolve the arithmetic instead, as top-level finals
(`ContextToken` equality is resolver identity):

<!-- dart-excerpt: continuation of components/button.dart -->

```dart
ContextToken<Color> _dimmed(ColorToken source, double alpha) =>
    ContextToken<Color>(
      (context) => source.resolve(context).withValues(alpha: alpha),
    );

final _primaryHoverFill = _dimmed(AcmeTokens.interactivePrimary, 0.9);
final _primaryPressedFill = _dimmed(AcmeTokens.interactivePrimary, 0.8);
```

**State fragments merge by state.** A caller override that must beat the
recipe's hover fill must itself be an `.onHovered(...)` fragment. Declare
`.onDisabled` last so it wins over every other state.

**Set foreground with fill in every state.** When hover or press changes the
fill, set label, icon, and spinner colors in the same fragment. Touch devices
never report hover, so a press fragment that changes only the fill paints the
pressed surface under the rest foreground.

**Icon placement is style-driven.** `ButtonStyler().iconAlignment(RemixPlacement.end)`
moves a single icon, whichever slot the caller used; with both icons, Remix
keeps leading → label → trailing. Test both if the system specifies placement.

**`RemixButton` prepends `.mainAxisSize(.min)`.** Alignment only matters when
the parent forces a width; set it for that case and leave the min default.

**`InheritedTheme.wrap` must rebuild the `MixScope`.** Routes and overlays
capture `InheritedTheme`s only. A `wrap` that rebuilds just the theme keeps
theme values but loses the token values every recipe resolves.

**Widgets layer only.** Recipes and tests use `WidgetsApp`, never Material;
consumers may not have a Material ancestor.

## 4. Worksheet

Write `specs/components/<component>.yaml` before code. It is the review
artifact: the code is checked against it, and it is checked against the
source. When reviewing a component that has no worksheet, report that as a
finding. Values that came only from a user's request cite the committed brief
(`docs/brief.md`), like any other designed value.

```yaml
component: Button                 # source system's name
widget: AcmeButton                # installed as <Prefix>Button
status: planned | implemented | complete
source:
  ref: <pinned commit, doc version, or brief section>
  pages: [<component page, frames, style files>]
anatomy: [container, label, leading icon, trailing icon, spinner]
variants: [primary, secondary, ghost]   # target system's names
sizes: {supported: [small, medium, large], default: medium}
states: [rest, hover, pressed, focus-visible, disabled, loading]
tokens: [interactive-primary, text-on-interactive, focus, radius]
measurements:                     # non-token values, each with a source
  - {what: medium height, value: 36, cite: "button spec p.3"}
behavior: <keyboard, focus, screen reader, RTL notes>
approximations: <every deviation from the source>
```

## 5. Tests

In the authoring package, pumping a `WidgetsApp` whose `builder` installs
`AcmeThemeScope`, the placement the README documents:

- every variant × size builds in every theme mode;
- measured default geometry (`tester.getSize(...)`), with and without an
  explicit size;
- focus ring appears on keyboard focus and does not change the widget's size;
- disabled and loading visuals match the worksheet;
- `AcmeTheme.of` throws without a scope and `maybeOf` returns null;
- the token test against `specs/tokens.yaml` (`references/tokens.md` §4).

A spinner animates forever, so `pumpAndSettle` never returns in loading tests;
use `tester.pump(const Duration(milliseconds: 100))`. Assert token-derived
expected values documented with their token name, so a value change fails
with a reviewable diff.
