part of 'tabs.dart';

/// Resolved visual values for a [RemixTabBar].
@MixableSpec(target: RemixTabBar.new, extraStylerMixins: [RemixBoxStylerMixin])
class TabBarSpec with _$TabBarSpec {
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<FlexBoxSpec> container;

  /// A surface shared by the tabs that sits behind the selected tab and glides
  /// to the next one when the selection changes.
  ///
  /// It takes the selected tab's bounds, so `margin` insets it and the
  /// decoration draws it. `null`, the default, draws none and leaves each
  /// tab's own selected style in charge. The tab content must be laid out in
  /// the bar's own layout: a scrollable inside the bar moves the tabs without
  /// moving the indicator, so scroll around the bar instead.
  @override
  final StyleSpec<BoxSpec>? indicator;

  /// Paint layers behind [indicator], such as a shadow.
  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? indicatorEffects;

  /// How [indicator] moves between tabs. `null` glides along
  /// `Curves.easeOutCubic` over 250 ms.
  @override
  final RemixTabIndicatorMotion? indicatorMotion;

  const TabBarSpec({
    StyleSpec<FlexBoxSpec>? container,
    this.indicator,
    this.indicatorEffects,
    this.indicatorMotion,
  }) : container = container ?? const StyleSpec(spec: FlexBoxSpec());

  // Deliberate: route effects through lerpNullable so shadows/blends animate;
  // the generator's default snap-lerps unrecognized spec types.
  @override
  TabBarSpec lerp(TabBarSpec? other, double t) {
    final generated = super.lerp(other, t);
    if (other == null) return generated;
    return generated.copyWith(
      indicatorEffects: RemixBoxEffectsSpec.lerpNullable(
        indicatorEffects,
        other.indicatorEffects,
        t,
      ),
    );
  }
}

/// Backward-compatible name for [TabBarSpec].
///
/// The generated style API is based on [TabBarSpec], so resolved values use
/// `TabBarSpec` as their runtime type.
typedef RemixTabBarSpec = TabBarSpec;

/// Resolved visual values for an individual [RemixTab].
@MixableSpec(
  target: RemixTab.new,
  extraStylerMixins: [RemixBoxStylerMixin, LabelStyleMixin, IconStyleMixin],
)
class TabSpec with _$TabSpec {
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<FlexBoxSpec> container;

  /// Outline and paint layers drawn around [container] without affecting
  /// layout, such as a focus ring.
  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? containerEffects;

  @override
  final StyleSpec<TextSpec> label;
  @override
  final StyleSpec<IconSpec> icon;

  const TabSpec({
    StyleSpec<FlexBoxSpec>? container,
    this.containerEffects,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  }) : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec());

  // Deliberate: route effects through lerpNullable so shadows/blends animate;
  // the generator's default snap-lerps unrecognized spec types.
  @override
  TabSpec lerp(TabSpec? other, double t) {
    final generated = super.lerp(other, t);
    if (other == null) return generated;
    return generated.copyWith(
      containerEffects: RemixBoxEffectsSpec.lerpNullable(
        containerEffects,
        other.containerEffects,
        t,
      ),
    );
  }
}

/// Backward-compatible name for [TabSpec].
///
/// The generated style API is based on [TabSpec], so resolved values use
/// `TabSpec` as their runtime type.
typedef RemixTabSpec = TabSpec;

/// Resolved visual values for a [RemixTabView].
@MixableSpec(target: RemixTabView.new, extraStylerMixins: [RemixBoxStylerMixin])
class TabViewSpec with _$TabViewSpec {
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;

  const TabViewSpec({StyleSpec<BoxSpec>? container})
    : container = container ?? const StyleSpec(spec: BoxSpec());
}

/// Backward-compatible name for [TabViewSpec].
///
/// The generated style API is based on [TabViewSpec], so resolved values use
/// `TabViewSpec` as their runtime type.
typedef RemixTabViewSpec = TabViewSpec;
