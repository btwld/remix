part of 'chip.dart';

class ChipStyle extends Style<ChipSpec> with StyleModifierMixin<ChipStyle, ChipSpec>, StyleVariantMixin<ChipStyle, ChipSpec> {
  final Prop<BoxSpec>? $container;
  final Prop<TextSpec>? $label;
  final Prop<IconSpec>? $leadingIcon;
  final Prop<IconSpec>? $trailingIcon;

  const ChipStyle.create({
    Prop<BoxSpec>? container,
    Prop<TextSpec>? label,
    Prop<IconSpec>? leadingIcon,
    Prop<IconSpec>? trailingIcon,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $label = label,
        $leadingIcon = leadingIcon,
        $trailingIcon = trailingIcon;

  ChipStyle({
    BoxMix? container,
    TextMix? label,
    IconMix? leadingIcon,
    IconMix? trailingIcon,
    AnimationConfig? animation,
    List<VariantStyle<ChipSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: container != null ? Prop.mix(container) : null,
          label: label != null ? Prop.mix(label) : null,
          leadingIcon: leadingIcon != null ? Prop.mix(leadingIcon) : null,
          trailingIcon: trailingIcon != null ? Prop.mix(trailingIcon) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory ChipStyle.value(ChipSpec spec) => ChipStyle(
        container: BoxMix.maybeValue(spec.container),
        label: TextMix.maybeValue(spec.label),
        leadingIcon: IconMix.maybeValue(spec.leadingIcon),
        trailingIcon: IconMix.maybeValue(spec.trailingIcon),
      );

  @override
  ChipSpec resolve(BuildContext context) {
    return ChipSpec(
      container: MixOps.resolve(context, $container),
      label: MixOps.resolve(context, $label),
      leadingIcon: MixOps.resolve(context, $leadingIcon),
      trailingIcon: MixOps.resolve(context, $trailingIcon),
    );
  }

  @override
  ChipStyle merge(ChipStyle? other) {
    if (other == null) return this;

    return ChipStyle.create(
      container: MixOps.merge($container, other.$container),
      label: MixOps.merge($label, other.$label),
      leadingIcon: MixOps.merge($leadingIcon, other.$leadingIcon),
      trailingIcon: MixOps.merge($trailingIcon, other.$trailingIcon),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  ChipStyle variant(Variant variant, ChipStyle style) {
    return merge(ChipStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  ChipStyle variants(List<VariantStyle<ChipSpec>> value) {
    return merge(ChipStyle(variants: value));
  }

  @override
  ChipStyle wrap(ModifierConfig value) {
    return merge(ChipStyle(modifier: value));
  }

  @override
  List<Object?> get props => [
        $container,
        $label,
        $leadingIcon,
        $trailingIcon,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

final DefaultChipStyle = ChipStyle(
  container: BoxMix(
    padding: EdgeInsetsMix.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecorationMix(
      color: Colors.grey[200],
      borderRadius: BorderRadiusMix.circular(16),
    ),
  ),
  label: TextMix(
    style: TextStyleMix(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
  leadingIcon: IconMix(
    size: 16,
  ),
  trailingIcon: IconMix(
    size: 16,
  ),
);