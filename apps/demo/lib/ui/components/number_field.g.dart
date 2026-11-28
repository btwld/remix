// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'number_field.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Number Field recipe: a rounded shell with a minus step, the
/// value centered in medium tabular figures, and a plus step.
///
/// It reads top to bottom: the column, the label and helper text, the shell
/// at rest, hovered, focused and disabled, the editor, both steps, then the
/// size.
///
/// The shell draws no focus ring: focus darkens its border to the text
/// color. The steps are quiet glyphs that gain a muted fill on hover and a
/// stronger one, with the glyph pressed in, while held. A step at its bound
/// fades.
///
/// [highContrast] moves the resting border to the control border and the
/// helper text to gray step 11. The theme's high contrast switch moves the
/// border too.
class FortalNumberField extends StatelessWidget {
  const FortalNumberField({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const NumberFieldStyler.create(),
    required this.value,
    this.onChanged,
    this.min = double.negativeInfinity,
    this.max = double.infinity,
    this.step = 1,
    this.largeStep,
    this.format,
    this.parse,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.error = false,
    this.label,
    this.hintText,
    this.helperText,
    this.semanticLabel,
    this.semanticHint,
    this.incrementSemanticLabel = 'Increase',
    this.decrementSemanticLabel = 'Decrease',
    this.incrementIcon,
    this.decrementIcon,
    this.textInputAction = TextInputAction.done,
  });

  final FortalNumberFieldSize size;

  final bool highContrast;

  final NumberFieldStyler style;

  final double? value;

  final ValueChanged<double?>? onChanged;

  final double min;

  final double max;

  final double step;

  final double? largeStep;

  final String Function(double value)? format;

  final double? Function(String text)? parse;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool enabled;

  final bool readOnly;

  final bool autofocus;

  final bool error;

  final String? label;

  final String? hintText;

  final String? helperText;

  final String? semanticLabel;

  final String? semanticHint;

  final String incrementSemanticLabel;

  final String decrementSemanticLabel;

  final IconData? incrementIcon;

  final IconData? decrementIcon;

  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext _) {
    return RemixNumberField(
      style: fortalNumberFieldStyle(
        size: size,
        highContrast: highContrast,
        style: style,
      ),
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
      step: step,
      largeStep: largeStep,
      format: format,
      parse: parse,
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      error: error,
      label: label,
      hintText: hintText,
      helperText: helperText,
      semanticLabel: semanticLabel,
      semanticHint: semanticHint,
      incrementSemanticLabel: incrementSemanticLabel,
      decrementSemanticLabel: decrementSemanticLabel,
      incrementIcon: incrementIcon,
      decrementIcon: decrementIcon,
      textInputAction: textInputAction,
    );
  }
}
