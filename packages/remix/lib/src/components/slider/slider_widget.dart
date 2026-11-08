part of 'slider.dart';

/// A customizable slider component that supports various styles and behaviors.
/// The slider integrates with the Mix styling system and follows Remix design patterns.
///
/// ## Example
///
/// ```dart
/// RemixSlider(
///   min: 0.0,
///   max: 100.0,
///   value: 50.0,
///   onChanged: (value) {
///     debugPrint('Slider value changed: $value');
///   },
///   style: SliderStyler(),
/// )
/// ```
class RemixSlider extends StatelessWidget {
  const RemixSlider({
    super.key,
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
    this.style = const SliderStyler.create(),
    this.styleSpec,
  }) : assert(min < max, 'Slider min must be less than max'),
       assert(
         snapDivisions == null || snapDivisions > 0,
         'Slider snapDivisions must be greater than 0',
       ),
       assert(
         value >= min && value <= max,
         'Slider value must be between min and max values',
       );

  /// The minimum value the slider can have.
  final double min;

  /// The maximum value the slider can have.
  final double max;

  /// Optional snapping divisions for interaction only (no visual ticks).
  /// When provided, the slider snaps to these discrete steps but does not
  /// render any division marks on the track.
  final int? snapDivisions;

  /// Whether the slider should automatically request focus when it is created.
  final bool autofocus;

  /// The current value of the slider.
  /// Must be between [min] and [max].
  final double value;

  /// The style configuration for the slider.
  final SliderStyler style;

  /// The style spec for the slider.
  final SliderSpec? styleSpec;

  static final styleFrom = SliderStyler.new;

  /// Whether the slider is enabled for interaction.
  final bool enabled;

  /// Whether to provide platform feedback during value changes.
  /// Defaults to true.
  final bool enableFeedback;

  /// Called when the user starts a pointer interaction (tap or drag).
  final ValueChanged<double>? onChangeStart;

  /// Called during pointer, keyboard, or semantic input with the new value.
  ///
  /// When null, the slider is visually disabled and does not respond to
  /// interaction.
  final ValueChanged<double>? onChanged;

  /// Called when the user is done selecting a new value.
  final ValueChanged<double>? onChangeEnd;

  /// The focus node for the slider.
  final FocusNode? focusNode;

  /// The semantic label for the slider's single thumb.
  final String? semanticLabel;

  /// Formats the semantic value for the slider's single thumb.
  final NakedSliderSemanticFormatterCallback? semanticFormatterCallback;

  /// Whether to hide the slider from the semantic tree.
  final bool excludeSemantics;

  double get _effectiveStep => _sliderStep(min, max, snapDivisions);

  @override
  Widget build(BuildContext context) {
    // NakedSlider handles semantics internally, no outer Semantics needed
    return NakedSlider(
      values: [value],
      min: min,
      max: max,
      step: _effectiveStep,
      onChanged: onChanged == null
          ? null
          : (values) => onChanged!(values.single),
      onChangeStart: onChangeStart == null
          ? null
          : (values) => onChangeStart!(values.single),
      onChangeEnd: onChangeEnd == null
          ? null
          : (values) => onChangeEnd!(values.single),
      enabled: enabled,
      enableFeedback: enableFeedback,
      focusNodes: focusNode == null ? null : [focusNode],
      autofocusThumbIndex: autofocus ? 0 : null,
      semanticLabels: semanticLabel == null ? null : [semanticLabel],
      semanticFormatterCallbacks: semanticFormatterCallback == null
          ? null
          : [semanticFormatterCallback],
      excludeSemantics: excludeSemantics,
      builder: (context, state, _) {
        return _SliderRenderer(
          state: state,
          style: style,
          styleSpec: styleSpec,
        );
      },
    );
  }
}

// Keep continuous and divided interaction steps identical across both facades.
double _sliderStep(double min, double max, int? snapDivisions) =>
    (max - min) / (snapDivisions ?? 1000);
