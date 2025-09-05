part of 'switch.dart';

class RemixSwitchStyle extends Style<SwitchSpec>
    with
        StyleModifierMixin<RemixSwitchStyle, SwitchSpec>,
        StyleVariantMixin<RemixSwitchStyle, SwitchSpec>,
        ModifierStyleMixin<RemixSwitchStyle, SwitchSpec>,
        BorderStyleMixin<RemixSwitchStyle>,
        BorderRadiusStyleMixin<RemixSwitchStyle>,
        ShadowStyleMixin<RemixSwitchStyle>,
        DecorationStyleMixin<RemixSwitchStyle>,
        SpacingStyleMixin<RemixSwitchStyle>,
        TransformStyleMixin<RemixSwitchStyle>,
        ConstraintStyleMixin<RemixSwitchStyle>,
        AnimationStyleMixin<SwitchSpec, RemixSwitchStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<BoxSpec>>? $track;
  final Prop<StyleSpec<BoxSpec>>? $thumb;

  const RemixSwitchStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<BoxSpec>>? track,
    Prop<StyleSpec<BoxSpec>>? thumb,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $track = track,
        $thumb = thumb;

  RemixSwitchStyle({
    BoxStyler? container,
    BoxStyler? track,
    BoxStyler? thumb,
    AnimationConfig? animation,
    List<VariantStyle<SwitchSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          track: Prop.maybeMix(track),
          thumb: Prop.maybeMix(thumb),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Sets track color
  RemixSwitchStyle trackColor(Color value) {
    return merge(RemixSwitchStyle(
      track: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets thumb color
  RemixSwitchStyle thumbColor(Color value) {
    return merge(RemixSwitchStyle(
      thumb: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets track styling
  RemixSwitchStyle track(BoxStyler value) {
    return merge(RemixSwitchStyle(track: value));
  }

  /// Sets thumb styling
  RemixSwitchStyle thumb(BoxStyler value) {
    return merge(RemixSwitchStyle(thumb: value));
  }

  @override
  StyleSpec<SwitchSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: SwitchSpec(
        container: MixOps.resolve(context, $container),
        track: MixOps.resolve(context, $track),
        thumb: MixOps.resolve(context, $thumb),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixSwitchStyle merge(RemixSwitchStyle? other) {
    if (other == null) return this;

    return RemixSwitchStyle.create(
      container: MixOps.merge($container, other.$container),
      track: MixOps.merge($track, other.$track),
      thumb: MixOps.merge($thumb, other.$thumb),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }


  @override
  RemixSwitchStyle variants(List<VariantStyle<SwitchSpec>> value) {
    return merge(RemixSwitchStyle(variants: value));
  }

  @override
  RemixSwitchStyle wrap(ModifierConfig value) {
    return merge(RemixSwitchStyle(modifier: value));
  }

  // Abstract method implementations for mixins
  
  @override
  RemixSwitchStyle animate(AnimationConfig config) {
    return merge(RemixSwitchStyle(animation: config));
  }
  
  @override
  RemixSwitchStyle constraints(BoxConstraintsMix value) {
    return merge(RemixSwitchStyle(container: BoxStyler(constraints: value)));
  }
  
  @override
  RemixSwitchStyle decoration(DecorationMix value) {
    return merge(RemixSwitchStyle(container: BoxStyler(decoration: value)));
  }
  
  @override
  RemixSwitchStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixSwitchStyle(container: BoxStyler(margin: value)));
  }
  
  @override
  RemixSwitchStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixSwitchStyle(container: BoxStyler(padding: value)));
  }
  
  @override
  RemixSwitchStyle foregroundDecoration(DecorationMix value) {
    return merge(RemixSwitchStyle(container: BoxStyler(foregroundDecoration: value)));
  }
  
  @override
  RemixSwitchStyle transform(Matrix4 value, {AlignmentGeometry alignment = Alignment.center}) {
    return merge(RemixSwitchStyle(container: BoxStyler(transform: value, alignment: alignment)));
  }

  @override
  List<Object?> get props => [
        $container,
        $track,
        $thumb,
        $variants,
        $animation,
        $modifier,
      ];
}

final DefaultRemixSwitchStyle = RemixSwitchStyle(
  container: BoxStyler(),
  track: BoxStyler(
    constraints: BoxConstraintsMix(
      minWidth: 44,
      maxWidth: 44,
      minHeight: 24,
      maxHeight: 24,
    ),
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(RemixTokens.radiusXl()),
      color: RemixTokens.border(),
    ),
  ),
  thumb: BoxStyler(
    constraints: BoxConstraintsMix(
      minWidth: 20,
      maxWidth: 20,
      minHeight: 20,
      maxHeight: 20,
    ),
    decoration: BoxDecorationMix(
      shape: BoxShape.circle,
      color: RemixTokens.background(),
      boxShadow: [
        BoxShadowMix(
          color: RemixTokens.textPrimary().withValues(alpha: 0.2),
          offset: const Offset(0, 1),
          blurRadius: 2,
        ),
      ],
    ),
  ),
  animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
);

extension SwitchVariants on RemixSwitchStyle {
  /// Primary switch variant with blue colors
  static RemixSwitchStyle get primary => RemixSwitchStyle(
        container: BoxStyler(),
        track: BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: 44,
            maxWidth: 44,
            minHeight: 24,
            maxHeight: 24,
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusXl()),
            color: RemixTokens.primary().withValues(alpha: 0.2),
          ),
        ),
        thumb: BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: 20,
            maxWidth: 20,
            minHeight: 20,
            maxHeight: 20,
          ),
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: RemixTokens.primary(),
            boxShadow: [
              BoxShadowMix(
                color: RemixTokens.primary().withValues(alpha: 0.3),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
      );

  /// Secondary switch variant with grey colors
  static RemixSwitchStyle get secondary => RemixSwitchStyle(
        container: BoxStyler(),
        track: BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: 44,
            maxWidth: 44,
            minHeight: 24,
            maxHeight: 24,
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusXl()),
            color: RemixTokens.surface(),
          ),
        ),
        thumb: BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: 20,
            maxWidth: 20,
            minHeight: 20,
            maxHeight: 20,
          ),
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: RemixTokens.textSecondary(),
            boxShadow: [
              BoxShadowMix(
                color: RemixTokens.textSecondary().withValues(alpha: 0.3),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
      );

  /// Compact switch variant with smaller size
  static RemixSwitchStyle get compact => RemixSwitchStyle(
        container: BoxStyler(),
        track: BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: 36,
            maxWidth: 36,
            minHeight: 20,
            maxHeight: 20,
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
            color: RemixTokens.border(),
          ),
        ),
        thumb: BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: 16,
            maxWidth: 16,
            minHeight: 16,
            maxHeight: 16,
          ),
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: RemixTokens.background(),
            boxShadow: [
              BoxShadowMix(
                color: RemixTokens.textPrimary().withValues(alpha: 0.1),
                offset: const Offset(0, 1),
                blurRadius: 1,
              ),
            ],
          ),
        ),
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
      );
}
