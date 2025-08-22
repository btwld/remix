part of 'switch.dart';

class RemixSwitchStyle extends Style<SwitchSpec>
    with
        StyleModifierMixin<RemixSwitchStyle, SwitchSpec>,
        StyleVariantMixin<RemixSwitchStyle, SwitchSpec> {
  final Prop<WidgetContainerProperties>? $container;
  final Prop<WidgetContainerProperties>? $track;
  final Prop<WidgetContainerProperties>? $thumb;

  const RemixSwitchStyle.create({
    Prop<WidgetContainerProperties>? container,
    Prop<WidgetContainerProperties>? track,
    Prop<WidgetContainerProperties>? thumb,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $track = track,
        $thumb = thumb;

  RemixSwitchStyle({
    WidgetContainerPropertiesMix? container,
    WidgetContainerPropertiesMix? track,
    WidgetContainerPropertiesMix? thumb,
    AnimationConfig? animation,
    List<VariantStyle<SwitchSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: container != null ? Prop.mix(container) : null,
          track: track != null ? Prop.mix(track) : null,
          thumb: thumb != null ? Prop.mix(thumb) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixSwitchStyle.value(SwitchSpec spec) => RemixSwitchStyle(
        container: WidgetContainerPropertiesMix.maybeValue(spec.container),
        track: WidgetContainerPropertiesMix.maybeValue(spec.track),
        thumb: WidgetContainerPropertiesMix.maybeValue(spec.thumb),
      );

  @override
  SwitchSpec resolve(BuildContext context) {
    return SwitchSpec(
      container: MixOps.resolve(context, $container),
      track: MixOps.resolve(context, $track),
      thumb: MixOps.resolve(context, $thumb),
    );
  }

  @override
  RemixSwitchStyle merge(RemixSwitchStyle? other) {
    if (other == null) return this;

    return RemixSwitchStyle.create(
      container: MixOps.merge($container, other.$container),
      track: MixOps.merge($track, other.$track),
      thumb: MixOps.merge($thumb, other.$thumb),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  RemixSwitchStyle variant(Variant variant, RemixSwitchStyle style) {
    return merge(RemixSwitchStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixSwitchStyle variants(List<VariantStyle<SwitchSpec>> value) {
    return merge(RemixSwitchStyle(variants: value));
  }

  @override
  RemixSwitchStyle wrap(ModifierConfig value) {
    return merge(RemixSwitchStyle(modifier: value));
  }

  @override
  List<Object?> get props => [
        $container,
        $track,
        $thumb,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

final DefaultRemixSwitchStyle = RemixSwitchStyle(
  container: WidgetContainerPropertiesMix(),
  track: WidgetContainerPropertiesMix(
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(12),
      color: Colors.grey[300],
    ),
    constraints: BoxConstraintsMix(
      minWidth: 44,
      maxWidth: 44,
      minHeight: 24,
      maxHeight: 24,
    ),
  ),
  thumb: WidgetContainerPropertiesMix(
    decoration: BoxDecorationMix(
      shape: BoxShape.circle,
      color: Colors.white,
      boxShadow: [
        BoxShadowMix(
          color: Colors.black.withValues(alpha: 0.2),
          offset: const Offset(0, 1),
          blurRadius: 2,
        ),
      ],
    ),
    constraints: BoxConstraintsMix(
      minWidth: 20,
      maxWidth: 20,
      minHeight: 20,
      maxHeight: 20,
    ),
  ),
  animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
);

extension SwitchVariants on RemixSwitchStyle {
  /// Primary switch variant with blue colors
  static RemixSwitchStyle get primary => RemixSwitchStyle(
        container: WidgetContainerPropertiesMix(),
        track: WidgetContainerPropertiesMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(12),
            color: Colors.blue[100],
          ),
          constraints: BoxConstraintsMix(
            minWidth: 44,
            maxWidth: 44,
            minHeight: 24,
            maxHeight: 24,
          ),
        ),
        thumb: WidgetContainerPropertiesMix(
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: Colors.blue[500],
            boxShadow: [
              BoxShadowMix(
                color: Colors.blue.withValues(alpha: 0.3),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          constraints: BoxConstraintsMix(
            minWidth: 20,
            maxWidth: 20,
            minHeight: 20,
            maxHeight: 20,
          ),
        ),
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
      );

  /// Secondary switch variant with grey colors
  static RemixSwitchStyle get secondary => RemixSwitchStyle(
        container: WidgetContainerPropertiesMix(),
        track: WidgetContainerPropertiesMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(12),
            color: Colors.grey[200],
          ),
          constraints: BoxConstraintsMix(
            minWidth: 44,
            maxWidth: 44,
            minHeight: 24,
            maxHeight: 24,
          ),
        ),
        thumb: WidgetContainerPropertiesMix(
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: Colors.grey[600],
            boxShadow: [
              BoxShadowMix(
                color: Colors.grey.withValues(alpha: 0.3),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          constraints: BoxConstraintsMix(
            minWidth: 20,
            maxWidth: 20,
            minHeight: 20,
            maxHeight: 20,
          ),
        ),
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
      );

  /// Compact switch variant with smaller size
  static RemixSwitchStyle get compact => RemixSwitchStyle(
        container: WidgetContainerPropertiesMix(),
        track: WidgetContainerPropertiesMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(10),
            color: Colors.grey[300],
          ),
          constraints: BoxConstraintsMix(
            minWidth: 36,
            maxWidth: 36,
            minHeight: 20,
            maxHeight: 20,
          ),
        ),
        thumb: WidgetContainerPropertiesMix(
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadowMix(
                color: Colors.black.withValues(alpha: 0.1),
                offset: const Offset(0, 1),
                blurRadius: 1,
              ),
            ],
          ),
          constraints: BoxConstraintsMix(
            minWidth: 16,
            maxWidth: 16,
            minHeight: 16,
            maxHeight: 16,
          ),
        ),
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
      );
}
