// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slider.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Ui Slider recipe.
///
/// It reads top to bottom: the track and thumb sizes, then the variant's
/// colors, then the dark-mode thumb edge, hover, press and disabled.
///
/// [highContrast] darkens the range with an overlay.
class UiSlider extends StatelessWidget {
  const UiSlider({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    this.highContrast = false,
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

  /// A gray track and a solid accent range.
  const UiSlider.surface({
    super.key,
    this.size = .size2,
    this.highContrast = false,
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
  }) : variant = UiSliderVariant.surface;

  /// A gray track and a softer accent range.
  const UiSlider.soft({
    super.key,
    this.size = .size2,
    this.highContrast = false,
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
  }) : variant = UiSliderVariant.soft;

  final UiSliderVariant variant;

  final UiSliderSize size;

  final bool highContrast;

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
  Widget build(BuildContext context) {
    return RemixSlider(
      key: this.key,
      style: uiSliderStyle(
        variant: this.variant,
        size: this.size,
        highContrast: this.highContrast,
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
      semanticFormatterCallback: this.semanticFormatterCallback,
      excludeSemantics: this.excludeSemantics,
    );
  }
}
