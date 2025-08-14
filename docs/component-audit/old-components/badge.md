# Badge - Old Component Documentation

## Overview
The RxBadge is a small utility component used to display short pieces of information like status indicators, counts, labels, or notifications. It integrates with the Mix styling system and provides flexible content options including text, icons, or custom widgets. The component is designed to be compact, visually distinct, and suitable for overlaying on other components or standing alone.

## API Parameters

### RxBadge Parameters

#### Required Parameters
None - all parameters are optional when using default constructor with label.

#### Optional Parameters (Default Constructor)
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| label | String? | Text to display in the badge | null |
| icon | IconData? | Icon to display alongside or instead of text | null |
| iconPosition | IconPosition | Position of icon relative to text | IconPosition.start |
| style | RxBadgeStyle? | Custom styling configuration | null |
| variants | List<Variant> | Style variants to apply | const [] |

#### Raw Constructor Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| child | Widget | Custom widget content for the badge | - |
| style | RxBadgeStyle? | Custom styling configuration | null |
| variants | List<Variant> | Style variants to apply | const [] |

## Styling Configuration

### Default Theme Values
```dart
// Default styling from RxBadgeStyle._default()
container.color.grey.shade200()
container.borderRadius.all(10)
container.padding.horizontal(10)
container.padding.vertical(2)
textStyle.color.grey.shade800()
textStyle.height(1.1)
icon.size(16)
```

### Style Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| container | BoxSpec | Container styling for the badge | BoxSpec() |
| textStyle | TextStyle | Text styling for badge content | TextStyle() |
| icon | IconThemeData | Icon theming for badge icons | IconThemeData() |

## Behavior Documentation

### Interactions
- **No Built-in Interactions**: Badge is purely visual with no user interaction
- **Static Display**: Always visible and unchanging unless parent manages visibility
- **Overlay Compatible**: Designed to work as overlay on other components
- **Layout Friendly**: Fits naturally in various layout contexts

### Animation/Transitions
- **No Built-in Animations**: Component is stateless and static
- **Custom Animation**: Can be animated via Mix animation system if needed
- **Style Transitions**: Smooth transitions possible when style changes externally
- **Lerp Support**: Built-in interpolation for smooth style transitions

### State Management
- **Stateless**: No internal state management required
- **Content Management**: Content determined by parameters at build time
- **Pure Visual**: Focuses solely on visual presentation

## Variants and Configurations

### Constructors

#### RxBadge (Default)
- Text and optional icon badge using RxLabel internally
- Supports icon positioning (start/end)

#### RxBadge.raw
- Custom widget content for maximum flexibility
- Allows any widget as badge content

### Common Badge Types
- **Status Badges**: Online, offline, active states
- **Count Badges**: Notification counts, unread messages
- **Label Badges**: Category tags, feature flags
- **Icon Badges**: Symbol-based indicators
- **Custom Badges**: Rich content with custom widgets

### Visual Variants
- **Rounded**: High border radius for pill-like appearance
- **Square**: Low/no border radius for rectangular badges
- **Colored**: Custom background colors for different states
- **Outlined**: Border-only style without background fill
- **Compact**: Minimal padding for small badges

## Accessibility Features
- **Semantic Content**: Badge content inherits text semantics
- **Icon Semantics**: Icons receive proper theming and accessibility
- **Screen Reader Compatible**: Text content announced by screen readers
- **No Focus Required**: Purely informational, doesn't need keyboard focus
- **Context-dependent**: Accessibility meaning depends on usage context

## Dependencies
- **Required components**:
  - RxLabel (for default constructor with text/icon content)
  - SpecBuilder (style application)
  
- **Utility dependencies**:
  - BadgeSpec (specification pattern)
  - DefaultTextStyle (text theming)
  - IconTheme (icon theming)
  
- **Theme dependencies**:
  - BoxSpec (container styling)
  - TextStyle (text styling)
  - IconThemeData (icon styling)

## Usage Examples
```dart
// Basic text badge
RxBadge(label: 'New')

// Badge with icon
RxBadge(
  label: 'Verified',
  icon: Icons.check_circle,
  iconPosition: IconPosition.start,
)

// Count badge
RxBadge(label: '42')

// Custom styled badge
RxBadge(
  label: 'Premium',
  style: RxBadgeStyle()
    ..container.color.blue.shade600()
    ..container.padding.horizontal(12)
    ..container.padding.vertical(6)
    ..container.borderRadius(16)
    ..textStyle.color.white()
    ..textStyle.fontSize(12)
    ..textStyle.fontWeight.w600(),
)

// Status badge
RxBadge(
  label: 'Online',
  icon: Icons.circle,
  style: RxBadgeStyle()
    ..container.color.green.shade100()
    ..textStyle.color.green.shade800()
    ..icon.color.green.shade600(),
)

// Notification count badge
RxBadge(
  label: '99+',
  style: RxBadgeStyle()
    ..container.color.red.shade600()
    ..container.borderRadius(12)
    ..container.padding.horizontal(8)
    ..container.padding.vertical(4)
    ..textStyle.color.white()
    ..textStyle.fontSize(10)
    ..textStyle.fontWeight.w700(),
)

// Icon-only badge
RxBadge(
  icon: Icons.star,
  style: RxBadgeStyle()
    ..container.color.yellow.shade400()
    ..container.borderRadius(20)
    ..container.padding.all(6)
    ..icon.color.white()
    ..icon.size(14),
)

// Custom content badge using raw constructor
RxBadge.raw(
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.trending_up, size: 12),
      SizedBox(width: 2),
      Text('Hot', style: TextStyle(fontSize: 10)),
    ],
  ),
  style: RxBadgeStyle()
    ..container.color.orange.shade500()
    ..container.padding.all(4)
    ..textStyle.color.white(),
)

// Outlined badge
RxBadge(
  label: 'Draft',
  style: RxBadgeStyle()
    ..container.border.all.color.grey.shade400()
    ..container.color.transparent()
    ..container.padding.horizontal(8)
    ..textStyle.color.grey.shade700(),
)

// Large badge
RxBadge(
  label: 'Featured',
  style: RxBadgeStyle()
    ..container.padding.horizontal(16)
    ..container.padding.vertical(8)
    ..container.borderRadius(20)
    ..textStyle.fontSize(14)
    ..textStyle.fontWeight.w600(),
)

// Compact badge
RxBadge(
  label: 'S',
  style: RxBadgeStyle()
    ..container.padding.all(4)
    ..container.borderRadius(4)
    ..textStyle.fontSize(10),
)

// Badge with variants
RxBadge(
  label: 'Important',
  variants: [PrimaryVariant()],
  style: RxBadgeStyle()
    ..container.padding.horizontal(12),
)
```

## Usage Patterns
```dart
// As notification indicator
Stack(
  children: [
    IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
    Positioned(
      right: 8,
      top: 8,
      child: RxBadge(
        label: '3',
        style: RxBadgeStyle()
          ..container.color.red.shade600()
          ..textStyle.color.white(),
      ),
    ),
  ],
)

// In list items
ListTile(
  title: Text('Product Name'),
  trailing: RxBadge(
    label: 'Sale',
    style: RxBadgeStyle()
      ..container.color.red.shade500()
      ..textStyle.color.white(),
  ),
)

// Category tags
Wrap(
  spacing: 8,
  children: categories.map((category) => 
    RxBadge(
      label: category,
      style: RxBadgeStyle()
        ..container.color.blue.shade100()
        ..textStyle.color.blue.shade800(),
    ),
  ).toList(),
)
```

## Notes
- Internally uses RxLabel for default constructor, providing consistent text+icon layout
- Raw constructor provides maximum flexibility for custom badge content
- Default styling creates subtle, readable badges suitable for most use cases
- Small default padding optimized for compact display
- Text height of 1.1 provides good readability without excess line spacing
- Style merging: default style → custom style → variants
- Stateless design makes it efficient for lists and repeated usage
- No built-in click handling - wrap with GestureDetector or Button if needed
- Icon theming applied via IconTheme for consistent icon appearance
- Supports Mix lerp system for smooth style transitions in animations
- Perfect for overlay positioning with Stack widgets