# Remix Component Reference

Behavior rules that are easy to get wrong from a widget's name or dartdoc
alone. This is not a parameter reference — read the installed source or the
linked doc page for the full constructor surface.

Every styled leaf `Remix*` widget accepts `style` (a `*Styler`) and
`styleSpec` (an optional resolved spec such as `ButtonSpec`; use canonical
`*Spec` names). Behavioral roots and groups —
`RemixTabs`, `RemixRadioGroup`, `RemixCheckboxGroup`, `RemixAccordionGroup` —
have no styler. See [Styling](styling.md) for `.call()`/`call<T>()` and other
fluent mechanics.

Fortal cross-references name APIs from the installed Fortal preset. Read
[Fortal](fortal.md) for config, typography, and token rules, and
[Vanilla](vanilla.md) for the Vanilla preset's own rules.

Sections: [Actions](#actions) · [Forms](#forms) · [Data display](#data-display) ·
[Layout and dashboard recipes](#layout-and-dashboard-recipes) ·
[Agent surfaces](#agent-surfaces) · [Overlays](#overlays) ·
[Navigation](#navigation) · [Typography](#typography).

## Actions

[button.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/button.mdx) ·
[icon_button.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/icon_button.mdx) ·
[toggle.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/toggle.mdx) ·
[toggle_group.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/toggle_group.mdx)

- **Button** — effective enabled state is `enabled && !loading &&
  (onPressed != null || onLongPress != null)`. While `loading`, content stays
  laid out via `Visibility(visible: false, maintainSize: true)` and a spinner is layered
  over it in a `Stack`, so the button never changes size. Icon placement is
  style-driven when exactly one icon is present —
  `ButtonStyler().iconAlignment(RemixPlacement.end)` moves it after the
  label regardless of whether it came from `leadingIcon` or `trailingIcon`.
  With both icons present, leading → label → trailing order is stable and
  not affected by `iconAlignment`.
- **IconButton** — the Fortal preset forwards the complete `RemixIconButton`
  behavior surface (long press, semantics, builders, autofocus, cursor), not
  just the visual variant/size.
- **ToggleGroup** — controlled, single-select, with roving keyboard focus
  across items; `onChanged: null` disables the whole group.

## Forms

[checkbox.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/checkbox.mdx) ·
[checkbox_group.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/checkbox_group.mdx) ·
[radio.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/radio.mdx) ·
[switch.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/switch.mdx) ·
[slider.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/slider.mdx) ·
[textfield.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/textfield.mdx) ·
[textarea.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/textarea.mdx) ·
[select.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/select.mdx) ·
[segmented_control.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/segmented_control.mdx)

- **Checkbox** — `checkedIcon` and `indeterminateIcon` are `IconData?`,
  default `null`. Leaving them unset does not mean "no icon": Remix falls
  back to its own built-in glyphs, `RemixPathGlyph.thickCheck` and
  `RemixPathGlyph.thickDividerHorizontal`, not a blank state.
- **CheckboxGroup** — keyboard model deliberately differs from Radix Themes:
  every enabled `RemixCheckboxGroupItem` is an ordinary Tab stop in widget
  order, and Space/Enter toggle the focused option, exactly like native HTML
  checkbox groups. The group does not rove focus with arrow keys.
- **TextField/TextArea** — forwards the standard Flutter text-input surface
  (`controller`, `keyboardType`, `inputFormatters`, `maxLines`, etc.)
  unchanged; check the doc page rather than assuming a param is missing.
  `TextArea` is a multiline facade with `minLines: 2`, `maxLines: null`,
  `expands`/`obscureText` fixed to `false`.
- **Select** — is interactively enabled only when `enabled == true` and
  `onChanged != null`; either condition alone leaves it visually present but
  inert. `positioning` defaults to
  `OverlayPositionConfig(side: .bottom, alignment: .center)`.
  `RemixSelectTrigger` and `RemixSelectItem<T>` are data classes, not
  widgets.

## Data display

[avatar.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/avatar.mdx) ·
[badge.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/badge.mdx) ·
[card.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/card.mdx) ·
[callout.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/callout.mdx) ·
[data_list.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/data_list.mdx) ·
[data_table.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/data_table.mdx) ·
[progress.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/progress.mdx) ·
[spinner.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/spinner.mdx) ·
[skeleton.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/skeleton.mdx) ·
[divider.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/divider.mdx)

- **Avatar** — purely presentational; content precedence is `child` >
  `labelBuilder`/`label` > `iconBuilder`/`icon`.
- **DataTable** — fully controlled: the caller supplies the current page in
  final order, and sort/selection/pagination callbacks report intent only —
  they never mutate or fetch rows. Its styler has a generic `call<T>()`
  builder (see [Styling](styling.md)).
- **Skeleton** — a decorative loading placeholder that preserves its child's
  geometry and local state. While `loading`, the child cannot paint, receive
  input or focus, tick, or appear in semantics — announce loading state
  separately when it matters.

## Layout and dashboard recipes

Both presets also ship layout items beyond the core component set:

- **sidebar** — `RemixSidebar<T>`; its styler has a generic `call<T>()`
  builder. The Fortal item additionally depends on `text`.
- **sidebar_layout** — a plain shell with no spec or generated adapter; it
  composes an installed `sidebar` into a row above its compact breakpoint and
  a start-edge sheet below it.
- **dashboard_shell** — a grouped recipe combining `sidebar`/`sidebar_layout`
  with host-owned navigation, page content, search, and brand/account/action
  slots. No generated adapter; does not install charts, tables, or agent
  surfaces itself.
- **dashboard_demo** — a large composite recipe that pulls in most other
  items to build a runnable example dashboard; see
  [Reference showcases](reference-showcases.md) for how its `GalleryMatrix`
  widget is provenanced.

## Agent surfaces

[activity.mdx](https://github.com/conceptadev/remix/blob/main/docs/agent/activity.mdx) ·
[answer.mdx](https://github.com/conceptadev/remix/blob/main/docs/agent/answer.mdx) ·
[composer.mdx](https://github.com/conceptadev/remix/blob/main/docs/agent/composer.mdx) ·
[execution.mdx](https://github.com/conceptadev/remix/blob/main/docs/agent/execution.mdx) ·
[message.mdx](https://github.com/conceptadev/remix/blob/main/docs/agent/message.mdx) ·
[permission.mdx](https://github.com/conceptadev/remix/blob/main/docs/agent/permission.mdx) ·
[plan.mdx](https://github.com/conceptadev/remix/blob/main/docs/agent/plan.mdx) ·
[transcript.mdx](https://github.com/conceptadev/remix/blob/main/docs/agent/transcript.mdx)

For agent-run surfaces — `activity`, `answer`, `composer`, `execution`,
`message`, `permission`, `plan`, `transcript` — install either preset's bare
item, which is unstyled by default, plus the matching `<item>_recipe` for a
complete, preset-specific styler bundle. Even a bare item is not Remix-only:
the shared `support` item brings in the preset `theme` and `remix_ui_icons`.
Each agent item also declares its own `mix_annotations` dependency and
`build_runner`/`mix_generator` dev dependencies for codegen.

## Overlays

[popover.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/popover.mdx) ·
[dialog.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/dialog.mdx) ·
[tooltip.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/tooltip.mdx) ·
[menu.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/menu.mdx) ·
[toast.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/toast.mdx)

Menu, select, popover, and tooltip content uses the nearest caller-provided
`Overlay` and does not require a `Navigator`; wrap the subtree with
`Overlay.wrap` when the host does not already expose one. Dialog helpers push
routes and require a caller-provided `Navigator`; toasts require a
`RemixToastScope` — see [host requirements](../SKILL.md#provide-only-the-host-capabilities-in-use).

- **showRemixDialog** — works even when the calling context has no
  `MixScope`; when one exists, it clones that scope's tokens and modifier
  order into the dialog route. Default `barrierColor` is `Color(0x8A000000)`.
  `RemixDialog` also takes `scrollable` (default `false`).
- **showRemixAlertDialog** — requires a nonempty, localized `semanticLabel`;
  the barrier is non-dismissible by default.
- **RemixTooltip** — has controlled `open`/`onOpenChanged` in addition to
  hover/long-press behavior. Its resolved `TooltipStyler.label(...)` spec is
  applied through `DefaultTextStyle`, so ordinary descendant `Text` widgets
  inside an arbitrary `tooltipChild` inherit the custom label style without
  requiring a single `Text` child. Base default `waitDuration` is 300ms; the
  Fortal recipe shortens it to 200ms (see [Fortal](fortal.md)).
- **RemixMenu\<T\>** — `RemixMenuTrigger` and every entry type are
  **configuration objects, not widgets**. The sealed entry hierarchy is
  `RemixMenuItem<T>`, `RemixMenuCheckboxItem<T>`, `RemixMenuRadioGroup<T>`
  (holding `RemixMenuRadioItem<T>` entries, which are only valid nested
  inside it), `RemixMenuSubmenu<T>` (recursive, holding its own
  `RemixMenuItemData<T>` list), and `RemixMenuDivider<T>`. Use
  `RemixMenuTrigger.builder(label:, icon:, builder:)` for custom visual
  content; the builder receives `NakedMenuState` and must return
  non-interactive content — never a nested button. The same
  `RemixMenuTrigger` is the trigger for `FortalMenu`; there is no separate
  Fortal trigger type.
- **Toast** — base Remix exposes `RemixToastScope` and
  `showRemixToast(context, RemixToastData(title: ...))`, which returns a
  `RemixToastHandle` (`closed`, `dismiss()`). A toast with the same non-null
  `id` replaces the visible or queued one in place. Style lives on the scope:
  `RemixToastScope(style: fortalToastStyle(), ...)` under Fortal, and a
  per-toast `RemixToastData.style` (for example
  `fortalToastStyle(intent: FortalToastIntent.error)`) merges over it. The
  generated `FortalToast` is for static previews, not for `showRemixToast`.
  Place the scope per [host requirements](../SKILL.md#provide-only-the-host-capabilities-in-use).

## Navigation

[tabs.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/tabs.mdx) ·
[accordion.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/accordion.mdx) ·
[disclosure.mdx](https://github.com/conceptadev/remix/blob/main/docs/components/disclosure.mdx)

- **RemixTabs** — the behavioral root; no `style`/`styleSpec`. Takes
  `activationMode` (default automatic). There is no `FortalTabs` — compose
  `RemixTabs` with `FortalTabBar`, `FortalTab`, `FortalTabView`. A
  `controller` is `NakedTabController`, which the `remix` barrel does not
  re-export — import it from `package:naked_ui/naked_ui.dart` directly.
  `maintainState` (default `true`) lives on `RemixTabView`, a different
  widget, not on `RemixTabs`.
- **RemixAccordionGroup\<T\>** — purely behavioral; `controller` is
  **required**: `RemixAccordionController<String>(min: 0, max: 1)`. Menu
  auto-creates a `MenuController` when its own `controller` is omitted.
  `RemixTabs` takes either a `controller` or `selectedTabId` plus
  `onChanged` (the caller holds the selection); with neither `controller`
  nor `onChanged` the tabs are disabled.
- **RemixAccordion\<T\>** — anatomy is one panel, two parts: `container`
  owns the shared frame (fill, border, radius, clipping), `trigger` owns the
  header row, `content` owns the expanded body. The top-level Box shorthand
  (`.color()`, `.padding()`, `.borderRadius()`, ...) forwards to `trigger`,
  **not** `container` — reach `.container(...)` explicitly for the outer
  frame. Widget-state variants (`onHovered`, `onPressed`, `onFocused`,
  `onFocusVisible`, `onDisabled`) describe interaction with the trigger but
  resolve once for the whole item, so they may style `container` too.
- **RemixDisclosure** — standalone trigger and one inline panel for items
  that do not need `RemixAccordionGroup` coordination. Same top-level
  shorthand-forwards-to-`trigger` rule as Accordion. `FortalDisclosure` has
  no trailing-icon slot; compose the expand indicator with `triggerBuilder`
  and `state.isExpanded`.

## Typography

`FortalText`, `FortalHeading`, `FortalCode`, and `FortalKbd` exist only in
the Fortal preset. `RemixLink` is base Remix — the Vanilla preset also ships
a `link` item generating `<Prefix>Link`, and Fortal ships `FortalLink`. See
[Fortal typography](fortal.md#typography).
