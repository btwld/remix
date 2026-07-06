part of 'progress.dart';

/// Style builder for [RemixProgress].
///
/// Use this class to style the progress container, track, indicator, and track
/// layout container.
@MixableStyler()
class RemixProgressStyle
    extends RemixContainerStyle<RemixProgressSpec, RemixProgressStyle>
    with Diagnosticable, _$RemixProgressStyleMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $track;
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $indicator;
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $trackContainer;

  const RemixProgressStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<BoxSpec>>? track,
    Prop<StyleSpec<BoxSpec>>? indicator,
    Prop<StyleSpec<BoxSpec>>? trackContainer,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $track = track,
       $indicator = indicator,
       $trackContainer = trackContainer;

  RemixProgressStyle({
    BoxStyler? container,
    BoxStyler? track,
    BoxStyler? indicator,
    BoxStyler? trackContainer,
    AnimationConfig? animation,
    List<VariantStyle<RemixProgressSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         track: Prop.maybeMix(track),
         indicator: Prop.maybeMix(indicator),
         trackContainer: Prop.maybeMix(trackContainer),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets progress height
  RemixProgressStyle height(double value) {
    return merge(
      RemixProgressStyle(
        container: BoxStyler(
          constraints: BoxConstraintsMix(minHeight: value, maxHeight: value),
        ),
      ),
    );
  }

  /// Sets track color
  RemixProgressStyle trackColor(Color value) {
    return merge(
      RemixProgressStyle(
        track: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets progress width
  RemixProgressStyle width(double value) {
    return merge(
      RemixProgressStyle(
        container: BoxStyler(
          constraints: BoxConstraintsMix(minWidth: value, maxWidth: value),
        ),
      ),
    );
  }

  /// Sets fill color
  RemixProgressStyle indicatorColor(Color value) {
    return merge(
      RemixProgressStyle(
        indicator: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets container alignment
  RemixProgressStyle alignment(Alignment value) {
    return merge(RemixProgressStyle(container: BoxStyler(alignment: value)));
  }

  /// Creates a [RemixProgress] widget with this style applied.
  RemixProgress call({Key? key, required double value}) {
    return RemixProgress(key: key, value: value, style: this);
  }

  // Abstract method implementations for mixins

  @override
  RemixProgressStyle constraints(BoxConstraintsMix value) {
    return merge(RemixProgressStyle(container: BoxStyler(constraints: value)));
  }

  @override
  RemixProgressStyle decoration(DecorationMix value) {
    return merge(RemixProgressStyle(container: BoxStyler(decoration: value)));
  }

  @override
  RemixProgressStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixProgressStyle(container: BoxStyler(margin: value)));
  }

  @override
  RemixProgressStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixProgressStyle(container: BoxStyler(padding: value)));
  }

  @override
  RemixProgressStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixProgressStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixProgressStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixProgressStyle(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }
}
