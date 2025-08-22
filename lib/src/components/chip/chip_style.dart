part of 'chip.dart';

class RemixChipStyle extends Style<ChipSpec>
    with
        StyleModifierMixin<RemixChipStyle, ChipSpec>,
        StyleVariantMixin<RemixChipStyle, ChipSpec> {
  final Prop<ContainerProperties>? $container;
  final Prop<FlexProperties>? $flex;
  final Prop<TextSpec>? $label;
  final Prop<IconSpec>? $leading;
  final Prop<IconSpec>? $trailing;

  const RemixChipStyle.create({
    Prop<ContainerProperties>? container,
    Prop<FlexProperties>? flex,
    Prop<TextSpec>? label,
    Prop<IconSpec>? leading,
    Prop<IconSpec>? trailing,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $flex = flex,
        $label = label,
        $leading = leading,
        $trailing = trailing;

  RemixChipStyle({
    ContainerPropertiesMix? container,
    FlexPropertiesMix? flex,
    TextMix? label,
    IconMix? leading,
    IconMix? trailing,
    AnimationConfig? animation,
    List<VariantStyle<ChipSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: container != null ? Prop.mix(container) : null,
          flex: flex != null ? Prop.mix(flex) : null,
          label: label != null ? Prop.mix(label) : null,
          leading: leading != null ? Prop.mix(leading) : null,
          trailing: trailing != null ? Prop.mix(trailing) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixChipStyle.value(ChipSpec spec) => RemixChipStyle(
        container: ContainerPropertiesMix.maybeValue(spec.container),
        flex: FlexPropertiesMix.maybeValue(spec.flex),
        label: TextMix.maybeValue(spec.label),
        leading: IconMix.maybeValue(spec.leading),
        trailing: IconMix.maybeValue(spec.trailing),
      );

  @override
  ChipSpec resolve(BuildContext context) {
    return ChipSpec(
      container: MixOps.resolve(context, $container),
      flex: MixOps.resolve(context, $flex),
      label: MixOps.resolve(context, $label),
      leading: MixOps.resolve(context, $leading),
      trailing: MixOps.resolve(context, $trailing),
    );
  }

  @override
  RemixChipStyle merge(RemixChipStyle? other) {
    if (other == null) return this;

    return RemixChipStyle.create(
      container: MixOps.merge($container, other.$container),
      flex: MixOps.merge($flex, other.$flex),
      label: MixOps.merge($label, other.$label),
      leading: MixOps.merge($leading, other.$leading),
      trailing: MixOps.merge($trailing, other.$trailing),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  RemixChipStyle variant(Variant variant, RemixChipStyle style) {
    return merge(RemixChipStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixChipStyle variants(List<VariantStyle<ChipSpec>> value) {
    return merge(RemixChipStyle(variants: value));
  }

  @override
  RemixChipStyle wrap(ModifierConfig value) {
    return merge(RemixChipStyle(modifier: value));
  }

  @override
  List<Object?> get props => [
        $container,
        $flex,
        $label,
        $leading,
        $trailing,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

final DefaultRemixChipStyle = RemixChipStyle(
  container: ContainerPropertiesMix(
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(16),
      color: Colors.grey[200],
    ),
    padding: EdgeInsetsMix.symmetric(vertical: 6, horizontal: 12),
  ),
  flex: FlexPropertiesMix(
    direction: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    gap: 4,
  ),
  label: TextMix(
    style: TextStyleMix(fontSize: 14, fontWeight: FontWeight.w500),
  ),
  leading: IconMix(size: 16),
  trailing: IconMix(size: 16),
);

extension ChipVariants on RemixChipStyle {
  /// Primary chip variant with blue colors
  static RemixChipStyle get primary => RemixChipStyle(
        container: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: Colors.blue[300]!, width: 1),
            ),
            borderRadius: BorderRadiusMix.circular(16),
            color: Colors.blue[100],
          ),
          padding: EdgeInsetsMix.symmetric(vertical: 6, horizontal: 12),
        ),
        flex: FlexPropertiesMix(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          gap: 4,
        ),
        label: TextMix(
          style: TextStyleMix(
            color: Colors.blue[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconMix(color: Colors.blue[600], size: 16),
        trailing: IconMix(color: Colors.blue[600], size: 16),
      );

  /// Secondary chip variant with grey colors
  static RemixChipStyle get secondary => RemixChipStyle(
        container: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: Colors.grey[400]!, width: 1),
            ),
            borderRadius: BorderRadiusMix.circular(16),
            color: Colors.grey[100],
          ),
          padding: EdgeInsetsMix.symmetric(vertical: 6, horizontal: 12),
        ),
        flex: FlexPropertiesMix(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          gap: 4,
        ),
        label: TextMix(
          style: TextStyleMix(
            color: Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconMix(color: Colors.grey[600], size: 16),
        trailing: IconMix(color: Colors.grey[600], size: 16),
      );

  /// Success chip variant with green colors
  static RemixChipStyle get success => RemixChipStyle(
        container: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: Colors.green[300]!, width: 1),
            ),
            borderRadius: BorderRadiusMix.circular(16),
            color: Colors.green[100],
          ),
          padding: EdgeInsetsMix.symmetric(vertical: 6, horizontal: 12),
        ),
        flex: FlexPropertiesMix(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          gap: 4,
        ),
        label: TextMix(
          style: TextStyleMix(
            color: Colors.green[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconMix(color: Colors.green[600], size: 16),
        trailing: IconMix(color: Colors.green[600], size: 16),
      );

  /// Warning chip variant with orange colors
  static RemixChipStyle get warning => RemixChipStyle(
        container: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: Colors.orange[300]!, width: 1),
            ),
            borderRadius: BorderRadiusMix.circular(16),
            color: Colors.orange[100],
          ),
          padding: EdgeInsetsMix.symmetric(vertical: 6, horizontal: 12),
        ),
        flex: FlexPropertiesMix(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          gap: 4,
        ),
        label: TextMix(
          style: TextStyleMix(
            color: Colors.orange[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconMix(color: Colors.orange[600], size: 16),
        trailing: IconMix(color: Colors.orange[600], size: 16),
      );
}
