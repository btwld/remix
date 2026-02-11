part of 'divider.dart';

// Private per-component constants (none)

@MixableStyler()
class RemixDividerStyle
    extends RemixContainerStyle<RemixDividerSpec, RemixDividerStyle>
    with Diagnosticable, _$RemixDividerStyleMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;

  const RemixDividerStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container;

  RemixDividerStyle({
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
  RemixDividerStyle color(Color value) {
    return merge(
      RemixDividerStyle(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets divider thickness (height for horizontal, width for vertical)
  RemixDividerStyle thickness(double value) {
    return merge(
      RemixDividerStyle(
        container: BoxStyler(
          constraints: BoxConstraintsMix(minHeight: value, maxHeight: value),
        ),
      ),
    );
  }

  /// Sets container padding
  RemixDividerStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixDividerStyle(container: BoxStyler(padding: value)));
  }

  /// Sets container margin
  RemixDividerStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixDividerStyle(container: BoxStyler(margin: value)));
  }

  /// Sets container alignment
  RemixDividerStyle alignment(Alignment value) {
    return merge(RemixDividerStyle(container: BoxStyler(alignment: value)));
  }

  /// Sets container decoration
  @override
  RemixDividerStyle decoration(DecorationMix value) {
    return merge(RemixDividerStyle(container: BoxStyler(decoration: value)));
  }

  // Abstract method implementations for mixins

  @override
  RemixDividerStyle constraints(BoxConstraintsMix value) {
    return merge(RemixDividerStyle(container: BoxStyler(constraints: value)));
  }

  @override
  RemixDividerStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixDividerStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixDividerStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixDividerStyle(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }
}
