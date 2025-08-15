part of 'select.dart';

class RemixSelectStyle extends Style<SelectSpec>
    with
        StyleModifierMixin<RemixSelectStyle, SelectSpec>,
        StyleVariantMixin<RemixSelectStyle, SelectSpec> {
  final Prop<BoxSpec>? $menuContainer;
  final Prop<SelectTriggerSpec>? $trigger;
  final Prop<SelectMenuItemSpec>? $item;
  final Prop<CompositedTransformFollowerSpec>? $position;

  const RemixSelectStyle.create({
    Prop<BoxSpec>? menuContainer,
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
    BoxMix? menuContainer,
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
  final Prop<FlexBoxSpec>? $container;
  final Prop<TextSpec>? $label;
  final Prop<IconThemeData>? $icon;

  const RemixSelectTriggerStyle.create({
    Prop<FlexBoxSpec>? container,
    Prop<TextSpec>? label,
    Prop<IconThemeData>? icon,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $label = label,
        $icon = icon;

  RemixSelectTriggerStyle({
    FlexBoxMix? container,
    TextMix? label,
    IconThemeData? icon,
    AnimationConfig? animation,
    List<VariantStyle<SelectTriggerSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: container != null ? Prop.mix(container) : null,
          label: label != null ? Prop.mix(label) : null,
          icon: Prop.maybe(icon),
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  @override
  SelectTriggerSpec resolve(BuildContext context) {
    return SelectTriggerSpec(
      container: MixOps.resolve(context, $container),
      label: MixOps.resolve(context, $label),
      icon: MixOps.resolve(context, $icon),
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
      inherit: other.$inherit ?? $inherit,
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
        $inherit,
      ];
}

class RemixSelectMenuItemStyle extends Style<SelectMenuItemSpec> {
  final Prop<FlexBoxSpec>? $container;
  final Prop<TextStyle>? $textStyle;
  final Prop<IconThemeData>? $icon;

  const RemixSelectMenuItemStyle.create({
    Prop<FlexBoxSpec>? container,
    Prop<TextStyle>? textStyle,
    Prop<IconThemeData>? icon,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $textStyle = textStyle,
        $icon = icon;

  RemixSelectMenuItemStyle({
    FlexBoxMix? container,
    TextStyle? textStyle,
    IconThemeData? icon,
    AnimationConfig? animation,
    List<VariantStyle<SelectMenuItemSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: container != null ? Prop.mix(container) : null,
          textStyle: Prop.maybe(textStyle),
          icon: Prop.maybe(icon),
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  @override
  SelectMenuItemSpec resolve(BuildContext context) {
    return SelectMenuItemSpec(
      container: MixOps.resolve(context, $container),
      textStyle: MixOps.resolve(context, $textStyle),
      icon: MixOps.resolve(context, $icon),
    );
  }

  @override
  RemixSelectMenuItemStyle merge(RemixSelectMenuItemStyle? other) {
    if (other == null) return this;

    return RemixSelectMenuItemStyle.create(
      container: MixOps.merge($container, other.$container),
      textStyle: other.$textStyle ?? $textStyle,
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
        $textStyle,
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
  menuContainer: BoxMix(
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
    container: FlexBoxMix(
      box: BoxMix(
        padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecorationMix(
          border: BoxBorderMix.all(
            BorderSideMix(color: Colors.grey.shade300, width: 1),
          ),
          borderRadius: BorderRadiusMix.circular(6),
        ),
      ),
      flex: FlexMix(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    ),
    label: TextMix(style: TextStyleMix(color: Colors.black87, fontSize: 14)),
    icon: IconThemeData(size: 20, color: Colors.black54),
  ),
  item: RemixSelectMenuItemStyle(
    container: FlexBoxMix(
      box: BoxMix(
        padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
      ),
      flex: FlexMix(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    ),
    textStyle: TextStyle(color: Colors.black87, fontSize: 14),
    icon: IconThemeData(size: 16, color: Colors.black54),
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
          container: FlexBoxMix(
            box: BoxMix(
              padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecorationMix(
                border: BoxBorderMix.all(
                  BorderSideMix(color: Colors.blue[500]!, width: 1),
                ),
                borderRadius: BorderRadiusMix.circular(6),
                color: Colors.blue[50],
              ),
            ),
            flex: FlexMix(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
          label: TextMix(
            style: TextStyleMix(color: Colors.blue[700], fontSize: 14),
          ),
          icon: IconThemeData(size: 20, color: Colors.blue[600]),
        ),
        item: RemixSelectMenuItemStyle(
          container: FlexBoxMix(
            box: BoxMix(
              padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
            ),
            flex: FlexMix(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
          textStyle: TextStyle(color: Colors.black87, fontSize: 14),
          icon: IconThemeData(size: 16, color: Colors.blue[500]),
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
          container: FlexBoxMix(
            box: BoxMix(
              padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecorationMix(
                border: BoxBorderMix.all(
                  BorderSideMix(color: Colors.grey[500]!, width: 1),
                ),
                borderRadius: BorderRadiusMix.circular(6),
                color: Colors.grey[50],
              ),
            ),
            flex: FlexMix(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
          label: TextMix(
            style: TextStyleMix(color: Colors.grey[700], fontSize: 14),
          ),
          icon: IconThemeData(size: 20, color: Colors.grey[600]),
        ),
        item: RemixSelectMenuItemStyle(
          container: FlexBoxMix(
            box: BoxMix(
              padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
            ),
            flex: FlexMix(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
          textStyle: TextStyle(color: Colors.black87, fontSize: 14),
          icon: IconThemeData(size: 16, color: Colors.grey[500]),
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
          container: FlexBoxMix(
            box: BoxMix(
              padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecorationMix(
                border: BoxBorderMix.all(
                  BorderSideMix(color: Colors.grey[400]!, width: 2),
                ),
                borderRadius: BorderRadiusMix.circular(6),
                color: Colors.transparent,
              ),
            ),
            flex: FlexMix(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
          label:
              TextMix(style: TextStyleMix(color: Colors.black87, fontSize: 14)),
          icon: IconThemeData(size: 20, color: Colors.black54),
        ),
        item: RemixSelectMenuItemStyle(
          container: FlexBoxMix(
            box: BoxMix(
              padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
            ),
            flex: FlexMix(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
          textStyle: TextStyle(color: Colors.black87, fontSize: 14),
          icon: IconThemeData(size: 16, color: Colors.black54),
        ),
        position: RemixCompositedTransformFollowerStyle(
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 4),
        ),
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 150)),
      );
}
