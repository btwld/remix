## Unreleased

- **Breaking:** replace Mangue with Serra, a new earthy olive (`#6F7845`).
  `FortalAccentColor.mangue` and the `mangue` palette constant are removed
  without an alias; use `.serra` and `serra`.
- **Breaking:** error roles (`error3`–`error12`, `errorA7`) read a dedicated red,
  `fortalError` (`#C92E3B`, installed as `<prefix>Error`), instead of Caju. It is
  not a selectable accent. Destructive content that used `accent: .caju` for red
  should use `accentPalette: fortalError`. Its dark solid is a deeper red so it
  stays apart from Caju (dark mark at OKLCH lightness 0.61, labelled solid at
  0.53 in both modes). The dashboard recipe's negative statuses, deltas, and
  destructive actions use it via `FortalAccentScope.error`; positive statuses
  use Serra, and every status keeps its text label.
- **Breaking:** the public dashboard recipe fields `FortalAccentScope.accent`
  and `FortalStatusBadge.accent` change from `FortalAccentColor` to
  `FortalAccentColor?` (installed as `<prefix>AccentScope.accent` and
  `<prefix>StatusBadge.accent`). A null value represents the dedicated error
  palette: `FortalAccentScope.error` sets it, as do refunded and suspended
  badges. Consumers reading either field must accept the nullable type and
  handle null explicitly. When forwarding an accent to another scope, use
  `FortalAccentScope.error(child: child)` for null and
  `FortalAccentScope(accent: accent, child: child)` for a promoted non-null
  value. Use `accentPalette: fortalError` when forwarding null to `FortalTheme`;
  passing only `accent: null` inherits the parent accent instead. Installed
  source uses the corresponding prefixed types and `<prefix>Error` palette.
- **Breaking:** the exported `FortalThemeColors` constructor (installed as
  `<prefix>ThemeColors`) requires two new arguments, `controlBorder` and
  `accentThumbRing`. Code that constructs it directly must supply both, or
  obtain the colors from `resolveFortalTokens(config)` (`resolve<prefix>Tokens`).
  Configuring and injecting themes through `FortalTheme` is unchanged. Refresh the complete `theme` item together with
  the updated `base_button`, `checkbox`, `radio`, `slider`, `switch` and
  `textfield` recipes, which read the new tokens.
- Caju becomes a cashew-fruit orange-red (`#E76A32`) and Céu a sky blue
  (`#1A95D8`).
- **Breaking (role semantics):** labelled solids and marks are separate
  roles.
  - Buttons, icon buttons, solid badges, avatars, solid code and highlighted
    menu/select items read the new `accentSolid`/`accentSolidHover` tokens,
    paired with `accentContrast`.
  - `accent9`/`accent10` are now the mark fill and its pressed step (selected
    checkbox/radio, switch track, slider and progress range, dots, chart
    series).
  - Checks and radio dots read the new `accentIndicatorContrast`, derived from
    the indicator instead of the label.
  - `FortalColor` (installed `<Prefix>Color`) accepts optional named `solid`
    and `solidHover`. Omitted, they are steps 9 and 10, so existing
    five-argument palettes compile and keep their labels on those steps. A
    `solid` without `solidHover` is also its own hover.
  - Migration: code that paints `accent9` behind `accentContrast` text should
    use `accentSolid`, and `accent10` should become `accentSolidHover`.
    Hand-authored palettes that set a deeper label fill supply both `solid`
    and `solidHover`. Refresh the complete `theme` item with the `avatar`,
    `badge`, `base_button`, `checkbox`, `code`, `menu`, `progress`, `radio`,
    `select` and `slider` recipes (and the dashboard recipe, if installed).
    Custom palettes regenerate with the split.
- Non-luminous palettes carry white labels in both modes.
  - Light Céu and Caju labelled solids deepen just enough
    (`#007BB7`, `#C84E09`), while their marks keep the seed.
  - Dark solids are no longer lifted to OKLCH 0.70–0.84: dark marks start from
    the seed's lightness within 0.58–0.72 and deepen only for white marks and
    the page.
  - Luminous palettes (Sol, Duna, near-white seeds) keep their bright fill for
    labels and marks with a warm-brown or deep-neutral ink (`#764B00`,
    `#694624`, `#704D2B`).
  - The error red's labelled solid is `#C22535` in both modes.
- Secondary surfaces show their hue: chromatic tints carry at least 0.09
  chroma, so Mar, Serra and Duna soft, surface and toggle fills are no longer
  near-gray. Step 11 is the lightest same-hue tone that keeps 4.6:1 on the
  pressed soft tint over the panel, so soft, surface, outline and ghost labels
  read lighter. Calçadão and the page and panel surfaces are unchanged.
- Normal selected surface-switch thumbs and enabled slider thumbs are light
  surfaces instead of ink discs: white with a 2px `accentThumbRing` outline.
  - The outline is the track colour where white stands out on the track and
    the track keeps 3:1 on the page and panels.
  - It is `controlBorder` where the track does not.
  - It is a dark ink on bright tracks (warm brown on Sol and Duna).
  - `computeAccentThumbRing(accent, controlBorder)` keeps its two-argument
    form and gains an optional `surfaces` list; without it, the result stays
    `controlBorder` wherever white fits the track.

  Off switch thumbs stay white with a neutral ring. Selected soft thumbs keep
  step 11/12, explicit high-contrast surface thumbs keep step 1, and disabled
  thumbs keep gray 2 with a gray-6 border.
- Progress bars show their value without text.
  - Both tracks gain a 1px inset `controlBorder` edge, so the total extent
    keeps 3:1 at value 0.
  - The surface fill gains a 1px inset `accentThumbRing` outline: seamless on
    fills that already contrast, warm brown on Sol and Duna.
  - The soft fill is step 8 without an accent-alpha overlay, which could be
    opaque and replace it. The soft slider range is likewise step 6 alone.
- Add `controlBorder`, a neutral boundary at 3:1 or more against the page,
  panels and off track, for unchecked checkbox/radio outlines (formerly gray
  alpha 7, about 2.1:1), the off switch track and thumb, and surface text
  field/area borders (formerly gray 7). Error fields frame with error step 8
  (formerly error alpha 7). Soft empty checkboxes and radios, and soft text
  fields and text areas (whose tint alone is about 1.2:1 when blank), gain an
  `accentA8` ring. Disabled controls keep their quieter strokes; disabled
  switches no longer show the active track edge. Select triggers are
  unchanged.
- Solid button press keeps its label readable: the pressed fill now moves away
  from the label (lighter under a deep ink) instead of always darkening in
  light mode, which put light Céu and Caju labels near 4.2:1. Solid and
  high-contrast hover/press recolor the fill instead of filtering the whole
  button, so the focus ring keeps its 3:1 contrast while a key or pointer is
  held, and caller label colours are no longer filtered.
- Sol's dark fill is gold (`#F3C442`, formerly mustard `#C49800`) and Duna
  keeps its sand seed in dark mode.
- The palette tool rejects custom names that reuse built-in identifiers and no
  longer infers the neutral palette from a custom name.
- Correct selected switch thumbs in both modes: normal surface thumbs are white
  with an `accentThumbRing`, explicit high-contrast surface thumbs use step 1,
  and soft thumbs use step 11/12. Idle thumb overrides remain supported; use
  `style.onSelected(...)` or `style.onDisabled(...)` to override those states,
  just as state-specific track colors require state overrides.
- Improve enabled surface input hints with secondary gray text and enabled soft
  input hints/icons with secondary accent content. Enabled base-level icon
  overrides remain supported; use explicit disabled-state overrides for that state.
  Disabled, focus, and error roles retain their existing precedence.
- Document seed-led near-white fill visibility limits and test a high-contrast
  custom-palette treatment without changing the palette algorithm.

- Refresh Fortal as an independent, Fortaleza-inspired design system: seven
  generated OKLCH palettes, neutral Calçadão defaults, a dedicated error red, and tested
  contrast in both modes. Apps can generate a custom palette from one seed.
- Remove the twelve classic control/card/inline variants, default panels to
  solid, flatten cards and controls, fill surface fields, share a token-based
  focus ring, and align spacing, touch targets, and the 36px type step.
- Replace the external parity contract and color fixtures with Fortal's own
  specification, API catalog, contrast tests, and light/dark polish-board goldens.

- Keep the dashboard theme panel's edge padding nonnegative when a custom focus
  ring offset draws the ring inside its swatch.

- Add `fortalAppBarStyle` and generated `FortalAppBar` with a solid panel surface, 64px (`space9`) toolbar height, bottom border, `space4` insets, and bold `size4` title. Update `FortalDashboardShell` to use `FortalAppBar` and align its sidebar header height to `space9`.

- Add `FortalTheme.theme`, `darkTheme`, and `mode`, with light/dark data constructors, live system appearance, and nested theme-pair inheritance. The outermost `FortalTheme` sets `DefaultTextStyle` and `IconTheme(color: gray12)`, and a nested `FortalTheme` whose `brightness` or `gray` differs from its parent recolors both `DefaultTextStyle` and `IconTheme` to the new `gray12`. **Breaking:** rename `FortalScope` to `FortalTheme` and remove scope `brightness` and config `createScope`; use `mode` and `theme`. Direct design options such as `accent` remain supported.

- **Breaking:** align icon button icon sizes to 12/16/20 pixels.

- Add `fortalToastStyle` and the generated `FortalToast` with surface and classic variants, three sizes, and a visual-only accent, neutral, or error intent.

## 1.0.0-beta.9

 - **FIX**(data_list): bound minimum intrinsic width by maximum (#185).
 - **DOCS**(fortal): clarify button icon sizing and overrides (#187).

## 1.0.0-beta.8

 - **FIX**(remix_ui_icons): use a publishable package name (#176).
 - **FEAT**(sidebar): publish a Remix sidebar panel (#168).
 - **FEAT**(remix_icons): extract Radix icon package (#174).

## 1.0.0-beta.7

 - **REFACTOR**(remix): simplify composite surface rendering (#165).
 - **FEAT**(remix): add RemixMenuTrigger.builder for custom menu triggers (#166).
 - **FEAT**(remix): add disclosure component (#164).

## 1.0.0-beta.6

 - **FIX**: correct dashboard showcase and checkbox indicator regressions (#162).

## 1.0.0-beta.5

> Note: This release has breaking changes.

 - **REFACTOR**(fortal): consolidate base button state styling.
 - **FIX**(ci): make the version workflow able to complete (#149).
 - **FEAT**(remix): add styler field metadata, raise Mix floor to 2.2.0-beta.5 (#158).
 - **FEAT**(fortal): add opt-in icon index and document soft AA (#155).
 - **DOCS**(fortal): reference catalog, generated from the parity manifest (#154).
 - **BREAKING** **REFACTOR**(remix): make interactive components visual-only over naked_ui (#157).
 - **BREAKING** **REFACTOR**(fortal): default unsized typography from tokens, not ambient text (#153).
 - **BREAKING** **REFACTOR**(remix): generate callable component stylers (#152).
 - **BREAKING** **FEAT**(remix): add RemixLink and rebuild FortalLink on it (#151).

## 0.1.0-beta.3

- **FEAT**: Regenerate the Fortal Select wrappers for the new trigger indicator
  icons and `mouseCursor`, so `FortalSelect` exposes `collapsedIcon`,
  `expandedIcon`, and a cursor alongside the base component.
- Raise the `remix` floor to `^1.0.0-beta.4`.

## 0.1.0-beta.2

- **FEAT**: Add Fortal-themed line, bar, and pie chart recipes and generated
  widgets backed by `mix_chart`.
- **FIX**: Match the pinned Radix Themes dialog and popover layout defaults.
  `FortalDialog` now defaults to centered placement, exposes `start` and
  `center` alignment options, fills up to 600 pixels, and preserves safe
  viewport insets;
  `FortalPopover` has a 480-pixel maximum width.
- **FEAT**: Complete the five typography families — `FortalText`,
  `FortalHeading`, `FortalCode`, `FortalKbd`, and `FortalLink` — sharing one
  nine-step `FortalTextSize` scale and one `FortalTextWeight` enum.
- **FEAT**: `FortalScope` establishes the Radix theme root's default text run
  (`text3` at `gray-12`, regular weight), so an unsized `FortalText`,
  `FortalCode`, `FortalKbd`, or `FortalLink` resolves `1em` the way upstream
  does. Only the outermost scope does this; a nested scope re-scopes tokens and
  inherits the closest text style. Under `MaterialApp` or `CupertinoApp` the
  scope belongs in `builder:`.
- **FEAT**: Add `FortalCheckboxGroupItem` and share the focus ring.
- **FEAT**: Add Fortal typography recipes.
- **FIX**: Restore dialog and popover layout defaults.
- Raise the `remix` floor to `^1.0.0-beta.3`.

## 0.1.0-beta.1

- Initial release. Fortal — the Radix Themes-inspired preset theme for
  [Remix](https://pub.dev/packages/remix) — now ships as its own package.
  `FortalScope`, `FortalTokens`, the `Fortal*` widgets, and the `fortal*Style()`
  recipes were extracted from `remix` so that `remix` stays theme-free.
