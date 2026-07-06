// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accordion.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixAccordionSpec implements Spec<RemixAccordionSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get trigger;
  StyleSpec<IconSpec> get leadingIcon;
  StyleSpec<TextSpec> get title;
  StyleSpec<IconSpec> get trailingIcon;
  StyleSpec<BoxSpec> get content;

  @override
  Type get type => RemixAccordionSpec;

  @override
  RemixAccordionSpec copyWith({
    StyleSpec<FlexBoxSpec>? trigger,
    StyleSpec<IconSpec>? leadingIcon,
    StyleSpec<TextSpec>? title,
    StyleSpec<IconSpec>? trailingIcon,
    StyleSpec<BoxSpec>? content,
  }) {
    return RemixAccordionSpec(
      trigger: trigger ?? this.trigger,
      leadingIcon: leadingIcon ?? this.leadingIcon,
      title: title ?? this.title,
      trailingIcon: trailingIcon ?? this.trailingIcon,
      content: content ?? this.content,
    );
  }

  @override
  RemixAccordionSpec lerp(RemixAccordionSpec? other, double t) {
    return RemixAccordionSpec(
      trigger: trigger.lerp(other?.trigger, t),
      leadingIcon: leadingIcon.lerp(other?.leadingIcon, t),
      title: title.lerp(other?.title, t),
      trailingIcon: trailingIcon.lerp(other?.trailingIcon, t),
      content: content.lerp(other?.content, t),
    );
  }

  @override
  List<Object?> get props => [
    trigger,
    leadingIcon,
    title,
    trailingIcon,
    content,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixAccordionSpec &&
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
      ..add(DiagnosticsProperty('trigger', trigger))
      ..add(DiagnosticsProperty('leadingIcon', leadingIcon))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('trailingIcon', trailingIcon))
      ..add(DiagnosticsProperty('content', content));
  }
}

@Deprecated(
  'Rename to `_\$RemixAccordionSpec` and migrate the class declaration to `class RemixAccordionSpec with _\$RemixAccordionSpec`. The `_\$RemixAccordionSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixAccordionSpecMethods = _$RemixAccordionSpec; // ignore: unused_element

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Fortal-themed accordion style and widget presets.
class FortalAccordion<T> extends StatelessWidget {
  const FortalAccordion({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    required this.value,
    required this.child,
    this.title,
    this.leadingIcon,
    this.trailingIcon,
    this.builder,
    this.enabled = true,
    this.mouseCursor = SystemMouseCursors.click,
    this.enableFeedback = true,
    this.autofocus = false,
    this.focusNode,
    this.onFocusChange,
    this.onHoverChange,
    this.onPressChange,
    this.semanticLabel,
    this.transitionBuilder,
  });

  final FortalAccordionVariant variant;

  final FortalAccordionSize size;

  final T value;

  final Widget child;

  final String? title;

  final IconData? leadingIcon;

  final IconData? trailingIcon;

  final NakedAccordionTriggerBuilder<T>? builder;

  final bool enabled;

  final MouseCursor mouseCursor;

  final bool enableFeedback;

  final bool autofocus;

  final FocusNode? focusNode;

  final ValueChanged<bool>? onFocusChange;

  final ValueChanged<bool>? onHoverChange;

  final ValueChanged<bool>? onPressChange;

  final String? semanticLabel;

  final Widget Function(Widget, Animation<double>)? transitionBuilder;

  @override
  Widget build(BuildContext context) {
    return fortalAccordionStyle(variant: this.variant, size: this.size).call<T>(
      key: this.key,
      value: this.value,
      child: this.child,
      title: this.title,
      leadingIcon: this.leadingIcon,
      trailingIcon: this.trailingIcon,
      builder: this.builder,
      enabled: this.enabled,
      mouseCursor: this.mouseCursor,
      enableFeedback: this.enableFeedback,
      autofocus: this.autofocus,
      focusNode: this.focusNode,
      onFocusChange: this.onFocusChange,
      onHoverChange: this.onHoverChange,
      onPressChange: this.onPressChange,
      semanticLabel: this.semanticLabel,
      transitionBuilder: this.transitionBuilder,
    );
  }
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixAccordionStyleMixin on Style<RemixAccordionSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $trigger;
  Prop<StyleSpec<IconSpec>>? get $leadingIcon;
  Prop<StyleSpec<TextSpec>>? get $title;
  Prop<StyleSpec<IconSpec>>? get $trailingIcon;
  Prop<StyleSpec<BoxSpec>>? get $content;

  /// Sets the trigger.
  RemixAccordionStyle trigger(FlexBoxStyler value) {
    return merge(RemixAccordionStyle(trigger: value));
  }

  /// Sets the leadingIcon.
  RemixAccordionStyle leadingIcon(IconStyler value) {
    return merge(RemixAccordionStyle(leadingIcon: value));
  }

  /// Sets the title.
  RemixAccordionStyle title(TextStyler value) {
    return merge(RemixAccordionStyle(title: value));
  }

  /// Sets the trailingIcon.
  RemixAccordionStyle trailingIcon(IconStyler value) {
    return merge(RemixAccordionStyle(trailingIcon: value));
  }

  /// Sets the content.
  RemixAccordionStyle content(BoxStyler value) {
    return merge(RemixAccordionStyle(content: value));
  }

  /// Sets the animation configuration.
  RemixAccordionStyle animate(AnimationConfig value) {
    return merge(RemixAccordionStyle(animation: value));
  }

  /// Sets the style variants.
  RemixAccordionStyle variants(List<VariantStyle<RemixAccordionSpec>> value) {
    return merge(RemixAccordionStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixAccordionStyle wrap(WidgetModifierConfig value) {
    return merge(RemixAccordionStyle(modifier: value));
  }

  /// Sets the widget modifier.
  RemixAccordionStyle modifier(WidgetModifierConfig value) {
    return merge(RemixAccordionStyle(modifier: value));
  }

  /// Merges with another [RemixAccordionStyle].
  @override
  RemixAccordionStyle merge(RemixAccordionStyle? other) {
    return RemixAccordionStyle.create(
      trigger: MixOps.merge($trigger, other?.$trigger),
      leadingIcon: MixOps.merge($leadingIcon, other?.$leadingIcon),
      title: MixOps.merge($title, other?.$title),
      trailingIcon: MixOps.merge($trailingIcon, other?.$trailingIcon),
      content: MixOps.merge($content, other?.$content),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixAccordionSpec>] using [context].
  @override
  StyleSpec<RemixAccordionSpec> resolve(BuildContext context) {
    final spec = RemixAccordionSpec(
      trigger: MixOps.resolve(context, $trigger),
      leadingIcon: MixOps.resolve(context, $leadingIcon),
      title: MixOps.resolve(context, $title),
      trailingIcon: MixOps.resolve(context, $trailingIcon),
      content: MixOps.resolve(context, $content),
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
      ..add(DiagnosticsProperty('trigger', $trigger))
      ..add(DiagnosticsProperty('leadingIcon', $leadingIcon))
      ..add(DiagnosticsProperty('title', $title))
      ..add(DiagnosticsProperty('trailingIcon', $trailingIcon))
      ..add(DiagnosticsProperty('content', $content));
  }

  @override
  List<Object?> get props => [
    $trigger,
    $leadingIcon,
    $title,
    $trailingIcon,
    $content,
    $animation,
    $modifier,
    $variants,
  ];
}
