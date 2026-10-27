## Unreleased

### Features

- Add `NakedMenu.openOnTap` (default `true`). Set it to `false` to use your own
  control as the trigger: the menu then draws no `NakedButton`, adds no tap or
  keyboard activation or focus stop, and leaves opening and closing to the
  `controller`. Attach `triggerFocusNode` to the control so focus returns to it
  when the menu closes. The menu merges the control's semantics into one node
  that carries the expanded state, so do not wrap the control in
  `MergeSemantics`, and it must not set `semanticLabel`. It cannot be `false`
  for an item of a `NakedMenubar`.
- Add `constrainToAvailableHeight` to `NakedSelect`, `NakedMenu`, and
  `OverlayPositioner` (default `false`, so nothing changes until it is set). A
  panel placed above or below its trigger is then laid out no taller than the
  space on that side, after `sideOffset` and `collisionPadding`, instead of as
  tall as the whole overlay, so a tall panel no longer slides over its trigger
  and a scroll view inside it scrolls beside the trigger. With collision
  avoidance on, the larger side bounds the layout; the panel stays on the
  preferred side when it fits there, otherwise it flips. Content that cannot
  scroll overflows the shorter panel, and placements to the left or right of the
  trigger are not capped.

### Fixes

- Keep the focus action and focused state on a `NakedDisclosure` trigger that
  sets `semanticLabel`. The label still replaces the trigger's visual content
  for assistive technology, but no longer drops focus semantics.
- `showNakedDialog`, `showNakedAlertDialog`, `NakedTooltip`, `NakedDisclosure`,
  and `NakedToastScope` now skip their transitions when the user asks to reduce
  motion, whatever durations they were given. They honor both
  `MediaQuery.disableAnimations` and the platform's Reduce Motion setting, which
  iOS reports separately and `disableAnimations` does not reflect. Until now
  `NakedDisclosure` and `NakedToastScope` honored only the former, and dialogs
  and tooltips neither.
  - A dialog reads the setting when it opens and when it is dismissed. One that
    opened without motion also closes without it.
  - A tooltip and a toast apply a change to their next show or hide. A
    disclosure also completes a transition already running.
- A modal `NakedDialog` shown without a transition, with a zero
  `transitionDuration` or under reduced motion, no longer hides the dismissible
  barrier's "Dismiss" node from screen readers. `showNakedDialog` now wraps the
  dialog page in a semantics container.
- Keep a menu nested in a menubar panel out of the bar's trigger traversal and
  focus/hover activation. A nested caller-owned control still opens its menu
  only through its own activation.
- Home and End now scroll the newly focused item just far enough into view in
  `NakedSelect`, `NakedMenu`, and other anchored overlays with scrolling
  content, in `NakedTabBar`, and in `NakedMenubar`.
- The arrow keys and Home and End in `NakedToggleGroup`, and the arrow keys
  from an open `NakedMenubar` menu, scroll the newly focused item into view the
  same way. A target that is already visible stays where it is.
- `NakedSelect` now opens with focus on the selected option, scrolled into
  view, so Arrow Up and Arrow Down continue from it instead of from the ends of
  the list. A select without a selected option, or whose selected option is
  disabled or not built yet in a lazy list, opens on its first enabled option:
  the first Arrow Down reaches the second option and Enter selects the first,
  where focus used to start on the overlay container. Focus stays on a field in
  the panel that has already taken it.
- Hovering an item in `NakedSelect` or `NakedMenu` clears keyboard focus, and
  hovering a submenu row also opens it after its delay, only when the pointer
  moves over it, no longer when a list scrolls under a resting pointer.

## 1.2.3

### Fixes

- In right-to-left `NakedTabBar`s, Home and End now move focus to the first
  and last tab, matching the arrow keys, instead of the tabs at the visual
  left and right edges.

## 1.2.2

### Fixes

- Remove the remaining direct Material imports and unused Material icon-font
  declaration. Public APIs and application font bundling are unchanged.
- Show one `NakedTooltip` at a time. Hover, focus, touch, and `tooltipKey`
  activation now replace the visible tooltip, which disappears at once instead
  of fading out under the next one. This reverses 1.2.1, which kept a focused
  or `tooltipKey`-opened tooltip visible while another trigger was hovered.
- A replaced `NakedTooltip` no longer reopens when the newer one closes, and a
  newer activation cancels a pending focus show. Escape closes the visible
  tooltip even when another trigger has focus.
- Do not show touch selection handles in `NakedTextField` after a mouse
  secondary click, matching Flutter's `TextField`.

## 1.2.1

### Fixes

- Clear stale keyboard focus when hovering menu items, and close hovered
  submenus without returning focus to their triggers. Keep ancestor submenus
  open while the pointer moves into nested panels.
- Dismiss stale hover tooltips when entering another trigger while preserving
  focus-held and manually opened tooltips. Keep focused tooltips visible when
  the pointer leaves their trigger or content.

## 1.2.0

### Features

- Build `NakedTooltip` on Flutter's `RawTooltip` for triggers, delays,
  feedback, animation, hoverable content, and overlay lifetime. Retains 1.1.0
  focus, blur, Escape, and collision-resolved `OverlayPlacement` behaviors.
- Add `NakedTooltip.tooltipKey` (`GlobalKey<RawTooltipState>`) to show the
  tooltip imperatively via `ensureTooltipVisible()`.

### Deprecations

- Deprecate `NakedTooltip.open`, `useRootOverlay`, and
  `disableHoverableContent` for removal in 2.0.0. Setting any of these
  parameters runs the legacy 1.1.0 implementation. Use `tooltipKey` to show
  the tooltip imperatively and `onOpenChanged` to observe visibility.
  `tooltipKey` has no effect when a deprecated parameter is set.

### Changed

- Clarify `NakedCombobox`'s direct `RawAutocomplete` composition and retain
  its lifecycle callbacks. Flutter issue #191928 still allows a pending async
  result to reopen the options after Escape; the adapter reports that reopen
  accurately and does not add a second visibility state machine.

### Fixes

- Allow Escape on a closed `NakedTooltip` trigger to reach enclosing dismiss
  actions (such as dialogs or drawers).
- Deliver uncontrolled `NakedTooltip.onOpenChanged` notifications after the
  current frame so callers can safely call `setState`. Discard pending
  notifications on disposal, report closure before replacing `tooltipKey`, and
  report zero-duration reopens while mounted.
- Preserve `NakedTooltip` animation defaults for partial `AnimationStyle`
  values, honor reverse curves, and apply style updates without resetting
  visibility, focus, or raw tooltip state.
- `NakedTextMagnifier` now updates its position and focal point when its
  notifier, size, magnification scale, or vertical shift changes, without
  waiting for the notifier's next update.
- A controlled `NakedSelect` (`open` + `onOpenChanged`) now asks its owner
  before every close, including Escape on the trigger, an ancestor scroll
  (once when scrolling starts and once when it ends), and a view resize. These
  used to close the overlay without calling `onOpenChanged`.
- Escape on a closed `NakedSelect` trigger now reaches an enclosing dismiss
  action, such as the `NakedPopover` around it. 1.1.0 consumed it.
- Remove the duplicate horizontal traversal binding from menubar overlays.
  `OverlayPortal` preserves the bar ancestry, while menu panels retain their
  own Home/End bindings; arrow traversal behavior is unchanged.
- Guard `NakedMenu` and `NakedPopover` `onCloseRequested` callbacks against
  closed anchors on Flutter 3.41 and 3.47, and avoid restoring focus to a
  closing menubar trigger when a sibling menu in the same `NakedMenubar` is
  already open.
- Bind Escape directly on dismissible `showNakedDialog` routes so custom
  `WidgetsApp` shortcut maps that omit `DismissIntent` still dismiss
  dialogs on Escape while respecting `PopScope`.
- Wrap `NakedCombobox` options overlays in `ExcludeFocus` (matching Flutter
  3.47) so Tab from an open combobox moves focus to the next focusable widget on
  Flutter 3.41 and 3.44, and guard async `optionsBuilder` completions after
  unmount on Flutter 3.41.
- Preserve other actively focused or hovered `NakedTooltip` overlays when a
  blurred tooltip's `dismissDelay` runs `RawTooltip.dismissAllToolTips()`, and
  reset hover/focus state cleanly on Escape or overlay removal.
- Reset `NakedScrollbar` hover state when `interactive` becomes `false` while
  hovered, and snap `NakedTextMagnifier` immediately on widget property updates
  instead of animating as a line jump.

### Evaluated and skipped

- `Expansible` hard-wires a clipped height animation and would drop
  `reverseDuration`.
- `RawTooltip` still has no per-instance dismiss, controlled open state,
  root-overlay option, or focus trigger, and `ignorePointer` needs Flutter
  3.44, so the deprecated parameters keep the 1.1.0 implementation.
- `showRawDialog` needs Flutter 3.44 and only adds native-window dialogs.

## 1.1.0

### Migration

- `NakedState` subclasses now supply equality fields through `props`, starting
  with `...super.props`. When migrating a manual `==`/`hashCode` override,
  include its former fields in `props`; the protected `statesEqual` and
  `statesHashCode` helpers have been removed.

### Features

- Add `NakedCombobox`, a headless autocomplete field on `RawAutocomplete`.
  Callers own the text field and the options panel. Keyboard highlight, Enter
  to select, Escape, and async option staleness come from Flutter.
- Add `NakedMenubar` on `RawMenuAnchorGroup`. Menus in the bar close their
  siblings, switch on hover while one is open, and move with the arrow keys.
- Add `NakedScrollbar` on `RawScrollbar`, with thumb and track colors resolved
  from hovered and dragged states.
- Add `NakedTextMagnifier` on `RawMagnifier`. `NakedTextField` now uses it on
  touch platforms instead of Material's `TextMagnifier`. Pass
  `magnifierConfiguration` to keep the previous Material or Cupertino lens.
- `NakedTextField` no longer supplies selection handles or resolves a
  `CupertinoDynamicColor`. Pass `selectionControls` for handles and
  `contextMenuBuilder` for the cut, copy, and paste menu. Resolve a dynamic
  color before passing it as `cursorColor`.

### Docs

- Document `NakedTooltip` as built on `RawMenuAnchor`. The 1.0 Flutter 3.41
  requirement was originally tied to `RawTooltip`; the tooltip no longer uses it.

## 1.0.2

### Fixes

- Remove the inner `container: true` from the `NakedSelect` trigger's merged
  semantics. On Flutter 3.44 the overlay made that folded-away node the menu's
  traversal parent, so the platform received a node with no parent and the
  macOS accessibility bridge dropped the update and could crash. The trigger
  still announces one merged node with its label, value, button role, and
  expanded state.

## 1.0.1

### Fixes

- Reword the `NakedToastScope` missing-scope error hint to use `WidgetsApp` and
  note that any app host works. Message-only change; no API or behavior change.

## 1.0.0

First stable release. The API is unchanged from `1.0.0-beta.15`; this release
declares it stable and commits to semantic versioning for future changes.

Development moves to the Remix monorepo
(https://github.com/conceptadev/remix), where `naked_ui` now lives at
`packages/naked_ui`. The package remains independently versioned and published.

## 1.0.0-beta.15

### Features

- Add `NakedToastScope`, `NakedToastController`, and typed toast requests with
  bounded queues, same-id replacement, lifecycle-aware timers, keyboard
  dismissal, focus restoration, and status/alert semantics. Presenters retain
  ownership of visuals and actions.

## 1.0.0-beta.14

### Fixes

- Link each `NakedDisclosure` trigger to its controlled panel in the semantics
  tree. Web relationships now resolve to the current panel DOM node after
  repeated remounts, while native trigger identity and the panel identifier
  remain stable.

## 1.0.0-beta.13

### Features

- Add `NakedDisclosure`, a standalone headless button-and-panel primitive with
  controlled and uncontrolled state, accessible expanded semantics, shared
  widget state, normal panel focus traversal, and optional exit-aware
  transitions that preserve panel state while closing.

## 1.0.0-beta.12

### Features

- Add `NakedButton.semanticHint` on the same Semantics node as the button
  role, label, enabled state, and tap/long-press actions.
- Add `NakedSelect.semanticValue` so the trigger can announce a
  human-readable selection instead of `T.toString()`.
  `SemanticsRole.comboBox` exists on Flutter 3.41+ but debug semantics
  still throw `Missing checks for role` (flutter/flutter#172918), so the
  trigger keeps the merged button + expanded + value contract.
- Add `NakedRadioGroup`, a thin wrapper over Flutter's `RadioGroup` that
  supplies what it lacks: a nullable `onChanged` (null means disabled), a
  group `enabled` state radios inherit, and an optional accessible group
  label. Flutter's `RadioGroup` keeps the single `SemanticsRole.radioGroup`
  node; the label is a plain container around it, never a second role node.

## 1.0.0-beta.11

### Features

- Add dependency-free `NakedLink` with Link semantics, optional destination
  metadata, caller-owned activation, observable hover/focus/press/disabled
  state, and caller-owned focus nodes. Primary tap, semantic tap, Enter, and
  Numpad Enter activate; Space and held-key repeats remain unclaimed. Inert
  Links expose no Link role, destination, focus stop, or tap action.

## 1.0.0-beta.10

### Features

- Add `NakedAccordion.itemBuilder` for styling a trigger and panel as one unit.
  It receives the same `NakedAccordionItemState` as the trigger builder plus the
  fully assembled item as its child, and its context resolves
  `NakedAccordionItemState.controllerOf` to the authoritative controller shared
  with the trigger and panel.

### Fixes

- Track `NakedAccordion` press state whenever the item is enabled instead of
  only when `onPressChange` is supplied, so `WidgetState.pressed` reaches
  builders without a callback, and clear the pressed state when the item
  becomes disabled.

## 1.0.0-beta.9

### Fixes

- Keep `NakedTextField`'s `WidgetState.pressed`, `onTapChange`, and
  `onPressChange` synchronized when selection gestures take over; block
  disabled pointer and selection paths, and defer lifecycle cleanup callbacks
  to avoid rebuilding while the widget tree is locked.
- Mark `NakedToggleOption` semantics as part of a mutually exclusive group,
  matching Flutter's segmented-control contract for enabled, selected, and
  disabled options.

## 1.0.0-beta.8

### Fixes

- Preserve tooltip overlay semantics when `semanticLabel` is absent or blank,
  while continuing to avoid duplicate announcements when a non-empty label
  represents the content on the trigger. Explicit semantics overrides remain
  authoritative.

## 1.0.0-beta.7

### Features

- Add `NakedSliderState.visualPercentageOf` for mapping arbitrary logical
  fractions to physical track alignment across orientation, text direction,
  and inversion, while preserving `visualPercentageAt` thumb placement.

## 1.0.0-beta.6

### Fixes

- Make `NakedTextField` honor ambient `DefaultSelectionStyle` cursor and
  selection colors, including context-resolved `CupertinoDynamicColor`
  variants, while preserving explicit cursor precedence, focus gating, and
  platform fallbacks.

### Maintenance

- Point package metadata at the canonical `conceptadev/naked_ui` repository.

## 1.0.0-beta.5

### Breaking changes

- Replace alignment-pair overlay positioning with a Radix-shaped
  `OverlayPositionConfig`: side, logical alignment, signed side/alignment
  offsets, collision padding, collision avoidance, and a resolved
  `OverlayPlacement` available to overlay descendants after flip or shift.
- Change `NakedSlider` from one `double value` to a nonempty, ordered
  `List<double> values`. Callbacks are list-valued; defaults are now `min=0`,
  `max=100`, and `step=1`. The slider supports arbitrary thumb counts,
  orientation, inversion, minimum spacing, nearest-thumb pointer selection,
  non-crossing constraints, and per-thumb focus, labels, formatters, and
  semantics actions.

### Features and behavior changes

- Add controlled `open` / `onOpenChanged` contracts to Select and Tooltip.
  Controlled owners may accept or reject trigger, selection, Escape, outside
  tap, hover, focus, and touch requests without transient visual mutation.
- Keep Tooltip open while either its trigger or overlay content is hovered,
  with an opt-out through `disableHoverableContent`; expose the final
  collision-resolved placement to tooltip content.
- Add separate keyed Popover anchors and automatic/manual Tabs activation.
- Add controlled menu checkbox items and typed radio groups/items with checked
  roles and mutually-exclusive semantics.
- Add recursively composable submenus with delayed hover handoff, LTR/RTL
  open/close arrows, Escape handling, sibling coordination, root dismissal,
  first-item focus, and trigger-focus restoration.

## 1.0.0-beta.4

### Features

- Add `SemanticsRole.alertDialog` support to `NakedDialog` and a
  `showNakedAlertDialog` helper with required non-empty caller-localized names,
  a non-dismissible outside barrier by default, null cancellation from Escape
  and platform Back, mandatory focus entry, safe initial-focus selection,
  closed-loop traversal, and caller-owned focus-node handling. Dismissible
  barriers require a non-empty localized label. Existing `NakedDialog` and
  `showNakedDialog` defaults remain unchanged.

### Behavior changes

- Migrate `NakedToggleGroup` options from independent Tab stops to one
  roving-focus stop: Tab enters and exits once, arrows and Home/End move focus
  without selecting, activation proposes the controlled value, and disabled or
  dynamically removed options repair focus within the group.

## 1.0.0-beta.3

### Fixes and hardening

- Scope overlay-item builders to their declared state type: `NakedMenuItem` and
  `NakedSelectOption` builders now receive a context containing a matching
  `NakedStateScope<S>`, so `NakedMenuItemState`/`NakedSelectOptionState`'s
  `of`/`controllerOf` helpers resolve to the item state. Downstream code no
  longer needs `NakedButtonState`, which leaked the internal button
  implementation.

## 1.0.0-beta.2

### Breaking changes

- Require Dart 3.9 and Flutter 3.41, matching the `RawTooltip` API used by the
  package.
- Treat `NakedSelect.value` as fully controlled, including `null`; a select
  without `onChanged` is now consistently non-interactive.
- Make `NakedAccordionController.values` immutable to callers and preserve its
  observable FIFO ordering.
- Make `NakedStateScope.controllerOf` type-specific; generic state helpers now
  require the requested value type.
- Require `NakedMenu` to have either a `child` or `builder`, and throw a
  descriptive error when menu/select items are used outside their owner.

### Fixes and hardening

- Rebuild controller-driven tabs, prevent duplicate tab selection callbacks,
  replace duplicated content semantics when `semanticLabel` is set, and keep
  orientation-aware Home/End navigation within each tab bar.
- Apply dialog, tab, menu, and menu-item semantic roles, including selected
  state for select options.
- Correct focus-node ownership swaps across controls and remove the redundant
  focus owner around `EditableText`.
- Consolidate overlay positioning, including safe handling of oversized
  content, and rebuild Popover on the shared anchored-overlay shell.
- Keep inherited callbacks current, initialize replacement accordion
  controllers, and scope slider drag-end values to each drag session.
- Correct example paths in CI workflows and remove redundant dependency steps.

## 1.0.0-beta.1

- feat(naked-select): add `mouseCursor` property to NakedSelect
- refactor(naked-tooltip): replace `RawMenuAnchor` with `RawTooltip`
- fix: stabilize flaky tests (InkSparkle shader + focus mode)

## 0.2.0-beta.7

- fix: text style handling in NakedTextField
- feat: improve 3.27-safe semantics for menu, select, accordion, checkbox, radio, slider, and text field

## 0.2.0-beta.6

- fix: disabled and error state support for NakedTextField

## 0.2.0-beta.5

- fix: NakedAccordionItemState scope on content
- refactor: remove NakedMenuController typedef

## 0.2.0-beta.4

- docs: refine documentation for developer clarity
- refactor: Simplify NakedTextFieldBuilder signature
- feat: add excludeSemantics parameter to all widgets

## 0.2.0-beta.3

- feat: expose StrutStyle to NakedTextField
- fix: state scope not in the Context
- feat: recreate NakedTooltip widget
- refactor: Overlay Rendering
- docs: Improve the usage examples

## 0.2.0-beta.2

### Bug Fixes

- Fixed `.when` method priority order to prioritize active interaction states (dragged) before selection states

### Improvements

- Added comprehensive test coverage for mixins and utilities

## 0.2.0-beta.1

- Added: Popover; Toggle
- API: Standardized state callbacks (onHoverChange/onPressChange/onFocusChange); removed onDisabledState (use enabled); added onSelectChange/onDragChange where applicable
- Better use of Raw Flutter components where available
- Accessibility: Improved semantics across button, checkbox, radio, slider, select, tabs, dialog, tooltip
- Focus/State: Unified focus handling (FocusNodeMixin) and consistent hover/press/selected for builders

- Architecture: Builder-first APIs (e.g., NakedTextField builder) with state provided via NakedStateScope

## 0.0.1-dev.2 (2025-07-03)

### Features

* "Naked" - A Behavior-First UI Component Library for Flutter ([#579](https://github.com/btwld/naked_ui/issues/579)) ([c55b55f](https://github.com/btwld/naked_ui/commit/c55b55ffa47206fd49da9eebf85e834b5f08220e))
* Add maybeOf helper to InheritedWidgets and refactor of() ([805a37e](https://github.com/btwld/naked_ui/commit/805a37e5a2924e79fe08784ff9ac52b20e59bc44))
* Add maybeOf helper to InheritedWidgets and refactor of() ([805a37e](https://github.com/btwld/naked_ui/commit/805a37e5a2924e79fe08784ff9ac52b20e59bc44))
* Add test for Hover to RadioButton ([#601](https://github.com/btwld/naked_ui/issues/601)) ([8bd0425](https://github.com/btwld/naked_ui/commit/8bd0425150e9d81a03f9885ad493da47ea1080b2))
* Add textStyle prop in NakedTextField  ([#608](https://github.com/btwld/naked_ui/issues/608)) ([4b5252b](https://github.com/btwld/naked_ui/commit/4b5252b7a49d21695a97e806fef5fd9f2d21555a))
* Implement Tooltip Lifecycle ([#603](https://github.com/btwld/naked_ui/issues/603)) ([2ddbf60](https://github.com/btwld/naked_ui/commit/2ddbf60b0a6093b41c193a4fd42259cc40519810))
* Recreate Button using Naked ([#587](https://github.com/btwld/naked_ui/issues/587)) ([0d55724](https://github.com/btwld/naked_ui/commit/0d5572437d4963f13572402128b6a7a85e60aab1))
* Refactor radio and checkbox components with new architecture ([#672](https://github.com/btwld/naked_ui/issues/672)) ([4f3ce7d](https://github.com/btwld/naked_ui/commit/4f3ce7d4023710adb9cc7f4ba751e78d8fe3f3c2))


### Bug Fixes

* Change default autofocus to false in Menu and Select ([#609](https://github.com/btwld/naked_ui/issues/609)) ([76d8736](https://github.com/btwld/naked_ui/commit/76d873661f7cec60195e1a0bdec530936decc82e))


### Miscellaneous Chores

* release 0.0.1-dev.2 ([399a65d](https://github.com/btwld/naked_ui/commit/399a65d6ebe2a5b2089dd233721f91a04dfe9e97))
* release 0.0.1-dev.2 ([6d1ff7f](https://github.com/btwld/naked_ui/commit/6d1ff7fa42c9b47191c5f3e8ac8ec2f26565d29f))
* release 0.0.1-dev.2 ([c1b981e](https://github.com/btwld/naked_ui/commit/c1b981ea029d3da7d7cd25f3197e27b049789d72))

## 0.0.1-dev.0

* Initial development release
* Core functionality for HeadlessButton component
* State management via HeadlessInteractiveStateController
* Support for interactive states (disabled, focused, hovered, pressed)
* Fully customizable rendering via builder pattern
