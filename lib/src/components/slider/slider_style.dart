part of 'slider.dart';

// Private per-component constants (sizes only)
const _kTrackWidth = 8.0;
const _kThumbBorderWidth = 2.0;

class RemixSliderStyle extends Style<SliderSpec>
    with
        VariantStyleMixin<RemixSliderStyle, SliderSpec>,
        WidgetModifierStyleMixin<RemixSliderStyle, SliderSpec> {
  final Prop<StyleSpec<BoxSpec>>? $thumb;
  final Prop<Paint>? $baseTrack;
  final Prop<Paint>? $activeTrack;
  final Prop<Paint>? $division;

  const RemixSliderStyle.create({
    Prop<StyleSpec<BoxSpec>>? thumb,
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
    BoxStyler? thumb,
    Paint? baseTrack,
    Paint? activeTrack,
    Paint? division,
    AnimationConfig? animation,
    List<VariantStyle<SliderSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          thumb: Prop.maybeMix(thumb),
          baseTrack: baseTrack != null ? Prop.value(baseTrack) : null,
          activeTrack: activeTrack != null ? Prop.value(activeTrack) : null,
          division: division != null ? Prop.value(division) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Sets thumb color
  RemixSliderStyle thumbColor(Color value) {
    return merge(RemixSliderStyle(
      thumb: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets base track color
  RemixSliderStyle baseTrackColor(Color value) {
    return merge(RemixSliderStyle(
      baseTrack: Paint()
        ..strokeWidth = 8
        ..color = value
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    ));
  }

  /// Sets active track color
  RemixSliderStyle activeTrackColor(Color value) {
    return merge(RemixSliderStyle(
      activeTrack: Paint()
        ..strokeWidth = 8
        ..color = value
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    ));
  }

  /// Sets thumb styling
  RemixSliderStyle thumb(BoxStyler value) {
    return merge(RemixSliderStyle(thumb: value));
  }

  @override
  StyleSpec<SliderSpec> resolve(BuildContext context) {
    return StyleSpec(
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
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixSliderStyle variants(List<VariantStyle<SliderSpec>> value) {
    return merge(RemixSliderStyle(variants: value));
  }

  @override
  RemixSliderStyle wrap(WidgetModifierConfig value) {
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

// Default style is provided by RemixSliderStyles.baseStyle

// Hover style
final RemixSliderHoverStyle = RemixSliderStyle(
  thumb: BoxStyler(
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(
        BorderSideMix(color: RemixTokens.primary(), width: _kThumbBorderWidth),
      ),
    ),
  ),
);

// Disabled style
final RemixSliderDisabledStyle = RemixSliderStyle(
  thumb: BoxStyler(
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(
        BorderSideMix(
          color: RemixTokens.primary(),
          width: _kThumbBorderWidth,
        ),
      ),
      color: RemixTokens.primary(),
    ),
  ),
  baseTrack: Paint()
    ..strokeWidth = _kTrackWidth
    ..color = RemixTokens.primary()
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke,
  activeTrack: Paint()
    ..strokeWidth = _kTrackWidth
    ..color = RemixTokens.primary()
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke,
);

// Removed colorful variants; slider uses single defaultStyle only

/// Canonical access to default and variants
class RemixSliderStyles {
  /// Base slider style
  static RemixSliderStyle get baseStyle => classic;

  /// Classic slider variant (default) - surface background with border
  static RemixSliderStyle get classic => RemixSliderStyle(
        thumb: BoxStyler(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(
                color: RemixTokens.primary(),
                width: _kThumbBorderWidth,
              ),
            ),
            shape: BoxShape.circle,
            color: RemixTokens.onPrimary(),
          ),
        ),
      ).builder((context) {
        return RemixSliderStyle(
          baseTrack: Paint()
            ..strokeWidth = _kTrackWidth
            ..color = RemixTokens.primary.resolve(context)
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
          activeTrack: Paint()
            ..strokeWidth = _kTrackWidth
            ..color = RemixTokens.primary.resolve(context)
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
          division: Paint()
            ..strokeWidth = _kTrackWidth
            ..color = RemixTokens.primary.resolve(context)
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
        );
      });
}
