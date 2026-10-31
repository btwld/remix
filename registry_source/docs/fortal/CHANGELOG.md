## Unreleased

- **Breaking:** replace Mangue with Serra, a new earthy olive (`#6F7845`).
  `FortalAccentColor.mangue` and the `mangue` palette constant are removed
  without an alias; use `.serra` and `serra`.
- **Breaking:** error roles (`error3`–`error12`, `errorA7`) read a dedicated red,
  `fortalError` (`#C92E3B`, installed as `<prefix>Error`), instead of Caju. It is
  not a selectable accent. Destructive content that used `accent: .caju` for red
  should use `accentPalette: fortalError`. Its dark solid is a deeper red so it
  stays apart from Caju. The dashboard recipe's negative statuses, deltas, and
  destructive actions use it via `FortalAccentScope.error`; positive statuses
  use Serra, and every status keeps its text label.
- Caju becomes a cashew-fruit orange-red (`#E76A32`) and Céu a sky blue
  (`#1A95D8`).
- Solid foregrounds (`contrast`) use a deep tone of each palette instead of
  basalt where white does not serve the fill: deep teal, navy, dark olive, warm
  brown and deep crimson, fitted to 4.6:1 on both fill and hover with fills
  unchanged. Calçadão and high-contrast knockouts are unchanged; custom
  palettes regenerate with their own deep ink.
- Dark solids take the seed's lightness within 0.70–0.84: Sol is gold
  (`#F3C442`, formerly mustard `#C49800`) and Duna keeps its sand seed. Custom
  palettes with seeds lighter than L 0.70 regenerate with lighter dark solids.
- The palette tool rejects custom names that reuse built-in identifiers and no
  longer infers the neutral palette from a custom name.
- Correct selected switch thumbs to semantic accent content roles in both modes:
  surface uses contrast/step 1, soft uses step 11/12. Idle thumb overrides remain
  supported; use `style.onSelected(...)` or `style.onDisabled(...)` to override
  those states, just as state-specific track colors require state overrides.
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
