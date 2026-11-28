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
class UiRadio<T> extends StatelessWidget {
  const UiRadio({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    this.highContrast = false,
    this.style = const RadioStyler.create(),
    required this.value,
    this.label,
    this.description,
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
  const UiRadio.surface({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const RadioStyler.create(),
    required this.value,
    this.label,
    this.description,
    this.semanticLabel,
    this.minimumTapTargetSize = Size.zero,
    this.enabled = true,
    this.toggleable = false,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.excludeSemantics = false,
  }) : variant = UiRadioVariant.surface;

  /// An accent tint inside a 1px accent ring, with an accent-colored dot.
  const UiRadio.soft({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const RadioStyler.create(),
    required this.value,
    this.label,
    this.description,
    this.semanticLabel,
    this.minimumTapTargetSize = Size.zero,
    this.enabled = true,
    this.toggleable = false,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.excludeSemantics = false,
  }) : variant = UiRadioVariant.soft;

  final UiRadioVariant variant;

  final UiRadioSize size;

  final bool highContrast;

  final RadioStyler style;

  final T value;

  final String? label;

  final String? description;

  final String? semanticLabel;

  final Size minimumTapTargetSize;

  final bool enabled;

  final bool toggleable;

  final MouseCursor? mouseCursor;

  final FocusNode? focusNode;

  final bool autofocus;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext _) {
    return RemixRadio<T>(
      style: uiRadioStyle(
        variant: variant,
        size: size,
        highContrast: highContrast,
        style: style,
      ),
      value: value,
      label: label,
      description: description,
      semanticLabel: semanticLabel,
      minimumTapTargetSize: minimumTapTargetSize,
      enabled: enabled,
      toggleable: toggleable,
      mouseCursor: mouseCursor,
      focusNode: focusNode,
      autofocus: autofocus,
      excludeSemantics: excludeSemantics,
    );
  }
}
