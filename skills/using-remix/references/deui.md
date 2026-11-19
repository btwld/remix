# Deui Reference

Rules for the Deui preset that are easy to get wrong from a widget's name or
dartdoc alone. The preset is Stargate's design language over Remix components:
Geist, hairline borders instead of shadows, pill controls and a blue primary.
Behavior and widget parameters are Remix's. For a component's variants, sizes
and defaults, the installed recipe's enum in `lib/ui/components/<name>.dart` is
authoritative, and this source is yours to edit. For install commands, scope
placement and theme selection shared with the other presets, see the
[main skill](../SKILL.md).

## Recipes

Each component ships a `deui<Name>Style(...)` function that returns the Remix
widget's `*Styler`, and a generated `Deui<Name>` widget that applies it. The
catalog is small on purpose: `theme`, `icons`, `alert`, `avatar`, `badge`,
`button` (with the icon button), `checkbox`, `disclosure`, `dropdown`, `link`,
`modal`, `popover`, `progress`, `select`, `separator`, `skeleton`, `spinner`,
`switch`, `tabs`, `textfield`, `tooltip`.

Buttons are pills (`small` 32, `medium` 36, `large` 48 px) in `primary`,
`secondary`, `ghost`, `outline` and `danger`. Every variant keeps a 1px edge,
transparent unless bordered, so variants share one size. A text field is a 44px
pill with a hairline border that darkens on focus.

## Theme

`DeuiTheme` takes `theme`, `darkTheme` and `mode` like the other presets.
`DeuiThemeData.light()` and `.dark()` carry deui's palette and radius 12. The
token names are the shared semantic vocabulary (`background`, `foreground`,
`surfaceSecondary`, `overlay`, `muted`, `border`, `accent`...); `accent` is
deui's blue `primary`, and `highlight` is its teal accent. Raised surfaces
(popover, menu, select, tooltip) use `overlay`, a hairline border and no shadow.

## Not included

Search field, combobox, toolbar, listbox, data table, calendar, charts and the
Agent and dashboard recipes. The dropdown's wipe (`MenuStyler.panelTransition`)
and the tab indicator's glide (`TabBarStyler.indicator`) are Remix hooks, so a
call can replace either. Motion that Remix cannot express yet is not
reproduced: anchor-origin grow of other overlays, staggered rows, and checkbox
or switch indicator progress. Build those in your app until Remix supports
them.
