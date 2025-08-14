# Button - Old Component Documentation

## Overview
The RxButton is a customizable button component that supports icons, loading states, and styling. It integrates with the Mix styling system and follows Remix design patterns. The button provides haptic feedback, focus management, and multiple constructors for different use cases.

## API Parameters

### Required Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| label | String | The text content of the button (for default constructor) | - |
| onPressed | VoidCallback? | Callback function when pressed | - |
| child | Widget | The widget content (for raw constructor) | - |
| icon | IconData | The icon to display (for icon constructor) | - |

### Optional Parameters  
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| enabled | bool | Whether the button is enabled | true |
| loading | bool | Whether the button is in loading state | false |
| spinnerBuilder | WidgetBuilder? | Custom widget builder for loading state | null |
| enableHapticFeedback | bool | Whether to provide haptic feedback | true |
| focusNode | FocusNode? | Focus node for focus management | null |
| variants | List<Variant> | Style variants to apply | const [] |
| style | RxButtonStyle? | Custom styling configuration | null |
| iconPosition | IconPosition | Position of icon relative to label | IconPosition.start |

## Styling Configuration

### Default Theme Values
```dart
// Default styling configuration from RxButtonStyle._default()
container.color.black()
container.padding(10)
container.borderRadius(8)
icon.color.white()
icon.size(18)
```

### Style Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| container | BoxSpec | Container styling (color, padding, border, etc.) | BoxSpec() |
| icon | IconThemeData | Icon theme configuration | IconThemeData() |
| textStyle | TextStyle | Text styling configuration | TextStyle() |
| spinner | SpinnerSpec | Loading spinner configuration | SpinnerSpec() |
| modifiers | WidgetModifiersConfig | Widget modifiers | null |
| animated | AnimatedData | Animation configuration | null |

## Behavior Documentation

### Interactions
- **Press**: Triggers onPressed callback with optional haptic feedback
- **Hover**: Updates hover state via MixController
- **Focus**: Manages focus state with optional FocusNode
- **Disabled**: Visual and interaction changes when disabled or loading

### Animation/Transitions
- Supports animated property for smooth transitions
- Loading state transitions with opacity animation
- State changes (hover, pressed, focused, disabled) trigger style updates
- Lerp interpolation for smooth animation between states

### State Management
- Internal states managed via MixControllerMixin:
  - hovered: bool
  - pressed: bool  
  - focused: bool
  - disabled: bool
- Loading state creates overlay with spinner
- Disabled when: enabled=false OR loading=true OR onPressed=null

## Variants and Configurations

### Constructors
1. **Default Constructor** - Standard button with label and optional icon
   ```dart
   RxButton(label: "Click Me", onPressed: () {})
   ```

2. **Icon Constructor** - Icon-only button
   ```dart
   RxButton.icon(Icons.star, onPressed: () {})
   ```

3. **Raw Constructor** - Custom child widget
   ```dart
   RxButton.raw(child: CustomWidget(), onPressed: () {})
   ```

### Visual Variants
- Supports custom variants through List<Variant> parameter
- Variants applied via Style.applyVariants() method
- Can be used for primary, secondary, danger, etc. button styles

### Size Options
- Controlled through style.container.padding
- Icon size via style.icon.size
- Text size via style.textStyle

## Accessibility Features
- Focus management with FocusNode support
- Keyboard navigation enabled via NakedButton
- Haptic feedback for interaction confirmation
- Disabled state management for screen readers
- Semantic button role inherited from NakedButton

## Dependencies
- **Required components**:
  - RxLabel (for default constructor)
  - SpinnerSpec (for loading state)
  - NakedButton (base functionality)
  
- **Utility dependencies**:
  - MixControllerMixin (state management)
  - RemixBuilder (style application)
  - ButtonSpec (specification pattern)
  
- **Theme dependencies**:
  - IconThemeData
  - TextStyle
  - BoxSpec

## Usage Examples
```dart
// Basic usage
RxButton(
  label: 'Submit',
  onPressed: () => print('Submitted'),
)

// With icon and loading state
RxButton(
  label: 'Save',
  icon: Icons.save,
  iconPosition: IconPosition.start,
  loading: isLoading,
  onPressed: handleSave,
)

// Icon-only button
RxButton.icon(
  Icons.delete,
  onPressed: handleDelete,
  variants: [DangerVariant()],
)

// Custom content with raw constructor
RxButton.raw(
  child: Row(
    children: [Icon(Icons.upload), Text('Upload')],
  ),
  onPressed: handleUpload,
  style: customButtonStyle,
)

// With custom spinner
RxButton(
  label: 'Processing',
  loading: true,
  spinnerBuilder: (context) => CustomSpinner(),
  onPressed: null,
)
```

## Notes
- Button automatically disables during loading state
- Loading state preserves button layout using Stack and Opacity
- Style merging: default style → custom style → variants
- Uses NakedButton for core button behavior (gestures, states)
- Implements Disableable interface for consistent disable behavior
- Generated code includes utilities for copying, equality, and debugging
- Supports interpolation between styles for smooth animations