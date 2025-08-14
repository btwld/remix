# Chip - Old Component Documentation

## Overview
The RxChip is a selectable chip component that can display text labels and icons with customizable styling and interactive states. It functions as a toggle element that can be selected or deselected, supporting both standard and custom content layouts. The component integrates with the Mix styling system and provides comprehensive interaction handling including hover, focus, and selection states.

## API Parameters

### RxChip Parameters

#### Required Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| onChanged | void Function(bool)? | Callback function when selection state changes | - |

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| selected | bool | Whether the chip is currently selected | false |
| label | String? | Text content displayed in the chip | null |
| enabled | bool | Whether the chip is enabled for interactions | true |
| iconLeft | IconData? | Icon displayed on the left side of the label | null |
| iconRight | IconData? | Icon displayed on the right side of the label | null |
| variants | List<Variant> | Style variants to apply | const [] |
| focusNode | FocusNode? | Focus node for focus management | null |
| style | RxChipStyle? | Custom styling configuration | null |
| child | Widget | Custom widget content (raw constructor only) | - |

## Styling Configuration

### Default Theme Values
```dart
// Default styling from RxChipStyle._default()
container.borderRadius(8)
container.color.white()
container.border.color.grey.shade300()
container.padding.vertical(6)
container.padding.horizontal(8)
container.flex.mainAxisSize.min()
container.flex.gap(4)
container.animated.easeInOut(100.ms)
container.height(32)
icon.size(18)
label.fontSize(14)
// Selected state styling
on.selected(RxChipStyle()..container.color.grey.shade200())
```

### Style Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| container | FlexBoxSpec | Container styling (color, padding, border, layout) | FlexBoxSpec() |
| icon | IconSpec | Icon styling configuration | IconSpec() |
| label | TextSpec | Text styling configuration | TextSpec() |
| modifiers | WidgetModifiersConfig | Widget modifiers configuration | null |
| animated | AnimatedData | Animation configuration | null |

## Behavior Documentation

### Interactions
- **Selection**: Toggles selected state via onChanged callback when tapped
- **Hover**: Updates hover state and applies hover styling via MixController
- **Focus**: Manages focus state with optional FocusNode support
- **Press**: Visual feedback during tap interactions
- **Disabled**: Prevents all interactions when enabled=false

### Animation/Transitions
- Default animation: 100ms easeInOut transition
- Selection state changes trigger smooth transitions
- Container properties animate between states
- Icon and label styling can be animated
- Hover and focus states animate smoothly

### State Management
- Internal states managed via MixControllerMixin:
  - hovered: bool
  - pressed: bool
  - focused: bool
  - selected: bool (synced with widget.selected)
- Selection state controlled externally via selected parameter
- State changes communicated through onChanged callback
- Disabled state prevents interaction but maintains visual state

## Variants and Configurations

### Constructors

#### RxChip (Default Constructor)
- Standard chip with text label and optional icons
```dart
RxChip(
  label: 'Option',
  iconLeft: Icons.check,
  iconRight: Icons.close,
  selected: true,
  onChanged: (selected) => handleChange(selected),
)
```

#### RxChip.raw (Raw Constructor)
- Custom content chip with flexible layout
```dart
RxChip.raw(
  child: CustomWidget(),
  selected: isSelected,
  onChanged: handleSelection,
)
```

### Visual Configurations
- **Text Only**: Simple text label chip
- **Icon + Text**: Leading/trailing icons with text
- **Icon Only**: Icons without text label
- **Custom Content**: Arbitrary widget content via raw constructor

### Selection States
- **Unselected**: Default state with normal styling
- **Selected**: Active state with selected styling applied
- **Hover**: Temporary visual state during mouse hover
- **Focused**: Keyboard focus state for accessibility
- **Disabled**: Non-interactive state

## Accessibility Features
- Focus management with optional FocusNode support
- Keyboard navigation via NakedCheckbox integration
- Selection state properly communicated to screen readers
- Semantic role as checkbox/toggle element
- Disabled state handling for keyboard navigation
- Proper focus indication through styling

## Dependencies
- **Required components**:
  - NakedCheckbox (core interaction handling)
  - RemixBuilder (Mix framework integration)
  - FlexBoxSpec (container layout)
  - IconSpec & TextSpec (content styling)

- **Utility dependencies**:
  - MixControllerMixin (state management)
  - DisableableMixin (disable behavior)
  - SelectableMixin (selection behavior)
  - StyleMixExt (style extensions)

- **Interface implementations**:
  - Disableable (consistent disable behavior)
  - Selectable (consistent selection behavior)
  - Diagnosticable (debugging support)

## Usage Examples
```dart
// Basic selectable chip
RxChip(
  label: 'Filter Option',
  selected: isFilterActive,
  onChanged: (selected) {
    setState(() {
      isFilterActive = selected;
    });
  },
)

// Chip with icons
RxChip(
  label: 'Favorite',
  iconLeft: Icons.star_outline,
  iconRight: Icons.close,
  selected: isFavorite,
  onChanged: toggleFavorite,
  style: RxChipStyle()
    ..container.color.amber.shade50()
    ..on.selected(
      RxChipStyle()..container.color.amber.shade200()
    ),
)

// Custom styled chip
RxChip(
  label: 'Premium',
  selected: isPremium,
  onChanged: handlePremiumToggle,
  variants: [PrimaryVariant()],
  style: RxChipStyle()
    ..container.borderRadius(16)
    ..container.padding.horizontal(16)
    ..container.height(40)
    ..label.fontSize(16)
    ..label.fontWeight.w600(),
)

// Disabled chip
RxChip(
  label: 'Unavailable',
  selected: false,
  enabled: false,
  onChanged: (_) {},
  style: RxChipStyle()
    ..container.color.grey.shade100()
    ..label.color.grey.shade400(),
)

// Custom content chip
RxChip.raw(
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircleAvatar(radius: 8, child: Text('A')),
      SizedBox(width: 8),
      Text('Custom Chip'),
      Icon(Icons.arrow_drop_down),
    ],
  ),
  selected: isCustomSelected,
  onChanged: handleCustomSelection,
)

// Multi-select chip group
Column(
  children: options.map((option) => RxChip(
    label: option.label,
    iconLeft: option.icon,
    selected: selectedOptions.contains(option.id),
    onChanged: (selected) {
      setState(() {
        if (selected) {
          selectedOptions.add(option.id);
        } else {
          selectedOptions.remove(option.id);
        }
      });
    },
  )).toList(),
)

// Interactive chip with focus
RxChip(
  label: 'Focusable Chip',
  focusNode: chipFocusNode,
  selected: isSelected,
  onChanged: handleSelection,
  style: RxChipStyle()
    ..on.focused(
      RxChipStyle()
        ..container.border.color.blue.shade500()
        ..container.border.width(2),
    ),
)
```

## Notes
- Uses NakedCheckbox as base for consistent checkbox-like behavior
- Selection state is controlled externally - component doesn't manage its own selection
- Icon positioning handled automatically in horizontal flex layout with gap
- Animation duration and curve configurable via container.animated properties
- Style merging follows standard pattern: default → custom → variants
- Raw constructor provides maximum flexibility but still supports label/icon properties
- Generated code includes comprehensive debugging and state management utilities
- MixControllerMixin provides consistent interaction state handling across Remix components
- FlexBoxSpec enables flexible layout configuration for different chip sizes and arrangements
- Component implements both Disableable and Selectable interfaces for consistent API patterns