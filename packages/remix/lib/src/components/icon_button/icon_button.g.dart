// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icon_button.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixIconButtonSpec
    implements Spec<RemixIconButtonSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<IconSpec> get icon;
  StyleSpec<RemixSpinnerSpec> get spinner;

  @override
  Type get type => RemixIconButtonSpec;

  @override
  RemixIconButtonSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<IconSpec>? icon,
    StyleSpec<RemixSpinnerSpec>? spinner,
  }) {
    return RemixIconButtonSpec(
      container: container ?? this.container,
      icon: icon ?? this.icon,
      spinner: spinner ?? this.spinner,
    );
  }

  @override
  RemixIconButtonSpec lerp(RemixIconButtonSpec? other, double t) {
    return RemixIconButtonSpec(
      container: container.lerp(other?.container, t),
      icon: icon.lerp(other?.icon, t),
      spinner: spinner.lerp(other?.spinner, t),
    );
  }

  @override
  List<Object?> get props => [container, icon, spinner];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixIconButtonSpec &&
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
      ..add(DiagnosticsProperty('icon', icon))
      ..add(DiagnosticsProperty('spinner', spinner));
  }
}

@Deprecated(
  'Rename to `_\$RemixIconButtonSpec` and migrate the class declaration to `class RemixIconButtonSpec with _\$RemixIconButtonSpec`. The `_\$RemixIconButtonSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixIconButtonSpecMethods = _$RemixIconButtonSpec; // ignore: unused_element

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Creates a Fortal-themed [RemixIconButtonStyler].
class FortalIconButton extends StatelessWidget {
  const FortalIconButton({
    super.key,
    this.variant = .solid,
    this.size = .size2,
    required this.icon,
    this.onPressed,
    this.loading = false,
    this.enabled = true,
    this.enableFeedback = true,
    this.focusNode,
  });

  final FortalIconButtonVariant variant;

  final FortalIconButtonSize size;

  final IconData icon;

  final VoidCallback? onPressed;

  final bool loading;

  final bool enabled;

  final bool enableFeedback;

  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return fortalIconButtonStyler(variant: this.variant, size: this.size).call(
      icon: this.icon,
      onPressed: this.onPressed,
      loading: this.loading,
      enabled: this.enabled,
      enableFeedback: this.enableFeedback,
      focusNode: this.focusNode,
    );
  }
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixIconButtonStylerMixin
    on Style<RemixIconButtonSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;
  Prop<StyleSpec<IconSpec>>? get $icon;
  Prop<StyleSpec<RemixSpinnerSpec>>? get $spinner;

  /// Sets the container.
  RemixIconButtonStyler container(BoxStyler value) {
    return merge(RemixIconButtonStyler(container: value));
  }

  /// Sets the icon.
  RemixIconButtonStyler icon(IconStyler value) {
    return merge(RemixIconButtonStyler(icon: value));
  }

  /// Sets the spinner.
  RemixIconButtonStyler spinner(RemixSpinnerStyler value) {
    return merge(RemixIconButtonStyler(spinner: value));
  }

  /// Sets the animation configuration.
  RemixIconButtonStyler animate(AnimationConfig value) {
    return merge(RemixIconButtonStyler(animation: value));
  }

  /// Sets the style variants.
  RemixIconButtonStyler variants(
    List<VariantStyle<RemixIconButtonSpec>> value,
  ) {
    return merge(RemixIconButtonStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixIconButtonStyler wrap(WidgetModifierConfig value) {
    return merge(RemixIconButtonStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixIconButtonStyler modifier(WidgetModifierConfig value) {
    return merge(RemixIconButtonStyler(modifier: value));
  }

  /// Merges with another [RemixIconButtonStyler].
  @override
  RemixIconButtonStyler merge(RemixIconButtonStyler? other) {
    return RemixIconButtonStyler.create(
      container: MixOps.merge($container, other?.$container),
      icon: MixOps.merge($icon, other?.$icon),
      spinner: MixOps.merge($spinner, other?.$spinner),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixIconButtonSpec>] using [context].
  @override
  StyleSpec<RemixIconButtonSpec> resolve(BuildContext context) {
    final spec = RemixIconButtonSpec(
      container: MixOps.resolve(context, $container),
      icon: MixOps.resolve(context, $icon),
      spinner: MixOps.resolve(context, $spinner),
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
      ..add(DiagnosticsProperty('icon', $icon))
      ..add(DiagnosticsProperty('spinner', $spinner));
  }

  @override
  List<Object?> get props => [
    $container,
    $icon,
    $spinner,
    $animation,
    $modifier,
    $variants,
  ];
}
