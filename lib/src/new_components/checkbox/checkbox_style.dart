part of 'checkbox.dart';

class CheckboxStyle extends Style<CheckboxSpec>
    with
        StyleModifierMixin<CheckboxStyle, CheckboxSpec>,
        StyleVariantMixin<CheckboxStyle, CheckboxSpec> {
  final Prop<BoxSpec>? $container;
  final Prop<BoxSpec>? $indicatorContainer;
  final Prop<IconSpec>? $indicator;
  final Prop<TextSpec>? $label;

  const CheckboxStyle.create({
    Prop<BoxSpec>? container,
    Prop<BoxSpec>? indicatorContainer,
    Prop<IconSpec>? indicator,
    Prop<TextSpec>? label,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $indicatorContainer = indicatorContainer,
        $indicator = indicator,
        $label = label;

  CheckboxStyle({
    BoxMix? container,
    BoxMix? indicatorContainer,
    IconMix? indicator,
    TextMix? label,
    AnimationConfig? animation,
    List<VariantStyle<CheckboxSpec>>? variants,
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

  factory CheckboxStyle.value(CheckboxSpec spec) => CheckboxStyle(
        container: BoxMix.maybeValue(spec.container),
        indicatorContainer: BoxMix.maybeValue(spec.indicatorContainer),
        indicator: IconMix.maybeValue(spec.indicator),
        label: TextMix.maybeValue(spec.label),
      );

  /// Factory for checkbox size (indicator container size)
  factory CheckboxStyle.size(double value) {
    return CheckboxStyle(
      indicatorContainer: BoxMix(
        constraints: BoxConstraintsMix(
          minWidth: value,
          maxWidth: value,
          minHeight: value,
          maxHeight: value,
        ),
      ),
    );
  }

  /// Factory for checkbox background color
  factory CheckboxStyle.color(Color value) {
    return CheckboxStyle(
      indicatorContainer: BoxMix(decoration: BoxDecorationMix(color: value)),
    );
  }

  /// Factory for checkbox border radius
  factory CheckboxStyle.borderRadius(double radius) {
    return CheckboxStyle(
      indicatorContainer: BoxMix(
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.circular(radius),
        ),
      ),
    );
  }

  /// Factory for checkbox border
  factory CheckboxStyle.border(BoxBorderMix value) {
    return CheckboxStyle(
      indicatorContainer: BoxMix(decoration: BoxDecorationMix(border: value)),
    );
  }

  /// Factory for indicator color
  factory CheckboxStyle.indicatorColor(Color value) {
    return CheckboxStyle(indicator: IconMix(color: value));
  }

  /// Factory for label color
  factory CheckboxStyle.labelColor(Color value) {
    return CheckboxStyle(label: TextMix(style: TextStyleMix(color: value)));
  }

  // Instance methods (chainable)

  /// Sets checkbox size
  CheckboxStyle size(double value) {
    return merge(CheckboxStyle.size(value));
  }

  /// Sets checkbox background color
  CheckboxStyle color(Color value) {
    return merge(CheckboxStyle.color(value));
  }

  /// Sets checkbox border radius
  CheckboxStyle borderRadius(double radius) {
    return merge(CheckboxStyle.borderRadius(radius));
  }

  /// Sets checkbox border
  CheckboxStyle border(BoxBorderMix value) {
    return merge(CheckboxStyle.border(value));
  }

  /// Sets indicator color
  CheckboxStyle indicatorColor(Color value) {
    return merge(CheckboxStyle.indicatorColor(value));
  }

  /// Sets label color
  CheckboxStyle labelColor(Color value) {
    return merge(CheckboxStyle.labelColor(value));
  }

  /// Sets animation
  CheckboxStyle animate(AnimationConfig animation) {
    return merge(CheckboxStyle(animation: animation));
  }

  /// Sets variant
  @override
  CheckboxStyle variant(Variant variant, CheckboxStyle style) {
    return merge(CheckboxStyle(variants: [VariantStyle(variant, style)]));
  }
  
  @override
  CheckboxStyle variants(List<VariantStyle<CheckboxSpec>> value) {
    return merge(CheckboxStyle(variants: value));
  }
  
  // Modifier support
  @override
  CheckboxStyle wrap(ModifierConfig value) {
    return merge(CheckboxStyle(modifier: value));
  }

  @override
  CheckboxSpec resolve(BuildContext context) {
    return CheckboxSpec(
      container: MixOps.resolve(context, $container),
      indicatorContainer: MixOps.resolve(context, $indicatorContainer),
      indicator: MixOps.resolve(context, $indicator),
      label: MixOps.resolve(context, $label),
    );
  }

  @override
  CheckboxStyle merge(CheckboxStyle? other) {
    if (other == null) return this;

    return CheckboxStyle.create(
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

final DefaultCheckboxStyle = CheckboxStyle(
  container: BoxMix(alignment: Alignment.centerLeft),
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
      borderRadius: BorderRadiusMix.circular(4),
      color: Colors.white,
    ),
  ),
  indicator: IconMix(color: Colors.black, size: 16),
  label: TextMix(
    style: TextStyleMix(color: Colors.black, fontSize: 14),
  ),
);
