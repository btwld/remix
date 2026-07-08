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
// MixWidgetGenerator
// **************************************************************************

/// Creates a Fortal-themed [RemixDialogStyler].
class FortalDialog extends StatelessWidget {
  const FortalDialog({
    super.key,
    this.child,
    this.title,
    this.description,
    this.actions,
    this.modal = true,
    this.semanticLabel,
  });

  final Widget? child;

  final String? title;

  final String? description;

  final List<Widget>? actions;

  final bool modal;

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return fortalDialogStyler().call(
      key: this.key,
      child: this.child,
      title: this.title,
      description: this.description,
      actions: this.actions,
      modal: this.modal,
      semanticLabel: this.semanticLabel,
    );
  }
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixDialogStylerMixin on Style<RemixDialogSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;
  Prop<StyleSpec<TextSpec>>? get $title;
  Prop<StyleSpec<TextSpec>>? get $description;
  Prop<StyleSpec<FlexBoxSpec>>? get $actions;
  Prop<StyleSpec<BoxSpec>>? get $overlay;

  /// Sets the container.
  RemixDialogStyler container(BoxStyler value) {
    return merge(RemixDialogStyler(container: value));
  }

  /// Sets the title.
  RemixDialogStyler title(TextStyler value) {
    return merge(RemixDialogStyler(title: value));
  }

  /// Sets the description.
  RemixDialogStyler description(TextStyler value) {
    return merge(RemixDialogStyler(description: value));
  }

  /// Sets the actions.
  RemixDialogStyler actions(FlexBoxStyler value) {
    return merge(RemixDialogStyler(actions: value));
  }

  /// Sets the overlay.
  RemixDialogStyler overlay(BoxStyler value) {
    return merge(RemixDialogStyler(overlay: value));
  }

  /// Sets the animation configuration.
  RemixDialogStyler animate(AnimationConfig value) {
    return merge(RemixDialogStyler(animation: value));
  }

  /// Sets the style variants.
  RemixDialogStyler variants(List<VariantStyle<RemixDialogSpec>> value) {
    return merge(RemixDialogStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixDialogStyler wrap(WidgetModifierConfig value) {
    return merge(RemixDialogStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixDialogStyler modifier(WidgetModifierConfig value) {
    return merge(RemixDialogStyler(modifier: value));
  }

  /// Merges with another [RemixDialogStyler].
  @override
  RemixDialogStyler merge(RemixDialogStyler? other) {
    return RemixDialogStyler.create(
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
