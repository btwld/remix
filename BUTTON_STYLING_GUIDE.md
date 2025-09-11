# RemixButton Fluent API Styling Guide

## Overview

The `RemixButtonStyle` class provides a comprehensive three-tier fluent API for styling buttons, from simple property changes to complex styling scenarios.

## Three-Tier API Approach

### 🎯 **Tier 1: Individual Property Helpers** (Most Common)

Use these methods for simple, single property changes. They're the most discoverable and readable approach.

```dart
RemixButtonStyle()
  // Label styling
  .labelColor(Colors.white)
  .labelFontSize(16.0)
  .labelFontWeight(FontWeight.bold)
  .labelLetterSpacing(0.5)
  
  // Icon styling  
  .iconColor(Colors.white)
  .iconSize(20.0)
  .iconOpacity(0.9)
  
  // Spinner styling
  .spinnerColor(Colors.white)
  .spinnerSize(16.0)
  .spinnerStrokeWidth(2.0)
  .spinnerFast()
  
  // Container styling (via mixins)
  .color(Colors.blue)
  .borderRadiusAll(Radius.circular(8))
  .paddingAll(16.0)
```

**Available Label Helpers:**
- `labelColor(Color)` - Sets text color
- `labelFontSize(double)` - Sets font size
- `labelFontWeight(FontWeight)` - Sets font weight
- `labelFontStyle(FontStyle)` - Sets italic/normal
- `labelLetterSpacing(double)` - Sets letter spacing
- `labelWordSpacing(double)` - Sets word spacing
- `labelHeight(double)` - Sets line height
- `labelDecoration(TextDecoration)` - Sets underline, strikethrough, etc.
- `labelDecorationColor(Color)` - Sets decoration color
- `labelFontFamily(String)` - Sets font family

**Available Icon Helpers:**
- `iconColor(Color)` - Sets icon color
- `iconSize(double)` - Sets icon size
- `iconOpacity(double)` - Sets icon opacity
- `iconWeight(double)` - Sets icon weight (variable fonts)
- `iconGrade(double)` - Sets icon grade (Material Icons)
- `iconFill(double)` - Sets icon fill (Material Icons)
- `iconOpticalSize(double)` - Sets optical size
- `iconBlendMode(BlendMode)` - Sets blend mode
- `iconShadows(List<ShadowMix>)` - Sets shadows

**Available Spinner Helpers:**
- `spinnerColor(Color)` - Sets spinner color
- `spinnerSize(double)` - Sets spinner size
- `spinnerStrokeWidth(double)` - Sets stroke width
- `spinnerDuration(Duration)` - Sets animation duration
- `spinnerType(SpinnerType)` - Sets spinner type
- `spinnerSolid()` - Sets to solid type (convenience)
- `spinnerDotted()` - Sets to dotted type (convenience)
- `spinnerFast()` - Sets to 500ms duration (convenience)
- `spinnerNormal()` - Sets to 1000ms duration (convenience)
- `spinnerSlow()` - Sets to 1500ms duration (convenience)

### 🎨 **Tier 2: TextStyleMix Helper** (Multiple Properties)

When you need to set multiple text properties at once, use `labelTextStyle()` with a `TextStyleMix`:

```dart
RemixButtonStyle()
  .labelTextStyle(TextStyleMix(
    color: Colors.white,
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
    height: 1.2,
    decoration: TextDecoration.underline,
  ))
  .iconColor(Colors.white)
  .iconSize(22.0)
```

**When to Use Tier 2:**
- Setting 3+ text properties at once
- Need to pass a pre-built `TextStyleMix`
- Want type safety with Mix's styling system
- Building reusable style objects

### ⚡ **Tier 3: Full Control** (Complex Scenarios)

For advanced text features or complex styling needs, use the full `label()` and `icon()` methods:

```dart
RemixButtonStyle()
  .label(
    TextStyler()
      .style(TextStyleMix(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ))
      .uppercase()           // Text transformations
      .maxLines(2)          // Layout constraints
      .overflow(TextOverflow.ellipsis)
      .textAlign(TextAlign.center)
  )
  .icon(IconStyler(
    color: Colors.white,
    size: 20.0,
    shadows: [ShadowMix.elevation(4)],
    blendMode: BlendMode.multiply,
  ))
```

**When to Use Tier 3:**
- Need text transformations (uppercase, lowercase, etc.)
- Complex layout constraints (maxLines, overflow, alignment)
- Advanced icon features (complex shadows, blend modes)
- Conditional styling with builders

## Migration from Old API

### Before (Verbose)
```dart
RemixButtonStyle()
  .label(
    TextStyler()
      .color(Colors.white)
      .fontSize(16.0)
  )
  .icon(IconStyler(
    color: Colors.white,
    size: 20.0,
  ))
```

### After (Clean)
```dart
RemixButtonStyle()
  .labelColor(Colors.white)
  .labelFontSize(16.0)
  .iconColor(Colors.white)
  .iconSize(20.0)
```

## Common Patterns

### Primary Button
```dart
static RemixButtonStyle get primary => RemixButtonStyle()
  .color(Colors.blue)
  .labelColor(Colors.white)
  .labelFontSize(16.0)
  .labelFontWeight(FontWeight.w600)
  .iconColor(Colors.white)
  .iconSize(20.0)
  .borderRadiusAll(Radius.circular(8))
  .paddingX(16.0)
  .paddingY(12.0);
```

### Outline Button  
```dart
static RemixButtonStyle get outline => RemixButtonStyle()
  .color(Colors.transparent)
  .labelColor(Colors.blue)
  .labelFontWeight(FontWeight.w500)
  .iconColor(Colors.blue)
  .borderAll(color: Colors.blue, width: 2.0)
  .borderRadiusAll(Radius.circular(8))
  .onHovered(RemixButtonStyle()
    .color(Colors.blue.withOpacity(0.05)));
```

### Ghost/Text Button
```dart
static RemixButtonStyle get ghost => RemixButtonStyle()
  .color(Colors.transparent)
  .labelColor(Colors.grey.shade700)
  .iconColor(Colors.grey.shade600)
  .onHovered(RemixButtonStyle()
    .color(Colors.grey.shade50)
    .labelColor(Colors.grey.shade900));
```

### Complex Typography
```dart
static RemixButtonStyle get typography => RemixButtonStyle()
  .color(Colors.indigo)
  .labelTextStyle(TextStyleMix(
    color: Colors.white,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.3,
    fontStyle: FontStyle.normal,
  ))
  .iconColor(Colors.white.withOpacity(0.9))
  .iconSize(20.0);
```

### Loading Button with Spinner
```dart
static RemixButtonStyle get loading => RemixButtonStyle()
  .color(Colors.blue)
  .labelColor(Colors.white.withOpacity(0.7))
  .iconColor(Colors.white.withOpacity(0.7))
  .spinnerColor(Colors.white)
  .spinnerSize(16.0)
  .spinnerStrokeWidth(2.0)
  .spinnerFast(); // 500ms animation
```

## Method Chaining Best Practices

### ✅ Good: Logical Grouping
```dart
RemixButtonStyle()
  // Background and structure
  .color(Colors.blue)
  .borderRadiusAll(Radius.circular(8))
  .paddingX(16.0)
  .paddingY(12.0)
  
  // Text styling
  .labelColor(Colors.white)
  .labelFontSize(16.0)
  .labelFontWeight(FontWeight.w600)
  
  // Icon styling
  .iconColor(Colors.white)
  .iconSize(20.0)
  
  // Interactive states
  .onHovered(RemixButtonStyle().color(Colors.blue.shade700));
```

### ❌ Avoid: Mixing API Tiers Unnecessarily
```dart
// Don't mix tiers when tier 1 is sufficient
RemixButtonStyle()
  .labelColor(Colors.white)          // Tier 1
  .labelTextStyle(TextStyleMix(      // Tier 2 - unnecessary here
    fontSize: 16.0,
  ))
```

## Performance Considerations

- **All tiers have identical runtime performance** - they're syntactic sugar over the same underlying implementation
- Helper methods create the same `TextStyler`/`IconStyler` objects internally
- Use the tier that best matches your use case for code clarity
- Method chaining creates new immutable instances (expected Flutter pattern)

## When to Use Which Tier

| Scenario | Recommended Tier | Example |
|----------|------------------|---------|
| Single property change | Tier 1 | `.labelColor(Colors.red)` |
| 2-3 simple properties | Tier 1 | `.labelColor().labelFontSize()` |
| 3+ text properties | Tier 2 | `.labelTextStyle(TextStyleMix(...))` |
| Text transformations | Tier 3 | `.label(TextStyler().uppercase())` |
| Complex layout constraints | Tier 3 | `.label(TextStyler().maxLines(2))` |
| Reusable style objects | Tier 2/3 | Create `TextStyleMix` variables |

## Examples in Action

See `lib/src/components/button/button_style_examples.dart` for comprehensive examples of all patterns and use cases.

For Radix-compliant buttons, see `lib/src/components/button/radix_button_styles.dart` which uses these patterns throughout all 6 button variants.