// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixProgressSpecMethods on Spec<RemixProgressSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<BoxSpec> get track;
  StyleSpec<BoxSpec> get indicator;
  StyleSpec<BoxSpec> get trackContainer;

  @override
  RemixProgressSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? track,
    StyleSpec<BoxSpec>? indicator,
    StyleSpec<BoxSpec>? trackContainer,
  }) {
    return RemixProgressSpec(
      container: container ?? this.container,
      track: track ?? this.track,
      indicator: indicator ?? this.indicator,
      trackContainer: trackContainer ?? this.trackContainer,
    );
  }

  @override
  RemixProgressSpec lerp(RemixProgressSpec? other, double t) {
    return RemixProgressSpec(
      container: container.lerp(other?.container, t),
      track: track.lerp(other?.track, t),
      indicator: indicator.lerp(other?.indicator, t),
      trackContainer: trackContainer.lerp(other?.trackContainer, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('track', track))
      ..add(DiagnosticsProperty('indicator', indicator))
      ..add(DiagnosticsProperty('trackContainer', trackContainer));
  }

  @override
  List<Object?> get props => [container, track, indicator, trackContainer];
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixProgressStyleMixin on Style<RemixProgressSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;
  Prop<StyleSpec<BoxSpec>>? get $indicator;
  Prop<StyleSpec<BoxSpec>>? get $track;
  Prop<StyleSpec<BoxSpec>>? get $trackContainer;

  /// Sets the container.
  RemixProgressStyle container(BoxStyler value) {
    return merge(RemixProgressStyle(container: value));
  }

  /// Sets the indicator.
  RemixProgressStyle indicator(BoxStyler value) {
    return merge(RemixProgressStyle(indicator: value));
  }

  /// Sets the track.
  RemixProgressStyle track(BoxStyler value) {
    return merge(RemixProgressStyle(track: value));
  }

  /// Sets the trackContainer.
  RemixProgressStyle trackContainer(BoxStyler value) {
    return merge(RemixProgressStyle(trackContainer: value));
  }

  /// Sets the animation configuration.
  RemixProgressStyle animate(AnimationConfig value) {
    return merge(RemixProgressStyle(animation: value));
  }

  /// Sets the style variants.
  RemixProgressStyle variants(List<VariantStyle<RemixProgressSpec>> value) {
    return merge(RemixProgressStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixProgressStyle wrap(WidgetModifierConfig value) {
    return merge(RemixProgressStyle(modifier: value));
  }

  /// Merges with another [RemixProgressStyle].
  @override
  RemixProgressStyle merge(RemixProgressStyle? other) {
    return RemixProgressStyle.create(
      container: MixOps.merge($container, other?.$container),
      indicator: MixOps.merge($indicator, other?.$indicator),
      track: MixOps.merge($track, other?.$track),
      trackContainer: MixOps.merge($trackContainer, other?.$trackContainer),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixProgressSpec>] using context.
  @override
  StyleSpec<RemixProgressSpec> resolve(BuildContext context) {
    final spec = RemixProgressSpec(
      container: MixOps.resolve(context, $container),
      indicator: MixOps.resolve(context, $indicator),
      track: MixOps.resolve(context, $track),
      trackContainer: MixOps.resolve(context, $trackContainer),
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
      ..add(DiagnosticsProperty('indicator', $indicator))
      ..add(DiagnosticsProperty('track', $track))
      ..add(DiagnosticsProperty('trackContainer', $trackContainer));
  }

  @override
  List<Object?> get props => [
    $container,
    $indicator,
    $track,
    $trackContainer,
    $animation,
    $modifier,
    $variants,
  ];
}
