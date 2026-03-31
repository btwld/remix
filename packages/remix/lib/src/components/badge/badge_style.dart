part of 'badge.dart';

@MixableStyler()
class RemixBadgeStyle
    extends RemixContainerStyle<RemixBadgeSpec, RemixBadgeStyle>
    with
        LabelStyleMixin<RemixBadgeStyle>,
        Diagnosticable,
        _$RemixBadgeStyleMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $text;

  const RemixBadgeStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? text,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $text = text;

  RemixBadgeStyle({
    BoxStyler? container,
    TextStyler? text,
    AnimationConfig? animation,
    List<VariantStyle<RemixBadgeSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         text: Prop.maybeMix(text),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  // -- Factory constructors for convenience --

  /// Creates a style with the given background color.
  factory RemixBadgeStyle.backgroundColor(Color value) =>
      RemixBadgeStyle().backgroundColor(value);

  /// Creates a style with the given foreground color (text).
  factory RemixBadgeStyle.foregroundColor(Color value) =>
      RemixBadgeStyle().foregroundColor(value);

  /// Creates a style with the given padding.
  factory RemixBadgeStyle.padding(EdgeInsetsGeometryMix value) =>
      RemixBadgeStyle().padding(value);

  /// Creates a style with the given margin.
  factory RemixBadgeStyle.margin(EdgeInsetsGeometryMix value) =>
      RemixBadgeStyle().margin(value);

  /// Creates a style with the given decoration.
  factory RemixBadgeStyle.decoration(DecorationMix value) =>
      RemixBadgeStyle().decoration(value);

  /// Creates a style with the given alignment.
  factory RemixBadgeStyle.alignment(Alignment value) =>
      RemixBadgeStyle().alignment(value);

  /// Creates a style with the given constraints.
  factory RemixBadgeStyle.constraints(BoxConstraintsMix value) =>
      RemixBadgeStyle().constraints(value);

  // Instance methods (chainable)

  /// Sets background color
  RemixBadgeStyle backgroundColor(Color value) {
    return merge(
      RemixBadgeStyle(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets the foreground color (text) of the badge.
  RemixBadgeStyle foregroundColor(Color value) {
    return labelColor(value);
  }

  /// Sets border radius
  RemixBadgeStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixBadgeStyle(
        container: BoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  /// Sets padding
  RemixBadgeStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixBadgeStyle(container: BoxStyler(padding: value)));
  }

  // Additional convenience methods that delegate to container

  /// Sets margin
  RemixBadgeStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixBadgeStyle(container: BoxStyler(margin: value)));
  }

  /// Sets decoration
  RemixBadgeStyle decoration(DecorationMix value) {
    return merge(RemixBadgeStyle(container: BoxStyler(decoration: value)));
  }

  /// Sets container alignment
  RemixBadgeStyle alignment(Alignment value) {
    return merge(RemixBadgeStyle(container: BoxStyler(alignment: value)));
  }

  @override
  RemixBadgeStyle label(TextStyler value) {
    return merge(RemixBadgeStyle(text: value));
  }

  /// Sets constraints
  @override
  RemixBadgeStyle constraints(BoxConstraintsMix value) {
    return merge(RemixBadgeStyle(container: BoxStyler(constraints: value)));
  }

  // Abstract method implementations for mixins

  @override
  RemixBadgeStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixBadgeStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixBadgeStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixBadgeStyle(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }
}
