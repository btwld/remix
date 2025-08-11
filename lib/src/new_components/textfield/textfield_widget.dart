part of 'textfield.dart';

/// A customizable text field component that supports various styles and behaviors.
/// The text field integrates with the Mix styling system and follows Remix design patterns.
///
/// ## Example
///
/// ```dart
/// RemixTextField(
///   controller: _controller,
///   hintText: 'Enter your name',
///   helperText: 'Required field',
///   onChanged: (value) {
///     print('Value changed: $value');
///   },
///   style: TextFieldStyle(),
/// )
/// ```
class RemixTextField extends StatefulWidget implements Disableable {
  const RemixTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.showCursor,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled = true,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionHeightStyle = BoxHeightStyle.tight,
    this.selectionWidthStyle = BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints,
    this.restorationId,
    this.enableIMEPersonalizedLearning = true,
    this.contextMenuBuilder,
    this.canRequestFocus = true,
    this.hintText,
    this.helperText,
    this.textFieldStyle,
    this.variants = const [],
  });

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Defines the keyboard focus for this widget.
  final FocusNode? focusNode;

  /// The decoration to show around the text field.
  final InputDecoration? decoration;

  /// The type of keyboard to use for editing the text.
  final TextInputType? keyboardType;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard.
  final TextCapitalization textCapitalization;

  /// The style to use for the text being edited.
  final TextStyle? style;

  /// The strut style used for the vertical layout.
  final StrutStyle? strutStyle;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// How the text should be aligned vertically.
  final TextAlignVertical? textAlignVertical;

  /// The directionality of the text.
  final TextDirection? textDirection;

  /// Whether the text can be changed.
  final bool readOnly;

  /// Whether to show cursor.
  final bool? showCursor;

  /// Whether this text field should focus itself if nothing else is already focused.
  final bool autofocus;

  /// Character used for obscuring text if obscureText is true.
  final String obscuringCharacter;

  /// Whether to hide the text being edited.
  final bool obscureText;

  /// Whether to enable autocorrect.
  final bool autocorrect;

  /// Whether to show input suggestions as the user types.
  final bool enableSuggestions;

  /// The maximum number of lines for the text to span.
  final int? maxLines;

  /// The minimum number of lines to occupy when the content spans fewer lines.
  final int? minLines;

  /// Whether this widget's height will be sized to fill its parent.
  final bool expands;

  /// The maximum number of characters to allow in the text field.
  final int? maxLength;

  /// Called when the user initiates a change to the TextField's value.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits editable content.
  final VoidCallback? onEditingComplete;

  /// Called when the user indicates that they are done editing the text in the field.
  final ValueChanged<String>? onSubmitted;

  /// This is used to receive a private command from the input method.
  final AppPrivateCommandCallback? onAppPrivateCommand;

  /// Optional input formatters.
  final List<TextInputFormatter>? inputFormatters;

  /// Whether the text field is enabled.
  @override
  final bool enabled;

  /// How thick the cursor will be.
  final double cursorWidth;

  /// How tall the cursor will be.
  final double? cursorHeight;

  /// How rounded the corners of the cursor should be.
  final Radius? cursorRadius;

  /// The color to use when painting the cursor.
  final Color? cursorColor;

  /// Controls how tall the selection highlight boxes are computed to be.
  final BoxHeightStyle selectionHeightStyle;

  /// Controls how wide the selection highlight boxes are computed to be.
  final BoxWidthStyle selectionWidthStyle;

  /// The appearance of the keyboard.
  final Brightness? keyboardAppearance;

  /// Configures padding to edges surrounding a Scrollable when the TextField scrolls into view.
  final EdgeInsets scrollPadding;

  /// Determines the way that drag start behavior is handled.
  final DragStartBehavior dragStartBehavior;

  /// Whether to enable user interface affordances for changing the text selection.
  final bool enableInteractiveSelection;

  /// Optional delegate for building the text selection handles and toolbar.
  final TextSelectionControls? selectionControls;

  /// Called when the user taps on this text field.
  final GestureTapCallback? onTap;

  /// The cursor for a mouse pointer when it enters or is hovering over the widget.
  final MouseCursor? mouseCursor;

  /// Callback that generates a custom InputDecoration.counter widget.
  final InputCounterWidgetBuilder? buildCounter;

  /// The ScrollController to use when vertically scrolling the input.
  final ScrollController? scrollController;

  /// The ScrollPhysics to use when vertically scrolling the input.
  final ScrollPhysics? scrollPhysics;

  /// A list of strings that helps the autofill service identify the type of this text input.
  final Iterable<String>? autofillHints;

  /// Restoration ID to save and restore the state of the text field.
  final String? restorationId;

  /// Whether to enable that the IME update personalized data.
  final bool enableIMEPersonalizedLearning;

  /// A context menu builder for the text field.
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Whether this text field can request focus.
  final bool canRequestFocus;

  /// Hint text to display when the text field is empty.
  final String? hintText;

  /// Helper text to display below the text field.
  final String? helperText;

  /// The style configuration for the text field.
  final TextFieldStyle? textFieldStyle;

  /// List of style variants to apply.
  final List<Variant> variants;

  @override
  State<RemixTextField> createState() => _RemixTextFieldState();
}

class _RemixTextFieldState extends State<RemixTextField>
    with MixControllerMixin, DisableableMixin {
  TextFieldStyle get _style =>
      DefaultTextFieldStyle.merge(widget.textFieldStyle ?? TextFieldStyle());

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: _style,
      builder: (context, spec) {
        // Build the text field with helper text if provided
        final textField = TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          style: spec.style.merge(widget.style),
          strutStyle: widget.strutStyle,
          textAlign: spec.textAlign,
          textAlignVertical: widget.textAlignVertical,
          textDirection: widget.textDirection,
          readOnly: widget.readOnly,
          showCursor: widget.showCursor,
          autofocus: widget.autofocus,
          obscuringCharacter: widget.obscuringCharacter,
          obscureText: widget.obscureText,
          autocorrect: widget.autocorrect,
          enableSuggestions: widget.enableSuggestions,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          expands: widget.expands,
          maxLength: widget.maxLength,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onSubmitted,
          onAppPrivateCommand: widget.onAppPrivateCommand,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          cursorWidth: spec.cursorWidth,
          cursorHeight: spec.cursorHeight,
          cursorRadius: spec.cursorRadius,
          cursorColor: spec.cursorColor,
          cursorOpacityAnimates: spec.cursorOpacityAnimates,
          selectionHeightStyle: spec.selectionHeightStyle,
          selectionWidthStyle: spec.selectionWidthStyle,
          keyboardAppearance: spec.keyboardAppearance,
          scrollPadding: spec.scrollPadding,
          dragStartBehavior: widget.dragStartBehavior,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          selectionControls: widget.selectionControls,
          onTap: widget.onTap,
          mouseCursor: widget.mouseCursor,
          buildCounter: widget.buildCounter,
          scrollController: widget.scrollController,
          scrollPhysics: widget.scrollPhysics,
          autofillHints: widget.autofillHints,
          restorationId: widget.restorationId,
          enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
          contextMenuBuilder: widget.contextMenuBuilder,
          canRequestFocus: widget.canRequestFocus,
          decoration: widget.decoration ??
              InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(color: spec.hintTextColor),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
        );

        // Build the final widget
        final Widget finalWidget;
        
        if (widget.helperText != null) {
          // If helper text is provided, wrap in a column
          finalWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              textField,
              SizedBox(height: spec.spacing),
              spec.helperText(widget.helperText!),
            ],
          );
        } else {
          finalWidget = textField;
        }

        // Apply container styling
        return spec.container.box(child: finalWidget);
      },
      controller: stateController,
    );
  }
}