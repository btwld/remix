## Unreleased

- **Breaking:** Fortal focus rings on toggles, toggle-group items, tabs, accordion and disclosure triggers, and sidebar destinations are outlines painted through `containerEffects` (`triggerEffects` on accordion and disclosure), so focusing no longer resizes or moves the part. Toggles, toggle groups, accordion, disclosure, and sidebar destinations ring in `focus-8`, where they rang in `focus-a8`. `fortalFocusRing`, `FortalFocusRing`, and `FortalFocusRingFlexBox` are removed: put `fortalTabFocusOutline()` (or `fortalFocusOutline(color, offset:)`) in `containerEffects` or `triggerEffects`.

- **Breaking:** `FortalActionMenu` takes a `RemixMenuTrigger` instead of `semanticLabel` and a `trigger` widget, and `fortalDataTableActionsTrigger` is a function of the accessible label that returns a `RemixMenuTrigger`. The data-table kebab and the top-bar account menu are real buttons through `RemixMenuTrigger.control`; the sidebar account row stays a visual trigger and now rings on keyboard focus.

- **Breaking:** The Fortal select panel is at least as wide as its trigger (`minWidth(remixAnchorWidth())`, Radix `select.css:45`). A `maxWidth` below the trigger width must also set `minWidth`.

- Add a `focus-8` ring to a focused sortable data-table header. Radix draws none; a focusable header needs a visible focus indicator.

- These changes need remix 1.0.0-beta.14 and naked_ui 1.3.0. Overwrite these installed items together: `theme`, `toggle`, `toggle_group`, `tabs`, `accordion`, `disclosure`, `data_table`, `select`, and `dashboard_demo`. `sidebar` needs no overwrite: its destinations take the new ring from `toggle`.

- Add `fortalAppBarStyle` and generated `FortalAppBar` with a solid panel surface, 64px (`space9`) toolbar height, bottom border, `space4` insets, and bold `size4` title. Update `FortalDashboardShell` to use `FortalAppBar` and align its sidebar header height to `space9`.

- Add `FortalTheme.theme`, `darkTheme`, and `mode`, with light/dark data constructors, live system appearance, and nested theme-pair inheritance. The outermost `FortalTheme` sets `DefaultTextStyle` and `IconTheme(color: gray12)`, and a nested `FortalTheme` whose `brightness` or `gray` differs from its parent recolors both `DefaultTextStyle` and `IconTheme` to the new `gray12`. **Breaking:** rename `FortalScope` to `FortalTheme` and remove scope `brightness` and config `createScope`; use `mode` and `theme`. Direct design options such as `accent` remain supported.

- **Breaking:** align icon button icon sizes to 12/16/20 pixels.

- Add `fortalToastStyle` and the generated `FortalToast` with surface and classic variants, three sizes, and a visual-only accent, neutral, or error intent. Toast is a Fortal extension and is not tracked in the Radix Themes parity ledger.

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
