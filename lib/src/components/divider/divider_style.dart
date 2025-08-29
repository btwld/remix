part of 'divider.dart';

class RemixDividerStyle extends Style<DividerSpec>
    with
        StyleModifierMixin<RemixDividerStyle, DividerSpec>,
        StyleVariantMixin<RemixDividerStyle, DividerSpec> {
  final Prop<WidgetSpec<BoxSpec>>? $container;

  const RemixDividerStyle.create({
    Prop<WidgetSpec<BoxSpec>>? container,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container;

  RemixDividerStyle({
    BoxStyle? container,
    AnimationConfig? animation,
    List<VariantStyle<DividerSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  @override
  RemixDividerStyle variant(Variant variant, RemixDividerStyle style) {
    return merge(RemixDividerStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixDividerStyle variants(List<VariantStyle<DividerSpec>> value) {
    return merge(RemixDividerStyle(variants: value));
  }

  @override
  RemixDividerStyle wrap(ModifierConfig value) {
    return merge(RemixDividerStyle(modifier: value));
  }

  @override
  WidgetSpec<DividerSpec> resolve(BuildContext context) {
    return WidgetSpec(
      spec: DividerSpec(container: MixOps.resolve(context, $container)),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixDividerStyle merge(RemixDividerStyle? other) {
    if (other == null) return this;

    return RemixDividerStyle.create(
      container: MixOps.merge($container, other.$container),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
    );
  }

  @override
  List<Object?> get props => [$container, $variants, $animation, $modifier];
}

final DefaultRemixDividerStyle = RemixDividerStyle(
  container: BoxStyle(
    constraints: BoxConstraintsMix(
      minWidth: double.infinity,
      minHeight: 1,
      maxHeight: 1,
    ),
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(99),
      color: RemixTokens.border(),
    ),
  ),
);

/// Default divider styles and variants
class RemixDividerStyles {
  /// Default divider style
  static RemixDividerStyle get defaultStyle => RemixDividerStyle(
        container: BoxStyle(
          constraints: BoxConstraintsMix(
            minWidth: double.infinity,
            minHeight: 1,
            maxHeight: 1,
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: RemixTokens.border(),
          ),
        ),
      );

  /// Vertical divider variant
  static RemixDividerStyle get vertical => RemixDividerStyle(
        container: BoxStyle(
          constraints: BoxConstraintsMix(
            minWidth: 1,
            maxWidth: 1,
            minHeight: double.infinity,
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: RemixTokens.border(),
          ),
        ),
      );

  /// Thick divider variant
  static RemixDividerStyle get thick => RemixDividerStyle(
        container: BoxStyle(
          constraints: BoxConstraintsMix(
            minWidth: double.infinity,
            minHeight: 2,
            maxHeight: 2,
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: RemixTokens.border(),
          ),
        ),
      );

  /// Dark divider variant
  static RemixDividerStyle get dark => RemixDividerStyle(
        container: BoxStyle(
          constraints: BoxConstraintsMix(
            minWidth: double.infinity,
            minHeight: 1,
            maxHeight: 1,
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: RemixTokens.textSecondary(),
          ),
        ),
      );
}
