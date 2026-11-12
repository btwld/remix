// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'textfield.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's TextField recipe.
///
/// There is no hover fragment: the I-beam cursor is the affordance, and tinting
/// the box would compete with the focus ring that follows.
///
/// `EditableText` asserts on an `Overlay` ancestor when the field takes focus.
/// Any app with a `Navigator` has one; a bare `WidgetsApp(builder: ...)` has to
/// supply its own.
class PlaygroundTextField extends StatelessWidget {
  const PlaygroundTextField({
    super.key,
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

  final int? maxLines;

  final int? minLines;

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
  Widget build(BuildContext context) {
    return RemixTextField(
      key: this.key,
      style: playgroundTextFieldStyle(style: this.style),
      controller: this.controller,
      focusNode: this.focusNode,
      label: this.label,
      hintText: this.hintText,
      helperText: this.helperText,
      error: this.error,
      keyboardType: this.keyboardType,
      textInputAction: this.textInputAction,
      textCapitalization: this.textCapitalization,
      textDirection: this.textDirection,
      obscureText: this.obscureText,
      enabled: this.enabled,
      readOnly: this.readOnly,
      autofocus: this.autofocus,
      maxLines: this.maxLines,
      minLines: this.minLines,
      expands: this.expands,
      maxLength: this.maxLength,
      maxLengthEnforcement: this.maxLengthEnforcement,
      onChanged: this.onChanged,
      onEditingComplete: this.onEditingComplete,
      onSubmitted: this.onSubmitted,
      onAppPrivateCommand: this.onAppPrivateCommand,
      inputFormatters: this.inputFormatters,
      showCursor: this.showCursor,
      obscuringCharacter: this.obscuringCharacter,
      autocorrect: this.autocorrect,
      enableSuggestions: this.enableSuggestions,
      smartDashesType: this.smartDashesType,
      smartQuotesType: this.smartQuotesType,
      dragStartBehavior: this.dragStartBehavior,
      enableInteractiveSelection: this.enableInteractiveSelection,
      selectionControls: this.selectionControls,
      onTap: this.onTap,
      onTapOutside: this.onTapOutside,
      onPressUpOutside: this.onPressUpOutside,
      onTapAlwaysCalled: this.onTapAlwaysCalled,
      scrollController: this.scrollController,
      scrollPhysics: this.scrollPhysics,
      autofillHints: this.autofillHints,
      contentInsertionConfiguration: this.contentInsertionConfiguration,
      clipBehavior: this.clipBehavior,
      restorationId: this.restorationId,
      stylusHandwritingEnabled: this.stylusHandwritingEnabled,
      enableIMEPersonalizedLearning: this.enableIMEPersonalizedLearning,
      contextMenuBuilder: this.contextMenuBuilder,
      spellCheckConfiguration: this.spellCheckConfiguration,
      magnifierConfiguration: this.magnifierConfiguration,
      canRequestFocus: this.canRequestFocus,
      ignorePointers: this.ignorePointers,
      undoController: this.undoController,
      groupId: this.groupId,
      leading: this.leading,
      trailing: this.trailing,
      semanticLabel: this.semanticLabel,
      semanticHint: this.semanticHint,
      excludeSemantics: this.excludeSemantics,
    );
  }
}

/// The application's TextArea recipe.
///
/// The field's recipe with a taller resting box (at least 64px, 8px above and
/// below the text) and accessories pinned to the first line.
class PlaygroundTextArea extends StatelessWidget {
  const PlaygroundTextArea({
    super.key,
    this.style = const TextFieldStyler.create(),
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.helperText,
    this.error = false,
    this.keyboardType = TextInputType.multiline,
    this.textInputAction = TextInputAction.newline,
    this.textCapitalization = .none,
    this.textDirection,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines,
    this.minLines = 2,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.showCursor,
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

  final bool enabled;

  final bool readOnly;

  final bool autofocus;

  final int? maxLines;

  final int? minLines;

  final int? maxLength;

  final MaxLengthEnforcement? maxLengthEnforcement;

  final ValueChanged<String>? onChanged;

  final VoidCallback? onEditingComplete;

  final ValueChanged<String>? onSubmitted;

  final AppPrivateCommandCallback? onAppPrivateCommand;

  final List<TextInputFormatter>? inputFormatters;

  final bool? showCursor;

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
  Widget build(BuildContext context) {
    return RemixTextArea(
      key: this.key,
      style: playgroundTextAreaStyle(style: this.style),
      controller: this.controller,
      focusNode: this.focusNode,
      label: this.label,
      hintText: this.hintText,
      helperText: this.helperText,
      error: this.error,
      keyboardType: this.keyboardType,
      textInputAction: this.textInputAction,
      textCapitalization: this.textCapitalization,
      textDirection: this.textDirection,
      enabled: this.enabled,
      readOnly: this.readOnly,
      autofocus: this.autofocus,
      maxLines: this.maxLines,
      minLines: this.minLines,
      maxLength: this.maxLength,
      maxLengthEnforcement: this.maxLengthEnforcement,
      onChanged: this.onChanged,
      onEditingComplete: this.onEditingComplete,
      onSubmitted: this.onSubmitted,
      onAppPrivateCommand: this.onAppPrivateCommand,
      inputFormatters: this.inputFormatters,
      showCursor: this.showCursor,
      autocorrect: this.autocorrect,
      enableSuggestions: this.enableSuggestions,
      smartDashesType: this.smartDashesType,
      smartQuotesType: this.smartQuotesType,
      dragStartBehavior: this.dragStartBehavior,
      enableInteractiveSelection: this.enableInteractiveSelection,
      selectionControls: this.selectionControls,
      onTap: this.onTap,
      onTapOutside: this.onTapOutside,
      onPressUpOutside: this.onPressUpOutside,
      onTapAlwaysCalled: this.onTapAlwaysCalled,
      scrollController: this.scrollController,
      scrollPhysics: this.scrollPhysics,
      autofillHints: this.autofillHints,
      contentInsertionConfiguration: this.contentInsertionConfiguration,
      clipBehavior: this.clipBehavior,
      restorationId: this.restorationId,
      stylusHandwritingEnabled: this.stylusHandwritingEnabled,
      enableIMEPersonalizedLearning: this.enableIMEPersonalizedLearning,
      contextMenuBuilder: this.contextMenuBuilder,
      spellCheckConfiguration: this.spellCheckConfiguration,
      magnifierConfiguration: this.magnifierConfiguration,
      canRequestFocus: this.canRequestFocus,
      ignorePointers: this.ignorePointers,
      undoController: this.undoController,
      groupId: this.groupId,
      leading: this.leading,
      trailing: this.trailing,
      semanticLabel: this.semanticLabel,
      semanticHint: this.semanticHint,
      excludeSemantics: this.excludeSemantics,
    );
  }
}
