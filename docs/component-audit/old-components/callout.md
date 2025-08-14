# Callout - Old Component Documentation

## Overview
The RxCallout is a feedback component used to display informational messages with optional icons in a visually distinct container. It serves as a way to highlight important information, warnings, tips, or other contextual messages to users. The component integrates with the Mix styling system and uses RxLabel internally for consistent text and icon presentation.

## API Parameters

### RxCallout Parameters

#### Required Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| text | String | The message text to display (default constructor) | - |
| child | Widget | Custom widget content (raw constructor) | - |

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| icon | IconData? | Optional icon to display alongside the text | null |
| variants | List<Variant> | Style variants to apply | const [] |
| style | RxCalloutStyle? | Custom styling configuration | null |

## Styling Configuration

### Default Theme Values
```dart
// Default styling from RxCalloutStyle._default()
container.borderRadius(6)
container.color.white()
container.padding(12)
container.border.all.color.grey.shade300()
container.flex.mainAxisSize.min()
container.flex.gap(8)
icon.color.black()
icon.size(16)
textStyle.color.black()
textStyle.fontWeight.w500()
```

### Style Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| container | FlexBoxSpec | Container styling (color, padding, border, layout) | FlexBoxSpec() |
| icon | IconThemeData | Icon theme configuration | IconThemeData() |
| textStyle | TextStyle | Text styling configuration | TextStyle() |
| modifiers | WidgetModifiersConfig | Widget modifiers configuration | null |
| animated | AnimatedData | Animation configuration | null |

## Behavior Documentation

### Interactions
- **Static Display**: Primarily serves as an informational display component
- **No Built-in Interactions**: Does not handle clicks, hovers, or focus by default
- **Content Presentation**: Uses RxLabel internally for consistent icon-text layout
- **Flexible Layout**: Container uses FlexBoxSpec for flexible sizing and alignment

### Animation/Transitions
- Supports animated properties through AnimatedData configuration
- Container properties (color, border, padding) can animate between states
- Icon and text styling transitions via Mix framework
- Smooth variant transitions for different callout types (info, warning, error)

### State Management
- Stateless widget with no internal state management
- All styling and content provided externally via parameters
- Style changes trigger rebuilds through SpecBuilder
- Uses IconTheme and DefaultTextStyle for consistent theming

## Variants and Configurations

### Constructors

#### RxCallout (Default Constructor)
- Standard callout with text and optional icon
```dart
RxCallout(
  text: 'Important information here',
  icon: Icons.info,
  variants: [InfoVariant()],
)
```

#### RxCallout.raw (Raw Constructor)
- Custom content callout with flexible widget child
```dart
RxCallout.raw(
  child: CustomCalloutContent(),
  variants: [WarningVariant()],
)
```

### Visual Configurations
- **Text Only**: Simple message display without icon
- **Icon + Text**: Message with contextual icon
- **Custom Content**: Arbitrary widget content via raw constructor
- **Variant-based**: Different styles for info, warning, error, success states

### Common Use Cases
- **Information**: General informational messages
- **Warning**: Cautionary messages requiring attention
- **Error**: Error states and problem notifications
- **Success**: Confirmation and success messages
- **Tips**: Helpful tips and guidance

## Accessibility Features
- Text content automatically accessible to screen readers
- Icon semantic meaning inherited from IconData properties
- Proper text rendering with Flutter's text accessibility support
- IconTheme and DefaultTextStyle provide consistent accessibility context
- Container structure maintains logical reading order
- No additional accessibility barriers introduced by the wrapper

## Dependencies
- **Required components**:
  - RxLabel (internal text and icon layout)
  - SpecBuilder (Mix framework integration)
  - FlexBoxSpec (container layout)
  - IconTheme & DefaultTextStyle (theming)

- **Utility dependencies**:
  - CalloutSpecUtility (styling utilities)
  - MixContext (style resolution)
  - Variant system (style variants)
  - IconThemeData & TextStyle (content styling)

- **Flutter dependencies**:
  - StatelessWidget (widget base)
  - IconData (icon representation)
  - Widget (child content)
  - BuildContext (context access)

## Usage Examples
```dart
// Basic informational callout
RxCallout(
  text: 'Your changes have been saved successfully.',
  icon: Icons.check_circle,
)

// Warning callout
RxCallout(
  text: 'This action cannot be undone. Please proceed with caution.',
  icon: Icons.warning,
  variants: [WarningVariant()],
  style: RxCalloutStyle()
    ..container.color.orange.shade50()
    ..container.border.color.orange.shade300()
    ..icon.color.orange.shade700()
    ..textStyle.color.orange.shade800(),
)

// Error callout
RxCallout(
  text: 'Failed to connect to server. Please try again.',
  icon: Icons.error,
  variants: [ErrorVariant()],
)

// Custom styled callout
RxCallout(
  text: 'Pro tip: Use keyboard shortcuts to work faster!',
  icon: Icons.lightbulb,
  style: RxCalloutStyle()
    ..container.color.blue.shade50()
    ..container.border.color.blue.shade200()
    ..container.borderRadius(12)
    ..container.padding.horizontal(16)
    ..container.padding.vertical(14)
    ..icon.color.blue.shade600()
    ..icon.size(20)
    ..textStyle.fontSize(14)
    ..textStyle.color.blue.shade800(),
)

// Complex custom content callout
RxCallout.raw(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        children: [
          Icon(Icons.announcement, size: 18),
          SizedBox(width: 8),
          Text('System Maintenance', 
               style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      SizedBox(height: 8),
      Text('Scheduled maintenance will occur on Sunday from 2-4 AM EST.'),
      SizedBox(height: 8),
      TextButton(
        child: Text('Learn More'),
        onPressed: () => showMaintenanceDetails(),
      ),
    ],
  ),
  variants: [InfoVariant()],
)

// Animated callout
RxCallout(
  text: currentMessage,
  icon: currentIcon,
  variants: currentVariants,
  style: RxCalloutStyle()
    ..animated.duration(Duration(milliseconds: 300))
    ..animated.curve(Curves.easeInOut),
)

// Callout without icon
RxCallout(
  text: 'Remember to save your work regularly.',
  style: RxCalloutStyle()
    ..container.color.grey.shade100()
    ..container.border.color.grey.shade300(),
)

// List of callouts
Column(
  children: [
    RxCallout(
      text: 'All systems operational',
      icon: Icons.check_circle,
      variants: [SuccessVariant()],
    ),
    SizedBox(height: 8),
    RxCallout(
      text: 'Maintenance scheduled for tonight',
      icon: Icons.schedule,
      variants: [InfoVariant()],
    ),
    SizedBox(height: 8),
    RxCallout(
      text: 'Database backup in progress',
      icon: Icons.backup,
      variants: [WarningVariant()],
    ),
  ],
)
```

## Notes
- Uses RxLabel internally, inheriting its icon positioning and text display capabilities
- Container uses FlexBox for flexible layout and sizing with mainAxisSize.min for compact presentation
- IconTheme and DefaultTextStyle provide consistent theming context for child content
- Style merging follows standard pattern: default → custom → variants
- Generated code includes lerp methods for smooth animation transitions
- Component is designed for static information display rather than interactive content
- Raw constructor provides maximum flexibility while maintaining consistent container styling
- Border radius and padding create distinct visual separation from surrounding content
- Gap spacing in container ensures proper visual rhythm between icon and text elements
- Can be used individually or in groups for status messages, notifications, and contextual information