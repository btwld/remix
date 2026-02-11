// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icon_button.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixIconButtonSpecMethods
    on Spec<RemixIconButtonSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<IconSpec> get icon;
  StyleSpec<RemixSpinnerSpec> get spinner;

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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('icon', icon))
      ..add(DiagnosticsProperty('spinner', spinner));
  }

  @override
  List<Object?> get props => [container, icon, spinner];
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixIconButtonStyleMixin
    on Style<RemixIconButtonSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;
  Prop<StyleSpec<IconSpec>>? get $icon;
  Prop<StyleSpec<RemixSpinnerSpec>>? get $spinner;

  /// Sets the container.
  RemixIconButtonStyle container(BoxStyler value) {
    return merge(RemixIconButtonStyle(container: value));
  }

  /// Sets the icon.
  RemixIconButtonStyle icon(IconStyler value) {
    return merge(RemixIconButtonStyle(icon: value));
  }

  /// Sets the spinner.
  RemixIconButtonStyle spinner(RemixSpinnerStyle value) {
    return merge(RemixIconButtonStyle(spinner: value));
  }

  /// Sets the animation configuration.
  RemixIconButtonStyle animate(AnimationConfig value) {
    return merge(RemixIconButtonStyle(animation: value));
  }

  /// Sets the style variants.
  RemixIconButtonStyle variants(List<VariantStyle<RemixIconButtonSpec>> value) {
    return merge(RemixIconButtonStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixIconButtonStyle wrap(WidgetModifierConfig value) {
    return merge(RemixIconButtonStyle(modifier: value));
  }

  /// Merges with another [RemixIconButtonStyle].
  @override
  RemixIconButtonStyle merge(RemixIconButtonStyle? other) {
    return RemixIconButtonStyle.create(
      container: MixOps.merge($container, other?.$container),
      icon: MixOps.merge($icon, other?.$icon),
      spinner: MixOps.merge($spinner, other?.$spinner),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixIconButtonSpec>] using context.
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
