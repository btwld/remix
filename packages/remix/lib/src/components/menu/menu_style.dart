part of 'menu.dart';

/// Style configuration for [RemixMenu] trigger content.
///
/// Naked menu behavior wraps the trigger in a button; this style only controls
/// the visible trigger content.
@MixableStyler()
class RemixMenuTriggerStyler
    extends
        RemixFlexContainerStyler<RemixMenuTriggerSpec, RemixMenuTriggerStyler>
    with
        LabelStyleMixin<RemixMenuTriggerStyler>,
        IconStyleMixin<RemixMenuTriggerStyler>,
        Diagnosticable,
        _$RemixMenuTriggerStylerMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $label;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixMenuTriggerStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $label = label,
       $icon = icon;

  RemixMenuTriggerStyler({
    FlexBoxStyler? container,
    TextStyler? label,
    IconStyler? icon,
    AnimationConfig? animation,
    List<VariantStyle<RemixMenuTriggerSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         label: Prop.maybeMix(label),
         icon: Prop.maybeMix(icon),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  RemixMenuTriggerStyler alignment(Alignment value) {
    return merge(
      RemixMenuTriggerStyler(container: FlexBoxStyler(alignment: value)),
    );
  }

  @override
  RemixMenuTriggerStyler padding(EdgeInsetsGeometryMix value) {
    return merge(
      RemixMenuTriggerStyler(container: FlexBoxStyler(padding: value)),
    );
  }

  @override
  RemixMenuTriggerStyler color(Color value) {
    return merge(
      RemixMenuTriggerStyler(
        container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  @override
  RemixMenuTriggerStyler size(double width, double height) {
    return merge(
      RemixMenuTriggerStyler(
        container: FlexBoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: width,
            maxWidth: width,
            minHeight: height,
            maxHeight: height,
          ),
        ),
      ),
    );
  }

  @override
  RemixMenuTriggerStyler borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixMenuTriggerStyler(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  @override
  RemixMenuTriggerStyler constraints(BoxConstraintsMix value) {
    return merge(
      RemixMenuTriggerStyler(container: FlexBoxStyler(constraints: value)),
    );
  }

  @override
  RemixMenuTriggerStyler decoration(DecorationMix value) {
    return merge(
      RemixMenuTriggerStyler(container: FlexBoxStyler(decoration: value)),
    );
  }

  @override
  RemixMenuTriggerStyler margin(EdgeInsetsGeometryMix value) {
    return merge(
      RemixMenuTriggerStyler(container: FlexBoxStyler(margin: value)),
    );
  }

  @override
  RemixMenuTriggerStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixMenuTriggerStyler(
        container: FlexBoxStyler(foregroundDecoration: value),
      ),
    );
  }

  @override
  RemixMenuTriggerStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixMenuTriggerStyler(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  @override
  RemixMenuTriggerStyler flex(FlexStyler value) {
    return merge(
      RemixMenuTriggerStyler(container: FlexBoxStyler().flex(value)),
    );
  }
}

/// Style configuration for [RemixMenu] trigger, overlay, items, and dividers.
@MixableStyler()
class RemixMenuStyler extends RemixStyler<RemixMenuSpec, RemixMenuStyler>
    with Diagnosticable, _$RemixMenuStylerMixin {
  /// Trigger styling (resolved into spec)
  @MixableField(setterType: RemixMenuTriggerStyler)
  final Prop<StyleSpec<RemixMenuTriggerSpec>>? $trigger;

  /// Overlay styling (resolved into spec)
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $overlay;

  /// Default item style resolved by each item against its own widget state.
  @MixableField(setterType: RemixMenuItemStyler)
  final Prop<StyleSpec<RemixMenuItemSpec>>? $item;

  /// Default divider style for separators in the overlay.
  @MixableField(setterType: RemixDividerStyler)
  final Prop<StyleSpec<RemixDividerSpec>>? $divider;

  const RemixMenuStyler.create({
    Prop<StyleSpec<RemixMenuTriggerSpec>>? trigger,
    Prop<StyleSpec<FlexBoxSpec>>? overlay,
    Prop<StyleSpec<RemixMenuItemSpec>>? item,
    Prop<StyleSpec<RemixDividerSpec>>? divider,
    super.variants,
    super.animation,
    super.modifier,
  }) : $trigger = trigger,
       $overlay = overlay,
       $item = item,
       $divider = divider;

  RemixMenuStyler({
    RemixMenuTriggerStyler? trigger,
    FlexBoxStyler? overlay,
    RemixMenuItemStyler? item,
    RemixDividerStyler? divider,
    AnimationConfig? animation,
    List<VariantStyle<RemixMenuSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         trigger: Prop.maybeMix(trigger),
         overlay: Prop.maybeMix(overlay),
         item: Prop.maybeMix(item),
         divider: Prop.maybeMix(divider),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Creates a [RemixMenu] widget with this style applied.
  ///
  /// Example:
  /// ```dart
  /// RemixMenuStyler()
  ///   .trigger(...)
  ///   .overlay(...)
  ///   .call<String>(
  ///     trigger: RemixMenuTrigger(label: 'Options'),
  ///     items: [...],
  ///   )
  /// ```
  RemixMenu<T> call<T>({
    Key? key,
    required RemixMenuTrigger trigger,
    required List<RemixMenuItemData<T>> items,
    MenuController? controller,
    ValueChanged<T>? onSelected,
    VoidCallback? onOpen,
    VoidCallback? onClose,
    VoidCallback? onCanceled,
    RawMenuAnchorOpenRequestedCallback? onOpenRequested,
    RawMenuAnchorCloseRequestedCallback? onCloseRequested,
    bool consumeOutsideTaps = true,
    bool useRootOverlay = false,
    bool closeOnClickOutside = true,
    FocusNode? triggerFocusNode,
    OverlayPositionConfig positioning = const OverlayPositionConfig(),
  }) {
    return RemixMenu(
      key: key,
      trigger: trigger,
      items: items,
      controller: controller,
      onSelected: onSelected,
      onOpen: onOpen,
      onClose: onClose,
      onCanceled: onCanceled,
      onOpenRequested: onOpenRequested,
      onCloseRequested: onCloseRequested,
      consumeOutsideTaps: consumeOutsideTaps,
      useRootOverlay: useRootOverlay,
      closeOnClickOutside: closeOnClickOutside,
      triggerFocusNode: triggerFocusNode,
      positioning: positioning,
      style: this,
    );
  }
}

/// Style configuration for an item in a [RemixMenu].
@MixableStyler()
class RemixMenuItemStyler
    extends RemixFlexContainerStyler<RemixMenuItemSpec, RemixMenuItemStyler>
    with Diagnosticable, _$RemixMenuItemStylerMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $label;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $leadingIcon;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $trailingIcon;

  const RemixMenuItemStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? leadingIcon,
    Prop<StyleSpec<IconSpec>>? trailingIcon,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $label = label,
       $leadingIcon = leadingIcon,
       $trailingIcon = trailingIcon;

  RemixMenuItemStyler({
    FlexBoxStyler? container,
    TextStyler? label,
    IconStyler? leadingIcon,
    IconStyler? trailingIcon,
    AnimationConfig? animation,
    List<VariantStyle<RemixMenuItemSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         label: Prop.maybeMix(label),
         leadingIcon: Prop.maybeMix(leadingIcon),
         trailingIcon: Prop.maybeMix(trailingIcon),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets container alignment
  RemixMenuItemStyler alignment(Alignment value) {
    return merge(
      RemixMenuItemStyler(container: FlexBoxStyler(alignment: value)),
    );
  }

  // RemixFlexContainerStyler mixin implementations
  @override
  RemixMenuItemStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixMenuItemStyler(container: FlexBoxStyler(padding: value)));
  }

  @override
  RemixMenuItemStyler color(Color value) {
    return merge(
      RemixMenuItemStyler(
        container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  @override
  RemixMenuItemStyler size(double width, double height) {
    return merge(
      RemixMenuItemStyler(
        container: FlexBoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: width,
            maxWidth: width,
            minHeight: height,
            maxHeight: height,
          ),
        ),
      ),
    );
  }

  @override
  RemixMenuItemStyler borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixMenuItemStyler(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  @override
  RemixMenuItemStyler constraints(BoxConstraintsMix value) {
    return merge(
      RemixMenuItemStyler(container: FlexBoxStyler(constraints: value)),
    );
  }

  @override
  RemixMenuItemStyler decoration(DecorationMix value) {
    return merge(
      RemixMenuItemStyler(container: FlexBoxStyler(decoration: value)),
    );
  }

  @override
  RemixMenuItemStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixMenuItemStyler(container: FlexBoxStyler(margin: value)));
  }

  @override
  RemixMenuItemStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixMenuItemStyler(
        container: FlexBoxStyler(foregroundDecoration: value),
      ),
    );
  }

  @override
  RemixMenuItemStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixMenuItemStyler(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  @override
  RemixMenuItemStyler flex(FlexStyler value) {
    return merge(RemixMenuItemStyler(container: FlexBoxStyler().flex(value)));
  }
}
