part of 'callout.dart';

// Private per-component constants (sizes only)
const _kFontSizeMd = 14.0;
const _kIconSizeMd = 16.0;

class RemixCalloutStyle
    extends RemixFlexContainerStyle<CalloutSpec, RemixCalloutStyle> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $text;
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixCalloutStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? text,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $text = text,
        $icon = icon;

  RemixCalloutStyle({
    FlexBoxStyler? container,
    TextStyler? text,
    IconStyler? icon,
    AnimationConfig? animation,
    List<VariantStyle<CalloutSpec>>? variants,
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
    return merge(RemixCalloutStyle(
      container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets container border radius
  RemixCalloutStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixCalloutStyle(
      container: FlexBoxStyler(
        decoration: BoxDecorationMix(borderRadius: radius),
      ),
    ));
  }

  /// Sets container decoration
  RemixCalloutStyle decoration(DecorationMix value) {
    return merge(
      RemixCalloutStyle(container: FlexBoxStyler(decoration: value)),
    );
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
    return merge(RemixCalloutStyle(
      text: TextStyler(style: TextStyleMix(color: value)),
    ));
  }

  @override
  StyleSpec<CalloutSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: CalloutSpec(
        container: MixOps.resolve(context, $container),
        text: MixOps.resolve(context, $text),
        icon: MixOps.resolve(context, $icon),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixCalloutStyle merge(RemixCalloutStyle? other) {
    if (other == null) return this;

    return RemixCalloutStyle.create(
      container: MixOps.merge($container, other.$container),
      text: MixOps.merge($text, other.$text),
      icon: MixOps.merge($icon, other.$icon),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixCalloutStyle withVariants(List<VariantStyle<CalloutSpec>> value) {
    return merge(RemixCalloutStyle(variants: value));
  }

  @override
  RemixCalloutStyle wrap(WidgetModifierConfig value) {
    return merge(RemixCalloutStyle(modifier: value));
  }

  // Abstract method implementations for mixins

  @override
  RemixCalloutStyle animate(AnimationConfig config) {
    return merge(RemixCalloutStyle(animation: config));
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
    return merge(RemixCalloutStyle(
      container: FlexBoxStyler(alignment: alignment, transform: value),
    ));
  }

  // FlexStyleMixin implementation
  @override
  RemixCalloutStyle flex(FlexStyler value) {
    return merge(RemixCalloutStyle(container: FlexBoxStyler()));
  }

  @override
  List<Object?> get props => [
        $container,
        $text,
        $icon,
        $variants,
        $animation,
        $modifier,
      ];
}

// Default style is provided by RemixCalloutStyles.baseStyle

// Variants are exposed via RemixCalloutStyles
/// Canonical access to default styles
class RemixCalloutStyles {
  /// Base callout style - informational design with border
  static RemixCalloutStyle get baseStyle => RemixCalloutStyle(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.primary(),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.all(RemixTokens.radius()),
            color: RemixTokens.onPrimary(),
          ),
          padding: EdgeInsetsMix.all(RemixTokens.spaceMd()),
          alignment: Alignment.centerLeft,
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: RemixTokens.spaceSm(),
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.primary(),
            fontSize: _kFontSizeMd,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyler(color: RemixTokens.primary(), size: _kIconSizeMd),
      );
}
