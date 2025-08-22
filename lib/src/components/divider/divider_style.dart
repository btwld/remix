part of 'divider.dart';

class RemixDividerStyle extends Style<DividerSpec>
    with StyleModifierMixin<RemixDividerStyle, DividerSpec>, StyleVariantMixin<RemixDividerStyle, DividerSpec> {
  final Prop<WidgetContainerProperties>? $container;

  const RemixDividerStyle.create({
    Prop<WidgetContainerProperties>? container,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  }) : $container = container;

  RemixDividerStyle({
    WidgetContainerPropertiesMix? container,
    AnimationConfig? animation,
    List<VariantStyle<DividerSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: container != null ? Prop.mix(container) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixDividerStyle.value(DividerSpec spec) => RemixDividerStyle(
        container: WidgetContainerPropertiesMix.maybeValue(spec.container),
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
  DividerSpec resolve(BuildContext context) {
    return DividerSpec(container: MixOps.resolve(context, $container));
  }

  @override
  RemixDividerStyle merge(RemixDividerStyle? other) {
    if (other == null) return this;

    return RemixDividerStyle.create(
      container: MixOps.merge($container, other.$container),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  List<Object?> get props => [
        $container,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

final DefaultRemixDividerStyle = RemixDividerStyle(
  container: WidgetContainerPropertiesMix(
    constraints: BoxConstraintsMix(
      minWidth: double.infinity,
      minHeight: 1,
      maxHeight: 1,
    ),
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(99),
      color: Colors.grey[300],
    ),
  ),
);

/// Default divider styles and variants
class RemixDividerStyles {
  /// Default divider style
  static RemixDividerStyle get defaultStyle => RemixDividerStyle(
        container: WidgetContainerPropertiesMix(
          constraints: BoxConstraintsMix(
            minWidth: double.infinity,
            minHeight: 1,
            maxHeight: 1,
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: Colors.grey[300],
          ),
        ),
      );

  /// Vertical divider variant
  static RemixDividerStyle get vertical => RemixDividerStyle(
        container: WidgetContainerPropertiesMix(
          constraints: BoxConstraintsMix(
            minWidth: 1,
            maxWidth: 1,
            minHeight: double.infinity,
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: Colors.grey[300],
          ),
        ),
      );

  /// Thick divider variant
  static RemixDividerStyle get thick => RemixDividerStyle(
        container: WidgetContainerPropertiesMix(
          constraints: BoxConstraintsMix(
            minWidth: double.infinity,
            minHeight: 2,
            maxHeight: 2,
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: Colors.grey[300],
          ),
        ),
      );

  /// Dark divider variant
  static RemixDividerStyle get dark => RemixDividerStyle(
        container: WidgetContainerPropertiesMix(
          constraints: BoxConstraintsMix(
            minWidth: double.infinity,
            minHeight: 1,
            maxHeight: 1,
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: Colors.grey[600],
          ),
        ),
      );
}
