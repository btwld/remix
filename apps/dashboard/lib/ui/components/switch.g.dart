// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switch.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Switch recipe.
///
/// It reads top to bottom: the pill track and its shadowed thumb, then the
/// variant's on colours, then the press stretch, disabled and the focus ring.
/// The thumb glides on the smooth spring and stretches 5px while held, its
/// near edge staying put.
///
/// [highContrast] moves the on track to accent step 12.
class UiSwitch extends StatelessWidget {
  const UiSwitch({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    this.highContrast = false,
    this.style = const SwitchStyler.create(),
    required this.selected,
    this.label,
    this.semanticLabel,
    this.minimumTapTargetSize = Size.zero,
    this.onChanged,
    this.enabled = true,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  });

  /// A neutral track that darkens on hover and fills with the control ink
  /// when on, under a shadowed light thumb.
  const UiSwitch.surface({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const SwitchStyler.create(),
    required this.selected,
    this.label,
    this.semanticLabel,
    this.minimumTapTargetSize = Size.zero,
    this.onChanged,
    this.enabled = true,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = UiSwitchVariant.surface;

  /// The surface track while off; on, a 10% control-ink tint with a
  /// control-ink thumb.
  const UiSwitch.soft({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const SwitchStyler.create(),
    required this.selected,
    this.label,
    this.semanticLabel,
    this.minimumTapTargetSize = Size.zero,
    this.onChanged,
    this.enabled = true,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = UiSwitchVariant.soft;

  final UiSwitchVariant variant;

  final UiSwitchSize size;

  final bool highContrast;

  final SwitchStyler style;

  final bool selected;

  final String? label;

  final String? semanticLabel;

  final Size minimumTapTargetSize;

  final ValueChanged<bool>? onChanged;

  final bool enabled;

  final bool enableFeedback;

  final FocusNode? focusNode;

  final bool autofocus;

  final bool excludeSemantics;

  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext _) {
    return RemixSwitch(
      style: uiSwitchStyle(
        variant: variant,
        size: size,
        highContrast: highContrast,
        style: style,
      ),
      selected: selected,
      label: label,
      semanticLabel: semanticLabel,
      minimumTapTargetSize: minimumTapTargetSize,
      onChanged: onChanged,
      enabled: enabled,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      autofocus: autofocus,
      excludeSemantics: excludeSemantics,
      mouseCursor: mouseCursor,
    );
  }
}
