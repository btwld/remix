part of 'badge.dart';

/// Style configuration for [RemixBadge] container and label text.
@MixableStyler()
class RemixBadgeStyler
    extends RemixContainerStyler<RemixBadgeSpec, RemixBadgeStyler>
    with
        LabelStyleMixin<RemixBadgeStyler>,
        Diagnosticable,
        _$RemixBadgeStylerMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $label;

  const RemixBadgeStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $label = label;

  RemixBadgeStyler({
    BoxStyler? container,
    TextStyler? label,
    AnimationConfig? animation,
    List<VariantStyle<RemixBadgeSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         label: Prop.maybeMix(label),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  // -- Factory constructors for convenience --

  /// Creates a style with the given background color.
  factory RemixBadgeStyler.backgroundColor(Color value) =>
      RemixBadgeStyler().backgroundColor(value);

  /// Creates a style with the given foreground color (text).
  factory RemixBadgeStyler.foregroundColor(Color value) =>
      RemixBadgeStyler().foregroundColor(value);

  /// Creates a style with the given padding.
  factory RemixBadgeStyler.padding(EdgeInsetsGeometryMix value) =>
      RemixBadgeStyler().padding(value);

  /// Creates a style with the given margin.
  factory RemixBadgeStyler.margin(EdgeInsetsGeometryMix value) =>
      RemixBadgeStyler().margin(value);

  /// Creates a style with the given decoration.
  factory RemixBadgeStyler.decoration(DecorationMix value) =>
      RemixBadgeStyler().decoration(value);

  /// Creates a style with the given alignment.
  factory RemixBadgeStyler.alignment(Alignment value) =>
      RemixBadgeStyler().alignment(value);

  /// Creates a style with the given constraints.
  factory RemixBadgeStyler.constraints(BoxConstraintsMix value) =>
      RemixBadgeStyler().constraints(value);

  // Instance methods (chainable)

  /// Sets background color
  RemixBadgeStyler backgroundColor(Color value) {
    return merge(
      RemixBadgeStyler(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets the foreground color (text) of the badge.
  RemixBadgeStyler foregroundColor(Color value) {
    return labelColor(value);
  }

  /// Sets border radius
  RemixBadgeStyler borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixBadgeStyler(
        container: BoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  /// Sets padding
  RemixBadgeStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixBadgeStyler(container: BoxStyler(padding: value)));
  }

  // Additional convenience methods that delegate to container

  /// Sets margin
  RemixBadgeStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixBadgeStyler(container: BoxStyler(margin: value)));
  }

  /// Sets decoration
  RemixBadgeStyler decoration(DecorationMix value) {
    return merge(RemixBadgeStyler(container: BoxStyler(decoration: value)));
  }

  /// Sets container alignment
  RemixBadgeStyler alignment(Alignment value) {
    return merge(RemixBadgeStyler(container: BoxStyler(alignment: value)));
  }

  @override
  RemixBadgeStyler label(TextStyler value) {
    return merge(RemixBadgeStyler(label: value));
  }

  /// Creates a [RemixBadge] widget with this style applied.
  RemixBadge call({
    Key? key,
    String? label,
    Widget? child,
    RemixBadgeLabelBuilder? labelBuilder,
  }) {
    return RemixBadge(
      key: key,
      label: label,
      child: child,
      labelBuilder: labelBuilder,
      style: this,
    );
  }

  /// Sets constraints
  @override
  RemixBadgeStyler constraints(BoxConstraintsMix value) {
    return merge(RemixBadgeStyler(container: BoxStyler(constraints: value)));
  }

  // Abstract method implementations for mixins

  @override
  RemixBadgeStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixBadgeStyler(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixBadgeStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixBadgeStyler(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }
}
