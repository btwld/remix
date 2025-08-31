# Remix UI - Shadcn Simplification Migration Plan

## Overview
This document outlines the complete migration plan to simplify Remix UI to match Shadcn UI's minimal token and variant approach. The goal is to reduce complexity while maintaining flexibility through Mix's powerful style composition system.

## Summary of Changes
- **Token Reduction**: From ~50 tokens to 20 tokens
- **Button Variants**: From 20+ to 6 variants
- **Badge Variants**: From 5+ to 4 variants  
- **Alert Variants**: From 3+ to 2 variants
- **Direct Values**: Replace token references with direct pixel values for spacing and typography

---

## Phase 1: Token System Update

### File: `lib/src/theme/remix_tokens.dart`

#### Tokens to REMOVE ❌
```dart
// Color tokens to remove
- RemixTokens.success
- RemixTokens.warning  
- RemixTokens.danger
- RemixTokens.info
- RemixTokens.textPrimary
- RemixTokens.textSecondary
- RemixTokens.textTertiary
- RemixTokens.textDisabled
- RemixTokens.surfaceVariant
- RemixTokens.borderSubtle

// ALL spacing tokens
- RemixTokens.spaceXs  // Remove - use 4.0 directly
- RemixTokens.spaceSm  // Remove - use 8.0 directly
- RemixTokens.spaceMd  // Remove - use 12.0 directly
- RemixTokens.spaceLg  // Remove - use 16.0 directly
- RemixTokens.spaceXl  // Remove - use 24.0 directly
- RemixTokens.spaceXxl // Remove - use 32.0 directly

// ALL typography tokens
- RemixTokens.fontSizeXs  // Remove - use 10.0 directly
- RemixTokens.fontSizeSm  // Remove - use 12.0 directly
- RemixTokens.fontSizeMd  // Remove - use 14.0 directly
- RemixTokens.fontSizeLg  // Remove - use 16.0 directly
- RemixTokens.fontSizeXl  // Remove - use 18.0 directly

// ALL icon size tokens
- RemixTokens.iconSizeXs  // Remove - use 12.0 directly
- RemixTokens.iconSizeSm  // Remove - use 14.0 directly
- RemixTokens.iconSizeMd  // Remove - use 16.0 directly
- RemixTokens.iconSizeLg  // Remove - use 18.0 directly
- RemixTokens.iconSizeXl  // Remove - use 20.0 directly

// ALL elevation tokens
- RemixTokens.elevationLow
- RemixTokens.elevationMd
- RemixTokens.elevationHigh

// Multiple radius tokens
- RemixTokens.radiusSm  // Remove - use radius * 0.5 or 4.0 directly
- RemixTokens.radiusMd  // Remove - use radius directly
- RemixTokens.radiusLg  // Remove - use radius * 1.5 or 8.0 directly
- RemixTokens.radiusXl  // Remove - use radius * 2 or 12.0 directly
```

#### Tokens to KEEP ✅ (20 total)
```dart
class RemixTokens {
  // Core colors
  static const background = MixToken<Color>('remix.background');
  static const foreground = MixToken<Color>('remix.foreground');
  
  // Component colors
  static const card = MixToken<Color>('remix.card');
  static const cardForeground = MixToken<Color>('remix.card.foreground');
  static const popover = MixToken<Color>('remix.popover');
  static const popoverForeground = MixToken<Color>('remix.popover.foreground');
  
  // Semantic colors
  static const primary = MixToken<Color>('remix.primary');
  static const primaryForeground = MixToken<Color>('remix.primary.foreground');
  static const secondary = MixToken<Color>('remix.secondary');
  static const secondaryForeground = MixToken<Color>('remix.secondary.foreground');
  static const muted = MixToken<Color>('remix.muted');
  static const mutedForeground = MixToken<Color>('remix.muted.foreground');
  static const accent = MixToken<Color>('remix.accent');
  static const accentForeground = MixToken<Color>('remix.accent.foreground');
  static const destructive = MixToken<Color>('remix.destructive');
  static const destructiveForeground = MixToken<Color>('remix.destructive.foreground');
  
  // UI elements
  static const border = MixToken<Color>('remix.border');
  static const input = MixToken<Color>('remix.input');
  static const ring = MixToken<Color>('remix.ring');
  
  // Single radius
  static const radius = MixToken<double>('remix.radius'); // Default: 6.0
}
```

---

## Phase 2: Theme Definitions Update

### File: `lib/src/theme/remix_theme.dart`

Update both light and dark theme definitions to only define the 20 tokens listed above.

#### Token Replacements
- Remove all definitions for deleted tokens
- Update color values to match Shadcn's palette

---

## Phase 3: Component Updates

### 3.1 Button Component

#### File: `lib/src/components/button/button_style.dart`

##### Variants to REMOVE ❌
```dart
- ButtonVariants.success
- ButtonVariants.danger  
- ButtonVariants.warning
- ButtonVariants.primaryOutline
- ButtonVariants.secondaryOutline
- ButtonVariants.successOutline
- ButtonVariants.dangerOutline
- ButtonVariants.primaryGhost
- ButtonVariants.secondaryGhost
- ButtonVariants.successGhost
- ButtonVariants.dangerGhost
- ButtonVariants.primarySoft
- ButtonVariants.secondarySoft
- ButtonVariants.successSoft
- ButtonVariants.dangerSoft
```

##### New Structure ✅
```dart
class RemixButtonStyle {
  // 6 variants (each includes default sizing)
  static RemixButtonStyle primary() => ...      // 40px height
  static RemixButtonStyle secondary() => ...    // 40px height
  static RemixButtonStyle destructive() => ...  // 40px height
  static RemixButtonStyle outline() => ...      // 40px height
  static RemixButtonStyle ghost() => ...        // 40px height
  static RemixButtonStyle link() => ...         // 40px height
}
```

RemixButton(
  style: RemixButtonStyle.primary(),  // Default with built-in sizing
)

##### Token Replacements
- `RemixTokens.spaceMd()` → `12.0`
- `RemixTokens.fontSizeMd()` → `14.0`
- `RemixTokens.iconSizeLg()` → `18.0`
- `RemixTokens.surface()` → `RemixTokens.background()`
- `RemixTokens.danger()` → `RemixTokens.destructive()`

### 3.2 Badge Component

#### File: `lib/src/components/badge/badge_style.dart`

##### Variants to REMOVE ❌
```dart
- BadgeVariants.success
- BadgeVariants.warning
- BadgeVariants.danger
- BadgeVariants.info
```

##### New Structure ✅
```dart
class RemixBadgeStyle {
  static RemixBadgeStyle solid() => ...       // Uses primary colors, default sizing
  static RemixBadgeStyle secondary() => ...   // Uses secondary colors, default sizing
  static RemixBadgeStyle destructive() => ... // Uses destructive colors, default sizing
  static RemixBadgeStyle outline() => ...     // Border only, default sizing
}
```

### 3.3 Alert/Callout Component

#### File: `lib/src/components/callout/callout_style.dart`

##### Variants to REMOVE ❌
```dart
- CalloutVariants.success
- CalloutVariants.warning
```

##### New Structure ✅
```dart
class RemixAlertStyle {
  static RemixAlertStyle info() => ...        // Default variant with built-in sizing
  static RemixAlertStyle destructive() => ... // Error/danger variant with built-in sizing
}
```

---

## Phase 4: Component Token Updates

### Files Requiring Token Updates (21 files)

All these files need token replacements:

1. **accordion_style.dart**
   - Replace spacing tokens with direct values
   - Replace typography tokens with direct values

2. **avatar_style.dart**
   - Replace `RemixTokens.surface()` → `RemixTokens.background()`
   - Replace spacing tokens with direct values

3. **badge_style.dart**
   - Replace `RemixTokens.surfaceVariant()` → `RemixTokens.muted()`
   - Replace `RemixTokens.textPrimary()` → `RemixTokens.foreground()`
   - Replace all spacing tokens with direct values

4. **button_style.dart**
   - Major refactor (see Section 3.1)
   - Replace all spacing/typography tokens with direct values

5. **card_style.dart**
   - Replace `RemixTokens.surface()` → `RemixTokens.card()`
   - Replace `RemixTokens.elevationMd()` → Direct BoxShadow definition
   - Replace spacing tokens with direct values

6. **checkbox_style.dart**
   - Replace border tokens with `RemixTokens.border()`
   - Replace spacing tokens with direct values

7. **chip_style.dart**
   - Replace `RemixTokens.success()` → Custom green color or remove variant
   - Replace `RemixTokens.warning()` → Custom orange color or remove variant
   - Replace spacing tokens with direct values

8. **divider_style.dart**
   - Replace `RemixTokens.borderSubtle()` → `RemixTokens.border()`

9. **label_style.dart**
   - Replace typography tokens with direct values

10. **list_item_style.dart**
    - Replace `RemixTokens.textSecondary()` → `RemixTokens.mutedForeground()`
    - Replace typography tokens with direct values

11. **progress_style.dart**
    - Replace `RemixTokens.success()` → `RemixTokens.primary()` or custom color
    - Replace `RemixTokens.warning()` → Custom orange color or remove

12. **radio_style.dart**
    - Similar to checkbox_style.dart

13. **select_style.dart**
    - Replace `RemixTokens.textPrimary()` → `RemixTokens.foreground()`
    - Replace `RemixTokens.textSecondary()` → `RemixTokens.mutedForeground()`
    - Replace spacing tokens with direct values

14. **slider_style.dart**
    - Replace spacing tokens with direct values

15. **spinner_style.dart**
    - Replace icon size tokens with direct values

16. **switch_style.dart**
    - Replace spacing tokens with direct values

17. **textfield_style.dart**
    - Replace `RemixTokens.borderSubtle()` → `RemixTokens.border()`
    - Replace `RemixTokens.surfaceVariant()` → `RemixTokens.muted()`
    - Replace spacing tokens with direct values

18. **tooltip_style.dart**
    - Replace spacing tokens with direct values
    - Replace elevation tokens with direct BoxShadow

---

## Phase 5: Test Updates

### File: `test/theme/remix_theme_test.dart`

- Update all token references
- Remove tests for deleted tokens
- Update variant tests for buttons, badges, alerts

---

## Migration Guide for Users

### Color Changes
```dart
// Before
RemixButton(
  style: ButtonVariants.success,
)

// After - use custom color
RemixButton(
  style: RemixButtonStyle.primary().color(Colors.green),
)
```

### Spacing Changes
```dart
// Before
padding: RemixTokens.spaceMd()

// After - use direct value
padding: 12.0
```

### Typography Changes
```dart
// Before
fontSize: RemixTokens.fontSizeMd()

// After - use direct value
fontSize: 14.0
```

---

## Token Replacement Table

| Old Token | New Value |
|-----------|-----------|
| `RemixTokens.success()` | `Colors.green` or remove |
| `RemixTokens.warning()` | `Colors.orange` or remove |
| `RemixTokens.danger()` | `RemixTokens.destructive()` |
| `RemixTokens.info()` | Remove |
| `RemixTokens.surface()` | `RemixTokens.background()` or `RemixTokens.card()` |
| `RemixTokens.surfaceVariant()` | `RemixTokens.muted()` |
| `RemixTokens.textPrimary()` | `RemixTokens.foreground()` |
| `RemixTokens.textSecondary()` | `RemixTokens.mutedForeground()` |
| `RemixTokens.textTertiary()` | `RemixTokens.mutedForeground().withOpacity(0.7)` |
| `RemixTokens.textDisabled()` | `RemixTokens.mutedForeground().withOpacity(0.5)` |
| `RemixTokens.borderSubtle()` | `RemixTokens.border()` |
| `RemixTokens.spaceXs()` | `4.0` |
| `RemixTokens.spaceSm()` | `8.0` |
| `RemixTokens.spaceMd()` | `12.0` |
| `RemixTokens.spaceLg()` | `16.0` |
| `RemixTokens.spaceXl()` | `24.0` |
| `RemixTokens.spaceXxl()` | `32.0` |
| `RemixTokens.fontSizeXs()` | `10.0` |
| `RemixTokens.fontSizeSm()` | `12.0` |
| `RemixTokens.fontSizeMd()` | `14.0` |
| `RemixTokens.fontSizeLg()` | `16.0` |
| `RemixTokens.fontSizeXl()` | `18.0` |
| `RemixTokens.iconSizeSm()` | `14.0` |
| `RemixTokens.iconSizeMd()` | `16.0` |
| `RemixTokens.iconSizeLg()` | `18.0` |
| `RemixTokens.iconSizeXl()` | `20.0` |
| `RemixTokens.radiusSm()` | `4.0` |
| `RemixTokens.radiusMd()` | `RemixTokens.radius()` |
| `RemixTokens.radiusLg()` | `8.0` |
| `RemixTokens.radiusXl()` | `12.0` |
| `RemixTokens.elevationLow()` | Direct BoxShadow definition |
| `RemixTokens.elevationMd()` | Direct BoxShadow definition |
| `RemixTokens.elevationHigh()` | Direct BoxShadow definition |

---

## Benefits of This Migration

1. **Reduced Complexity**: From ~50 tokens to 20 tokens
2. **Clearer Code**: Direct values are more explicit than token references
3. **Better Performance**: No token lookup overhead for spacing/typography
4. **Industry Standard**: Matches Shadcn UI's proven approach
5. **Flexibility**: Custom colors and values can be applied directly
6. **Maintainability**: Fewer tokens and variants to maintain

---

## Execution Order

1. **Start with tokens** - Update remix_tokens.dart
2. **Update themes** - Update remix_theme.dart 
3. **Update button** - Has the most changes
4. **Update badge and alert** - Simpler variant changes
5. **Update remaining components** - Token replacements only
6. **Update tests** - Fix any broken tests
7. **Update documentation** - Examples and migration guide

---

## Breaking Changes

This is a **major breaking change** that will require users to:
1. Update all variant references
2. Replace token usage with direct values or new tokens
3. Use custom colors for success/warning states

Consider releasing as a major version update (e.g., v2.0.0).