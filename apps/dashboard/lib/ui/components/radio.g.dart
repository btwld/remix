// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Radio recipe.
///
/// It reads top to bottom: the circle and its dot, then the variant's colors,
/// then the label, press, disabled and the focus ring. The dot stays mounted
/// so it grows in from 40% and fades out when another radio is chosen; a
/// pressed empty radio previews it at 22%.
///
/// [highContrast] moves the selected fill (surface, card) or dot (soft) to
/// accent step 12.
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

  /// An empty circle in a 1px strong frame; selected, a control-ink disc
  /// with a glyph-coloured dot.
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

  /// The surface circle at rest; selected, a 10% control-ink tint inside a
  /// control-ink frame, with a control-ink dot.
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

  /// The surface circle inside a 1px framed card row with 12px padding that
  /// fills on hover and takes a control-ink frame and a 5% tint when
  /// selected. Use it with a label, and a description under it.
  const UiRadio.card({
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
  }) : variant = UiRadioVariant.card;

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
