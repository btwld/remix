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
class RemixTextField extends StatefulWidget with HasEnabled, HasError {
  RemixTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.textDirection,
    this.readOnly = false,
    this.showCursor,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTapOutside,
    this.onPressUpOutside,
    this.onTapAlwaysCalled = false,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints,
    this.contentInsertionConfiguration,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.stylusHandwritingEnabled = true,
    this.enableIMEPersonalizedLearning = true,
    this.contextMenuBuilder,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
    this.canRequestFocus = true,
    this.ignorePointers,
    this.undoController,
    this.groupId = EditableText,
    this.hintText,
    this.helperText,
    this.label,
    this.error = false,
    this.leading,
    this.trailing,
    this.onPressed,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.style = const RemixTextFieldStyle.create(),
  });

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Defines the keyboard focus for this widget.
  final FocusNode? focusNode;

  /// Undo controller for managing undo/redo operations.
  final UndoHistoryController? undoController;

  /// The group ID for the text field.
  final Object groupId;

  /// The type of keyboard to use for editing the text.
  final TextInputType? keyboardType;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard.
  final TextCapitalization textCapitalization;

  /// The directionality of the text.
  final TextDirection? textDirection;

  /// Whether the text can be changed.
  final bool readOnly;

  /// Whether to show cursor.
  final bool? showCursor;

  /// Whether this text field should focus itself if nothing else is already focused.
  final bool autofocus;

  /// Whether to hide the text being edited.
  final bool obscureText;

  /// Character used for obscuring text if obscureText is true.
  final String obscuringCharacter;

  /// Whether to enable autocorrect.
  final bool autocorrect;

  /// Whether to show input suggestions as the user types.
  final bool enableSuggestions;

  /// Configuration for smart dashes.
  final SmartDashesType? smartDashesType;

  /// Configuration for smart quotes.
  final SmartQuotesType? smartQuotesType;

  /// The maximum number of lines for the text to span.
  final int? maxLines;

  /// The minimum number of lines to occupy when the content spans fewer lines.
  final int? minLines;

  /// Whether this widget's height will be sized to fill its parent.
  final bool expands;

  /// The maximum number of characters to allow in the text field.
  final int? maxLength;

  /// How the maxLength limit should be enforced.
  final MaxLengthEnforcement? maxLengthEnforcement;

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
  final bool enabled;

  /// Defines how to handle drag start behavior.
  final DragStartBehavior dragStartBehavior;

  /// Whether to enable user interface affordances for changing the text selection.
  final bool enableInteractiveSelection;

  /// Optional delegate for building the text selection handles and toolbar.
  final TextSelectionControls? selectionControls;

  /// Called when the user taps outside of this text field.
  final TapRegionCallback? onTapOutside;

  /// Called when tap up is detected outside of this text field.
  final TapRegionUpCallback? onPressUpOutside;

  /// Whether onTap should be called for every tap.
  final bool onTapAlwaysCalled;

  /// The ScrollController to use when vertically scrolling the input.
  final ScrollController? scrollController;

  /// The ScrollPhysics to use when vertically scrolling the input.
  final ScrollPhysics? scrollPhysics;

  /// A list of strings that helps the autofill service identify the type of this text input.
  final Iterable<String>? autofillHints;

  /// Configuration for content insertion.
  final ContentInsertionConfiguration? contentInsertionConfiguration;

  /// The content will be clipped (or not) according to this option.
  final Clip clipBehavior;

  /// Restoration ID to save and restore the state of the text field.
  final String? restorationId;

  /// Whether stylus handwriting is enabled.
  final bool stylusHandwritingEnabled;

  /// Whether to enable that the IME update personalized data.
  final bool enableIMEPersonalizedLearning;

  /// A context menu builder for the text field.
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Configuration for spell checking.
  final SpellCheckConfiguration? spellCheckConfiguration;

  /// Configuration for text magnification.
  final TextMagnifierConfiguration? magnifierConfiguration;

  /// Whether this text field can request focus.
  final bool canRequestFocus;

  /// Whether to ignore pointer events.
  final bool? ignorePointers;

  /// Hint text to display when the text field is empty.
  final String? hintText;

  /// Helper text to display below the text field.
  final String? helperText;

  /// Label text to display above the text field.
  final String? label;

  /// Whether the text field is in error state.
  final bool error;

  /// A widget to display at the leading edge of the text field.
  final Widget? leading;

  /// A widget to display at the trailing edge of the text field.
  final Widget? trailing;

  /// Called when the text field is pressed (for tap interactions).
  final VoidCallback? onPressed;

  /// The semantic label for the text field.
  final String? semanticLabel;

  /// The semantic hint for the text field.
  final String? semanticHint;

  /// Whether to exclude child semantics.
  final bool excludeSemantics;

  /// The style configuration for the text field.
  final RemixTextFieldStyle style;

  @override
  State<RemixTextField> createState() => _RemixTextFieldState();
}

class _RemixTextFieldState extends State<RemixTextField>
    with HasWidgetStateController {
  RemixTextFieldStyle get _style => widget.style;

  TextEditingController? _internalController;
  TextEditingController get _controller =>
      widget.controller ?? (_internalController ??= TextEditingController());

  @override
  void didUpdateWidget(covariant RemixTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Clean up internal controller if external one is now provided
    if (oldWidget.controller == null &&
        widget.controller != null &&
        _internalController != null) {
      _internalController!.dispose();
      _internalController = null;
    }
  }

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StyleBuilder<TextFieldSpec>(
      style: _style,
      controller: controller,
      builder: (context, spec) {
        return Semantics(
          excludeSemantics: widget.excludeSemantics,
          enabled: widget.enabled && !widget.readOnly,
          textField: true,
          focusable: widget.enabled && !widget.readOnly,
          obscured: widget.obscureText,
          multiline: widget.maxLines != 1,
          label: widget.semanticLabel ?? widget.label,
          value: _controller.text,
          hint: widget.semanticHint ?? widget.hintText,
          child: NakedTextField(
            groupId: widget.groupId,
            controller: _controller,
            focusNode: widget.focusNode,
            undoController: widget.undoController,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            textCapitalization: widget.textCapitalization,
            textAlign: spec.textAlign,
            textDirection: widget.textDirection,
            readOnly: widget.readOnly,
            showCursor: widget.showCursor,
            autofocus: widget.autofocus,
            obscuringCharacter: widget.obscuringCharacter,
            obscureText: widget.obscureText,
            autocorrect: widget.autocorrect,
            smartDashesType: widget.smartDashesType,
            smartQuotesType: widget.smartQuotesType,
            enableSuggestions: widget.enableSuggestions,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            expands: widget.expands,
            maxLength: widget.maxLength,
            maxLengthEnforcement: widget.maxLengthEnforcement,
            onChanged: widget.onChanged,
            onEditingComplete: widget.onEditingComplete,
            onSubmitted: widget.onSubmitted,
            onAppPrivateCommand: widget.onAppPrivateCommand,
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled,
            cursorWidth: spec.cursorWidth,
            cursorHeight: spec.cursorHeight,
            cursorRadius: spec.cursorRadius,
            cursorOpacityAnimates: spec.cursorOpacityAnimates,
            cursorColor: spec.cursorColor,
            selectionHeightStyle: spec.selectionHeightStyle,
            selectionWidthStyle: spec.selectionWidthStyle,
            keyboardAppearance: spec.keyboardAppearance,
            scrollPadding: spec.scrollPadding,
            dragStartBehavior: widget.dragStartBehavior,
            enableInteractiveSelection: widget.enableInteractiveSelection,
            selectionControls: widget.selectionControls,
            onTapAlwaysCalled: widget.onTapAlwaysCalled,
            onTapOutside: widget.onTapOutside,
            scrollController: widget.scrollController,
            scrollPhysics: widget.scrollPhysics,
            autofillHints: widget.autofillHints,
            contentInsertionConfiguration: widget.contentInsertionConfiguration,
            clipBehavior: widget.clipBehavior,
            restorationId: widget.restorationId,
            stylusHandwritingEnabled: widget.stylusHandwritingEnabled,
            enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
            contextMenuBuilder: widget.contextMenuBuilder,
            canRequestFocus: widget.canRequestFocus,
            spellCheckConfiguration: widget.spellCheckConfiguration,
            magnifierConfiguration: widget.magnifierConfiguration,
            style: spec.text.spec.style ?? const TextStyle(),
            ignorePointers: widget.ignorePointers,
            builder: (context, editableText) {
              // Build the core editable with hint overlay if needed
              final editableWithHint = widget.hintText != null
                  ? Stack(
                      alignment: AlignmentDirectional.centerStart,
                      children: [
                        ListenableBuilder(
                          listenable: _controller,
                          builder: (context, _) => Visibility(
                            visible: _controller.text.isEmpty,
                            child: Builder(
                              builder: (context) {
                                final HintText = spec.hintText.createWidget;

                                return HintText(widget.hintText!);
                              },
                            ),
                          ),
                        ),
                        editableText,
                      ],
                    )
                  : editableText;

              final FlexContainer = spec.container.createWidget;
              final Label = spec.label.createWidget;
              final HelperText = spec.helperText.createWidget;

              // Add leading/trailing widgets if present
              final withAccessories = FlexContainer(
                direction: Axis.horizontal,
                children: [
                  if (widget.leading != null) widget.leading!,
                  Flexible(fit: FlexFit.loose, child: editableWithHint),
                  if (widget.trailing != null) widget.trailing!,
                ],
              );

              // Add label and helper text if present
              final needsWrapper =
                  widget.label != null || widget.helperText != null;

              return needsWrapper
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: spec.spacing,
                      children: [
                        if (widget.label != null) Label(widget.label!),
                        withAccessories,
                        if (widget.helperText != null)
                          HelperText(widget.helperText!),
                      ],
                    )
                  : withAccessories;
            },
          ),
        );
      },
    );
  }
}
