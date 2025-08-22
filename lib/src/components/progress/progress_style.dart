part of 'progress.dart';

class RemixProgressStyle extends Style<ProgressSpec>
    with StyleModifierMixin<RemixProgressStyle, ProgressSpec>, StyleVariantMixin<RemixProgressStyle, ProgressSpec> {
  final Prop<WidgetContainerProperties>? $container;
  final Prop<WidgetContainerProperties>? $track;
  final Prop<WidgetContainerProperties>? $fill;
  final Prop<WidgetContainerProperties>? $outerContainer;

  const RemixProgressStyle.create({
    Prop<WidgetContainerProperties>? container,
    Prop<WidgetContainerProperties>? track,
    Prop<WidgetContainerProperties>? fill,
    Prop<WidgetContainerProperties>? outerContainer,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $track = track,
        $fill = fill,
        $outerContainer = outerContainer;

  RemixProgressStyle({
    WidgetContainerPropertiesMix? container,
    WidgetContainerPropertiesMix? track,
    WidgetContainerPropertiesMix? fill,
    WidgetContainerPropertiesMix? outerContainer,
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
        container: WidgetContainerPropertiesMix.maybeValue(spec.container),
        track: WidgetContainerPropertiesMix.maybeValue(spec.track),
        fill: WidgetContainerPropertiesMix.maybeValue(spec.fill),
        outerContainer: WidgetContainerPropertiesMix.maybeValue(spec.outerContainer),
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
  container: WidgetContainerPropertiesMix(
    constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
    decoration: BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
    clipBehavior: Clip.antiAlias,
  ),
  track: WidgetContainerPropertiesMix(decoration: BoxDecorationMix(color: Colors.grey[200])),
  fill: WidgetContainerPropertiesMix(
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(99),
      color: Colors.black,
    ),
  ),
  outerContainer: WidgetContainerPropertiesMix(),
);

extension ProgressVariants on RemixProgressStyle {
  /// Primary progress variant with blue fill
  static RemixProgressStyle get primary => RemixProgressStyle(
        container: WidgetContainerPropertiesMix(
          constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
          decoration: BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
          clipBehavior: Clip.antiAlias,
        ),
        track: WidgetContainerPropertiesMix(decoration: BoxDecorationMix(color: Colors.blue[100])),
        fill: WidgetContainerPropertiesMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: Colors.blue[500],
          ),
        ),
        outerContainer: WidgetContainerPropertiesMix(),
      );

  /// Secondary progress variant with grey fill
  static RemixProgressStyle get secondary => RemixProgressStyle(
        container: WidgetContainerPropertiesMix(
          constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
          decoration: BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
          clipBehavior: Clip.antiAlias,
        ),
        track: WidgetContainerPropertiesMix(decoration: BoxDecorationMix(color: Colors.grey[200])),
        fill: WidgetContainerPropertiesMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: Colors.grey[600],
          ),
        ),
        outerContainer: WidgetContainerPropertiesMix(),
      );

  /// Success progress variant with green fill
  static RemixProgressStyle get success => RemixProgressStyle(
        container: WidgetContainerPropertiesMix(
          constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
          decoration: BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
          clipBehavior: Clip.antiAlias,
        ),
        track: WidgetContainerPropertiesMix(decoration: BoxDecorationMix(color: Colors.green[100])),
        fill: WidgetContainerPropertiesMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: Colors.green[500],
          ),
        ),
        outerContainer: WidgetContainerPropertiesMix(),
      );

  /// Warning progress variant with orange fill
  static RemixProgressStyle get warning => RemixProgressStyle(
        container: WidgetContainerPropertiesMix(
          constraints: BoxConstraintsMix(minHeight: 6, maxHeight: 6),
          decoration: BoxDecorationMix(borderRadius: BorderRadiusMix.circular(99)),
          clipBehavior: Clip.antiAlias,
        ),
        track: WidgetContainerPropertiesMix(decoration: BoxDecorationMix(color: Colors.orange[100])),
        fill: WidgetContainerPropertiesMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(99),
            color: Colors.orange[500],
          ),
        ),
        outerContainer: WidgetContainerPropertiesMix(),
      );
}
