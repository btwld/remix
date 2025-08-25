part of 'switch.dart';

class RemixSwitchStyle extends Style<SwitchSpec>
    with
        StyleModifierMixin<RemixSwitchStyle, SwitchSpec>,
        StyleVariantMixin<RemixSwitchStyle, SwitchSpec> {
  final Prop<ContainerSpec>? $container;
  final Prop<ContainerSpec>? $track;
  final Prop<ContainerSpec>? $thumb;

  const RemixSwitchStyle.create({
    Prop<ContainerSpec>? container,
    Prop<ContainerSpec>? track,
    Prop<ContainerSpec>? thumb,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $track = track,
        $thumb = thumb;

  RemixSwitchStyle({
    ContainerSpecMix? container,
    ContainerSpecMix? track,
    ContainerSpecMix? thumb,
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
        container: ContainerSpecMix.maybeValue(spec.container),
        track: ContainerSpecMix.maybeValue(spec.track),
        thumb: ContainerSpecMix.maybeValue(spec.thumb),
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
  container: ContainerSpecMix(),
  track: ContainerSpecMix(
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(RemixTokens.radiusXl()),
      color: RemixTokens.border(),
    ),
    constraints: BoxConstraintsMix(
      minWidth: 44,
      maxWidth: 44,
      minHeight: 24,
      maxHeight: 24,
    ),
  ),
  thumb: ContainerSpecMix(
    decoration: BoxDecorationMix(
      shape: BoxShape.circle,
      color: RemixTokens.background(),
      boxShadow: [
        BoxShadowMix(
          color: RemixTokens.textPrimary().withValues(alpha: 0.2),
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
        container: ContainerSpecMix(),
        track: ContainerSpecMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusXl()),
            color: RemixTokens.primary().withValues(alpha: 0.2),
          ),
          constraints: BoxConstraintsMix(
            minWidth: 44,
            maxWidth: 44,
            minHeight: 24,
            maxHeight: 24,
          ),
        ),
        thumb: ContainerSpecMix(
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: RemixTokens.primary(),
            boxShadow: [
              BoxShadowMix(
                color: RemixTokens.primary().withValues(alpha: 0.3),
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
        container: ContainerSpecMix(),
        track: ContainerSpecMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusXl()),
            color: RemixTokens.surface(),
          ),
          constraints: BoxConstraintsMix(
            minWidth: 44,
            maxWidth: 44,
            minHeight: 24,
            maxHeight: 24,
          ),
        ),
        thumb: ContainerSpecMix(
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: RemixTokens.textSecondary(),
            boxShadow: [
              BoxShadowMix(
                color: RemixTokens.textSecondary().withValues(alpha: 0.3),
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
        container: ContainerSpecMix(),
        track: ContainerSpecMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
            color: RemixTokens.border(),
          ),
          constraints: BoxConstraintsMix(
            minWidth: 36,
            maxWidth: 36,
            minHeight: 20,
            maxHeight: 20,
          ),
        ),
        thumb: ContainerSpecMix(
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: RemixTokens.background(),
            boxShadow: [
              BoxShadowMix(
                color: RemixTokens.textPrimary().withValues(alpha: 0.1),
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
