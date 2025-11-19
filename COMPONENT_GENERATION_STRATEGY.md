# Mix Component Generation Strategy

## Overview

This document outlines a comprehensive code generation strategy for Mix Flutter components based on the thorough architecture analysis of the 20-component codebase.

---

## Current State Analysis

### Statistics
- **20 total components** implementing a consistent 3-tier architecture
- **~100 Dart files** organized in a library pattern
- **~5,040 lines of boilerplate code** (68% average duplication)
- **100+ duplicate methods** with identical implementations across components

### Architecture Pattern
```
1. Style Classes (RemixXyzStyle)     → Fluent API builders, resolve/merge logic
2. Spec Classes (RemixXyzSpec)       → Immutable data holders, copyWith/lerp
3. Widget Classes (RemixXyz)          → UI rendering components
4. Theme Factories (FortalXyzStyles)  → Design system integration
```

---

## Code Generation Roadmap

### Phase 1: Spec Class Generation (Immediate - 100% Automated)

**Target**: Generate complete *_spec.dart files

**Input Metadata**:
```dart
ComponentFieldDef(
  name: 'container',
  type: 'BoxSpec',
  nullable: true,
  defaultValue: 'const StyleSpec(spec: BoxSpec())',
)
```

**Output**: Complete Spec class with:
- Constructor with null coalescing
- copyWith() method
- lerp() method
- debugFillProperties() override
- props getter
- Full docstring documentation

**Examples Generated**:
- RemixBadgeSpec (2 fields, ~42 lines)
- RemixButtonSpec (4 fields, ~70 lines)
- RemixDialogSpec (5 fields, ~90 lines)
- RemixSelectSpec (3 nested specs, ~150 lines)

**Lines Saved**: ~1,000 lines
**Effort**: 2-3 hours to build generator
**ROI**: Immediate, 100% tested

---

### Phase 2: Style Class Boilerplate (High Priority - 98% Automated)

**Target**: Generate 70% of *_style.dart files

**Input Metadata**:
```dart
StyleClassDef(
  name: 'RemixBadgeStyle',
  specName: 'RemixBadgeSpec',
  baseClass: StyleBaseClass.container, // container, flexContainer, custom
  fields: [
    StyleFieldDef('container', 'BoxSpec', 'BoxStyler'),
    StyleFieldDef('text', 'TextSpec', 'TextStyler'),
  ],
  mixins: ['LabelStyleMixin'],
)
```

**Generated Code**:
- Prop field declarations
- Factory constructor (.create)
- Public constructor
- resolve() method
- merge() method
- props getter

**Not Generated** (manually implemented):
- Convenience methods (custom per component)
- Custom helper methods
- Special overrides

**Output Scaffold**:
```dart
// GENERATED - DO NOT EDIT
class RemixBadgeStyle extends RemixContainerStyle<RemixBadgeSpec, RemixBadgeStyle>
    with LabelStyleMixin<RemixBadgeStyle> {
  // ... [constructor, resolve, merge, props - all generated]
  
  // TODO: Add convenience methods
  // TODO: Implement custom style helpers
}
```

**Lines Saved**: ~1,400 lines
**Effort**: 4-5 hours to build generator
**ROI**: High, reduces manual class boilerplate

---

### Phase 3: Convenience Methods (High Value - 95% Automated)

**Target**: Generate common convenience methods for container-based styles

**Input**: Base class type
```dart
enum StyleBaseClass {
  container,      // RemixContainerStyle
  flexContainer,  // RemixFlexContainerStyle
  custom,         // Custom (no generation)
}
```

**Generated Methods** (for container-based styles):
```dart
RemixXyzStyle padding(EdgeInsetsGeometryMix value) {
  return merge(RemixXyzStyle(container: BoxStyler(padding: value)));
}

RemixXyzStyle margin(EdgeInsetsGeometryMix value) {
  return merge(RemixXyzStyle(container: BoxStyler(margin: value)));
}

RemixXyzStyle decoration(DecorationMix value) {
  return merge(RemixXyzStyle(container: BoxStyler(decoration: value)));
}

RemixXyzStyle alignment(Alignment value) {
  return merge(RemixXyzStyle(container: BoxStyler(alignment: value)));
}

RemixXyzStyle constraints(BoxConstraintsMix value) {
  return merge(RemixXyzStyle(container: BoxStyler(constraints: value)));
}

RemixXyzStyle borderRadius(BorderRadiusGeometryMix radius) {
  return merge(RemixXyzStyle(container: BoxStyler(decoration: 
    BoxDecorationMix(borderRadius: radius))));
}

RemixXyzStyle foregroundDecoration(DecorationMix value) {
  return merge(RemixXyzStyle(container: BoxStyler(foregroundDecoration: value)));
}

RemixXyzStyle transform(Matrix4 value, {AlignmentGeometry alignment = Alignment.center}) {
  return merge(RemixXyzStyle(container: BoxStyler(
    transform: value, 
    transformAlignment: alignment)));
}
```

**Lines Saved**: ~1,500 lines
**Effort**: 3-4 hours to build generator
**ROI**: Very high, eliminates most copy-paste

---

### Phase 4: Widget Class Templates (Medium Value - 50% Automated)

**Target**: Generate widget class scaffolds with TODO markers

**Types of Widgets**:

1. **Simple StyleWidget<T>** (Badge, Avatar, Card, Divider)
   - Template: Basic structure with build() method signature
   - Manual: Rendering logic inside build()

2. **Stateful with NakedXXX** (Button, Checkbox, Radio, Select)
   - Template: NakedButton builder structure
   - Manual: StyleBuilder content and state handling

3. **Complex Custom** (Dialog, Menu, Tabs, Textfield)
   - Template: Class structure with required fields
   - Manual: Full implementation

**Generated Scaffold Example**:
```dart
/// A customizable badge component for displaying labels and status indicators.
class RemixBadge extends StyleWidget<RemixBadgeSpec> {
  const RemixBadge({
    super.style = const RemixBadgeStyle.create(),
    super.styleSpec,
    super.key,
    // TODO: Add widget-specific parameters
    this.label,
    this.child,
    this.labelBuilder,
  });

  // TODO: Document properties
  final String? label;
  final Widget? child;
  final RemixBadgeLabelBuilder? labelBuilder;

  @override
  Widget build(BuildContext context, RemixBadgeSpec spec) {
    // TODO: Implement rendering logic
    return Box(styleSpec: spec.container);
  }
}
```

**Lines Saved**: ~200-400 lines
**Effort**: 5-6 hours to build generator (multiple templates)
**ROI**: Medium, saves boilerplate but requires careful implementation

---

### Phase 5: Fortal Theme Files (Medium Value - 60% Automated)

**Target**: Generate Fortal theme factory templates with token placeholders

**Input Metadata**:
```dart
FortalThemeDef(
  componentName: 'badge',
  variants: ['solid', 'soft', 'surface', 'outline'],
  sizes: ['size1', 'size2', 'size3'],
  stateVariants: [], // for stateful components
)
```

**Generated Structure**:
```dart
// GENERATED TEMPLATE - Customize token selections
class FortalBadgeStyles {
  const FortalBadgeStyles._();

  static RemixBadgeStyle create({
    FortalBadgeVariant variant = FortalBadgeVariant.solid,
    FortalBadgeSize size = FortalBadgeSize.size2,
  }) {
    return switch (variant) {
      FortalBadgeVariant.solid => solid(size: size),
      FortalBadgeVariant.soft => soft(size: size),
      FortalBadgeVariant.surface => surface(size: size),
      FortalBadgeVariant.outline => outline(size: size),
    };
  }

  static RemixBadgeStyle solid({FortalBadgeSize size = FortalBadgeSize.size2}) {
    return base(size: size)
        .color(FortalTokens.accent9()) // TODO: Select token
        .labelColor(FortalTokens.accentContrast()) // TODO: Select token
        // ... TODO: Add variant styles (hover, pressed, disabled)
        ;
  }

  static RemixBadgeStyle _sizeStyle(FortalBadgeSize size) {
    final style = RemixBadgeStyle();
    return switch (size) {
      FortalBadgeSize.size1 => RemixBadgeStyle(
        container: BoxStyler()
            .paddingX(6.0) // TODO: Select token
            .paddingY(2.0) // TODO: Select token
            .borderRadiusAll(FortalTokens.radius2()),
        text: TextStyler().fontSize(11.0).height(16.0 / 11.0),
      ),
      // ... TODO: Add other sizes
    };
  }
}
```

**Lines Saved**: ~1,500 lines (with guidance)
**Effort**: 4-5 hours to build generator
**ROI**: Medium-High, captures common patterns

---

## Implementation Plan

### Step 1: Metadata Definition (Week 1)
Create a YAML/JSON-based metadata schema for components:
```yaml
components:
  badge:
    name: RemixBadge
    libraryName: remix_badge
    baseClass: RemixContainerStyle
    fields:
      - name: container
        type: BoxSpec
        fieldType: BoxStyler
        documentation: "The badge container styling"
      - name: text
        type: TextSpec
        fieldType: TextStyler
        documentation: "The badge text/label styling"
    mixins:
      - LabelStyleMixin
    convenience_methods:
      - padding
      - margin
      - alignment
      - decoration
    fortal:
      variants:
        - solid
        - soft
        - surface
        - outline
      sizes:
        - size1
        - size2
        - size3
```

### Step 2: Spec Generator (Week 2)
Build generator for Phase 1:
- Parse metadata
- Generate Spec classes
- Validate generated code
- Test against existing specs

### Step 3: Style Boilerplate Generator (Week 3)
Build generator for Phase 2:
- Generate Prop fields
- Generate both constructors
- Generate resolve() and merge()
- Add mixin support

### Step 4: Convenience Methods Generator (Week 4)
Build generator for Phase 3:
- Template standard methods
- Support for custom methods
- Per-component customization

### Step 5: Widget & Fortal Generators (Week 5)
Build generators for Phases 4-5:
- Template-based generation
- TODO markers for custom code
- Integration testing

### Step 6: Integration & Testing (Week 6)
- Test on all 20 components
- Validate output against existing code
- Create documentation
- Build CLI tool

---

## Expected Outcomes

### Code Reduction
- **Before**: ~420 lines per component (average)
- **After**: ~250 lines per component (30% reduction)
- **Total Saved**: ~3,400 lines across 20 components

### Time Savings per Component
- **Before**: 2-3 hours (including boilerplate copying & customization)
- **After**: 30-45 minutes (only widget logic + fortal customization)
- **Total Saved**: ~30-40 hours development time

### Consistency Improvements
- 100% consistent Spec implementations
- 100% consistent Style boilerplate
- Standardized convenience method naming
- Automatic documentation from metadata

### Quality Improvements
- Fewer copy-paste errors
- Automatic type checking in generator
- Generated code always follows best practices
- Easy to audit and update patterns

---

## Risk Assessment

### Low Risk (Spec Generation)
- Pure data class generation
- Validated by strong typing
- Easy to test against existing code
- Can be rolled back easily

### Medium Risk (Style Boilerplate)
- More complex generation logic
- Mixin composition needs careful handling
- Should be tested thoroughly
- Manual review recommended before commit

### Medium-High Risk (Widget Templates)
- Requires multiple template types
- Custom logic varies per component
- Should include TODO markers
- Requires manual implementation

### Medium Risk (Fortal Themes)
- Design-dependent customization
- Token selection is manual
- Template captures pattern
- Reduces manual work but not fully automatic

---

## Migration Strategy

### Conservative Approach (Recommended)
1. Generate Spec classes → Review → Commit
2. Generate Style boilerplate → Add convenience methods manually → Review → Commit
3. Create Widget templates → Implement manually → Review → Commit
4. Create Fortal templates → Customize tokens → Review → Commit

This keeps human decision-making in the loop while reducing mechanical work.

### Aggressive Approach
Generate all phases at once, review integrated results, commit in bulk.
- Faster but higher risk
- Recommended only after proving generator correctness

---

## Tool Requirements

### Generator Features Needed
1. **Metadata Parser**: YAML/JSON support
2. **Code Generation**: Dart AST generation or string templates
3. **Validation**: Generated code syntax checking
4. **Formatting**: dart format integration
5. **Diff Viewer**: Show changes before committing
6. **CLI**: Command-line interface for selective generation
7. **Documentation**: Auto-generate docs from metadata

### Suggested Technology Stack
- **Language**: Dart (for Flutter ecosystem familiarity)
- **Metadata**: YAML (human-readable)
- **Generation**: Dart code_builder package or mustache templates
- **Validation**: analyzer package
- **Formatting**: dart format CLI
- **Testing**: test package

---

## Success Criteria

1. **Code Quality**: Generated code matches/exceeds existing code quality
2. **Coverage**: 100% of boilerplate patterns captured
3. **Consistency**: All 20 components generate identically
4. **Maintainability**: Easy to update generator when patterns change
5. **Extensibility**: Simple to add new components via metadata
6. **Time Savings**: 50%+ reduction in component creation time
7. **Developer Experience**: Clear error messages and helpful TODOs

---

## Recommendations

### Start Here
1. Build Spec generator first (Phase 1)
   - Lowest risk
   - Highest confidence
   - Immediate value
   - Validates approach

2. Validate against all 20 existing specs
   - Ensure 100% match
   - Catch edge cases early

3. Then move to Style boilerplate (Phase 2)
   - Larger scope
   - More dependencies
   - Build on Phase 1 success

### Don't Start With
- Widget templates (too varied, hard to validate)
- Fortal themes (too design-dependent)
- Build all phases at once (too risky)

### Long-term Value
Once system is proven:
1. Use for all new components
2. Consider retrofitting existing components
3. Apply patterns to other Flutter projects
4. Open-source the generator
5. Build IDE plugins for faster development

---

## Conclusion

The Mix codebase presents an **ideal candidate for code generation** due to:
- Highly consistent architecture
- Predictable patterns across components
- Significant boilerplate code (5000+ lines)
- 20 validated examples to test against
- Clear extension points for customization

A phased approach starting with Spec classes will provide **immediate ROI** while building confidence for more complex generations. The final system could **save 30-40 hours** of development time while improving consistency and code quality.

