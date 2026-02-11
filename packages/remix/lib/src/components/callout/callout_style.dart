part of 'callout.dart';

@MixableStyler()
class RemixCalloutStyle
    extends RemixFlexContainerStyle<RemixCalloutSpec, RemixCalloutStyle>
    with
        IconStyleMixin<RemixCalloutStyle>,
        StyledTextStyleMixin<RemixCalloutStyle>,
        Diagnosticable,
        _$RemixCalloutStyleMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $text;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixCalloutStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? text,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $text = text,
       $icon = icon;

  RemixCalloutStyle({
    FlexBoxStyler? container,
    TextStyler? text,
    IconStyler? icon,
    AnimationConfig? animation,
    List<VariantStyle<RemixCalloutSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         text: Prop.maybeMix(text),
         icon: Prop.maybeMix(icon),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets container padding
  RemixCalloutStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixCalloutStyle(container: FlexBoxStyler(padding: value)));
  }

  /// Sets container margin
  RemixCalloutStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixCalloutStyle(container: FlexBoxStyler(margin: value)));
  }

  /// Sets container background color
  RemixCalloutStyle color(Color value) {
    return merge(
      RemixCalloutStyle(
        container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets container border radius
  RemixCalloutStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixCalloutStyle(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  /// Sets container decoration
  RemixCalloutStyle decoration(DecorationMix value) {
    return merge(
      RemixCalloutStyle(container: FlexBoxStyler(decoration: value)),
    );
  }

  /// Sets container alignment
  RemixCalloutStyle alignment(Alignment value) {
    return merge(RemixCalloutStyle(container: FlexBoxStyler(alignment: value)));
  }

  /// Sets flex spacing
  RemixCalloutStyle spacing(double value) {
    return merge(RemixCalloutStyle(container: FlexBoxStyler(spacing: value)));
  }

  /// Sets icon color
  RemixCalloutStyle iconColor(Color value) {
    return merge(RemixCalloutStyle(icon: IconStyler(color: value)));
  }

  /// Sets text color
  RemixCalloutStyle textColor(Color value) {
    final text = TextStyler(style: TextStyleMix(color: value));

    return merge(RemixCalloutStyle(text: text));
  }

  @override
  RemixCalloutStyle constraints(BoxConstraintsMix value) {
    return merge(
      RemixCalloutStyle(container: FlexBoxStyler(constraints: value)),
    );
  }

  @override
  RemixCalloutStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixCalloutStyle(container: FlexBoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixCalloutStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixCalloutStyle(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  // FlexStyleMixin implementation
  @override
  RemixCalloutStyle flex(FlexStyler value) {
    return merge(RemixCalloutStyle(container: FlexBoxStyler().flex(value)));
  }
}
