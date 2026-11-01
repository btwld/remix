# HeroUI Reference

Rules for the HeroUI preset that are easy to get wrong from a widget's name or
dartdoc alone. The preset reproduces the look of HeroUI web 3.2.6 over Remix
components; behavior and widget parameters are Remix's. For a component's
variants, sizes, and defaults, the installed recipe's enum in
`lib/ui/components/<name>.dart` is authoritative, and this source is yours to
edit. For install commands, scope placement, and theme selection shared with
the other presets, see the [main skill](../SKILL.md).

Sections: [Recipes](#recipes) · [Compositions](#compositions) ·
[Overlays](#overlays) · [Theme](#theme) · [Tokens](#tokens) ·
[Not included](#not-included).

## Recipes

Each component ships a `heroUi<Name>Style(...)` function that returns the Remix
widget's `*Styler`, and a generated `HeroUi<Name>` widget that applies it:

```dart
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'ui/ui.dart';

// Generated widget: Remix's parameters plus HeroUI's variant and size.
Widget generated(VoidCallback save) =>
    HeroUiButton.secondary(label: 'Save', onPressed: save, size: .lg);

// Styler function: a ButtonStyler to extend.
Widget styled(VoidCallback save) => RemixButton(
  label: 'Save',
  onPressed: save,
  style: heroUiButtonStyle(variant: .secondary, size: .lg)
      .onHovered(ButtonStyler().scale(1.02)),
);
```

Recipes resolve `HeroUiTokens`, so a `HeroUiTheme` ancestor is required. Every
`variant` value has a named constructor; HeroUI's `default` becomes
`default<Component>` (`HeroUiCard.defaultCard`), and colour props use the
shared `HeroUiColor` (`defaultColor`, `accent`, `success`, `warning`,
`danger`).

HeroUI's React props map onto Remix rather than being copied:

| HeroUI | Here |
| --- | --- |
| `isPending` | Remix `loading: true` (dims like disabled, as upstream measures) |
| `isInvalid` on a text field | Remix `error: true`; the message goes in `helperText` |
| `isInvalid` on checkbox, select, switch option | the recipe's `invalid: true`; validation stays with the app |
| `isSelected` / `defaultSelected` | Remix's single `selected` value and `onChanged` |
| `isIconOnly` | `HeroUiIconButton` for buttons, `iconOnly` for toggle buttons |

Sizes follow HeroUI's responsive rules (`sm` 640px, `md` 768px), so a button
is taller on phones. A caller override of a responsive value must be an
`onBreakpoint` fragment too, or the breakpoint variant wins.

## Compositions

Where Remix has no widget, the preset composes Remix widgets and Mix
primitives with no behavior of their own: `HeroUiBadge` (a label pinned to its
child), `HeroUiAvatarGroup`, `HeroUiBreadcrumbs`, `HeroUiButtonGroup`,
`HeroUiKbd`, `HeroUiSurface`, `HeroUiTypography`, `HeroUiCardTitle` and
`HeroUiCardDescription`, `HeroUiAccordionGroup` (one surface card around
accordion items), and the field layouts `HeroUiCheckboxGroup`,
`HeroUiRadioGroup`, `HeroUiSwitchGroup`, `HeroUiFieldLayout`, and
`HeroUiControlRow`.

A radio's or switch's label is composed beside the bare Remix control, so it is
not a tap target; checkbox labels are, because `RemixCheckbox` takes a label.
A search field is `HeroUiSearchField` with `HeroUiSearchIcon` as `leading` and
a `HeroUiSearchClearButton` as `trailing`; the app clears its controller and
decides when the button shows.

## Overlays

- Open a popover from a `HeroUiButton` with `openOnTap: false` and a
  `MenuController` driven from the button's `onPressed`.
- `RemixMenu` draws its own trigger button, so a dropdown's trigger is a label,
  not a `HeroUiButton`.
- A modal's backdrop is the route barrier: pass `HeroUiTokens.backdrop`
  resolved from context as the dialog's barrier color.
- Overlays keep the theme through `HeroUiTheme`'s `InheritedTheme.wrap`;
  place the scope in `WidgetsApp.builder`, above the Navigator.

## Theme

`HeroUiTheme(theme:, darkTheme:, mode:)` selects between a light and a dark
`HeroUiThemeData`. HeroUI themes by overriding CSS variables, and so does this:

```dart
import 'package:flutter/widgets.dart';
import 'ui/ui.dart';

final brand = const HeroUiThemeData.light().copyWith(
  colors: {HeroUiTokens.accent: const Color(0xFF8000FF)},
  radius: 10,
);
```

Overriding a colour recomputes the colours HeroUI derives from it (accent's
hover, soft, and focus colours follow); `radius` drives the whole radius
scale. `fontFamily` is null by default, the platform font, as HeroUI uses the
system stack; code text uses Geist Mono from `remix_ui_fonts`.

## Tokens

`HeroUiTokens` keeps HeroUI's role names: `accent`, `defaultColor`,
`surface`, `overlay`, `fieldBackground`, `muted`, `focus`, the status colours
and their `*Foreground`, `*Hover`, and `*Soft` forms; radii `radiusXs` through
`radius4xl`, `radiusField`, `radiusPanel`; text `textXs`, `textSm`, `textBase`;
motion curves `easeSmooth`, `easeOut`, `easeOutQuart`, `easeOutFluid`; and
the transitions `fillMotion`, `smoothMotion`, `selectionMotion`, and
`transformMotion`.
Derive a translucent colour with `heroUiAlpha(token, alpha)` held in a
top-level final, never `token().withValues(...)`.

## Not included

Families that need behavior Remix does not provide are not in the preset:
Form, Fieldset, NumberField, InputOTP, ListBox, ComboBox, Pagination, a
standalone Menu, and the date and color pickers. Each component's worksheet
lists its visual approximations (fonts, shadow softness, motion such as the
sliding tab indicator).
