# Slider - Old Component Documentation

## Overview
The RxSlider is a customizable horizontal slider component that supports continuous and discrete value selection with various visual styles and behaviors. It integrates with the Mix styling system and provides comprehensive interaction states including dragging, hovering, and focus. The component supports custom ranges, divisions, animations, and accessibility features.

## API Parameters

### RxSlider Parameters

#### Required Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| value | double | Current slider value (must be between min and max) | - |
| onChanged | ValueChanged<double> | Callback when slider value changes during drag | - |

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| min | double | Minimum slider value | 0.0 |
| max | double | Maximum slider value | 1.0 |
| divisions | int? | Number of discrete steps (null for continuous) | null |
| enabled | bool | Whether the slider is interactive | true |
| onChangeStart | ValueChanged<double>? | Callback when drag starts | null |
| onChangeEnd | ValueChanged<double>? | Callback when drag ends | null |
| style | RxSliderStyle? | Custom styling configuration | null |
| variants | List<Variant> | Style variants to apply | const [] |
| focusNode | FocusNode? | Focus node for keyboard navigation | null |

## Styling Configuration

### Default Theme Values
```dart
// Default styling from RxSliderStyle._default()
thumb.shape.circle.side.color.black()
thumb.shape.circle.side.width(2)
thumb.color.white()
thumb.size(24)
baseTrack.color.grey.shade300()
activeTrack.color.black()
division.color.black26()
```

### Style Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| thumb | BoxSpec | Styling for the draggable thumb/handle | BoxSpec() |
| baseTrack | PaintData | Styling for the inactive track portion | PaintData() |
| activeTrack | PaintData | Styling for the active track portion | PaintData() |
| division | PaintData | Styling for division marks (when divisions > 0) | PaintData() |

### PaintData Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| strokeWidth | double | Width of painted lines | 8.0 |
| color | Color | Color of painted elements | Colors.grey |
| strokeCap | StrokeCap | End style for painted lines | StrokeCap.round |

## Behavior Documentation

### Interactions
- **Thumb Drag**: Moves slider value continuously or in discrete steps
- **Track Click**: Jumps thumb to clicked position and updates value
- **Keyboard Navigation**: Arrow keys adjust value incrementally
- **Hover**: Updates hover state via MixController
- **Focus**: Manages focus state with visual focus indicators
- **Disabled**: Component becomes non-interactive when enabled=false

### Animation/Transitions
- **Track Animation**: Smooth color and style transitions via TweenAnimationBuilder
- **Default Duration**: 200ms with linear curve
- **Custom Animation**: Configurable via AnimatedData in spec
- **Thumb Movement**: Immediate response to value changes
- **Style Transitions**: Animated changes between track styles

### State Management
- Value validation ensures value stays within min/max bounds
- Internal state management via MixControllerMixin:
  - hovered: bool
  - focused: bool
  - dragged: bool (custom state for drag interactions)
- Callback system for drag lifecycle events
- Implements Disableable interface for consistent disable behavior

## Variants and Configurations

### Constructors

#### RxSlider
- Standard horizontal slider with full customization options

### Value Modes
- **Continuous**: divisions=null, smooth value changes
- **Discrete**: divisions=n, snaps to specific values
- **Custom Range**: Any min/max values supported

### Division Handling
- When divisions=0, treated as null (continuous)
- When divisions>0, creates discrete snap points
- Division marks painted as visual indicators
- Value automatically snaps to nearest division

## Accessibility Features
- Full keyboard navigation support with arrow keys
- Screen reader compatibility via Disableable interface
- Focus management with FocusNode support
- Proper semantic value announcements
- Visual focus indicators
- Disable support with appropriate cursor states

## Dependencies
- **Required components**:
  - NakedSlider (base slider functionality)
  - RemixBuilder (style application)
  
- **Utility dependencies**:
  - MixControllerMixin (interaction state management)
  - DisableableMixin (disable behavior)
  - SliderSpec (specification pattern)
  
- **Animation dependencies**:
  - TweenAnimationBuilder (track style animations)
  - TickerProviderStateMixin (animation timing)
  - Custom painters for track rendering
  
- **Theme dependencies**:
  - BoxSpec (thumb styling)
  - PaintData (track styling)

## Usage Examples
```dart
// Basic continuous slider
RxSlider(
  value: _currentValue,
  min: 0.0,
  max: 100.0,
  onChanged: (value) {
    setState(() {
      _currentValue = value;
    });
  },
)

// Discrete slider with divisions
RxSlider(
  value: _volume,
  min: 0.0,
  max: 1.0,
  divisions: 10,
  onChanged: (value) => setState(() => _volume = value),
  onChangeStart: (value) => print('Started dragging: $value'),
  onChangeEnd: (value) => print('Finished dragging: $value'),
)

// Custom styled slider
RxSlider(
  value: _brightness,
  min: 0.0,
  max: 255.0,
  onChanged: (value) => setState(() => _brightness = value),
  style: RxSliderStyle()
    ..thumb.size(32)
    ..thumb.color.blue.shade500()
    ..thumb.shape.circle.side.color.blue.shade700()
    ..thumb.shape.circle.side.width(3)
    ..activeTrack.color.blue.shade600()
    ..activeTrack.strokeWidth(6)
    ..baseTrack.color.grey.shade200()
    ..baseTrack.strokeWidth(6),
  variants: [PrimaryVariant()],
)

// Disabled slider
RxSlider(
  value: 0.5,
  enabled: false,
  onChanged: (_) {}, // Required but won't be called
)

// With custom focus management
RxSlider(
  value: _setting,
  min: 1.0,
  max: 10.0,
  divisions: 9,
  onChanged: (value) => setState(() => _setting = value),
  focusNode: sliderFocusNode,
)

// Percentage slider with formatting
RxSlider(
  value: _percentage,
  min: 0.0,
  max: 100.0,
  divisions: 100,
  onChanged: (value) {
    setState(() {
      _percentage = value;
    });
    print('${value.round()}%');
  },
  style: RxSliderStyle()
    ..activeTrack.color.green.shade500()
    ..division.color.green.shade200()
    ..thumb.color.green.shade600(),
)

// Custom animation timing
RxSlider(
  value: _animatedValue,
  onChanged: (value) => setState(() => _animatedValue = value),
  style: RxSliderStyle()
    ..animated(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),
)
```

## Notes
- Value must always be within min/max range (enforced by assertion)
- When divisions=0, it's converted to null internally for continuous behavior
- Custom painters handle track rendering with support for divisions
- Track animation system smoothly transitions between style changes
- Thumb positioning calculated dynamically based on container constraints
- Horizontal padding automatically calculated based on thumb size
- Style merging: default style → custom style → variants
- Uses Stack layout for precise thumb positioning over track
- Full integration with Mix styling system for comprehensive theming
- NakedSlider provides core interaction behavior with Remix adding visual styling
- Division marks painted as visual indicators when divisions > 0