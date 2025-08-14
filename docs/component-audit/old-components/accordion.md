# Accordion - Old Component Documentation

## Overview
The RxAccordion is a collapsible accordion component that can contain multiple expandable items. It supports single or multiple expanded sections, custom controllers, and various style configurations. Each accordion item can be individually enabled/disabled and supports custom headers and icons.

## API Parameters

### RxAccordion Parameters

#### Required Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| children | List<RxAccordionItem<T>> | List of accordion items to display | - |

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| initialExpandedValues | List<T> | Values that should be initially expanded | const [] |
| controller | RxAccordionController<T>? | Optional controller to manage accordion state | null |
| style | RxAccordionStyle? | Custom styling configuration | null |
| variants | List<Variant> | Style variants to apply | const [] |
| defaultTrailingIcon | IconData | Default icon for expand/collapse | Icons.keyboard_arrow_down_rounded |

### RxAccordionItem Parameters

#### Required Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| title | String | Text to display as section header (default constructor) | - |
| child | Widget | Content to display when expanded | - |
| value | T | Unique value associated with this item | - |
| header | Widget | Custom header widget (raw constructor) | - |

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| leadingIcon | IconData? | Optional icon before the title | null |
| focusNode | FocusNode? | Focus node for focus management | null |
| enabled | bool | Whether the accordion item is enabled | true |
| trailingIconBuilder | Widget Function(bool)? | Custom trailing icon builder | null |

### RxAccordionController Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| min | int? | Minimum number of expanded items | null |
| max | int? | Maximum number of expanded items | null |

## Styling Configuration

### Default Theme Values
```dart
// Default styling from RxAccordionStyle._default()
itemContainer.margin.bottom(12)
itemContainer.border.all.color.grey.shade300()
itemContainer.borderRadius.circular(12)
headerContainer.padding(12)
contentContainer.width.infinity()
contentContainer.padding(12)
contentContainer.padding.top(0)
contentContainer.color.transparent()
titleStyle.fontSize(14)
titleStyle.fontWeight.w500()
titleStyle.color.grey.shade800()
contentStyle.fontSize(14)
contentStyle.fontWeight.w400()
contentStyle.color.grey.shade800()
```

### Style Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| itemContainer | BoxSpec | Container for each accordion item | BoxSpec() |
| contentContainer | BoxSpec | Container for expanded content | BoxSpec() |
| headerContainer | FlexBoxSpec | Container for header layout | FlexBoxSpec() |
| leadingIcon | IconThemeData | Theme for leading icons | IconThemeData() |
| trailingIcon | IconSpec | Spec for trailing expand/collapse icon | IconSpec() |
| titleStyle | TextStyle | Text style for header titles | TextStyle() |
| contentStyle | TextStyle | Text style for content | TextStyle() |
| animated | AnimatedData | Animation configuration | null |

## Behavior Documentation

### Interactions
- **Header Click**: Toggles expand/collapse state via NakedButton
- **Hover**: Updates hover state on header via MixController
- **Focus**: Manages focus state with optional FocusNode
- **Press**: Visual feedback on header press
- **Disabled**: Item becomes non-interactive when disabled

### Animation/Transitions
- Default duration: 100ms with easeInOut curve
- Transition effects:
  - FadeTransition for opacity
  - SizeTransition for height (vertical axis)
  - AnimatedSwitcher for smooth content transitions
- Animation configuration via spec.contentContainer.animated
- Axis alignment: -1 (top alignment)

### State Management
- Controller manages expanded/collapsed states
- Internal states via MixControllerMixin:
  - hovered: bool
  - pressed: bool
  - focused: bool
  - selected: bool (tracks expanded state)
- Min/max expanded items enforced by controller
- Shared state via _InheritedAccordionStyle

## Variants and Configurations

### Constructors

#### RxAccordion
- Standard accordion container

#### RxAccordionItem
1. **Default Constructor** - Item with title and optional icon
   ```dart
   RxAccordionItem(
     title: 'Section 1',
     value: 'section1',
     child: content,
     leadingIcon: Icons.info
   )
   ```

2. **Raw Constructor** - Item with custom header
   ```dart
   RxAccordionItem.raw(
     header: CustomHeaderWidget(),
     value: 'custom',
     child: content
   )
   ```

### Visual Variants
- Supports custom variants through List<Variant> parameter
- Variants applied to all items via InheritedWidget
- Can control single vs multiple expansion via controller

### Expansion Modes
- **Single expansion**: Set controller.max = 1
- **Multiple expansion**: Default behavior or set controller.max > 1
- **Always expanded**: Set controller.min = number of items
- **Initial state**: Via initialExpandedValues parameter

## Accessibility Features
- Focus management with FocusNode support per item
- Keyboard navigation via NakedButton
- Semantic expand/collapse states
- Individual item disable support via Disableable interface
- Screen reader compatible with proper state announcements

## Dependencies
- **Required components**:
  - RxLabel (for default item headers)
  - NakedAccordion (base accordion functionality)
  - NakedAccordionItem (base item functionality)
  - NakedButton (interactive header)
  
- **Utility dependencies**:
  - MixControllerMixin (state management)
  - DisableableMixin (disable behavior)
  - RemixBuilder (style application)
  - AccordionSpec (specification pattern)
  
- **Theme dependencies**:
  - IconThemeData (icon theming)
  - TextStyle (text theming)
  - BoxSpec/FlexBoxSpec (container styling)

## Usage Examples
```dart
// Basic usage
RxAccordion<String>(
  children: [
    RxAccordionItem(
      title: 'Section 1',
      value: 'section1',
      child: Text('Content for section 1'),
    ),
    RxAccordionItem(
      title: 'Section 2',
      value: 'section2',
      child: Text('Content for section 2'),
    ),
  ],
)

// With initial expanded values and icons
RxAccordion<String>(
  initialExpandedValues: ['section1'],
  defaultTrailingIcon: Icons.expand_more,
  children: [
    RxAccordionItem(
      title: 'Important Info',
      value: 'section1',
      leadingIcon: Icons.warning,
      child: Container(height: 100, child: Text('Warning details')),
    ),
  ],
)

// With custom controller for single expansion
RxAccordion<int>(
  controller: RxAccordionController(max: 1),
  children: [
    RxAccordionItem(value: 0, title: 'Only One', child: content),
    RxAccordionItem(value: 1, title: 'At A Time', child: content),
  ],
)

// Custom header with raw constructor
RxAccordion<String>(
  children: [
    RxAccordionItem.raw(
      header: Row(
        children: [Icon(Icons.star), Text('Custom')],
      ),
      value: 'custom',
      child: Text('Custom content'),
      trailingIconBuilder: (isExpanded) => 
        Icon(isExpanded ? Icons.remove : Icons.add),
    ),
  ],
)

// With style and variants
RxAccordion<String>(
  style: customAccordionStyle,
  variants: [PrimaryVariant()],
  children: items,
)
```

## Notes
- Uses InheritedWidget pattern for sharing style across items
- Controller disposal handled automatically if not provided externally
- Post-frame callback ensures selected state syncs with expanded state
- AnimatedSwitcher provides smooth content transitions
- Style merging: default style → custom style → variants
- Generic type T allows flexible value types for tracking items
- Implements Disableable interface for consistent disable behavior
- Trailing icon rotation typically handled via IconSpec transformations