part of 'select.dart';

class RemixSelectStyle extends Style<SelectSpec>
    with
        StyleModifierMixin<RemixSelectStyle, SelectSpec>,
        StyleVariantMixin<RemixSelectStyle, SelectSpec> {
  final Prop<BoxSpec>? $menuContainer;
  final Prop<WidgetSpec<SelectTriggerSpec>>? $trigger;
  final Prop<WidgetSpec<SelectMenuItemSpec>>? $item;
  final Prop<WidgetSpec<CompositedTransformFollowerSpec>>? $position;

  const RemixSelectStyle.create({
    Prop<BoxSpec>? menuContainer,
    Prop<WidgetSpec<SelectTriggerSpec>>? trigger,
    Prop<WidgetSpec<SelectMenuItemSpec>>? item,
    Prop<WidgetSpec<CompositedTransformFollowerSpec>>? position,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $menuContainer = menuContainer,
        $trigger = trigger,
        $item = item,
        $position = position;

  RemixSelectStyle({
    BoxMix? menuContainer,
    RemixSelectTriggerStyle? trigger,
    RemixSelectMenuItemStyle? item,
    RemixCompositedTransformFollowerStyle? position,
    AnimationConfig? animation,
    List<VariantStyle<SelectSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          menuContainer: Prop.maybeMix(menuContainer),
          trigger: Prop.maybeMix(trigger),
          item: Prop.maybeMix(item),
          position: Prop.maybeMix(position),
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixSelectStyle.value(SelectSpec spec) => RemixSelectStyle(
        menuContainer: BoxMix.maybeValue(spec.menuContainer),
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
        trigger: MixOps.resolve(context, $trigger)?.spec,
        menuContainer: MixOps.resolve(context, $menuContainer),
        item: MixOps.resolve(context, $item)?.spec,
        position: MixOps.resolve(context, $position)?.spec,
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
      inherit: $inherit,
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
      inherit: other.$inherit ?? $inherit,
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
        $inherit,
      ];
}

// Style classes for sub-specs
class RemixSelectTriggerStyle extends Style<SelectTriggerSpec> {
  final Prop<BoxSpec>? $container;
  final Prop<FlexSpec>? $flex;
  final Prop<TextSpec>? $label;
  final Prop<IconSpec>? $icon;

  const RemixSelectTriggerStyle.create({
    Prop<BoxSpec>? container,
    Prop<FlexSpec>? flex,
    Prop<TextSpec>? label,
    Prop<IconSpec>? icon,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $flex = flex,
        $label = label,
        $icon = icon;

  RemixSelectTriggerStyle({
    BoxMix? container,
    FlexMix? flex,
    TextMix? label,
    IconMix? icon,
    AnimationConfig? animation,
    List<VariantStyle<SelectTriggerSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: Prop.maybeMix(container),
          flex: Prop.maybeMix(flex),
          label: Prop.maybeMix(label),
          icon: Prop.maybeMix(icon),
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixSelectTriggerStyle.value(SelectTriggerSpec spec) =>
      RemixSelectTriggerStyle(
        container: BoxMix.maybeValue(spec.container),
        flex: FlexMix.maybeValue(spec.flex),
        label: TextMix.maybeValue(spec.label),
        icon: IconMix.maybeValue(spec.icon),
      );

  @override
  WidgetSpec<SelectTriggerSpec> resolve(BuildContext context) {
    return WidgetSpec(
      spec: SelectTriggerSpec(
        container: MixOps.resolve(context, $container),
        flex: MixOps.resolve(context, $flex),
        label: MixOps.resolve(context, $label),
        icon: MixOps.resolve(context, $icon),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
      inherit: $inherit,
    );
  }

  @override
  RemixSelectTriggerStyle merge(RemixSelectTriggerStyle? other) {
    if (other == null) return this;

    return RemixSelectTriggerStyle.create(
      container: MixOps.merge($container, other.$container),
      flex: MixOps.merge($flex, other.$flex),
      label: MixOps.merge($label, other.$label),
      icon: other.$icon ?? $icon,
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  List<Object?> get props => [
        $container,
        $flex,
        $label,
        $icon,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

class RemixSelectMenuItemStyle extends Style<SelectMenuItemSpec> {
  final Prop<BoxSpec>? $container;
  final Prop<FlexSpec>? $flex;
  final Prop<TextSpec>? $text;
  final Prop<IconSpec>? $icon;

  const RemixSelectMenuItemStyle.create({
    Prop<BoxSpec>? container,
    Prop<FlexSpec>? flex,
    Prop<TextSpec>? text,
    Prop<IconSpec>? icon,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $flex = flex,
        $text = text,
        $icon = icon;

  RemixSelectMenuItemStyle({
    BoxMix? container,
    FlexMix? flex,
    TextMix? text,
    IconMix? icon,
    AnimationConfig? animation,
    List<VariantStyle<SelectMenuItemSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: Prop.maybeMix(container),
          flex: Prop.maybeMix(flex),
          text: Prop.maybeMix(text),
          icon: Prop.maybeMix(icon),
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixSelectMenuItemStyle.value(SelectMenuItemSpec spec) =>
      RemixSelectMenuItemStyle(
        container: BoxMix.maybeValue(spec.container),
        flex: FlexMix.maybeValue(spec.flex),
        text: TextMix.maybeValue(spec.text),
        icon: IconMix.maybeValue(spec.icon),
      );

  @override
  WidgetSpec<SelectMenuItemSpec> resolve(BuildContext context) {
    return WidgetSpec(
      spec: SelectMenuItemSpec(
        container: MixOps.resolve(context, $container),
        flex: MixOps.resolve(context, $flex),
        text: MixOps.resolve(context, $text),
        icon: MixOps.resolve(context, $icon),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
      inherit: $inherit,
    );
  }

  @override
  RemixSelectMenuItemStyle merge(RemixSelectMenuItemStyle? other) {
    if (other == null) return this;

    return RemixSelectMenuItemStyle.create(
      container: MixOps.merge($container, other.$container),
      flex: MixOps.merge($flex, other.$flex),
      text: other.$text ?? $text,
      icon: other.$icon ?? $icon,
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  List<Object?> get props => [
        $container,
        $flex,
        $text,
        $icon,
        $variants,
        $animation,
        $modifier,
        $inherit,
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
    super.inherit,
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
    bool? inherit,
  }) : this.create(
          targetAnchor: Prop.maybe(targetAnchor),
          followerAnchor: Prop.maybe(followerAnchor),
          offset: Prop.maybe(offset),
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
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
      inherit: $inherit,
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
      inherit: other.$inherit ?? $inherit,
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
        $inherit,
      ];
}

// Default styles
final DefaultRemixSelectStyle = RemixSelectStyle(
  menuContainer: BoxMix(
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
    padding: EdgeInsetsMix.symmetric(vertical: 4),
  ),
  trigger: RemixSelectTriggerStyle(
    container: BoxMix(
      decoration: BoxDecorationMix(
        border: BoxBorderMix.all(
          BorderSideMix(color: RemixTokens.border(), width: 1),
        ),
        borderRadius: BorderRadiusMix.circular(6),
      ),
      padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
    ),
    flex: FlexMix(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
    ),
    label: TextMix(
      style: TextStyleMix(
        color: RemixTokens.textPrimary(),
        fontSize: RemixTokens.fontSizeSm(),
      ),
    ),
    icon: IconMix(color: RemixTokens.textSecondary(), size: 20),
  ),
  item: RemixSelectMenuItemStyle(
    container: BoxMix(
      padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
    ),
    flex: FlexMix(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
    ),
    text: TextMix(
      style: TextStyleMix(
        color: RemixTokens.textPrimary(),
        fontSize: RemixTokens.fontSizeSm(),
      ),
    ),
    icon: IconMix(color: RemixTokens.textSecondary(), size: 16),
  ),
  position: RemixCompositedTransformFollowerStyle(
    targetAnchor: Alignment.bottomLeft,
    followerAnchor: Alignment.topLeft,
    offset: const Offset(0, 4),
  ),
  animation: AnimationConfig.easeInOut(const Duration(milliseconds: 150)),
);

extension RemixSelectVariants on RemixSelectStyle {
  /// Primary select variant with blue accents
  static RemixSelectStyle get primary => RemixSelectStyle(
        menuContainer: BoxMix(
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
          padding: EdgeInsetsMix.symmetric(vertical: 4),
        ),
        trigger: RemixSelectTriggerStyle(
          container: BoxMix(
            decoration: BoxDecorationMix(
              border: BoxBorderMix.all(
                BorderSideMix(color: RemixTokens.primary(), width: 1),
              ),
              borderRadius: BorderRadiusMix.circular(6),
              color: RemixTokens.primary().withValues(alpha: 0.1),
            ),
            padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
          ),
          flex: FlexMix(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          label: TextMix(
            style: TextStyleMix(
              color: RemixTokens.primary(),
              fontSize: RemixTokens.fontSizeSm(),
            ),
          ),
          icon: IconMix(color: RemixTokens.primary(), size: 20),
        ),
        item: RemixSelectMenuItemStyle(
          container: BoxMix(
            padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
          ),
          flex: FlexMix(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          text: TextMix(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: RemixTokens.fontSizeSm(),
            ),
          ),
          icon: IconMix(color: RemixTokens.primary(), size: 16),
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
        menuContainer: BoxMix(
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
          padding: EdgeInsetsMix.symmetric(vertical: 4),
        ),
        trigger: RemixSelectTriggerStyle(
          container: BoxMix(
            decoration: BoxDecorationMix(
              border: BoxBorderMix.all(
                BorderSideMix(color: RemixTokens.textSecondary(), width: 1),
              ),
              borderRadius: BorderRadiusMix.circular(6),
              color: RemixTokens.surface(),
            ),
            padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
          ),
          flex: FlexMix(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          label: TextMix(
            style: TextStyleMix(
              color: RemixTokens.textSecondary(),
              fontSize: RemixTokens.fontSizeSm(),
            ),
          ),
          icon: IconMix(color: RemixTokens.textSecondary(), size: 20),
        ),
        item: RemixSelectMenuItemStyle(
          container: BoxMix(
            padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
          ),
          flex: FlexMix(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          text: TextMix(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: RemixTokens.fontSizeSm(),
            ),
          ),
          icon: IconMix(color: RemixTokens.textSecondary(), size: 16),
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
        menuContainer: BoxMix(
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
          padding: EdgeInsetsMix.symmetric(vertical: 4),
        ),
        trigger: RemixSelectTriggerStyle(
          container: BoxMix(
            decoration: BoxDecorationMix(
              border: BoxBorderMix.all(
                BorderSideMix(color: RemixTokens.border(), width: 2),
              ),
              borderRadius: BorderRadiusMix.circular(6),
              color: RemixTokens.surface().withValues(alpha: 0.0),
            ),
            padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
          ),
          flex: FlexMix(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          label: TextMix(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: RemixTokens.fontSizeSm(),
            ),
          ),
          icon: IconMix(color: RemixTokens.textSecondary(), size: 20),
        ),
        item: RemixSelectMenuItemStyle(
          container: BoxMix(
            padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
          ),
          flex: FlexMix(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          text: TextMix(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: RemixTokens.fontSizeSm(),
            ),
          ),
          icon: IconMix(color: RemixTokens.textSecondary(), size: 16),
        ),
        position: RemixCompositedTransformFollowerStyle(
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 4),
        ),
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 150)),
      );
}
