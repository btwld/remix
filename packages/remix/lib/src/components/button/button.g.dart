// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixButtonSpec implements Spec<RemixButtonSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<TextSpec> get label;
  StyleSpec<IconSpec> get icon;
  StyleSpec<RemixSpinnerSpec> get spinner;
  IconAlignment get iconAlignment;

  @override
  Type get type => RemixButtonSpec;

  @override
  RemixButtonSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
    StyleSpec<RemixSpinnerSpec>? spinner,
    IconAlignment? iconAlignment,
  }) {
    return RemixButtonSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      spinner: spinner ?? this.spinner,
      iconAlignment: iconAlignment ?? this.iconAlignment,
    );
  }

  @override
  RemixButtonSpec lerp(RemixButtonSpec? other, double t) {
    return RemixButtonSpec(
      container: container.lerp(other?.container, t),
      label: label.lerp(other?.label, t),
      icon: icon.lerp(other?.icon, t),
      spinner: spinner.lerp(other?.spinner, t),
      iconAlignment: MixOps.lerpSnap(iconAlignment, other?.iconAlignment, t),
    );
  }

  @override
  List<Object?> get props => [container, label, icon, spinner, iconAlignment];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixButtonSpec &&
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
      ..add(DiagnosticsProperty('icon', icon))
      ..add(DiagnosticsProperty('spinner', spinner))
      ..add(DiagnosticsProperty('iconAlignment', iconAlignment));
  }
}

@Deprecated(
  'Rename to `_\$RemixButtonSpec` and migrate the class declaration to `class RemixButtonSpec with _\$RemixButtonSpec`. The `_\$RemixButtonSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixButtonSpecMethods = _$RemixButtonSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class RemixButtonStyler extends MixStyler<RemixButtonStyler, RemixButtonSpec> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<StyleSpec<IconSpec>>? $icon;
  final Prop<StyleSpec<RemixSpinnerSpec>>? $spinner;
  final Prop<IconAlignment>? $iconAlignment;

  const RemixButtonStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    Prop<StyleSpec<RemixSpinnerSpec>>? spinner,
    Prop<IconAlignment>? iconAlignment,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $label = label,
       $icon = icon,
       $spinner = spinner,
       $iconAlignment = iconAlignment;

  RemixButtonStyler({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
    StyleSpec<RemixSpinnerSpec>? spinner,
    IconAlignment? iconAlignment,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<RemixButtonSpec>>? variants,
  }) : this.create(
         container: Prop.maybe(container),
         label: Prop.maybe(label),
         icon: Prop.maybe(icon),
         spinner: Prop.maybe(spinner),
         iconAlignment: Prop.maybe(iconAlignment),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory RemixButtonStyler.iconAlignment(IconAlignment value) =>
      RemixButtonStyler().iconAlignment(value);

  /// Sets the iconAlignment.
  RemixButtonStyler iconAlignment(IconAlignment value) {
    return merge(RemixButtonStyler(iconAlignment: value));
  }

  /// Sets the animation configuration.
  @override
  RemixButtonStyler animate(AnimationConfig value) {
    return merge(RemixButtonStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  RemixButtonStyler variants(List<VariantStyle<RemixButtonSpec>> value) {
    return merge(RemixButtonStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  RemixButtonStyler wrap(WidgetModifierConfig value) {
    return merge(RemixButtonStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixButtonStyler modifier(WidgetModifierConfig value) {
    return merge(RemixButtonStyler(modifier: value));
  }

  RemixButton call({
    Key? key,
    required String label,
    IconData? leadingIcon,
    IconData? trailingIcon,
    RemixButtonTextBuilder? textBuilder,
    RemixButtonIconBuilder? leadingIconBuilder,
    RemixButtonIconBuilder? trailingIconBuilder,
    RemixButtonLoadingBuilder? loadingBuilder,
    bool autofocus = false,
    bool loading = false,
    bool enabled = true,
    bool enableFeedback = true,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    FocusNode? focusNode,
    String? semanticLabel,
    String? semanticHint,
    bool excludeSemantics = false,
    MouseCursor mouseCursor = SystemMouseCursors.click,
  }) {
    return RemixButton(
      key: key,
      style: this,
      label: label,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      textBuilder: textBuilder,
      leadingIconBuilder: leadingIconBuilder,
      trailingIconBuilder: trailingIconBuilder,
      loadingBuilder: loadingBuilder,
      autofocus: autofocus,
      loading: loading,
      enabled: enabled,
      enableFeedback: enableFeedback,
      onPressed: onPressed,
      onLongPress: onLongPress,
      focusNode: focusNode,
      semanticLabel: semanticLabel,
      semanticHint: semanticHint,
      excludeSemantics: excludeSemantics,
      mouseCursor: mouseCursor,
    );
  }

  /// Merges with another [RemixButtonStyler].
  @override
  RemixButtonStyler merge(RemixButtonStyler? other) {
    return RemixButtonStyler.create(
      container: MixOps.merge($container, other?.$container),
      label: MixOps.merge($label, other?.$label),
      icon: MixOps.merge($icon, other?.$icon),
      spinner: MixOps.merge($spinner, other?.$spinner),
      iconAlignment: MixOps.merge($iconAlignment, other?.$iconAlignment),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixButtonSpec>] using [context].
  @override
  StyleSpec<RemixButtonSpec> resolve(BuildContext context) {
    final spec = RemixButtonSpec(
      container: MixOps.resolve(context, $container),
      label: MixOps.resolve(context, $label),
      icon: MixOps.resolve(context, $icon),
      spinner: MixOps.resolve(context, $spinner),
      iconAlignment: MixOps.resolve(context, $iconAlignment),
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
      ..add(DiagnosticsProperty('icon', $icon))
      ..add(DiagnosticsProperty('spinner', $spinner))
      ..add(DiagnosticsProperty('iconAlignment', $iconAlignment));
  }

  @override
  List<Object?> get props => [
    $container,
    $label,
    $icon,
    $spinner,
    $iconAlignment,
    $animation,
    $modifier,
    $variants,
  ];
}
