// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixAvatarSpec implements Spec<RemixAvatarSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<TextSpec> get label;
  StyleSpec<IconSpec> get icon;

  @override
  Type get type => RemixAvatarSpec;

  @override
  RemixAvatarSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  }) {
    return RemixAvatarSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      icon: icon ?? this.icon,
    );
  }

  @override
  RemixAvatarSpec lerp(RemixAvatarSpec? other, double t) {
    return RemixAvatarSpec(
      container: container.lerp(other?.container, t),
      label: label.lerp(other?.label, t),
      icon: icon.lerp(other?.icon, t),
    );
  }

  @override
  List<Object?> get props => [container, label, icon];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixAvatarSpec &&
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
      ..add(DiagnosticsProperty('icon', icon));
  }
}

@Deprecated(
  'Rename to `_\$RemixAvatarSpec` and migrate the class declaration to `class RemixAvatarSpec with _\$RemixAvatarSpec`. The `_\$RemixAvatarSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixAvatarSpecMethods = _$RemixAvatarSpec; // ignore: unused_element

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Creates a Fortal-themed [RemixAvatarStyle].
class FortalAvatar extends StatelessWidget {
  const FortalAvatar({
    super.key,
    this.variant = .soft,
    this.size = .size2,
    this.backgroundImage,
    this.foregroundImage,
    this.onBackgroundImageError,
    this.onForegroundImageError,
    this.child,
    this.label,
    this.labelBuilder,
    this.icon,
    this.iconBuilder,
  });

  final FortalAvatarVariant variant;

  final FortalAvatarSize size;

  final ImageProvider<Object>? backgroundImage;

  final ImageProvider<Object>? foregroundImage;

  final ImageErrorListener? onBackgroundImageError;

  final ImageErrorListener? onForegroundImageError;

  final Widget? child;

  final String? label;

  final RemixAvatarLabelBuilder? labelBuilder;

  final IconData? icon;

  final RemixAvatarIconBuilder? iconBuilder;

  @override
  Widget build(BuildContext context) {
    return fortalAvatarStyle(variant: this.variant, size: this.size).call(
      key: this.key,
      backgroundImage: this.backgroundImage,
      foregroundImage: this.foregroundImage,
      onBackgroundImageError: this.onBackgroundImageError,
      onForegroundImageError: this.onForegroundImageError,
      child: this.child,
      label: this.label,
      labelBuilder: this.labelBuilder,
      icon: this.icon,
      iconBuilder: this.iconBuilder,
    );
  }
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixAvatarStyleMixin on Style<RemixAvatarSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;
  Prop<StyleSpec<TextSpec>>? get $label;
  Prop<StyleSpec<IconSpec>>? get $icon;

  /// Sets the container.
  RemixAvatarStyle container(BoxStyler value) {
    return merge(RemixAvatarStyle(container: value));
  }

  /// Sets the label.
  RemixAvatarStyle label(TextStyler value) {
    return merge(RemixAvatarStyle(label: value));
  }

  /// Sets the icon.
  RemixAvatarStyle icon(IconStyler value) {
    return merge(RemixAvatarStyle(icon: value));
  }

  /// Sets the animation configuration.
  RemixAvatarStyle animate(AnimationConfig value) {
    return merge(RemixAvatarStyle(animation: value));
  }

  /// Sets the style variants.
  RemixAvatarStyle variants(List<VariantStyle<RemixAvatarSpec>> value) {
    return merge(RemixAvatarStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixAvatarStyle wrap(WidgetModifierConfig value) {
    return merge(RemixAvatarStyle(modifier: value));
  }

  /// Sets the widget modifier.
  RemixAvatarStyle modifier(WidgetModifierConfig value) {
    return merge(RemixAvatarStyle(modifier: value));
  }

  /// Merges with another [RemixAvatarStyle].
  @override
  RemixAvatarStyle merge(RemixAvatarStyle? other) {
    return RemixAvatarStyle.create(
      container: MixOps.merge($container, other?.$container),
      label: MixOps.merge($label, other?.$label),
      icon: MixOps.merge($icon, other?.$icon),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixAvatarSpec>] using [context].
  @override
  StyleSpec<RemixAvatarSpec> resolve(BuildContext context) {
    final spec = RemixAvatarSpec(
      container: MixOps.resolve(context, $container),
      label: MixOps.resolve(context, $label),
      icon: MixOps.resolve(context, $icon),
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
      ..add(DiagnosticsProperty('icon', $icon));
  }

  @override
  List<Object?> get props => [
    $container,
    $label,
    $icon,
    $animation,
    $modifier,
    $variants,
  ];
}
