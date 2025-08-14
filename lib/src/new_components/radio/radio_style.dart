part of 'radio.dart';

class RadioStyle extends Style<RadioSpec>
    with StyleModifierMixin<RadioStyle, RadioSpec>, StyleVariantMixin<RadioStyle, RadioSpec> {
  final Prop<FlexBoxSpec>? $container;
  final Prop<BoxSpec>? $indicatorContainer;
  final Prop<BoxSpec>? $indicator;
  final Prop<TextSpec>? $label;

  const RadioStyle.create({
    Prop<FlexBoxSpec>? container,
    Prop<BoxSpec>? indicatorContainer,
    Prop<BoxSpec>? indicator,
    Prop<TextSpec>? label,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $indicatorContainer = indicatorContainer,
        $indicator = indicator,
        $label = label;

  RadioStyle({
    FlexBoxMix? container,
    BoxMix? indicatorContainer,
    BoxMix? indicator,
    TextMix? label,
    AnimationConfig? animation,
    List<VariantStyle<RadioSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: container != null ? Prop.mix(container) : null,
          indicatorContainer:
              indicatorContainer != null ? Prop.mix(indicatorContainer) : null,
          indicator: indicator != null ? Prop.mix(indicator) : null,
          label: label != null ? Prop.mix(label) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RadioStyle.value(RadioSpec spec) => RadioStyle(
        container: FlexBoxMix.maybeValue(spec.container),
        indicatorContainer: BoxMix.maybeValue(spec.indicatorContainer),
        indicator: BoxMix.maybeValue(spec.indicator),
        label: TextMix.maybeValue(spec.label),
      );

  @override
  RadioStyle variant(Variant variant, RadioStyle style) {
    return merge(RadioStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RadioStyle variants(List<VariantStyle<RadioSpec>> value) {
    return merge(RadioStyle(variants: value));
  }

  @override
  RadioStyle wrap(ModifierConfig value) {
    return merge(RadioStyle(modifier: value));
  }

  @override
  RadioSpec resolve(BuildContext context) {
    return RadioSpec(
      container: MixOps.resolve(context, $container),
      indicatorContainer: MixOps.resolve(context, $indicatorContainer),
      indicator: MixOps.resolve(context, $indicator),
      label: MixOps.resolve(context, $label),
    );
  }

  @override
  RadioStyle merge(RadioStyle? other) {
    if (other == null) return this;

    return RadioStyle.create(
      container: MixOps.merge($container, other.$container),
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
        $indicatorContainer,
        $indicator,
        $label,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

final DefaultRadioStyle = RadioStyle(
  container: FlexBoxMix(
    box: BoxMix(alignment: Alignment.centerLeft),
    flex: FlexMix(
      direction: Axis.horizontal,
      gap: 8,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
    ),
  ),
  indicatorContainer: BoxMix(
    alignment: Alignment.center,
    constraints: BoxConstraintsMix(
      minWidth: 20,
      maxWidth: 20,
      minHeight: 20,
      maxHeight: 20,
    ),
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(BorderSideMix(
        color: Colors.grey[400]!,
        width: 1.5,
      )),
      shape: BoxShape.circle,
      color: Colors.white,
    ),
  ),
  indicator: BoxMix(
    constraints: BoxConstraintsMix(
      minWidth: 10,
      maxWidth: 10,
      minHeight: 10,
      maxHeight: 10,
    ),
    decoration: BoxDecorationMix(
      shape: BoxShape.circle,
      color: Colors.black,
    ),
  ),
  label: TextMix(style: TextStyleMix(color: Colors.black, fontSize: 14)),
);

extension RadioVariants on RadioStyle {
  /// Primary radio variant with blue colors
  static RadioStyle get primary => RadioStyle(
        container: FlexBoxMix(
          box: BoxMix(alignment: Alignment.centerLeft),
          flex: FlexMix(
            direction: Axis.horizontal,
            gap: 8,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ),
        indicatorContainer: BoxMix(
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 20,
            maxWidth: 20,
            minHeight: 20,
            maxHeight: 20,
          ),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: Colors.blue[500]!,
              width: 1.5,
            )),
            shape: BoxShape.circle,
            color: Colors.blue[50],
          ),
        ),
        indicator: BoxMix(
          constraints: BoxConstraintsMix(
            minWidth: 10,
            maxWidth: 10,
            minHeight: 10,
            maxHeight: 10,
          ),
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: Colors.blue[500],
          ),
        ),
        label: TextMix(style: TextStyleMix(color: Colors.black, fontSize: 14)),
      );

  /// Secondary radio variant with grey colors
  static RadioStyle get secondary => RadioStyle(
        container: FlexBoxMix(
          box: BoxMix(alignment: Alignment.centerLeft),
          flex: FlexMix(
            direction: Axis.horizontal,
            gap: 8,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ),
        indicatorContainer: BoxMix(
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 20,
            maxWidth: 20,
            minHeight: 20,
            maxHeight: 20,
          ),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: Colors.grey[500]!,
              width: 1.5,
            )),
            shape: BoxShape.circle,
            color: Colors.grey[50],
          ),
        ),
        indicator: BoxMix(
          constraints: BoxConstraintsMix(
            minWidth: 10,
            maxWidth: 10,
            minHeight: 10,
            maxHeight: 10,
          ),
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: Colors.grey[600],
          ),
        ),
        label: TextMix(style: TextStyleMix(color: Colors.black, fontSize: 14)),
      );

  /// Compact radio variant with smaller size
  static RadioStyle get compact => RadioStyle(
        container: FlexBoxMix(
          box: BoxMix(alignment: Alignment.centerLeft),
          flex: FlexMix(
            direction: Axis.horizontal,
            gap: 6,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ),
        indicatorContainer: BoxMix(
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 16,
            maxWidth: 16,
            minHeight: 16,
            maxHeight: 16,
          ),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: Colors.grey[400]!,
              width: 1.5,
            )),
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
        indicator: BoxMix(
          constraints: BoxConstraintsMix(
            minWidth: 8,
            maxWidth: 8,
            minHeight: 8,
            maxHeight: 8,
          ),
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
        ),
        label: TextMix(style: TextStyleMix(color: Colors.black, fontSize: 12)),
      );
}
