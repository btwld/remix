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

### Button — `FortalButtonStyle`

| Variant | Description |
|---------|-------------|
| `solid` | Filled accent background, high contrast text |
| `soft` | Subtle accent surface, accent text |
| `surface` | Neutral surface with accent border |
| `outline` | Transparent with accent border |
| `ghost` | Transparent, accent text only |

| Size | Font | Radius | Padding |
|------|------|--------|---------|
| `size1` | 12px (text1) | radius2 | compact |
| `size2` | 14px (text2) | radius3 | default |
| `size3` | 16px (text3) | radius4 | spacious |
| `size4` | 18px (text4) | radius5 | large |

```dart
FortalButtonStyle.create(variant: FortalButtonVariant.solid, size: FortalButtonSize.size2)
FortalButtonStyle.solid()
FortalButtonStyle.soft(size: FortalButtonSize.size3)
FortalButtonStyle.outline()
FortalButtonStyle.surface()
FortalButtonStyle.ghost()
```

### IconButton — `FortalIconButtonStyle`

Same variants as Button: `solid`, `soft`, `surface`, `outline`, `ghost`.

| Size | Dimensions | Icon | Radius |
|------|-----------|------|--------|
| `size1` | 24×24 | 12px | radius2 |
| `size2` | 32×32 | 16px | radius3 |
| `size3` | 40×40 | 20px | radius4 |
| `size4` | 48×48 | 24px | radius5 |

```dart
FortalIconButtonStyle.create(variant: FortalIconButtonVariant.solid, size: FortalIconButtonSize.size2)
FortalIconButtonStyle.ghost()
```

### Checkbox — `FortalCheckboxStyles`

| Variant | Description |
|---------|-------------|
| `surface` | Neutral surface container |
| `soft` | Subtle accent surface |

| Size | Dimensions | Indicator |
|------|-----------|-----------|
| `size1` | 16×16 | 12px icon |
| `size2` | 24×24 | 16px icon |
| `size3` | 32×32 | 24px icon |

```dart
FortalCheckboxStyles.create(variant: FortalCheckboxVariant.surface, size: FortalCheckboxSize.size2)
FortalCheckboxStyles.surface()
FortalCheckboxStyles.soft()
```

### Radio — `FortalRadioStyles`

Variants: `surface`, `soft`. Sizes: `size1` (16×16, 6px dot), `size2` (20×20, 8px dot), `size3` (24×24, 10px dot).

```dart
FortalRadioStyles.create(variant: FortalRadioVariant.surface, size: FortalRadioSize.size2)
```

### Switch — `FortalSwitchStyles`

Variants: `surface`, `soft`. Sizes: `size1` (28×16 track), `size2` (35×20 track), `size3` (42×24 track).

```dart
FortalSwitchStyles.create(variant: FortalSwitchVariant.surface, size: FortalSwitchSize.size2)
```

### Badge — `FortalBadgeStyles`

| Variant | Description |
|---------|-------------|
| `solid` | Filled accent |
| `soft` | Subtle accent surface |
| `surface` | Neutral surface |
| `outline` | Border only |

Sizes: `size1` (11px), `size2` (12px), `size3` (13px).

```dart
FortalBadgeStyles.create(variant: FortalBadgeVariant.solid, size: FortalBadgeSize.size2)
FortalBadgeStyles.solid()
FortalBadgeStyles.outline()
```

### Avatar — `FortalAvatarStyles`

Variants: `soft`, `solid`. Sizes: `size1` (24px), `size2` (32px), `size3` (40px), `size4` (64px).

```dart
FortalAvatarStyles.create(variant: FortalAvatarVariant.soft, size: FortalAvatarSize.size3)
```

### Card — `FortalCardStyles`

| Variant | Description |
|---------|-------------|
| `surface` | Neutral surface with subtle border |
| `classic` | Traditional card with shadow |
| `ghost` | Transparent, no border |

Sizes: `size1` (16px padding), `size2` (24px padding), `size3` (32px padding).

```dart
FortalCardStyles.create(variant: FortalCardVariant.surface, size: FortalCardSize.size2)
FortalCardStyles.classic()
```

### Callout — `FortalCalloutStyles`

Variants: `outline`, `surface`, `soft`. Sizes: `size1` (compact), `size2` (default), `size3` (spacious).

```dart
FortalCalloutStyles.create(variant: FortalCalloutVariant.surface, size: FortalCalloutSize.size2)
```

### Progress — `FortalProgressStyles`

Variants: `surface`, `soft`. Sizes: `size1` (4px height), `size2` (8px), `size3` (12px).

```dart
FortalProgressStyles.create(variant: FortalProgressVariant.surface, size: FortalProgressSize.size2)
```

### Slider — `FortalSliderStyles`

Variants: `surface`, `soft`. Sizes: `size1` (13px thumb), `size2` (16px thumb), `size3` (19px thumb).

```dart
FortalSliderStyles.create(variant: FortalSliderVariant.surface, size: FortalSliderSize.size2)
```

### Spinner — `FortalSpinnerStyles`

No variants. Sizes: `size1` (16px), `size2` (20px), `size3` (24px).

```dart
FortalSpinnerStyles.create(size: FortalSpinnerSize.size2)
```

### TextField — `FortalTextFieldStyles`

Variants: `surface`, `soft`. Sizes: `size1` (12px text), `size2` (14px text), `size3` (15px text).

```dart
FortalTextFieldStyles.create(variant: FortalTextFieldVariant.surface, size: FortalTextFieldSize.size2)
```

### Select — `FortalSelectStyles` + `FortalSelectItemStyles`

Variants: `surface`, `soft`, `ghost`. Sizes: `size1`, `size2`, `size3`.

```dart
FortalSelectStyles.create(variant: FortalSelectVariant.surface, size: FortalSelectSize.size2)
```

### Menu — `FortalMenuStyles` + `FortalMenuItemStyles`

Variants: `solid`, `soft`. Sizes: `size1`, `size2`.

```dart
FortalMenuStyles.create(variant: FortalMenuVariant.solid, size: FortalMenuSize.size2)
```

### Tabs — `FortalTabsStyles`

No variants, no sizes.

```dart
FortalTabsStyles.create()
```

### Tooltip — `FortalTooltipStyles`

No variants, no sizes.

```dart
FortalTooltipStyles.create()
```

### Dialog — `FortalDialogStyle`

No variants, no sizes.

```dart
FortalDialogStyle.create()
```

### Divider — `FortalDividerStyles`

No variants. Sizes: `size1` (1px), `size2` (2px), `size3` (3px).

```dart
FortalDividerStyles.create(size: FortalDividerSize.size1)
```

### Accordion — `FortalAccordionStyle`

No variants, no sizes. Use `FortalAccordionStyle.base()`.

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
