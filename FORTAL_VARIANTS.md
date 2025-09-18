# Fortal Variant System Implementation Plan

## Analysis Summary

After analyzing the `component_tokens_ref.json` file, I've discovered that the Fortal UI variant system is **NOT universal** - each component has different token mappings for the same variant names.

## Key Findings

### 1. Variants Have Different Values Per Component

The same variant name uses different tokens across components:

#### Example: "Solid" Variant
- **Button/IconButton**: 
  - Background: `{accent}[9]` → `{accent}[10]` on hover
  - Text: `--accent-contrast`
  - Focus ring: `--focus-a8`
  
- **Badge**: 
  - Background: `{accent}[9]` (no hover state)
  - Text: `--accent-contrast`
  - No focus ring
  
- **Code**: 
  - Background: `{accent}[9]`
  - Text: `--accent-contrast`
  
- **Spinner**: 
  - No solid variant (only default with stroke `{accent}[9]`)

#### Example: "Soft" Variant
- **Button**: 
  - Background: `{accent}[3]` → `{accent}[4]` hover → `{accent}[5]` active
  - Text: `{accent}[11]`
  - Border: `{accent}[6]` → `{accent}[7]` hover
  
- **Checkbox**: 
  - Background: `{accent}[3]` (no hover/active states)
  - Border: `{accent}[6]` (no hover)
  - Check color: `{accent}[11]`
  
- **TextField**: 
  - Background: `{accent}[3]`
  - Text: `{accent}[12]` (different from button!)
  - Placeholder: `{accent}[10]`
  - Border: `{accent}[6]` → `{accent}[8]` on focus
  
- **Progress**: 
  - Track: `{accent}[4]` (completely different structure)
  - Indicator: `{accent}[9]`

### 2. Components Support Different Variant Subsets

| Component | Supported Variants | Count |
|-----------|-------------------|--------|
| Button/IconButton | solid, soft, surface, outline, ghost, classic | 6 |
| Badge | solid, soft, surface, outline | 4 |
| Card | surface, classic, ghost | 3 |
| Checkbox/Radio | classic, surface, soft | 3 |
| Switch | classic, surface, soft | 3 |
| Progress | classic, surface, soft | 3 |
| Slider | classic, surface, soft | 3 |
| TextField/TextArea | classic, surface, soft | 3 |
| Spinner | (none - just default) | 0 |
| Select | Trigger: classic, surface, soft, ghost / Content: solid, soft | 4+2 |

### 3. Component-Specific Properties

Different components require completely different style properties:

- **Buttons**: background, text, border, focusRing
- **Progress**: track, indicator (both require BoxStyler wrappers)
- **Slider**: baseTrack, activeTrack (Paint objects), thumb (BoxStyler)
- **Checkbox**: indicatorContainer, indicator, label, container
- **Switch**: track, thumb, container (state variants handled via .onVariant())
- **Select**: Separate Trigger and Content variants

**Important**: All color tokens must be wrapped in appropriate Styler objects:
- Colors: `BoxStyler(decoration: BoxDecorationMix(color: token))`
- Text colors: `TextStyler(color: token)`
- Icon colors: `IconStyler(color: token)`

## Recommended Implementation

### Approach: Component-Specific Variant Factories

Since variants are NOT universal, each component needs its own variant factory class.

### Implementation Structure

```dart
// 1. Keep existing FortalTokens as-is (already done)
// Provides the building blocks for all variants

// 2. Create component-specific factory classes
// Each implements only the variants that make sense for that component

// Example: Button (all 6 variants)
class FortalButtonStyles {
  static RemixButtonStyle solid({int size = 2}) { 
    // Uses {accent}[9], hover {accent}[10], --accent-contrast
  }
  static RemixButtonStyle soft({int size = 2}) { 
    // Uses {accent}[3], hover {accent}[4], active {accent}[5]
  }
  static RemixButtonStyle surface({int size = 2}) { ... }
  static RemixButtonStyle outline({int size = 2}) { ... }
  static RemixButtonStyle ghost({int size = 2}) { ... }
  static RemixButtonStyle classic({int size = 2}) { ... }
}

// Example: Checkbox (only 3 variants) - UPDATED WITH DIRECT SCALE TOKENS
class FortalCheckboxStyles {
  static RemixCheckboxStyle classic({int size = 2}) {
    return RemixCheckboxStyle()
      .indicatorContainer(BoxStyler(
        decoration: BoxDecorationMix(
          color: FortalTokens.colorSurface(),
          border: BoxBorderMix.all(
            color: FortalTokens.gray7(),
            width: FortalTokens.borderWidth1(),
          ),
        ),
      ))
      .indicatorColor(FortalTokens.gray12());
  }
  
  static RemixCheckboxStyle surface({int size = 2}) {
    return RemixCheckboxStyle()
      .indicatorContainer(BoxStyler(
        decoration: BoxDecorationMix(
          color: FortalTokens.accentSurface(),
          border: BoxBorderMix.all(
            color: FortalTokens.accent6(),
            width: FortalTokens.borderWidth1(),
          ),
        ),
      ))
      .indicatorColor(FortalTokens.accent11());
  }
  
  static RemixCheckboxStyle soft({int size = 2}) {
    return RemixCheckboxStyle()
      .indicatorContainer(BoxStyler(
        decoration: BoxDecorationMix(
          color: FortalTokens.accent3(),
          border: BoxBorderMix.all(
            color: FortalTokens.accent6(),
            width: FortalTokens.borderWidth1(),
          ),
        ),
      ))
      .indicatorColor(FortalTokens.accent11());
  }
  // No solid, outline, or ghost variants!
}

// Example: Progress (different properties entirely) - UPDATED WITH DIRECT SCALE TOKENS
class FortalProgressStyles {
  static RemixProgressStyle classic({int size = 2}) {
    return RemixProgressStyle()
      .track(BoxStyler(
        decoration: BoxDecorationMix(
          color: FortalTokens.accentTrack(),  // --accent-track (gray6)
        ),
      ))
      .indicator(BoxStyler(
        decoration: BoxDecorationMix(
          color: FortalTokens.accentIndicator(), // --accent-indicator (accent9)
        ),
      ));
  }
  
  static RemixProgressStyle soft({int size = 2}) {
    return RemixProgressStyle()
      .track(BoxStyler(
        decoration: BoxDecorationMix(
          color: FortalTokens.accent4(),  // Direct scale access
        ),
      ))
      .indicator(BoxStyler(
        decoration: BoxDecorationMix(
          color: FortalTokens.accent9(), // Direct scale access
        ),
      ));
  }
}

// Example: Switch - UPDATED WITH DIRECT SCALE TOKENS
class FortalSwitchStyles {
  static RemixSwitchStyle classic({int size = 2}) {
    return RemixSwitchStyle()
      .trackColor(FortalTokens.colorSurface())
      .thumbColor(FortalTokens.gray12())
      .onVariant('checked', RemixSwitchStyle()
        .trackColor(FortalTokens.accentIndicator()) // accent9
      );
  }
  
  static RemixSwitchStyle soft({int size = 2}) {
    return RemixSwitchStyle()
      .trackColor(FortalTokens.accent3())
      .thumbColor(FortalTokens.colorSurface())
      .onVariant('checked', RemixSwitchStyle()
        .trackColor(FortalTokens.accent9())
      );
  }
  // No separate "checkedTrack" or "checkedThumb" properties!
  // State variants are handled via .onVariant() method
}

// Example: Slider - UPDATED WITH DIRECT SCALE TOKENS
class FortalSliderStyles {
  static RemixSliderStyle classic({int size = 2}) {
    return RemixSliderStyle()
      .baseTrackColor(FortalTokens.accentTrack()) // gray6
      .activeTrackColor(FortalTokens.accentIndicator()) // accent9  
      .thumbColor(FortalTokens.colorSurface());
  }
  
  static RemixSliderStyle soft({int size = 2}) {
    return RemixSliderStyle()
      .baseTrackColor(FortalTokens.accent4())
      .activeTrackColor(FortalTokens.accent9())
      .thumbColor(FortalTokens.colorSurface());
  }
  // Note: baseTrack and activeTrack use Paint objects, not BoxStyler
  // Use .baseTrackColor() and .activeTrackColor() convenience methods
}
```

### Why NOT a Shared Variant Config?

A shared `VariantConfig` class would be incorrect because:
1. The same variant name has different token values per component
2. Components have different style properties (background vs track/thumb)
3. Not all components support all variants
4. Would create confusion and type-safety issues

### Size Config Pattern

The existing `_ButtonSizeConfig` pattern is good for sizes because:
- Size properties are consistent (height, padding, fontSize, etc.)
- All size variants share the same structure
- Can be reused across components with similar sizing needs

But this pattern does NOT work for variants because variants change:
- Different properties per component
- Different token mappings per component
- Different state behaviors (hover, active, focus)

## Implementation Priority

1. **Already Done**: Button component with all 6 variants ✓
2. **High Priority** (most commonly used):
   - IconButton (similar to Button)
   - TextField/TextArea
   - Checkbox/Radio
   - Select
3. **Medium Priority**:
   - Badge
   - Card
   - Switch
   - Slider
4. **Low Priority**:
   - Progress
   - Spinner
   - Table
   - Tabs
   - Code

## Token Mapping Source of Truth

Use `/Users/leofarias/bitwild/remix/lib/src/radix/colors/component_tokens_ref.json` as the authoritative source for:
- Which variants each component supports
- Exact token mappings for each variant
- State variations (hover, active, focus)
- Component-specific properties

## Benefits of This Approach

1. **Accuracy**: Matches actual Fortal UI behavior
2. **Type Safety**: Each component gets exactly the variants it needs
3. **Clarity**: No confusion about which variants are available
4. **Maintainability**: Easy to update individual components
5. **Flexibility**: Can add new variants per component as needed
6. **Documentation**: Self-documenting which variants exist per component

## Critical Implementation Notes

### Available FortalTokens (CORRECTED)

**✅ Token Constants That Require () to Get Reference Types:**
- **Accent Scale**: `accent1()` through `accent12()` - Full 12-step accent color scale
- **Gray Scale**: `gray1()` through `gray12()` - Full 12-step gray color scale  
- **Alpha Scale**: `accentA3()`, `accentA4()`, `accentA8()` - Common alpha transparency steps
- **Functional Color Tokens**: `colorBackground()`, `colorSurface()`, `colorPanelSolid()`, `colorPanelTranslucent()`, `colorOverlay()`
- **Accent Functional**: `accentSurface()`, `accentIndicator()`, `accentTrack()`, `accentContrast()`
- **Focus Tokens**: `focus8()`, `focusA8()`
- **Space Tokens**: `space1()` through `space9()`, `borderWidth1()`, `borderWidth2()`, `focusRingWidth()`, `focusRingOffset()`
- **Radius Tokens**: `radius1()` through `radius6()`, `radiusFull()`

**✅ Function Constants That Return Flutter Types:**
- `fontWeightRegular()`, `fontWeightMedium()`, `fontWeightBold()` - Return `FontWeight`
- `transitionFast()`, `transitionSlow()` - Return `Duration`

**Why () is Required:**
```dart
// Token constants return token objects
FortalTokens.accent9        // Returns ColorToken (not usable in styles)

// Calling () returns reference types that implement interfaces
FortalTokens.accent9()      // Returns ColorRef (implements Color, usable in styles)
FortalTokens.space3()       // Returns SpaceRef (implements double, usable as spacing)
FortalTokens.radius2()      // Returns RadiusRef (implements Radius, usable for borders)
```

**❌ Removed Variant-Specific Tokens (NO LONGER EXIST):**
- `solidBackground()`, `softBackground()`, `surfaceBackground()`, etc.
- `solidText()`, `softText()`, `surfaceText()`, etc.
- `solidFocusRing()`, `softFocusRing()`, `surfaceFocusRing()`, etc.
- **Use direct scale tokens instead**: `accent9()`, `accent11()`, `focusA8()`, etc.

### Style Method Patterns (CORRECTED)

1. **All color tokens MUST be wrapped in Styler objects:**
   - Background colors: `BoxStyler(decoration: BoxDecorationMix(color: token))`
   - Text colors: `TextStyler(color: token)`
   - Icon colors: `IconStyler(color: token)`
   - Paint objects (Slider tracks): Use convenience methods like `.baseTrackColor()`

2. **Component Property Names (Actual vs. Conceptual):**
   - ✅ **Progress**: `.track()`, `.indicator()` (both need BoxStyler)
   - ✅ **Checkbox**: `.indicatorContainer()` (box), `.indicator()` (check)
   - ✅ **Radio**: `.indicatorContainer()` (outer ring), `.indicator()` (inner fill)
   - ✅ **Switch**: `.track()`, `.thumb()` only - use `.onVariant('checked', ...)` for state
   - ✅ **Slider**: `.baseTrackColor()`, `.activeTrackColor()`, `.thumbColor()`

3. **State Handling:**
   - Hover/focus states: Use `.onHovered()`, `.onFocused()` methods
   - Checked states: Use `.onVariant('checked', style)` method
   - Active states: Use `.onPressed()` or `.onVariant('active', style)`

### Common Mistakes to Avoid

❌ **WRONG**: Using removed variant-specific tokens:
```dart
FortalTokens.softBackground()    // ❌ Removed - no longer exists
FortalTokens.classicBorder()     // ❌ Removed - no longer exists  
FortalTokens.solidText()         // ❌ Removed - no longer exists
```

✅ **CORRECT**: Use direct scale tokens:
```dart
FortalTokens.accent3()      // ✅ Direct access to accent step 3
FortalTokens.gray7()        // ✅ Direct access to gray step 7
FortalTokens.accentContrast() // ✅ For contrast text on accent9
```

❌ **WRONG**: Direct token assignment without Styler wrappers:
```dart
.track(FortalTokens.accentTrack())  // ❌ Missing BoxStyler wrapper
```

✅ **CORRECT**: Wrap tokens in appropriate Stylers:
```dart
.track(BoxStyler(decoration: BoxDecorationMix(color: FortalTokens.accentTrack())))
```

❌ **WRONG**: Checkbox `.box()` and `.check()` methods (don't exist)
✅ **CORRECT**: Checkbox `.indicatorContainer()` and `.indicator()`

❌ **WRONG**: Switch `.checkedTrack()` and `.checkedThumb()` (don't exist)
✅ **CORRECT**: Switch `.onVariant('checked', RemixSwitchStyle().trackColor(...))`

❌ **WRONG**: Function vs constant confusion:
```dart
FortalTokens.borderWidth1      // ❌ Missing parentheses
FortalTokens.fontWeightMedium() // ❌ Unnecessary parentheses
```

✅ **CORRECT**: Functions need parentheses, constants don't:
```dart
FortalTokens.borderWidth1()    // ✅ Function call
FortalTokens.fontWeightMedium  // ✅ Constant access
```

## Size Method Refactoring Implementation Plan

### CRITICAL: Remove _SizeConfig Pattern and Add Composable Size Methods

The current _SizeConfig pattern violates Mix principles by mixing size concerns with variant styling. We need to refactor to make sizing orthogonal and composable.

### Current Problem

```dart
// ❌ WRONG: Size parameter in variant methods
FortalButtonStyles.solid(size: 2)  // Couples size with variant

// ❌ WRONG: _SizeConfig storing wrong types  
class _ButtonSizeConfig {
  final Radius radius;  // Type mismatch - should be RadiusRef
  const _ButtonSizeConfig({
    required this.radius, // Gets FortalTokens.radius2() which returns RadiusRef
  });
}
```

### Target Solution

```dart
// ✅ CORRECT: Composable size and variant methods
FortalButtonStyles.solid().size2()  // Size and variant are orthogonal
FortalButtonStyles.soft().size1()   // Any combination possible
```

### Implementation Steps

#### Phase 1: Button Component (Pattern Template)

1. **Add size methods to FortalButtonStyles**:
   ```dart
   class FortalButtonStyles {
     // Remove size parameter from all variant methods
     static RemixButtonStyle solid() { ... }
     static RemixButtonStyle soft() { ... }
     
     // Add composable size methods
     static RemixButtonStyle size1() {
       return RemixButtonStyle()
         .height(32.0)
         .paddingHorizontal(FortalTokens.space3())
         .paddingVertical(FortalTokens.space2())
         .borderRadiusAll(FortalTokens.radius2())
         .text(TextStyler().fontSize(12.0));
     }
     
     static RemixButtonStyle size2() {
       return RemixButtonStyle()
         .height(40.0)
         .paddingHorizontal(FortalTokens.space4())
         .paddingVertical(FortalTokens.space3())
         .borderRadiusAll(FortalTokens.radius3())
         .text(TextStyler().fontSize(14.0));
     }
     
     static RemixButtonStyle size3() {
       return RemixButtonStyle()
         .height(48.0)
         .paddingHorizontal(FortalTokens.space5())
         .paddingVertical(FortalTokens.space4())
         .borderRadiusAll(FortalTokens.radius4())
         .text(TextStyler().fontSize(16.0));
     }
   }
   ```

2. **Remove _ButtonSizeConfig class entirely**

3. **Update variant methods to not use size**:
   ```dart
   static RemixButtonStyle solid() {
     return RemixButtonStyle()
       .color(FortalTokens.accent9())
       .text(TextStyler().color(FortalTokens.accentContrast()))
       // No size-related properties here
       .onHovered(RemixButtonStyle().color(FortalTokens.accent10()));
   }
   ```

#### Phase 2: All Remaining Components (11 total)

Apply the same pattern to each component:

**High Priority** (most used):
1. **IconButton** - Similar to Button, 3 sizes
2. **TextField** - 3 sizes (height, padding, fontSize, radius)
3. **Checkbox** - 3 sizes (container size, check size)
4. **Radio** - 3 sizes (container size, dot size)
5. **Select** - 3 sizes (trigger height, content padding)

**Medium Priority**:
6. **Switch** - 3 sizes (track width/height, thumb size)
7. **Slider** - 3 sizes (thumb size, track height)
8. **Badge** - 3 sizes (height, padding, fontSize)

**Lower Priority**:
9. **Progress** - 3 sizes (track height, border radius)
10. **Spinner** - 3 sizes (diameter, stroke width)
11. **Card** - 3 sizes (padding, border radius)

#### Phase 3: Update Usage Patterns

**Examples and Tests**:
```dart
// Old pattern (remove)
RemixButton(style: FortalButtonStyles.solid(size: 2))

// New pattern (implement)
RemixButton(style: FortalButtonStyles.solid().size2())
```

### Size Configuration Standards

Each component should support 3 standard sizes:

**Size 1 (Small)**:
- Compact forms, toolbars, dense layouts
- Smaller padding, font size, dimensions

**Size 2 (Medium - Default)**:
- Standard forms, most common use case
- Balanced dimensions for general use

**Size 3 (Large)**:
- Prominent CTAs, accessibility needs
- Larger touch targets, increased visibility

### Critical Implementation Rules

1. **Remove ALL _SizeConfig classes** - They store wrong types and mix concerns
2. **Remove size parameters** from ALL variant methods
3. **Size methods return partial styles** that can be composed
4. **Use direct token calls** with () in size methods:
   ```dart
   .paddingHorizontal(FortalTokens.space4())  // ✅ Returns SpaceRef
   .borderRadiusAll(FortalTokens.radius3())   // ✅ Returns RadiusRef
   ```

### Next Steps

1. ✅ Review this plan (COMPLETED - corrected implementation patterns)
2. ✅ **System Simplified** - Removed variant-specific tokens, added direct scale tokens
3. ✅ **Button Updated** - Uses direct scale tokens: `accent9()`, `accent11()`, etc.
4. **CURRENT PRIORITY**: Implement size method refactoring:
   - Start with Button component as template pattern
   - Remove _ButtonSizeConfig class
   - Add .size1(), .size2(), .size3() methods
   - Remove size parameter from .solid(), .soft(), etc.
   - Test composition: `FortalButtonStyles.solid().size2()`
5. **Next**: Apply same pattern to remaining 10 components
6. **Finally**: Update all examples and test compilation

## ✅ **Simplified Token System Complete**

The Fortal token system is now simplified and more maintainable:
- **Direct Scale Access**: `accent1()` through `accent12()`, `gray1()` through `gray12()`
- **No More Variant Duplication**: Removed 30+ variant-specific tokens
- **Single Source of Truth**: All colors come from `FortalThemeColors` scales
- **Matches Fortal Spec**: Uses `{accent}[9]` notation directly in code
