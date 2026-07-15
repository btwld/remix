part of 'popover.dart';

/// Style configuration for a [RemixPopover] overlay container.
@MixableStyler()
class RemixPopoverStyler
    extends RemixContainerStyler<RemixPopoverSpec, RemixPopoverStyler>
    with Diagnosticable, _$RemixPopoverStylerMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;

  const RemixPopoverStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container;

  RemixPopoverStyler({
    BoxStyler? container,
    AnimationConfig? animation,
    List<VariantStyle<RemixPopoverSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Creates a style with the given padding.
  factory RemixPopoverStyler.padding(EdgeInsetsGeometryMix value) =>
      RemixPopoverStyler().padding(value);

  /// Creates a style with the given margin.
  factory RemixPopoverStyler.margin(EdgeInsetsGeometryMix value) =>
      RemixPopoverStyler().margin(value);

  /// Creates a style with the given border radius.
  factory RemixPopoverStyler.borderRadius(BorderRadiusGeometryMix value) =>
      RemixPopoverStyler().borderRadius(value);

  /// Creates a style with the given alignment.
  factory RemixPopoverStyler.alignment(Alignment value) =>
      RemixPopoverStyler().alignment(value);

  /// Creates a style with the given decoration.
  factory RemixPopoverStyler.decoration(DecorationMix value) =>
      RemixPopoverStyler().decoration(value);

  /// Creates a style with the given background color.
  factory RemixPopoverStyler.backgroundColor(Color value) =>
      RemixPopoverStyler().backgroundColor(value);

  /// Creates a style with the given constraints.
  factory RemixPopoverStyler.constraints(BoxConstraintsMix value) =>
      RemixPopoverStyler().constraints(value);

  /// Sets the popover background color.
  RemixPopoverStyler backgroundColor(Color value) => color(value);

  /// Creates a [RemixPopover] with this style applied.
  RemixPopover call({
    Key? key,
    required Widget popoverChild,
    required Widget child,
    OverlayPositionConfig positioning = const OverlayPositionConfig(),
    bool consumeOutsideTaps = true,
    bool useRootOverlay = false,
    bool openOnTap = true,
    FocusNode? triggerFocusNode,
    VoidCallback? onOpen,
    VoidCallback? onClose,
    RawMenuAnchorOpenRequestedCallback? onOpenRequested,
    RawMenuAnchorCloseRequestedCallback? onCloseRequested,
    MenuController? controller,
    String? semanticLabel,
    bool excludeSemantics = false,
  }) {
    return RemixPopover(
      key: key,
      popoverChild: popoverChild,
      positioning: positioning,
      consumeOutsideTaps: consumeOutsideTaps,
      useRootOverlay: useRootOverlay,
      openOnTap: openOnTap,
      triggerFocusNode: triggerFocusNode,
      onOpen: onOpen,
      onClose: onClose,
      onOpenRequested: onOpenRequested,
      onCloseRequested: onCloseRequested,
      controller: controller,
      semanticLabel: semanticLabel,
      excludeSemantics: excludeSemantics,
      style: this,
      child: child,
    );
  }

  /// Sets the overlay container alignment.
  @override
  RemixPopoverStyler alignment(Alignment value) {
    return merge(RemixPopoverStyler(container: BoxStyler(alignment: value)));
  }

  /// Sets padding inside the overlay container.
  @override
  RemixPopoverStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixPopoverStyler(container: BoxStyler(padding: value)));
  }

  /// Sets margin around the overlay container.
  @override
  RemixPopoverStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixPopoverStyler(container: BoxStyler(margin: value)));
  }

  /// Sets the overlay container decoration.
  @override
  RemixPopoverStyler decoration(DecorationMix value) {
    return merge(RemixPopoverStyler(container: BoxStyler(decoration: value)));
  }

  /// Sets constraints on the overlay container.
  @override
  RemixPopoverStyler constraints(BoxConstraintsMix value) {
    return merge(RemixPopoverStyler(container: BoxStyler(constraints: value)));
  }

  /// Sets a foreground decoration on the overlay container.
  @override
  RemixPopoverStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixPopoverStyler(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  /// Applies a transform to the overlay container.
  @override
  RemixPopoverStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixPopoverStyler(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }
}
