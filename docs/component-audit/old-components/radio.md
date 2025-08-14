# Radio - Old Component Documentation

## Overview
The RxRadio system is a two-part radio button component consisting of RxRadioGroup (the group container) and RxRadio (individual radio buttons). The components integrate with the Mix styling system and follow Remix design patterns. The system supports single selection within a group, custom styling, and comprehensive interaction states including hover, press, and focus.

## API Parameters

### RxRadioGroup Parameters

#### Required Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| value | T? | Currently selected value in the group | - |
| onChanged | ValueChanged<T?>? | Callback when selection changes | - |
| child | Widget | Widget containing RxRadio children | - |

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| enabled | bool | Whether the radio group is interactive | true |
| style | RxRadioStyle? | Custom styling configuration | null |
| variants | List<Variant> | Style variants to apply | const [] |

### RxRadio Parameters

#### Required Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| value | T | Value associated with this radio button | - |
| label | String | Text label displayed next to radio button | - |

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| enabled | bool | Whether this radio button is interactive | true |
| focusNode | FocusNode? | Focus node for keyboard navigation | null |
| enableHapticFeedback | bool | Whether to provide haptic feedback on tap | true |

## Styling Configuration

### Default Theme Values
```dart
// Default styling from RxRadioStyle._default()
indicatorContainer.padding.all(3)
indicatorContainer.border.all.color.grey.shade500()
indicatorContainer.shape.circle()
indicator.size(8)
indicator.shape.circle()
indicator.color.black()
text.style.color.black()
text.style.fontSize(14)
text.textHeightBehavior.heightToFirstAscent.off()
container.flex.mainAxisSize.min()
container.flex.gap(8)
indicator.wrap.opacity(0)
on.selected(indicator.wrap.opacity(1))
```

### Style Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| indicatorContainer | BoxSpec | Container for the radio circle | BoxSpec() |
| indicator | BoxSpec | Inner circle indicator when selected | BoxSpec() |
| container | FlexBoxSpec | Layout container for radio and label | FlexBoxSpec() |
| text | TextSpec | Text styling for the label | TextSpec() |

## Behavior Documentation

### Interactions
- **Radio Click**: Selects this radio button and deselects others in group
- **Label Click**: Also selects the radio (full clickable area)
- **Hover**: Updates hover state via MixController
- **Focus**: Manages focus state with optional FocusNode
- **Press**: Visual feedback on press via MixController
- **Disabled**: Individual radios or entire group can be disabled
- **Haptic Feedback**: Optional tactile feedback on selection

### Animation/Transitions
- Inner circle opacity transitions between selected/unselected states
- Smooth state transitions via Mix animation system
- Default animation configuration available via spec
- Hover and press state animations

### State Management
- Group-level state management via RxRadioGroup
- Individual radio states managed via MixControllerMixin:
  - hovered: bool
  - pressed: bool
  - focused: bool
  - selected: bool (mirrors group selection)
  - disabled: bool
- State changes propagated through group onChanged callback
- Uses NakedRadioGroup for underlying radio group behavior

## Variants and Configurations

### Constructors

#### RxRadioGroup<T>
- Generic radio group container for type T values

#### RxRadio<T>
- Individual radio button with required value and label

### Usage Patterns
- Must use RxRadio within RxRadioGroup (throws FlutterError if not)
- Automatic selection state synchronization
- Single selection enforcement within group
- Type-safe value handling with generic T

### Error Handling
- Runtime validation: RxRadio must have RxRadioGroup ancestor
- Clear error message when group is missing
- Proper generic type checking

## Accessibility Features
- Full keyboard navigation support with FocusNode
- Screen reader compatibility via radio semantics
- Proper semantic state announcements for selection
- Individual disable support via Disableable interface
- Focus management and visual focus indicators
- Clickable label area for improved usability
- Group-based selection announcements

## Dependencies
- **Required components**:
  - NakedRadioGroup (base radio group functionality)
  - NakedRadio (base radio button functionality)
  - RemixBuilder (style application)
  - StyleScope (style sharing between group and children)
  
- **Utility dependencies**:
  - MixControllerMixin (interaction state management)
  - DisableableMixin (disable behavior)
  - RadioSpec (specification pattern)
  
- **Theme dependencies**:
  - FlexBoxSpec (layout)
  - BoxSpec (radio styling)
  - TextSpec (label styling)

## Usage Examples
```dart
// Basic radio group
enum Options { banana, apple, orange }

RxRadioGroup<Options>(
  value: _selectedOption,
  onChanged: (value) {
    setState(() {
      _selectedOption = value;
    });
  },
  child: const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RxRadio(
        label: 'Banana',
        value: Options.banana,
      ),
      RxRadio(
        label: 'Apple',
        value: Options.apple,
      ),
      RxRadio(
        label: 'Orange',
        value: Options.orange,
      ),
    ],
  ),
)

// With custom styling
RxRadioGroup<String>(
  value: _theme,
  onChanged: (value) => setState(() => _theme = value),
  style: RxRadioStyle()
    ..indicator.size(12)
    ..indicator.color.blue.shade600()
    ..indicatorContainer.border.all.color.blue.shade300()
    ..text.style.fontSize(16)
    ..text.style.fontWeight.w500(),
  variants: [PrimaryVariant()],
  child: Column(
    children: [
      RxRadio(label: 'Dark Theme', value: 'dark'),
      RxRadio(label: 'Light Theme', value: 'light'),
      RxRadio(label: 'System Theme', value: 'system'),
    ],
  ),
)

// Disabled group
RxRadioGroup<int>(
  value: 1,
  enabled: false,
  onChanged: null,
  child: Column(
    children: [
      RxRadio(label: 'Option 1', value: 1),
      RxRadio(label: 'Option 2', value: 2),
    ],
  ),
)

// With custom focus management
RxRadioGroup<bool>(
  value: _setting,
  onChanged: handleChange,
  child: Column(
    children: [
      RxRadio(
        label: 'Enable Feature',
        value: true,
        focusNode: enableFocusNode,
      ),
      RxRadio(
        label: 'Disable Feature',
        value: false,
        focusNode: disableFocusNode,
        enableHapticFeedback: false,
      ),
    ],
  ),
)
```

## Notes
- RxRadio components MUST be used within RxRadioGroup
- Generic type T allows flexible value types (enum, string, int, etc.)
- Group manages selection state; individual radios cannot be independently selected
- Inner circle opacity animation provides visual feedback for selection
- StyleScope pattern shares styling between group and radio items
- Haptic feedback can be disabled per radio button
- Style merging: default style → custom style → variants
- Uses NakedUI components for core radio button functionality
- Full integration with Mix styling system for comprehensive theming
- Automatic state synchronization between group and individual radios