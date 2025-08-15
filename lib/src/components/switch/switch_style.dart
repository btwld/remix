part of 'switch.dart';

class SwitchStyle extends Style<SwitchSpec>
    with
        StyleModifierMixin<SwitchStyle, SwitchSpec>,
        StyleVariantMixin<SwitchStyle, SwitchSpec> {
  final Prop<BoxSpec>? $container;
  final Prop<BoxSpec>? $track;
  final Prop<BoxSpec>? $thumb;

  const SwitchStyle.create({
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

  SwitchStyle({
    BoxMix? container,
    BoxMix? track,
    BoxMix? thumb,
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

  factory SwitchStyle.value(SwitchSpec spec) => SwitchStyle(
        container: BoxMix.maybeValue(spec.container),
        track: BoxMix.maybeValue(spec.track),
        thumb: BoxMix.maybeValue(spec.thumb),
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
  SwitchStyle merge(SwitchStyle? other) {
    if (other == null) return this;

    return SwitchStyle.create(
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
  SwitchStyle variant(Variant variant, SwitchStyle style) {
    return merge(SwitchStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  SwitchStyle variants(List<VariantStyle<SwitchSpec>> value) {
    return merge(SwitchStyle(variants: value));
  }

  @override
  SwitchStyle wrap(ModifierConfig value) {
    return merge(SwitchStyle(modifier: value));
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

final DefaultSwitchStyle = SwitchStyle(
  container: BoxMix(),
  track: BoxMix(
    constraints: BoxConstraintsMix(
      minWidth: 44,
      maxWidth: 44,
      minHeight: 24,
      maxHeight: 24,
    ),
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(12),
      color: Colors.grey[300],
    ),
  ),
  thumb: BoxMix(
    constraints: BoxConstraintsMix(
      minWidth: 20,
      maxWidth: 20,
      minHeight: 20,
      maxHeight: 20,
    ),
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
  ),
  animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
);

extension SwitchVariants on SwitchStyle {
  /// Primary switch variant with blue colors
  static SwitchStyle get primary => SwitchStyle(
        container: BoxMix(),
        track: BoxMix(
          constraints: BoxConstraintsMix(
            minWidth: 44,
            maxWidth: 44,
            minHeight: 24,
            maxHeight: 24,
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(12),
            color: Colors.blue[100],
          ),
        ),
        thumb: BoxMix(
          constraints: BoxConstraintsMix(
            minWidth: 20,
            maxWidth: 20,
            minHeight: 20,
            maxHeight: 20,
          ),
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
        ),
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
      );

  /// Secondary switch variant with grey colors
  static SwitchStyle get secondary => SwitchStyle(
        container: BoxMix(),
        track: BoxMix(
          constraints: BoxConstraintsMix(
            minWidth: 44,
            maxWidth: 44,
            minHeight: 24,
            maxHeight: 24,
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(12),
            color: Colors.grey[200],
          ),
        ),
        thumb: BoxMix(
          constraints: BoxConstraintsMix(
            minWidth: 20,
            maxWidth: 20,
            minHeight: 20,
            maxHeight: 20,
          ),
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
        ),
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
      );

  /// Compact switch variant with smaller size
  static SwitchStyle get compact => SwitchStyle(
        container: BoxMix(),
        track: BoxMix(
          constraints: BoxConstraintsMix(
            minWidth: 36,
            maxWidth: 36,
            minHeight: 20,
            maxHeight: 20,
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(10),
            color: Colors.grey[300],
          ),
        ),
        thumb: BoxMix(
          constraints: BoxConstraintsMix(
            minWidth: 16,
            maxWidth: 16,
            minHeight: 16,
            maxHeight: 16,
          ),
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
        ),
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
      );
}
