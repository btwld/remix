import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../theme/theme.dart';
import 'icon_button.dart';
import 'text_field.dart';

/// The sizes a search field comes in: the text field's. Pixel values are at
/// 100% theme scaling.
enum FortalSearchFieldSize {
  /// 24px tall, with 12px text and a 12px clear glyph.
  size1,

  /// 32px tall, with 14px text and a 12px clear glyph. The default.
  size2,

  /// 40px tall, with 16px text and a 16px clear glyph.
  size3,
}

/// The looks a search field comes in: the text field's.
enum FortalSearchFieldVariant {
  /// The `gray2` fill inside a 1px neutral frame, with neutral text.
  surface,

  /// An accent tint inside a 1px accent ring, with accent-colored text.
  soft,
}

/// A text field for a search: a leading search glyph, and a clear button once
/// there is something to clear.
///
/// The field is a [FortalTextField] of the same [size] and [variant], so the
/// two share their height, frame, focus ring and disabled look. It has no
/// label or helper text: [semanticLabel] names it.
///
/// The clear button shows while the field is enabled, editable and not
/// empty. It sits over the field's end, centered in the last 40px so its
/// whole 40px target is inside the field, and the text area always stops
/// where that target starts. Pressing it clears the text, reports `onChanged('')` and
/// [onCleared], and returns focus to the field. It is its own semantics node
/// and takes no Tab stop. Escape clears an editable, nonempty field and
/// consumes that press through release. A press that starts during active
/// composition in an editable field stays with the input method through
/// release. A fresh Escape in a read-only or empty field can dismiss an
/// enclosing dialog.
///
/// The field creates its own controller and focus node when none are given.
/// When a caller's controller is withdrawn, the owned one starts from its
/// last value.
///
/// ```dart
/// FortalSearchField(semanticLabel: 'Search editions', controller: query)
/// ```
class FortalSearchField extends StatelessWidget {
  const FortalSearchField({
    super.key,
    this.variant = .surface,
    this.size = .size2,
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
    this.textInputAction = .search,
    this.style = const TextFieldStyler.create(),
  }) : assert(semanticLabel != ''),
       assert(clearSemanticLabel != '');

  /// The `gray2` fill inside a 1px neutral frame, with neutral text.
  const FortalSearchField.surface({
    super.key,
    this.size = .size2,
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
    this.textInputAction = .search,
    this.style = const TextFieldStyler.create(),
  }) : variant = FortalSearchFieldVariant.surface,
       assert(semanticLabel != ''),
       assert(clearSemanticLabel != '');

  /// An accent tint inside a 1px accent ring, with accent-colored text.
  const FortalSearchField.soft({
    super.key,
    this.size = .size2,
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
    this.textInputAction = .search,
    this.style = const TextFieldStyler.create(),
  }) : variant = FortalSearchFieldVariant.soft,
       assert(semanticLabel != ''),
       assert(clearSemanticLabel != '');

  final FortalSearchFieldVariant variant;
  final FortalSearchFieldSize size;

  /// The field's accessible name.
  final String semanticLabel;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Called after the clear button or Escape empties the field.
  final VoidCallback? onCleared;

  /// The clear button's accessible name.
  final String clearSemanticLabel;

  final TextInputAction textInputAction;

  /// Merged last into the field's style.
  final TextFieldStyler style;

  @override
  Widget build(BuildContext context) {
    // The field's own end padding and the spacing before a trailing widget,
    // as the text field sets them for each size.
    final (fieldSize, buttonSize, paddingX, spacing, glyph) = switch (size) {
      .size1 => (
        FortalTextFieldSize.size1,
        FortalIconButtonSize.size1,
        FortalTokens.space2,
        FortalTokens.space2,
        FortalTokens.space3,
      ),
      .size2 => (
        FortalTextFieldSize.size2,
        FortalIconButtonSize.size1,
        FortalTokens.space2,
        FortalTokens.space2,
        FortalTokens.space3,
      ),
      .size3 => (
        FortalTextFieldSize.size3,
        FortalIconButtonSize.size2,
        FortalTokens.space3,
        FortalTokens.space3,
        FortalTokens.space4,
      ),
    };
    final target = FortalTokens.touchTargetMin.resolve(context);
    final inset = paddingX.resolve(context) + spacing.resolve(context);
    // The input stops where the clear button's target starts, so a tap on
    // the text never clears it, and at least one spacing step short of the
    // glyph, as it would beside a trailing icon of that size.
    final reserved = math.max(
      target - inset,
      target / 2 + glyph.resolve(context) / 2 - paddingX.resolve(context),
    );

    return NakedSearchField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      onChanged: onChanged,
      onCleared: onCleared,
      builder: (context, field) => Stack(
        fit: .passthrough,
        children: [
          FortalTextField(
            variant: switch (variant) {
              .surface => .surface,
              .soft => .soft,
            },
            size: fieldSize,
            controller: field.controller,
            focusNode: field.focusNode,
            hintText: hintText,
            semanticLabel: semanticLabel,
            enabled: field.enabled,
            readOnly: field.readOnly,
            autofocus: autofocus,
            textInputAction: textInputAction,
            onChanged: field.onChanged,
            onSubmitted: onSubmitted,
            leading: const StyledIcon(icon: RemixIcons.search),
            trailing: SizedBox(width: reserved),
            style: style,
          ),
          if (field.clear != null)
            PositionedDirectional(
              top: 0,
              bottom: 0,
              end: 0,
              width: target,
              // Its own semantics node. Merged into the node around the
              // field, the button would make that node a button once there
              // is text, and on the web the browser then drops the input
              // focus the field's editor hangs from.
              child: Semantics(
                container: true,
                child: Center(
                  // Inside the field's tap region, so pressing it does not
                  // count as a tap outside the field.
                  child: TextFieldTapRegion(
                    child: ExcludeFocus(
                      child: FortalIconButton.ghost(
                        icon: RemixIcons.close,
                        semanticLabel: clearSemanticLabel,
                        size: buttonSize,
                        onPressed: field.clear,
                        style: _clearStyle(variant),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The clear button takes the field's icon color: gray on a surface field,
/// with a gray tint under the pointer, and the accent on a soft one.
IconButtonStyler _clearStyle(FortalSearchFieldVariant variant) =>
    switch (variant) {
      .surface =>
        IconButtonStyler()
            .icon(.color(FortalTokens.gray11()))
            .onHovered(.color(FortalTokens.grayA3()))
            .onPressed(.color(FortalTokens.grayA4())),
      .soft => IconButtonStyler().icon(.color(FortalTokens.accentContent())),
    };
