# Fortal Theme Reference

Complete reference for the Fortal design system — variants, sizes, and tokens.

## Table of Contents

- [Component Variants & Sizes](#component-variants--sizes)
- [Color Tokens](#color-tokens)
- [Space Tokens](#space-tokens)
- [Radius Tokens](#radius-tokens)
- [Typography Tokens](#typography-tokens)
- [Shadow Tokens](#shadow-tokens)
- [Border & Focus Tokens](#border--focus-tokens)
- [Animation Tokens](#animation-tokens)
- [Font Weight Tokens](#font-weight-tokens)

---

## Component Variants & Sizes

Use generated `Fortal*` widgets for standard Fortal UI. The matching `fortal*Styler` functions remain available for custom raw `Remix*` compositions.

### Button — `FortalButton`

Variants: `solid`, `soft`, `surface`, `outline`, `ghost`.
Sizes: `size1`, `size2`, `size3`, `size4`.

```dart
FortalButton(label: 'Save', variant: .solid, size: .size2)
FortalButton(label: 'Cancel', variant: .outline)
```

Custom styler: `fortalButtonStyler(variant: .solid, size: .size2)`.

### IconButton — `FortalIconButton`

Variants: `solid`, `soft`, `surface`, `outline`, `ghost`.
Sizes: `size1`, `size2`, `size3`, `size4`.

```dart
FortalIconButton(icon: Icons.add, variant: .solid, size: .size2)
FortalIconButton(icon: Icons.settings, variant: .ghost)
```

Custom styler: `fortalIconButtonStyler(variant: .ghost, size: .size2)`.

### Checkbox — `FortalCheckbox`

Variants: `surface`, `soft`. Sizes: `size1`, `size2`, `size3`.

```dart
FortalCheckbox(selected: accepted, variant: .surface, size: .size2)
```

Custom styler: `fortalCheckboxStyler(variant: .surface, size: .size2)`.

### Radio — `FortalRadio`

Variants: `surface`, `soft`. Sizes: `size1`, `size2`, `size3`.

```dart
FortalRadio<String>(value: 'email', variant: .surface, size: .size2)
```

Custom styler: `fortalRadioStyler(variant: .surface, size: .size2)`.

### Switch — `FortalSwitch`

Variants: `surface`, `soft`. Sizes: `size1`, `size2`, `size3`.

```dart
FortalSwitch(selected: enabled, variant: .soft, size: .size2)
```

Custom styler: `fortalSwitchStyler(variant: .soft, size: .size2)`.

### Slider — `FortalSlider`

Variants: `surface`, `soft`. Sizes: `size1`, `size2`, `size3`.

```dart
FortalSlider(value: progress, variant: .surface, size: .size2)
```

Custom styler: `fortalSliderStyler(variant: .surface, size: .size2)`.

### TextField — `FortalTextField`

Variants: `surface`, `soft`. Sizes: `size1`, `size2`, `size3`.

```dart
FortalTextField(label: 'Email', variant: .surface, size: .size2)
```

Custom styler: `fortalTextFieldStyler(variant: .surface, size: .size2)`.

### Select — `FortalSelect`

Variants: `surface`, `soft`, `ghost`. Sizes: `size1`, `size2`, `size3`.

```dart
final itemStyle = fortalSelectMenuItemStyler(variant: .surface, size: .size2);

FortalSelect<String>(
  variant: .surface,
  size: .size2,
  trigger: RemixSelectTrigger(placeholder: 'Choose one'),
  items: [
    RemixSelectItem(value: 'a', label: 'A', style: itemStyle),
  ],
)
```

`FortalSelect` styles the trigger and menu container. Item rows are `RemixSelectItem` data objects; use `fortalSelectMenuItemStyler` for matching item styling.

Custom styler: `fortalSelectStyler(variant: .surface, size: .size2)`.

### Badge — `FortalBadge`

Variants: `solid`, `soft`, `surface`, `outline`. Sizes: `size1`, `size2`, `size3`.

```dart
FortalBadge(label: 'New', variant: .solid, size: .size2)
```

Custom styler: `fortalBadgeStyler(variant: .solid, size: .size2)`.

### Avatar — `FortalAvatar`

Variants: `soft`, `solid`. Sizes: `size1`, `size2`, `size3`, `size4`.

```dart
FortalAvatar(label: 'LF', variant: .soft, size: .size3)
```

Custom styler: `fortalAvatarStyler(variant: .soft, size: .size3)`.

### Card — `FortalCard`

Variants: `surface`, `classic`, `ghost`. Sizes: `size1`, `size2`, `size3`.

```dart
FortalCard(variant: .surface, size: .size2, child: Text('Content'))
```

Custom styler: `fortalCardStyler(variant: .surface, size: .size2)`.

### Callout — `FortalCallout`

Variants: `outline`, `surface`, `soft`. Sizes: `size1`, `size2`, `size3`.

```dart
FortalCallout(text: 'Heads up', variant: .surface, size: .size2)
```

Custom styler: `fortalCalloutStyler(variant: .surface, size: .size2)`.

### Progress — `FortalProgress`

Variants: `surface`, `soft`. Sizes: `size1`, `size2`, `size3`.

```dart
FortalProgress(value: 0.65, variant: .surface, size: .size2)
```

Custom styler: `fortalProgressStyler(variant: .surface, size: .size2)`.

### Spinner — `FortalSpinner`

No variants. Sizes: `size1`, `size2`, `size3`.

```dart
FortalSpinner(size: .size2)
```

Custom styler: `fortalSpinnerStyler(size: .size2)`.

### Divider — `FortalDivider`

No variants. Sizes: `size1`, `size2`, `size3`.

```dart
FortalDivider(size: .size1)
```

Custom styler: `fortalDividerStyler(size: .size1)`.

### Accordion — `FortalAccordion`

Variants: `surface`, `soft`. Sizes: `size1`, `size2`, `size3`.

```dart
FortalAccordion<String>(
  value: 'item',
  title: 'Question',
  variant: .surface,
  size: .size2,
  child: Text('Answer'),
)
```

Custom styler: `fortalAccordionStyler(variant: .surface, size: .size2)`.

### Menu — `FortalMenu`

Variants: `solid`, `soft`. Sizes: `size1`, `size2`.

```dart
FortalMenu<String>(
  variant: .solid,
  size: .size2,
  trigger: RemixMenuTrigger(label: 'Actions', icon: Icons.more_vert),
  items: [
    RemixMenuItem(value: 'edit', label: 'Edit'),
  ],
)
```

Custom stylers: `fortalMenuStyler(variant: .solid, size: .size2)` and `fortalMenuItemStyler(variant: .solid, size: .size2)`.

### Tabs — `FortalTabBar`, `FortalTab`, `FortalTabView`

No variants, no sizes.

```dart
FortalTabBar(
  child: Row(children: [
    FortalTab(tabId: 'overview', label: 'Overview'),
  ]),
)
FortalTabView(tabId: 'overview', child: OverviewPanel())
```

Custom stylers: `fortalTabBarStyler()`, `fortalTabStyler()`, `fortalTabViewStyler()`.

### Tooltip — `FortalTooltip`

No variants, no sizes.

```dart
FortalTooltip(
  tooltipChild: Text('Help text'),
  child: Icon(Icons.help),
)
```

Custom styler: `fortalTooltipStyler()`.

### Dialog — `FortalDialog`

No variants, no sizes.

```dart
FortalDialog(title: 'Confirm', description: 'Save changes?')
```

Custom styler: `fortalDialogStyler()`.

---

## Color Tokens

### Accent Scale (12 steps)

| Token | Semantic Role |
|-------|---------------|
| `FortalTokens.accent1` | App background (subtle) |
| `FortalTokens.accent2` | Subtle component background |
| `FortalTokens.accent3` | Component background (rest) |
| `FortalTokens.accent4` | Component background (hover) |
| `FortalTokens.accent5` | Component background (active) |
| `FortalTokens.accent6` | Subtle border |
| `FortalTokens.accent7` | Component border |
| `FortalTokens.accent8` | Border (hover) |
| `FortalTokens.accent9` | Solid background (default) |
| `FortalTokens.accent10` | Solid background (hover) |
| `FortalTokens.accent11` | Low-contrast text |
| `FortalTokens.accent12` | High-contrast text |

### Gray Scale (12 steps)

Same semantic structure: `FortalTokens.gray1` through `FortalTokens.gray12`.

### Alpha Variants

- Accent alpha: `FortalTokens.accentA1` through `FortalTokens.accentA12`
- Gray alpha: `FortalTokens.grayA1` through `FortalTokens.grayA12`
- Black alpha: `FortalTokens.blackA3`, `blackA4`, `blackA5`, `blackA6`, `blackA7`, `blackA11`

### Functional Colors

| Token | Role |
|-------|------|
| `FortalTokens.colorBackground` | Page background (gray1) |
| `FortalTokens.colorSurface` | Input/control surface |
| `FortalTokens.colorPanelSolid` | Solid panel (gray2) |
| `FortalTokens.colorPanelTranslucent` | Translucent panel with alpha |
| `FortalTokens.colorOverlay` | Dark overlay for modals |
| `FortalTokens.accentSurface` | Subtle accent (soft buttons) |
| `FortalTokens.accentIndicator` | Active indicator (sliders, progress) |
| `FortalTokens.accentTrack` | Track background |
| `FortalTokens.accentContrast` | High-contrast text on accent solid |
| `FortalTokens.graySurface` | Neutral surface |
| `FortalTokens.grayIndicator` | Neutral indicator |
| `FortalTokens.grayTrack` | Neutral track |
| `FortalTokens.grayContrast` | Text on neutral solid (white) |
| `FortalTokens.focus8` | Solid focus ring |
| `FortalTokens.focusA8` | Translucent focus ring |
| `FortalTokens.shadowStroke` | Shadow stroke blend |

---

## Space Tokens

| Token | Value |
|-------|-------|
| `FortalTokens.space1` | 4px |
| `FortalTokens.space2` | 8px |
| `FortalTokens.space3` | 12px |
| `FortalTokens.space4` | 16px |
| `FortalTokens.space5` | 24px |
| `FortalTokens.space6` | 32px |
| `FortalTokens.space7` | 40px |
| `FortalTokens.space8` | 48px |
| `FortalTokens.space9` | 64px |

---

## Radius Tokens

| Token | Value |
|-------|-------|
| `FortalTokens.radius1` | 3px |
| `FortalTokens.radius2` | 4px |
| `FortalTokens.radius3` | 6px |
| `FortalTokens.radius4` | 8px |
| `FortalTokens.radius5` | 12px |
| `FortalTokens.radius6` | 16px |
| `FortalTokens.radiusFull` | 9999px (pill shape) |

---

## Typography Tokens

| Token | Size | Line Height | Letter Spacing |
|-------|------|-------------|----------------|
| `FortalTokens.text1` | 12px | 1.33 | +0.0025em |
| `FortalTokens.text2` | 14px | 1.43 | 0 |
| `FortalTokens.text3` | 16px | 1.50 | 0 |
| `FortalTokens.text4` | 18px | 1.44 | -0.0025em |
| `FortalTokens.text5` | 20px | 1.40 | -0.005em |
| `FortalTokens.text6` | 24px | 1.25 | -0.00625em |
| `FortalTokens.text7` | 28px | 1.29 | -0.0075em |
| `FortalTokens.text8` | 35px | 1.14 | -0.01em |
| `FortalTokens.text9` | 60px | 1.00 | -0.025em |

---

## Shadow Tokens

| Token | Description |
|-------|-------------|
| `FortalTokens.shadow1` | Minimal shadow (1 layer) |
| `FortalTokens.shadow2` | Light shadow (2 layers) |
| `FortalTokens.shadow3` | Medium shadow |
| `FortalTokens.shadow4` | Prominent shadow |
| `FortalTokens.shadow5` | Heavy shadow |
| `FortalTokens.shadow6` | Maximum elevation |

---

## Border & Focus Tokens

| Token | Value |
|-------|-------|
| `FortalTokens.borderWidth1` | 1px |
| `FortalTokens.borderWidth2` | 2px |
| `FortalTokens.focusRingWidth` | 2px |
| `FortalTokens.focusRingOffset` | 2px |

---

## Animation Tokens

| Token | Value |
|-------|-------|
| `FortalTokens.transitionFast` | 100ms |
| `FortalTokens.transitionSlow` | 300ms |

---

## Font Weight Tokens

| Token | Value |
|-------|-------|
| `FortalTokens.fontWeightLight` | w300 |
| `FortalTokens.fontWeightRegular` | w400 |
| `FortalTokens.fontWeightMedium` | w500 |
| `FortalTokens.fontWeightBold` | w700 |
