import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../theme/tokens.dart';
import 'icon_button.dart';
import 'textfield.dart';

/// The application's SearchField: a text field for a query, with a search
/// icon at the start and a clear button at the end.
///
/// A composition of [VanillaTextField] and [VanillaIconButton] in the shape
/// of shadcn/ui's Input Group with a search addon and an `InputGroupButton`.
/// The field keeps the TextField recipe's 36px height, border, focus ring,
/// and disabled treatment. The icon sits 12px in and 8px before the text in
/// the field's muted accessory color. The clear button, a 24px ghost
/// square 4px from the end, shows only while the field is enabled, editable,
/// and not empty.
///
/// Clearing, by the button or by Escape, empties the text, reports `''` to
/// [onChanged], calls [onCleared], and keeps focus in the field. Escape clears
/// when there is text, and the key repeats of that press are spent on it, so
/// holding Escape does not go on to close an enclosing dialog. A press that
/// starts during editable composition stays with the input method through
/// release. A fresh Escape in a read-only or empty field passes up, so an
/// enclosing dialog can close.
///
/// ```dart
/// VanillaSearchField(
///   semanticLabel: 'Search customers',
///   hintText: 'Search customers…',
///   onChanged: (query) => setState(() => this.query = query),
/// )
/// ```
class VanillaSearchField extends StatelessWidget {
  const VanillaSearchField({
    super.key,
    required this.semanticLabel,
    this.controller,
    this.focusNode,
    this.hintText,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onCleared,
    this.clearSemanticLabel = 'Clear search',
    this.textInputAction = TextInputAction.search,
    this.style = const TextFieldStyler.create(),
  });

  /// Names the field for assistive technology; a search field rarely has a
  /// visible label.
  final String semanticLabel;

  /// The query text. The field creates and disposes its own when null.
  final TextEditingController? controller;

  /// The field's focus. The field creates and disposes its own when null.
  final FocusNode? focusNode;

  /// The placeholder shown while the field is empty.
  final String? hintText;

  /// Whether the field accepts input. A disabled field fades and shows no
  /// clear button.
  final bool enabled;

  /// Whether the text can be selected but not changed. A read-only field
  /// shows no clear button and ignores Escape.
  final bool readOnly;

  /// Whether the field takes focus when first built.
  final bool autofocus;

  /// Called with the text after each edit, and with `''` after a clear.
  final ValueChanged<String>? onChanged;

  /// Called with the text when the keyboard's search action is submitted.
  final ValueChanged<String>? onSubmitted;

  /// Called after the clear button or Escape empties the field.
  final VoidCallback? onCleared;

  /// Names the clear button for assistive technology.
  final String clearSemanticLabel;

  /// The keyboard's action button.
  final TextInputAction textInputAction;

  /// Merged last into the field's style.
  final TextFieldStyler style;

  @override
  Widget build(BuildContext context) => NakedSearchField(
    controller: controller,
    focusNode: focusNode,
    enabled: enabled,
    readOnly: readOnly,
    onChanged: onChanged,
    onCleared: onCleared,
    builder: (context, field) => VanillaTextField(
      controller: field.controller,
      focusNode: field.focusNode,
      hintText: hintText,
      enabled: field.enabled,
      readOnly: field.readOnly,
      autofocus: autofocus,
      textInputAction: textInputAction,
      onChanged: field.onChanged,
      onSubmitted: onSubmitted,
      semanticLabel: semanticLabel,
      style: _fieldStyle(Directionality.of(context)).merge(style),
      // In the recipe's accessory icon theme: `mutedForeground`, 16px.
      leading: const ExcludeSemantics(
        child: StyledIcon(icon: RemixIcons.search),
      ),
      // Always present, so the 8px gap before it plus the 4px end inset
      // make the 12px text inset the field has without the button.
      trailing: field.clear != null
          // Its own semantics node: a button's semantics are not a
          // container, so it would otherwise merge into whatever node
          // encloses the field.
          ? Semantics(
              container: true,
              child: VanillaIconButton.ghost(
                size: .small,
                icon: RemixIcons.close,
                semanticLabel: clearSemanticLabel,
                onPressed: field.clear,
                style: _clearButtonStyle(),
              ),
            )
          : const SizedBox.shrink(),
    ),
  );
}

/// The Input Group's insets over the TextField recipe: 12px before the search
/// icon, as the addon's `pl-3`, and 4px after the trailing slot, where the
/// addon's `pr-3` and the button's `-mr-[0.45rem]` leave the clear button.
///
/// Resolved to left and right for [direction]: the recipe's padding is not
/// directional, and Mix cannot merge directional insets into it.
TextFieldStyler _fieldStyle(TextDirection direction) {
  final (left, right) = switch (direction) {
    .ltr => (VanillaTokens.s3, VanillaTokens.s1),
    .rtl => (VanillaTokens.s1, VanillaTokens.s3),
  };

  return TextFieldStyler().padding(.only(left: left, right: right));
}

/// `InputGroupButton` at `size="icon-xs"` over the small ghost icon button: a
/// 24px square with the small radius, its glyph in the addon's
/// `mutedForeground` until the pointer brings the ghost hover.
IconButtonStyler _clearButtonStyle() => IconButtonStyler()
    .size(VanillaTokens.s6, VanillaTokens.s6)
    .borderRadius(.all(VanillaTokens.radiusSm()))
    .icon(.color(VanillaTokens.mutedForeground()));
