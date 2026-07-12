part of 'callout.dart';

/// Style configuration for [RemixCallout] layout, icon, and text.
@MixableStyler()
class RemixCalloutStyler
    extends RemixFlexContainerStyler<RemixCalloutSpec, RemixCalloutStyler>
    with
        IconStyleMixin<RemixCalloutStyler>,
        StyledTextStyleMixin<RemixCalloutStyler>,
        Diagnosticable,
        _$RemixCalloutStylerMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $text;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixCalloutStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? text,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $text = text,
       $icon = icon;

  RemixCalloutStyler({
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
  factory RemixCalloutStyler.backgroundColor(Color value) =>
      RemixCalloutStyler().backgroundColor(value);

  /// Creates a style with the given foreground color (icon and text).
  factory RemixCalloutStyler.foregroundColor(Color value) =>
      RemixCalloutStyler().foregroundColor(value);

  /// Creates a style with the given padding.
  factory RemixCalloutStyler.padding(EdgeInsetsGeometryMix value) =>
      RemixCalloutStyler().padding(value);

  /// Creates a style with the given margin.
  factory RemixCalloutStyler.margin(EdgeInsetsGeometryMix value) =>
      RemixCalloutStyler().margin(value);

  /// Creates a style with the given decoration.
  factory RemixCalloutStyler.decoration(DecorationMix value) =>
      RemixCalloutStyler().decoration(value);

  /// Creates a style with the given alignment.
  factory RemixCalloutStyler.alignment(Alignment value) =>
      RemixCalloutStyler().alignment(value);

  /// Creates a style with the given spacing.
  factory RemixCalloutStyler.spacing(double value) =>
      RemixCalloutStyler().spacing(value);

  /// Creates a style with the given constraints.
  factory RemixCalloutStyler.constraints(BoxConstraintsMix value) =>
      RemixCalloutStyler().constraints(value);

  /// Creates a style with the given shape.
  factory RemixCalloutStyler.shape(ShapeBorderMix value) =>
      RemixCalloutStyler().shape(value);

  /// Creates a style with the given icon size.
  factory RemixCalloutStyler.iconSize(double value) =>
      RemixCalloutStyler().iconSize(value);

  /// Creates a style with the given text style.
  factory RemixCalloutStyler.textStyle(TextStyleMix value) =>
      RemixCalloutStyler().textStyle(value);

  /// Sets container padding
  RemixCalloutStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixCalloutStyler(container: FlexBoxStyler(padding: value)));
  }

  /// Sets container margin
  RemixCalloutStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixCalloutStyler(container: FlexBoxStyler(margin: value)));
  }

  /// Sets container background color
  RemixCalloutStyler backgroundColor(Color value) {
    return merge(
      RemixCalloutStyler(
        container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets the foreground color (icon and text) of the callout.
  RemixCalloutStyler foregroundColor(Color value) {
    return iconColor(value).textColor(value);
  }

  /// Sets the shape of the callout.
  RemixCalloutStyler shape(ShapeBorderMix value) {
    return merge(
      RemixCalloutStyler(
        container: FlexBoxStyler(decoration: ShapeDecorationMix(shape: value)),
      ),
    );
  }

  /// Sets container border radius
  RemixCalloutStyler borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixCalloutStyler(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  /// Sets container decoration
  RemixCalloutStyler decoration(DecorationMix value) {
    return merge(
      RemixCalloutStyler(container: FlexBoxStyler(decoration: value)),
    );
  }

  /// Sets container alignment
  RemixCalloutStyler alignment(Alignment value) {
    return merge(
      RemixCalloutStyler(container: FlexBoxStyler(alignment: value)),
    );
  }

  /// Sets flex spacing
  RemixCalloutStyler spacing(double value) {
    return merge(RemixCalloutStyler(container: FlexBoxStyler(spacing: value)));
  }

  /// Creates a [RemixCallout] widget with this style applied.
  RemixCallout call({Key? key, String? text, IconData? icon, Widget? child}) {
    return RemixCallout(
      key: key,
      text: text,
      icon: icon,
      style: this,
      child: child,
    );
  }

  @override
  RemixCalloutStyler constraints(BoxConstraintsMix value) {
    return merge(
      RemixCalloutStyler(container: FlexBoxStyler(constraints: value)),
    );
  }

  @override
  RemixCalloutStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixCalloutStyler(container: FlexBoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixCalloutStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixCalloutStyler(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  @override
  RemixCalloutStyler color(Color value) {
    return backgroundColor(value);
  }

  // FlexStyleMixin implementation
  @override
  RemixCalloutStyler flex(FlexStyler value) {
    return merge(RemixCalloutStyler(container: FlexBoxStyler().flex(value)));
  }
}
