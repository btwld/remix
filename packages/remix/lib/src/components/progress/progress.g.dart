// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixProgressSpec implements Spec<RemixProgressSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<BoxSpec> get track;
  StyleSpec<BoxSpec> get indicator;
  StyleSpec<BoxSpec> get trackContainer;

  @override
  Type get type => RemixProgressSpec;

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
  List<Object?> get props => [container, track, indicator, trackContainer];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixProgressSpec &&
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
      ..add(DiagnosticsProperty('track', track))
      ..add(DiagnosticsProperty('indicator', indicator))
      ..add(DiagnosticsProperty('trackContainer', trackContainer));
  }
}

@Deprecated(
  'Rename to `_\$RemixProgressSpec` and migrate the class declaration to `class RemixProgressSpec with _\$RemixProgressSpec`. The `_\$RemixProgressSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixProgressSpecMethods = _$RemixProgressSpec; // ignore: unused_element

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Creates a Fortal-themed [RemixProgressStyler].
class FortalProgress extends StatelessWidget {
  const FortalProgress({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    required this.value,
  });

  final FortalProgressVariant variant;

  final FortalProgressSize size;

  final double value;

  @override
  Widget build(BuildContext context) {
    return fortalProgressStyler(
      variant: this.variant,
      size: this.size,
    ).call(key: this.key, value: this.value);
  }
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixProgressStylerMixin on Style<RemixProgressSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;
  Prop<StyleSpec<BoxSpec>>? get $track;
  Prop<StyleSpec<BoxSpec>>? get $indicator;
  Prop<StyleSpec<BoxSpec>>? get $trackContainer;

  /// Sets the container.
  RemixProgressStyler container(BoxStyler value) {
    return merge(RemixProgressStyler(container: value));
  }

  /// Sets the track.
  RemixProgressStyler track(BoxStyler value) {
    return merge(RemixProgressStyler(track: value));
  }

  /// Sets the indicator.
  RemixProgressStyler indicator(BoxStyler value) {
    return merge(RemixProgressStyler(indicator: value));
  }

  /// Sets the trackContainer.
  RemixProgressStyler trackContainer(BoxStyler value) {
    return merge(RemixProgressStyler(trackContainer: value));
  }

  /// Sets the animation configuration.
  RemixProgressStyler animate(AnimationConfig value) {
    return merge(RemixProgressStyler(animation: value));
  }

  /// Sets the style variants.
  RemixProgressStyler variants(List<VariantStyle<RemixProgressSpec>> value) {
    return merge(RemixProgressStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixProgressStyler wrap(WidgetModifierConfig value) {
    return merge(RemixProgressStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixProgressStyler modifier(WidgetModifierConfig value) {
    return merge(RemixProgressStyler(modifier: value));
  }

  /// Merges with another [RemixProgressStyler].
  @override
  RemixProgressStyler merge(RemixProgressStyler? other) {
    return RemixProgressStyler.create(
      container: MixOps.merge($container, other?.$container),
      track: MixOps.merge($track, other?.$track),
      indicator: MixOps.merge($indicator, other?.$indicator),
      trackContainer: MixOps.merge($trackContainer, other?.$trackContainer),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixProgressSpec>] using [context].
  @override
  StyleSpec<RemixProgressSpec> resolve(BuildContext context) {
    final spec = RemixProgressSpec(
      container: MixOps.resolve(context, $container),
      track: MixOps.resolve(context, $track),
      indicator: MixOps.resolve(context, $indicator),
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
      ..add(DiagnosticsProperty('track', $track))
      ..add(DiagnosticsProperty('indicator', $indicator))
      ..add(DiagnosticsProperty('trackContainer', $trackContainer));
  }

  @override
  List<Object?> get props => [
    $container,
    $track,
    $indicator,
    $trackContainer,
    $animation,
    $modifier,
    $variants,
  ];
}
