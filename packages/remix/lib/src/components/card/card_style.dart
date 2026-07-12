part of 'card.dart';

/// Style configuration for a [RemixCard] container.
@MixableStyler()
class RemixCardStyler
    extends RemixContainerStyler<RemixCardSpec, RemixCardStyler>
    with Diagnosticable, _$RemixCardStylerMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;

  const RemixCardStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container;

  RemixCardStyler({
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
  factory RemixCardStyler.padding(EdgeInsetsGeometryMix value) =>
      RemixCardStyler().padding(value);

  /// Creates a style with the given margin.
  factory RemixCardStyler.margin(EdgeInsetsGeometryMix value) =>
      RemixCardStyler().margin(value);

  /// Creates a style with the given border radius.
  factory RemixCardStyler.borderRadius(BorderRadiusGeometryMix radius) =>
      RemixCardStyler().borderRadius(radius);

  /// Creates a style with the given alignment.
  factory RemixCardStyler.alignment(Alignment value) =>
      RemixCardStyler().alignment(value);

  /// Creates a style with the given decoration.
  factory RemixCardStyler.decoration(DecorationMix value) =>
      RemixCardStyler().decoration(value);

  /// Creates a style with the given background color.
  factory RemixCardStyler.backgroundColor(Color value) =>
      RemixCardStyler().backgroundColor(value);

  /// Creates a style with the given constraints.
  factory RemixCardStyler.constraints(BoxConstraintsMix value) =>
      RemixCardStyler().constraints(value);

  /// Creates a style with the given shape.
  factory RemixCardStyler.shape(ShapeBorderMix value) =>
      RemixCardStyler().shape(value);

  /// Sets container padding
  RemixCardStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixCardStyler(container: BoxStyler(padding: value)));
  }

  /// Sets the card background color.
  RemixCardStyler backgroundColor(Color value) => color(value);

  /// Sets container border radius
  RemixCardStyler borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixCardStyler(
        container: BoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  /// Sets container margin
  RemixCardStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixCardStyler(container: BoxStyler(margin: value)));
  }

  /// Sets container alignment
  RemixCardStyler alignment(Alignment value) {
    return merge(RemixCardStyler(container: BoxStyler(alignment: value)));
  }

  /// Sets the shape of the card.
  RemixCardStyler shape(ShapeBorderMix value) {
    return merge(
      RemixCardStyler(
        container: BoxStyler(decoration: ShapeDecorationMix(shape: value)),
      ),
    );
  }

  /// Creates a [RemixCard] widget with this style applied.
  RemixCard call({Key? key, Widget? child}) {
    return RemixCard(key: key, style: this, child: child);
  }

  /// Sets container decoration
  @override
  RemixCardStyler decoration(DecorationMix value) {
    return merge(RemixCardStyler(container: BoxStyler(decoration: value)));
  }

  // Abstract method implementations for mixins

  @override
  RemixCardStyler constraints(BoxConstraintsMix value) {
    return merge(RemixCardStyler(container: BoxStyler(constraints: value)));
  }

  @override
  RemixCardStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixCardStyler(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixCardStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixCardStyler(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }
}
