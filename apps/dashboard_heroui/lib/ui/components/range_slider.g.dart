// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'range_slider.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Two-bound interval sharing [uiSliderStyle]'s pill track and thumbs.
/// Remix owns independent thumb interaction, RTL, spacing and announcements.
/// Give each bound a distinct localized name with `semanticLabels`.
class UiRangeSlider extends StatelessWidget {
  const UiRangeSlider({
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
    this.semanticFormatterCallbacks,
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

  final List<NakedSliderSemanticFormatterCallback?>? semanticFormatterCallbacks;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext _) {
    return RemixRangeSlider(
      style: uiRangeSliderStyle(style: style),
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
