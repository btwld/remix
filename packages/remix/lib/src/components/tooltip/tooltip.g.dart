// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tooltip.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixTooltipSpecMethods on Spec<RemixTooltipSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<TextSpec> get label;
  Duration? get waitDuration;
  Duration? get showDuration;

  @override
  RemixTooltipSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
    Duration? waitDuration,
    Duration? showDuration,
  }) {
    return RemixTooltipSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      waitDuration: waitDuration ?? this.waitDuration,
      showDuration: showDuration ?? this.showDuration,
    );
  }

  @override
  RemixTooltipSpec lerp(RemixTooltipSpec? other, double t) {
    return RemixTooltipSpec(
      container: container.lerp(other?.container, t),
      label: label.lerp(other?.label, t),
      waitDuration: MixOps.lerpSnap(waitDuration, other?.waitDuration, t),
      showDuration: MixOps.lerpSnap(showDuration, other?.showDuration, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('waitDuration', waitDuration))
      ..add(DiagnosticsProperty('showDuration', showDuration));
  }

  @override
  List<Object?> get props => [container, label, waitDuration, showDuration];
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixTooltipStyleMixin on Style<RemixTooltipSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;
  Prop<StyleSpec<TextSpec>>? get $label;
  Prop<Duration>? get $showDuration;
  Prop<Duration>? get $waitDuration;

  /// Sets the container.
  RemixTooltipStyle container(BoxStyler value) {
    return merge(RemixTooltipStyle(container: value));
  }

  /// Sets the label.
  RemixTooltipStyle label(TextStyler value) {
    return merge(RemixTooltipStyle(label: value));
  }

  /// Sets the showDuration.
  RemixTooltipStyle showDuration(Duration value) {
    return merge(RemixTooltipStyle(showDuration: value));
  }

  /// Sets the waitDuration.
  RemixTooltipStyle waitDuration(Duration value) {
    return merge(RemixTooltipStyle(waitDuration: value));
  }

  /// Sets the animation configuration.
  RemixTooltipStyle animate(AnimationConfig value) {
    return merge(RemixTooltipStyle(animation: value));
  }

  /// Sets the style variants.
  RemixTooltipStyle variants(List<VariantStyle<RemixTooltipSpec>> value) {
    return merge(RemixTooltipStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixTooltipStyle wrap(WidgetModifierConfig value) {
    return merge(RemixTooltipStyle(modifier: value));
  }

  /// Merges with another [RemixTooltipStyle].
  @override
  RemixTooltipStyle merge(RemixTooltipStyle? other) {
    return RemixTooltipStyle.create(
      container: MixOps.merge($container, other?.$container),
      label: MixOps.merge($label, other?.$label),
      showDuration: MixOps.merge($showDuration, other?.$showDuration),
      waitDuration: MixOps.merge($waitDuration, other?.$waitDuration),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixTooltipSpec>] using context.
  @override
  StyleSpec<RemixTooltipSpec> resolve(BuildContext context) {
    final spec = RemixTooltipSpec(
      container: MixOps.resolve(context, $container),
      label: MixOps.resolve(context, $label),
      showDuration: MixOps.resolve(context, $showDuration),
      waitDuration: MixOps.resolve(context, $waitDuration),
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
      ..add(DiagnosticsProperty('showDuration', $showDuration))
      ..add(DiagnosticsProperty('waitDuration', $waitDuration));
  }

  @override
  List<Object?> get props => [
    $container,
    $label,
    $showDuration,
    $waitDuration,
    $animation,
    $modifier,
    $variants,
  ];
}
