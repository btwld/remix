// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slider.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Slider recipe.
///
/// A pill-shaped rail (`mutedForeground`, `ring` in the dark theme) with a
/// `primary` range and a white thumb in both themes, outlined in `primary`
/// (`primaryForeground` in the dark theme) so overlapping handles stay
/// distinct. Both slider recipes reserve a 48px interaction height.
///
/// Set [surfaceColor] to the enclosing surface on cards or tinted panels (for
/// example `PlaygroundTokens.card.resolve(context)`); the hover and press halos
/// are opaque and blend against it, defaulting to the page background.
///
/// The generated widget omits `semanticFormatterCallback`: its type comes from
/// `package:naked_ui`, which this layer does not import. Use `RemixSlider` to
/// reword the announced value.
class PlaygroundSlider extends StatelessWidget {
  const PlaygroundSlider({
    super.key,
    this.surfaceColor,
    this.style = const SliderStyler.create(),
    required this.value,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.enabled = true,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.snapDivisions,
    this.semanticLabel,
    this.excludeSemantics = false,
  });

  final Color? surfaceColor;

  final SliderStyler style;

  final double value;

  final ValueChanged<double>? onChanged;

  final ValueChanged<double>? onChangeStart;

  final ValueChanged<double>? onChangeEnd;

  final double min;

  final double max;

  final bool enabled;

  final bool enableFeedback;

  final FocusNode? focusNode;

  final bool autofocus;

  final int? snapDivisions;

  final String? semanticLabel;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    return RemixSlider(
      key: this.key,
      style: playgroundSliderStyle(
        surfaceColor: this.surfaceColor,
        style: this.style,
      ),
      value: this.value,
      onChanged: this.onChanged,
      onChangeStart: this.onChangeStart,
      onChangeEnd: this.onChangeEnd,
      min: this.min,
      max: this.max,
      enabled: this.enabled,
      enableFeedback: this.enableFeedback,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      snapDivisions: this.snapDivisions,
      semanticLabel: this.semanticLabel,
      excludeSemantics: this.excludeSemantics,
    );
  }
}
