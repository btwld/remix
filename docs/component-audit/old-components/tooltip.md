# Tooltip - Old Component Documentation

## Overview
The RxTooltip is a customizable overlay component that displays contextual information when users hover over or interact with a trigger element. It integrates with the Mix styling system and provides smooth fade animations, customizable timing, and accessibility features. The component wraps NakedTooltip for core functionality while adding Remix styling capabilities.

## API Parameters

### RxTooltip Parameters

#### Required Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| tooltipChild | Widget | The widget content displayed inside the tooltip | - |
| child | Widget | The trigger widget that shows tooltip on hover/long-press | - |

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| showDuration | Duration | How long to display the tooltip | Duration(seconds: 1) |
| waitDuration | Duration | Delay before showing tooltip after trigger | Duration.zero |
| tooltipSemantics | String? | Semantic label for accessibility | null |
| style | RxTooltipStyle? | Custom styling configuration | null |
| variants | List<Variant> | Style variants to apply | const [] |

## Styling Configuration

### Default Theme Values
```dart
// Default styling from RxTooltipStyle._default()
container.color.black.withOpacity(0.8)
container.padding(10)
container.borderRadius(8)
animated.duration(100.ms)
on.hover(container.color.red())
```

### Style Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| container | BoxSpec | Styling for the tooltip container | BoxSpec() |
| animated | AnimatedData? | Animation configuration for show/hide | null |

### Animation Configuration
- **Default Duration**: 100ms fade in/out
- **Animation Type**: FadeTransition with opacity animation
- **Custom Animation**: Configurable via AnimatedData in style
- **Lifecycle Management**: Automatic show/hide based on overlay state

## Behavior Documentation

### Interactions
- **Hover**: Shows tooltip on mouse hover (desktop)
- **Long Press**: Shows tooltip on long press (mobile)
- **Leave/Release**: Hides tooltip when interaction ends
- **Timer-based**: Automatically hides after showDuration
- **Wait Delay**: Optional delay before showing tooltip

### Animation/Transitions
- **Fade In**: Smooth opacity transition when tooltip appears
- **Fade Out**: Smooth opacity transition when tooltip disappears
- **Duration Control**: Customizable animation timing via style
- **State Synchronization**: Animation controller synced with overlay lifecycle
- **Removal Delay**: Tooltip removal waits for animation to complete

### State Management
- Uses AnimationController for fade animations
- Overlay lifecycle management via NakedTooltip
- State changes trigger animation forward/reverse
- TickerProviderStateMixin for animation timing
- Automatic cleanup on widget disposal

## Variants and Configurations

### Constructors

#### RxTooltip
- Standard tooltip with all customization options

### Tooltip Types
- **Informational**: Default black background with white text
- **Warning**: Custom colored for warnings/alerts
- **Error**: Red styling for error messages
- **Help**: Contextual help information
- **Label**: Simple text labels for UI elements

### Positioning
- **Auto-positioning**: NakedTooltip handles optimal placement
- **Constraint-aware**: Adjusts position to stay on screen
- **Responsive**: Works on both desktop and mobile platforms

## Accessibility Features
- Semantic labels via tooltipSemantics parameter
- Screen reader support through proper ARIA attributes
- Keyboard navigation compatibility
- Platform-specific interaction patterns (hover vs long-press)
- Proper focus management for tooltip content
- Automatic semantic announcements when tooltip appears

## Dependencies
- **Required components**:
  - NakedTooltip (base tooltip functionality and positioning)
  - MixBuilder (style application)
  - SpecBuilder (spec-based rendering)
  
- **Animation dependencies**:
  - AnimationController (fade animations)
  - FadeTransition (opacity animations)
  - TickerProviderStateMixin (animation timing)
  
- **Utility dependencies**:
  - TooltipSpec (specification pattern)
  - Overlay system (for tooltip positioning and lifecycle)
  
- **Theme dependencies**:
  - BoxSpec (container styling)
  - Mix animation system

## Usage Examples
```dart
// Basic tooltip
RxTooltip(
  tooltipChild: Text(
    'This is helpful information',
    style: TextStyle(color: Colors.white),
  ),
  child: Icon(Icons.help_outline),
)

// Tooltip with custom styling
RxTooltip(
  tooltipChild: Text(
    'Custom styled tooltip',
    style: TextStyle(color: Colors.white, fontSize: 14),
  ),
  child: Text('Hover me'),
  style: RxTooltipStyle()
    ..container.color.blue.shade800()
    ..container.padding.all(12)
    ..container.borderRadius(12)
    ..animated.duration(Duration(milliseconds: 200)),
)

// Tooltip with custom timing
RxTooltip(
  tooltipChild: Text(
    'This tooltip shows quickly and stays longer',
    style: TextStyle(color: Colors.white),
  ),
  child: ElevatedButton(
    onPressed: () {},
    child: Text('Button with tooltip'),
  ),
  waitDuration: Duration(milliseconds: 100),
  showDuration: Duration(seconds: 3),
)

// Warning tooltip
RxTooltip(
  tooltipChild: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.warning, color: Colors.white, size: 16),
      SizedBox(width: 4),
      Text('Warning message', style: TextStyle(color: Colors.white)),
    ],
  ),
  child: Icon(Icons.warning, color: Colors.orange),
  style: RxTooltipStyle()
    ..container.color.orange.shade700()
    ..container.padding.horizontal(12)
    ..container.padding.vertical(8),
)

// Tooltip with semantic label
RxTooltip(
  tooltipChild: Text(
    'More details about this feature',
    style: TextStyle(color: Colors.white),
  ),
  child: Text('Feature name'),
  tooltipSemantics: 'Additional information about feature',
)

// Rich content tooltip
RxTooltip(
  tooltipChild: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Feature Details',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 4),
      Text(
        'This feature helps you accomplish tasks more efficiently.',
        style: TextStyle(color: Colors.white70, fontSize: 12),
      ),
    ],
  ),
  child: Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text('Complex Feature'),
  ),
  style: RxTooltipStyle()
    ..container.color.grey.shade900()
    ..container.padding.all(16)
    ..container.borderRadius(8),
)

// No delay tooltip for immediate feedback
RxTooltip(
  tooltipChild: Text(
    'Immediate tooltip',
    style: TextStyle(color: Colors.white),
  ),
  child: IconButton(
    icon: Icon(Icons.info),
    onPressed: () {},
  ),
  waitDuration: Duration.zero,
  showDuration: Duration(milliseconds: 800),
)

// Tooltip with variants
RxTooltip(
  tooltipChild: Text(
    'Styled with variant',
    style: TextStyle(color: Colors.white),
  ),
  child: Text('Styled tooltip'),
  variants: [PrimaryVariant()],
  style: RxTooltipStyle()
    ..container.padding.all(14),
)
```

## Notes
- Uses FadeTransition for smooth show/hide animations
- Animation controller automatically synced with overlay lifecycle
- NakedTooltip handles positioning, collision detection, and platform behavior
- Tooltip content can be any widget, not just text
- Style merging: default style → custom style → variants
- Animation duration configurable independently from show/hide timing
- Automatic cleanup prevents memory leaks from animation controllers
- Works seamlessly across desktop (hover) and mobile (long-press) platforms
- Respects platform conventions for tooltip interactions
- Overlay system ensures tooltips appear above other content
- Full integration with Mix styling system for consistent theming