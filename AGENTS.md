# Remix Architecture & Context

> **Last Updated:** 2025-11-05
> **Version:** 0.1.0-beta.1
> **Status:** Active Development

## Executive Summary

Remix is a comprehensive Flutter component library that combines headless UI behavior with Mix's powerful styling system. It provides complete freedom to build and customize components that match any design system. Built on top of Naked UI (headless components) and Mix (styling system), Remix enables developers to create fully customizable, reusable, and maintainable components.

**Tech Stack:**
- **Language:** Dart 3.9.0+
- **Framework:** Flutter 3.35.0+
- **Monorepo:** Melos 7.1.1
- **Dependencies:** Mix 2.0.0-dev.5, Naked UI 0.2.0-beta.7
- **Styling:** Mix (chainable, composable styling API)
- **State:** Naked UI (headless component behavior)
- **Design System:** Fortal (prebuilt Radix-inspired styles)

## Project Structure

```
remix/
├── packages/
│   ├── remix/                   # Core library package
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── components/  # 20 production-ready components
│   │   │   │   │   ├── button/
│   │   │   │   │   │   ├── button.dart           # Main export
│   │   │   │   │   │   ├── button_spec.dart      # Mix specification
│   │   │   │   │   │   ├── button_style.dart     # Styling API
│   │   │   │   │   │   ├── button_widget.dart    # Widget implementation
│   │   │   │   │   │   └── fortal_button_styles.dart  # Prebuilt styles
│   │   │   │   │   ├── [20 other components follow same pattern]
│   │   │   │   ├── fortal/      # Fortal design system
│   │   │   │   │   ├── fortal_theme.dart  # Design tokens (colors, spacing, etc)
│   │   │   │   │   └── computed.dart      # Computed token values
│   │   │   │   ├── theme/       # Remix theme system
│   │   │   │   ├── style/       # Style utilities
│   │   │   │   └── utilities/   # Shared utilities
│   │   │   └── remix.dart       # Main library export
│   │   ├── test/                # Unit & widget tests
│   │   └── scripts/             # Component generation scripts
│   ├── demo/                    # Interactive demo app
│   │   └── lib/
│   │       ├── components/      # Demo pages for each component
│   │       └── helpers/         # Demo utilities
│   ├── example/                 # Example code snippets
│   │   └── lib/api/            # Usage examples for each component
│   └── playground/              # Interactive playground app
│       └── lib/
│           ├── registry/        # Component registry
│           └── routes/          # Playground routes
├── scripts/                     # Monorepo scripts
├── pubspec.yaml                 # Melos workspace configuration
└── .fvmrc                       # Flutter version (stable)
```

## Technology Stack

### Core Dependencies

**Mix (2.0.0-dev.5)** - Powerful styling system
- Chainable, composable API for Flutter widget styling
- State-aware styling (hover, focus, press, disabled)
- Animation support with springs and curves
- Theme tokens and design system integration
- Location: All `*_style.dart` and `*_spec.dart` files

**Naked UI (0.2.0-beta.7)** - Headless components
- Provides behavior, accessibility, keyboard navigation
- No styling opinions - fully customizable
- Used as foundation for all Remix components
- Location: Component widget implementations use Naked UI primitives

**Prism (2.0.0)** - Reactive state management
- Powers the styling system
- Handles state changes and rebuilds
- Location: Mix integration layer

### Build Tools

- **Melos:** Monorepo management, linking, bootstrapping
- **FVM:** Flutter Version Manager (configured for stable channel)
- **build_runner:** Code generation (if needed)
- **dart_code_metrics_presets:** Linting and code quality

## Key Architectural Patterns

### Pattern 1: Component Structure (4-File Pattern)

Every component follows a consistent structure:

**1. Main Export (`component.dart`):**
```dart
library remix_button;

// Imports
import 'package:mix/mix.dart';
import 'package:naked_ui/naked_ui.dart';

// Part files
part 'button_spec.dart';
part 'button_style.dart';
part 'button_widget.dart';
part 'fortal_button_styles.dart';
```

**2. Spec (`component_spec.dart`):**
- Mix specification defining structure
- Defines slots for child widgets
- Layout and container configuration
- Example: `RemixButtonSpec`

**3. Style (`component_style.dart`):**
- Chainable styling API
- State-aware styling methods (onHovered, onPressed, onFocused, onDisabled)
- Callable style (allows `style(...)` syntax)
- Example: `RemixButtonStyle`

**4. Widget (`component_widget.dart`):**
- Widget implementation using Naked UI
- Connects styling system to behavior
- Handles props and callbacks
- Example: `RemixButton`

**5. Fortal Styles (`fortal_component_styles.dart`):**
- Prebuilt styles for Fortal design system
- Static factory methods for variants
- Example: `FortalButtonStyle.solid()`, `FortalButtonStyle.outline()`

**Location:** `/packages/remix/lib/src/components/*/`

### Pattern 2: Mix Styling System

Mix provides a powerful, chainable API for styling:

```dart
final style = RemixButtonStyle()
  .paddingX(16)                    // Horizontal padding
  .paddingY(10)                    // Vertical padding
  .color(Colors.blue)              // Background color
  .borderRadiusAll(Radius.circular(8))
  .label(TextStyler().color(Colors.white))  // Nested styling
  .onHovered(                      // State-aware styling
    RemixButtonStyle().color(Colors.blue.shade700)
  )
  .animate(AnimationConfig.spring(300.ms));  // Smooth animations
```

**Key Features:**
- Chainable methods for all styling properties
- State variants: `onHovered()`, `onPressed()`, `onFocused()`, `onDisabled()`
- Nested styling: `label()`, `icon()`, etc.
- Animation support: `animate()` with springs, curves
- Style composition: Combine multiple styles

**Location:** All `*_style.dart` files

### Pattern 3: Callable Styles

Styles can be used as functions to create widgets:

```dart
final button = RemixButtonStyle()
  .paddingX(16)
  .color(Colors.blue);

// Use as callable
final widget = button(
  label: 'Click me',
  onPressed: () {},
);  // Returns RemixButton widget
```

**Implementation:** `call()` method in style classes

### Pattern 4: Fortal Design System

Fortal provides a complete design system with:

**Design Tokens:**
- **Colors:** 12-step accent and gray scales (Radix Colors)
  - Access: `FortalTokens.accent9()`, `FortalTokens.gray3()`
- **Spacing:** 9-step scale (1-9)
  - Access: `FortalTokens.space4()`, `FortalTokens.space8()`
- **Border Radius:** 6-step scale
  - Access: `FortalTokens.radius3()`, `FortalTokens.radius5()`
- **Shadows:** 6-level shadow system
  - Access: `FortalTokens.shadow2()`, `FortalTokens.shadow4()`
- **Typography:** 9-size type scale
  - Access: `FortalTokens.fontSize3()`, `FortalTokens.fontSize7()`

**Prebuilt Styles:**
```dart
FortalButtonStyle.solid()      // Solid variant
FortalButtonStyle.outline()    // Outline variant
FortalButtonStyle.ghost()      // Ghost variant
```

**Setup:**
```dart
createFortalScope(
  child: YourApp(),
)
```

**Location:** `/packages/remix/lib/src/fortal/`

### Pattern 5: State Management with Naked UI

Components use Naked UI's state management:

```dart
RemixButton(
  onPressed: () {},       // Callback
  disabled: false,        // Disabled state
  style: style,          // Styling
  label: 'Click',        // Content
)
```

Naked UI handles:
- Hover state tracking
- Focus state management
- Press state handling
- Keyboard navigation
- Accessibility (ARIA, semantics)

## Component Architecture

### Available Components (20)

**Interactive Elements:**
- `RemixButton` - Clickable actions
- `RemixIconButton` - Icon-based actions
- `RemixSwitch` - Toggle controls
- `RemixCheckbox` - Multiple selection
- `RemixRadio` - Single selection
- `RemixSlider` - Continuous value selection

**Input Components:**
- `RemixTextField` - Text input
- `RemixSelect` - Dropdown selection

**Display Components:**
- `RemixAvatar` - User avatars
- `RemixBadge` - Status indicators
- `RemixCard` - Content containers
- `RemixDivider` - Visual separators
- `RemixProgress` - Progress indicators
- `RemixSpinner` - Loading states

**Layout & Navigation:**
- `RemixTabs` - Tabbed navigation
- `RemixAccordion` - Collapsible sections
- `RemixMenu` - Context menus

**Overlays:**
- `RemixDialog` - Modal dialogs
- `RemixTooltip` - Contextual help
- `RemixCallout` - Highlighted information

### Component Pattern Example (Button)

**Files:**
- `button.dart` - Main export (library definition)
- `button_spec.dart` - Mix specification (structure)
- `button_style.dart` - Styling API (chainable methods)
- `button_widget.dart` - Widget implementation (Naked UI integration)
- `fortal_button_styles.dart` - Prebuilt Fortal styles (variants)

**Usage:**
```dart
// With style object
final style = RemixButtonStyle().color(Colors.blue);
RemixButton(style: style, label: 'Click', onPressed: () {});

// With callable style
final button = RemixButtonStyle().color(Colors.blue);
button(label: 'Click', onPressed: () {});

// With Fortal prebuilt style
RemixButton(
  style: FortalButtonStyle.solid(),
  label: 'Click',
  onPressed: () {},
);
```

## Development Workflows

### Setup

```bash
# Install FVM (if not installed)
dart pub global activate fvm

# Install Flutter via FVM
fvm install
fvm use --force

# Install Melos
dart pub global activate melos

# Bootstrap workspace (link packages, install dependencies)
melos bootstrap
```

### Common Tasks

- **Bootstrap workspace:** `melos bootstrap`
- **Run all tests:** `melos run test:flutter`
- **Run CI checks:** `melos run ci`
- **Install dependencies:** `melos exec -- flutter pub get`
- **Clean all packages:** `melos clean`

### Package-Specific Commands

**Remix package:**
```bash
cd packages/remix
flutter test                    # Run tests
flutter analyze                 # Analyze code
```

**Demo app:**
```bash
cd packages/demo
flutter run -d chrome           # Run demo in browser
flutter run -d macos            # Run demo on macOS
```

**Playground app:**
```bash
cd packages/playground
flutter run -d chrome           # Interactive component playground
```

## Critical Files & Conventions

| File | Purpose | Change Frequency |
|------|---------|------------------|
| `pubspec.yaml` (root) | Melos workspace config | Low - only when adding/removing packages |
| `packages/remix/lib/remix.dart` | Main library export | Medium - when adding new components |
| `packages/remix/lib/src/fortal/fortal_theme.dart` | Design tokens | Low - design system updates |
| `*_style.dart` | Component styling API | High - feature development |
| `*_widget.dart` | Component implementation | High - feature development |
| `fortal_*_styles.dart` | Prebuilt styles | Medium - design system updates |
| `.fvmrc` | Flutter version | Low - version upgrades |

## Coding Standards

### Component Development

**When adding a new component:**
1. Create directory in `packages/remix/lib/src/components/[component]/`
2. Create 5 files following the 4-file pattern
3. Export from `packages/remix/lib/remix.dart`
4. Add demo in `packages/demo/lib/components/`
5. Add example in `packages/example/lib/api/`
6. Add playground entry in `packages/playground/lib/registry/entries/`

**Style API Guidelines:**
- Use chainable methods for all properties
- Support state variants: `onHovered()`, `onPressed()`, `onFocused()`, `onDisabled()`
- Provide nested styling where applicable (e.g., `label()`, `icon()`)
- Support animations with `animate()`
- Make styles callable with `call()` method

**Widget Guidelines:**
- Use Naked UI primitives as base
- Keep widget implementation minimal (delegate to Naked UI)
- Accept style as parameter
- Follow Flutter's naming conventions

### Code Quality

- **Linting:** Use `dart_code_metrics_presets`
- **Analysis:** `flutter analyze` must pass with no issues
- **Formatting:** `dart format .` before committing
- **Testing:** Write widget tests for all components

## Testing Strategy

### Test Structure

```bash
packages/remix/test/
├── components/
│   ├── button_test.dart
│   ├── checkbox_test.dart
│   └── [other component tests]
└── integration/
    └── [integration tests]
```

### Running Tests

```bash
# All packages
melos run test:flutter

# Single package
cd packages/remix
flutter test

# Single test file
flutter test test/components/button_test.dart

# With coverage
flutter test --coverage
```

### Test Guidelines

- Write widget tests for all components
- Test styling API (style application)
- Test state management (hover, press, focus)
- Test accessibility features
- Test edge cases and error handling

## Current State

### Recent Changes (from commits)

**cd0446f** - Reorganized repository structure
**847ef3d** - Added interactive widget tests
**399f06a** / **ca43cac** - Updated banner image
**0ae60d8** - Removed unused utilities and specs

### Active Development Areas

- **Beta Phase:** Version 0.1.0-beta.1 - API may change
- **Mix 2.0 Integration:** Using dev version, tracking upstream changes
- **Fortal Design System:** Expanding prebuilt styles
- **Component Library:** 20 components currently available
- **Documentation:** Expanding examples and API docs

### Known Patterns

**Monorepo Structure:**
- Use Melos for all workspace operations
- Packages are linked via `resolution: workspace`
- Changes in `remix` package immediately available in `demo`/`playground`

**Version Management:**
- FVM configured for Flutter stable channel
- Dart SDK: >=3.9.0 <4.0.0
- Flutter: >=3.35.0

## Common Pitfalls

### Development

- **Don't forget `melos bootstrap`** - Required after git clone and when adding dependencies
- **Don't edit generated files** - Files with `.g.dart` suffix are generated
- **Don't bypass Melos** - Use `melos exec` for commands across packages
- **Mix dev version** - Breaking changes possible; check Mix repo for updates
- **FVM usage** - Always use `fvm flutter` instead of `flutter` directly

### Styling

- **State order matters** - Apply base styles first, then state variants
- **Animation placement** - Call `animate()` before state variants for proper transitions
- **Style composition** - Styles merge; later styles override earlier ones
- **Fortal scope required** - Wrap app with `createFortalScope()` to use Fortal tokens

### Components

- **Naked UI integration** - Components depend on Naked UI behavior; don't bypass it
- **Style vs Props** - Visual styling goes in style, behavior in props
- **Callable styles** - Remember `call()` method for style-as-function pattern

## Resources

- **Repository:** https://github.com/btwld/remix
- **Documentation:** https://docs.page/btwld/remix
- **Issues:** https://github.com/btwld/remix/issues
- **Mix Repository:** https://github.com/btwld/mix
- **Naked UI Repository:** https://github.com/btwld/naked_ui
- **Radix Colors:** https://www.radix-ui.com/colors (Fortal color system)

## Workspace Packages

### `remix` (Core)
- **Purpose:** Main component library
- **Dependencies:** Mix, Naked UI, Prism
- **Entry:** `lib/remix.dart`

### `demo` (Demo App)
- **Purpose:** Interactive demo application showcasing all components
- **Dependencies:** Remix (workspace), Flutter
- **Platform:** Web, macOS

### `example` (Examples)
- **Purpose:** Code examples and usage snippets
- **Dependencies:** Remix (workspace)
- **Location:** `lib/api/*.dart`

### `playground` (Playground App)
- **Purpose:** Interactive component playground for testing
- **Dependencies:** Remix (workspace)
- **Platform:** Web, macOS

## Quick Reference

### Component File Pattern
```
component/
├── component.dart              # Main export (library)
├── component_spec.dart         # Mix specification
├── component_style.dart        # Styling API
├── component_widget.dart       # Widget implementation
└── fortal_component_styles.dart  # Prebuilt Fortal styles
```

### Common Melos Commands
```bash
melos bootstrap    # Setup workspace
melos clean        # Clean all packages
melos exec         # Run command in all packages
melos run ci       # Run CI checks
```

### Common Flutter Commands
```bash
fvm flutter test              # Run tests
fvm flutter analyze           # Analyze code
fvm flutter run -d chrome     # Run on web
fvm flutter pub get           # Get dependencies
```

### Style Composition Example
```dart
// Base style
final base = RemixButtonStyle()
  .paddingX(16)
  .paddingY(10);

// Extend with variant
final primary = base
  .color(Colors.blue)
  .label(TextStyler().color(Colors.white));

// Add states
final interactive = primary
  .onHovered(RemixButtonStyle().color(Colors.blue.shade700))
  .onPressed(RemixButtonStyle().wrapScale(x: 0.95, y: 0.95))
  .animate(AnimationConfig.spring(300.ms));
```

---

**This document should be updated when:**
- New components are added
- Architecture patterns change
- Major dependencies are upgraded
- Design system tokens are modified
- Workspace structure changes
