// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slider.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Slider recipe.
///
/// Remix owns the rendering, the drag and keyboard behavior, the mapping from
/// a 0-1 value onto the filled range, and the slider accessibility semantics;
/// this recipe supplies the rail, the filled range, and the thumb.
///
/// The pill-shaped rail is `mutedForeground` in light and `ring` in dark;
/// the range is `primary`.
/// Both slider recipes reserve a 48px interaction height. The thumb is a white disc
/// with a `primary` outline and a small shadow, which keeps it a distinct
/// handle on either page. In dark mode a dark outline separates overlapping
/// white handles.
///
/// Set [surfaceColor] to the actual enclosing surface on cards or tinted panels
/// (for example, `PlaygroundTokens.card.resolve(context)`). It defaults to the page
/// background. Hover and press halos blend against that surface so the range
/// does not show through them.
///
/// `semanticFormatterCallback` is deliberately not forwarded to the generated
/// `PlaygroundSlider`. Its type is
/// `NakedSliderSemanticFormatterCallback`, which comes from
/// `package:naked_ui` — a package this layer does not depend on. Reach for
/// `RemixSlider` directly on the rare call site that needs to reword the
/// announced value.
class PlaygroundSlider extends StatelessWidget {
  const PlaygroundSlider({
    super.key,
    this.surfaceColor,
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
    this.excludeSemantics = false,
  });

  final Color? surfaceColor;

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

  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    return RemixSlider(
      key: this.key,
      style: playgroundSliderStyle(
        surfaceColor: this.surfaceColor,
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
      excludeSemantics: this.excludeSemantics,
    );
  }
}
