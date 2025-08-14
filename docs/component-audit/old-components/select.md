# Select - Old Component Documentation

## Overview
The RxSelect system is a comprehensive dropdown selection component consisting of three main parts: RxSelect (the container), RxSelectTrigger (the clickable button), and RxSelectItem (dropdown options). The components integrate with the Mix styling system and provide advanced features including type-ahead search, keyboard navigation, animations, and accessibility support. The system supports both single selection modes with customizable styling and behavior.

## API Parameters

### RxSelect Parameters

#### Required Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| child | Widget | The trigger widget (typically RxSelectTrigger) | - |
| items | List<Widget> | List of selectable items (typically RxSelectItem) | - |

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| selectedValue | T? | Currently selected value (single selection) | null |
| onSelectedValueChanged | ValueChanged<T?>? | Callback when selection changes (single) | null |
| selectedValues | Set<T>? | Currently selected values (multiple selection) | null |
| onSelectedValuesChanged | ValueChanged<Set<T>>? | Callback when selections change (multiple) | null |
| enabled | bool | Whether the select is interactive | true |
| semanticLabel | String? | Accessibility label | null |
| closeOnSelect | bool | Whether to close menu after selection | true |
| autofocus | bool | Whether to focus menu when opened | true |
| enableTypeAhead | bool | Whether to enable type-ahead search | true |
| typeAheadDebounceTime | Duration | Debounce time for type-ahead search | Duration(milliseconds: 500) |
| onClose | VoidCallback? | Callback when menu closes | null |
| onOpen | VoidCallback? | Callback when menu opens | null |
| style | RxSelectStyle? | Custom styling configuration | null |
| variants | List<Variant> | Style variants to apply | const [] |

### RxSelectTrigger Parameters

#### Required Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| label | String | Text to display on trigger (default constructor) | - |
| child | Widget | Custom trigger content (raw constructor) | - |

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| enabled | bool | Whether trigger is interactive | true |
| semanticLabel | String? | Accessibility label | null |
| cursor | MouseCursor | Cursor when hovering | SystemMouseCursors.click |
| enableHapticFeedback | bool | Whether to provide haptic feedback | true |
| focusNode | FocusNode? | Focus node for keyboard navigation | null |
| trailingIcon | IconData? | Icon displayed on trigger | Icons.keyboard_arrow_down |

### RxSelectItem Parameters

#### Required Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| value | T | Value associated with this item | - |
| label | String | Text to display (default constructor) | - |
| child | Widget | Custom item content (raw constructor) | - |

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| enabled | bool | Whether item is selectable | true |
| semanticLabel | String? | Accessibility label | null |
| cursor | MouseCursor | Cursor when hovering | SystemMouseCursors.click |
| enableHapticFeedback | bool | Whether to provide haptic feedback | true |
| focusNode | FocusNode? | Focus node for keyboard navigation | null |
| trailingIcon | IconData | Icon shown when selected | Icons.check |

## Styling Configuration

### Default Theme Values
```dart
// Default styling from RxSelectStyle._default()
trigger.container.flex.mainAxisSize.min()
trigger.container.flex.mainAxisAlignment.spaceBetween()
trigger.container.color.white()
trigger.container.padding(8)
trigger.container.padding.left(12)
trigger.container.borderRadius.all(8)
trigger.container.flex.gap(12)
trigger.container.border.color.grey.shade300()
trigger.icon.size(18)
menuContainer.color.white()
menuContainer.maxWidth(200)
menuContainer.padding.all(8)
menuContainer.borderRadius.all(8)
menuContainer.border.color.grey.shade300()
item.container.flex.mainAxisAlignment.spaceBetween()
item.icon.size(16)
item.textStyle.color.grey.shade700()
item.container.padding.horizontal(8)
item.container.padding.vertical(8)
item.container.borderRadius(4)
item.icon.color.grey.withOpacity(0)
on.selected(item.icon.color.grey.withOpacity(1))
on.selected(item.container.color.grey.shade100())
```

### Style Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| trigger | SelectTriggerSpec | Styling for the trigger button | SelectTriggerSpec() |
| menuContainer | BoxSpec | Container for dropdown menu | BoxSpec() |
| item | SelectMenuItemSpec | Styling for menu items | SelectMenuItemSpec() |
| position | CompositedTransformFollowerSpec | Positioning for overlay | CompositedTransformFollowerSpec() |

### Sub-specifications
#### SelectTriggerSpec
| Property | Type | Description |
|----------|------|-------------|
| container | FlexBoxSpec | Layout container for trigger |
| label | TextSpec | Text styling for trigger label |
| icon | IconThemeData | Theming for trigger icons |

#### SelectMenuItemSpec
| Property | Type | Description |
|----------|------|-------------|
| container | FlexBoxSpec | Layout container for items |
| textStyle | TextStyle | Text styling for item labels |
| icon | IconThemeData | Theming for item icons |

## Behavior Documentation

### Interactions
- **Trigger Click**: Opens/closes dropdown menu
- **Item Click**: Selects item and closes menu (if closeOnSelect=true)
- **Keyboard Navigation**: Arrow keys navigate items, Enter selects
- **Type-ahead Search**: Typing filters/navigates to matching items
- **Hover**: Visual feedback on trigger and items
- **Focus**: Focus management with visual indicators
- **Outside Click**: Closes menu when clicking outside

### Animation/Transitions
- **Menu Appearance**: Fade in with scale animation (0.95 to 1.0)
- **Menu Disappearance**: Fade out with scale animation
- **Default Duration**: 150ms with easeInOut curve
- **Selection Icons**: Opacity transitions for check marks
- **Custom Animation**: Configurable via AnimatedData in spec

### State Management
- Selection state managed by RxSelect container
- Individual component states via MixControllerMixin:
  - hovered: bool (trigger and items)
  - pressed: bool (trigger and items)
  - focused: bool (trigger and items)
  - selected: bool (items only, mirrors selection state)
- Type-ahead search state with debouncing
- Overlay lifecycle management

## Variants and Configurations

### Constructors

#### RxSelect<T>
- Generic select container for type T values
- Single selection mode (default constructor)

#### RxSelectTrigger
1. **Default Constructor** - Text-based trigger with label
2. **Raw Constructor** - Custom trigger content

#### RxSelectItem<T>
1. **Default Constructor** - Text-based item with label
2. **Raw Constructor** - Custom item content

### Usage Patterns
- Must use RxSelectTrigger and RxSelectItem within RxSelect
- Runtime validation with clear error messages
- Type-safe value handling with generic T
- StyleScope pattern for sharing styles

### Advanced Features
- **Type-ahead Search**: Filter items by typing
- **Keyboard Navigation**: Full arrow key support
- **Auto-focus**: Automatic focus when menu opens
- **Haptic Feedback**: Customizable per component
- **Debounced Search**: Configurable search timing

## Accessibility Features
- Full keyboard navigation support
- Screen reader compatibility with semantic labels
- Proper ARIA states for open/closed menu
- Focus management with FocusNode support
- Individual item disable support
- Type-ahead search announcements
- Clear error states and validation

## Dependencies
- **Required components**:
  - NakedSelect (base select functionality)
  - NakedSelectTrigger (trigger behavior)
  - NakedSelectItem (item behavior)
  - RemixBuilder (style application)
  - StyleScope (style sharing)
  
- **Utility dependencies**:
  - MixControllerMixin (interaction states)
  - DisableableMixin (disable behavior)
  - SelectSpec and sub-specs (specification pattern)
  
- **Animation dependencies**:
  - AnimationController (overlay animations)
  - CurvedAnimation (timing curves)
  - Transform.scale and Opacity (visual effects)

## Usage Examples
```dart
// Basic single selection
enum Fruit { apple, banana, orange }

RxSelect<Fruit>(
  selectedValue: _selectedFruit,
  onSelectedValueChanged: (value) {
    setState(() {
      _selectedFruit = value;
    });
  },
  items: Fruit.values.map((fruit) => 
    RxSelectItem(
      value: fruit,
      label: fruit.name.capitalize(),
    )
  ).toList(),
  child: RxSelectTrigger(
    label: _selectedFruit?.name.capitalize() ?? 'Select a fruit',
  ),
)

// Custom styled select
RxSelect<String>(
  selectedValue: _theme,
  onSelectedValueChanged: (value) => setState(() => _theme = value),
  style: RxSelectStyle()
    ..trigger.container.width(250)
    ..trigger.container.color.blue.shade50()
    ..trigger.container.border.color.blue.shade300()
    ..menuContainer.maxWidth(300)
    ..item.textStyle.fontSize(16),
  items: ['Dark', 'Light', 'System'].map((theme) =>
    RxSelectItem(value: theme, label: theme)
  ).toList(),
  child: RxSelectTrigger(
    label: _theme ?? 'Select theme',
    trailingIcon: Icons.palette,
  ),
)

// Custom trigger and items
RxSelect<User>(
  selectedValue: _selectedUser,
  onSelectedValueChanged: (user) => setState(() => _selectedUser = user),
  items: users.map((user) =>
    RxSelectItem.raw(
      value: user,
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(user.avatar)),
          SizedBox(width: 12),
          Text(user.name),
        ],
      ),
    )
  ).toList(),
  child: RxSelectTrigger.raw(
    child: Row(
      children: [
        if (_selectedUser != null) ...[
          CircleAvatar(backgroundImage: NetworkImage(_selectedUser!.avatar)),
          SizedBox(width: 8),
          Text(_selectedUser!.name),
        ] else
          Text('Select user'),
        Spacer(),
        Icon(Icons.keyboard_arrow_down),
      ],
    ),
  ),
)

// Disabled select
RxSelect<String>(
  enabled: false,
  selectedValue: 'Read-only value',
  onSelectedValueChanged: null,
  items: const [],
  child: RxSelectTrigger(label: 'Read-only value'),
)

// With custom animation and search settings
RxSelect<String>(
  selectedValue: _value,
  onSelectedValueChanged: (value) => setState(() => _value = value),
  enableTypeAhead: true,
  typeAheadDebounceTime: Duration(milliseconds: 300),
  autofocus: false,
  closeOnSelect: false,
  style: RxSelectStyle()
    ..menuContainer.animated(
      duration: Duration(milliseconds: 200),
      curve: Curves.elasticOut,
    ),
  items: longItemList,
  child: RxSelectTrigger(label: _value ?? 'Search and select'),
)
```

## Notes
- Components must be used in proper hierarchy: RxSelect → RxSelectTrigger + RxSelectItem
- Generic type T allows flexible value types with type safety
- StyleScope pattern efficiently shares styling between all child components
- Animation system uses overlay lifecycle management for smooth transitions
- Type-ahead search works with item labels for keyboard accessibility
- Haptic feedback can be disabled per component for custom behavior
- Selection icons automatically show/hide based on selection state
- Full integration with Mix styling system for comprehensive theming
- NakedUI provides the core functionality with Remix adding styling layer
- Overlay positioning automatically adjusts based on available space