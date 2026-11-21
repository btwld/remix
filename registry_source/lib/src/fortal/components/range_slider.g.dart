// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'range_slider.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Two-bound slider sharing [fortalSliderStyle]'s variants, sizes and states.
/// Each thumb keeps independent hover, press and visible keyboard focus.
/// Supply distinct localized `semanticLabels`.
class FortalRangeSlider extends StatelessWidget {
  const FortalRangeSlider({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    this.highContrast = false,
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

  /// A gray track and a solid accent range.
  const FortalRangeSlider.surface({
    super.key,
    this.size = .size2,
    this.highContrast = false,
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
  }) : variant = FortalSliderVariant.surface;

  /// A gray track and a softer accent range.
  const FortalRangeSlider.soft({
    super.key,
    this.size = .size2,
    this.highContrast = false,
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
  }) : variant = FortalSliderVariant.soft;

  final FortalSliderVariant variant;

  final FortalSliderSize size;

  final bool highContrast;

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
      style: fortalRangeSliderStyle(
        variant: variant,
        size: size,
        highContrast: highContrast,
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
