# Spinner - Old Component Documentation

## Overview
The RxSpinner is an animated loading indicator component that displays a spinning animation to indicate ongoing processes or loading states. It features two distinct visual styles (solid and dotted) with customizable size, color, stroke width, and animation duration. The component uses custom painters for rendering and AnimationController for continuous rotation animation.

## API Parameters

### RxSpinner Parameters

#### Required Parameters
None - all parameters are optional with sensible defaults.

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| style | RxSpinnerStyle? | Custom styling configuration | null |
| variants | List<Variant> | Style variants to apply | const [] |

## Styling Configuration

### Default Theme Values
```dart
// Default styling from RxSpinnerStyle._default()
color.black()
style.solid()
size(24)
strokeWidth(1.5)
duration: Duration(milliseconds: 500) // From SpinnerSpec default
```

### Style Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| size | double | Size of the spinner (width and height) | 24.0 |
| strokeWidth | double? | Width of the stroke line (0-1 range recommended) | 1.5 |
| color | Color | Color of the spinner line/elements | Colors.white (spec default) / black (style default) |
| duration | Duration | Duration of a full cycle of spin | Duration(milliseconds: 500) |
| style | SpinnerTypeStyle | Visual style (solid or dotted) | SpinnerTypeStyle.solid |
| modifiers | WidgetModifiersConfig | Widget modifiers configuration | null |
| animated | AnimatedData | Animation configuration | null |

## Behavior Documentation

### Interactions
- **Continuous Animation**: Automatically starts spinning animation on mount
- **No User Interactions**: Purely visual feedback component
- **Self-Contained**: Manages its own animation controller lifecycle
- **Responsive**: Adapts to available space while maintaining aspect ratio

### Animation/Transitions
- **Continuous Rotation**: Uses AnimationController.repeat() for infinite rotation
- **Configurable Duration**: Full rotation duration customizable via style
- **Smooth Animation**: 60fps animation with SingleTickerProviderStateMixin
- **Style-Specific Animation**:
  - **Solid**: Rotating arc segment (120° sweep angle)
  - **Dotted**: 12 radial lines with opacity-based rotation effect

### State Management
- Internal AnimationController managed by SpinnerSpecWidget
- Automatic controller disposal on widget disposal
- Duration updates trigger controller reset and restart
- Stateful animation with stateless public interface

## Variants and Configurations

### Constructors

#### RxSpinner (Default Constructor)
- Standard spinner with customizable styling
```dart
RxSpinner(
  style: RxSpinnerStyle()..color.blue(),
  variants: [PrimaryVariant()],
)
```

### Visual Styles

#### SpinnerTypeStyle.solid
- Displays as rotating arc segment (120° sweep)
- Continuous solid line appearance
- Single color with full opacity

#### SpinnerTypeStyle.dotted
- Displays as 12 radial lines with varying opacity
- Creates a "chase" effect as opacity fades
- Lines positioned at 30° intervals

### Size Configurations
- **Small**: 16px for compact interfaces
- **Medium**: 24px (default) for general use
- **Large**: 32px+ for prominent loading states
- **Custom**: Any size via style.size() configuration

## Accessibility Features
- Pure visual indicator with no semantic content by default
- Parent components should provide loading announcements
- No keyboard interactions or focus requirements
- Screen readers rely on contextual loading messages
- Animation respects system animation preferences implicitly

## Dependencies
- **Required components**:
  - SpinnerSpecWidget (internal animation management)
  - SpinnerPainter implementations (rendering)
  - AnimationController (animation state)
  - CustomPaint (rendering surface)

- **Painter implementations**:
  - SolidSpinnerPainter (arc-based rendering)
  - DottedSpinnerPainter (radial lines rendering)
  - SpinnerPainter interface (common contract)

- **Utility dependencies**:
  - SpinnerSpecUtility (styling utilities)
  - MixContext (style resolution)
  - Variant system (style variants)
  - SingleTickerProviderStateMixin (animation)

## Usage Examples
```dart
// Basic spinner
RxSpinner()

// Custom colored spinner
RxSpinner(
  style: RxSpinnerStyle()
    ..color.blue.shade600()
    ..size(32),
)

// Fast spinning spinner
RxSpinner(
  style: RxSpinnerStyle()
    ..duration(Duration(milliseconds: 300))
    ..color.red.shade500(),
)

// Dotted style spinner
RxSpinner(
  style: RxSpinnerStyle()
    ..style.dotted()
    ..color.green.shade600()
    ..size(28),
)

// Thick stroke spinner
RxSpinner(
  style: RxSpinnerStyle()
    ..strokeWidth(3.0)
    ..color.purple.shade600()
    ..size(40),
)

// Loading overlay with spinner
Container(
  color: Colors.black54,
  child: Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RxSpinner(
          style: RxSpinnerStyle()
            ..color.white()
            ..size(48),
        ),
        SizedBox(height: 16),
        Text(
          'Loading...',
          style: TextStyle(color: Colors.white),
        ),
      ],
    ),
  ),
)

// Button with inline spinner
ElevatedButton(
  onPressed: isLoading ? null : handleSubmit,
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (isLoading) ...[
        RxSpinner(
          style: RxSpinnerStyle()
            ..color.white()
            ..size(16),
        ),
        SizedBox(width: 8),
      ],
      Text(isLoading ? 'Submitting...' : 'Submit'),
    ],
  ),
)

// Card loading state
Card(
  child: Padding(
    padding: EdgeInsets.all(24),
    child: isLoading
        ? Center(
            child: RxSpinner(
              style: RxSpinnerStyle()
                ..color.grey.shade600()
                ..size(24),
            ),
          )
        : ContentWidget(),
  ),
)

// List item with spinner
ListTile(
  leading: isProcessing
      ? RxSpinner(
          style: RxSpinnerStyle()
            ..color.blue.shade600()
            ..size(20),
        )
      : Icon(Icons.check, color: Colors.green),
  title: Text('Processing item...'),
)

// Different spinner variants
Column(
  children: [
    // Solid spinner
    RxSpinner(
      style: RxSpinnerStyle()
        ..style.solid()
        ..color.blue.shade600(),
    ),
    SizedBox(height: 16),
    // Dotted spinner
    RxSpinner(
      style: RxSpinnerStyle()
        ..style.dotted()
        ..color.orange.shade600(),
    ),
  ],
)

// Slow, large spinner for full-screen loading
RxSpinner(
  style: RxSpinnerStyle()
    ..size(64)
    ..strokeWidth(2.0)
    ..duration(Duration(milliseconds: 1000))
    ..color.indigo.shade600(),
)
```

## Notes
- AnimationController automatically repeats for continuous spinning
- Custom painters provide efficient rendering without widget rebuilds
- Size property controls both width and height (square aspect ratio)
- StrokeWidth affects line thickness in both solid and dotted styles
- Solid style renders as partial arc (120°) that rotates around center
- Dotted style renders 12 lines with opacity gradient creating chase effect
- Duration changes trigger controller reset and restart for immediate effect
- Color changes are applied immediately without animation restart
- Generated code includes comprehensive debugging and property management
- Widget is automatically disposed when removed from widget tree
- SingleTickerProviderStateMixin ensures proper animation lifecycle
- Both painters use mathematical calculations for precise positioning
- Canvas transformations center the spinner within the available size
- Anti-aliasing provides smooth rendering on all pixel densities