# Fortal Reference

Rules for the Fortal preset that are easy to get wrong from a widget's name
or dartdoc alone. For component variants, sizes, and defaults, the installed
recipe's enum in `lib/ui/components/<name>.dart` is authoritative — this
source is owned and may be edited. The
[generated catalog](https://github.com/btwld/remix/blob/main/docs/fortal/catalog.mdx)
describes the owned Fortal families. For install commands, scope
placement, and theme selection shared with the Vanilla preset, see the
[main skill](../SKILL.md).

Sections: [Presets and recipes](#presets-and-recipes) ·
[Typography](#typography) · [Scope and theme config](#scope-and-theme-config) ·
[Token rules](#token-rules) · [Palettes and review](#palettes-and-review) ·
[Focus rings](#focus-rings).

## Presets and recipes

Each recipe is `fortal<Name>Style(...)` returning a `*Styler`, with a generated
`Fortal<Name>` adapter. Prefer named constructors for fixed variants:

```dart
import 'package:flutter/widgets.dart';
import 'ui/ui.dart';

Widget saveButton(VoidCallback save) =>
    FortalButton.soft(label: 'Save', onPressed: save, size: .size3);
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
the catalog. Soft badges pair `accentA3`/`accentContentAlpha`; all seven built-in
palettes pass 4.5:1 over the page and solid panel in both modes.
`highContrast: true` strengthens the foreground to step 12.

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
  its token run from the ambient `DefaultTextStyle`. Transparent,
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

`FortalTheme` takes `theme`, `darkTheme`, `mode`, `accent`,
`accentPalette`, `panelBackground`, `radius`, `scaling`, `hasBackground`, `orderOfModifiers`,
and `child` — see [theme selection](../SKILL.md#place-the-theme-scope) for
the shared `theme`/`darkTheme`/`mode` rules. `FortalThemeConfig` is the
immutable config object form (`FortalThemeData extends FortalThemeConfig`):

Use one `const FortalThemeConfig(accent: .mar)` in both
`theme` and `darkTheme` when the config should follow either brightness.

Leave `brightness` unset on `brand` itself: the scope fills it per slot,
light for `theme` and dark for `darkTheme`, so the same config object works
in both places without forcing one brightness onto the other.

`panelBackground` defaults to solid (zero blur); translucent is opt-in; `radius`
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
- `colorBackground` and `colorPanelSolid` use the selected theme’s paired `gray1`/`gray2` in
  both modes. Error tokens use the dedicated error red (`<prefix>Error` in
  `ui/theme/fortal_colors.dart`) regardless of the active accent or a custom
  palette; it is not a selectable accent, and Caju is an orange-red accent.
- Component sizing frequently reuses space tokens rather than fixed
  literals and does not always step evenly — e.g. `FortalProgress` heights
  are `space1`/`progressHeight2`/`space2` (4/6/8px) × the theme's `scaling`,
  not an evenly-stepped 4/8/12.
- `blackA1`–`blackA12` and `whiteA1`–`whiteA12` (alpha scales), `colorPanel`,
  `radiusCircle`, and `focusA5` all exist alongside the documented accent,
  gray, space, radius, text, shadow, border, and animation token families.

See [Styling](styling.md#styling-with-installed-tokens) for the token
call-form mechanics (`.mix()`, `.resolve(context)`).

## Palettes and review

The accents are `orla`, `mar`, `ceu`, `serra`, `sol`, `duna`, and `caju`.
For destructive or negative content, scope the error palette with
`accentPalette:` instead of choosing Caju, and keep a text label or icon.
The default is `orla`. Each theme pairs a pinned Radix accent and neutral:
Orla Gray/Gray, Mar Teal/Sage, Céu Blue/Slate, Serra Gold/Olive, Sol Amber/Sand,
Duna Brown/Sand, Caju Orange/Sand. There is no `gray:` configuration or gray
selector. Custom `accentPalette:` source remains supported and inherits the
named theme's neutral pairing. The imported raw scales remain exact; functional
content, mark, label and focus roles enforce Fortal's contrast requirements.

The twelve flat-control families expose no `classic` constructor. Kbd defaults
to `soft`; segmented control has only `surface`. Toast's independent `classic`
variant remains a floating notification surface. Cards and controls have no
elevation, surface fields use gray2 with the 3:1 `controlBorder` frame (select
triggers keep gray7). Most focus rings use the fitted `focus8` role at 2px
with a 2px gap; sliders use contiguous accent11 rings. Labelled fills
(solid buttons, badges, avatars, menu highlights) read `accentSolid` and
`accentSolidHover` with `accentContrast`. `accentIndicator`/`accentTrack` are the mark
fill of selected controls and progress, and checks read
`accentIndicatorContrast`; pair a custom fill with the matching role. Most
palettes carry white labels in both modes; Sol keeps warm-brown labels. Orla uses
Gray-12 primary fills in light mode and true white in dark mode, with opposite
ink. Its soft variants and neutral surfaces stay subtle. `accentMarkHover` pairs
selected marks/tracks with their hover or pressed fill; mark ink follows both. Normal selected surface-switch thumbs and enabled slider thumbs are
white with an `accentThumbRing` outline (slider edges use gray3 in dark); off switch
thumbs are white with a `controlBorder` ring. Progress tracks are edged in
`controlBorder`. Selected soft thumbs keep accentContent (accent12 at
high contrast), selected high-contrast surface thumbs keep accent1, and
disabled thumbs keep gray2 with a gray6 border.
The type ramp is 12/14/16/18/20/24/28/36/60.

Generate custom brand source from a checkout with
`registry_source/tool/fortal_palettes/generate.dart --name brand --seed '#8038CC'
--type-prefix Acme --output /path/to/app/lib/ui/theme/brand_colors.dart`.
Match the app prefix, import that file, and pass `accentPalette: brand`.
A named `accent` in a nested scope clears the inherited custom palette.

The independent contract is `registry_source/specs/fortal.md` and its catalog;
`tool/check_fortal.dart` verifies APIs and test ownership. Use the
`apps/demo/lib/polish_main.dart` playground to review every size/variant in
both modes on a 4px grid, with palette and interaction-state selectors.

## Focus rings

Fortal uses one shared outline from `focus8`, `focusRingWidth`, and
`focusRingOffset` (2px wide, 2px outside by default). Effects-capable controls
paint it through `containerEffects`, accordion/disclosure use `triggerEffects`,
switches use `trackEffects`. Sliders use `thumbFocusEffects` with accent11
and a zero gap so neighbouring handles keep contiguous rings. Rings take
no layout space. Disabled controls do not ring.

Select panels use `minWidth(remixAnchorWidth())`; a smaller `maxWidth` override
must also replace that minimum.

## Slider intervals

Install `range_slider` for `<Prefix>RangeSlider` and its shared `slider`
dependency. Both recipes expose `size` (size1–size3), `variant` (surface/soft),
and `highContrast`; caller style merges last. Independent thumbs have hover,
press and contiguous keyboard-focus rings. Normal scaling reserves 48px.
Give `semanticLabels` distinct localized names. Custom value formatters use
`RemixRangeSlider` with `<prefix>RangeSliderStyle()`.
See [Slider](https://github.com/btwld/remix/blob/main/docs/components/slider.mdx).
