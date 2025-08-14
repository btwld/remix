# TextField - Old Component Documentation

## Overview
The RxTextField is a comprehensive text input component that supports various input types, validation states, and extensive customization options. It integrates with the Mix styling system and provides features including labels, helper text, prefix/suffix widgets, placeholder text, character limits, and accessibility support. The component supports both single-line and multi-line input modes.

## API Parameters

### RxTextField Parameters

#### Required Parameters
None - all parameters are optional with sensible defaults.

#### Optional Parameters
| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| controller | TextEditingController? | Controller for managing text content | null |
| focusNode | FocusNode? | Focus node for keyboard navigation | null |
| enabled | bool | Whether the text field is interactive | true |
| readOnly | bool | Whether the text field is read-only | false |
| autofocus | bool | Whether to focus automatically when widget appears | false |
| obscureText | bool | Whether to hide text (for passwords) | false |
| maxLines | int? | Maximum number of lines (1 for single-line) | 1 |
| minLines | int? | Minimum number of lines | null |
| expands | bool | Whether to expand to fill available space | false |
| maxLength | int? | Maximum number of characters allowed | null |
| keyboardType | TextInputType? | Type of keyboard to show | auto-detected |
| textInputAction | TextInputAction? | Action button on keyboard | null |
| textCapitalization | TextCapitalization | Capitalization behavior | TextCapitalization.none |
| onChanged | ValueChanged<String>? | Callback when text changes | null |
| onSubmitted | ValueChanged<String>? | Callback when user submits | null |
| onEditingComplete | VoidCallback? | Callback when editing completes | null |
| hintText | String? | Placeholder text when field is empty | null |
| label | String? | Label text displayed above field | null |
| helperText | String? | Helper text displayed below field | null |
| prefix | Widget? | Widget displayed before input text | null |
| suffix | Widget? | Widget displayed after input text | null |
| error | bool | Whether to show error state styling | false |
| style | RxTextFieldStyle? | Custom styling configuration | null |
| variants | List<Variant> | Style variants to apply | const [] |

#### Additional Parameters
The component supports numerous additional Flutter TextField parameters including:
- `inputFormatters`, `autocorrect`, `enableSuggestions`
- `selectionControls`, `scrollController`, `scrollPhysics`
- `autofillHints`, `contentInsertionConfiguration`
- `spellCheckConfiguration`, `magnifierConfiguration`
- `contextMenuBuilder`, `undoController`
- And many more Flutter TextField properties

## Styling Configuration

### Default Theme Values
```dart
// Default styling from RxTextFieldStyle._default()
container.color.white()
container.border.all.color.grey.shade300()
container.borderRadius(6)
container.padding.vertical(8)
container.padding.horizontal(12)
hintTextColor.grey.shade500()
style.color.black()
helperText.color.grey.shade500()
helperText.letterSpacing(0.1)
```

### Style Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| container | FlexBoxSpec | Container for the input area | FlexBoxSpec() |
| style | TextStyle | Text styling for input content | TextStyle() |
| hintTextColor | Color? | Color for placeholder text | null |
| helperText | TextSpec | Styling for helper text | TextSpec() |
| textAlign | TextAlign | Text alignment within field | TextAlign.start |
| spacing | double | Vertical spacing between elements | 4.0 |

### Cursor and Selection Properties
| Property | Type | Description | Default Value |
|----------|------|-------------|---------------|
| cursorWidth | double | Width of text cursor | 2.0 |
| cursorHeight | double? | Height of text cursor | null |
| cursorRadius | Radius? | Radius of text cursor corners | null |
| cursorColor | Color? | Color of text cursor | null |
| cursorOffset | Offset | Offset for cursor positioning | Offset.zero |
| cursorOpacityAnimates | bool? | Whether cursor opacity animates | null |
| selectionHeightStyle | BoxHeightStyle | Height style for text selection | BoxHeightStyle.tight |
| selectionWidthStyle | BoxWidthStyle | Width style for text selection | BoxWidthStyle.tight |
| keyboardAppearance | Brightness? | Appearance of keyboard | null |
| scrollPadding | EdgeInsets | Padding when scrolling into view | EdgeInsets.all(20.0) |

## Behavior Documentation

### Interactions
- **Text Input**: Standard text editing with cursor and selection
- **Focus Management**: Automatic and manual focus control
- **Tap to Focus**: Taps move cursor and show keyboard
- **Selection**: Text selection with platform-specific controls
- **Hover**: Visual feedback on hover via MixController
- **Press**: Visual feedback on press via MixController
- **Keyboard Actions**: Submit, next, done actions
- **Scroll**: Automatic scrolling for long text

### Animation/Transitions
- **Focus Transitions**: Smooth focus state changes
- **Cursor Animation**: Blinking cursor with customizable timing
- **Selection Animation**: Smooth text selection updates
- **State Transitions**: Animated style changes via Mix system

### State Management
- Internal state management via MixControllerMixin:
  - hovered: bool
  - pressed: bool
  - focused: bool
- Error state via ErrorableMixin
- Disable state via DisableableMixin
- Text content managed by TextEditingController

## Variants and Configurations

### Input Types
- **Single-line**: maxLines=1, default behavior
- **Multi-line**: maxLines>1 or null for unlimited
- **Expandable**: expands=true to fill available space
- **Password**: obscureText=true with custom obscuring character
- **Read-only**: readOnly=true for display-only fields
- **Disabled**: enabled=false for non-interactive fields

### Validation States
- **Normal**: Default appearance
- **Error**: error=true for validation errors
- **Focused**: Automatic focus state styling
- **Disabled**: Grayed out appearance when disabled

### Layout Configurations
- **With Label**: label parameter adds top label
- **With Helper**: helperText parameter adds bottom helper text
- **With Prefix**: prefix widget before input area
- **With Suffix**: suffix widget after input area
- **Compact**: Minimal padding and spacing
- **Expanded**: Full width with expands=true

## Accessibility Features
- Full screen reader support with semantic labels
- Keyboard navigation with focus management
- Text selection accessibility
- Input method editor (IME) support
- Autofill integration for forms
- Platform-specific text selection controls
- Undo/redo support with UndoHistoryController
- Magnifier support for text selection
- Spell check integration

## Dependencies
- **Required components**:
  - NakedTextField (base text field functionality)
  - RemixBuilder (style application)
  
- **Utility dependencies**:
  - MixControllerMixin (interaction states)
  - DisableableMixin (disable behavior)  
  - ErrorableMixin (error states)
  - TextFieldSpec (specification pattern)
  - Custom placeholder painter
  
- **Flutter dependencies**:
  - TextEditingController (text management)
  - FocusNode (focus management)
  - TextInputFormatter (input validation)
  - All standard Flutter TextField features

## Usage Examples
```dart
// Basic text field
TextEditingController _controller = TextEditingController();

RxTextField(
  controller: _controller,
  hintText: 'Enter your name',
  onChanged: (value) {
    print('Text changed: $value');
  },
)

// Password field
RxTextField(
  obscureText: true,
  hintText: 'Password',
  label: 'Password',
  helperText: 'Must be at least 8 characters',
  onSubmitted: (value) => handlePasswordSubmit(value),
)

// Multi-line text area
RxTextField(
  maxLines: 5,
  hintText: 'Enter your message...',
  label: 'Message',
  keyboardType: TextInputType.multiline,
  textInputAction: TextInputAction.newline,
)

// Search field with prefix/suffix
RxTextField(
  hintText: 'Search...',
  prefix: Icon(Icons.search),
  suffix: IconButton(
    icon: Icon(Icons.clear),
    onPressed: () => _controller.clear(),
  ),
  controller: _controller,
)

// Custom styled text field
RxTextField(
  label: 'Custom Field',
  style: RxTextFieldStyle()
    ..container.color.blue.shade50()
    ..container.border.all.color.blue.shade300()
    ..container.borderRadius(12)
    ..container.padding.all(16)
    ..style.fontSize(16)
    ..hintTextColor.grey.shade400(),
  variants: [PrimaryVariant()],
)

// Error state field
RxTextField(
  error: true,
  hintText: 'Required field',
  label: 'Email',
  helperText: 'Please enter a valid email address',
)

// Disabled field
RxTextField(
  enabled: false,
  controller: TextEditingController(text: 'Read-only value'),
  label: 'Status',
)

// Character limited field
RxTextField(
  maxLength: 100,
  hintText: 'Limited to 100 characters',
  helperText: 'Character count shown below',
)

// Numeric input field
RxTextField(
  keyboardType: TextInputType.number,
  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  hintText: 'Enter number',
  label: 'Age',
)

// Email field with autofill
RxTextField(
  keyboardType: TextInputType.emailAddress,
  autofillHints: [AutofillHints.email],
  hintText: 'Enter email',
  label: 'Email Address',
)
```

## Notes
- Supports nearly all Flutter TextField parameters for maximum compatibility
- Custom placeholder painter provides enhanced placeholder text rendering
- Automatic keyboard type detection based on maxLines (single vs multi-line)
- Character counter automatically appears when maxLength is set
- Prefix and suffix widgets integrated into container layout
- Error state can be controlled independently of validation logic
- Full integration with Flutter's text editing and input systems
- Style merging: default style → custom style → variants
- Uses NakedTextField for core functionality with Remix styling layer
- Comprehensive accessibility support following Flutter best practices
- Supports both controlled (with controller) and uncontrolled usage patterns