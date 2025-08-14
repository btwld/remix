# Switch - Old Component Documentation

## Overview
The RxSwitch is a customizable toggle switch component that supports on/off states with various visual styles and smooth animations. It integrates with the Mix styling system and provides comprehensive interaction states including hover, press, and focus. The component features spring-based animations for smooth state transitions and supports accessibility features.

## API Parameters

### RxSwitch Parameters

#### Required Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| selected | bool | Whether the switch is in the on position | - |
| onChanged | ValueChanged<bool> | Callback when switch state changes | - |

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| enabled | bool | Whether the switch is interactive | true |
| style | RxSwitchStyle? | Custom styling configuration | null |
| variants | List<Variant> | Style variants to apply | const [] |
| enableHapticFeedback | bool | Whether to provide haptic feedback on toggle | true |
| focusNode | FocusNode? | Focus node for keyboard navigation | null |

## Styling Configuration

### Default Theme Values
```dart
// Default styling from RxSwitchStyle._default()
container.color.grey.shade300()
container.borderRadius(99)
container.padding.all(2)
container.alignment.centerLeft()
container.height(24)
container.width(44)
container.animated.spring(stiffness: 100, dampingRatio: 1)
indicator.color.white()
indicator.shape.circle()
indicator.width(20)
on.selected(container.alignment.bottomRight())
on.selected(container.color.greenAccent.shade700())
```

### Style Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| container | BoxSpec | Outer switch track/background container | BoxSpec() |
| indicator | BoxSpec | Inner switch thumb/handle | BoxSpec() |

### Animation Configuration
- **Spring Animation**: Default stiffness=100, dampingRatio=1
- **Position Transition**: Smooth indicator movement between positions
- **Color Transition**: Background color changes with state
- **Custom Animation**: Configurable via AnimatedData in container spec

## Behavior Documentation

### Interactions
- **Click/Tap**: Toggles switch on/off state
- **Keyboard**: Space key toggles state when focused
- **Hover**: Updates hover state via MixController
- **Focus**: Manages focus state with visual focus indicators
- **Press**: Visual feedback on press via MixController
- **Disabled**: Component becomes non-interactive when enabled=false
- **Haptic Feedback**: Optional tactile feedback on toggle

### Animation/Transitions
- **Indicator Movement**: Spring animation between left (off) and right (on) positions
- **Background Color**: Smooth color transition between off/on states
- **Default Spring**: Stiffness=100, dampingRatio=1 for natural movement
- **Container Alignment**: Changes from centerLeft to bottomRight when selected
- **State Transitions**: All visual changes animated via Mix animation system

### State Management
- Internal state management via MixControllerMixin:
  - hovered: bool
  - pressed: bool
  - focused: bool
  - selected: bool (mirrors switch on/off state)
- State changes propagated through onChanged callback
- Implements Disableable and Selectable interfaces

## Variants and Configurations

### Constructors

#### RxSwitch
- Standard toggle switch with all configuration options

### Visual States
- **Off State**: Indicator aligned left, grey background
- **On State**: Indicator aligned right, accent color background
- **Hover State**: Visual feedback via MixController
- **Disabled State**: Non-interactive with appropriate styling
- **Focused State**: Visual focus indicators for keyboard navigation

## Accessibility Features
- Full keyboard navigation support with Space key toggle
- Screen reader compatibility via Selectable interface
- Focus management with FocusNode support
- Proper semantic state announcements for on/off states
- Disable support via Disableable interface
- Visual focus indicators
- Haptic feedback for improved tactile experience

## Dependencies
- **Required components**:
  - NakedCheckbox (reused for base toggle functionality)
  - RemixBuilder (style application)
  
- **Utility dependencies**:
  - MixControllerMixin (interaction state management)
  - DisableableMixin (disable behavior)
  - SelectableMixin (selection state)
  - SwitchSpec (specification pattern)
  
- **Animation dependencies**:
  - Spring animation system via Mix
  - BoxSpec alignment animations
  - Color transition animations
  
- **Theme dependencies**:
  - BoxSpec (container and indicator styling)

## Usage Examples
```dart
// Basic switch
bool _isEnabled = false;

RxSwitch(
  selected: _isEnabled,
  onChanged: (value) {
    setState(() {
      _isEnabled = value;
    });
  },
)

// Custom styled switch
RxSwitch(
  selected: _notificationsEnabled,
  onChanged: (value) => setState(() => _notificationsEnabled = value),
  style: RxSwitchStyle()
    ..container.height(32)
    ..container.width(56)
    ..container.color.red.shade300()
    ..indicator.width(26)
    ..indicator.color.white()
    ..indicator.shape.circle()
    ..on.selected(RxSwitchStyle()
      ..container.color.green.shade500()
    ),
  variants: [PrimaryVariant()],
)

// Disabled switch
RxSwitch(
  selected: true,
  enabled: false,
  onChanged: (_) {}, // Required but won't be called
)

// Switch without haptic feedback
RxSwitch(
  selected: _silentMode,
  onChanged: (value) => setState(() => _silentMode = value),
  enableHapticFeedback: false,
)

// With custom focus management
RxSwitch(
  selected: _autoSave,
  onChanged: (value) => setState(() => _autoSave = value),
  focusNode: switchFocusNode,
)

// Custom animation timing
RxSwitch(
  selected: _fastToggle,
  onChanged: (value) => setState(() => _fastToggle = value),
  style: RxSwitchStyle()
    ..container.animated(
      duration: Duration(milliseconds: 100),
      curve: Curves.easeOut,
    ),
)

// Large switch with custom colors
RxSwitch(
  selected: _darkMode,
  onChanged: (value) => setState(() => _darkMode = value),
  style: RxSwitchStyle()
    ..container.height(40)
    ..container.width(72)
    ..container.color.grey.shade400()
    ..container.borderRadius(20)
    ..indicator.width(32)
    ..indicator.color.white()
    ..indicator.shape.circle()
    ..on.selected(RxSwitchStyle()
      ..container.color.purple.shade600()
    ),
)

// Compact switch
RxSwitch(
  selected: _compactMode,
  onChanged: (value) => setState(() => _compactMode = value),
  style: RxSwitchStyle()
    ..container.height(18)
    ..container.width(32)
    ..indicator.width(14),
)
```

## Notes
- Uses NakedCheckbox internally for core toggle behavior and state management
- Spring animations provide natural, responsive feel for state transitions
- Container alignment changes (centerLeft ↔ bottomRight) drive indicator position
- Background color automatically transitions between off and on states
- Haptic feedback enhances user experience but can be disabled if needed
- Style merging: default style → custom style → variants
- Full integration with Mix styling system for comprehensive theming
- Indicator position calculated automatically based on container alignment
- Supports both programmatic focus management and automatic focus behavior
- Visual states properly reflect interaction states (hover, press, focus)
- Implements standard Flutter widget patterns for consistent behavior