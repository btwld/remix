// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixRadioSpec implements Spec<RemixRadioSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<BoxSpec> get indicator;

  @override
  Type get type => RemixRadioSpec;

  @override
  RemixRadioSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? indicator,
  }) {
    return RemixRadioSpec(
      container: container ?? this.container,
      indicator: indicator ?? this.indicator,
    );
  }

  @override
  RemixRadioSpec lerp(RemixRadioSpec? other, double t) {
    return RemixRadioSpec(
      container: container.lerp(other?.container, t),
      indicator: indicator.lerp(other?.indicator, t),
    );
  }

  @override
  List<Object?> get props => [container, indicator];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixRadioSpec &&
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
      ..add(DiagnosticsProperty('indicator', indicator));
  }
}

@Deprecated(
  'Rename to `_\$RemixRadioSpec` and migrate the class declaration to `class RemixRadioSpec with _\$RemixRadioSpec`. The `_\$RemixRadioSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixRadioSpecMethods = _$RemixRadioSpec; // ignore: unused_element

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Fortal-themed radio style and widget presets.
class FortalRadio<T> extends StatelessWidget {
  const FortalRadio({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    required this.value,
    this.enabled = true,
    this.toggleable = false,
    this.mouseCursor,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
  });

  final FortalRadioVariant variant;

  final FortalRadioSize size;

  final T value;

  final bool enabled;

  final bool toggleable;

  final MouseCursor? mouseCursor;

  final bool enableFeedback;

  final FocusNode? focusNode;

  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return fortalRadioStyle(variant: this.variant, size: this.size).call<T>(
      key: this.key,
      value: this.value,
      enabled: this.enabled,
      toggleable: this.toggleable,
      mouseCursor: this.mouseCursor,
      enableFeedback: this.enableFeedback,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
    );
  }
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixRadioStyleMixin on Style<RemixRadioSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;
  Prop<StyleSpec<BoxSpec>>? get $indicator;

  /// Sets the container.
  RemixRadioStyle container(BoxStyler value) {
    return merge(RemixRadioStyle(container: value));
  }

  /// Sets the indicator.
  RemixRadioStyle indicator(BoxStyler value) {
    return merge(RemixRadioStyle(indicator: value));
  }

  /// Sets the animation configuration.
  RemixRadioStyle animate(AnimationConfig value) {
    return merge(RemixRadioStyle(animation: value));
  }

  /// Sets the style variants.
  RemixRadioStyle variants(List<VariantStyle<RemixRadioSpec>> value) {
    return merge(RemixRadioStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixRadioStyle wrap(WidgetModifierConfig value) {
    return merge(RemixRadioStyle(modifier: value));
  }

  /// Sets the widget modifier.
  RemixRadioStyle modifier(WidgetModifierConfig value) {
    return merge(RemixRadioStyle(modifier: value));
  }

  /// Merges with another [RemixRadioStyle].
  @override
  RemixRadioStyle merge(RemixRadioStyle? other) {
    return RemixRadioStyle.create(
      container: MixOps.merge($container, other?.$container),
      indicator: MixOps.merge($indicator, other?.$indicator),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixRadioSpec>] using [context].
  @override
  StyleSpec<RemixRadioSpec> resolve(BuildContext context) {
    final spec = RemixRadioSpec(
      container: MixOps.resolve(context, $container),
      indicator: MixOps.resolve(context, $indicator),
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
      ..add(DiagnosticsProperty('indicator', $indicator));
  }

  @override
  List<Object?> get props => [
    $container,
    $indicator,
    $animation,
    $modifier,
    $variants,
  ];
}
