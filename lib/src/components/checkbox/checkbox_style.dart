part of 'checkbox.dart';

class RemixCheckboxStyle extends Style<CheckboxSpec>
    with
        StyleModifierMixin<RemixCheckboxStyle, CheckboxSpec>,
        StyleVariantMixin<RemixCheckboxStyle, CheckboxSpec> {
  final Prop<FlexBoxSpec>? $container;
  final Prop<BoxSpec>? $indicatorContainer;
  final Prop<IconSpec>? $indicator;
  final Prop<TextSpec>? $label;

  const RemixCheckboxStyle.create({
    Prop<FlexBoxSpec>? container,
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

  RemixCheckboxStyle({
    FlexBoxMix? container,
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

  factory RemixCheckboxStyle.value(CheckboxSpec spec) => RemixCheckboxStyle(
        container: FlexBoxMix.maybeValue(spec.container),
        indicatorContainer: BoxMix.maybeValue(spec.indicatorContainer),
        indicator: IconMix.maybeValue(spec.indicator),
        label: TextMix.maybeValue(spec.label),
      );

  /// Factory for checkbox size (indicator container size)
  factory RemixCheckboxStyle.size(double value) {
    return RemixCheckboxStyle(
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
  factory RemixCheckboxStyle.color(Color value) {
    return RemixCheckboxStyle(
      indicatorContainer: BoxMix(decoration: BoxDecorationMix(color: value)),
    );
  }

  /// Factory for checkbox border radius
  factory RemixCheckboxStyle.borderRadius(double radius) {
    return RemixCheckboxStyle(
      indicatorContainer: BoxMix(
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.circular(radius),
        ),
      ),
    );
  }

  /// Factory for checkbox border
  factory RemixCheckboxStyle.border(BoxBorderMix value) {
    return RemixCheckboxStyle(
      indicatorContainer: BoxMix(decoration: BoxDecorationMix(border: value)),
    );
  }

  /// Factory for indicator color
  factory RemixCheckboxStyle.indicatorColor(Color value) {
    return RemixCheckboxStyle(indicator: IconMix(color: value));
  }

  /// Factory for label color
  factory RemixCheckboxStyle.labelColor(Color value) {
    return RemixCheckboxStyle(label: TextMix(style: TextStyleMix(color: value)));
  }

  // Instance methods (chainable)

  /// Sets checkbox size
  RemixCheckboxStyle size(double value) {
    return merge(RemixCheckboxStyle.size(value));
  }

  /// Sets checkbox background color
  RemixCheckboxStyle color(Color value) {
    return merge(RemixCheckboxStyle.color(value));
  }

  /// Sets checkbox border radius
  RemixCheckboxStyle borderRadius(double radius) {
    return merge(RemixCheckboxStyle.borderRadius(radius));
  }

  /// Sets checkbox border
  RemixCheckboxStyle border(BoxBorderMix value) {
    return merge(RemixCheckboxStyle.border(value));
  }

  /// Sets indicator color
  RemixCheckboxStyle indicatorColor(Color value) {
    return merge(RemixCheckboxStyle.indicatorColor(value));
  }

  /// Sets label color
  RemixCheckboxStyle labelColor(Color value) {
    return merge(RemixCheckboxStyle.labelColor(value));
  }

  /// Sets animation
  RemixCheckboxStyle animate(AnimationConfig animation) {
    return merge(RemixCheckboxStyle(animation: animation));
  }

  /// Sets variant
  @override
  RemixCheckboxStyle variant(Variant variant, RemixCheckboxStyle style) {
    return merge(RemixCheckboxStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixCheckboxStyle variants(List<VariantStyle<CheckboxSpec>> value) {
    return merge(RemixCheckboxStyle(variants: value));
  }

  // Modifier support
  @override
  RemixCheckboxStyle wrap(ModifierConfig value) {
    return merge(RemixCheckboxStyle(modifier: value));
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
  RemixCheckboxStyle merge(RemixCheckboxStyle? other) {
    if (other == null) return this;

    return RemixCheckboxStyle.create(
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

final DefaultRemixCheckboxStyle = RemixCheckboxStyle(
  container: FlexBoxMix(
    box: BoxMix(alignment: Alignment.centerLeft),
    flex: FlexMix(
      direction: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      gap: 8,
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
      borderRadius: BorderRadiusMix.circular(4),
      color: Colors.white,
    ),
  ),
  indicator: IconMix(color: Colors.black, size: 16),
  label: TextMix(style: TextStyleMix(color: Colors.black, fontSize: 14)),
);

extension CheckboxVariants on RemixCheckboxStyle {
  /// Primary checkbox variant with blue colors
  static RemixCheckboxStyle get primary => RemixCheckboxStyle(
        container: FlexBoxMix(
          box: BoxMix(alignment: Alignment.centerLeft),
          flex: FlexMix(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            gap: 8,
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
            borderRadius: BorderRadiusMix.circular(4),
            color: Colors.blue[50],
          ),
        ),
        indicator: IconMix(color: Colors.blue[500], size: 16),
        label: TextMix(
          style: TextStyleMix(color: Colors.black, fontSize: 14),
        ),
      );

  /// Secondary checkbox variant with grey colors
  static RemixCheckboxStyle get secondary => RemixCheckboxStyle(
        container: FlexBoxMix(
          box: BoxMix(alignment: Alignment.centerLeft),
          flex: FlexMix(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            gap: 8,
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
            borderRadius: BorderRadiusMix.circular(4),
            color: Colors.grey[50],
          ),
        ),
        indicator: IconMix(color: Colors.grey[600], size: 16),
        label: TextMix(
          style: TextStyleMix(color: Colors.black, fontSize: 14),
        ),
      );

  /// Compact checkbox variant with smaller size
  static RemixCheckboxStyle get compact => RemixCheckboxStyle(
        container: FlexBoxMix(
          box: BoxMix(alignment: Alignment.centerLeft),
          flex: FlexMix(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            gap: 6,
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
            borderRadius: BorderRadiusMix.circular(3),
            color: Colors.white,
          ),
        ),
        indicator: IconMix(color: Colors.black, size: 12),
        label: TextMix(
          style: TextStyleMix(color: Colors.black, fontSize: 12),
        ),
      );
}
