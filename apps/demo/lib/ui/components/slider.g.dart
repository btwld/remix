// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slider.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Slider recipe.
///
/// It reads top to bottom: the track, thumb and row sizes, then the
/// variant's colours, then the thumb lift, motion and disabled. Thumbs are
/// the light control thumb under the three-layer thumb shadow; a held thumb
/// lifts to 116%, and keys, track presses and new values glide the thumb on
/// the snappy spring while a dragged thumb follows the pointer.
///
/// [highContrast] darkens the range with an overlay.
class FortalSlider extends StatelessWidget {
  const FortalSlider({
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

  /// The control track and a control-ink range.
  const FortalSlider.surface({
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
  }) : variant = FortalSliderVariant.surface;

  /// The control track and a range mixed 55% from the control ink toward the
  /// track.
  const FortalSlider.soft({
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
  }) : variant = FortalSliderVariant.soft;

  final FortalSliderVariant variant;

  final FortalSliderSize size;

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
  Widget build(BuildContext _) {
    return RemixSlider(
      style: fortalSliderStyle(
        variant: variant,
        size: size,
        highContrast: highContrast,
        style: style,
      ),
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
