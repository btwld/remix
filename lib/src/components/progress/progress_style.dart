part of 'progress.dart';

class RemixProgressStyle extends Style<ProgressSpec>
    with
        StyleModifierMixin<RemixProgressStyle, ProgressSpec>,
        StyleVariantMixin<RemixProgressStyle, ProgressSpec> {
  final Prop<WidgetSpec<BoxSpec>>? $container;
  final Prop<WidgetSpec<BoxSpec>>? $track;
  final Prop<WidgetSpec<BoxSpec>>? $fill;
  final Prop<WidgetSpec<BoxSpec>>? $outerContainer;

  const RemixProgressStyle.create({
    Prop<WidgetSpec<BoxSpec>>? container,
    Prop<WidgetSpec<BoxSpec>>? track,
    Prop<WidgetSpec<BoxSpec>>? fill,
    Prop<WidgetSpec<BoxSpec>>? outerContainer,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $track = track,
        $fill = fill,
        $outerContainer = outerContainer;

  RemixProgressStyle({
    BoxStyle? container,
    BoxStyle? track,
    BoxStyle? fill,
    BoxStyle? outerContainer,
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
  WidgetSpec<ProgressSpec> resolve(BuildContext context) {
    return WidgetSpec(
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
  container: BoxStyle(
    constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
    decoration: BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
    clipBehavior: Clip.antiAlias,
  ),
  track: BoxStyle(decoration: BoxDecorationMix(color: RemixTokens.surface())),
  fill: BoxStyle(
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(99),
      color: RemixTokens.textPrimary(),
    ),
  ),
  outerContainer: BoxStyle(),
);

extension ProgressVariants on RemixProgressStyle {
  /// Primary progress variant with blue fill
  static RemixProgressStyle get primary => RemixProgressStyle(
        container: BoxStyle(
          constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
          decoration:
              BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
          clipBehavior: Clip.antiAlias,
        ),
        track: BoxStyle(
          decoration: BoxDecorationMix(
            color: RemixTokens.primary().withValues(alpha: 0.2),
          ),
        ),
        fill: BoxStyle(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: RemixTokens.primary(),
          ),
        ),
        outerContainer: BoxStyle(),
      );

  /// Secondary progress variant with grey fill
  static RemixProgressStyle get secondary => RemixProgressStyle(
        container: BoxStyle(
          constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
          decoration:
              BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
          clipBehavior: Clip.antiAlias,
        ),
        track: BoxStyle(
          decoration: BoxDecorationMix(color: RemixTokens.surface()),
        ),
        fill: BoxStyle(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: RemixTokens.textSecondary(),
          ),
        ),
        outerContainer: BoxStyle(),
      );

  /// Success progress variant with green fill
  static RemixProgressStyle get success => RemixProgressStyle(
        container: BoxStyle(
          constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
          decoration:
              BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
          clipBehavior: Clip.antiAlias,
        ),
        track: BoxStyle(
          decoration: BoxDecorationMix(
            color: RemixTokens.success().withValues(alpha: 0.2),
          ),
        ),
        fill: BoxStyle(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: RemixTokens.success(),
          ),
        ),
        outerContainer: BoxStyle(),
      );

  /// Warning progress variant with orange fill
  static RemixProgressStyle get warning => RemixProgressStyle(
        container: BoxStyle(
          constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
          decoration:
              BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
          clipBehavior: Clip.antiAlias,
        ),
        track: BoxStyle(
          decoration: BoxDecorationMix(
            color: RemixTokens.warning().withValues(alpha: 0.2),
          ),
        ),
        fill: BoxStyle(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: RemixTokens.warning(),
          ),
        ),
        outerContainer: BoxStyle(),
      );
}
