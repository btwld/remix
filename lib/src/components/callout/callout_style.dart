part of 'callout.dart';

class RemixCalloutStyle extends Style<CalloutSpec>
    with
        StyleModifierMixin<RemixCalloutStyle, CalloutSpec>,
        StyleVariantMixin<RemixCalloutStyle, CalloutSpec>,
        ModifierStyleMixin<RemixCalloutStyle, CalloutSpec>,
        BorderStyleMixin<RemixCalloutStyle>,
        BorderRadiusStyleMixin<RemixCalloutStyle>,
        ShadowStyleMixin<RemixCalloutStyle>,
        DecorationStyleMixin<RemixCalloutStyle>,
        SpacingStyleMixin<RemixCalloutStyle>,
        TransformStyleMixin<RemixCalloutStyle>,
        ConstraintStyleMixin<RemixCalloutStyle>,
        AnimationStyleMixin<CalloutSpec, RemixCalloutStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $text;
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixCalloutStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? text,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $text = text,
        $icon = icon;

  RemixCalloutStyle({
    BoxStyler? container,
    TextStyler? text,
    IconStyler? icon,
    AnimationConfig? animation,
    List<VariantStyle<CalloutSpec>>? variants,
    ModifierConfig? modifier,
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
    return merge(RemixCalloutStyle(container: BoxStyler(padding: value)));
  }

  /// Sets container margin
  RemixCalloutStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixCalloutStyle(container: BoxStyler(margin: value)));
  }

  /// Sets container background color
  RemixCalloutStyle color(Color value) {
    return merge(RemixCalloutStyle(
      container: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets container border radius
  RemixCalloutStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixCalloutStyle(
      container: BoxStyler(
        decoration: BoxDecorationMix(borderRadius: radius),
      ),
    ));
  }

  /// Sets container decoration
  RemixCalloutStyle decoration(DecorationMix value) {
    return merge(RemixCalloutStyle(container: BoxStyler(decoration: value)));
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
  RemixCalloutStyle variants(List<VariantStyle<CalloutSpec>> value) {
    return merge(RemixCalloutStyle(variants: value));
  }

  @override
  RemixCalloutStyle wrap(ModifierConfig value) {
    return merge(RemixCalloutStyle(modifier: value));
  }

  // Abstract method implementations for mixins

  @override
  RemixCalloutStyle animate(AnimationConfig config) {
    return merge(RemixCalloutStyle(animation: config));
  }

  @override
  RemixCalloutStyle constraints(BoxConstraintsMix value) {
    return merge(RemixCalloutStyle(container: BoxStyler(constraints: value)));
  }

  @override
  RemixCalloutStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixCalloutStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixCalloutStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixCalloutStyle(
      container: BoxStyler(alignment: alignment, transform: value),
    ));
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

final DefaultRemixCalloutStyle = RemixCalloutStyle(
  container: BoxStyler(
    padding: EdgeInsetsMix.all(12),
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(BorderSideMix(
        color: RemixTokens.border(),
        width: 1,
      )),
      borderRadius: BorderRadiusMix.circular(6),
      color: RemixTokens.background(),
    ),
  ),
  text: TextStyler(
    style: TextStyleMix(
      color: RemixTokens.textPrimary(),
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
  icon: IconStyler(color: RemixTokens.textPrimary(), size: 16),
);

class RemixCalloutStyles {
  static RemixCalloutStyle get defaultStyle => DefaultRemixCalloutStyle;
}

extension CalloutVariants on RemixCalloutStyle {
  /// Info callout variant with blue colors
  static RemixCalloutStyle get info => RemixCalloutStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(12),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.primary().withValues(alpha: 0.6),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(6),
            color: RemixTokens.primary().withValues(alpha: 0.1),
          ),
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.primary(),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyler(color: RemixTokens.primary(), size: 16),
      );

  /// Success callout variant with green colors
  static RemixCalloutStyle get success => RemixCalloutStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(12),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.success().withValues(alpha: 0.6),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(6),
            color: RemixTokens.success().withValues(alpha: 0.1),
          ),
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.success(),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyler(color: RemixTokens.success(), size: 16),
      );

  /// Warning callout variant with orange colors
  static RemixCalloutStyle get warning => RemixCalloutStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(12),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.warning().withValues(alpha: 0.6),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(6),
            color: RemixTokens.warning().withValues(alpha: 0.1),
          ),
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.warning(),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyler(color: RemixTokens.warning(), size: 16),
      );

  /// Error callout variant with red colors
  static RemixCalloutStyle get error => RemixCalloutStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(12),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.danger().withValues(alpha: 0.6),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(6),
            color: RemixTokens.danger().withValues(alpha: 0.1),
          ),
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.danger(),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyler(color: RemixTokens.danger(), size: 16),
      );
}
