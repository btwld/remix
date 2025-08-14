# ListItem - Old Component Documentation

## Overview
The RxListItem is a menu item component that displays a title and optionally a subtitle, leading widget, and trailing widget in a structured horizontal layout. It serves as a building block for creating consistent list interfaces, menu items, and navigation elements. The component integrates with the Pressable system for interaction handling and supports comprehensive styling through the Mix framework.

## API Parameters

### RxListItem Parameters

#### Required Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| title | String | The primary text displayed in the menu item | - |

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| subtitle | String? | Optional secondary text displayed below the title | null |
| leading | Widget? | Widget displayed at the start of the menu item | null |
| trailing | Widget? | Widget displayed at the end of the menu item | null |
| onPress | VoidCallback? | Callback function when the item is pressed | null |
| variants | List<Variant> | Style variants to apply | const [] |
| style | RxListItemStyle? | Custom styling configuration | null |
| enabled | bool | Whether the menu item is enabled for interactions | true |
| focusNode | FocusNode? | Focus node for focus management | null |

## Styling Configuration

### Default Theme Values
```dart
// Default styling from RxListItemStyle._default()
titleSubtitleContainer.flex.crossAxisAlignment.start()
titleSubtitleContainer.flex.mainAxisSize.min()
titleSubtitleContainer.wrap.expanded()
titleSubtitleContainer.flex.gap(2.0)
container.flex.gap(12)
container.padding(12)
subtitle.style.fontSize(12.0)
subtitle.style.color.grey.shade600()
subtitle.maxLines(2)
```

### Style Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| container | FlexBoxSpec | Main container styling (padding, color, layout) | FlexBoxSpec() |
| titleSubtitleContainer | FlexBoxSpec | Container for title/subtitle column | FlexBoxSpec() |
| title | TextSpec | Title text styling configuration | TextSpec() |
| subtitle | TextSpec | Subtitle text styling configuration | TextSpec() |
| modifiers | WidgetModifiersConfig | Widget modifiers configuration | null |
| animated | AnimatedData | Animation configuration | null |

## Behavior Documentation

### Interactions
- **Press**: Triggers onPress callback when tapped via Pressable wrapper
- **Hover**: Hover states handled through Pressable interaction system
- **Focus**: Focus management with optional FocusNode support
- **Disabled**: Prevents all interactions when enabled=false
- **Visual Feedback**: Press states and visual feedback through styling system

### Animation/Transitions
- Supports animated properties through AnimatedData configuration
- Container and text properties can animate between states
- Interaction states (hover, press, focus) can have animated transitions
- Layout changes animate smoothly with proper configuration

### State Management
- Stateless widget with externally controlled state
- Interaction states managed by Pressable wrapper
- Style changes trigger rebuilds through SpecBuilder
- Focus state handled by Pressable with optional FocusNode

## Variants and Configurations

### Constructors

#### RxListItem (Default Constructor)
- Standard list item with title and optional elements
```dart
RxListItem(
  title: 'Settings',
  subtitle: 'Manage your preferences',
  leading: Icon(Icons.settings),
  trailing: Icon(Icons.arrow_forward),
  onPress: () => handlePress(),
)
```

### Layout Configurations
- **Title Only**: Simple text display
- **Title + Subtitle**: Two-line text layout with proper spacing
- **With Leading**: Icon, avatar, or custom widget at start
- **With Trailing**: Arrow, button, or custom widget at end
- **Full Layout**: All elements present for complex list items

### Visual Variations
- **Navigation Item**: With trailing arrow indicator
- **Profile Item**: With leading avatar and user information
- **Settings Item**: With leading icon and descriptive text
- **Action Item**: With interactive trailing elements
- **Informational Item**: Read-only items without press handlers

## Accessibility Features
- Title and subtitle text automatically accessible to screen readers
- Proper semantic structure through horizontal/vertical flex containers
- Focus management with FocusNode support for keyboard navigation
- Disabled state handling prevents interaction and updates accessibility
- Leading and trailing widgets maintain their individual accessibility properties
- Press actions properly communicated to assistive technologies

## Dependencies
- **Required components**:
  - Pressable (interaction handling)
  - SpecBuilder (Mix framework integration)
  - FlexBoxSpec (layout containers)
  - TextSpec (text styling)

- **Utility dependencies**:
  - ListItemSpecUtility (styling utilities)
  - MixContext (style resolution)
  - Variant system (style variants)
  - DiagnosticPropertiesBuilder (debugging)

- **Flutter dependencies**:
  - StatelessWidget (widget base)
  - VoidCallback (press handling)
  - Widget (leading/trailing content)
  - FocusNode (focus management)

## Usage Examples
```dart
// Basic list item
RxListItem(
  title: 'Settings',
  onPress: () => Navigator.pushNamed(context, '/settings'),
)

// List item with subtitle
RxListItem(
  title: 'Account',
  subtitle: 'Manage your account settings',
  leading: Icon(Icons.account_circle),
  trailing: Icon(Icons.chevron_right),
  onPress: () => showAccountSettings(),
)

// Profile list item
RxListItem(
  title: 'John Doe',
  subtitle: 'john.doe@example.com',
  leading: CircleAvatar(
    backgroundImage: NetworkImage('https://avatar.url'),
  ),
  trailing: PopupMenuButton(
    itemBuilder: (context) => [
      PopupMenuItem(child: Text('Edit')),
      PopupMenuItem(child: Text('Delete')),
    ],
  ),
)

// Custom styled list item
RxListItem(
  title: 'Important Notice',
  subtitle: 'This requires immediate attention',
  leading: Icon(Icons.warning, color: Colors.orange),
  style: RxListItemStyle()
    ..container.color.orange.shade50()
    ..container.border.left.color.orange.shade400()
    ..container.border.left.width(4)
    ..title.style.fontWeight.w600()
    ..subtitle.style.color.orange.shade800(),
)

// Disabled list item
RxListItem(
  title: 'Unavailable Feature',
  subtitle: 'Coming soon',
  leading: Icon(Icons.lock, color: Colors.grey),
  enabled: false,
  style: RxListItemStyle()
    ..container.color.grey.shade100()
    ..title.style.color.grey.shade600()
    ..subtitle.style.color.grey.shade500(),
)

// Interactive list item with variants
RxListItem(
  title: 'Delete Account',
  subtitle: 'Permanently delete your account',
  leading: Icon(Icons.delete_forever),
  trailing: Icon(Icons.warning),
  variants: [DangerVariant()],
  onPress: () => showDeleteConfirmation(),
  style: RxListItemStyle()
    ..on.hover(
      RxListItemStyle()..container.color.red.shade50()
    ),
)

// List item with custom spacing
RxListItem(
  title: 'Compact Item',
  subtitle: 'Less padding example',
  style: RxListItemStyle()
    ..container.padding(8)
    ..container.flex.gap(8)
    ..titleSubtitleContainer.flex.gap(1),
)

// Action list item
RxListItem(
  title: 'Logout',
  leading: Icon(Icons.logout),
  trailing: TextButton(
    child: Text('Confirm'),
    onPressed: () => handleLogout(),
  ),
  onPress: null, // No main press action, only button
)

// List item in ListView
ListView(
  children: menuItems.map((item) => RxListItem(
    title: item.title,
    subtitle: item.description,
    leading: Icon(item.icon),
    trailing: item.hasSubMenu ? Icon(Icons.chevron_right) : null,
    onPress: () => handleMenuSelection(item.id),
    style: RxListItemStyle()
      ..container.border.bottom.color.grey.shade200()
      ..container.border.bottom.width(1),
  )).toList(),
)
```

## Notes
- Uses Pressable wrapper for consistent interaction handling across Remix components
- Horizontal layout with flexible middle section that expands to fill available space
- Title/subtitle container uses vertical layout with configurable gap spacing
- Leading and trailing widgets maintain their natural sizes while middle section expands
- Subtitle automatically wraps with maxLines(2) by default for consistent appearance
- Style merging follows standard pattern: default → custom → variants
- Generated code includes comprehensive debugging and property management utilities
- Container gap spacing provides consistent visual rhythm between elements
- Cross-axis alignment set to start for proper vertical alignment of varied content heights
- Component serves as foundation for more complex list-based interfaces and navigation patterns