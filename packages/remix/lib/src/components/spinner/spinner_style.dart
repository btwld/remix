part of 'spinner.dart';

@MixableStyler()
class RemixSpinnerStyle extends RemixStyle<RemixSpinnerSpec, RemixSpinnerStyle>
    with Diagnosticable, _$RemixSpinnerStyleMixin {
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

  const RemixSpinnerStyle.create({
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

  RemixSpinnerStyle({
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

  RemixSpinner call() {
    return RemixSpinner(style: this);
  }
}
