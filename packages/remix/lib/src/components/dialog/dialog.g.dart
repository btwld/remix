// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixDialogSpecMethods on Spec<RemixDialogSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<TextSpec> get title;
  StyleSpec<TextSpec> get description;
  StyleSpec<FlexBoxSpec> get actions;
  StyleSpec<BoxSpec> get overlay;

  @override
  RemixDialogSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? title,
    StyleSpec<TextSpec>? description,
    StyleSpec<FlexBoxSpec>? actions,
    StyleSpec<BoxSpec>? overlay,
  }) {
    return RemixDialogSpec(
      container: container ?? this.container,
      title: title ?? this.title,
      description: description ?? this.description,
      actions: actions ?? this.actions,
      overlay: overlay ?? this.overlay,
    );
  }

  @override
  RemixDialogSpec lerp(RemixDialogSpec? other, double t) {
    return RemixDialogSpec(
      container: container.lerp(other?.container, t),
      title: title.lerp(other?.title, t),
      description: description.lerp(other?.description, t),
      actions: actions.lerp(other?.actions, t),
      overlay: overlay.lerp(other?.overlay, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('actions', actions))
      ..add(DiagnosticsProperty('overlay', overlay));
  }

  @override
  List<Object?> get props => [container, title, description, actions, overlay];
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixDialogStyleMixin on Style<RemixDialogSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $actions;
  Prop<StyleSpec<BoxSpec>>? get $container;
  Prop<StyleSpec<TextSpec>>? get $description;
  Prop<StyleSpec<BoxSpec>>? get $overlay;
  Prop<StyleSpec<TextSpec>>? get $title;

  /// Sets the actions.
  RemixDialogStyle actions(FlexBoxStyler value) {
    return merge(RemixDialogStyle(actions: value));
  }

  /// Sets the container.
  RemixDialogStyle container(BoxStyler value) {
    return merge(RemixDialogStyle(container: value));
  }

  /// Sets the description.
  RemixDialogStyle description(TextStyler value) {
    return merge(RemixDialogStyle(description: value));
  }

  /// Sets the overlay.
  RemixDialogStyle overlay(BoxStyler value) {
    return merge(RemixDialogStyle(overlay: value));
  }

  /// Sets the title.
  RemixDialogStyle title(TextStyler value) {
    return merge(RemixDialogStyle(title: value));
  }

  /// Sets the animation configuration.
  RemixDialogStyle animate(AnimationConfig value) {
    return merge(RemixDialogStyle(animation: value));
  }

  /// Sets the style variants.
  RemixDialogStyle variants(List<VariantStyle<RemixDialogSpec>> value) {
    return merge(RemixDialogStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixDialogStyle wrap(WidgetModifierConfig value) {
    return merge(RemixDialogStyle(modifier: value));
  }

  /// Merges with another [RemixDialogStyle].
  @override
  RemixDialogStyle merge(RemixDialogStyle? other) {
    return RemixDialogStyle.create(
      actions: MixOps.merge($actions, other?.$actions),
      container: MixOps.merge($container, other?.$container),
      description: MixOps.merge($description, other?.$description),
      overlay: MixOps.merge($overlay, other?.$overlay),
      title: MixOps.merge($title, other?.$title),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixDialogSpec>] using context.
  @override
  StyleSpec<RemixDialogSpec> resolve(BuildContext context) {
    final spec = RemixDialogSpec(
      actions: MixOps.resolve(context, $actions),
      container: MixOps.resolve(context, $container),
      description: MixOps.resolve(context, $description),
      overlay: MixOps.resolve(context, $overlay),
      title: MixOps.resolve(context, $title),
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
      ..add(DiagnosticsProperty('actions', $actions))
      ..add(DiagnosticsProperty('container', $container))
      ..add(DiagnosticsProperty('description', $description))
      ..add(DiagnosticsProperty('overlay', $overlay))
      ..add(DiagnosticsProperty('title', $title));
  }

  @override
  List<Object?> get props => [
    $actions,
    $container,
    $description,
    $overlay,
    $title,
    $animation,
    $modifier,
    $variants,
  ];
}
