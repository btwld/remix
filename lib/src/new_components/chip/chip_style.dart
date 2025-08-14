part of 'chip.dart';

class ChipStyle extends Style<ChipSpec> with StyleModifierMixin<ChipStyle, ChipSpec>, StyleVariantMixin<ChipStyle, ChipSpec> {
  final Prop<FlexBoxSpec>? $container;
  final Prop<TextSpec>? $label;
  final Prop<IconSpec>? $leadingIcon;
  final Prop<IconSpec>? $trailingIcon;

  const ChipStyle.create({
    Prop<FlexBoxSpec>? container,
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
    FlexBoxMix? container,
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
        container: FlexBoxMix.maybeValue(spec.container),
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
  container: FlexBoxMix(
    box: BoxMix(
      padding: EdgeInsetsMix.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecorationMix(
        color: Colors.grey[200],
        borderRadius: BorderRadiusMix.circular(16),
      ),
    ),
    flex: FlexMix(
      direction: Axis.horizontal,
      gap: 4,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
    ),
  ),
  label: TextMix(
    style: TextStyleMix(
      fontSize: 14,
      fontWeight: FontWeight.w500
    )
  ),
  leadingIcon: IconMix(
    size: 16
  ),
  trailingIcon: IconMix(
    size: 16
  )
);

extension ChipVariants on ChipStyle {
  /// Primary chip variant with blue colors
  static ChipStyle get primary => ChipStyle(
        container: FlexBoxMix(
          box: BoxMix(
            padding: EdgeInsetsMix.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecorationMix(
              color: Colors.blue[100],
              borderRadius: BorderRadiusMix.circular(16),
              border: BoxBorderMix.all(
                BorderSideMix(color: Colors.blue[300]!, width: 1),
              ),
            ),
          ),
          flex: FlexMix(
            direction: Axis.horizontal,
            gap: 4,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ),
        label: TextMix(
          style: TextStyleMix(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.blue[700],
          ),
        ),
        leadingIcon: IconMix(
          size: 16,
          color: Colors.blue[600],
        ),
        trailingIcon: IconMix(
          size: 16,
          color: Colors.blue[600],
        ),
      );

  /// Secondary chip variant with grey colors
  static ChipStyle get secondary => ChipStyle(
        container: FlexBoxMix(
          box: BoxMix(
            padding: EdgeInsetsMix.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecorationMix(
              color: Colors.grey[100],
              borderRadius: BorderRadiusMix.circular(16),
              border: BoxBorderMix.all(
                BorderSideMix(color: Colors.grey[400]!, width: 1),
              ),
            ),
          ),
          flex: FlexMix(
            direction: Axis.horizontal,
            gap: 4,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ),
        label: TextMix(
          style: TextStyleMix(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        leadingIcon: IconMix(
          size: 16,
          color: Colors.grey[600],
        ),
        trailingIcon: IconMix(
          size: 16,
          color: Colors.grey[600],
        ),
      );

  /// Success chip variant with green colors
  static ChipStyle get success => ChipStyle(
        container: FlexBoxMix(
          box: BoxMix(
            padding: EdgeInsetsMix.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecorationMix(
              color: Colors.green[100],
              borderRadius: BorderRadiusMix.circular(16),
              border: BoxBorderMix.all(
                BorderSideMix(color: Colors.green[300]!, width: 1),
              ),
            ),
          ),
          flex: FlexMix(
            direction: Axis.horizontal,
            gap: 4,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ),
        label: TextMix(
          style: TextStyleMix(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.green[700],
          ),
        ),
        leadingIcon: IconMix(
          size: 16,
          color: Colors.green[600],
        ),
        trailingIcon: IconMix(
          size: 16,
          color: Colors.green[600],
        ),
      );

  /// Warning chip variant with orange colors
  static ChipStyle get warning => ChipStyle(
        container: FlexBoxMix(
          box: BoxMix(
            padding: EdgeInsetsMix.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecorationMix(
              color: Colors.orange[100],
              borderRadius: BorderRadiusMix.circular(16),
              border: BoxBorderMix.all(
                BorderSideMix(color: Colors.orange[300]!, width: 1),
              ),
            ),
          ),
          flex: FlexMix(
            direction: Axis.horizontal,
            gap: 4,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ),
        label: TextMix(
          style: TextStyleMix(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.orange[700],
          ),
        ),
        leadingIcon: IconMix(
          size: 16,
          color: Colors.orange[600],
        ),
        trailingIcon: IconMix(
          size: 16,
          color: Colors.orange[600],
        ),
      );
}