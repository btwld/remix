part of 'card.dart';

// Private per-component constants (sizes only)

@MixableStyler()
class RemixCardStyle extends RemixContainerStyle<RemixCardSpec, RemixCardStyle>
    with Diagnosticable, _$RemixCardStyleMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;

  const RemixCardStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container;

  RemixCardStyle({
    BoxStyler? container,
    AnimationConfig? animation,
    List<VariantStyle<RemixCardSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  // -- Factory constructors for convenience --

  /// Creates a style with the given padding.
  factory RemixCardStyle.padding(EdgeInsetsGeometryMix value) =>
      RemixCardStyle().padding(value);

  /// Creates a style with the given margin.
  factory RemixCardStyle.margin(EdgeInsetsGeometryMix value) =>
      RemixCardStyle().margin(value);

  /// Creates a style with the given border radius.
  factory RemixCardStyle.borderRadius(BorderRadiusGeometryMix radius) =>
      RemixCardStyle().borderRadius(radius);

  /// Creates a style with the given alignment.
  factory RemixCardStyle.alignment(Alignment value) =>
      RemixCardStyle().alignment(value);

  /// Creates a style with the given decoration.
  factory RemixCardStyle.decoration(DecorationMix value) =>
      RemixCardStyle().decoration(value);

  /// Creates a style with the given constraints.
  factory RemixCardStyle.constraints(BoxConstraintsMix value) =>
      RemixCardStyle().constraints(value);

  /// Creates a style with the given shape.
  factory RemixCardStyle.shape(ShapeBorderMix value) =>
      RemixCardStyle().shape(value);

  /// Sets container padding
  RemixCardStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixCardStyle(container: BoxStyler(padding: value)));
  }

  /// Sets container border radius
  RemixCardStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixCardStyle(
        container: BoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  /// Sets container margin
  RemixCardStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixCardStyle(container: BoxStyler(margin: value)));
  }

  /// Sets container alignment
  RemixCardStyle alignment(Alignment value) {
    return merge(RemixCardStyle(container: BoxStyler(alignment: value)));
  }

  /// Sets container decoration
  @override
  RemixCardStyle decoration(DecorationMix value) {
    return merge(RemixCardStyle(container: BoxStyler(decoration: value)));
  }

  /// Sets the shape of the card.
  RemixCardStyle shape(ShapeBorderMix value) {
    return merge(
      RemixCardStyle(
        container: BoxStyler(decoration: ShapeDecorationMix(shape: value)),
      ),
    );
  }

  // Abstract method implementations for mixins

  @override
  RemixCardStyle constraints(BoxConstraintsMix value) {
    return merge(RemixCardStyle(container: BoxStyler(constraints: value)));
  }

  @override
  RemixCardStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixCardStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixCardStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixCardStyle(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }
}
