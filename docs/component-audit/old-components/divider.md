# Divider - Old Component Documentation

## Overview
The RxDivider is a simple visual separator component that creates thin lines to organize and group content in layouts. It integrates with the Mix styling system and provides a clean way to visually separate content sections. The component is lightweight, stateless, and focuses purely on visual separation without any interactive behavior.

## API Parameters

### RxDivider Parameters

#### Required Parameters
None - all parameters are optional.

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| style | RxDividerStyle? | Custom styling configuration | null |
| variants | List<Variant> | Style variants to apply | const [] |

## Styling Configuration

### Default Theme Values
```dart
// Default styling from RxDividerStyle._default()
container.color.grey.shade300()
container.borderRadius(99)
container.height(1)
container.width.infinity()
```

### Style Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| container | BoxSpec | The visual divider line container | BoxSpec() |

### Common Style Customizations
- **Height**: Controls thickness of the divider line
- **Width**: Controls length of the divider (infinity for full width)
- **Color**: Sets the divider line color
- **Border Radius**: Rounds the ends of the divider
- **Margin**: Adds spacing around the divider
- **Padding**: Adds internal spacing (rarely used for dividers)

## Behavior Documentation

### Interactions
- **No Interactions**: The divider is purely visual with no user interaction
- **Static Display**: Always visible and unchanging
- **Layout Impact**: Takes up space in layouts as a visual separator

### Animation/Transitions
- **No Built-in Animations**: Component is stateless and static
- **Custom Animation**: Can be animated via Mix animation system if needed
- **Style Transitions**: Smooth transitions possible when style changes

### State Management
- **Stateless**: No internal state management required
- **No Controllers**: No need for interaction controllers
- **Pure Visual**: Focuses solely on visual presentation

## Variants and Configurations

### Constructors

#### RxDivider
- Simple stateless divider with styling options

### Visual Variations
- **Horizontal Line**: Default full-width horizontal separator
- **Vertical Line**: Custom styled for vertical separation
- **Thick Divider**: Increased height for prominent separation
- **Colored Divider**: Custom colors for brand consistency
- **Rounded Divider**: Rounded ends via border radius
- **Dashed/Dotted**: Via custom border styling

### Layout Usage Patterns
- **List Separators**: Between list items
- **Section Breaks**: Between content sections
- **Card Borders**: As visual boundaries
- **Form Separators**: Between form sections

## Accessibility Features
- **Semantic Role**: Acts as visual separator (no semantic meaning)
- **Screen Reader**: Generally ignored by screen readers as decorative
- **Non-interactive**: No focus or keyboard navigation needed
- **Visual Only**: Purely decorative element for visual organization

## Dependencies
- **Required components**:
  - SpecBuilder (style application)
  
- **Utility dependencies**:
  - DividerSpec (specification pattern)
  
- **Theme dependencies**:
  - BoxSpec (container styling)
  - Color system for divider coloring
  - Mix styling system integration

## Usage Examples
```dart
// Basic horizontal divider
RxDivider()

// Custom colored divider
RxDivider(
  style: RxDividerStyle()
    ..container.color.blue.shade300(),
)

// Thick divider
RxDivider(
  style: RxDividerStyle()
    ..container.height(3)
    ..container.color.grey.shade600(),
)

// Rounded thick divider
RxDivider(
  style: RxDividerStyle()
    ..container.height(4)
    ..container.borderRadius(2)
    ..container.color.green.shade400(),
)

// Short divider with custom width
RxDivider(
  style: RxDividerStyle()
    ..container.width(100)
    ..container.color.red.shade400(),
)

// Divider with margin spacing
RxDivider(
  style: RxDividerStyle()
    ..container.margin.vertical(16)
    ..container.color.grey.shade400(),
)

// Vertical divider (requires container height)
Container(
  height: 50,
  child: RxDivider(
    style: RxDividerStyle()
      ..container.width(1)
      ..container.height.infinity()
      ..container.color.grey.shade500(),
  ),
)

// In a list layout
Column(
  children: [
    Text('Section 1'),
    RxDivider(),
    Text('Section 2'),
    RxDivider(
      style: RxDividerStyle()
        ..container.color.blue.shade200(),
    ),
    Text('Section 3'),
  ],
)

// With variants
RxDivider(
  variants: [PrimaryVariant()],
  style: RxDividerStyle()
    ..container.height(2),
)

// Subtle divider
RxDivider(
  style: RxDividerStyle()
    ..container.color.grey.shade100()
    ..container.height(0.5),
)

// Prominent divider with shadow effect
RxDivider(
  style: RxDividerStyle()
    ..container.color.grey.shade400()
    ..container.height(1)
    ..container.elevation(1),
)
```

## Notes
- Extremely lightweight component focusing solely on visual separation
- Default full-width behavior makes it suitable for most layout scenarios
- Rounded border radius (99) creates smooth line ends by default
- Can be customized to work as both horizontal and vertical dividers
- Stateless design means no performance overhead for state management
- Style merging: default style → custom style → variants
- No interactive behavior keeps the component simple and focused
- Full integration with Mix styling system for consistent theming
- Works well in lists, forms, cards, and any layout requiring visual separation
- Can be animated externally even though component itself is stateless