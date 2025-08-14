# Card - Old Component Documentation

## Overview
The RxCard is a simple container component that displays a single child widget with customizable styling and variant support. It serves as a flexible wrapper that can encapsulate content within a styled container, providing consistent card-like presentation patterns. The component follows the Remix design system and integrates seamlessly with the Mix framework for theming and styling.

## API Parameters

### RxCard Parameters

#### Required Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| child | Widget | The child widget to be displayed inside the card | - |

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| style | RxCardStyle? | Custom styling configuration | null |
| variants | List<Variant> | Style variants to apply | const [] |

## Styling Configuration

### Default Theme Values
```dart
// Default styling from RxCardStyle._default()
container.borderRadius(8)
container.color.white()
container.border.all.color.black12()
container.padding.all(16)
```

### Style Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| container | BoxSpec | Container styling (padding, margin, border, color, etc.) | BoxSpec() |
| modifiers | WidgetModifiersConfig | Widget modifiers configuration | null |
| animated | AnimatedData | Animation configuration | null |

## Behavior Documentation

### Interactions
- **Hover**: Supports hover states via style.on.hover() configuration
- **Static Container**: Primarily serves as a styled wrapper without complex interactions
- **Content Layout**: Simply wraps child content with styling applied

### Animation/Transitions
- Supports animated properties through AnimatedData configuration
- Container transitions via BoxSpec lerp interpolation
- Smooth transitions between different card styles using CardSpecTween
- State-based animations for hover and other interaction states

### State Management
- Static widget with no internal state
- State changes handled through Mix framework
- Style changes trigger rebuilds through SpecBuilder
- Interactive states (hover, focus) managed via container styling

## Variants and Configurations

### Constructors

#### RxCard (Default Constructor)
- Standard card container with required child
```dart
RxCard(
  child: Text('Card Content'),
  style: customStyle,
  variants: [PrimaryVariant()],
)
```

### Visual Configurations
- **Basic Card**: Simple container with default styling
- **Styled Card**: Custom colors, borders, and padding
- **Interactive Card**: Hover states and visual feedback
- **Variant Card**: Pre-defined style variants (primary, secondary, etc.)

### Layout Options
- Padding controlled via `style.container.padding`
- Border radius via `style.container.borderRadius`
- Background color via `style.container.color`
- Border styling via `style.container.border`

## Accessibility Features
- Content accessibility inherited from child widgets
- Proper semantic structure maintained
- Focus management passed through to child content
- No additional accessibility barriers introduced
- Screen reader compatible through Flutter's widget hierarchy

## Dependencies
- **Required components**:
  - SpecBuilder (Mix framework integration)
  - CardSpec (specification pattern)
  - BoxSpec (container styling)

- **Utility dependencies**:
  - CardSpecUtility (styling utilities)
  - MixContext (style resolution)
  - Variant system (style variants)
  - DiagnosticPropertiesBuilder (debugging)

- **Flutter dependencies**:
  - StatelessWidget (widget base)
  - Widget (child content)
  - BuildContext (context access)

## Usage Examples
```dart
// Basic card
RxCard(
  child: Text('Hello, World!'),
)

// Card with custom styling
RxCard(
  child: Column(
    children: [
      Text('Title'),
      Text('Content'),
    ],
  ),
  style: RxCardStyle()
    ..container.padding.all(24)
    ..container.color.blue.shade50()
    ..container.borderRadius(12),
)

// Card with variants
RxCard(
  child: ListTile(
    leading: Icon(Icons.info),
    title: Text('Information'),
    subtitle: Text('This is a card with variants'),
  ),
  variants: [PrimaryVariant(), ElevatedVariant()],
)

// Interactive card with hover effects
RxCard(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Hover over me'),
  ),
  style: RxCardStyle()
    ..container.color.white()
    ..on.hover(
      RxCardStyle()
        ..container.color.grey.shade100()
        ..container.elevation(4),
    ),
)

// Card with complex content
RxCard(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          CircleAvatar(child: Text('U')),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User Name', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('user@example.com', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
      SizedBox(height: 12),
      Text('Card content goes here...'),
      SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(child: Text('Cancel'), onPressed: () {}),
          ElevatedButton(child: Text('Save'), onPressed: () {}),
        ],
      ),
    ],
  ),
  style: RxCardStyle()
    ..container.border.all.color.grey.shade300()
    ..container.borderRadius(8)
    ..container.padding.all(16),
)

// Animated card
RxCard(
  child: Text('Animated Card'),
  style: RxCardStyle()
    ..container.color.white()
    ..animated.duration(Duration(milliseconds: 200))
    ..animated.curve(Curves.easeInOut),
)
```

## Notes
- Extremely simple component with single child and styling focus
- All complexity comes from the styling system rather than component logic
- Uses SpecBuilder pattern for consistent Mix framework integration
- Style merging follows pattern: default style → custom style → variants
- Generated code includes utilities for copying, equality, debugging, and animation
- Supports all standard BoxSpec properties for container customization
- Widget modifiers allow additional wrapper functionality via modifiers parameter
- Diagnosticable implementation provides debugging support for development
- The container property directly becomes the widget through spec.container(child: child) call
- No built-in gestures or complex interactions - purely a styled container