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
enum UiSearchFieldSize {
  /// 24px tall, with 12px text and a 12px clear glyph.
  size1,

  /// 32px tall, with 14px text and a 12px clear glyph. The default.
  size2,

  /// 40px tall, with 16px text and a 16px clear glyph.
  size3,
}

/// The looks a search field comes in: the text field's.
enum UiSearchFieldVariant {
  /// The `gray2` fill inside a 1px neutral frame, with neutral text.
  surface,

  /// An accent tint inside a 1px accent ring, with accent-colored text.
  soft,
}

/// A text field for a search: a leading search glyph, and a clear button once
/// there is something to clear.
///
/// The field is a [UiTextField] of the same [size] and [variant], so the
/// two share their height, frame, focus ring and disabled look. It has no
/// label or helper text: [semanticLabel] names it.
///
/// The clear button shows while the field is enabled, editable and not
/// empty. It sits over the field's end, centered in the last 40px so its
/// whole 40px target is inside the field, and the text area always stops
/// where that target starts. Pressing it clears the text, reports `onChanged('')` and
/// [onCleared], and returns focus to the field. It is its own semantics node
/// and takes no Tab stop: Escape clears from the keyboard, its repeats
/// included. A press that starts during editable composition stays with the
/// input method through release. A fresh Escape in a read-only or empty field
/// passes on, to close a dialog for example.
///
/// The field creates its own controller and focus node when none are given.
/// When a caller's controller is withdrawn, the owned one starts from its
/// last value.
///
/// ```dart
/// UiSearchField(semanticLabel: 'Search editions', controller: query)
/// ```
class UiSearchField extends StatelessWidget {
  const UiSearchField({
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
  const UiSearchField.surface({
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
  }) : variant = UiSearchFieldVariant.surface,
       assert(semanticLabel != ''),
       assert(clearSemanticLabel != '');

  /// An accent tint inside a 1px accent ring, with accent-colored text.
  const UiSearchField.soft({
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
  }) : variant = UiSearchFieldVariant.soft,
       assert(semanticLabel != ''),
       assert(clearSemanticLabel != '');

  final UiSearchFieldVariant variant;
  final UiSearchFieldSize size;

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
        UiTextFieldSize.size1,
        UiIconButtonSize.size1,
        UiTokens.space2,
        UiTokens.space2,
        UiTokens.space3,
      ),
      .size2 => (
        UiTextFieldSize.size2,
        UiIconButtonSize.size1,
        UiTokens.space2,
        UiTokens.space2,
        UiTokens.space3,
      ),
      .size3 => (
        UiTextFieldSize.size3,
        UiIconButtonSize.size2,
        UiTokens.space3,
        UiTokens.space3,
        UiTokens.space4,
      ),
    };
    final target = UiTokens.touchTargetMin.resolve(context);
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
          UiTextField(
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
            // Always present at the clear button's width, so the text area
            // keeps one width and the field one structure as text comes and
            // goes.
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
                      child: UiIconButton.ghost(
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
IconButtonStyler _clearStyle(UiSearchFieldVariant variant) => switch (variant) {
  .surface =>
    IconButtonStyler()
        .icon(.color(UiTokens.gray11()))
        .onHovered(.color(UiTokens.grayA3()))
        .onPressed(.color(UiTokens.grayA4())),
  .soft => IconButtonStyler().icon(.color(UiTokens.accentContent())),
};
