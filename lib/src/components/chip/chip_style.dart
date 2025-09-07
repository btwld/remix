part of 'chip.dart';

// Private per-component constants (sizes only)
const _kFontSizeMd = 14.0;
const _kIconSizeMd = 16.0;

class RemixChipStyle extends Style<ChipSpec>
    with
        StyleModifierMixin<RemixChipStyle, ChipSpec>,
        StyleVariantMixin<RemixChipStyle, ChipSpec>,
        ModifierStyleMixin<RemixChipStyle, ChipSpec>,
        BorderStyleMixin<RemixChipStyle>,
        BorderRadiusStyleMixin<RemixChipStyle>,
        ShadowStyleMixin<RemixChipStyle>,
        DecorationStyleMixin<RemixChipStyle>,
        SpacingStyleMixin<RemixChipStyle>,
        TransformStyleMixin<RemixChipStyle>,
        ConstraintStyleMixin<RemixChipStyle>,
        AnimationStyleMixin<ChipSpec, RemixChipStyle> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixChipStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $label = label,
        $icon = icon;

  RemixChipStyle({
    FlexBoxStyler? container,
    TextStyler? label,
    IconStyler? icon,
    AnimationConfig? animation,
    List<VariantStyle<ChipSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          label: Prop.maybeMix(label),
          icon: Prop.maybeMix(icon),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  // Convenience methods that delegate to container FlexBoxSpec

  /// Sets container padding
  RemixChipStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixChipStyle(container: FlexBoxStyler(padding: value)));
  }

  /// Sets container margin
  RemixChipStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixChipStyle(container: FlexBoxStyler(margin: value)));
  }

  /// Sets container background color
  RemixChipStyle color(Color value) {
    return merge(RemixChipStyle(
      container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets container decoration
  RemixChipStyle decoration(DecorationMix value) {
    return merge(RemixChipStyle(container: FlexBoxStyler(decoration: value)));
  }

  /// Sets container constraints
  RemixChipStyle constraints(BoxConstraintsMix value) {
    return merge(RemixChipStyle(
      container: FlexBoxStyler(constraints: value),
    ));
  }

  /// Sets container border radius
  RemixChipStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixChipStyle(
      container: FlexBoxStyler(
        decoration: BoxDecorationMix(borderRadius: radius),
      ),
    ));
  }

  /// Sets flex spacing
  RemixChipStyle spacing(double value) {
    return merge(RemixChipStyle(container: FlexBoxStyler(spacing: value)));
  }

  /// Sets container border
  RemixChipStyle border(BoxBorderMix value) {
    return merge(RemixChipStyle(
      container: FlexBoxStyler(decoration: BoxDecorationMix(border: value)),
    ));
  }

  /// Sets flex direction
  RemixChipStyle direction(Axis value) {
    return merge(RemixChipStyle(container: FlexBoxStyler(direction: value)));
  }

  /// Sets cross axis alignment
  RemixChipStyle crossAxisAlignment(CrossAxisAlignment value) {
    return merge(RemixChipStyle(
      container: FlexBoxStyler(crossAxisAlignment: value),
    ));
  }

  /// Sets main axis alignment
  RemixChipStyle mainAxisAlignment(MainAxisAlignment value) {
    return merge(RemixChipStyle(
      container: FlexBoxStyler(mainAxisAlignment: value),
    ));
  }

  @override
  StyleSpec<ChipSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: ChipSpec(
        container: MixOps.resolve(context, $container),
        label: MixOps.resolve(context, $label),
        icon: MixOps.resolve(context, $icon),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixChipStyle merge(RemixChipStyle? other) {
    if (other == null) return this;

    return RemixChipStyle.create(
      container: MixOps.merge($container, other.$container),
      label: MixOps.merge($label, other.$label),
      icon: MixOps.merge($icon, other.$icon),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixChipStyle variants(List<VariantStyle<ChipSpec>> value) {
    return merge(RemixChipStyle(variants: value));
  }

  @override
  RemixChipStyle wrap(ModifierConfig value) {
    return merge(RemixChipStyle(modifier: value));
  }

  // Abstract method implementations for mixins

  @override
  RemixChipStyle animate(AnimationConfig config) {
    return merge(RemixChipStyle(animation: config));
  }

  @override
  RemixChipStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixChipStyle(container: FlexBoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixChipStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixChipStyle(
      container: FlexBoxStyler(alignment: alignment, transform: value),
    ));
  }

  @override
  List<Object?> get props => [
        $container,
        $label,
        $icon,
        $variants,
        $animation,
        $modifier,
      ];
}

/// Default chip styles and variants
class RemixChipStyles {
  /// Default chip style
  static RemixChipStyle get defaultStyle => RemixChipStyle(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(SpaceTokens.radius()),
            color: RemixTokens.onPrimary(),
          ),
          padding: EdgeInsetsGeometryMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceMd(),
          ),
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: RemixTokens.spaceXs(),
        ),
        label: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.primary(),
            fontSize: _kFontSizeMd,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyler(color: RemixTokens.primary(), size: _kIconSizeMd),
      )
          .onFocused(
            RemixChipStyle(
              container: FlexBoxStyler(
                decoration: BoxDecorationMix(
                  border: BoxBorderMix.all(
                    BorderSideMix(
                      color: RemixTokens.primary().withValues(alpha: 0.40),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          )
          .onDisabled(
            RemixChipStyle(
              container: FlexBoxStyler(
                decoration: BoxDecorationMix(
                  color: RemixTokens.onPrimary().withValues(alpha: 0.5),
                ),
              ),
              label: TextStyler(
                style: TextStyleMix(
                  color: RemixTokens.secondary().withValues(alpha: 0.6),
                ),
              ),
              icon: IconStyler(
                color: RemixTokens.secondary().withValues(alpha: 0.6),
              ),
            ),
          );

  /// Solid chip variant
  static RemixChipStyle get solid => RemixChipStyle(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(SpaceTokens.radius()),
            color: RemixTokens.primary(),
          ),
          padding: EdgeInsetsMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceMd(),
          ),
        ),
        label: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.onPrimary(),
            fontSize: _kFontSizeMd,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyler(color: RemixTokens.onPrimary(), size: _kIconSizeMd),
      );

  /// Outline chip variant
  static RemixChipStyle get outline => RemixChipStyle(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.primary(), width: 1),
            ),
            borderRadius: BorderRadiusMix.circular(SpaceTokens.radius()),
            color: MixColors.transparent,
          ),
          padding: EdgeInsetsMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceMd(),
          ),
        ),
        label: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.primary(),
            fontSize: _kFontSizeMd,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyler(color: RemixTokens.primary(), size: _kIconSizeMd),
      );

}
