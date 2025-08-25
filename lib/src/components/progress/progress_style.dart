part of 'progress.dart';

class RemixProgressStyle extends Style<ProgressSpec>
    with
        StyleModifierMixin<RemixProgressStyle, ProgressSpec>,
        StyleVariantMixin<RemixProgressStyle, ProgressSpec> {
  final Prop<ContainerSpec>? $container;
  final Prop<ContainerSpec>? $track;
  final Prop<ContainerSpec>? $fill;
  final Prop<ContainerSpec>? $outerContainer;

  const RemixProgressStyle.create({
    Prop<ContainerSpec>? container,
    Prop<ContainerSpec>? track,
    Prop<ContainerSpec>? fill,
    Prop<ContainerSpec>? outerContainer,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $track = track,
        $fill = fill,
        $outerContainer = outerContainer;

  RemixProgressStyle({
    ContainerSpecMix? container,
    ContainerSpecMix? track,
    ContainerSpecMix? fill,
    ContainerSpecMix? outerContainer,
    AnimationConfig? animation,
    List<VariantStyle<ProgressSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: container != null ? Prop.mix(container) : null,
          track: track != null ? Prop.mix(track) : null,
          fill: fill != null ? Prop.mix(fill) : null,
          outerContainer:
              outerContainer != null ? Prop.mix(outerContainer) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixProgressStyle.value(ProgressSpec spec) => RemixProgressStyle(
        container: ContainerSpecMix.maybeValue(spec.container),
        track: ContainerSpecMix.maybeValue(spec.track),
        fill: ContainerSpecMix.maybeValue(spec.fill),
        outerContainer:
            ContainerSpecMix.maybeValue(spec.outerContainer),
      );

  @override
  RemixProgressStyle variant(Variant variant, RemixProgressStyle style) {
    return merge(RemixProgressStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixProgressStyle variants(List<VariantStyle<ProgressSpec>> value) {
    return merge(RemixProgressStyle(variants: value));
  }

  @override
  RemixProgressStyle wrap(ModifierConfig value) {
    return merge(RemixProgressStyle(modifier: value));
  }

  @override
  ProgressSpec resolve(BuildContext context) {
    return ProgressSpec(
      container: MixOps.resolve(context, $container),
      track: MixOps.resolve(context, $track),
      fill: MixOps.resolve(context, $fill),
      outerContainer: MixOps.resolve(context, $outerContainer),
    );
  }

  @override
  RemixProgressStyle merge(RemixProgressStyle? other) {
    if (other == null) return this;

    return RemixProgressStyle.create(
      container: MixOps.merge($container, other.$container),
      track: MixOps.merge($track, other.$track),
      fill: MixOps.merge($fill, other.$fill),
      outerContainer: MixOps.merge($outerContainer, other.$outerContainer),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  List<Object?> get props => [
        $container,
        $track,
        $fill,
        $outerContainer,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

final DefaultRemixProgressStyle = RemixProgressStyle(
  container: ContainerSpecMix(
    decoration: BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
    constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
    clipBehavior: Clip.antiAlias,
  ),
  track: ContainerSpecMix(
    decoration: BoxDecorationMix(color: RemixTokens.surface()),
  ),
  fill: ContainerSpecMix(
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(99),
      color: RemixTokens.textPrimary(),
    ),
  ),
  outerContainer: ContainerSpecMix(),
);

extension ProgressVariants on RemixProgressStyle {
  /// Primary progress variant with blue fill
  static RemixProgressStyle get primary => RemixProgressStyle(
        container: ContainerSpecMix(
          decoration:
              BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
          constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
          clipBehavior: Clip.antiAlias,
        ),
        track: ContainerSpecMix(
          decoration: BoxDecorationMix(color: RemixTokens.primary().withValues(alpha: 0.2)),
        ),
        fill: ContainerSpecMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: RemixTokens.primary(),
          ),
        ),
        outerContainer: ContainerSpecMix(),
      );

  /// Secondary progress variant with grey fill
  static RemixProgressStyle get secondary => RemixProgressStyle(
        container: ContainerSpecMix(
          decoration:
              BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
          constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
          clipBehavior: Clip.antiAlias,
        ),
        track: ContainerSpecMix(
          decoration: BoxDecorationMix(color: RemixTokens.surface()),
        ),
        fill: ContainerSpecMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: RemixTokens.textSecondary(),
          ),
        ),
        outerContainer: ContainerSpecMix(),
      );

  /// Success progress variant with green fill
  static RemixProgressStyle get success => RemixProgressStyle(
        container: ContainerSpecMix(
          decoration:
              BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
          constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
          clipBehavior: Clip.antiAlias,
        ),
        track: ContainerSpecMix(
          decoration: BoxDecorationMix(color: RemixTokens.success().withValues(alpha: 0.2)),
        ),
        fill: ContainerSpecMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: RemixTokens.success(),
          ),
        ),
        outerContainer: ContainerSpecMix(),
      );

  /// Warning progress variant with orange fill
  static RemixProgressStyle get warning => RemixProgressStyle(
        container: ContainerSpecMix(
          decoration:
              BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
          constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
          clipBehavior: Clip.antiAlias,
        ),
        track: ContainerSpecMix(
          decoration: BoxDecorationMix(color: RemixTokens.warning().withValues(alpha: 0.2)),
        ),
        fill: ContainerSpecMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: RemixTokens.warning(),
          ),
        ),
        outerContainer: ContainerSpecMix(),
      );
}
