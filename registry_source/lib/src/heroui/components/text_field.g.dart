// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_field.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixTextField]: label, input, and description or error.
///
/// Pass [RemixTextField.error] for the error treatment, and the error message
/// as `helperText`; validation stays with the app.
///
/// [minLines] and [maxLines] reach the field itself and the placeholder's line
/// budget, which is why they are named here: see [heroUiHintLines].
class HeroUiTextField extends StatelessWidget {
  const HeroUiTextField({
    super.key,
    this.variant = .primary,
    this.maxLines = 1,
    this.minLines,
    this.style = const TextFieldStyler.create(),
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.helperText,
    this.error = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = .none,
    this.textDirection,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.dragStartBehavior = .start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
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
    this.leading,
    this.trailing,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
  });

  /// The field surface fill, with its shadow.
  const HeroUiTextField.primary({
    super.key,
    this.maxLines = 1,
    this.minLines,
    this.style = const TextFieldStyler.create(),
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.helperText,
    this.error = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = .none,
    this.textDirection,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.dragStartBehavior = .start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
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
    this.leading,
    this.trailing,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
  }) : variant = HeroUiTextFieldVariant.primary;

  /// The `default` fill.
  const HeroUiTextField.secondary({
    super.key,
    this.maxLines = 1,
    this.minLines,
    this.style = const TextFieldStyler.create(),
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.helperText,
    this.error = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = .none,
    this.textDirection,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.dragStartBehavior = .start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
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
    this.leading,
    this.trailing,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
  }) : variant = HeroUiTextFieldVariant.secondary;

  final HeroUiTextFieldVariant variant;

  final int? maxLines;

  final int? minLines;

  final TextFieldStyler style;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final String? label;

  final String? hintText;

  final String? helperText;

  final bool error;

  final TextInputType? keyboardType;

  final TextInputAction? textInputAction;

  final TextCapitalization textCapitalization;

  final TextDirection? textDirection;

  final bool obscureText;

  final bool enabled;

  final bool readOnly;

  final bool autofocus;

  final bool expands;

  final int? maxLength;

  final MaxLengthEnforcement? maxLengthEnforcement;

  final ValueChanged<String>? onChanged;

  final VoidCallback? onEditingComplete;

  final ValueChanged<String>? onSubmitted;

  final AppPrivateCommandCallback? onAppPrivateCommand;

  final List<TextInputFormatter>? inputFormatters;

  final bool? showCursor;

  final String obscuringCharacter;

  final bool autocorrect;

  final bool enableSuggestions;

  final SmartDashesType? smartDashesType;

  final SmartQuotesType? smartQuotesType;

  final DragStartBehavior dragStartBehavior;

  final bool enableInteractiveSelection;

  final TextSelectionControls? selectionControls;

  final GestureTapCallback? onTap;

  final TapRegionCallback? onTapOutside;

  final TapRegionUpCallback? onPressUpOutside;

  final bool onTapAlwaysCalled;

  final ScrollController? scrollController;

  final ScrollPhysics? scrollPhysics;

  final Iterable<String>? autofillHints;

  final ContentInsertionConfiguration? contentInsertionConfiguration;

  final Clip clipBehavior;

  final String? restorationId;

  final bool stylusHandwritingEnabled;

  final bool enableIMEPersonalizedLearning;

  final EditableTextContextMenuBuilder? contextMenuBuilder;

  final SpellCheckConfiguration? spellCheckConfiguration;

  final TextMagnifierConfiguration? magnifierConfiguration;

  final bool canRequestFocus;

  final bool? ignorePointers;

  final UndoHistoryController? undoController;

  final Object groupId;

  final Widget? leading;

  final Widget? trailing;

  final String? semanticLabel;

  final String? semanticHint;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext _) {
    return RemixTextField(
      style: heroUiTextFieldStyle(
        variant: variant,
        maxLines: maxLines,
        minLines: minLines,
        style: style,
      ),
      controller: controller,
      focusNode: focusNode,
      label: label,
      hintText: hintText,
      helperText: helperText,
      error: error,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      textDirection: textDirection,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
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
      showCursor: showCursor,
      obscuringCharacter: obscuringCharacter,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      onTap: onTap,
      onTapOutside: onTapOutside,
      onPressUpOutside: onPressUpOutside,
      onTapAlwaysCalled: onTapAlwaysCalled,
      scrollController: scrollController,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      contentInsertionConfiguration: contentInsertionConfiguration,
      clipBehavior: clipBehavior,
      restorationId: restorationId,
      stylusHandwritingEnabled: stylusHandwritingEnabled,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      contextMenuBuilder: contextMenuBuilder,
      spellCheckConfiguration: spellCheckConfiguration,
      magnifierConfiguration: magnifierConfiguration,
      canRequestFocus: canRequestFocus,
      ignorePointers: ignorePointers,
      undoController: undoController,
      groupId: groupId,
      leading: leading,
      trailing: trailing,
      semanticLabel: semanticLabel,
      semanticHint: semanticHint,
      excludeSemantics: excludeSemantics,
    );
  }
}
