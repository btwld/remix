# Checkbox - Old Component Documentation

## Overview
The RxCheckbox is a customizable checkbox form component that supports various styles, behaviors, and accessibility features. It integrates with the Mix styling system and follows Remix design patterns. The component supports checked/unchecked states, custom icons, labels, and comprehensive interaction states including hover, press, and focus.

## API Parameters

### RxCheckbox Parameters

#### Required Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| selected | bool | Whether the checkbox is currently checked | - |

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| enabled | bool | Whether the checkbox is interactive | true |
| onChanged | ValueChanged<bool>? | Callback when checkbox state changes | null |
| iconChecked | IconData | Icon displayed when checked | Icons.check_rounded |
| iconUnchecked | IconData? | Icon displayed when unchecked | null |
| style | RxCheckboxStyle? | Custom styling configuration | null |
| variants | List<Variant> | Style variants to apply | const [] |
| label | String? | Optional text label next to checkbox | null |
| focusNode | FocusNode? | Focus node for keyboard navigation | null |

## Styling Configuration

### Default Theme Values
```dart
// Default styling from RxCheckboxStyle._default()
indicatorContainer.borderRadius(4)
indicatorContainer.border.all.color.black()
indicator.size(16)
indicator.color.black()
label.style.color.black()
label.style.fontSize(14)
container.flex.mainAxisSize.min()
container.flex.gap(8)
indicator.wrap.opacity(0)
on.selected(indicator.wrap.opacity(1))
```

### Style Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| container | FlexBoxSpec | Layout container for checkbox and label | FlexBoxSpec() |
| indicatorContainer | BoxSpec | Container for the checkbox indicator | BoxSpec() |
| indicator | IconSpec | Spec for the checkbox icon | IconSpec() |
| label | TextSpec | Text styling for optional label | TextSpec() |

## Behavior Documentation

### Interactions
- **Checkbox Click**: Toggles checked/unchecked state via NakedCheckbox
- **Label Click**: Also toggles state (full clickable area)
- **Hover**: Updates hover state via MixController
- **Focus**: Manages focus state with optional FocusNode
- **Press**: Visual feedback on press via MixController
- **Disabled**: Component becomes non-interactive when enabled=false

### Animation/Transitions
- Icon opacity transitions between checked/unchecked states
- Smooth state transitions via Mix animation system
- Default animation configuration available via spec
- Hover and press state animations

### State Management
- Internal state management via MixControllerMixin:
  - hovered: bool
  - pressed: bool  
  - focused: bool
  - selected: bool (mirrors checkbox checked state)
- State changes propagated through onChanged callback
- Implements Disableable and Selectable interfaces

## Variants and Configurations

### Constructors

#### RxCheckbox
- Standard checkbox with all configuration options

### Visual Variants
- Supports custom variants through List<Variant> parameter
- Variants applied via Style system
- Custom icons for checked/unchecked states
- Optional label display

### Icon Configurations
- **iconChecked**: Always displayed when selected=true
- **iconUnchecked**: Displayed when selected=false (if provided)
- **Fallback**: Uses iconChecked with opacity changes if iconUnchecked is null

## Accessibility Features
- Full keyboard navigation support with FocusNode
- Screen reader compatibility via Selectable interface
- Proper semantic state announcements
- Disable support via Disableable interface
- Focus management and visual focus indicators
- Clickable label area for improved usability

## Dependencies
- **Required components**:
  - NakedCheckbox (base checkbox functionality)
  - RemixBuilder (style application)
  
- **Utility dependencies**:
  - MixControllerMixin (interaction state management)
  - DisableableMixin (disable behavior)
  - SelectableMixin (selection state)
  - CheckboxSpec (specification pattern)
  
- **Theme dependencies**:
  - FlexBoxSpec (layout)
  - BoxSpec (container styling)
  - IconSpec (icon styling)
  - TextSpec (label styling)

## Usage Examples
```dart
// Basic usage
RxCheckbox(
  selected: _isChecked,
  onChanged: (value) {
    setState(() {
      _isChecked = value;
    });
  },
)

// With label and custom icons
RxCheckbox(
  selected: _agreeToTerms,
  onChanged: (value) => setState(() => _agreeToTerms = value),
  label: 'I agree to the terms and conditions',
  iconChecked: Icons.check_box_rounded,
  iconUnchecked: Icons.check_box_outline_blank_rounded,
)

// Custom styling
RxCheckbox(
  selected: _isSelected,
  onChanged: handleChange,
  label: 'Custom styled checkbox',
  style: RxCheckboxStyle()
    ..indicator.size(24)
    ..indicator.color.blue.shade500()
    ..indicatorContainer.borderRadius(8)
    ..indicatorContainer.border.all.color.blue.shade300()
    ..label.style.fontSize(16)
    ..label.style.fontWeight.w600(),
  variants: [PrimaryVariant()],
)

// Disabled checkbox
RxCheckbox(
  selected: true,
  enabled: false,
  label: 'Disabled checkbox',
  onChanged: null,
)

// With focus node for custom focus management
RxCheckbox(
  selected: _value,
  onChanged: handleChange,
  focusNode: myFocusNode,
  label: 'Focused checkbox',
)
```

## Notes
- Icon opacity animation provides visual feedback for state changes
- When iconUnchecked is null, the same icon is used with opacity changes
- Label is optional but improves usability when provided
- Implements Flutter's standard checkbox behavior patterns
- Style merging: default style → custom style → variants
- Controller disposal handled automatically if not provided externally
- Uses NakedCheckbox for core functionality and behavior
- Full integration with Mix styling system for comprehensive theming