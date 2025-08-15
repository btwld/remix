part of 'progress.dart';

class RemixProgressStyle extends Style<ProgressSpec>
    with StyleModifierMixin<RemixProgressStyle, ProgressSpec>, StyleVariantMixin<RemixProgressStyle, ProgressSpec> {
  final Prop<BoxSpec>? $container;
  final Prop<BoxSpec>? $track;
  final Prop<BoxSpec>? $fill;
  final Prop<BoxSpec>? $outerContainer;

  const RemixProgressStyle.create({
    Prop<BoxSpec>? container,
    Prop<BoxSpec>? track,
    Prop<BoxSpec>? fill,
    Prop<BoxSpec>? outerContainer,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $track = track,
        $fill = fill,
        $outerContainer = outerContainer;

  RemixProgressStyle({
    BoxMix? container,
    BoxMix? track,
    BoxMix? fill,
    BoxMix? outerContainer,
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
        container: BoxMix.maybeValue(spec.container),
        track: BoxMix.maybeValue(spec.track),
        fill: BoxMix.maybeValue(spec.fill),
        outerContainer: BoxMix.maybeValue(spec.outerContainer),
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
  container: BoxMix(
    constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
    decoration: BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
    clipBehavior: Clip.antiAlias,
  ),
  track: BoxMix(decoration: BoxDecorationMix(color: Colors.grey[200])),
  fill: BoxMix(
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(99),
      color: Colors.black,
    ),
  ),
  outerContainer: BoxMix(),
);

extension ProgressVariants on RemixProgressStyle {
  /// Primary progress variant with blue fill
  static RemixProgressStyle get primary => RemixProgressStyle(
        container: BoxMix(
          constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
          decoration: BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
          clipBehavior: Clip.antiAlias,
        ),
        track: BoxMix(decoration: BoxDecorationMix(color: Colors.blue[100])),
        fill: BoxMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: Colors.blue[500],
          ),
        ),
        outerContainer: BoxMix(),
      );

  /// Secondary progress variant with grey fill
  static RemixProgressStyle get secondary => RemixProgressStyle(
        container: BoxMix(
          constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
          decoration: BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
          clipBehavior: Clip.antiAlias,
        ),
        track: BoxMix(decoration: BoxDecorationMix(color: Colors.grey[200])),
        fill: BoxMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: Colors.grey[600],
          ),
        ),
        outerContainer: BoxMix(),
      );

  /// Success progress variant with green fill
  static RemixProgressStyle get success => RemixProgressStyle(
        container: BoxMix(
          constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
          decoration: BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
          clipBehavior: Clip.antiAlias,
        ),
        track: BoxMix(decoration: BoxDecorationMix(color: Colors.green[100])),
        fill: BoxMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: Colors.green[500],
          ),
        ),
        outerContainer: BoxMix(),
      );

  /// Warning progress variant with orange fill
  static RemixProgressStyle get warning => RemixProgressStyle(
        container: BoxMix(
          constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
          decoration: BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
          clipBehavior: Clip.antiAlias,
        ),
        track: BoxMix(decoration: BoxDecorationMix(color: Colors.orange[100])),
        fill: BoxMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: Colors.orange[500],
          ),
        ),
        outerContainer: BoxMix(),
      );
}
