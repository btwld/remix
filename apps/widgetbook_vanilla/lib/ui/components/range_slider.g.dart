// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'range_slider.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's two-bound Slider recipe.
///
/// It is [vanillaSliderStyle]: the same rail, filled interval and thumb states
/// serve both thumbs. Pass [surfaceColor] on a card or tinted panel so the
/// thumb halos blend with it rather than the page.
///
/// Give each bound a distinct name in `semanticLabels`. The generated
/// `VanillaRangeSlider` omits `semanticFormatterCallbacks`, whose type comes
/// from `package:naked_ui`; use `RemixRangeSlider` for custom announcements.
class VanillaRangeSlider extends StatelessWidget {
  const VanillaRangeSlider({
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

  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    return RemixRangeSlider(
      key: this.key,
      style: vanillaRangeSliderStyle(
        surfaceColor: this.surfaceColor,
        style: this.style,
      ),
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
