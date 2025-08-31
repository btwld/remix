part of 'progress.dart';

class RemixProgressStyle extends Style<ProgressSpec>
    with
        StyleModifierMixin<RemixProgressStyle, ProgressSpec>,
        StyleVariantMixin<RemixProgressStyle, ProgressSpec> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<BoxSpec>>? $track;
  final Prop<StyleSpec<BoxSpec>>? $fill;
  final Prop<StyleSpec<BoxSpec>>? $outerContainer;

  const RemixProgressStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<BoxSpec>>? track,
    Prop<StyleSpec<BoxSpec>>? fill,
    Prop<StyleSpec<BoxSpec>>? outerContainer,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $track = track,
        $fill = fill,
        $outerContainer = outerContainer;

  RemixProgressStyle({
    BoxStyler? container,
    BoxStyler? track,
    BoxStyler? fill,
    BoxStyler? outerContainer,
    AnimationConfig? animation,
    List<VariantStyle<ProgressSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          track: Prop.maybeMix(track),
          fill: Prop.maybeMix(fill),
          outerContainer: Prop.maybeMix(outerContainer),
          variants: variants,
          animation: animation,
          modifier: modifier,
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
  StyleSpec<ProgressSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: ProgressSpec(
        container: MixOps.resolve(context, $container),
        track: MixOps.resolve(context, $track),
        fill: MixOps.resolve(context, $fill),
        outerContainer: MixOps.resolve(context, $outerContainer),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
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
      ];
}

final DefaultRemixProgressStyle = RemixProgressStyle(
  container: BoxStyler(
    constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
    decoration: BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
    clipBehavior: Clip.antiAlias,
  ),
  track: BoxStyler(decoration: BoxDecorationMix(color: RemixTokens.surface())),
  fill: BoxStyler(
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(99),
      color: RemixTokens.textPrimary(),
    ),
  ),
  outerContainer: BoxStyler(),
);

extension ProgressVariants on RemixProgressStyle {
  /// Primary progress variant with blue fill
  static RemixProgressStyle get primary => RemixProgressStyle(
        container: BoxStyler(
          constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
          decoration:
              BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
          clipBehavior: Clip.antiAlias,
        ),
        track: BoxStyler(
          decoration: BoxDecorationMix(
            color: RemixTokens.primary().withValues(alpha: 0.2),
          ),
        ),
        fill: BoxStyler(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: RemixTokens.primary(),
          ),
        ),
        outerContainer: BoxStyler(),
      );

  /// Secondary progress variant with grey fill
  static RemixProgressStyle get secondary => RemixProgressStyle(
        container: BoxStyler(
          constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
          decoration:
              BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
          clipBehavior: Clip.antiAlias,
        ),
        track: BoxStyler(
          decoration: BoxDecorationMix(color: RemixTokens.surface()),
        ),
        fill: BoxStyler(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: RemixTokens.textSecondary(),
          ),
        ),
        outerContainer: BoxStyler(),
      );

  /// Success progress variant with green fill
  static RemixProgressStyle get success => RemixProgressStyle(
        container: BoxStyler(
          constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
          decoration:
              BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
          clipBehavior: Clip.antiAlias,
        ),
        track: BoxStyler(
          decoration: BoxDecorationMix(
            color: RemixTokens.success().withValues(alpha: 0.2),
          ),
        ),
        fill: BoxStyler(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: RemixTokens.success(),
          ),
        ),
        outerContainer: BoxStyler(),
      );

  /// Warning progress variant with orange fill
  static RemixProgressStyle get warning => RemixProgressStyle(
        container: BoxStyler(
          constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
          decoration:
              BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
          clipBehavior: Clip.antiAlias,
        ),
        track: BoxStyler(
          decoration: BoxDecorationMix(
            color: RemixTokens.warning().withValues(alpha: 0.2),
          ),
        ),
        fill: BoxStyler(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: RemixTokens.warning(),
          ),
        ),
        outerContainer: BoxStyler(),
      );
}
