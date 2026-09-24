# Fortal Reference

Rules for the Fortal preset that are easy to get wrong from a widget's name
or dartdoc alone. For component variants, sizes, and defaults, use the
[generated catalog](https://github.com/conceptadev/remix/blob/main/docs/fortal/catalog.mdx) —
do not hand-copy a variant/size table here; it drifts. For install commands,
scope placement, and theme selection shared with the Vanilla preset, see the
[main skill](../SKILL.md).

## Choose Fortal or base Remix / Vanilla

Use Fortal when the UI should follow its ready-made Radix Themes-inspired
visual system. Use base Remix or the Vanilla preset when the user wants a
distinct visual language, does not want Fortal's token scales, or needs a
fully custom `*Styler`. Fortal is optional and never required for ordinary
`Remix*` widgets.

## Install

```bash
flutter pub add dev:remix_cli
dart run remix_cli:remix init --preset fortal
dart run remix_cli:remix add button
```

```dart
import 'ui/ui.dart';
```

The owned barrel does not re-export `remix`; import `package:remix/remix.dart`
too when a file also uses base `Remix*` widgets or `*Styler` types. `add
chart` installs the chart recipe and its `mix_chart` dependency — import
`mix_chart` directly for its data models, since the owned barrel does not
re-export it either.

## Presets and recipes

Each component ships a `fortal<Name>Style(...)` function that returns the
component's `*Styler`, plus a `Fortal<Name>` preset widget that applies it:

```dart
// Preset widget — Remix widget params + fixed variant/size
FortalButton.soft(label: 'Save', onPressed: save, size: .size3)

// Styler function — returns a ButtonStyler to extend
RemixButton(
  label: 'Save',
  onPressed: save,
  style: fortalButtonStyle(variant: .soft, size: .size3)
      .onHovered(ButtonStyler().scale(1.02)),
)
```

Fortal preset styles resolve `FortalTokens`, so a `FortalScope` ancestor is
required. Every variant has a matching named constructor; reserve the
unnamed constructor's `variant:` parameter for runtime-selected values.
Generic presets infer their type from required values and item lists, so
`FortalRadio.soft(value: 'option')` does not need an explicit `<String>`.

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
one `FortalTextSize` (`size1`–`size9`) and one `FortalTextWeight` (`light`,
`regular`, `medium`, `bold`).

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

`FortalScope` takes `theme`, `darkTheme`, `mode`, `accent`, `gray`,
`panelBackground`, `radius`, `scaling`, `hasBackground`, `orderOfModifiers`,
and `child` — see [theme selection](../SKILL.md#place-the-theme-scope) for
the shared `theme`/`darkTheme`/`mode` rules. `FortalThemeConfig` is the
immutable config object form (`FortalThemeData extends FortalThemeConfig`):

```dart
const theme = FortalThemeConfig(accent: .green, gray: .sage, brightness: .dark);
final light = theme.copyWith(brightness: .light);
FortalScope(theme: theme, child: child)
```

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

Call the token inside styler chains; use `.mix()` for text-style tokens and
`.resolve(context)` for a direct value in widget code — see
[Styling](styling.md).
