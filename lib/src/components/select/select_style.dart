part of 'select.dart';

class RemixSelectStyle extends Style<SelectSpec>
    with
        StyleModifierMixin<RemixSelectStyle, SelectSpec>,
        StyleVariantMixin<RemixSelectStyle, SelectSpec> {
  final Prop<WidgetSpec<BoxSpec>>? $menuContainer;
  final Prop<WidgetSpec<SelectTriggerSpec>>? $trigger;
  final Prop<WidgetSpec<SelectMenuItemSpec>>? $item;
  final Prop<WidgetSpec<CompositedTransformFollowerSpec>>? $position;

  const RemixSelectStyle.create({
    Prop<WidgetSpec<BoxSpec>>? menuContainer,
    Prop<WidgetSpec<SelectTriggerSpec>>? trigger,
    Prop<WidgetSpec<SelectMenuItemSpec>>? item,
    Prop<WidgetSpec<CompositedTransformFollowerSpec>>? position,
    super.variants,
    super.animation,
    super.modifier,
  })  : $menuContainer = menuContainer,
        $trigger = trigger,
        $item = item,
        $position = position;

  RemixSelectStyle({
    BoxStyle? menuContainer,
    RemixSelectTriggerStyle? trigger,
    RemixSelectMenuItemStyle? item,
    RemixCompositedTransformFollowerStyle? position,
    AnimationConfig? animation,
    List<VariantStyle<SelectSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          menuContainer: Prop.maybeMix(menuContainer),
          trigger: Prop.maybeMix(trigger),
          item: Prop.maybeMix(item),
          position: Prop.maybeMix(position),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  @override
  RemixSelectStyle variants(List<VariantStyle<SelectSpec>> value) {
    return merge(RemixSelectStyle(variants: value));
  }

  @override
  RemixSelectStyle wrap(ModifierConfig value) {
    return merge(RemixSelectStyle(modifier: value));
  }

  @override
  RemixSelectStyle variant(Variant variant, RemixSelectStyle style) {
    return merge(style);
  }

  @override
  WidgetSpec<SelectSpec> resolve(BuildContext context) {
    return WidgetSpec(
      spec: SelectSpec(
        trigger: MixOps.resolve(context, $trigger),
        menuContainer: MixOps.resolve(context, $menuContainer),
        item: MixOps.resolve(context, $item),
        position: MixOps.resolve(context, $position),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixSelectStyle merge(RemixSelectStyle? other) {
    if (other == null) return this;

    return RemixSelectStyle.create(
      menuContainer: MixOps.merge($menuContainer, other.$menuContainer),
      trigger: MixOps.merge($trigger, other.$trigger),
      item: MixOps.merge($item, other.$item),
      position: MixOps.merge($position, other.$position),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
    );
  }

  @override
  List<Object?> get props => [
        $menuContainer,
        $trigger,
        $item,
        $position,
        $variants,
        $animation,
        $modifier,
      ];
}

// Style classes for sub-specs
class RemixSelectTriggerStyle extends Style<SelectTriggerSpec> {
  final Prop<WidgetSpec<FlexBoxSpec>>? $container;
  final Prop<WidgetSpec<TextSpec>>? $label;
  final Prop<WidgetSpec<IconSpec>>? $icon;

  const RemixSelectTriggerStyle.create({
    Prop<WidgetSpec<FlexBoxSpec>>? container,
    Prop<WidgetSpec<TextSpec>>? label,
    Prop<WidgetSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $label = label,
        $icon = icon;

  RemixSelectTriggerStyle({
    FlexBoxStyle? container,
    TextStyling? label,
    IconStyle? icon,
    AnimationConfig? animation,
    List<VariantStyle<SelectTriggerSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          label: Prop.maybeMix(label),
          icon: Prop.maybeMix(icon),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  @override
  WidgetSpec<SelectTriggerSpec> resolve(BuildContext context) {
    return WidgetSpec(
      spec: SelectTriggerSpec(
        container: MixOps.resolve(context, $container),
        label: MixOps.resolve(context, $label),
        icon: MixOps.resolve(context, $icon),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixSelectTriggerStyle merge(RemixSelectTriggerStyle? other) {
    if (other == null) return this;

    return RemixSelectTriggerStyle.create(
      container: MixOps.merge($container, other.$container),
      label: MixOps.merge($label, other.$label),
      icon: other.$icon ?? $icon,
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
    );
  }

  @override
  List<Object?> get props => [
        $container,
        $label,
        $icon,
        $variants,
        $animation,
        $modifier,
      ];
}

class RemixSelectMenuItemStyle extends Style<SelectMenuItemSpec> {
  final Prop<WidgetSpec<FlexBoxSpec>>? $container;
  final Prop<WidgetSpec<TextSpec>>? $text;
  final Prop<WidgetSpec<IconSpec>>? $icon;

  const RemixSelectMenuItemStyle.create({
    Prop<WidgetSpec<FlexBoxSpec>>? container,
    Prop<WidgetSpec<TextSpec>>? text,
    Prop<WidgetSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $text = text,
        $icon = icon;

  RemixSelectMenuItemStyle({
    FlexBoxStyle? container,
    TextStyling? text,
    IconStyle? icon,
    AnimationConfig? animation,
    List<VariantStyle<SelectMenuItemSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          text: Prop.maybeMix(text),
          icon: Prop.maybeMix(icon),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  @override
  WidgetSpec<SelectMenuItemSpec> resolve(BuildContext context) {
    return WidgetSpec(
      spec: SelectMenuItemSpec(
        container: MixOps.resolve(context, $container),
        text: MixOps.resolve(context, $text),
        icon: MixOps.resolve(context, $icon),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixSelectMenuItemStyle merge(RemixSelectMenuItemStyle? other) {
    if (other == null) return this;

    return RemixSelectMenuItemStyle.create(
      container: MixOps.merge($container, other.$container),
      text: other.$text ?? $text,
      icon: other.$icon ?? $icon,
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
    );
  }

  @override
  List<Object?> get props => [
        $container,
        $text,
        $icon,
        $variants,
        $animation,
        $modifier,
      ];
}

class RemixCompositedTransformFollowerStyle
    extends Style<CompositedTransformFollowerSpec> {
  final Prop<Alignment>? $targetAnchor;
  final Prop<Alignment>? $followerAnchor;
  final Prop<Offset>? $offset;

  const RemixCompositedTransformFollowerStyle.create({
    Prop<Alignment>? targetAnchor,
    Prop<Alignment>? followerAnchor,
    Prop<Offset>? offset,
    super.variants,
    super.animation,
    super.modifier,
  })  : $targetAnchor = targetAnchor,
        $followerAnchor = followerAnchor,
        $offset = offset;

  RemixCompositedTransformFollowerStyle({
    Alignment? targetAnchor,
    Alignment? followerAnchor,
    Offset? offset,
    AnimationConfig? animation,
    List<VariantStyle<CompositedTransformFollowerSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          targetAnchor: Prop.maybe(targetAnchor),
          followerAnchor: Prop.maybe(followerAnchor),
          offset: Prop.maybe(offset),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  @override
  WidgetSpec<CompositedTransformFollowerSpec> resolve(BuildContext context) {
    return WidgetSpec(
      spec: CompositedTransformFollowerSpec(
        offset: MixOps.resolve(context, $offset),
        targetAnchor: MixOps.resolve(context, $targetAnchor),
        followerAnchor: MixOps.resolve(context, $followerAnchor),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixCompositedTransformFollowerStyle merge(
    RemixCompositedTransformFollowerStyle? other,
  ) {
    if (other == null) return this;

    return RemixCompositedTransformFollowerStyle.create(
      targetAnchor: other.$targetAnchor ?? $targetAnchor,
      followerAnchor: other.$followerAnchor ?? $followerAnchor,
      offset: other.$offset ?? $offset,
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
    );
  }

  @override
  List<Object?> get props => [
        $targetAnchor,
        $followerAnchor,
        $offset,
        $variants,
        $animation,
        $modifier,
      ];
}

// Default styles
final DefaultRemixSelectStyle = RemixSelectStyle(
  menuContainer: BoxStyle(
    padding: EdgeInsetsMix.symmetric(vertical: 4),
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(8),
      color: RemixTokens.background(),
      boxShadow: [
        BoxShadowMix(
          color: RemixTokens.textPrimary().withValues(alpha: 0.1),
          offset: const Offset(0, 2),
          blurRadius: 8,
        ),
      ],
    ),
  ),
  trigger: RemixSelectTriggerStyle(
    container: FlexBoxStyle(
      decoration: BoxDecorationMix(
        border: BoxBorderMix.all(
          BorderSideMix(color: RemixTokens.border(), width: 1),
        ),
        borderRadius: BorderRadiusMix.circular(6),
      ),
      padding: EdgeInsetsGeometryMix.symmetric(vertical: 8, horizontal: 12),
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
    ),
    label: TextStyling(
      style: TextStyleMix(
        color: RemixTokens.textPrimary(),
        fontSize: RemixTokens.fontSizeSm(),
      ),
    ),
    icon: IconStyle(color: RemixTokens.textSecondary(), size: 20),
  ),
  item: RemixSelectMenuItemStyle(
    container: FlexBoxStyle(
      padding: EdgeInsetsGeometryMix.symmetric(vertical: 8, horizontal: 12),
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
    ),
    text: TextStyling(
      style: TextStyleMix(
        color: RemixTokens.textPrimary(),
        fontSize: RemixTokens.fontSizeSm(),
      ),
    ),
    icon: IconStyle(color: RemixTokens.textSecondary(), size: 16),
  ),
  position: RemixCompositedTransformFollowerStyle(
    targetAnchor: Alignment.bottomLeft,
    followerAnchor: Alignment.topLeft,
    offset: const Offset(0, 4),
  ),
  animation: AnimationConfig.easeInOut(Duration(milliseconds: 150)),
);

extension RemixSelectVariants on RemixSelectStyle {
  /// Primary select variant with blue accents
  static RemixSelectStyle get primary => RemixSelectStyle(
        menuContainer: BoxStyle(
          padding: EdgeInsetsMix.symmetric(vertical: 4),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(8),
            color: RemixTokens.background(),
            boxShadow: [
              BoxShadowMix(
                color: RemixTokens.primary().withValues(alpha: 0.2),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        trigger: RemixSelectTriggerStyle(
          container: FlexBoxStyle(
            decoration: BoxDecorationMix(
              border: BoxBorderMix.all(
                BorderSideMix(color: RemixTokens.primary(), width: 1),
              ),
              borderRadius: BorderRadiusMix.circular(6),
              color: RemixTokens.primary().withValues(alpha: 0.1),
            ),
            padding:
                EdgeInsetsGeometryMix.symmetric(vertical: 8, horizontal: 12),
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          label: TextStyling(
            style: TextStyleMix(
              color: RemixTokens.primary(),
              fontSize: RemixTokens.fontSizeSm(),
            ),
          ),
          icon: IconStyle(color: RemixTokens.primary(), size: 20),
        ),
        item: RemixSelectMenuItemStyle(
          container: FlexBoxStyle(
            padding:
                EdgeInsetsGeometryMix.symmetric(vertical: 8, horizontal: 12),
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          text: TextStyling(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: RemixTokens.fontSizeSm(),
            ),
          ),
          icon: IconStyle(color: RemixTokens.primary(), size: 16),
        ),
        position: RemixCompositedTransformFollowerStyle(
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 4),
        ),
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 150)),
      );

  /// Secondary select variant with grey styling
  static RemixSelectStyle get secondary => RemixSelectStyle(
        menuContainer: BoxStyle(
          padding: EdgeInsetsMix.symmetric(vertical: 4),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(8),
            color: RemixTokens.background(),
            boxShadow: [
              BoxShadowMix(
                color: RemixTokens.textSecondary().withValues(alpha: 0.2),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        trigger: RemixSelectTriggerStyle(
          container: FlexBoxStyle(
            decoration: BoxDecorationMix(
              border: BoxBorderMix.all(
                BorderSideMix(color: RemixTokens.textSecondary(), width: 1),
              ),
              borderRadius: BorderRadiusMix.circular(6),
              color: RemixTokens.surface(),
            ),
            padding:
                EdgeInsetsGeometryMix.symmetric(vertical: 8, horizontal: 12),
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          label: TextStyling(
            style: TextStyleMix(
              color: RemixTokens.textSecondary(),
              fontSize: RemixTokens.fontSizeSm(),
            ),
          ),
          icon: IconStyle(color: RemixTokens.textSecondary(), size: 20),
        ),
        item: RemixSelectMenuItemStyle(
          container: FlexBoxStyle(
            padding:
                EdgeInsetsGeometryMix.symmetric(vertical: 8, horizontal: 12),
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          text: TextStyling(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: RemixTokens.fontSizeSm(),
            ),
          ),
          icon: IconStyle(color: RemixTokens.textSecondary(), size: 16),
        ),
        position: RemixCompositedTransformFollowerStyle(
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 4),
        ),
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 150)),
      );

  /// Outlined select variant with no background fill
  static RemixSelectStyle get outlined => RemixSelectStyle(
        menuContainer: BoxStyle(
          padding: EdgeInsetsMix.symmetric(vertical: 4),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.border(), width: 1),
            ),
            borderRadius: BorderRadiusMix.circular(8),
            color: RemixTokens.background(),
            boxShadow: [
              BoxShadowMix(
                color: RemixTokens.textPrimary().withValues(alpha: 0.1),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        trigger: RemixSelectTriggerStyle(
          container: FlexBoxStyle(
            decoration: BoxDecorationMix(
              border: BoxBorderMix.all(
                BorderSideMix(color: RemixTokens.border(), width: 2),
              ),
              borderRadius: BorderRadiusMix.circular(6),
              color: RemixTokens.surface().withValues(alpha: 0.0),
            ),
            padding:
                EdgeInsetsGeometryMix.symmetric(vertical: 8, horizontal: 12),
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          label: TextStyling(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: RemixTokens.fontSizeSm(),
            ),
          ),
          icon: IconStyle(color: RemixTokens.textSecondary(), size: 20),
        ),
        item: RemixSelectMenuItemStyle(
          container: FlexBoxStyle(
            padding:
                EdgeInsetsGeometryMix.symmetric(vertical: 8, horizontal: 12),
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          text: TextStyling(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: RemixTokens.fontSizeSm(),
            ),
          ),
          icon: IconStyle(color: RemixTokens.textSecondary(), size: 16),
        ),
        position: RemixCompositedTransformFollowerStyle(
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 4),
        ),
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 150)),
      );
}
