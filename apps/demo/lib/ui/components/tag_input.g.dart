// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_input.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal tag input recipe: a 44px shell of wrapping tags and an inline
/// editor, with a label above and helper text below.
///
/// The shell edge is `gray7` at rest, `gray8` under the pointer and `gray12`
/// while the editor has focus. Tags are 28px pills on `gray3` with a 1px
/// `gray7` edge. A picked tag takes an `accent9` edge over an `accentA3`
/// tint, and its remove glyph darkens to `gray12`. The remove button is a
/// 22px circle that fills with `gray2` under the pointer.
///
/// [highContrast] moves the resting shell and tag edges to `gray8`, which
/// holds 3:1 against the page.
class FortalTagInput extends StatelessWidget {
  const FortalTagInput({
    super.key,
    this.highContrast = false,
    this.style = const TagInputStyler.create(),
    required this.value,
    this.onChanged,
    this.onDuplicate,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.helperText,
    this.error = false,
    this.separators = const [','],
    this.duplicates = NakedTagInputDuplicates.rejectIgnoringCase,
    this.maxTags,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.textInputAction,
    this.semanticLabel,
    this.messages = const NakedTagInputMessages(),
    this.removeLabelBuilder,
  });

  final bool highContrast;

  final TagInputStyler style;

  final List<String> value;

  final ValueChanged<List<String>>? onChanged;

  final ValueChanged<int>? onDuplicate;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final String? label;

  final String? hintText;

  final String? helperText;

  final bool error;

  final List<String> separators;

  final NakedTagInputDuplicates duplicates;

  final int? maxTags;

  final bool enabled;

  final bool readOnly;

  final bool autofocus;

  final TextInputAction? textInputAction;

  final String? semanticLabel;

  final NakedTagInputMessages messages;

  final String Function(String tag)? removeLabelBuilder;

  @override
  Widget build(BuildContext _) {
    return RemixTagInput(
      style: fortalTagInputStyle(highContrast: highContrast, style: style),
      value: value,
      onChanged: onChanged,
      onDuplicate: onDuplicate,
      controller: controller,
      focusNode: focusNode,
      label: label,
      hintText: hintText,
      helperText: helperText,
      error: error,
      separators: separators,
      duplicates: duplicates,
      maxTags: maxTags,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      textInputAction: textInputAction,
      semanticLabel: semanticLabel,
      messages: messages,
      removeLabelBuilder: removeLabelBuilder,
    );
  }
}
