part of 'select.dart';

class RemixSelectStyle extends Style<SelectSpec>
    with
        StyleModifierMixin<RemixSelectStyle, SelectSpec>,
        StyleVariantMixin<RemixSelectStyle, SelectSpec> {
  final Prop<WidgetContainerProperties>? $menuContainer;
  final Prop<SelectTriggerSpec>? $trigger;
  final Prop<SelectMenuItemSpec>? $item;
  final Prop<CompositedTransformFollowerSpec>? $position;

  const RemixSelectStyle.create({
    Prop<WidgetContainerProperties>? menuContainer,
    Prop<SelectTriggerSpec>? trigger,
    Prop<SelectMenuItemSpec>? item,
    Prop<CompositedTransformFollowerSpec>? position,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $menuContainer = menuContainer,
        $trigger = trigger,
        $item = item,
        $position = position;

  RemixSelectStyle({
    WidgetContainerPropertiesMix? menuContainer,
    RemixSelectTriggerStyle? trigger,
    RemixSelectMenuItemStyle? item,
    RemixCompositedTransformFollowerStyle? position,
    AnimationConfig? animation,
    List<VariantStyle<SelectSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          menuContainer: menuContainer != null ? Prop.mix(menuContainer) : null,
          trigger: trigger != null ? Prop.mix(trigger) : null,
          item: item != null ? Prop.mix(item) : null,
          position: position != null ? Prop.mix(position) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixSelectStyle.value(SelectSpec spec) => RemixSelectStyle(
        menuContainer: WidgetContainerPropertiesMix.maybeValue(spec.menuContainer),
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
  SelectSpec resolve(BuildContext context) {
    return SelectSpec(
      trigger: MixOps.resolve(context, $trigger),
      menuContainer: MixOps.resolve(context, $menuContainer),
      item: MixOps.resolve(context, $item),
      position: MixOps.resolve(context, $position),
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
  final Prop<WidgetContainerProperties>? $container;
  final Prop<WidgetFlexProperties>? $flex;
  final Prop<TextSpec>? $label;
  final Prop<IconSpec>? $icon;

  const RemixSelectTriggerStyle.create({
    Prop<WidgetContainerProperties>? container,
    Prop<WidgetFlexProperties>? flex,
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
    WidgetContainerPropertiesMix? container,
    WidgetFlexPropertiesMix? flex,
    TextMix? label,
    IconMix? icon,
    AnimationConfig? animation,
    List<VariantStyle<SelectTriggerSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: container != null ? Prop.mix(container) : null,
          flex: flex != null ? Prop.mix(flex) : null,
          label: label != null ? Prop.mix(label) : null,
          icon: icon != null ? Prop.mix(icon) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixSelectTriggerStyle.value(SelectTriggerSpec spec) => RemixSelectTriggerStyle(
        container: WidgetContainerPropertiesMix.maybeValue(spec.container),
        flex: WidgetFlexPropertiesMix.maybeValue(spec.flex),
      );

  @override
  SelectTriggerSpec resolve(BuildContext context) {
    return SelectTriggerSpec(
      container: MixOps.resolve(context, $container),
      flex: MixOps.resolve(context, $flex),
      label: MixOps.resolve(context, $label),
      icon: MixOps.resolve(context, $icon),
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
  final Prop<WidgetContainerProperties>? $container;
  final Prop<WidgetFlexProperties>? $flex;
  final Prop<TextSpec>? $text;
  final Prop<IconSpec>? $icon;

  const RemixSelectMenuItemStyle.create({
    Prop<WidgetContainerProperties>? container,
    Prop<WidgetFlexProperties>? flex,
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
    WidgetContainerPropertiesMix? container,
    WidgetFlexPropertiesMix? flex,
    TextMix? text,
    IconMix? icon,
    AnimationConfig? animation,
    List<VariantStyle<SelectMenuItemSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: container != null ? Prop.mix(container) : null,
          flex: flex != null ? Prop.mix(flex) : null,
          text: text != null ? Prop.mix(text) : null,
          icon: icon != null ? Prop.mix(icon) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixSelectMenuItemStyle.value(SelectMenuItemSpec spec) => RemixSelectMenuItemStyle(
        container: WidgetContainerPropertiesMix.maybeValue(spec.container),
        flex: WidgetFlexPropertiesMix.maybeValue(spec.flex),
      );

  @override
  SelectMenuItemSpec resolve(BuildContext context) {
    return SelectMenuItemSpec(
      container: MixOps.resolve(context, $container),
      flex: MixOps.resolve(context, $flex),
      text: MixOps.resolve(context, $text),
      icon: MixOps.resolve(context, $icon),
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
  CompositedTransformFollowerSpec resolve(BuildContext context) {
    return CompositedTransformFollowerSpec(
      offset: MixOps.resolve(context, $offset),
      targetAnchor: MixOps.resolve(context, $targetAnchor),
      followerAnchor: MixOps.resolve(context, $followerAnchor),
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
  menuContainer: WidgetContainerPropertiesMix(
    padding: EdgeInsetsMix.symmetric(vertical: 4),
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(8),
      color: Colors.white,
      boxShadow: [
        BoxShadowMix(
          color: Colors.black.withValues(alpha: 0.1),
          offset: const Offset(0, 2),
          blurRadius: 8,
        ),
      ],
    ),
  ),
  trigger: RemixSelectTriggerStyle(
    container: WidgetContainerPropertiesMix(
      padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecorationMix(
        border: BoxBorderMix.all(
          BorderSideMix(color: Colors.grey.shade300, width: 1),
        ),
        borderRadius: BorderRadiusMix.circular(6),
      ),
    ),
    flex: WidgetFlexPropertiesMix(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
    ),
    label: TextMix(style: TextStyleMix(color: Colors.black87, fontSize: 14)),
    icon: IconMix(size: 20, color: Colors.black54),
  ),
  item: RemixSelectMenuItemStyle(
    container: WidgetContainerPropertiesMix(
      padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
    ),
    flex: WidgetFlexPropertiesMix(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
    ),
    text: TextMix(style: TextStyleMix(color: Colors.black87, fontSize: 14)),
    icon: IconMix(size: 16, color: Colors.black54),
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
        menuContainer: WidgetContainerPropertiesMix(
          padding: EdgeInsetsMix.symmetric(vertical: 4),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadowMix(
              color: Colors.blue.withValues(alpha: 0.2),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        trigger: RemixSelectTriggerStyle(
          container: WidgetContainerPropertiesMix(
            padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecorationMix(
              border: BoxBorderMix.all(
                  BorderSideMix(color: Colors.blue[500]!, width: 1),
              ),
              borderRadius: BorderRadiusMix.circular(6),
              color: Colors.blue[50],
            ),
          ),
          flex: WidgetFlexPropertiesMix(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          label: TextMix(
            style: TextStyleMix(color: Colors.blue[700], fontSize: 14),
          ),
          icon: IconMix(size: 20, color: Colors.blue[600]),
        ),
        item: RemixSelectMenuItemStyle(
          container: WidgetContainerPropertiesMix(
            padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
          ),
          flex: WidgetFlexPropertiesMix(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          text: TextMix(style: TextStyleMix(color: Colors.black87, fontSize: 14)),
          icon: IconMix(size: 16, color: Colors.blue[500]),
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
        menuContainer: WidgetContainerPropertiesMix(
          padding: EdgeInsetsMix.symmetric(vertical: 4),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadowMix(
              color: Colors.grey.withValues(alpha: 0.2),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        trigger: RemixSelectTriggerStyle(
          container: WidgetContainerPropertiesMix(
            padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecorationMix(
              border: BoxBorderMix.all(
                  BorderSideMix(color: Colors.grey[500]!, width: 1),
              ),
              borderRadius: BorderRadiusMix.circular(6),
              color: Colors.grey[50],
            ),
          ),
          flex: WidgetFlexPropertiesMix(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          label: TextMix(
            style: TextStyleMix(color: Colors.grey[700], fontSize: 14),
          ),
          icon: IconMix(size: 20, color: Colors.grey[600]),
        ),
        item: RemixSelectMenuItemStyle(
          container: WidgetContainerPropertiesMix(
            padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
          ),
          flex: WidgetFlexPropertiesMix(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          text: TextMix(style: TextStyleMix(color: Colors.black87, fontSize: 14)),
          icon: IconMix(size: 16, color: Colors.grey[500]),
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
        menuContainer: WidgetContainerPropertiesMix(
          padding: EdgeInsetsMix.symmetric(vertical: 4),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: Colors.grey[300]!, width: 1),
            ),
            borderRadius: BorderRadiusMix.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadowMix(
              color: Colors.black.withValues(alpha: 0.1),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        trigger: RemixSelectTriggerStyle(
          container: WidgetContainerPropertiesMix(
            padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecorationMix(
              border: BoxBorderMix.all(
                  BorderSideMix(color: Colors.grey[400]!, width: 2),
              ),
              borderRadius: BorderRadiusMix.circular(6),
              color: Colors.transparent,
            ),
          ),
          flex: WidgetFlexPropertiesMix(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          label:
              TextMix(style: TextStyleMix(color: Colors.black87, fontSize: 14)),
          icon: IconMix(size: 20, color: Colors.black54),
        ),
        item: RemixSelectMenuItemStyle(
          container: WidgetContainerPropertiesMix(
            padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
          ),
          flex: WidgetFlexPropertiesMix(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          text: TextMix(style: TextStyleMix(color: Colors.black87, fontSize: 14)),
          icon: IconMix(size: 16, color: Colors.black54),
        ),
        position: RemixCompositedTransformFollowerStyle(
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 4),
        ),
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 150)),
      );
}
