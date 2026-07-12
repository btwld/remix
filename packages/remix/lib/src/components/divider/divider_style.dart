part of 'divider.dart';

/// Style configuration for a [RemixDivider] container.
@MixableStyler()
class RemixDividerStyler
    extends RemixContainerStyler<RemixDividerSpec, RemixDividerStyler>
    with Diagnosticable, _$RemixDividerStylerMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;

  const RemixDividerStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container;

  RemixDividerStyler({
    BoxStyler? container,
    AnimationConfig? animation,
    List<VariantStyle<RemixDividerSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets divider color
  RemixDividerStyler color(Color value) {
    return merge(
      RemixDividerStyler(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets divider thickness (height for horizontal, width for vertical)
  RemixDividerStyler thickness(double value) {
    return merge(
      RemixDividerStyler(
        container: BoxStyler(
          constraints: BoxConstraintsMix(minHeight: value, maxHeight: value),
        ),
      ),
    );
  }

  /// Sets container padding
  RemixDividerStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixDividerStyler(container: BoxStyler(padding: value)));
  }

  /// Sets container margin
  RemixDividerStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixDividerStyler(container: BoxStyler(margin: value)));
  }

  /// Sets container alignment
  RemixDividerStyler alignment(Alignment value) {
    return merge(RemixDividerStyler(container: BoxStyler(alignment: value)));
  }

  /// Creates a [RemixDivider] widget with this style applied.
  RemixDivider call({Key? key}) {
    return RemixDivider(key: key, style: this);
  }

  /// Sets container decoration
  @override
  RemixDividerStyler decoration(DecorationMix value) {
    return merge(RemixDividerStyler(container: BoxStyler(decoration: value)));
  }

  // Abstract method implementations for mixins

  @override
  RemixDividerStyler constraints(BoxConstraintsMix value) {
    return merge(RemixDividerStyler(container: BoxStyler(constraints: value)));
  }

  @override
  RemixDividerStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixDividerStyler(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixDividerStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixDividerStyler(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }
}
