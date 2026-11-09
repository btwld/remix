// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'range_slider.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Two-bound interval sharing [heroUiSliderStyle]'s pill track and thumbs.
/// Remix owns independent thumb interaction, RTL, spacing and announcements.
/// Give each bound a distinct localized name with `semanticLabels`.
/// Custom formatters use [RemixRangeSlider] with this recipe.
class HeroUiRangeSlider extends StatelessWidget {
  const HeroUiRangeSlider({
    super.key,
    this.style = const SliderStyler.create(),
    required this.values,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0,
    this.max = 1,
    this.minSpacing = 0,
    this.snapDivisions,
    this.enabled = true,
    this.enableFeedback = true,
    this.focusNodes,
    this.autofocusThumbIndex,
    this.semanticLabels,
    this.excludeSemantics = false,
  });

  final SliderStyler style;

  final List<double> values;

  final ValueChanged<List<double>>? onChanged;

  final ValueChanged<List<double>>? onChangeStart;

  final ValueChanged<List<double>>? onChangeEnd;

  final double min;

  final double max;

  final double minSpacing;

  final int? snapDivisions;

  final bool enabled;

  final bool enableFeedback;

  final List<FocusNode?>? focusNodes;

  final int? autofocusThumbIndex;

  final List<String?>? semanticLabels;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    return RemixRangeSlider(
      key: this.key,
      style: heroUiRangeSliderStyle(style: this.style),
      values: this.values,
      onChanged: this.onChanged,
      onChangeStart: this.onChangeStart,
      onChangeEnd: this.onChangeEnd,
      min: this.min,
      max: this.max,
      minSpacing: this.minSpacing,
      snapDivisions: this.snapDivisions,
      enabled: this.enabled,
      enableFeedback: this.enableFeedback,
      focusNodes: this.focusNodes,
      autofocusThumbIndex: this.autofocusThumbIndex,
      semanticLabels: this.semanticLabels,
      excludeSemantics: this.excludeSemantics,
    );
  }
}
