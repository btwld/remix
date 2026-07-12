part of 'progress.dart';

/// Style builder for [RemixProgress].
///
/// Use this class to style the progress container, track, indicator, and track
/// layout container.
@MixableStyler()
class RemixProgressStyler
    extends RemixContainerStyler<RemixProgressSpec, RemixProgressStyler>
    with Diagnosticable, _$RemixProgressStylerMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $track;
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $indicator;
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $trackContainer;

  const RemixProgressStyler.create({
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

  RemixProgressStyler({
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
  RemixProgressStyler height(double value) {
    return merge(
      RemixProgressStyler(
        container: BoxStyler(
          constraints: BoxConstraintsMix(minHeight: value, maxHeight: value),
        ),
      ),
    );
  }

  /// Sets track color
  RemixProgressStyler trackColor(Color value) {
    return merge(
      RemixProgressStyler(
        track: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets progress width
  RemixProgressStyler width(double value) {
    return merge(
      RemixProgressStyler(
        container: BoxStyler(
          constraints: BoxConstraintsMix(minWidth: value, maxWidth: value),
        ),
      ),
    );
  }

  /// Sets fill color
  RemixProgressStyler indicatorColor(Color value) {
    return merge(
      RemixProgressStyler(
        indicator: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets container alignment
  RemixProgressStyler alignment(Alignment value) {
    return merge(RemixProgressStyler(container: BoxStyler(alignment: value)));
  }

  /// Creates a [RemixProgress] widget with this style applied.
  RemixProgress call({Key? key, required double value}) {
    return RemixProgress(key: key, value: value, style: this);
  }

  // Abstract method implementations for mixins

  @override
  RemixProgressStyler constraints(BoxConstraintsMix value) {
    return merge(RemixProgressStyler(container: BoxStyler(constraints: value)));
  }

  @override
  RemixProgressStyler decoration(DecorationMix value) {
    return merge(RemixProgressStyler(container: BoxStyler(decoration: value)));
  }

  @override
  RemixProgressStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixProgressStyler(container: BoxStyler(margin: value)));
  }

  @override
  RemixProgressStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixProgressStyler(container: BoxStyler(padding: value)));
  }

  @override
  RemixProgressStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixProgressStyler(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixProgressStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixProgressStyler(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }
}
