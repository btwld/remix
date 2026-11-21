// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'range_slider.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's two-bound Slider recipe.
///
/// It is [playgroundSliderStyle]: the same rail, filled interval and thumb states
/// serve both thumbs. Pass [surfaceColor] on a card or tinted panel so the
/// thumb halos blend with it rather than the page.
///
/// Give each bound a distinct name in `semanticLabels`.
class PlaygroundRangeSlider extends StatelessWidget {
  const PlaygroundRangeSlider({
    super.key,
    this.surfaceColor,
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
    this.semanticFormatterCallbacks,
    this.excludeSemantics = false,
  });

  final Color? surfaceColor;

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

  final List<NakedSliderSemanticFormatterCallback?>? semanticFormatterCallbacks;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext _) {
    return RemixRangeSlider(
      style: playgroundRangeSliderStyle(
        surfaceColor: surfaceColor,
        style: style,
      ),
      values: values,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      min: min,
      max: max,
      minSpacing: minSpacing,
      snapDivisions: snapDivisions,
      enabled: enabled,
      enableFeedback: enableFeedback,
      focusNodes: focusNodes,
      autofocusThumbIndex: autofocusThumbIndex,
      semanticLabels: semanticLabels,
      semanticFormatterCallbacks: semanticFormatterCallbacks,
      excludeSemantics: excludeSemantics,
    );
  }
}
