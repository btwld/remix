part of 'slider.dart';

class RemixSliderStyle extends Style<SliderSpec>
    with
        StyleModifierMixin<RemixSliderStyle, SliderSpec>,
        StyleVariantMixin<RemixSliderStyle, SliderSpec> {
  final Prop<WidgetSpec<BoxSpec>>? $thumb;
  final Prop<Paint>? $baseTrack;
  final Prop<Paint>? $activeTrack;
  final Prop<Paint>? $division;

  const RemixSliderStyle.create({
    Prop<WidgetSpec<BoxSpec>>? thumb,
    Prop<Paint>? baseTrack,
    Prop<Paint>? activeTrack,
    Prop<Paint>? division,
    super.variants,
    super.animation,
    super.modifier,
  })  : $thumb = thumb,
        $baseTrack = baseTrack,
        $activeTrack = activeTrack,
        $division = division;

  RemixSliderStyle({
    BoxStyle? thumb,
    Paint? baseTrack,
    Paint? activeTrack,
    Paint? division,
    AnimationConfig? animation,
    List<VariantStyle<SliderSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          thumb: Prop.maybeMix(thumb),
          baseTrack: baseTrack != null ? Prop.value(baseTrack) : null,
          activeTrack: activeTrack != null ? Prop.value(activeTrack) : null,
          division: division != null ? Prop.value(division) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  @override
  WidgetSpec<SliderSpec> resolve(BuildContext context) {
    return WidgetSpec(
      spec: SliderSpec(
        thumb: MixOps.resolve(context, $thumb),
        baseTrack: MixOps.resolve(context, $baseTrack),
        activeTrack: MixOps.resolve(context, $activeTrack),
        division: MixOps.resolve(context, $division),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixSliderStyle merge(RemixSliderStyle? other) {
    if (other == null) return this;

    return RemixSliderStyle.create(
      thumb: MixOps.merge($thumb, other.$thumb),
      baseTrack: MixOps.merge($baseTrack, other.$baseTrack),
      activeTrack: MixOps.merge($activeTrack, other.$activeTrack),
      division: MixOps.merge($division, other.$division),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
    );
  }

  @override
  RemixSliderStyle variant(Variant variant, RemixSliderStyle style) {
    return merge(RemixSliderStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixSliderStyle variants(List<VariantStyle<SliderSpec>> value) {
    return merge(RemixSliderStyle(variants: value));
  }

  @override
  RemixSliderStyle wrap(ModifierConfig value) {
    return merge(RemixSliderStyle(modifier: value));
  }

  @override
  List<Object?> get props => [
        $thumb,
        $baseTrack,
        $activeTrack,
        $division,
        $variants,
        $animation,
        $modifier,
      ];
}

// Default style
final DefaultRemixSliderStyle = RemixSliderStyle(
  thumb: BoxStyle(
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(
        BorderSideMix(color: RemixTokens.textPrimary(), width: 2),
      ),
      shape: BoxShape.circle,
      color: RemixTokens.background(),
    ),
  ),
).builder((context) {
  return RemixSliderStyle(
    baseTrack: Paint()
      ..strokeWidth = 8
      ..color = RemixTokens.border.resolve(context)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke,
    activeTrack: Paint()
      ..strokeWidth = 8
      ..color = RemixTokens.textPrimary.resolve(context)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke,
    division: Paint()
      ..strokeWidth = 8
      ..color = RemixTokens.textPrimary.resolve(context).withValues(alpha: 0.26)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke,
    animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
  );
});

// Hover style
final RemixSliderHoverStyle = RemixSliderStyle(
  thumb: BoxStyle(
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(
        BorderSideMix(color: RemixTokens.primary(), width: 2),
      ),
    ),
  ),
);

// Disabled style
final RemixSliderDisabledStyle = RemixSliderStyle(
  thumb: BoxStyle(
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(
        BorderSideMix(color: RemixTokens.border(), width: 2),
      ),
      color: RemixTokens.surface(),
    ),
  ),
  baseTrack: Paint()
    ..strokeWidth = 8
    ..color = RemixTokens.surface()
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke,
  activeTrack: Paint()
    ..strokeWidth = 8
    ..color = RemixTokens.border()
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke,
);

extension SliderVariants on RemixSliderStyle {
  /// Primary slider variant with blue colors
  static RemixSliderStyle get primary => RemixSliderStyle(
        thumb: BoxStyle(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.primary(), width: 2),
            ),
            shape: BoxShape.circle,
            color: RemixTokens.background(),
            boxShadow: [
              BoxShadowMix(
                color: RemixTokens.primary().withValues(alpha: 0.3),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        baseTrack: Paint()
          ..strokeWidth = 8
          ..color = RemixTokens.primary().withValues(alpha: 0.2)
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        activeTrack: Paint()
          ..strokeWidth = 8
          ..color = RemixTokens.primary()
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        division: Paint()
          ..strokeWidth = 8
          ..color = RemixTokens.primary().withValues(alpha: 0.5)
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
      );

  /// Secondary slider variant with grey colors
  static RemixSliderStyle get secondary => RemixSliderStyle(
        thumb: BoxStyle(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.textSecondary(), width: 2),
            ),
            shape: BoxShape.circle,
            color: RemixTokens.background(),
          ),
        ),
        baseTrack: Paint()
          ..strokeWidth = 8
          ..color = RemixTokens.surface()
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        activeTrack: Paint()
          ..strokeWidth = 8
          ..color = RemixTokens.textSecondary()
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        division: Paint()
          ..strokeWidth = 8
          ..color = RemixTokens.textSecondary().withValues(alpha: 0.5)
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
      );

  /// Compact slider variant with smaller track
  static RemixSliderStyle get compact => RemixSliderStyle(
        thumb: BoxStyle(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.textPrimary(), width: 1.5),
            ),
            shape: BoxShape.circle,
            color: RemixTokens.background(),
          ),
        ),
        baseTrack: Paint()
          ..strokeWidth = 4
          ..color = RemixTokens.border()
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        activeTrack: Paint()
          ..strokeWidth = 4
          ..color = RemixTokens.textPrimary()
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        division: Paint()
          ..strokeWidth = 4
          ..color = RemixTokens.textPrimary().withValues(alpha: 0.26)
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
      );
}
