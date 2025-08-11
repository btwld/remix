part of 'divider.dart';

class DividerStyle extends Style<DividerSpec>
    with StyleModifierMixin<DividerStyle, DividerSpec>, StyleVariantMixin<DividerStyle, DividerSpec> {
  final Prop<BoxSpec>? $container;

  const DividerStyle.create({
    Prop<BoxSpec>? container,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  }) : $container = container;

  DividerStyle({
    BoxMix? container,
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

  factory DividerStyle.value(DividerSpec spec) => DividerStyle(
        container: BoxMix.maybeValue(spec.container),
      );

  @override
  DividerStyle variant(Variant variant, DividerStyle style) {
    return merge(DividerStyle(variants: [VariantStyle(variant, style)]));
  }
  
  @override
  DividerStyle variants(List<VariantStyle<DividerSpec>> value) {
    return merge(DividerStyle(variants: value));
  }
  
  @override
  DividerStyle wrap(ModifierConfig value) {
    return merge(DividerStyle(modifier: value));
  }

  @override
  DividerSpec resolve(BuildContext context) {
    return DividerSpec(container: MixOps.resolve(context, $container));
  }

  @override
  DividerStyle merge(DividerStyle? other) {
    if (other == null) return this;

    return DividerStyle.create(
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

final DefaultDividerStyle = DividerStyle(
  container: BoxMix(
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
class DividerStyles {
  /// Default divider style
  static DividerStyle get defaultStyle => DividerStyle(
        container: BoxMix(
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
  static DividerStyle get vertical => DividerStyle(
        container: BoxMix(
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
  static DividerStyle get thick => DividerStyle(
        container: BoxMix(
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
  static DividerStyle get dark => DividerStyle(
        container: BoxMix(
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
