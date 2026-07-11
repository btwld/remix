# Remix Component API Reference

Constructor parameters for every Remix component, verified against
`packages/remix/lib/src/components/`.

Shared contract for every leaf `Remix*` widget:

- `style` — a `Remix*Styler` (defaults to `const Remix*Styler.create()`).
- `styleSpec` — an optional raw `Remix*Spec?` that bypasses style resolution.
- `static final styleFrom = Remix*Styler.new` — tear-off convenience for
  building a styler.

The tables below list the component-specific parameters; `style`/`styleSpec`
are omitted from each table since they are universal.

## Table of Contents

- [Actions](#actions): Button, IconButton, Toggle
- [Forms](#forms): Checkbox, Radio, Switch, Slider, TextField, Select
- [Data Display](#data-display): Avatar, Badge, Card, Callout, Progress, Spinner, Divider
- [Overlays](#overlays): Dialog, Tooltip, Menu
- [Navigation](#navigation): Tabs, Accordion

---

## Actions

### RemixButton

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `label` | `String` | — | yes |
| `onPressed` | `VoidCallback?` | `null` | no |
| `leadingIcon` | `IconData?` | `null` | no |
| `trailingIcon` | `IconData?` | `null` | no |
| `loading` | `bool` | `false` | no |
| `enabled` | `bool` | `true` | no |
| `onLongPress` | `VoidCallback?` | `null` | no |
| `autofocus` | `bool` | `false` | no |
| `enableFeedback` | `bool` | `true` | no |
| `focusNode` | `FocusNode?` | `null` | no |
| `mouseCursor` | `MouseCursor` | `SystemMouseCursors.click` | no |
| `semanticLabel` | `String?` | `null` | no |
| `semanticHint` | `String?` | `null` | no |
| `excludeSemantics` | `bool` | `false` | no |
| `textBuilder` | `RemixButtonTextBuilder?` | `null` | no |
| `leadingIconBuilder` | `RemixButtonIconBuilder?` | `null` | no |
| `trailingIconBuilder` | `RemixButtonIconBuilder?` | `null` | no |
| `loadingBuilder` | `RemixButtonLoadingBuilder?` | `null` | no |

Effective enabled state is `enabled && !loading && onPressed != null`. During
loading, content stays laid out (invisible) with a spinner overlay to prevent
layout shift.

Fortal preset: `FortalButton` — all params above plus
`variant` (`solid|soft|surface|outline|ghost`) and `size` (`size1–size4`).

### RemixIconButton

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `icon` | `IconData` | — | yes |
| `onPressed` | `VoidCallback?` | `null` | no |
| `loading` | `bool` | `false` | no |
| `enabled` | `bool` | `true` | no |
| `onLongPress` | `VoidCallback?` | `null` | no |
| `autofocus` | `bool` | `false` | no |
| `enableFeedback` | `bool` | `true` | no |
| `focusNode` | `FocusNode?` | `null` | no |
| `mouseCursor` | `MouseCursor` | `SystemMouseCursors.click` | no |
| `semanticLabel` | `String?` | `null` | no |
| `semanticHint` | `String?` | `null` | no |
| `excludeSemantics` | `bool` | `false` | no |
| `iconBuilder` | `RemixIconButtonIconBuilder?` | `null` | no |
| `loadingBuilder` | `RemixIconButtonLoadingBuilder?` | `null` | no |

Fortal preset: `FortalIconButton` — `variant` (`solid|soft|surface|outline|ghost`),
`size` (`size1–size4`). **Caveat:** `FortalIconButton` forwards only `icon`,
`onPressed`, `loading`, `enabled`, `enableFeedback`, `focusNode`. For
`onLongPress`, semantics, builders, etc., use
`RemixIconButton(style: fortalIconButtonStyler(variant: …, size: …), …)`.

### RemixToggle

A pressable button that stays visually active while selected (unlike
`RemixSwitch`, which is a sliding on/off control).

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `selected` | `bool` | — | yes |
| `onChanged` | `ValueChanged<bool>?` | `null` | no |
| `label` | `String?` | `null` | \* |
| `icon` | `IconData?` | `null` | \* |
| `enabled` | `bool` | `true` | no |
| `enableFeedback` | `bool` | `true` | no |
| `focusNode` | `FocusNode?` | `null` | no |
| `autofocus` | `bool` | `false` | no |
| `semanticLabel` | `String?` | `null` | no |
| `mouseCursor` | `MouseCursor` | `SystemMouseCursors.click` | no |

\* At least one of `label` or `icon` must be provided.

Fortal preset: `FortalToggle` — `variant` (`ghost|outline`), `size` (`size1–size3`).

---

## Forms

### RemixCheckbox

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `selected` | `bool?` | — | yes |
| `onChanged` | `ValueChanged<bool?>?` | `null` | no |
| `enabled` | `bool` | `true` | no |
| `tristate` | `bool` | `false` | no |
| `checkedIcon` | `IconData` | `Icons.check_rounded` | no |
| `uncheckedIcon` | `IconData?` | `null` | no |
| `indeterminateIcon` | `IconData` | `Icons.horizontal_rule` | no |
| `autofocus` | `bool` | `false` | no |
| `enableFeedback` | `bool` | `true` | no |
| `focusNode` | `FocusNode?` | `null` | no |
| `semanticLabel` | `String?` | `null` | no |
| `mouseCursor` | `MouseCursor` | `SystemMouseCursors.click` | no |

Fortal preset: `FortalCheckbox` — `variant` (`surface|soft`), `size` (`size1–size3`).

### RemixRadioGroup\<T\>

Purely behavioral — no `style`/`styleSpec`; each `RemixRadio` is styled
individually.

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `groupValue` | `T?` | — | yes |
| `onChanged` | `ValueChanged<T?>?` | `null` | no (null disables the group) |
| `child` | `Widget` | — | yes |

### RemixRadio\<T\>

Must be a descendant of `RemixRadioGroup<T>` (throws otherwise).

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `value` | `T` | — | yes |
| `enabled` | `bool` | `true` | no |
| `toggleable` | `bool` | `false` | no |
| `autofocus` | `bool` | `false` | no |
| `focusNode` | `FocusNode?` | `null` | no |
| `mouseCursor` | `MouseCursor?` | `null` | no |

Fortal preset: `FortalRadio<T>` — `variant` (`surface|soft`), `size`
(`size1–size3`). Still must sit inside a `RemixRadioGroup<T>`.

### RemixSwitch

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `selected` | `bool` | — | yes |
| `onChanged` | `ValueChanged<bool>?` | `null` | no |
| `enabled` | `bool` | `true` | no |
| `enableFeedback` | `bool` | `true` | no |
| `focusNode` | `FocusNode?` | `null` | no |
| `autofocus` | `bool` | `false` | no |
| `semanticLabel` | `String?` | `null` | no |
| `mouseCursor` | `MouseCursor` | `SystemMouseCursors.click` | no |

Fortal preset: `FortalSwitch` — `variant` (`surface|soft`), `size` (`size1–size3`).

### RemixSlider

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `value` | `double` | — | yes (must be within `min..max`) |
| `onChanged` | `ValueChanged<double>?` | `null` | no |
| `min` | `double` | `0.0` | no |
| `max` | `double` | `1.0` | no |
| `enabled` | `bool` | `true` | no |
| `enableFeedback` | `bool` | `true` | no |
| `focusNode` | `FocusNode?` | `null` | no |
| `autofocus` | `bool` | `false` | no |
| `snapDivisions` | `int?` | `null` | no |
| `onChangeStart` | `ValueChanged<double>?` | `null` | no |
| `onChangeEnd` | `ValueChanged<double>?` | `null` | no |

Fortal preset: `FortalSlider` — `variant` (`surface|soft`), `size` (`size1–size3`).

### RemixTextField

Remix-specific parameters:

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `controller` | `TextEditingController?` | `null` | no |
| `label` | `String?` | `null` | no |
| `hintText` | `String?` | `null` | no |
| `helperText` | `String?` | `null` | no |
| `error` | `bool` | `false` | no |
| `leading` | `Widget?` | `null` | no |
| `trailing` | `Widget?` | `null` | no |
| `enabled` | `bool` | `true` | no |
| `semanticLabel` | `String?` | `null` | no |
| `semanticHint` | `String?` | `null` | no |
| `excludeSemantics` | `bool` | `false` | no |

Plus the standard Flutter text-input surface, passed through: `focusNode`,
`keyboardType`, `textInputAction`, `textCapitalization`, `textDirection`,
`readOnly`, `showCursor`, `autofocus`, `obscureText`, `obscuringCharacter`,
`autocorrect`, `enableSuggestions`, `smartDashesType`, `smartQuotesType`,
`maxLines` (default `1`), `minLines`, `expands`, `maxLength`,
`maxLengthEnforcement`, `onChanged`, `onEditingComplete`, `onSubmitted`,
`onAppPrivateCommand`, `inputFormatters`, `dragStartBehavior`,
`enableInteractiveSelection`, `selectionControls`, `onTapOutside`,
`onPressUpOutside`, `onTapAlwaysCalled`, `scrollController`, `scrollPhysics`,
`autofillHints`, `contentInsertionConfiguration`, `clipBehavior`,
`restorationId`, `stylusHandwritingEnabled`,
`enableIMEPersonalizedLearning`, `contextMenuBuilder`,
`spellCheckConfiguration`, `magnifierConfiguration`, `canRequestFocus`,
`ignorePointers`, `undoController`, `groupId`.

Sets `WidgetState.error` when `error == true`, enabling error-state styling.

Fortal preset: `FortalTextField` — mirrors the entire param list plus
`variant` (`surface|soft`), `size` (`size1–size3`).

### RemixSelect\<T\>

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `trigger` | `RemixSelectTrigger` | — | yes |
| `items` | `List<RemixSelectItem<T>>` | — | yes |
| `selectedValue` | `T?` | `null` | no |
| `onChanged` | `ValueChanged<T?>?` | `null` | no |
| `onOpen` / `onClose` | `VoidCallback?` | `null` | no |
| `enabled` | `bool` | `true` | no |
| `closeOnSelect` | `bool` | `true` | no |
| `focusNode` | `FocusNode?` | `null` | no |
| `semanticLabel` | `String?` | `null` | no |
| `positioning` | `OverlayPositionConfig` | `bottomCenter/topCenter anchors` | no |

`RemixSelectTrigger` and `RemixSelectItem<T>` are **data classes**, not
widgets:

- **RemixSelectTrigger**: `placeholder` (required), `icon` (optional).
- **RemixSelectItem\<T\>**: `value` (required), `label` (required),
  `enabled` (default true), `style` (a `RemixSelectMenuItemStyler`),
  `semanticLabel`.

Fortal preset: `FortalSelect<T>` — `variant` (`surface|soft|ghost`), `size`
(`size1–size3`). **Caveat:** it styles only the trigger and menu container;
set each item's `style: fortalSelectMenuItemStyler(variant: …, size: …)`
yourself or items render unstyled.

---

## Data Display

### RemixAvatar

Purely presentational — no interaction params. Content precedence:
`child` > `labelBuilder`/`label` > `iconBuilder`/`icon`.

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `label` | `String?` | `null` | no |
| `icon` | `IconData?` | `null` | no |
| `backgroundImage` | `ImageProvider?` | `null` | no |
| `foregroundImage` | `ImageProvider?` | `null` | no |
| `child` | `Widget?` | `null` | no |
| `labelBuilder` | `RemixAvatarLabelBuilder?` | `null` | no |
| `iconBuilder` | `RemixAvatarIconBuilder?` | `null` | no |
| `onBackgroundImageError` | `ImageErrorListener?` | `null` | no |
| `onForegroundImageError` | `ImageErrorListener?` | `null` | no |

Fortal preset: `FortalAvatar` — `variant` (`soft|solid`), `size`
(`size1–size4`, 24/32/40/64 px).

### RemixBadge

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `label` | `String?` | `null` | no |
| `child` | `Widget?` | `null` | no |
| `labelBuilder` | `RemixBadgeLabelBuilder?` | `null` | no |

Fortal preset: `FortalBadge` — `variant` (`solid|soft|surface|outline`),
`size` (`size1–size3`).

### RemixCard

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `child` | `Widget?` | `null` | no |

Fortal preset: `FortalCard` — `variant` (`surface|classic|ghost`), `size`
(`size1–size3`).

### RemixCallout

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `text` | `String?` | `null` | \* |
| `icon` | `IconData?` | `null` | no |
| `child` | `Widget?` | `null` | \* |

\* Either `text` or `child` must be provided.

Fortal preset: `FortalCallout` — `variant` (`outline|surface|soft`), `size`
(`size1–size3`).

### RemixProgress

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `value` | `double` | — | yes (0.0–1.0) |

Fortal preset: `FortalProgress` — `variant` (`surface|soft`), `size`
(`size1–size3`, 4/8/12 px height).

### RemixSpinner

Only `style`/`styleSpec`. The spec carries `size`, `strokeWidth`,
`indicatorColor`, `trackColor`, `trackStrokeWidth`, `duration`.

Fortal preset: `FortalSpinner` — `size` only (`size1–size3`), no variant.

### RemixDivider

Only `style`/`styleSpec`.

Fortal preset: `FortalDivider` — `size` only (`size1–size3`, 1/2/3 px
thickness), no variant.

---

## Overlays

### showRemixDialog\<T\>

The only `showRemix*` helper in the package. It wraps `showNakedDialog` and
re-injects the current `MixScope` tokens into the dialog route.

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `context` | `BuildContext` | — | yes |
| `builder` | `WidgetBuilder` | — | yes |
| `barrierColor` | `Color?` | `null` | no |
| `barrierDismissible` | `bool` | `true` | no |
| `barrierLabel` | `String?` | `null` | no |
| `transitionDuration` | `Duration` | `400ms` | no |
| `transitionBuilder` | `RouteTransitionsBuilder?` | `null` | no |
| `useRootNavigator` | `bool` | `true` | no |
| `routeSettings` | `RouteSettings?` | `null` | no |
| `anchorPoint` | `Offset?` | `null` | no |
| `requestFocus` | `bool` | `true` | no |
| `traversalEdgeBehavior` | `TraversalEdgeBehavior?` | `null` | no |

### RemixDialog

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `title` | `String?` | `null` | \* |
| `description` | `String?` | `null` | \* |
| `child` | `Widget?` | `null` | \* |
| `actions` | `List<Widget>?` | `null` | no |
| `modal` | `bool` | `true` | no |
| `semanticLabel` | `String?` | `null` | no |

\* At least one of `child`, `title`, or `description` must be provided.
Content renders in the order title → description → child → actions.

Fortal preset: `FortalDialog` — same params, no variant/size (single style).

### RemixTooltip

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `tooltipChild` | `Widget` | — | yes (overlay content) |
| `child` | `Widget` | — | yes (trigger) |
| `tooltipSemantics` | `String?` | `null` | no |
| `positioning` | `OverlayPositionConfig` | `OverlayPositionConfig()` | no |

Spec timing defaults: `waitDuration` 300ms (hover delay), `showDuration`
1500ms (touch long-press), `dismissDuration` 100ms (hover-exit grace).

Fortal preset: `FortalTooltip` — same params, no variant/size.

### RemixMenu\<T\>

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `trigger` | `RemixMenuTrigger` | — | yes |
| `items` | `List<RemixMenuItemData<T>>` | — | yes |
| `controller` | `MenuController?` | auto-created | no |
| `onSelected` | `ValueChanged<T>?` | `null` | no |
| `onOpen` / `onClose` / `onCanceled` | `VoidCallback?` | `null` | no |
| `onOpenRequested` / `onCloseRequested` | `RawMenuAnchor*Callback?` | `null` | no |
| `consumeOutsideTaps` | `bool` | `true` | no |
| `closeOnClickOutside` | `bool` | `true` | no |
| `useRootOverlay` | `bool` | `false` | no |
| `positioning` | `OverlayPositionConfig` | `OverlayPositionConfig()` | no |
| `triggerFocusNode` | `FocusNode?` | `null` | no |

`RemixMenuTrigger` and item entries are **data classes**, not widgets:

- **RemixMenuTrigger**: `label` (required), `icon` (optional).
- **RemixMenuItem\<T\>**: `value` (required), `label` (required),
  `leadingIcon`, `trailingIcon`, `enabled` (default true), `closeOnActivate`
  (default true), `semanticLabel`, `style`.
- **RemixMenuDivider\<T\>**: no fields, visual separator.

Fortal preset: `FortalMenu<T>` — `variant` (`solid|soft`), `size`
(`size1–size2`). Unlike Select, `fortalMenuStyler` already bakes in the
matching item styler — no per-item `style` wiring needed.

---

## Navigation

### RemixTabs

Behavioral root — no `style`/`styleSpec`. There is no `FortalTabs`; use
`RemixTabs` directly.

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `child` | `Widget` | — | yes |
| `selectedTabId` | `String?` | `null` | \* |
| `controller` | `NakedTabController?` | `null` | \* |
| `onChanged` | `ValueChanged<String>?` | `null` | no |
| `orientation` | `Axis` | `Axis.horizontal` | no |
| `enabled` | `bool` | `true` | no |
| `onEscapePressed` | `VoidCallback?` | `null` | no |

\* Either `controller` or `selectedTabId` must be provided.

### RemixTabBar

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `child` | `Widget` | — | yes |

Fortal preset: `FortalTabBar` — no variant/size.

### RemixTab

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `tabId` | `String` | — | yes |
| `label` | `String?` | `null` | \* |
| `icon` | `IconData?` | `null` | no |
| `child` | `Widget?` | `null` | \* |
| `builder` | `ValueWidgetBuilder<NakedTabState>?` | `null` | \* |
| `enabled` | `bool` | `true` | no |
| `autofocus` | `bool` | `false` | no |
| `mouseCursor` | `MouseCursor` | `SystemMouseCursors.click` | no |
| `enableFeedback` | `bool` | `true` | no |
| `focusNode` | `FocusNode?` | `null` | no |
| `onFocusChange` / `onHoverChange` / `onPressChange` | callbacks | `null` | no |
| `semanticLabel` | `String?` | `null` | no |

\* At least one of `child`, `builder`, or `label` must be provided.

Fortal preset: `FortalTab` — no variant/size.

### RemixTabView

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `tabId` | `String` | — | yes |
| `child` | `Widget` | — | yes |

Fortal preset: `FortalTabView` — no variant/size.

### RemixAccordionGroup\<T\>

Purely behavioral — no `style`/`styleSpec`. `controller` is **required**
(unlike Tabs/Menu, no auto-created default):
`RemixAccordionController<String>(min: 0, max: 1)`.
(`RemixAccordionController<T>` is a typedef for `NakedAccordionController<T>`.)

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `controller` | `RemixAccordionController<T>` | — | yes |
| `child` | `Widget` | — | yes |
| `initialExpandedValues` | `List<T>` | `[]` | no |

### RemixAccordion\<T\>

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `value` | `T` | — | yes |
| `child` | `Widget` | — | yes (panel content) |
| `title` | `String?` | `null` | \* |
| `builder` | `NakedAccordionTriggerBuilder<T>?` | `null` | \* |
| `leadingIcon` / `trailingIcon` | `IconData?` | `null` | no |
| `enabled` | `bool` | `true` | no |
| `mouseCursor` | `MouseCursor` | `SystemMouseCursors.click` | no |
| `enableFeedback` | `bool` | `true` | no |
| `autofocus` | `bool` | `false` | no |
| `focusNode` | `FocusNode?` | `null` | no |
| `onFocusChange` / `onHoverChange` / `onPressChange` | callbacks | `null` | no |
| `semanticLabel` | `String?` | `null` | no |
| `transitionBuilder` | `Widget Function(Widget, Animation<double>)` | fade + size | no |

\* Either `title` or `builder` must be provided.

Fortal preset: `FortalAccordion<T>` — `variant` (`surface|soft`), `size`
(`size1–size3`).
