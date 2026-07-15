// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popover.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixPopoverSpec implements Spec<RemixPopoverSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;

  @override
  Type get type => RemixPopoverSpec;

  @override
  RemixPopoverSpec copyWith({StyleSpec<BoxSpec>? container}) {
    return RemixPopoverSpec(container: container ?? this.container);
  }

  @override
  RemixPopoverSpec lerp(RemixPopoverSpec? other, double t) {
    return RemixPopoverSpec(container: container.lerp(other?.container, t));
  }

  @override
  List<Object?> get props => [container];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixPopoverSpec &&
            runtimeType == other.runtimeType &&
            propsEquals(props, other.props);
  }

  @override
  int get hashCode => propsHash(runtimeType, props);

  @override
  bool get stringify => true;

  @override
  Map<String, String> getDiff(Equatable other) {
    if (this == other) return const {};

    return propsDiff(props, other.props);
  }

  @override
  String toStringShort() => '$runtimeType';

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      toDiagnosticsNode(
        style: DiagnosticsTreeStyle.singleLine,
      ).toString(minLevel: minLevel);

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) =>
      DiagnosticableNode<Diagnosticable>(name: name, value: this, style: style);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty('container', container));
  }
}

@Deprecated(
  'Rename to `_\$RemixPopoverSpec` and migrate the class declaration to `class RemixPopoverSpec with _\$RemixPopoverSpec`. The `_\$RemixPopoverSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixPopoverSpecMethods = _$RemixPopoverSpec; // ignore: unused_element

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Fortal-themed preset for [RemixPopover].
class FortalPopover extends StatelessWidget {
  const FortalPopover({
    super.key,
    required this.popoverChild,
    required this.child,
    this.positioning = const OverlayPositionConfig(),
    this.consumeOutsideTaps = true,
    this.useRootOverlay = false,
    this.openOnTap = true,
    this.triggerFocusNode,
    this.onOpen,
    this.onClose,
    this.onOpenRequested,
    this.onCloseRequested,
    this.controller,
    this.semanticLabel,
    this.excludeSemantics = false,
  });

  final Widget popoverChild;

  final Widget child;

  final OverlayPositionConfig positioning;

  final bool consumeOutsideTaps;

  final bool useRootOverlay;

  final bool openOnTap;

  final FocusNode? triggerFocusNode;

  final VoidCallback? onOpen;

  final VoidCallback? onClose;

  final RawMenuAnchorOpenRequestedCallback? onOpenRequested;

  final RawMenuAnchorCloseRequestedCallback? onCloseRequested;

  final MenuController? controller;

  final String? semanticLabel;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    return fortalPopoverStyler().call(
      key: this.key,
      popoverChild: this.popoverChild,
      child: this.child,
      positioning: this.positioning,
      consumeOutsideTaps: this.consumeOutsideTaps,
      useRootOverlay: this.useRootOverlay,
      openOnTap: this.openOnTap,
      triggerFocusNode: this.triggerFocusNode,
      onOpen: this.onOpen,
      onClose: this.onClose,
      onOpenRequested: this.onOpenRequested,
      onCloseRequested: this.onCloseRequested,
      controller: this.controller,
      semanticLabel: this.semanticLabel,
      excludeSemantics: this.excludeSemantics,
    );
  }
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixPopoverStylerMixin on Style<RemixPopoverSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;

  /// Sets the container.
  RemixPopoverStyler container(BoxStyler value) {
    return merge(RemixPopoverStyler(container: value));
  }

  /// Sets the animation configuration.
  RemixPopoverStyler animate(AnimationConfig value) {
    return merge(RemixPopoverStyler(animation: value));
  }

  /// Sets the style variants.
  RemixPopoverStyler variants(List<VariantStyle<RemixPopoverSpec>> value) {
    return merge(RemixPopoverStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixPopoverStyler wrap(WidgetModifierConfig value) {
    return merge(RemixPopoverStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixPopoverStyler modifier(WidgetModifierConfig value) {
    return merge(RemixPopoverStyler(modifier: value));
  }

  /// Merges with another [RemixPopoverStyler].
  @override
  RemixPopoverStyler merge(RemixPopoverStyler? other) {
    return RemixPopoverStyler.create(
      container: MixOps.merge($container, other?.$container),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixPopoverSpec>] using [context].
  @override
  StyleSpec<RemixPopoverSpec> resolve(BuildContext context) {
    final spec = RemixPopoverSpec(
      container: MixOps.resolve(context, $container),
    );

    return StyleSpec(
      spec: spec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('container', $container));
  }

  @override
  List<Object?> get props => [$container, $animation, $modifier, $variants];
}
