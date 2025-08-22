part of 'radio.dart';

class RemixRadioStyle extends Style<RadioSpec>
    with
        StyleModifierMixin<RemixRadioStyle, RadioSpec>,
        StyleVariantMixin<RemixRadioStyle, RadioSpec> {
  final Prop<ContainerProperties>? $container;
  final Prop<FlexProperties>? $flex;
  final Prop<ContainerProperties>? $indicatorContainer;
  final Prop<ContainerProperties>? $indicator;
  final Prop<TextSpec>? $label;

  const RemixRadioStyle.create({
    Prop<ContainerProperties>? container,
    Prop<FlexProperties>? flex,
    Prop<ContainerProperties>? indicatorContainer,
    Prop<ContainerProperties>? indicator,
    Prop<TextSpec>? label,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $flex = flex,
        $indicatorContainer = indicatorContainer,
        $indicator = indicator,
        $label = label;

  RemixRadioStyle({
    ContainerPropertiesMix? container,
    FlexPropertiesMix? flex,
    ContainerPropertiesMix? indicatorContainer,
    ContainerPropertiesMix? indicator,
    TextMix? label,
    AnimationConfig? animation,
    List<VariantStyle<RadioSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: container != null ? Prop.mix(container) : null,
          flex: flex != null ? Prop.mix(flex) : null,
          indicatorContainer:
              indicatorContainer != null ? Prop.mix(indicatorContainer) : null,
          indicator: indicator != null ? Prop.mix(indicator) : null,
          label: label != null ? Prop.mix(label) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixRadioStyle.value(RadioSpec spec) => RemixRadioStyle(
        container: ContainerPropertiesMix.maybeValue(spec.container),
        flex: FlexPropertiesMix.maybeValue(spec.flex),
        indicatorContainer:
            ContainerPropertiesMix.maybeValue(spec.indicatorContainer),
        indicator: ContainerPropertiesMix.maybeValue(spec.indicator),
        label: TextMix.maybeValue(spec.label),
      );

  @override
  RemixRadioStyle variant(Variant variant, RemixRadioStyle style) {
    return merge(RemixRadioStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixRadioStyle variants(List<VariantStyle<RadioSpec>> value) {
    return merge(RemixRadioStyle(variants: value));
  }

  @override
  RemixRadioStyle wrap(ModifierConfig value) {
    return merge(RemixRadioStyle(modifier: value));
  }

  @override
  RadioSpec resolve(BuildContext context) {
    return RadioSpec(
      container: MixOps.resolve(context, $container),
      flex: MixOps.resolve(context, $flex),
      indicatorContainer: MixOps.resolve(context, $indicatorContainer),
      indicator: MixOps.resolve(context, $indicator),
      label: MixOps.resolve(context, $label),
    );
  }

  @override
  RemixRadioStyle merge(RemixRadioStyle? other) {
    if (other == null) return this;

    return RemixRadioStyle.create(
      container: MixOps.merge($container, other.$container),
      flex: MixOps.merge($flex, other.$flex),
      indicatorContainer:
          MixOps.merge($indicatorContainer, other.$indicatorContainer),
      indicator: MixOps.merge($indicator, other.$indicator),
      label: MixOps.merge($label, other.$label),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  List<Object?> get props => [
        $container,
        $flex,
        $indicatorContainer,
        $indicator,
        $label,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

final DefaultRemixRadioStyle = RemixRadioStyle(
  container: ContainerPropertiesMix(alignment: Alignment.centerLeft),
  flex: FlexPropertiesMix(
    direction: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    gap: 8,
  ),
  indicatorContainer: ContainerPropertiesMix(
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(BorderSideMix(
        color: Colors.grey[400]!,
        width: 1.5,
      )),
      shape: BoxShape.circle,
      color: Colors.white,
    ),
    alignment: Alignment.center,
    constraints: BoxConstraintsMix(
      minWidth: 20,
      maxWidth: 20,
      minHeight: 20,
      maxHeight: 20,
    ),
  ),
  indicator: ContainerPropertiesMix(
    decoration: BoxDecorationMix(
      shape: BoxShape.circle,
      color: Colors.black,
    ),
    constraints: BoxConstraintsMix(
      minWidth: 10,
      maxWidth: 10,
      minHeight: 10,
      maxHeight: 10,
    ),
  ),
  label: TextMix(style: TextStyleMix(color: Colors.black, fontSize: 14)),
);

extension RadioVariants on RemixRadioStyle {
  /// Primary radio variant with blue colors
  static RemixRadioStyle get primary => RemixRadioStyle(
        container: ContainerPropertiesMix(
          alignment: Alignment.centerLeft,
        ),
        flex: FlexPropertiesMix(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          gap: 8,
        ),
        indicatorContainer: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: Colors.blue[500]!,
              width: 1.5,
            )),
            shape: BoxShape.circle,
            color: Colors.blue[50],
          ),
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 20,
            maxWidth: 20,
            minHeight: 20,
            maxHeight: 20,
          ),
        ),
        indicator: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: Colors.blue[500],
          ),
          constraints: BoxConstraintsMix(
            minWidth: 10,
            maxWidth: 10,
            minHeight: 10,
            maxHeight: 10,
          ),
        ),
        label: TextMix(style: TextStyleMix(color: Colors.black, fontSize: 14)),
      );

  /// Secondary radio variant with grey colors
  static RemixRadioStyle get secondary => RemixRadioStyle(
        container: ContainerPropertiesMix(
          alignment: Alignment.centerLeft,
        ),
        flex: FlexPropertiesMix(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          gap: 8,
        ),
        indicatorContainer: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: Colors.grey[500]!,
              width: 1.5,
            )),
            shape: BoxShape.circle,
            color: Colors.grey[50],
          ),
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 20,
            maxWidth: 20,
            minHeight: 20,
            maxHeight: 20,
          ),
        ),
        indicator: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: Colors.grey[600],
          ),
          constraints: BoxConstraintsMix(
            minWidth: 10,
            maxWidth: 10,
            minHeight: 10,
            maxHeight: 10,
          ),
        ),
        label: TextMix(style: TextStyleMix(color: Colors.black, fontSize: 14)),
      );

  /// Compact radio variant with smaller size
  static RemixRadioStyle get compact => RemixRadioStyle(
        container: ContainerPropertiesMix(
          alignment: Alignment.centerLeft,
        ),
        flex: FlexPropertiesMix(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          gap: 6,
        ),
        indicatorContainer: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: Colors.grey[400]!,
              width: 1.5,
            )),
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 16,
            maxWidth: 16,
            minHeight: 16,
            maxHeight: 16,
          ),
        ),
        indicator: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          constraints: BoxConstraintsMix(
            minWidth: 8,
            maxWidth: 8,
            minHeight: 8,
            maxHeight: 8,
          ),
        ),
        label: TextMix(style: TextStyleMix(color: Colors.black, fontSize: 12)),
      );
}
