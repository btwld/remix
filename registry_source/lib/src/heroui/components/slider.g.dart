// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slider.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixSlider]: a pill track and fill with a ringed thumb.
///
/// The label and value output beside the track are the app's composition.
class HeroUiSlider extends StatelessWidget {
  const HeroUiSlider({
    super.key,
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
    this.semanticFormatterCallback,
    this.excludeSemantics = false,
  });

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

  final NakedSliderSemanticFormatterCallback? semanticFormatterCallback;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext _) {
    return RemixSlider(
      style: heroUiSliderStyle(style: style),
      value: value,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      min: min,
      max: max,
      enabled: enabled,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      autofocus: autofocus,
      snapDivisions: snapDivisions,
      semanticLabel: semanticLabel,
      semanticFormatterCallback: semanticFormatterCallback,
      excludeSemantics: excludeSemantics,
    );
  }
}
