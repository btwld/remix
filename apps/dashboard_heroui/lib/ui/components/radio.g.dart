// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixRadio].
///
/// The label sits inside the control's tap target. A description beneath it is
/// `UiRadioGroup`'s. [invalid] paints the error treatment and turns the
/// label danger; validation stays with the app.
class UiRadio<T> extends StatelessWidget {
  const UiRadio({
    super.key,
    this.variant = .primary,
    this.invalid = false,
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

  /// The field surface fill, with its shadow.
  const UiRadio.primary({
    super.key,
    this.invalid = false,
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
  }) : variant = UiRadioVariant.primary;

  /// The `default` fill.
  const UiRadio.secondary({
    super.key,
    this.invalid = false,
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
  }) : variant = UiRadioVariant.secondary;

  final UiRadioVariant variant;

  final bool invalid;

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
      style: uiRadioStyle(variant: variant, invalid: invalid, style: style),
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
