part of 'spinner.dart';

/// Style builder for [RemixSpinner].
///
/// Use this class to customize spinner size, stroke widths, colors, duration,
/// and Mix variants.
@MixableStyler()
class RemixSpinnerStyler
    extends RemixStyler<RemixSpinnerSpec, RemixSpinnerStyler>
    with Diagnosticable, _$RemixSpinnerStylerMixin {
  @MixableField()
  final Prop<double>? $size;
  @MixableField()
  final Prop<double>? $strokeWidth;
  @MixableField()
  final Prop<Color>? $indicatorColor;
  @MixableField()
  final Prop<Color>? $trackColor;
  @MixableField()
  final Prop<double>? $trackStrokeWidth;
  @MixableField()
  final Prop<Duration>? $duration;

  const RemixSpinnerStyler.create({
    Prop<double>? size,
    Prop<double>? strokeWidth,
    Prop<Color>? indicatorColor,
    Prop<Color>? trackColor,
    Prop<double>? trackStrokeWidth,
    Prop<Duration>? duration,
    super.variants,
    super.animation,
    super.modifier,
  }) : $size = size,
       $strokeWidth = strokeWidth,
       $indicatorColor = indicatorColor,
       $trackColor = trackColor,
       $trackStrokeWidth = trackStrokeWidth,
       $duration = duration;

  RemixSpinnerStyler({
    double? size,
    double? strokeWidth,
    Color? indicatorColor,
    Color? trackColor,
    double? trackStrokeWidth,
    Duration? duration,
    AnimationConfig? animation,
    List<VariantStyle<RemixSpinnerSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         size: Prop.maybe(size),
         strokeWidth: Prop.maybe(strokeWidth),
         indicatorColor: Prop.maybe(indicatorColor),
         trackColor: Prop.maybe(trackColor),
         trackStrokeWidth: Prop.maybe(trackStrokeWidth),
         duration: Prop.maybe(duration),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  factory RemixSpinnerStyler.duration(Duration value) =>
      RemixSpinnerStyler().duration(value);

  factory RemixSpinnerStyler.indicatorColor(Color value) =>
      RemixSpinnerStyler().indicatorColor(value);

  factory RemixSpinnerStyler.size(double value) =>
      RemixSpinnerStyler().size(value);

  factory RemixSpinnerStyler.strokeWidth(double value) =>
      RemixSpinnerStyler().strokeWidth(value);

  factory RemixSpinnerStyler.trackColor(Color value) =>
      RemixSpinnerStyler().trackColor(value);

  factory RemixSpinnerStyler.trackStrokeWidth(double value) =>
      RemixSpinnerStyler().trackStrokeWidth(value);

  RemixSpinner call() {
    return RemixSpinner(style: this);
  }
}
