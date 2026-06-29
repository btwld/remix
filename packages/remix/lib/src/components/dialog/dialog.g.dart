// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixDialogSpec implements Spec<RemixDialogSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<TextSpec> get title;
  StyleSpec<TextSpec> get description;
  StyleSpec<FlexBoxSpec> get actions;
  StyleSpec<BoxSpec> get overlay;

  @override
  Type get type => RemixDialogSpec;

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
  List<Object?> get props => [container, title, description, actions, overlay];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixDialogSpec &&
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
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('actions', actions))
      ..add(DiagnosticsProperty('overlay', overlay));
  }
}

@Deprecated(
  'Rename to `_\$RemixDialogSpec` and migrate the class declaration to `class RemixDialogSpec with _\$RemixDialogSpec`. The `_\$RemixDialogSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixDialogSpecMethods = _$RemixDialogSpec; // ignore: unused_element

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixDialogStyleMixin on Style<RemixDialogSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;
  Prop<StyleSpec<TextSpec>>? get $title;
  Prop<StyleSpec<TextSpec>>? get $description;
  Prop<StyleSpec<FlexBoxSpec>>? get $actions;
  Prop<StyleSpec<BoxSpec>>? get $overlay;

  /// Sets the container.
  RemixDialogStyle container(BoxStyler value) {
    return merge(RemixDialogStyle(container: value));
  }

  /// Sets the title.
  RemixDialogStyle title(TextStyler value) {
    return merge(RemixDialogStyle(title: value));
  }

  /// Sets the description.
  RemixDialogStyle description(TextStyler value) {
    return merge(RemixDialogStyle(description: value));
  }

  /// Sets the actions.
  RemixDialogStyle actions(FlexBoxStyler value) {
    return merge(RemixDialogStyle(actions: value));
  }

  /// Sets the overlay.
  RemixDialogStyle overlay(BoxStyler value) {
    return merge(RemixDialogStyle(overlay: value));
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

  /// Sets the widget modifier.
  RemixDialogStyle modifier(WidgetModifierConfig value) {
    return merge(RemixDialogStyle(modifier: value));
  }

  /// Merges with another [RemixDialogStyle].
  @override
  RemixDialogStyle merge(RemixDialogStyle? other) {
    return RemixDialogStyle.create(
      container: MixOps.merge($container, other?.$container),
      title: MixOps.merge($title, other?.$title),
      description: MixOps.merge($description, other?.$description),
      actions: MixOps.merge($actions, other?.$actions),
      overlay: MixOps.merge($overlay, other?.$overlay),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixDialogSpec>] using [context].
  @override
  StyleSpec<RemixDialogSpec> resolve(BuildContext context) {
    final spec = RemixDialogSpec(
      container: MixOps.resolve(context, $container),
      title: MixOps.resolve(context, $title),
      description: MixOps.resolve(context, $description),
      actions: MixOps.resolve(context, $actions),
      overlay: MixOps.resolve(context, $overlay),
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
      ..add(DiagnosticsProperty('title', $title))
      ..add(DiagnosticsProperty('description', $description))
      ..add(DiagnosticsProperty('actions', $actions))
      ..add(DiagnosticsProperty('overlay', $overlay));
  }

  @override
  List<Object?> get props => [
    $container,
    $title,
    $description,
    $actions,
    $overlay,
    $animation,
    $modifier,
    $variants,
  ];
}
