# Remix Component API Reference

Complete constructor parameters for every Remix component.

## Table of Contents

- [Actions](#actions): Button, IconButton
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
| `onPressed` | `VoidCallback?` | — | yes |
| `style` | `RemixButtonStyle` | `RemixButtonStyle.create()` | no |
| `styleSpec` | `RemixButtonSpec?` | `null` | no |
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

The button is disabled when `enabled == false`, `loading == true`, or `onPressed == null`. During loading, content stays laid out (invisible) with a spinner overlay to prevent layout shift.

### RemixIconButton

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `icon` | `IconData` | — | yes |
| `onPressed` | `VoidCallback?` | — | yes |
| `style` | `RemixIconButtonStyle` | `RemixIconButtonStyle.create()` | no |
| `styleSpec` | `RemixIconButtonSpec?` | `null` | no |
| `loading` | `bool` | `false` | no |
| `enableFeedback` | `bool` | `true` | no |
| `onLongPress` | `VoidCallback?` | `null` | no |
| `autofocus` | `bool` | `false` | no |
| `focusNode` | `FocusNode?` | `null` | no |
| `mouseCursor` | `MouseCursor` | `SystemMouseCursors.click` | no |
| `semanticLabel` | `String?` | `null` | no |
| `semanticHint` | `String?` | `null` | no |
| `excludeSemantics` | `bool` | `false` | no |
| `iconBuilder` | `RemixIconButtonIconBuilder?` | `null` | no |
| `loadingBuilder` | `RemixIconButtonLoadingBuilder?` | `null` | no |

No separate `enabled` parameter — disabled when `loading == true` or `onPressed == null`.

---

## Forms

### RemixCheckbox

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `selected` | `bool?` | — | yes |
| `onChanged` | `ValueChanged<bool?>?` | `null` | no |
| `style` | `RemixCheckboxStyle` | `RemixCheckboxStyle.create()` | no |
| `styleSpec` | `RemixCheckboxSpec?` | `null` | no |
| `enabled` | `bool` | `true` | no |
| `tristate` | `bool` | `false` | no |
| `autofocus` | `bool` | `false` | no |
| `checkedIcon` | `IconData` | `Icons.check_rounded` | no |
| `uncheckedIcon` | `IconData?` | `null` | no |
| `indeterminateIcon` | `IconData` | `Icons.horizontal_rule` | no |
| `enableFeedback` | `bool` | `true` | no |
| `focusNode` | `FocusNode?` | `null` | no |
| `semanticLabel` | `String?` | `null` | no |
| `mouseCursor` | `MouseCursor` | `SystemMouseCursors.click` | no |

### RemixRadioGroup\<T\>

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `groupValue` | `T?` | — | yes |
| `onChanged` | `ValueChanged<T?>` | — | yes |
| `child` | `Widget` | — | yes |

### RemixRadio\<T\>

Must be a descendant of `RemixRadioGroup<T>`.

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `value` | `T` | — | yes |
| `style` | `RemixRadioStyle` | `RemixRadioStyle.create()` | no |
| `styleSpec` | `RemixRadioSpec?` | `null` | no |
| `enabled` | `bool` | `true` | no |
| `autofocus` | `bool` | `false` | no |
| `toggleable` | `bool` | `false` | no |
| `focusNode` | `FocusNode?` | `null` | no |
| `mouseCursor` | `MouseCursor?` | `null` | no |
| `enableFeedback` | `bool` | `true` | no |

### RemixSwitch

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `selected` | `bool` | — | yes |
| `onChanged` | `ValueChanged<bool>` | — | yes |
| `style` | `RemixSwitchStyle` | `RemixSwitchStyle.create()` | no |
| `styleSpec` | `RemixSwitchSpec?` | `null` | no |
| `enabled` | `bool` | `true` | no |
| `enableFeedback` | `bool` | `true` | no |
| `focusNode` | `FocusNode?` | `null` | no |
| `autofocus` | `bool` | `false` | no |
| `semanticLabel` | `String?` | `null` | no |
| `mouseCursor` | `MouseCursor` | `SystemMouseCursors.click` | no |

### RemixSlider

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `value` | `double` | — | yes |
| `onChanged` | `ValueChanged<double>?` | — | yes |
| `style` | `RemixSliderStyle` | `RemixSliderStyle.create()` | no |
| `styleSpec` | `RemixSliderSpec?` | `null` | no |
| `min` | `double` | `0.0` | no |
| `max` | `double` | `1.0` | no |
| `enabled` | `bool` | `true` | no |
| `enableHapticFeedback` | `bool` | `true` | no |
| `focusNode` | `FocusNode?` | `null` | no |
| `autofocus` | `bool` | `false` | no |
| `snapDivisions` | `int?` | `null` | no |
| `onChangeStart` | `ValueChanged<double>?` | `null` | no |
| `onChangeEnd` | `ValueChanged<double>?` | `null` | no |

### RemixTextField

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `style` | `RemixTextFieldStyle` | `RemixTextFieldStyle.create()` | no |
| `styleSpec` | `RemixTextFieldSpec?` | `null` | no |
| `controller` | `TextEditingController?` | `null` | no |
| `focusNode` | `FocusNode?` | `null` | no |
| `label` | `String?` | `null` | no |
| `hintText` | `String?` | `null` | no |
| `helperText` | `String?` | `null` | no |
| `error` | `bool` | `false` | no |
| `leading` | `Widget?` | `null` | no |
| `trailing` | `Widget?` | `null` | no |
| `enabled` | `bool` | `true` | no |
| `readOnly` | `bool` | `false` | no |
| `obscureText` | `bool` | `false` | no |
| `maxLines` | `int?` | `1` | no |
| `minLines` | `int?` | `null` | no |
| `maxLength` | `int?` | `null` | no |
| `keyboardType` | `TextInputType?` | `null` | no |
| `textInputAction` | `TextInputAction?` | `null` | no |
| `autofocus` | `bool` | `false` | no |
| `onChanged` | `ValueChanged<String>?` | `null` | no |
| `onSubmitted` | `ValueChanged<String>?` | `null` | no |
| `onEditingComplete` | `VoidCallback?` | `null` | no |
| `inputFormatters` | `List<TextInputFormatter>?` | `null` | no |
| `autofillHints` | `Iterable<String>?` | `null` | no |
| `semanticLabel` | `String?` | `null` | no |
| `semanticHint` | `String?` | `null` | no |
| `excludeSemantics` | `bool` | `false` | no |

Sets `WidgetState.error` when `error == true`, enabling error-state styling.

### RemixSelect\<T\>

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `trigger` | `RemixSelectTrigger` | — | yes |
| `items` | `List<RemixSelectItem<T>>` | — | yes |
| `style` | `RemixSelectStyle` | `RemixSelectStyle.create()` | no |
| `selectedValue` | `T?` | `null` | no |
| `onChanged` | `ValueChanged<T?>?` | `null` | no |
| `onOpen` | `VoidCallback?` | `null` | no |
| `onClose` | `VoidCallback?` | `null` | no |
| `enabled` | `bool` | `true` | no |
| `closeOnSelect` | `bool` | `true` | no |
| `focusNode` | `FocusNode?` | `null` | no |
| `semanticLabel` | `String?` | `null` | no |
| `targetAnchor` | `Alignment?` | `null` | no |
| `followerAnchor` | `Alignment?` | `null` | no |

**RemixSelectTrigger**: `placeholder` (required), `icon` (optional).
**RemixSelectItem\<T\>**: `value` (required), `label` (required), `enabled` (default true), `style`, `semanticLabel`.

---

## Data Display

### RemixAvatar

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `style` | `RemixAvatarStyle` | `RemixAvatarStyle.create()` | no |
| `styleSpec` | `RemixAvatarSpec?` | `null` | no |
| `label` | `String?` | `null` | no |
| `icon` | `IconData?` | `null` | no |
| `backgroundImage` | `ImageProvider?` | `null` | no |
| `foregroundImage` | `ImageProvider?` | `null` | no |
| `child` | `Widget?` | `null` | no |
| `labelBuilder` | `RemixAvatarLabelBuilder?` | `null` | no |
| `iconBuilder` | `RemixAvatarIconBuilder?` | `null` | no |
| `onBackgroundImageError` | `ImageErrorListener?` | `null` | no |
| `onForegroundImageError` | `ImageErrorListener?` | `null` | no |

### RemixBadge

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `style` | `RemixBadgeStyle` | `RemixBadgeStyle.create()` | no |
| `styleSpec` | `RemixBadgeSpec?` | `null` | no |
| `label` | `String?` | `null` | no |
| `child` | `Widget?` | `null` | no |
| `labelBuilder` | `RemixBadgeLabelBuilder?` | `null` | no |

### RemixCard

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `style` | `RemixCardStyle` | `RemixCardStyle.create()` | no |
| `styleSpec` | `RemixCardSpec?` | `null` | no |
| `child` | `Widget?` | `null` | no |

### RemixCallout

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `style` | `RemixCalloutStyle` | `RemixCalloutStyle.create()` | no |
| `styleSpec` | `RemixCalloutSpec?` | `null` | no |
| `text` | `String?` | `null` | no |
| `icon` | `IconData?` | `null` | no |
| `child` | `Widget?` | `null` | no |

Either `text` or `child` must be provided.

### RemixProgress

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `value` | `double` | — | yes |
| `style` | `RemixProgressStyle` | `RemixProgressStyle.create()` | no |
| `styleSpec` | `RemixProgressSpec?` | `null` | no |

Value must be between 0.0 and 1.0.

### RemixSpinner

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `style` | `RemixSpinnerStyle` | `RemixSpinnerStyle.create()` | no |
| `styleSpec` | `RemixSpinnerSpec?` | `null` | no |

### RemixDivider

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `style` | `RemixDividerStyle` | `RemixDividerStyle.create()` | no |
| `styleSpec` | `RemixDividerSpec?` | `null` | no |

---

## Overlays

### showRemixDialog\<T\>

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `context` | `BuildContext` | — | yes |
| `builder` | `WidgetBuilder` | — | yes |
| `barrierColor` | `Color?` | `Colors.black54` | no |
| `barrierDismissible` | `bool` | `true` | no |
| `transitionDuration` | `Duration` | `400ms` | no |
| `transitionBuilder` | `RouteTransitionsBuilder?` | `null` | no |
| `useRootNavigator` | `bool` | `true` | no |
| `routeSettings` | `RouteSettings?` | `null` | no |
| `requestFocus` | `bool` | `true` | no |

### RemixDialog

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `style` | `RemixDialogStyle` | `RemixDialogStyle.create()` | no |
| `title` | `String?` | `null` | no |
| `description` | `String?` | `null` | no |
| `actions` | `List<Widget>?` | `null` | no |
| `child` | `Widget?` | `null` | no |
| `modal` | `bool` | `true` | no |
| `semanticLabel` | `String?` | `null` | no |

At least one of `child`, `title`, or `description` must be provided.

### RemixTooltip

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `tooltipChild` | `Widget` | — | yes |
| `child` | `Widget` | — | yes |
| `style` | `RemixTooltipStyle` | `RemixTooltipStyle.create()` | no |
| `styleSpec` | `RemixTooltipSpec?` | `null` | no |
| `tooltipSemantics` | `String?` | `null` | no |

`tooltipChild` is the tooltip content; `child` is the widget that triggers the tooltip on hover.

### RemixMenu\<T\>

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `trigger` | `RemixMenuTrigger` | — | yes |
| `items` | `List<RemixMenuItemData<T>>` | — | yes |
| `style` | `RemixMenuStyle` | `RemixMenuStyle.create()` | no |
| `controller` | `MenuController?` | `null` | no |
| `onSelected` | `ValueChanged<T>?` | `null` | no |
| `onOpen` | `VoidCallback?` | `null` | no |
| `onClose` | `VoidCallback?` | `null` | no |
| `consumeOutsideTaps` | `bool` | `true` | no |
| `closeOnClickOutside` | `bool` | `true` | no |
| `useRootOverlay` | `bool` | `false` | no |
| `positioning` | `OverlayPositionConfig` | `OverlayPositionConfig()` | no |
| `triggerFocusNode` | `FocusNode?` | `null` | no |

**RemixMenuTrigger**: `label` (required), `icon` (optional).
**RemixMenuItem\<T\>**: `value` (required), `label` (required), `leadingIcon`, `trailingIcon`, `enabled` (default true), `closeOnActivate` (default true), `semanticLabel`, `style`.
**RemixMenuDivider\<T\>**: No fields, visual separator.

---

## Navigation

### RemixTabs

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
| `style` | `RemixTabBarStyle` | `RemixTabBarStyle.create()` | no |

### RemixTab

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `tabId` | `String` | — | yes |
| `label` | `String?` | `null` | \* |
| `icon` | `IconData?` | `null` | no |
| `child` | `Widget?` | `null` | \* |
| `builder` | `ValueWidgetBuilder<NakedTabState>?` | `null` | \* |
| `style` | `RemixTabStyle` | `RemixTabStyle.create()` | no |
| `enabled` | `bool` | `true` | no |
| `autofocus` | `bool` | `false` | no |
| `mouseCursor` | `MouseCursor` | `SystemMouseCursors.click` | no |
| `enableFeedback` | `bool` | `true` | no |
| `focusNode` | `FocusNode?` | `null` | no |
| `semanticLabel` | `String?` | `null` | no |

\* At least one of `child`, `builder`, or `label` must be provided.

### RemixTabView

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `tabId` | `String` | — | yes |
| `child` | `Widget` | — | yes |
| `style` | `RemixTabViewStyle` | `RemixTabViewStyle.create()` | no |

### RemixAccordionGroup\<T\>

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `controller` | `RemixAccordionController<T>` | — | yes |
| `child` | `Widget` | — | yes |
| `initialExpandedValues` | `List<T>` | `[]` | no |

### RemixAccordion\<T\>

| Parameter | Type | Default | Required |
|-----------|------|---------|----------|
| `value` | `T` | — | yes |
| `child` | `Widget` | — | yes |
| `title` | `String?` | `null` | \* |
| `builder` | `NakedAccordionTriggerBuilder<T>?` | `null` | \* |
| `style` | `RemixAccordionStyle` | `RemixAccordionStyle.create()` | no |
| `leadingIcon` | `IconData?` | `null` | no |
| `trailingIcon` | `IconData?` | `null` | no |
| `enabled` | `bool` | `true` | no |
| `mouseCursor` | `MouseCursor` | `SystemMouseCursors.click` | no |
| `enableFeedback` | `bool` | `true` | no |
| `autofocus` | `bool` | `false` | no |
| `focusNode` | `FocusNode?` | `null` | no |
| `semanticLabel` | `String?` | `null` | no |
| `transitionBuilder` | `Widget Function(Widget, Animation<double>)` | fade + size | no |

\* Either `title` or `builder` must be provided.
