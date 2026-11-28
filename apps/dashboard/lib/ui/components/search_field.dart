import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../motion/motion.dart';
import '../theme/theme.dart';
import 'icon_button.dart';
import 'text_field.dart';

/// The sizes a search field comes in: the text field's. Pixel values are at
/// 100% theme scaling.
enum UiSearchFieldSize {
  /// 32px tall.
  size1,

  /// 40px tall. The default.
  size2,

  /// 44px tall.
  size3,
}

/// The looks a search field comes in: the text field's.
enum UiSearchFieldVariant {
  /// The surface fill inside a 1px strong frame.
  surface,

  /// The muted surface fill with no frame until hovered or focused.
  soft,
}

/// A text field for a search: a leading search glyph, and a clear button once
/// there is something to clear.
///
/// The field is a [UiTextField] of the same [size] and [variant], so the
/// two share their height, frame and disabled look. [label] shows above the
/// field; [semanticLabel] names it either way. The 18px search glyph is muted
/// at rest and takes the text color while the field is focused or filled.
///
/// The clear button shows while the field is enabled, editable and not
/// empty. Its 24px circle sits in a slot the field always reserves at its
/// end, so the text never moves; the circle grows in from 0.8 out of a 2px
/// blur and shrinks back when the field empties. Its 40px target is inside
/// the field, and the text area always stops where that target starts. Pressing it clears the text, reports `onChanged('')` and
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
/// UiSearchField(semanticLabel: 'Search editions', controller: query)
/// ```
class UiSearchField extends StatelessWidget {
  const UiSearchField({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    required this.semanticLabel,
    this.label,
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

  /// The surface fill inside a 1px strong frame.
  const UiSearchField.surface({
    super.key,
    this.size = .size2,
    required this.semanticLabel,
    this.label,
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

  /// The muted surface fill with no frame until hovered or focused.
  const UiSearchField.soft({
    super.key,
    this.size = .size2,
    required this.semanticLabel,
    this.label,
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

  /// The visible label above the field, or none.
  final String? label;

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
    final target = UiTokens.touchTargetMin.resolve(context);
    final slot = UiTokens.space5.resolve(context);
    final inset =
        UiTokens.space3.resolve(context) +
        UiTokens.borderWidth1.resolve(context);
    // The clear target is centered on the slot, so the input stops where the
    // target starts once the gap before the slot is counted.
    final targetEnd = inset + slot / 2 - target / 2;
    final fieldHeight = switch (size) {
      .size1 => UiTokens.controlHeight1,
      .size2 => UiTokens.controlHeight2,
      .size3 => UiTokens.controlHeight3,
    }.resolve(context);

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
            size: switch (size) {
              .size1 => .size1,
              .size2 => .size2,
              .size3 => .size3,
            },
            controller: field.controller,
            focusNode: field.focusNode,
            label: label,
            hintText: hintText,
            semanticLabel: semanticLabel,
            enabled: field.enabled,
            readOnly: field.readOnly,
            autofocus: autofocus,
            textInputAction: textInputAction,
            onChanged: field.onChanged,
            onSubmitted: onSubmitted,
            leading: const StyledIcon(icon: RemixIcons.search),
            trailing: SizedBox(width: slot),
            style: _glass(
              filled: field.controller.text.isNotEmpty,
            ).merge(style),
          ),
          PositionedDirectional(
            // Without a label the field is the whole stack, which keeps the
            // button centered as text scaling grows the field.
            top: label == null ? 0 : null,
            bottom: 0,
            end: targetEnd,
            width: target,
            height: label == null ? null : fieldHeight,
            // Its own semantics node. Merged into the node around the field,
            // the button would make that node a button once there is text,
            // and on the web the browser then drops the input focus the
            // field's editor hangs from.
            child: UiSwap(
              motion: _clearMotion,
              alignment: AlignmentDirectional.center,
              child: field.clear == null
                  ? const SizedBox.shrink(key: ValueKey('empty'))
                  : Semantics(
                      key: const ValueKey('clear'),
                      container: true,
                      child: Center(
                        // Inside the field's tap region, so pressing it does
                        // not count as a tap outside the field.
                        child: TextFieldTapRegion(
                          child: ExcludeFocus(
                            child: UiIconButton.ghost(
                              icon: RemixIcons.close,
                              semanticLabel: clearSemanticLabel,
                              size: .size1,
                              onPressed: field.clear,
                              style: _clearStyle(),
                            ),
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

/// The search glyph: 18px, muted at rest and the text color while the field
/// is focused or [filled].
TextFieldStyler _glass({required bool filled}) {
  final glass = TextFieldStyler().wrap(.iconTheme(size: UiTokens.space18()));
  final awake = TextFieldStyler().wrap(.iconTheme(color: UiTokens.gray12()));

  return filled ? glass.merge(awake) : glass.onFocused(awake);
}

/// The clear button: a 24px circle with a 16px muted glyph that takes the
/// muted fill and the text color under the pointer, and presses in to 0.96.
IconButtonStyler _clearStyle() => IconButtonStyler()
    .padding(.all(UiTokens.space1()))
    .margin(.all(0))
    .borderRadius(.all(UiTokens.radiusCircle()))
    .icon(.size(UiTokens.space4()).color(UiTokens.gray10()))
    .onHovered(
      IconButtonStyler()
          .color(UiTokens.gray3())
          .icon(.color(UiTokens.gray12())),
    )
    .onPressed(IconButtonStyler().wrap(.scale(x: 0.96, y: 0.96)))
    .animate(
      AnimationConfig.curve(
        duration: UiMotion.fast,
        curve: UiMotion.easeStandard,
      ),
    );

/// The clear button grows in from 0.8 out of a 2px blur, its scale on the
/// snappy spring and its fade over 150ms, and leaves the same way in 100ms.
const _clearMotion = UiSwapMotion(
  enter: UiSwapPhase(
    visual: UiVisual(opacity: 0, scale: 0.8, blur: UiMotion.blurSubtle),
    timing: UiVisualTiming(
      opacity: UiTiming.fade,
      transform: UiTiming.snappy,
      blur: UiTiming.fade,
    ),
  ),
  exit: UiSwapPhase(
    visual: UiVisual(opacity: 0, scale: 0.8, blur: UiMotion.blurSubtle),
    timing: UiVisualTiming.all(UiTiming.instant),
  ),
);
