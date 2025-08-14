# Progress - Old Component Documentation

## Overview
The RxProgress is a visual feedback component that displays a progress bar indicating completion percentage between 0 and 1. It consists of a track (background) and a fill (foreground) that dynamically resizes based on the progress value. The component uses a Stack-based layout with LayoutBuilder for responsive sizing and supports extensive customization through the Mix styling system.

## API Parameters

### RxProgress Parameters

#### Required Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| value | double | The progress value between 0 and 1 (with assertion check) | - |

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| style | RxProgressStyle? | Custom styling configuration | null |
| variants | List<Variant> | Style variants to apply | const [] |

## Styling Configuration

### Default Theme Values
```dart
// Default styling from RxProgressStyle._default()
container.height(6)
container.clipBehavior.antiAlias()
container.shape.stadium()
fill.color.black()
fill.borderRadius(99)
track.color.grey.shade200()
```

### Style Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| container | BoxSpec | Main container styling (height, shape, clipping) | BoxSpec() |
| track | BoxSpec | Background track styling (color, shape) | BoxSpec() |
| fill | BoxSpec | Progress fill styling (color, shape) | BoxSpec() |
| outerContainer | BoxSpec | Optional outer container overlay | BoxSpec() |
| animated | AnimatedData | Animation configuration | null |
| modifiers | WidgetModifiersConfig | Widget modifiers configuration | null |

## Behavior Documentation

### Interactions
- **Static Display**: Primarily serves as a visual indicator without built-in interactions
- **Value-Driven**: Progress fill width calculated as `containerWidth * value`
- **Responsive Layout**: Uses LayoutBuilder to adapt to available space
- **Stack Layering**: Track renders first, then fill, then optional outer container

### Animation/Transitions
- Supports animated properties through AnimatedData configuration
- Fill width changes can be animated smoothly between progress values
- Color transitions for fill and track via Mix framework
- Container properties (height, border radius) can animate between states

### State Management
- Stateless widget with externally controlled progress value
- Value assertion ensures input remains within valid 0-1 range
- No internal state - all changes driven by external value updates
- Style changes trigger rebuilds through SpecBuilder

## Variants and Configurations

### Constructors

#### RxProgress (Default Constructor)
- Standard progress bar with required value parameter
```dart
RxProgress(
  value: 0.75,
  variants: [PrimaryVariant()],
  style: customProgressStyle,
)
```

### Visual Configurations
- **Linear Progress**: Standard horizontal progress bar
- **Custom Height**: Adjustable thickness via container.height
- **Rounded**: Stadium shape for rounded ends
- **Square**: Rectangular progress bars with custom border radius
- **Color Variants**: Different fill and track colors for various states

### Progress States
- **Empty**: value = 0.0 (no fill visible)
- **Partial**: value between 0.0 and 1.0 (proportional fill)
- **Complete**: value = 1.0 (full fill width)
- **Indeterminate**: Not supported (requires explicit value)

## Accessibility Features
- Progress value can be exposed to screen readers through parent semantics
- Visual representation automatically scales with container size
- Color contrast considerations for fill vs track colors
- No additional semantic information provided by default
- Proper semantic context should be added by parent components

## Dependencies
- **Required components**:
  - SpecBuilder (Mix framework integration)
  - ProgressSpec (specification pattern)
  - Stack (layered layout)
  - LayoutBuilder (responsive sizing)

- **Utility dependencies**:
  - ProgressSpecUtility (styling utilities)
  - MixContext (style resolution)
  - Variant system (style variants)
  - DiagnosticPropertiesBuilder (debugging)

- **Flutter dependencies**:
  - StatelessWidget (widget base)
  - BoxConstraints (layout constraints)
  - SizedBox (fill sizing)
  - BuildContext (context access)

## Usage Examples
```dart
// Basic progress bar
RxProgress(value: 0.65)

// Custom styled progress
RxProgress(
  value: 0.4,
  style: RxProgressStyle()
    ..container.height(8)
    ..fill.color.blue.shade600()
    ..track.color.blue.shade100()
    ..container.shape.rectangle()
    ..container.borderRadius(4),
)

// Success state progress
RxProgress(
  value: 1.0,
  variants: [SuccessVariant()],
  style: RxProgressStyle()
    ..fill.color.green.shade600()
    ..track.color.green.shade100(),
)

// Thick progress bar
RxProgress(
  value: progressValue,
  style: RxProgressStyle()
    ..container.height(12)
    ..fill.color.purple.shade600()
    ..fill.borderRadius(6),
)

// Animated progress updates
AnimatedBuilder(
  animation: progressAnimation,
  builder: (context, child) {
    return RxProgress(
      value: progressAnimation.value,
      style: RxProgressStyle()
        ..animated.duration(Duration(milliseconds: 300))
        ..animated.curve(Curves.easeInOut),
    );
  },
)

// Progress with outer container styling
RxProgress(
  value: 0.3,
  style: RxProgressStyle()
    ..container.height(10)
    ..fill.color.orange.shade600()
    ..track.color.orange.shade100()
    ..outerContainer.border.all.color.orange.shade300()
    ..outerContainer.borderRadius(5),
)

// Loading progress with variants
RxProgress(
  value: loadingProgress,
  variants: [LoadingVariant()],
  style: RxProgressStyle()
    ..container.height(4)
    ..fill.color.blue.shade500()
    ..track.color.grey.shade200(),
)

// Progress in card layout
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Upload Progress: ${(uploadProgress * 100).toInt()}%'),
        SizedBox(height: 8),
        RxProgress(
          value: uploadProgress,
          style: RxProgressStyle()
            ..container.height(8)
            ..fill.color.indigo.shade600()
            ..track.color.indigo.shade100(),
        ),
      ],
    ),
  ),
)

// Multiple progress indicators
Column(
  children: [
    // CPU Usage
    Row(
      children: [
        Expanded(child: Text('CPU: ${cpuUsage.toInt()}%')),
        SizedBox(
          width: 100,
          child: RxProgress(
            value: cpuUsage / 100,
            style: RxProgressStyle()
              ..fill.color.red.shade600()
              ..track.color.red.shade100(),
          ),
        ),
      ],
    ),
    SizedBox(height: 8),
    // Memory Usage
    Row(
      children: [
        Expanded(child: Text('Memory: ${memoryUsage.toInt()}%')),
        SizedBox(
          width: 100,
          child: RxProgress(
            value: memoryUsage / 100,
            style: RxProgressStyle()
              ..fill.color.blue.shade600()
              ..track.color.blue.shade100(),
          ),
        ),
      ],
    ),
  ],
)
```

## Notes
- Value assertion prevents invalid progress values outside 0-1 range
- Uses Stack layout for layered track and fill rendering
- LayoutBuilder ensures responsive fill width calculation
- Container provides overall shape and clipping behavior
- Track renders as full-width background element
- Fill width dynamically calculated as `containerWidth * value`
- Optional outerContainer allows for additional border or overlay effects
- Stadium shape provides rounded ends by default
- Style merging follows standard pattern: default → custom → variants
- Generated code includes comprehensive debugging and property management utilities
- Component is purely visual - semantic progress information should be provided by parent widgets
- Anti-alias clipping ensures smooth rounded corners on all platforms
- Supports both subtle (thin) and prominent (thick) progress bar styles