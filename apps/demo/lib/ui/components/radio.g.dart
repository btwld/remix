// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Radio recipe.
///
/// It reads top to bottom: the circle and its focus ring, then the variant's
/// colors for rest, selected and disabled, then the touch target.
///
/// [highContrast] moves the selected fill (surface) or dot (soft) to accent
/// step 12.
class FortalRadio<T> extends StatelessWidget {
  const FortalRadio({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    this.highContrast = false,
    this.style = const RadioStyler.create(),
    required this.value,
    this.label,
    this.semanticLabel,
    this.minimumTapTargetSize = Size.zero,
    this.enabled = true,
    this.toggleable = false,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.excludeSemantics = false,
  });

  /// A surface fill inside a 1px neutral frame, filled with the accent when
  /// selected.
  const FortalRadio.surface({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const RadioStyler.create(),
    required this.value,
    this.label,
    this.semanticLabel,
    this.minimumTapTargetSize = Size.zero,
    this.enabled = true,
    this.toggleable = false,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.excludeSemantics = false,
  }) : variant = FortalRadioVariant.surface;

  /// An accent tint inside a 1px accent ring, with an accent-colored dot.
  const FortalRadio.soft({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const RadioStyler.create(),
    required this.value,
    this.label,
    this.semanticLabel,
    this.minimumTapTargetSize = Size.zero,
    this.enabled = true,
    this.toggleable = false,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.excludeSemantics = false,
  }) : variant = FortalRadioVariant.soft;

  final FortalRadioVariant variant;

  final FortalRadioSize size;

  final bool highContrast;

  final RadioStyler style;

  final T value;

  final String? label;

  final String? semanticLabel;

  final Size minimumTapTargetSize;

  final bool enabled;

  final bool toggleable;

  final MouseCursor? mouseCursor;

  final FocusNode? focusNode;

  final bool autofocus;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    return RemixRadio<T>(
      key: this.key,
      style: fortalRadioStyle(
        variant: this.variant,
        size: this.size,
        highContrast: this.highContrast,
        style: this.style,
      ),
      value: this.value,
      label: this.label,
      semanticLabel: this.semanticLabel,
      minimumTapTargetSize: this.minimumTapTargetSize,
      enabled: this.enabled,
      toggleable: this.toggleable,
      mouseCursor: this.mouseCursor,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      excludeSemantics: this.excludeSemantics,
    );
  }
}
