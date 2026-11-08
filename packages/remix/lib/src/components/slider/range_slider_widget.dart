part of 'slider.dart';

/// A controlled horizontal interval with stable lower and upper thumbs.
///
/// The host owns [values], which must contain exactly two finite, ordered values.
/// Thumbs may touch when [minSpacing] is zero, but never cross, push or swap.
/// Supply distinct, localized [semanticLabels] for the two bounds.
///
/// Uses [SliderStyler] and [SliderSpec]. Forwarded Box styling controls the
/// thumbs; constrain the complete slider's width with a parent widget.
class RemixRangeSlider extends StatelessWidget {
  const RemixRangeSlider({
    super.key,
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
    this.style = const SliderStyler.create(),
    this.styleSpec,
  }) : assert(
         min > double.negativeInfinity && max < double.infinity && min < max,
         'Range slider bounds must be finite and min must be less than max',
       ),
       assert(
         minSpacing >= 0 && minSpacing < double.infinity,
         'Range slider minSpacing must be finite and nonnegative',
       ),
       assert(
         snapDivisions == null || snapDivisions > 0,
         'Range slider snapDivisions must be greater than 0',
       ),
       assert(
         autofocusThumbIndex == null ||
             autofocusThumbIndex == 0 ||
             autofocusThumbIndex == 1,
         'Range slider autofocusThumbIndex must be 0 or 1',
       );

  /// The parent-authoritative `[lower, upper]` bounds.
  final List<double> values;

  /// Receives immutable complete requests from pointer, keyboard or semantics.
  /// A null callback disables interaction.
  final ValueChanged<List<double>>? onChanged;

  /// Called once when a pointer transaction begins, with its starting values.
  final ValueChanged<List<double>>? onChangeStart;

  /// Called once at pointer release/cancellation with the last requested values.
  /// This reports a request, not proof that the host accepted it. Keyboard and
  /// semantic adjustments do not emit pointer start/end callbacks.
  final ValueChanged<List<double>>? onChangeEnd;

  /// Domain bounds; [min] must be less than [max].
  final double min;
  final double max;

  /// Minimum value-space separation between the bounds.
  final double minSpacing;

  /// Interaction divisions; no ticks are rendered. Without divisions, the step
  /// is one thousandth of the domain. Neighbor bounds take precedence over snap.
  final int? snapDivisions;

  final bool enabled;
  final bool enableFeedback;

  /// Optional caller-owned focus nodes, in lower/upper order.
  final List<FocusNode?>? focusNodes;
  final int? autofocusThumbIndex;

  /// Independent accessible names and value formatters, in lower/upper order.
  final List<String?>? semanticLabels;
  final List<NakedSliderSemanticFormatterCallback?>? semanticFormatterCallbacks;
  final bool excludeSemantics;
  final SliderStyler style;

  /// A resolved spec that bypasses fluent and inherited style resolution.
  final SliderSpec? styleSpec;

  @override
  Widget build(BuildContext context) {
    assert(values.length == 2, 'Range slider requires exactly two values');
    assert(
      focusNodes == null || focusNodes!.length == 2,
      'Range slider focusNodes must contain exactly two entries',
    );
    assert(
      semanticLabels == null || semanticLabels!.length == 2,
      'Range slider semanticLabels must contain exactly two entries',
    );
    assert(
      semanticFormatterCallbacks == null ||
          semanticFormatterCallbacks!.length == 2,
      'Range slider semanticFormatterCallbacks must contain exactly two entries',
    );

    assert(
      values.every((v) => v.isFinite) &&
          values[0] >= min &&
          values[1] <= max &&
          values[0] <= values[1] &&
          values[1] - values[0] >= minSpacing - precisionErrorTolerance,
      'Values must be finite, ordered, in range, and honor minSpacing',
    );
    return NakedSlider(
      values: values,
      min: min,
      max: max,
      minSpacing: minSpacing,
      step: _sliderStep(min, max, snapDivisions),
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      enabled: enabled,
      enableFeedback: enableFeedback,
      focusNodes: focusNodes,
      autofocusThumbIndex: autofocusThumbIndex,
      semanticLabels: semanticLabels,
      semanticFormatterCallbacks: semanticFormatterCallbacks,
      excludeSemantics: excludeSemantics,
      builder: (context, state, _) => _SliderRenderer(
        state: state,
        style: style,
        styleSpec: styleSpec,
        range: true,
      ),
    );
  }
}
