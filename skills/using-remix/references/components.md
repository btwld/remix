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


- **Checkbox** — `checkedIcon` and `indeterminateIcon` are `IconData?`,
  default `null`. Leaving them unset does not mean "no icon": Remix falls
  back to its own built-in glyphs, `RemixPathGlyph.thickCheck` and
  `RemixPathGlyph.thickDividerHorizontal`, not a blank state.
- **Radio and Switch** — `label` is drawn inside the same pointer, hover,
  press, focus, and semantics target as the control and is its accessible
  name; `semanticLabel` overrides it. Pass at least one of the two. The gap is
  `labelSpacing` (default 8) and the label style is `.label(...)` /
  `.labelColor(...)`. The target is the control's own size unless
  `minimumTapTargetSize` is set (default `Size.zero`; checkbox defaults to
  48x48), so opt in with `Size.square(48)` for touch.
- **CheckboxGroup** — standard Flutter keyboard model:
  every enabled `RemixCheckboxGroupItem` is an ordinary Tab stop in widget
  order, and Space/Enter toggle the focused option, exactly like native HTML
  checkbox groups. The group does not rove focus with arrow keys.
- **Combobox** — editable text with eligible suggestions, using
  `RemixCombobox<T>` over NakedCombobox/RawAutocomplete. Supply both `controller`
  and `focusNode` or neither; `initialValue` initializes text, not an entity.
  `onSelected(T)` reports acceptance rather than arbitrary text changes, so it
  uses `onSelected` instead of `onChanged`. Observe the controller for edits;
  callback controller edits are preserved. Callers own filtering, debounce and errors. `isOptionDisabled`
  keeps unavailable rows visible: keyboard moves skip them, Enter and pointer
  never accept them, and rows resolve option `onDisabled` styles. It is read
  once when a result arrives, so return a new result from `optionsBuilder` to
  change availability. A result with no enabled row closes the panel, as no
  results does. No chips or multiselect API. Custom fields forward the exact editor pair and
  submit callback, and own labels/disablement; custom option builders provide
  visuals beneath one named interactive wrapper. Style `field`, `panel(ComboboxPanelStyler())`,
  and `option(ComboboxOptionStyler())`; the nested `ComboboxOptionSpec` has
  `container` and `label` slots. Set option text with `.label(TextStyler(...))`;
  option `onFocused` means keyboard highlight,
  independent of hover. Eager rows have a style-owned minimum (48px by default) inside a bounded
  scroll panel with a persistent overflow thumb. Panel styles expose effects,
  scrollbar color and thickness. Vanilla ships `<Prefix>Combobox<T>` via `remix add combobox`,
  with the TextField recipe and a Select-like panel; its dependencies are
  `theme` and `textfield`. Fortal also ships the recipe with surface/soft variants and three TextField sizes; HeroUI ships primary/secondary variants with its responsive TextField and ComboBox/ListBox panel.
  See [Combobox](https://github.com/btwld/remix/blob/main/docs/components/combobox.mdx).
- **TextField/TextArea** — forwards the standard Flutter text-input surface
  (`controller`, `keyboardType`, `inputFormatters`, `maxLines`, etc.)
  unchanged; check the doc page rather than assuming a param is missing.
  `TextArea` is a multiline facade with `minLines: 2`, `maxLines: null`,
  `expands`/`obscureText` fixed to `false`. Vanilla, Fortal, and HeroUI recipes
  ring the field with `onFocused`, so a click shows the ring. Other controls use
  `onFocusVisible`.
- **RangeSlider** — `RemixRangeSlider` takes exactly two ordered, parent-owned
  values. Give the lower and upper thumbs distinct `semanticLabels` in that
  order. `onChanged` requests values; the parent decides whether to accept them.
  `onChangeEnd` reports the last pointer request, including a rejected request;
  keyboard and semantic changes do not emit pointer-only start/end callbacks.
  Each preset's `range_slider` item installs `<Prefix>RangeSlider` and its shared
  `slider` recipe dependency. Both thumbs use their preset's shared slider treatments;
  focus, hover and press rings apply independently to the active thumb.
  Use `<prefix>RangeSliderStyle()` on the base widget for custom semantic
  formatters, which the generated adapter omits.
  See [Slider](https://github.com/btwld/remix/blob/main/docs/components/slider.mdx).
- **Select** — is interactively enabled only when `enabled == true` and
  `onChanged != null`; either condition alone leaves it visually present but
  inert. `positioning` defaults to
  `OverlayPositionConfig(side: .bottom, alignment: .center)`.
  `RemixSelectTrigger` and `RemixSelectItem<T>` are data classes, not
  widgets. The menu keeps the width its styles give it unless one opts in with
  `remixAnchorWidth()` (for example
  `SelectStyler().content(SelectContentStyler().minWidth(remixAnchorWidth()))`),
  which resolves to the trigger width inside `RemixSelect` and `RemixMenu`
  overlays and to `0` anywhere else, `RemixPopover` included.
- **[Calendar](https://github.com/btwld/remix/blob/main/docs/components/calendar.mdx)** — controlled Gregorian date selection. `value` is nullable;
  `firstDate`/`lastDate` are required and inclusive. Compare civil year/month/day
  fields, not instants; callbacks return local date-only `DateTime` values,
  with a UTC civil fallback for historically skipped local days. Do not convert
  their timezones; compare with `isSameCivilDate`/`compareCivilDates` and build
  with `civilDate`, not `==` or `difference`.
  `enabled && onChanged != null` controls interaction. Unavailable in-range
  dates stay keyboard-focusable without becoming selectable. Browsing never
  selects; clearing `value` preserves the displayed month. The day grid has one
  Tab entry and supports arrows, Home/End, PageUp/Down and Shift+PageUp/Down.
  `RemixCalendarLabels` defaults to English; provide localized formatters and
  `firstDayOfWeek` explicitly (Monday=1 through Sunday=7). Default month/year
  selectors need an Overlay ancestor. Keep `navigationStyle`, `selectorStyle`
  and day styling unresolved in their own interaction states. Day styles add
  `onToday` and `onUnavailable` (predicate-rejected, in range; declare after
  `onDisabled`). Vanilla, Fortal and HeroUI ship `<Prefix>Calendar` with icon navigation, growing Select
  selectors and all day states; install `calendar`. `CalendarStyler.call(...)`
  builds a `RemixCalendar` with the supplied style.
- **[RangeCalendar](https://github.com/btwld/remix/blob/main/docs/components/range_calendar.mdx)** — controlled complete inclusive `CivilDateRange?`, sharing
  Calendar navigation and day anatomy. First activation anchors locally without
  a callback; second eligible activation requests one ordered range and clears
  the draft. Every interior date must be available, including offscreen dates.
  Parent rejection retains the supplied value. Escape cancels draft; inline
  Tab/blur preserves it. Use `RemixCalendarLabels` plus
  `RemixRangeCalendarLabels`, and the shared `CalendarStyler`. Style the painted
  interval with `CalendarDayStyler` variants `onRangePreview`, `onRangeStart`,
  `onRangeMiddle`, `onRangeEnd` and `onRangeSingle`, declared after
  `onSelected` so they win; a raw `styleSpec` paints no range. The range
  summary is an unpainted live region unless `summaryBuilder` shows it. No
  public draft controller, partial committed value, drag selection or typed
  entry. Vanilla, Fortal and HeroUI ship `<Prefix>RangeCalendar`; install `range_calendar`. Its
  outlined tinted draft de-emphasizes the old committed range.
- **[DatePicker](https://github.com/btwld/remix/blob/main/docs/components/date_picker.mdx)** — a thin Button + Popover + Calendar composition, not a text
  field. The parent owns nullable `value`; valid activation requests one date
  and closes even when rejected. Escape, outside interaction and disabling
  close without selection.
  Localize `semanticLabel` (purpose; the trigger's name), `placeholder`,
  `calendarLabels` (`fullDate` is the trigger's value, `noDate` when empty) and
  optionally `formatDate` (painted text only). An Overlay ancestor is required.
  A view resize closes it; keyboard and safe-area changes re-fit the open panel.
  Use `icon` for a decorative leading date-picker icon, `placeholderStyle`
  for the null-value fragment, and `expandedStyle` for the open-panel fragment
  (merged last over `buttonStyle`). Finite trigger labels ellipsize on one line.
  Style children independently with `buttonStyle`, `popoverStyle`,
  `calendarStyle`, `navigationStyle` and `selectorStyle`; there is no DatePicker
  `style`/`styleSpec` or public controller.
  `onOpen`/`onClose` report the popover; a completed selection calls `onChanged`
  before `onClose`, a dismissal only `onClose`. Parsing and segmented entry are
  not supported; use DateRangePicker for ranges. Vanilla, Fortal and HeroUI ship
  `<Prefix>DatePicker`; install `date_picker` for the Button, Popover and
  Calendar recipes wired as a hand-written composite.
- **DateRangePicker** — Button + Popover + RangeCalendar with a controlled
  `CivilDateRange?`. First activation anchors without closing; second eligible
  activation requests a complete range and closes even on parent rejection.
  Every reopening starts a fresh draft. An Overlay ancestor is required.
  Localize `semanticLabel` (purpose; the trigger's name), `placeholder`,
  `calendarLabels`, `rangeLabels` (`rangeValue` is the trigger's value, `noRange`
  when empty) and optionally `formatRange` (painted text only). Same resize,
  keyboard, `onOpen`/`onClose` and five child styles as DatePicker; no picker
  styler/controller or typed entry. Forwards `summaryBuilder` to paint the
  otherwise unpainted range summary. Vanilla, Fortal and HeroUI ship `<Prefix>DateRangePicker`;
  install `date_range_picker` for the matching hand-written composite. See
  [Date Range Picker](https://github.com/btwld/remix/blob/main/docs/components/date_range_picker.mdx).

## Data display


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
- **Spinner** — `SpinnerStyler().sweepAngle(...)` (radians; default a third of
  a turn) and `.strokeCap(...)` (default `StrokeCap.butt`) shape the circular
  indicator's arc. The leaf spinner, selected by `color`, `opacity` or
  `leafRadius`, ignores both. A component with a spinner part takes them
  nested, for example
  `ButtonStyler().spinner(SpinnerStyler().sweepAngle(3 * pi / 2).strokeCap(.round))`;
  there is no `.spinnerSweepAngle()` shorthand. See
  [Spinner](https://github.com/btwld/remix/blob/main/docs/components/spinner.mdx).

## Layout and dashboard recipes


Vanilla and Fortal also ship layout items beyond the core component set.
HeroUI ships `app_bar`, `sidebar`, `sidebar_layout`, `dashboard_shell`, and
`dashboard_demo` as extensions with no upstream HeroUI reference:

- **app_bar** — `RemixAppBar`: provides slots for leading widgets, title headings,
  actions, and bottom content. By default, `safeArea` is enabled (`true`). Wrap
  the page body below in `MediaQuery.removePadding(removeTop: true)`. The Fortal
  recipe requires the `text` item.
- **sidebar** — `RemixSidebar<T>`: provides vertical navigation sections and
  collapsible panels. Its styler includes a generic `call<T>()` builder. The
  Fortal recipe requires the `text` item; the HeroUI recipe requires
  `toggle_button` and `tooltip`.
- **sidebar_layout** — layout shell pairing an installed `sidebar` with page content.
  Displays an inline row above the compact breakpoint and a modal start-edge sheet
  below it. Contains no generated adapter.
- **dashboard_shell** — compound recipe combining `app_bar`, `sidebar`, and
  `sidebar_layout`. Provides slots for brand, search, page title (or custom
  `headerTitle`), account, and header actions. Contains no generated adapter.
  The HeroUI shell also installs `button` and `search_field`.
- **dashboard_demo** — showcase recipe assembling the five product dashboard
  screens (Overview, Chat, Customers, Orders, and Settings) into a runnable
  demo; see [Reference showcases](reference-showcases.md) for product-example
  and coverage-gallery conventions. The HeroUI demo also installs `chart`,
  `table`, `tabs`, `chip`, and the Agent items.

## Agent surfaces


Import experimental `package:remix/agent.dart` for `AgentConversation`,
`AgentMessage`, `AgentSteps`, `AgentToolCall`, `AgentAnswer`, `AgentSources`,
`AgentSuggestions`, and `AgentComposer`. These widgets, models, and stylers
keep their package names; they are not installed or prefixed.

Install `conversation_recipe`, `message_recipe`, `steps_recipe`,
`tool_call_recipe`, `answer_recipe`, `sources_recipe`, `suggestions_recipe`,
and `composer_recipe` for the selected preset's unresolved styler bundles.
Install `agent_glyphs_recipe` and wrap the conversation in
`AgentGlyphs(builder: uiAgentGlyph, child: ...)` (prefix `Ui`).
These recipes need no consumer `build.yaml`. The app owns the theme, recipes,
runner, decisions, and announcements. HeroUI's agent recipes are extensions
because its upstream library has no Agent family.

The old Transcript maps to Conversation; Plan and Activity to Steps;
Execution and Permission to ToolCall. Previously installed source stays
app-owned and keeps compiling. See the repository's `docs/agent/migrating.mdx`
for installation and call-site migration.

## Overlays


See [host requirements](../SKILL.md#provide-only-the-host-capabilities-in-use)
for Overlay, Navigator and toast scope placement.

- **showRemixDialog** — works even when the calling context has no
  `MixScope`; when one exists, it clones that scope's tokens and modifier
  order into the dialog route. Default `barrierColor` is `Color(0x8A000000)`.
  `RemixDialog` also takes `scrollable` (default `false`).
  `transitionDuration` (default 400ms) times the entrance;
  `reverseTransitionDuration` times the exit and defaults to
  `transitionDuration`. Reduced motion skips both.
- **showRemixAlertDialog** — requires a nonempty, localized `semanticLabel`;
  the barrier is non-dismissible by default. Takes the same
  `transitionDuration` and `reverseTransitionDuration`.
- **RemixTooltip** — opens on hover, focus, or long-press. Accepts `tooltipKey`
  (`GlobalKey<RawTooltipState>?`) for imperative display via
  `ensureTooltipVisible()`, and `onOpenChanged` to observe visibility. Applies
  the resolved `TooltipStyler.label(...)` spec through `DefaultTextStyle` so
  descendant `Text` widgets inside `tooltipChild` inherit the label style. The
  default `waitDuration` is 300ms (200ms in the Fortal recipe; see
  [Fortal](fortal.md)); it paces hover only, and is skipped within 300ms after
  another tooltip closes. Keyboard focus opens at once. One tooltip is visible
  at a time. The surface fades in 150ms and out in 75ms; `animationStyle`
  (`AnimationStyle`) changes those durations and curves, and
  `transitionBuilder` (`(context, animation, child)`) replaces the fade around
  the styled surface; inside it, `OverlayPlacement.of(context)` gives the
  placed side. Reduced motion shows and hides it at once, whatever the
  durations.
- **RemixMenu\<T\>** — `RemixMenuTrigger` and every entry type are
  **configuration objects, not widgets**. The sealed entry hierarchy is
  `RemixMenuItem<T>`, `RemixMenuCheckboxItem<T>`, `RemixMenuRadioGroup<T>`
  (holding `RemixMenuRadioItem<T>` entries, which are only valid nested
  inside it), `RemixMenuSubmenu<T>` (recursive, holding its own
  `RemixMenuItemData<T>` list), `RemixMenuSection<T>` (a heading over its
  own `items`: read as one group named by the heading, which is not
  focusable or selectable, styled by `MenuStyler().sectionLabel(...)` after
  `item`), and `RemixMenuDivider<T>`. Never fake a heading with a disabled
  `RemixMenuItem`. Use
  `RemixMenuTrigger.builder(label:, icon:, builder:)` for custom visual
  content; the builder receives `NakedMenuState` and must return
  non-interactive content — never a nested button. Use
  `RemixMenuTrigger.control(builder: (context, menu) => ...)` when the
  trigger is a real button such as `FortalButton`: pass `menu.focusNode` as
  its `focusNode` and `menu.toggle` as its `onPressed` (`menu` also exposes
  `isOpen` and `controller`). The builder must return a single control,
  with expanded state on its button; a loading announcement stays separate.
  A split button needs separate menu controls. The button
  keeps its own look, label, and enabled state, `MenuStyler.trigger` and
  `RemixMenu.semanticLabel` do not apply to it, and
  `RemixMenuTrigger.label` is null. The same
  `RemixMenuTrigger` is the trigger for `FortalMenu`; there is no separate
  Fortal trigger type. Size the panel from the trigger with
  `MenuStyler().overlay(FlexBoxStyler().minWidth(remixAnchorWidth()))`.
  Show a keyboard shortcut or count on a row with `trailingText:` (ordinary,
  checkbox, radio, and submenu items) rather than a hand-built row; style it
  with `MenuItemStyler().trailingText(...)`, which inherits the label style.
  An icon-only `RemixMenuItem` omits `label` and sets `semanticLabel`.
  `RemixMenu` (root panel) and `RemixMenuSubmenu` (that submenu) both take
  `onOpenRequested` and `onCloseRequested`. To animate an exit, call
  `hideOverlay` when the transition ends; the panel stays open until then.
  Hover and keys do not reopen a panel whose close is pending, and when the
  whole menu closes a submenu hides with the root panel.
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

### HeroUI calendar family

HeroUI also installs `calendar`, `range_calendar`, `date_picker` and
`date_range_picker`. The composites retain Remix's date and range API and merge
each child style last. Pickers use field-shaped button triggers rather than
segmented input. See the [Open Code catalog](https://github.com/btwld/remix/blob/main/docs/open-code/catalog.mdx)
and [Calendar](https://github.com/btwld/remix/blob/main/docs/components/calendar.mdx).
