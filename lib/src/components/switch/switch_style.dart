part of 'switch.dart';

class RemixSwitchStyle extends Style<SwitchSpec>
    with
        StyleModifierMixin<RemixSwitchStyle, SwitchSpec>,
        StyleVariantMixin<RemixSwitchStyle, SwitchSpec> {
  final Prop<BoxSpec>? $container;
  final Prop<BoxSpec>? $track;
  final Prop<BoxSpec>? $thumb;

  const RemixSwitchStyle.create({
    Prop<BoxSpec>? container,
    Prop<BoxSpec>? track,
    Prop<BoxSpec>? thumb,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $track = track,
        $thumb = thumb;

  RemixSwitchStyle({
    BoxMix? container,
    BoxMix? track,
    BoxMix? thumb,
    AnimationConfig? animation,
    List<VariantStyle<SwitchSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: Prop.maybeMix(container),
          track: Prop.maybeMix(track),
          thumb: Prop.maybeMix(thumb),
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixSwitchStyle.value(SwitchSpec spec) => RemixSwitchStyle(
        container: BoxMix.maybeValue(spec.container),
        track: BoxMix.maybeValue(spec.track),
        thumb: BoxMix.maybeValue(spec.thumb),
      );

  @override
  WidgetSpec<SwitchSpec> resolve(BuildContext context) {
    return WidgetSpec(
      spec: SwitchSpec(
        container: MixOps.resolve(context, $container),
        track: MixOps.resolve(context, $track),
        thumb: MixOps.resolve(context, $thumb),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
      inherit: $inherit,
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
  container: BoxMix(),
  track: BoxMix(
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
  thumb: BoxMix(
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
        container: BoxMix(),
        track: BoxMix(
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
        thumb: BoxMix(
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
        container: BoxMix(),
        track: BoxMix(
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
        thumb: BoxMix(
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
        container: BoxMix(),
        track: BoxMix(
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
        thumb: BoxMix(
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
