// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixAvatarSpecMethods on Spec<RemixAvatarSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<TextSpec> get text;
  StyleSpec<IconSpec> get icon;

  @override
  RemixAvatarSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? text,
    StyleSpec<IconSpec>? icon,
  }) {
    return RemixAvatarSpec(
      container: container ?? this.container,
      text: text ?? this.text,
      icon: icon ?? this.icon,
    );
  }

  @override
  RemixAvatarSpec lerp(RemixAvatarSpec? other, double t) {
    return RemixAvatarSpec(
      container: container.lerp(other?.container, t),
      text: text.lerp(other?.text, t),
      icon: icon.lerp(other?.icon, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('icon', icon));
  }

  @override
  List<Object?> get props => [container, text, icon];
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixAvatarStyleMixin on Style<RemixAvatarSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;
  Prop<StyleSpec<IconSpec>>? get $icon;
  Prop<StyleSpec<TextSpec>>? get $text;

  /// Sets the container.
  RemixAvatarStyle container(BoxStyler value) {
    return merge(RemixAvatarStyle(container: value));
  }

  /// Sets the icon.
  RemixAvatarStyle icon(IconStyler value) {
    return merge(RemixAvatarStyle(icon: value));
  }

  /// Sets the text.
  RemixAvatarStyle text(TextStyler value) {
    return merge(RemixAvatarStyle(text: value));
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

  /// Merges with another [RemixAvatarStyle].
  @override
  RemixAvatarStyle merge(RemixAvatarStyle? other) {
    return RemixAvatarStyle.create(
      container: MixOps.merge($container, other?.$container),
      icon: MixOps.merge($icon, other?.$icon),
      text: MixOps.merge($text, other?.$text),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixAvatarSpec>] using context.
  @override
  StyleSpec<RemixAvatarSpec> resolve(BuildContext context) {
    final spec = RemixAvatarSpec(
      container: MixOps.resolve(context, $container),
      icon: MixOps.resolve(context, $icon),
      text: MixOps.resolve(context, $text),
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
      ..add(DiagnosticsProperty('text', $text));
  }

  @override
  List<Object?> get props => [
    $container,
    $icon,
    $text,
    $animation,
    $modifier,
    $variants,
  ];
}
