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

  // -- Factory constructors for convenience --

  /// Creates a style with the given background color.
  factory RemixCalloutStyle.backgroundColor(Color value) =>
      RemixCalloutStyle().backgroundColor(value);

  /// Creates a style with the given foreground color (icon and text).
  factory RemixCalloutStyle.foregroundColor(Color value) =>
      RemixCalloutStyle().foregroundColor(value);

  /// Creates a style with the given padding.
  factory RemixCalloutStyle.padding(EdgeInsetsGeometryMix value) =>
      RemixCalloutStyle().padding(value);

  /// Creates a style with the given margin.
  factory RemixCalloutStyle.margin(EdgeInsetsGeometryMix value) =>
      RemixCalloutStyle().margin(value);

  /// Creates a style with the given decoration.
  factory RemixCalloutStyle.decoration(DecorationMix value) =>
      RemixCalloutStyle().decoration(value);

  /// Creates a style with the given alignment.
  factory RemixCalloutStyle.alignment(Alignment value) =>
      RemixCalloutStyle().alignment(value);

  /// Creates a style with the given spacing.
  factory RemixCalloutStyle.spacing(double value) =>
      RemixCalloutStyle().spacing(value);

  /// Creates a style with the given constraints.
  factory RemixCalloutStyle.constraints(BoxConstraintsMix value) =>
      RemixCalloutStyle().constraints(value);

  /// Creates a style with the given shape.
  factory RemixCalloutStyle.shape(ShapeBorderMix value) =>
      RemixCalloutStyle().shape(value);

  /// Creates a style with the given icon color.
  factory RemixCalloutStyle.iconColor(Color value) =>
      RemixCalloutStyle().iconColor(value);

  /// Creates a style with the given icon size.
  factory RemixCalloutStyle.iconSize(double value) =>
      RemixCalloutStyle().iconSize(value);

  /// Creates a style with the given text color.
  factory RemixCalloutStyle.textColor(Color value) =>
      RemixCalloutStyle().textColor(value);

  /// Creates a style with the given text style.
  factory RemixCalloutStyle.textStyle(TextStyleMix value) =>
      RemixCalloutStyle().textStyle(value);

  /// Sets container padding
  RemixCalloutStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixCalloutStyle(container: FlexBoxStyler(padding: value)));
  }

  /// Sets container margin
  RemixCalloutStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixCalloutStyle(container: FlexBoxStyler(margin: value)));
  }

  /// Sets container background color
  RemixCalloutStyle backgroundColor(Color value) {
    return merge(
      RemixCalloutStyle(
        container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets the foreground color (icon and text) of the callout.
  RemixCalloutStyle foregroundColor(Color value) {
    return iconColor(value).textColor(value);
  }

  /// Sets the shape of the callout.
  RemixCalloutStyle shape(ShapeBorderMix value) {
    return merge(
      RemixCalloutStyle(
        container: FlexBoxStyler(decoration: ShapeDecorationMix(shape: value)),
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

  @override
  RemixCalloutStyle color(Color value) {
    return backgroundColor(value);
  }

  // FlexStyleMixin implementation
  @override
  RemixCalloutStyle flex(FlexStyler value) {
    return merge(RemixCalloutStyle(container: FlexBoxStyler().flex(value)));
  }
}
