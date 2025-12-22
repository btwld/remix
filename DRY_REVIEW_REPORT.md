# DRY Review Report: Remix Component Library

**Reviewed by:** DRY Reviewer Agent
**Date:** 2025-12-22
**Branch:** `claude/dry-code-reviewer-0rkLv`

---

## 1) Summary

- **FortalButtonStyle and FortalIconButtonStyle** are near-duplicates (~90% identical) sharing the same variant logic (solid, soft, surface, outline, ghost), color tokens, and state patterns - they should be unified.
- **Focus ring styling** is duplicated verbatim across 6+ components with identical `FortalTokens.focusA8()` / `focusRingWidth()` pattern - this is shared UI knowledge.
- **Disabled spinner pattern** repeats 8+ times in button/icon_button with identical `gray8()` color and `borderWidth1()` stroke configuration.
- **Spec classes follow identical boilerplate** (copyWith, lerp, debugFillProperties, props) - could benefit from code generation or mixin extraction.
- **Highest-risk duplication**: Button/IconButton variant styles - any token change (e.g., accent color step) requires editing both files identically.
- **Recommended action level**: **Strongly Recommend** for button/icon_button unification; **Medium** for focus ring extraction.

---

## 2) Findings

### Finding 1: FortalButtonStyle / FortalIconButtonStyle Near-Duplication

| Attribute | Value |
|-----------|-------|
| **Severity** | High |
| **Category** | DRY Violation |

**Evidence:**

| File | Lines | Shared Knowledge |
|------|-------|------------------|
| `fortal_button_styles.dart` | 56-201 | 5 variant methods (solid, soft, surface, outline, ghost) with identical color tokens |
| `fortal_icon_button_styles.dart` | 54-178 | Same 5 variant methods with identical color tokens |

**Shared "knowledge" in one sentence:** Both files encode the same Fortal design system's 5 visual variants using identical accent/gray tokens, hover/press/disabled state colors, and spinner configurations.

**Why it matters:**
- If `FortalTokens.accent9()` changes to `accent10()` for solid buttons, both files must be edited identically
- Already showing signs of divergence: Button ghost has special padding logic at size2 that IconButton doesn't
- Adding a new variant (e.g., "danger") requires changes in 2 places

**Recommendation:**

**Best option:** Extract shared variant styling into a generic helper that both can use:

```dart
// In a shared file like fortal_variant_mixins.dart
class FortalInteractiveVariants {
  // Returns color tokens for each variant - component applies to its style type
  static ({Color bg, Color fg, Color hover, Color disabled, ...}) solidColors() => (
    bg: FortalTokens.accent9(),
    fg: FortalTokens.accentContrast(),
    hover: FortalTokens.accent10(),
    disabledBg: FortalTokens.grayA3(),
    disabledFg: FortalTokens.gray8(),
  );

  static disabledSpinner() => RemixSpinnerStyle()
    .indicatorColor(FortalTokens.gray8())
    .strokeWidth(FortalTokens.borderWidth1());
}
```

**Alternative option:** Keep as-is if the teams anticipate Button and IconButton evolving separately (e.g., Button might get more complex semantics). Document the intentional duplication.

**Wrong-abstraction risk:** Low - these share identical design tokens by definition (Fortal system). The abstraction is data-driven (color records) not behavior-driven.

---

### Finding 2: Focus Ring Pattern Duplication

| Attribute | Value |
|-----------|-------|
| **Severity** | Medium |
| **Category** | DRY Violation |

**Evidence:**

| File | Line | Identical Pattern |
|------|------|-------------------|
| `fortal_button_styles.dart` | 46-51 | `.onFocused(RemixButtonStyle().borderAll(color: FortalTokens.focusA8(), width: FortalTokens.focusRingWidth()))` |
| `fortal_icon_button_styles.dart` | 44-49 | Same pattern, different style type |
| `fortal_checkbox_styles.dart` | 33-38 | Same pattern |
| `fortal_radio_styles.dart` | 31-36 | Same pattern |
| `fortal_switch_styles.dart` | 42-47 | Same pattern |
| `fortal_select_styles.dart` | 57-62 | Same pattern (nested in trigger) |

**Shared "knowledge":** Fortal's accessibility focus ring specification: `focusA8` color at `focusRingWidth` thickness via border.

**Why it matters:**
- If Fortal changes focus ring from border to box-shadow, 6+ files need identical edits
- WCAG compliance logic is scattered rather than centralized

**Recommendation:**

**Best option:** Create a focus ring helper that returns the border configuration:

```dart
// fortal_shared_states.dart
class FortalStates {
  static BorderAllMix focusRing() => BorderAllMix(
    color: FortalTokens.focusA8(),
    width: FortalTokens.focusRingWidth(),
  );
}

// Usage in each component:
.onFocused(RemixXxxStyle().borderAll(FortalStates.focusRing()))
```

**Alternative:** Since each component uses a different Style type, a mixin approach could work if the style classes share a common interface.

**Wrong-abstraction risk:** Low - the focus ring is a single, well-defined accessibility requirement.

---

### Finding 3: Disabled Spinner Style Duplication

| Attribute | Value |
|-----------|-------|
| **Severity** | Medium |
| **Category** | DRY Violation |

**Evidence:**

The pattern `.spinner(RemixSpinnerStyle().indicatorColor(FortalTokens.gray8()).strokeWidth(FortalTokens.borderWidth1()))` appears:
- `fortal_button_styles.dart`: lines 73-77, 96-100, 131-135, 164-168 (4 times)
- `fortal_icon_button_styles.dart`: lines 69-73, 90-94, 123-127, 154-158 (4 times)

**Shared "knowledge":** Fortal's disabled spinner appearance: gray8 indicator with borderWidth1 stroke.

**Why it matters:** 8 locations to update if disabled spinner appearance changes.

**Recommendation:**

```dart
// fortal_shared_states.dart
class FortalStates {
  static RemixSpinnerStyle disabledSpinner() => RemixSpinnerStyle()
    .indicatorColor(FortalTokens.gray8())
    .strokeWidth(FortalTokens.borderWidth1());
}
```

---

### Finding 4: Spec Class Boilerplate

| Attribute | Value |
|-----------|-------|
| **Severity** | Low |
| **Category** | Acceptable Repetition |

**Evidence:**

All spec classes (`RemixButtonSpec`, `RemixCheckboxSpec`, `RemixRadioSpec`, `RemixSwitchSpec`, etc.) follow identical patterns:
- `copyWith()` with null-coalescing
- `lerp()` with `MixOps.lerp()` calls
- `debugFillProperties()` with property additions
- `props` getter returning field list

**Why this is Acceptable Repetition:**
- The fields differ per component (container, label, icon vs container, thumb)
- Dart lacks the metaprogramming to easily abstract this without codegen
- The boilerplate is simple and unlikely to change in structure

**Recommendation:** Consider code generation (e.g., `freezed`, `built_value`, or custom build_runner generator) if the component count grows significantly. For now, accept the repetition as the cost of explicit Dart typing.

---

### Finding 5: Fortal Style Class Structure

| Attribute | Value |
|-----------|-------|
| **Severity** | Low |
| **Category** | Intentional Duplication |

**Evidence:**

All `fortal_*_styles.dart` files follow the same structure:
1. Size enum (`FortalXxxSize`)
2. Variant enum (`FortalXxxVariant`)
3. Private constructor `const FortalXxxStyle._();`
4. `create()` factory with switch on variant
5. `base()` method with size merge
6. Variant methods (solid, soft, etc.)
7. Private `_sizeStyle()` method

**Why this is Intentional Duplication:**
- This is a well-designed architectural pattern
- Each component genuinely has different size/variant specifications
- The structure provides consistency and discoverability
- Extracting a generic "FortalStyleFactory" would require complex generics and reduce readability

**Recommendation:** Keep as-is. This is a template pattern that provides consistency. Document the pattern in a CONTRIBUTING.md for new component authors.

---

## 3) Proposed Patch Sketch

### Unifying Button/IconButton Variant Colors

```dart
// New file: packages/remix/lib/src/fortal/fortal_shared_states.dart

part of '../components/button/button.dart'; // or standalone

/// Shared Fortal state styling tokens for interactive components.
class FortalInteractiveStates {
  const FortalInteractiveStates._();

  /// Standard focus ring for keyboard navigation.
  static BorderSideMix focusRing() => BorderSideMix()
      .color(FortalTokens.focusA8())
      .width(FortalTokens.focusRingWidth());

  /// Disabled spinner appearance.
  static RemixSpinnerStyle disabledSpinner() => RemixSpinnerStyle()
      .indicatorColor(FortalTokens.gray8())
      .strokeWidth(FortalTokens.borderWidth1());

  /// Solid variant colors for buttons/icon buttons.
  static _VariantColors solidColors() => _VariantColors(
    background: FortalTokens.accent9(),
    foreground: FortalTokens.accentContrast(),
    hoverBackground: FortalTokens.accent10(),
    disabledBackground: FortalTokens.grayA3(),
    disabledForeground: FortalTokens.gray8(),
  );

  // soft(), surface(), outline(), ghost() similarly...
}

class _VariantColors {
  final Color background;
  final Color foreground;
  final Color hoverBackground;
  final Color disabledBackground;
  final Color disabledForeground;

  const _VariantColors({
    required this.background,
    required this.foreground,
    required this.hoverBackground,
    required this.disabledBackground,
    required this.disabledForeground,
  });
}
```

### Updated FortalButtonStyle.solid() usage:

```dart
// fortal_button_styles.dart
static RemixButtonStyle solid({FortalButtonSize size = FortalButtonSize.size2}) {
  final colors = FortalInteractiveStates.solidColors();
  return base(size: size)
      .color(colors.background)
      .labelColor(colors.foreground)
      .iconColor(colors.foreground)
      .spinner(RemixSpinnerStyle().indicatorColor(colors.foreground))
      .onHovered(RemixButtonStyle().color(colors.hoverBackground))
      .onPressed(RemixButtonStyle().color(colors.hoverBackground))
      .onDisabled(
        RemixButtonStyle()
            .color(colors.disabledBackground)
            .labelColor(colors.disabledForeground)
            .iconColor(colors.disabledForeground)
            .spinner(FortalInteractiveStates.disabledSpinner()),
      );
}
```

### Updated base() with focus ring:

```dart
// In fortal_button_styles.dart and fortal_icon_button_styles.dart
static RemixButtonStyle base({FortalButtonSize size = FortalButtonSize.size2}) {
  return RemixButtonStyle()
      .label(TextStyler().fontWeight(FortalTokens.fontWeightMedium()))
      .spinner(RemixSpinnerStyle(
        strokeWidth: FortalTokens.borderWidth2(),
        duration: const Duration(milliseconds: 800),
      ))
      .onFocused(RemixButtonStyle().borderAll(
        color: FortalInteractiveStates.focusRing().color,
        width: FortalInteractiveStates.focusRing().width,
      ))
      .merge(_sizeStyle(size));
}
```

---

## 4) Verification Checklist

### Tests to Add/Update

- [ ] Unit test for `FortalInteractiveStates.solidColors()` returns expected token values
- [ ] Visual regression test confirming Button and IconButton solid variants render identically
- [ ] Test that all 5 variants (solid, soft, surface, outline, ghost) render correctly after refactor
- [ ] Test disabled state spinner uses correct gray8 color

### Smoke Checks

```bash
# Run existing tests
cd packages/remix && flutter test

# Visual check in playground/demo
cd packages/demo && flutter run
# Verify: Button solid, IconButton solid look identical
# Verify: Focus rings appear on keyboard navigation
# Verify: Disabled states show correct muted colors
```

### Rollout/Compatibility Concerns

- **Non-breaking**: The proposed changes are internal refactors; public API unchanged
- **Incremental**: Can refactor focus ring first, then disabled spinner, then variant colors
- **Risk**: If `FortalTokens` method signatures change, the shared state class centralizes the impact

---

## Severity Summary

| Finding | Severity | Action |
|---------|----------|--------|
| Button/IconButton variant duplication | **High** | Strongly Recommend refactor |
| Focus ring duplication | **Medium** | Suggest extraction |
| Disabled spinner duplication | **Medium** | Suggest extraction |
| Spec class boilerplate | **Low** | Accept (consider codegen later) |
| Style class structure | **None** | Intentional - keep as-is |

---

*Generated by DRY Reviewer Agent*
