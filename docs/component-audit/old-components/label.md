# Label - Old Component Documentation

## Overview
The RxLabel is a simple text display component with optional icon support and flexible positioning. It serves as a basic text presentation element that can be enhanced with icons positioned either at the start or end of the text. The component integrates with the Mix styling system and follows Remix design patterns for consistent theming and variant support.

## API Parameters

### RxLabel Parameters

#### Required Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| label | String | The text to display in the label | - |

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| icon | IconData? | Optional icon to display alongside the text | null |
| variants | List<Variant> | Style variants to apply | const [] |
| style | RxLabelStyle? | Custom styling configuration | null |
| iconPosition | IconPosition | Position of icon relative to text | IconPosition.start |

## Styling Configuration

### Default Theme Values
```dart
// Default values from LabelSpec
spacing: 8 // Spacing between icon and text
icon: IconSpec() // Default icon styling
label: TextSpec() // Default text styling
```

### Style Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| spacing | double | Space between icon and text | 8.0 |
| icon | IconSpec | Icon styling configuration | IconSpec() |
| label | TextSpec | Text styling configuration | TextSpec() |
| modifiers | WidgetModifiersConfig | Widget modifiers configuration | null |
| animated | AnimatedData | Animation configuration | null |

## Behavior Documentation

### Interactions
- **Static Display**: Primarily serves as a text display component
- **No Built-in Interactions**: Does not handle clicks, hovers, or focus by default
- **Layout**: Uses Row with mainAxisSize.min for compact presentation
- **Conditional Rendering**: Icon only renders when provided and positioned correctly

### Animation/Transitions
- Supports animated properties through AnimatedData configuration
- Text and icon styling can transition smoothly between states
- Layout changes (icon position) are immediate without animation
- Variant transitions can be animated via Mix framework

### State Management
- Stateless widget with no internal state
- All configuration provided externally via parameters
- Style changes trigger rebuilds through SpecBuilder
- Layout determined by iconPosition enum value

## Variants and Configurations

### Constructors

#### RxLabel (Default Constructor)
- Standard label with required text and optional icon
```dart
RxLabel(
  'Label Text',
  icon: Icons.star,
  iconPosition: IconPosition.start,
  variants: [PrimaryVariant()],
)
```

### Icon Positioning
- **IconPosition.start**: Icon appears before the text (left side in LTR layouts)
- **IconPosition.end**: Icon appears after the text (right side in LTR layouts)

### Visual Configurations
- **Text Only**: Simple text display without icon
- **Icon + Text**: Text with icon at specified position
- **Styled Label**: Custom typography and icon styling
- **Variant Label**: Pre-defined style variants applied

## Accessibility Features
- Text content automatically accessible to screen readers
- Icon semantic meaning inherited from IconData accessibility properties
- Proper text rendering with Flutter's text accessibility support
- No additional accessibility barriers introduced
- Maintains semantic relationship between icon and text through Row layout

## Dependencies
- **Required components**:
  - SpecBuilder (Mix framework integration)
  - LabelSpec (specification pattern)
  - IconSpec & TextSpec (content styling)

- **Utility dependencies**:
  - LabelSpecUtility (styling utilities)
  - MixContext (style resolution)
  - Variant system (style variants)
  - DiagnosticPropertiesBuilder (debugging)

- **Flutter dependencies**:
  - StatelessWidget (widget base)
  - Row (layout widget)
  - IconData (icon representation)
  - BuildContext (context access)

## Usage Examples
```dart
// Basic text label
RxLabel('Simple Label')

// Label with icon at start
RxLabel(
  'Starred Item',
  icon: Icons.star,
  iconPosition: IconPosition.start,
)

// Label with icon at end
RxLabel(
  'External Link',
  icon: Icons.open_in_new,
  iconPosition: IconPosition.end,
)

// Styled label
RxLabel(
  'Important Notice',
  icon: Icons.warning,
  style: RxLabelStyle()
    ..label.fontSize(16)
    ..label.fontWeight.w600()
    ..label.color.red.shade700()
    ..icon.color.red.shade700()
    ..icon.size(20)
    ..spacing(12),
)

// Label with variants
RxLabel(
  'Primary Action',
  icon: Icons.arrow_forward,
  iconPosition: IconPosition.end,
  variants: [PrimaryVariant(), BoldVariant()],
)

// Custom spacing
RxLabel(
  'Widely Spaced',
  icon: Icons.space_bar,
  style: RxLabelStyle()..spacing(24),
)

// Label as part of larger component
ListTile(
  leading: Icon(Icons.settings),
  title: RxLabel(
    'Settings',
    icon: Icons.chevron_right,
    iconPosition: IconPosition.end,
    style: RxLabelStyle()
      ..label.fontSize(16)
      ..icon.size(18)
      ..icon.color.grey.shade600(),
  ),
)

// Conditional icon display
RxLabel(
  'Status: ${isOnline ? "Online" : "Offline"}',
  icon: isOnline ? Icons.circle : null,
  style: RxLabelStyle()
    ..icon.color(isOnline ? Colors.green : Colors.transparent)
    ..icon.size(8),
)

// Animated label transitions
RxLabel(
  currentLabel,
  icon: currentIcon,
  style: RxLabelStyle()
    ..animated.duration(Duration(milliseconds: 200))
    ..animated.curve(Curves.easeInOut),
)
```

## Notes
- Very simple component focused on text + optional icon presentation
- Uses Row with mainAxisSize.min to take only required space
- Icon positioning handled through conditional rendering in children array
- No default styling applied - relies entirely on Mix theme system
- Spacing property controls gap between icon and text consistently
- IconPosition enum provides type-safe positioning options
- Style merging follows pattern: base style → custom style → variants
- Generated code includes utilities for debugging and property management
- Component serves as building block for other Remix components (Button, etc.)
- Stateless design ensures predictable rendering and performance
- Row layout with spacing property provides clean icon-text relationships
- Can be used standalone or as part of more complex component compositions