// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tooltip.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixTooltipSpec implements Spec<RemixTooltipSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<TextSpec> get label;
  Duration? get waitDuration;
  Duration? get showDuration;
  Duration? get dismissDuration;

  @override
  Type get type => RemixTooltipSpec;

  @override
  RemixTooltipSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
    Duration? waitDuration,
    Duration? showDuration,
    Duration? dismissDuration,
  }) {
    return RemixTooltipSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      waitDuration: waitDuration ?? this.waitDuration,
      showDuration: showDuration ?? this.showDuration,
      dismissDuration: dismissDuration ?? this.dismissDuration,
    );
  }

  @override
  RemixTooltipSpec lerp(RemixTooltipSpec? other, double t) {
    return RemixTooltipSpec(
      container: container.lerp(other?.container, t),
      label: label.lerp(other?.label, t),
      waitDuration: MixOps.lerpSnap(waitDuration, other?.waitDuration, t),
      showDuration: MixOps.lerpSnap(showDuration, other?.showDuration, t),
      dismissDuration: MixOps.lerpSnap(
        dismissDuration,
        other?.dismissDuration,
        t,
      ),
    );
  }

  @override
  List<Object?> get props => [
    container,
    label,
    waitDuration,
    showDuration,
    dismissDuration,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixTooltipSpec &&
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
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('waitDuration', waitDuration))
      ..add(DiagnosticsProperty('showDuration', showDuration))
      ..add(DiagnosticsProperty('dismissDuration', dismissDuration));
  }
}

@Deprecated(
  'Rename to `_\$RemixTooltipSpec` and migrate the class declaration to `class RemixTooltipSpec with _\$RemixTooltipSpec`. The `_\$RemixTooltipSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixTooltipSpecMethods = _$RemixTooltipSpec; // ignore: unused_element

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Fortal-themed preset for [RemixTooltip].
class FortalTooltip extends StatelessWidget {
  const FortalTooltip({
    super.key,
    required this.tooltipChild,
    required this.child,
    this.tooltipSemantics,
    this.positioning = const OverlayPositionConfig(),
  });

  final Widget tooltipChild;

  final Widget child;

  final String? tooltipSemantics;

  final OverlayPositionConfig positioning;

  @override
  Widget build(BuildContext context) {
    return fortalTooltipStyler().call(
      key: this.key,
      tooltipChild: this.tooltipChild,
      child: this.child,
      tooltipSemantics: this.tooltipSemantics,
      positioning: this.positioning,
    );
  }
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixTooltipStylerMixin on Style<RemixTooltipSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;
  Prop<StyleSpec<TextSpec>>? get $label;
  Prop<Duration>? get $waitDuration;
  Prop<Duration>? get $showDuration;
  Prop<Duration>? get $dismissDuration;

  /// Sets the container.
  RemixTooltipStyler container(BoxStyler value) {
    return merge(RemixTooltipStyler(container: value));
  }

  /// Sets the label.
  RemixTooltipStyler label(TextStyler value) {
    return merge(RemixTooltipStyler(label: value));
  }

  /// Sets the waitDuration.
  RemixTooltipStyler waitDuration(Duration value) {
    return merge(RemixTooltipStyler(waitDuration: value));
  }

  /// Sets the showDuration.
  RemixTooltipStyler showDuration(Duration value) {
    return merge(RemixTooltipStyler(showDuration: value));
  }

  /// Sets the dismissDuration.
  RemixTooltipStyler dismissDuration(Duration value) {
    return merge(RemixTooltipStyler(dismissDuration: value));
  }

  /// Sets the animation configuration.
  RemixTooltipStyler animate(AnimationConfig value) {
    return merge(RemixTooltipStyler(animation: value));
  }

  /// Sets the style variants.
  RemixTooltipStyler variants(List<VariantStyle<RemixTooltipSpec>> value) {
    return merge(RemixTooltipStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixTooltipStyler wrap(WidgetModifierConfig value) {
    return merge(RemixTooltipStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixTooltipStyler modifier(WidgetModifierConfig value) {
    return merge(RemixTooltipStyler(modifier: value));
  }

  /// Merges with another [RemixTooltipStyler].
  @override
  RemixTooltipStyler merge(RemixTooltipStyler? other) {
    return RemixTooltipStyler.create(
      container: MixOps.merge($container, other?.$container),
      label: MixOps.merge($label, other?.$label),
      waitDuration: MixOps.merge($waitDuration, other?.$waitDuration),
      showDuration: MixOps.merge($showDuration, other?.$showDuration),
      dismissDuration: MixOps.merge($dismissDuration, other?.$dismissDuration),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixTooltipSpec>] using [context].
  @override
  StyleSpec<RemixTooltipSpec> resolve(BuildContext context) {
    final spec = RemixTooltipSpec(
      container: MixOps.resolve(context, $container),
      label: MixOps.resolve(context, $label),
      waitDuration: MixOps.resolve(context, $waitDuration),
      showDuration: MixOps.resolve(context, $showDuration),
      dismissDuration: MixOps.resolve(context, $dismissDuration),
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
    properties
      ..add(DiagnosticsProperty('container', $container))
      ..add(DiagnosticsProperty('label', $label))
      ..add(DiagnosticsProperty('waitDuration', $waitDuration))
      ..add(DiagnosticsProperty('showDuration', $showDuration))
      ..add(DiagnosticsProperty('dismissDuration', $dismissDuration));
  }

  @override
  List<Object?> get props => [
    $container,
    $label,
    $waitDuration,
    $showDuration,
    $dismissDuration,
    $animation,
    $modifier,
    $variants,
  ];
}
