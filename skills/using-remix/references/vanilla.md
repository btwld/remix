# Vanilla Reference

Rules for the Vanilla preset that are easy to get wrong from a widget's name
alone. Vanilla is the `remix_cli` default: a neutral, minimal theme inspired
by shadcn/ui, editable the same way as Fortal. For
install commands, scope placement, and the preset chooser, see the
[main skill](../SKILL.md).

## Tokens

`<Prefix>Tokens` follows shadcn/ui's theme variable names (`card-foreground`
is `cardForeground`), so values from those themes carry over:

- `background`, `foreground`, `card`, `cardForeground`, `popover`,
  `popoverForeground`
- `primary`, `primaryForeground`, `secondary`, `secondaryForeground`
- `muted`, `mutedForeground`, `accent`, `accentForeground`
- `destructive`, `destructiveForeground`
- `border`, `input`, `ring`
- `chart1`–`chart5`
- `sidebar`, `sidebarForeground`, `sidebarPrimary`,
  `sidebarPrimaryForeground`, `sidebarAccent`, `sidebarAccentForeground`,
  `sidebarBorder`, `sidebarRing`
- radius steps: `radiusSm`, `radiusMd`, `radiusLg`, `radiusXl`
- text steps: `textXs`, `textSm`, `textBase`, `textLg`, `textXl`, `text2xl`,
  `text3xl`, and `textMono`

The lists `colors`, `radii`, `textStyles`, and `chart` enumerate them.

`<Prefix>ThemeData` stores one `radius` (10); the four radius steps derive
from it (6, 8, 10, 14), so `copyWith(radius: ...)` rounds everything. Controls
use `radiusMd`, dialogs and callouts `radiusLg`, cards `radiusXl`, menu rows
`radiusSm`. The text steps carry the family, size, and line height only; set
weight and color in the recipe. `fontFamily` and `monoFontFamily` default to
Geist and Geist Mono from `remix_ui_fonts`, which `theme` adds to your
`dependencies`; set either to null to leave the family to the platform.

`accent` is the interaction surface for otherwise transparent controls (the
hovered ghost button, the highlighted menu row, the toggle that is on), not a
brand hue. In the shipped themes it is the same gray as `muted`. Set a brand
color with `copyWith(primary: ...)`, and give it to `ring` too if focus rings
should follow.

`mutedForeground` clears 4.5:1 on `muted` as well as on `background` (the
light theme sets it at `#707070` for this), so muted text may sit on a muted
surface.

The dark theme's `destructive` is a light red: it reads as text on the page
but cannot carry white text as a solid fill, so recipes paint dark
destructive fills at 60%.

## Scales and helpers

`theme/scale.dart` holds the fixed scales as constants: `<Prefix>Space`
(a 4px grid, `s0_5` through `s16`), `<Prefix>Size` (control heights
32/36/40, icon sizes, a few panel widths, `pill`), `<Prefix>Stroke`,
`<Prefix>Opacity.disabled`, and `<Prefix>Motion.standard` (150ms,
`Curves.fastOutSlowIn`). Spacing is deliberately not a token.

`theme/effects.dart` holds the shared helpers:

- `<prefix>Tint(token, alpha, {dark})`: a token at a fraction of its own
  opacity. Use it instead of
  `Tokens.x().withValues(...)`, which records a directive that survives
  later merges.
- `<prefix>ByBrightness(light:, dark:)`: one token in the light theme and
  another in the dark.
- `<Prefix>Shadow.xs` to `.lg`: the shadow scale, as `.box` for a
  styler's `shadows` or `.effects` for a `containerEffects` layer.
- `<prefix>FocusRing()`, `<prefix>FocusRingDecoration()`, and
  `<prefix>FocusBorder()`: the 3px `ring` band at half strength, and a
  bordered control's outline turned `ring`.

## Scope

The outermost `<Prefix>ThemeScope` paints the theme's `background` and gives
bare `Text` the body run (`textSm` in `foreground`) and bare `Icon`s the
`foreground` color. Place it inside the host's `builder`, below `MaterialApp`
or `WidgetsApp`, so the host's own text defaults do not sit between the two. A
nested scope re-scopes tokens; if its theme has a different `foreground` (a
region shown in the other brightness), it also recolors text and icons below
it, but it never paints a background.

## Theme values

`<Prefix>ThemeData.light()`/`.dark()` are the named constructors;
`copyWith(...)` derives a changed theme. Read the active theme with
`<Prefix>Theme.of(context)` or `<Prefix>Theme.maybeOf(context)`.

## Components

The installed recipe's enums in `lib/ui/components/<name>.dart` are
authoritative for a component's variants and sizes; do not assume Fortal's
families carry over.

- **Button** — `<Prefix>ButtonVariant { primary, secondary, outline, ghost,
  destructive }`; `<Prefix>ButtonSize { small, medium, large }` (32/36/40px).
  Every size sets its label in `textSm`. There is no pressed step: a press
  lands on the hover fill.
- **Toggle** — on is `accent` with `accentForeground`; a ghost toggle hovers
  onto `muted` with `mutedForeground`. There is no selected border.
- **Tabs** — compose `RemixTabs` (the behavioral root) with `<Prefix>TabBar`,
  `<Prefix>Tab`, and `<Prefix>TabView`. `<Prefix>TabsVariant { filled, line }`:
  `filled` (the default) is a recessed pill list, `line` an underline.
  Pass the same variant to the bar and to each tab.
- **Toast** — style lives on the scope:
  `RemixToastScope(style: uiToastStyle(), child: ...)`. A per-toast
  `RemixToastData.style` (for example `uiToastStyle(variant: .destructive)`)
  merges over it. `<Prefix>ToastVariant { neutral, destructive }`.
- **Chart** — the palette is a gray ramp. Pie labels are off by
  default; when you turn them on, color each slice's label with
  `<prefix>PieSliceLabelColor(context, sliceColor)`.

## Styling with tokens

```dart
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'ui/ui.dart';

final primaryButton = ButtonStyler()
    .color(UiTokens.primary())
    .label(
      TextStyler()
          .style(UiTokens.textSm.mix())
          .color(UiTokens.primaryForeground()),
    );

Widget background(BuildContext context) =>
    Container(color: UiTokens.background.resolve(context));
```

Call a color or radius token inside a styler chain, `.mix()` on a text token
for `TextStyler.style`, and `.resolve(context)` for a direct value in widget
code. See [Styling](styling.md) for general token and `Prop` mechanics.

## Updating an older install

A theme installed before the current token set names `focusRing` and a single
`radius` token. After `remix add theme --overwrite`, rename `focusRing` to
`ring` in your own code, and replace `Tokens.radius` with a step (`radiusMd`
for controls). Reinstall the component items with `--overwrite` to pick up
the new recipes, and check `--diff` first on any you have edited.
