part of 'card.dart';

class RemixCardStyle extends Style<CardSpec>
    with
        StyleModifierMixin<RemixCardStyle, CardSpec>,
        StyleVariantMixin<RemixCardStyle, CardSpec>,
        ModifierStyleMixin<RemixCardStyle, CardSpec>,
        BorderStyleMixin<RemixCardStyle>,
        BorderRadiusStyleMixin<RemixCardStyle>,
        ShadowStyleMixin<RemixCardStyle>,
        DecorationStyleMixin<RemixCardStyle>,
        SpacingStyleMixin<RemixCardStyle>,
        TransformStyleMixin<RemixCardStyle>,
        ConstraintStyleMixin<RemixCardStyle>,
        AnimationStyleMixin<CardSpec, RemixCardStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;

  const RemixCardStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container;

  RemixCardStyle({
    BoxStyler? container,
    AnimationConfig? animation,
    List<VariantStyle<CardSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Sets container padding
  RemixCardStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixCardStyle(container: BoxStyler(padding: value)));
  }

  /// Sets container background color
  RemixCardStyle color(Color value) {
    return merge(RemixCardStyle(
      container: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets container border radius
  RemixCardStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixCardStyle(
      container: BoxStyler(
        decoration: BoxDecorationMix(borderRadius: radius),
      ),
    ));
  }

  /// Sets container margin
  RemixCardStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixCardStyle(container: BoxStyler(margin: value)));
  }

  /// Sets container decoration
  RemixCardStyle decoration(DecorationMix value) {
    return merge(RemixCardStyle(container: BoxStyler(decoration: value)));
  }

  @override
  StyleSpec<CardSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: CardSpec(container: MixOps.resolve(context, $container)),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixCardStyle merge(RemixCardStyle? other) {
    if (other == null) return this;

    return RemixCardStyle.create(
      container: MixOps.merge($container, other.$container),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixCardStyle variants(List<VariantStyle<CardSpec>> value) {
    return merge(RemixCardStyle(variants: value));
  }

  @override
  RemixCardStyle wrap(ModifierConfig value) {
    return merge(RemixCardStyle(modifier: value));
  }

  // Abstract method implementations for mixins
  
  @override
  RemixCardStyle animate(AnimationConfig config) {
    return merge(RemixCardStyle(animation: config));
  }
  
  @override
  RemixCardStyle constraints(BoxConstraintsMix value) {
    return merge(RemixCardStyle(container: BoxStyler(constraints: value)));
  }
  
  
  @override
  RemixCardStyle foregroundDecoration(DecorationMix value) {
    return merge(RemixCardStyle(container: BoxStyler(foregroundDecoration: value)));
  }
  
  @override
  RemixCardStyle transform(Matrix4 value, {AlignmentGeometry alignment = Alignment.center}) {
    return merge(RemixCardStyle(container: BoxStyler(transform: value, alignment: alignment)));
  }

  @override
  List<Object?> get props => [$container, $variants, $animation, $modifier];
}

/// Default card styles and variants
class RemixCardStyles {
  /// Default card style
  static RemixCardStyle get defaultStyle => RemixCardStyle(
        container: BoxStyler(
          padding: EdgeInsetsMix.all(RemixTokens.spaceLg()),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
            color: RemixTokens.surface(),
            boxShadow: [
              BoxShadowMix(
                color: RemixTokens.textPrimary().withValues(alpha: 0.1),
                offset: const Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
      )
          .onHovered(
            RemixCardStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  boxShadow: [
                    BoxShadowMix(
                      color: RemixTokens.textPrimary().withValues(alpha: 0.15),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
          )
          .onPressed(
            RemixCardStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  boxShadow: [
                    BoxShadowMix(
                      color: RemixTokens.textPrimary().withValues(alpha: 0.08),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
          )
          .onFocused(
            RemixCardStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  border: BoxBorderMix.all(
                    BorderSideMix(
                      color: RemixTokens.primary().withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          );

  /// Elevated card variant with stronger shadow
  static RemixCardStyle get elevated => RemixCardStyle(
        container: BoxStyler(
          padding: EdgeInsetsMix.all(RemixTokens.spaceLg()),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
            color: RemixTokens.surface(),
            boxShadow: [
              BoxShadowMix(
                color: RemixTokens.textPrimary().withValues(alpha: 0.15),
                offset: const Offset(0, 4),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
      )
          .onHovered(
            RemixCardStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  boxShadow: [
                    BoxShadowMix(
                      color: RemixTokens.textPrimary().withValues(alpha: 0.2),
                      offset: const Offset(0, 8),
                      blurRadius: 16,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
          )
          .onPressed(
            RemixCardStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  boxShadow: [
                    BoxShadowMix(
                      color: RemixTokens.textPrimary().withValues(alpha: 0.12),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
          );

  /// Outlined card variant with border
  static RemixCardStyle get outlined => RemixCardStyle(
        container: BoxStyler(
          padding: EdgeInsetsMix.all(RemixTokens.spaceLg()),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.border(), width: 1),
            ),
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
            color: RemixTokens.surface(),
          ),
        ),
      )
          .onHovered(
            RemixCardStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  border: BoxBorderMix.all(
                    BorderSideMix(color: RemixTokens.border(), width: 1.5),
                  ),
                  color: RemixTokens.surfaceVariant().withValues(alpha: 0.5),
                ),
              ),
            ),
          )
          .onPressed(
            RemixCardStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  border: BoxBorderMix.all(
                    BorderSideMix(color: RemixTokens.border(), width: 2),
                  ),
                  color: RemixTokens.surfaceVariant().withValues(alpha: 0.8),
                ),
              ),
            ),
          );

  /// Flat card variant without shadow
  static RemixCardStyle get flat => RemixCardStyle(
        container: BoxStyler(
          padding: EdgeInsetsMix.all(RemixTokens.spaceLg()),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
            color: RemixTokens.surfaceVariant(),
          ),
        ),
      )
          .onHovered(
            RemixCardStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: RemixTokens.surfaceVariant().withValues(alpha: 0.8),
                ),
              ),
            ),
          )
          .onPressed(
            RemixCardStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: RemixTokens.surfaceVariant().withValues(alpha: 0.9),
                ),
              ),
            ),
          );

  /// Compact card variant with reduced padding
  static RemixCardStyle get compact => RemixCardStyle(
        container: BoxStyler(
          padding: EdgeInsetsMix.all(RemixTokens.spaceMd()),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusMd()),
            color: RemixTokens.surface(),
            boxShadow: [
              BoxShadowMix(
                color: RemixTokens.textPrimary().withValues(alpha: 0.08),
                offset: const Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
      );
}
