// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switch.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixSwitchSpec implements Spec<RemixSwitchSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<BoxSpec> get thumb;

  @override
  Type get type => RemixSwitchSpec;

  @override
  RemixSwitchSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? thumb,
  }) {
    return RemixSwitchSpec(
      container: container ?? this.container,
      thumb: thumb ?? this.thumb,
    );
  }

  @override
  RemixSwitchSpec lerp(RemixSwitchSpec? other, double t) {
    return RemixSwitchSpec(
      container: container.lerp(other?.container, t),
      thumb: thumb.lerp(other?.thumb, t),
    );
  }

  @override
  List<Object?> get props => [container, thumb];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixSwitchSpec &&
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
      ..add(DiagnosticsProperty('thumb', thumb));
  }
}

@Deprecated(
  'Rename to `_\$RemixSwitchSpec` and migrate the class declaration to `class RemixSwitchSpec with _\$RemixSwitchSpec`. The `_\$RemixSwitchSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixSwitchSpecMethods = _$RemixSwitchSpec; // ignore: unused_element

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Creates a Fortal-themed [RemixSwitchStyler].
class FortalSwitch extends StatelessWidget {
  const FortalSwitch({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    required this.selected,
    this.onChanged,
    this.enabled = true,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.click,
  });

  final FortalSwitchVariant variant;

  final FortalSwitchSize size;

  final bool selected;

  final ValueChanged<bool>? onChanged;

  final bool enabled;

  final bool enableFeedback;

  final FocusNode? focusNode;

  final bool autofocus;

  final String? semanticLabel;

  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext context) {
    return fortalSwitchStyler(variant: this.variant, size: this.size).call(
      selected: this.selected,
      onChanged: this.onChanged,
      enabled: this.enabled,
      enableFeedback: this.enableFeedback,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      semanticLabel: this.semanticLabel,
      mouseCursor: this.mouseCursor,
    );
  }
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixSwitchStylerMixin on Style<RemixSwitchSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;
  Prop<StyleSpec<BoxSpec>>? get $thumb;

  /// Sets the container.
  RemixSwitchStyler container(BoxStyler value) {
    return merge(RemixSwitchStyler(container: value));
  }

  /// Sets the thumb.
  RemixSwitchStyler thumb(BoxStyler value) {
    return merge(RemixSwitchStyler(thumb: value));
  }

  /// Sets the animation configuration.
  RemixSwitchStyler animate(AnimationConfig value) {
    return merge(RemixSwitchStyler(animation: value));
  }

  /// Sets the style variants.
  RemixSwitchStyler variants(List<VariantStyle<RemixSwitchSpec>> value) {
    return merge(RemixSwitchStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixSwitchStyler wrap(WidgetModifierConfig value) {
    return merge(RemixSwitchStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixSwitchStyler modifier(WidgetModifierConfig value) {
    return merge(RemixSwitchStyler(modifier: value));
  }

  /// Merges with another [RemixSwitchStyler].
  @override
  RemixSwitchStyler merge(RemixSwitchStyler? other) {
    return RemixSwitchStyler.create(
      container: MixOps.merge($container, other?.$container),
      thumb: MixOps.merge($thumb, other?.$thumb),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixSwitchSpec>] using [context].
  @override
  StyleSpec<RemixSwitchSpec> resolve(BuildContext context) {
    final spec = RemixSwitchSpec(
      container: MixOps.resolve(context, $container),
      thumb: MixOps.resolve(context, $thumb),
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
      ..add(DiagnosticsProperty('thumb', $thumb));
  }

  @override
  List<Object?> get props => [
    $container,
    $thumb,
    $animation,
    $modifier,
    $variants,
  ];
}
