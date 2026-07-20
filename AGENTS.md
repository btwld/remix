# Remix Architecture & Context

> **Last Updated:** 2025-11-05
> **Version:** 0.1.0-beta.1
> **Repository:** https://github.com/btwld/remix

## Executive Summary

Remix is a comprehensive Flutter component library that combines headless UI behavior with Mix's powerful styling system. It provides complete freedom to build and customize components that match any design system perfectly.

**Tech Stack:**
- **Language:** Dart 3.9.0+
- **Framework:** Flutter 3.35.0+
- **Styling:** Mix 2.0.0-dev.5 (composable styling system)
- **Behavior:** Naked UI 0.2.0-beta.7 (headless UI components)
- **Design System:** Fortal (Radix-inspired, included)
- **Monorepo:** Melos 7.1.1+ (workspace management)
- **Flutter Version:** Managed by FVM (stable channel)

**Key Features:**
- Ready-to-use components with built-in behavior and accessibility
- Complete styling freedom via Mix's chainable API
- State-aware styling (hover, focus, press, custom states)
- Smooth animations integrated with styling
- Production-ready Fortal design system
- Fully customizable and themeable

## Monorepo Structure

```
remix/
├── .fvmrc                    # FVM configuration (Flutter stable)
├── pubspec.yaml              # Workspace configuration
├── docs/                     # Documentation
├── packages/
│   ├── remix/                # Core library package
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── components/     # All UI components
│   │   │   │   ├── fortal/         # Fortal design system
│   │   │   │   └── ...
│   │   │   └── remix.dart          # Main export
│   │   ├── test/                   # Component tests
│   │   └── pubspec.yaml            # Package metadata
│   ├── demo/                 # Demo application
│   ├── example/              # Example code snippets
│   └── playground/           # Development playground
└── README.md
```

### Package Dependencies

**Workspace packages:**
- `remix` - Core component library (main package)
- `demo` - Interactive demo application
- `example` - Code examples and usage patterns
- `playground` - Development and testing environment

**Core dependencies:**
- `mix: ^2.0.0-dev.5` - Styling and theming system
- `naked_ui: ^0.2.0-beta.7` - Headless UI primitives
- `prism: ^2.0.0` - Token system
- `prism_flutter: ^2.0.0` - Flutter integration for tokens

## Key Architectural Patterns

### 1. Component Structure

All Remix components follow this pattern:

```dart
// Component Widget
class RemixButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final RemixButtonStyle? style;

  const RemixButton({
    required this.label,
    this.onPressed,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    // Uses Naked UI for behavior + Mix for styling
  }
}

// Style Class (Chainable API)
class RemixButtonStyle {
  RemixButtonStyle paddingX(double value) { /* ... */ }
  RemixButtonStyle paddingY(double value) { /* ... */ }
  RemixButtonStyle color(Color value) { /* ... */ }
  RemixButtonStyle onHovered(RemixButtonStyle style) { /* ... */ }
  RemixButtonStyle animate(AnimationConfig config) { /* ... */ }

  // Callable - style can be used as a function
  RemixButton call({required String label, VoidCallback? onPressed}) {
    return RemixButton(label: label, onPressed: onPressed, style: this);
  }
}
```

### 2. Styling System (Mix Integration)

Remix uses Mix for all styling. Mix provides:

**Chainable API:**
```dart
final style = RemixButtonStyle()
  .paddingX(16)
  .paddingY(10)
  .color(Colors.blue)
  .borderRadiusAll(const Radius.circular(8));
```

**State-based styling:**
```dart
final style = RemixButtonStyle()
  .color(Colors.blue)
  .onHovered(RemixButtonStyle().color(Colors.blue.shade700))
  .onPressed(RemixButtonStyle().wrapScale(x: 0.95, y: 0.95))
  .onDisabled(RemixButtonStyle().opacity(0.5));
```

**Animation integration:**
```dart
final style = RemixButtonStyle()
  .color(Colors.blue)
  .animate(AnimationConfig.spring(300.ms))
  .onHovered(RemixButtonStyle().color(Colors.blue.shade700));
```

**Style composition:**
```dart
final base = RemixButtonStyle().paddingX(16).paddingY(10);
final primary = base.color(Colors.blue);
final destructive = base.color(Colors.red);
```

### 3. Behavior System (Naked UI Integration)

Naked UI provides headless component behavior:
- Interaction handling (click, hover, focus, press)
- Keyboard navigation
- Accessibility (ARIA attributes, screen reader support)
- State management

Remix wraps Naked UI components and adds Mix styling on top.

### 4. Token System (Prism)

Fortal design system uses Prism for design tokens:

```dart
// Token access
FortalTokens.accent9()          // Accent color step 9
FortalTokens.space4()           // Spacing step 4
FortalTokens.radius3()          // Border radius step 3
FortalTokens.accentContrast()   // Contrast color for accent
```

**Token categories:**
- Colors: 12-step scales (powered by Radix Colors)
- Spacing: 9-step scale
- Border Radius: 6-step scale
- Shadows: 6-level system
- Typography: 9-size type scale
- Border Widths: Consistent strokes

### 5. Fortal Design System

Fortal provides production-ready styles:

**Usage:**
```dart
// Wrap app with Fortal scope
createFortalScope(
  child: RemixButton(
    style: FortalButtonStyle.solid(),
    label: 'Click me',
    onPressed: () {},
  ),
);

// Available variants
FortalButtonStyle.solid()     // Primary solid button
FortalButtonStyle.soft()      // Soft background button
FortalButtonStyle.outline()   // Outlined button
FortalButtonStyle.ghost()     // Ghost/text button
```

**Customization:**
```dart
final custom = FortalButtonStyle.solid()
  .borderRadiusAll(Radius.circular(8))
  .paddingX(32)
  .onHovered(RemixButtonStyle().wrapScale(x: 1.05, y: 1.05));
```

## Available Components

### Interactive Elements
- `RemixButton` - Clickable actions (lib/src/components/button/)
- `RemixIconButton` - Icon-based actions
- `RemixSwitch` - Toggle controls
- `RemixCheckbox` - Multiple selection
- `RemixRadio` - Single selection from group
- `RemixSlider` - Continuous value selection

### Input Components
- `RemixTextField` - Text input with validation
- `RemixSelect` - Dropdown with keyboard navigation

### Display Components
- `RemixAvatar` - User avatars and images
- `RemixBadge` - Status indicators and labels
- `RemixCard` - Content containers
- `RemixDivider` - Visual separators
- `RemixProgress` - Progress indicators
- `RemixSpinner` - Loading states

### Layout & Navigation
- `RemixTabs` - Tabbed navigation
- `RemixAccordion` - Collapsible sections
- `RemixMenu` - Context menus and dropdowns

### Overlays
- `RemixDialog` - Modal dialogs
- `RemixTooltip` - Contextual help
- `RemixCallout` - Highlighted information blocks

## Development Workflows

### Setup Environment

```bash
# Install FVM (if not installed)
dart pub global activate fvm

# Install Flutter via FVM
fvm install

# Install Melos
dart pub global activate melos

# Bootstrap workspace (installs all dependencies)
melos bootstrap

# Verify setup
flutter doctor
```

### Common Commands

```bash
# Bootstrap workspace
melos bootstrap

# Run all tests
melos run test:flutter

# Run CI tests
melos run ci

# Run specific package tests
cd packages/remix && flutter test

# Run demo app
cd packages/demo && flutter run

# Run playground
cd packages/playground && flutter run

# Clean all packages
melos clean

# Get dependencies for all packages
melos exec -- flutter pub get
```

### Adding a New Component

1. Create component directory: `packages/remix/lib/src/components/my_component/`
2. Create widget file: `my_component.dart`
3. Create style file: `my_component_style.dart`
4. Export from main: Add to `packages/remix/lib/remix.dart`
5. Add tests: `packages/remix/test/my_component_test.dart`
6. Add to demo: Update `packages/demo/lib/` with example
7. Run tests: `melos run test:flutter`

### Code Style & Standards

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `dart format` for formatting
- Use `dart analyze` for linting
- Component files use lowercase_with_underscores.dart naming
- Class names use PascalCase
- Private members use _leadingUnderscore

## Current State & Recent Changes

**Version:** 0.1.0-beta.1

**Recent commits:**
- `cd0446f` - chore: reorganize repo
- `847ef3d` - test: Add test for interactive widgets
- `399f06a` - Change banner image to new URL
- `ca43cac` - Change banner image source to hosted URL
- `0ae60d8` - refactor: Remove unused internal utilities and specs

**Active development areas:**
- Component library expansion
- Fortal design system refinement
- Documentation improvements
- Demo application enhancements
- Testing coverage

## Testing Strategy

**Unit tests:**
- Component behavior tests
- Style composition tests
- Token system tests
- State management tests

**Integration tests:**
- Component interaction tests
- Accessibility tests
- Animation tests

**Widget tests:**
- Visual regression tests
- Layout tests
- Responsive behavior tests

**Run tests:**
```bash
# All tests
melos run test:flutter

# Specific package
cd packages/remix && flutter test

# Specific test file
flutter test test/components/button_test.dart

# With coverage
flutter test --coverage
```

## Common Patterns

### Creating a Styled Component

```dart
// 1. Define style class
class MyComponentStyle {
  MyComponentStyle padding(double value) { /* ... */ }
  MyComponentStyle color(Color value) { /* ... */ }
  MyComponentStyle onHovered(MyComponentStyle style) { /* ... */ }
}

// 2. Create component widget
class MyComponent extends StatelessWidget {
  final MyComponentStyle? style;

  const MyComponent({this.style});

  @override
  Widget build(BuildContext context) {
    // Apply style using Mix
  }
}

// 3. Export from library
// Add to lib/remix.dart
```

### Using Fortal Tokens

```dart
final style = RemixButtonStyle()
  .color(FortalTokens.accent9())
  .paddingAll(FortalTokens.space4())
  .borderRadiusAll(FortalTokens.radius3())
  .label(TextStyler().color(FortalTokens.accentContrast()));
```

### Composing Styles

```dart
// Base style
final base = RemixButtonStyle()
  .paddingX(16)
  .paddingY(10)
  .borderRadiusAll(const Radius.circular(8));

// Variants
final primary = base.color(Colors.blue);
final secondary = base.color(Colors.gray);
final destructive = base.color(Colors.red);

// With states
final interactive = primary
  .onHovered(RemixButtonStyle().color(Colors.blue.shade700))
  .onPressed(RemixButtonStyle().wrapScale(x: 0.95, y: 0.95));

// With animation
final animated = interactive
  .animate(AnimationConfig.spring(300.ms));
```

### Using Callable Styles

```dart
// Style as function
final button = RemixButtonStyle()
  .paddingX(16)
  .paddingY(10)
  .color(Colors.blue);

// Call style to create widget
button(
  label: 'Click me',
  onPressed: () {},
); // Returns RemixButton widget
```

## Critical Files

### Core Library
- `packages/remix/lib/remix.dart` - Main library export
- `packages/remix/lib/src/components/` - All component implementations
- `packages/remix/lib/src/fortal/` - Fortal design system
- `packages/remix/pubspec.yaml` - Package configuration

### Workspace
- `pubspec.yaml` - Workspace configuration and Melos scripts
- `.fvmrc` - Flutter version configuration
- `README.md` - Project documentation

### Development
- `packages/demo/` - Demo application
- `packages/example/` - Usage examples
- `packages/playground/` - Development playground

## Integration Points

### Mix Integration
Remix heavily depends on Mix for styling. Understanding Mix is crucial:
- Mix provides the styling API and attribute system
- Remix wraps Mix's styling in component-specific style classes
- Animation is handled by Mix's animation system
- See: https://github.com/btwld/mix

### Naked UI Integration
Naked UI provides headless behavior:
- Keyboard navigation
- Focus management
- Accessibility features
- Interaction handling
- See: https://github.com/btwld/naked_ui

### Prism Integration
Prism provides the token system:
- Design tokens (colors, spacing, etc.)
- Token resolution and inheritance
- Theme switching support

## Performance Considerations

- Mix uses efficient attribute system for styling
- Components rebuild only when necessary
- Animation performance optimized via Mix
- Token system uses efficient lookup
- Widget tree kept shallow where possible

## Debugging Tips

**Style not applying:**
- Check if component wrapped in Fortal scope (if using Fortal)
- Verify style method chaining returns new instance
- Check state conditions (hover requires pointer device)

**Animation not working:**
- Ensure `.animate()` is called before state styles
- Check animation duration is reasonable (100-500ms typical)
- Verify Mix animation system is properly configured

**Component not responding:**
- Check if `onPressed` or similar callback is provided
- Verify Naked UI behavior is properly configured
- Check accessibility properties

**Build errors:**
- Run `melos bootstrap` to ensure dependencies
- Clean workspace: `melos clean && melos bootstrap`
- Check Flutter version: `fvm flutter --version`

**Test failures:**
- Ensure workspace is bootstrapped
- Run `flutter pub get` in test package
- Check for async timing issues in widget tests

## Additional Resources

- **Repository:** https://github.com/btwld/remix
- **Documentation:** https://docs.page/btwld/remix
- **Mix Repository:** https://github.com/btwld/mix
- **Naked UI Repository:** https://github.com/btwld/naked_ui
- **Issue Tracker:** https://github.com/btwld/remix/issues

## Quick Reference

**Component usage:**
```dart
RemixButton(
  label: 'Click me',
  onPressed: () {},
  style: RemixButtonStyle()
    .color(Colors.blue)
    .paddingX(16)
    .onHovered(RemixButtonStyle().color(Colors.blue.shade700)),
)
```

**Fortal usage:**
```dart
createFortalScope(
  child: RemixButton(
    style: FortalButtonStyle.solid(),
    label: 'Fortal button',
    onPressed: () {},
  ),
)
```

**Development commands:**
```bash
melos bootstrap           # Setup workspace
melos run test:flutter    # Run tests
cd packages/demo && flutter run  # Run demo
```
