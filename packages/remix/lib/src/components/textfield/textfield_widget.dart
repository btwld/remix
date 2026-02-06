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
class RemixTextField extends StatelessWidget {
  const RemixTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = .none,
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
    this.dragStartBehavior = .start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTapOutside,
    this.onPressUpOutside,
    this.onTapAlwaysCalled = false,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints,
    this.contentInsertionConfiguration,
    this.clipBehavior = .hardEdge,
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
    this.styleSpec,
    this.leading,
    this.trailing,
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

  /// The semantic label for the text field.
  final String? semanticLabel;

  /// The semantic hint for the text field.
  final String? semanticHint;

  /// Whether to exclude child semantics.
  final bool excludeSemantics;

  /// The style configuration for the text field.
  final RemixTextFieldStyle style;

  /// The style spec for the text field.
  final RemixTextFieldSpec? styleSpec;

  static final styleFrom = RemixTextFieldStyle.new;

  @override
  Widget build(BuildContext context) {
    // NakedTextField handles semantics internally, no outer Semantics needed
    return NakedTextField(
      groupId: groupId,
      controller: controller,
      focusNode: focusNode,
      undoController: undoController,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      textAlign: .start,
      textDirection: textDirection,
      readOnly: readOnly,
      showCursor: showCursor,
      autofocus: autofocus,
      obscuringCharacter: obscuringCharacter,
      obscureText: obscureText,
      autocorrect: autocorrect,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      enableSuggestions: enableSuggestions,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      onAppPrivateCommand: onAppPrivateCommand,
      inputFormatters: inputFormatters,
      enabled: enabled,
      // Cursor properties will be styled via StyleBuilder
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      onTapAlwaysCalled: onTapAlwaysCalled,
      onTapOutside: onTapOutside,
      scrollController: scrollController,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      contentInsertionConfiguration: contentInsertionConfiguration,
      clipBehavior: clipBehavior,
      restorationId: restorationId,
      stylusHandwritingEnabled: stylusHandwritingEnabled,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      contextMenuBuilder: contextMenuBuilder,
      canRequestFocus: canRequestFocus,
      spellCheckConfiguration: spellCheckConfiguration,
      magnifierConfiguration: magnifierConfiguration,
      semanticLabel: semanticLabel ?? label,
      semanticHint: semanticHint ?? hintText,
      builder: (BuildContext context, state, Widget editableText) {
        final textFieldState = NakedTextFieldState.of(context);

        // Create a controller with the current states plus error state if needed.
        // Note: This controller is used transiently for style resolution and
        // doesn't need explicit disposal as it's not a listener subscription.
        final controller = WidgetStatesController({
          ...NakedTextFieldState.controllerOf(context).value,
          if (error) .error,
        });

        return StyleBuilder(
          style: style,
          controller: controller,
          builder: (context, spec) {
            // Apply text style from spec
            final textStyleSpec =
                spec.text ?? const StyleSpec(spec: TextSpec());
            final textStyle = textStyleSpec.spec.style ?? const TextStyle();

            final styledEditableText = DefaultTextStyle(
              style: textStyle,
              textAlign: spec.textAlign,
              child: editableText,
            );

            // Build the core editable with hint overlay if needed
            final editableWithHint = hintText != null
                ? Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      if (textFieldState.text.isEmpty)
                        Positioned.fill(
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: StyledText(
                              hintText!,
                              styleSpec: spec.hintText,
                            ),
                          ),
                        ),
                      styledEditableText,
                    ],
                  )
                : styledEditableText;

            // Use Box widgets instead of deprecated createWidget

            // Add leading/trailing widgets if present
            final withAccessories = RowBox(
              styleSpec: spec.container,
              children: [
                if (leading != null) leading!,
                // ignore: avoid-flexible-outside-flex
                Expanded(child: editableWithHint),
                if (trailing != null) trailing!,
              ],
            );

            // Add label and helper text if present
            final needsWrapper = label != null || helperText != null;

            return needsWrapper
                ? Column(
                    mainAxisSize: .min,
                    crossAxisAlignment: .start,
                    children: [
                      if (label != null)
                        StyledText(label!, styleSpec: spec.label),
                      withAccessories,
                      if (helperText != null)
                        StyledText(helperText!, styleSpec: spec.helperText),
                    ],
                  )
                : withAccessories;
          },
        );
      },
    );
  }
}
