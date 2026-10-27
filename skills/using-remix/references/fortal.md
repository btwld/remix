# Fortal Reference

Rules for the Fortal preset that are easy to get wrong from a widget's name
or dartdoc alone. For component variants, sizes, and defaults, the installed
recipe's enum in `lib/ui/components/<name>.dart` is authoritative — this
source is owned and may be edited. The
[generated catalog](https://github.com/btwld/remix/blob/main/docs/fortal/catalog.mdx)
describes the unedited upstream family. For install commands, scope
placement, and theme selection shared with the Vanilla preset, see the
[main skill](../SKILL.md).

Sections: [Presets and recipes](#presets-and-recipes) ·
[Typography](#typography) · [Scope and theme config](#scope-and-theme-config) ·
[Token rules](#token-rules) · [Select](#select) ·
[Focus rings](#focus-rings).

## Presets and recipes

Each component ships a `fortal<Name>Style(...)` function that returns the
component's `*Styler`, plus a `Fortal<Name>` generated widget that applies
it:

```dart
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'ui/ui.dart';

// Generated widget — Remix widget params + fixed variant/size
Widget generated(VoidCallback save) =>
    FortalButton.soft(label: 'Save', onPressed: save, size: .size3);

// Styler function — returns a ButtonStyler to extend
Widget styled(VoidCallback save) => RemixButton(
  label: 'Save',
  onPressed: save,
  style: fortalButtonStyle(variant: .soft, size: .size3)
      .onHovered(ButtonStyler().scale(1.02)),
);
```

Fortal preset styles resolve `FortalTokens`, so a `FortalTheme` ancestor is
required. Every variant has a matching named constructor; reserve the
unnamed constructor's `variant:` parameter for runtime-selected values.
Generic presets infer their type from required values and item lists, so
`FortalRadio.soft(value: 'option')` does not need an explicit `<String>`.
`add chart` additionally installs the chart recipe's own `mix_chart`
dependency; import `mix_chart` directly for its data models, since the owned
barrel does not re-export it.

Components that expose `highContrast` use it to strengthen their active or
foreground treatment — do not assume the option exists on every family; check
the catalog. Soft badges pair `accentA3`/`accentA11` (Radix low-contrast
text), which is not WCAG AA 4.5:1 in light mode for every accent when
composited over `colorPanelSolid`; pass `highContrast: true` for AA.

## Typography

`FortalText`, `FortalHeading`, `FortalCode`, and `FortalKbd` exist only in
Fortal — base Remix ships no equivalent. `FortalLink` is Fortal's themed
wrapper over `RemixLink`, which is base Remix (the Vanilla preset also ships
a `link` item generating `<Prefix>Link`). All five typography widgets share
one `FortalTextSize` (`size1`–`size9`). `FortalTextWeight` (`light`,
`regular`, `medium`, `bold`) is shared by `FortalText`, `FortalHeading`,
`FortalCode`, and `FortalLink` only — `FortalKbd` pins its own weight and
takes no `weight` parameter.

Rules that matter when writing code:

- Omitting `size` pins the `text3` token metrics. `FortalText` also pins
  regular weight and neutral `gray-12`; `FortalHeading` pins neutral
  `gray-12` and defaults to `size6`/`bold`. Fortal typography never derives
  its token run from the ambient `DefaultTextStyle` — this deliberately
  differs from Radix CSS, where an unsized `Text` is `1em`. Transparent,
  non-accent `FortalCode.ghost` is the deliberate exception and retains only
  the ambient foreground, so it can blend into surrounding text.
- `headingLevel` drives accessibility only; it never changes the visual
  `size`. Page titles are level 1, sections and cards below them level 2.
- Colour is opt-in: `accent: true` gives `accent-a11`, and adding
  `highContrast: true` promotes it to `accent-12`. `highContrast` alone does
  nothing.
- `truncate: true` wins over `softWrap` and forces one ellipsized line.
- A `FortalLink` **without** `onPressed` is disabled, exactly like one with
  `enabled: false`: no focus stop, no link role, no activation. Only an
  actionable link underlines. It activates on pointer and **Enter**, not
  Space; use `FortalButton` when Space should activate. `linkUrl` is
  assistive metadata and is never launched — navigation belongs in
  `onPressed`, and passing `linkUrl` without `onPressed` asserts.

## Scope and theme config

`FortalTheme` takes `theme`, `darkTheme`, `mode`, `accent`, `gray`,
`panelBackground`, `radius`, `scaling`, `hasBackground`, `orderOfModifiers`,
and `child` — see [theme selection](../SKILL.md#place-the-theme-scope) for
the shared `theme`/`darkTheme`/`mode` rules. `FortalThemeConfig` is the
immutable config object form (`FortalThemeData extends FortalThemeConfig`):

```dart
import 'package:flutter/widgets.dart';
import 'ui/ui.dart';

const brand = FortalThemeConfig(accent: .green, gray: .sage);

Widget branded(FortalThemeMode mode, Widget child) =>
    FortalTheme(theme: brand, darkTheme: brand, mode: mode, child: child);
```

Leave `brightness` unset on `brand` itself: the scope fills it per slot,
light for `theme` and dark for `darkTheme`, so the same config object works
in both places without forcing one brightness onto the other.

`panelBackground` selects solid or translucent floating surfaces; `radius`
selects `none|small|medium|large|full`; `scaling` selects 90–110%; and
`hasBackground` controls whether the scope paints the resolved page
background behind its child.

## Token rules

Full token catalog lives in the installed `ui/theme/tokens.dart` — these are
the rules that are not obvious from a token's name:

- `radiusFull` resolves to **zero** unless the active theme's `radius` is
  `.full`; it is not a fixed pill radius. Use `radiusCircle` instead for a
  shape that must stay circular regardless of the theme's radius setting.
- `colorPanel` follows `panelBackground`: it resolves to `colorPanelSolid`
  when `panelBackground == .solid`, otherwise to `colorPanelTranslucent`.
- `colorBackground` and `colorPanelSolid` are **white** in light mode, not a
  gray step — they only resolve to `gray1`/`gray2` in dark mode.
- Component sizing frequently reuses space tokens rather than fixed
  literals and does not always step evenly — e.g. `FortalProgress` heights
  are `space1`/`progressHeight2`/`space2` (4/6/8px) × the theme's `scaling`,
  not an evenly-stepped 4/8/12.
- `blackA1`–`blackA12` and `whiteA1`–`whiteA12` (alpha scales), `colorPanel`,
  `radiusCircle`, and `focusA5` all exist alongside the documented accent,
  gray, space, radius, text, shadow, border, and animation token families.

See [Styling](styling.md#styling-with-installed-tokens) for the token
call-form mechanics (`.mix()`, `.resolve(context)`).

## Select

`FortalSelect`'s panel is at least as wide as its trigger, as in Radix
(`min-width: var(--radix-select-trigger-width)`), through
`SelectContentStyler().minWidth(remixAnchorWidth())`. A longer option still
widens it. A `style:` that gives the content a `maxWidth` below the trigger's
width must also set `minWidth`, which replaces the minimum, because a minimum
above a maximum is invalid:

```dart
import 'package:remix/remix.dart';

final narrowPanel = SelectStyler().content(
  SelectContentStyler().maxWidth(160).minWidth(0),
);
```

## Focus rings

Fortal focus rings are outlines painted over the control through box effects
(`containerEffects`, or `triggerEffects` on an accordion or disclosure), so
focusing a control never changes its size. They draw at the `focusRingWidth`
token (2), in `focus-8` or, for Radix's soft variants, the accent.

- Classic and solid buttons and icon buttons, checkboxes, radios, switches, and
  links draw outward, at the `focusRingOffset` token (2).
- Inset rings keep Radix's literal offset: `-1` for fields, cards, selects,
  segmented control items, and the soft, surface, outline, and ghost buttons
  and icon buttons, and `-2` for tabs.
- Toggles, toggle-group items, accordion and disclosure triggers, and sidebar
  destinations have no Radix counterpart. They borrow the tab ring, `focus-8` at
  `-2`, which lies inside the box at the default width, so the clip of a toggle
  group or a panel does not crop it. A sidebar destination rings the same way
  expanded, collapsed, and at the edge of a scrolling sidebar.
- A sortable data-table header rings in `focus-8` inside its own cell, like a
  tab. Radix has no sortable header; this is a Fortal extension, since a
  focusable header needs a visible focus indicator. The ring replaces the
  divider on the cell's bottom edge while focused, and a stateful custom header
  keeps its state across focus. A focusable control nested in the header keeps
  the ring lit while it holds focus. At `focusRingWidth: 0` nothing is drawn.
