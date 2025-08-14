part of 'progress.dart';

class ProgressStyle extends Style<ProgressSpec>
    with StyleModifierMixin<ProgressStyle, ProgressSpec>, StyleVariantMixin<ProgressStyle, ProgressSpec> {
  final Prop<BoxSpec>? $container;
  final Prop<BoxSpec>? $track;
  final Prop<BoxSpec>? $fill;
  final Prop<BoxSpec>? $outerContainer;

  const ProgressStyle.create({
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

  ProgressStyle({
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

  factory ProgressStyle.value(ProgressSpec spec) => ProgressStyle(
        container: BoxMix.maybeValue(spec.container),
        track: BoxMix.maybeValue(spec.track),
        fill: BoxMix.maybeValue(spec.fill),
        outerContainer: BoxMix.maybeValue(spec.outerContainer),
      );

  @override
  ProgressStyle variant(Variant variant, ProgressStyle style) {
    return merge(ProgressStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  ProgressStyle variants(List<VariantStyle<ProgressSpec>> value) {
    return merge(ProgressStyle(variants: value));
  }

  @override
  ProgressStyle wrap(ModifierConfig value) {
    return merge(ProgressStyle(modifier: value));
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
  ProgressStyle merge(ProgressStyle? other) {
    if (other == null) return this;

    return ProgressStyle.create(
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

final DefaultProgressStyle = ProgressStyle(
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

extension ProgressVariants on ProgressStyle {
  /// Primary progress variant with blue fill
  static ProgressStyle get primary => ProgressStyle(
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
  static ProgressStyle get secondary => ProgressStyle(
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
  static ProgressStyle get success => ProgressStyle(
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
  static ProgressStyle get warning => ProgressStyle(
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
