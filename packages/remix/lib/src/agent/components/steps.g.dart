// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'steps.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$AgentStepsSpec implements Spec<AgentStepsSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<FlexBoxSpec> get trigger;
  StyleSpec<IconSpec> get icon;
  StyleSpec<TextSpec> get label;
  StyleSpec<IconSpec> get indicator;
  StyleSpec<FlexBoxSpec> get rail;

  @override
  Type get type => AgentStepsSpec;

  @override
  AgentStepsSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<FlexBoxSpec>? trigger,
    StyleSpec<IconSpec>? icon,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? indicator,
    StyleSpec<FlexBoxSpec>? rail,
  }) {
    return AgentStepsSpec(
      container: container ?? this.container,
      trigger: trigger ?? this.trigger,
      icon: icon ?? this.icon,
      label: label ?? this.label,
      indicator: indicator ?? this.indicator,
      rail: rail ?? this.rail,
    );
  }

  @override
  AgentStepsSpec lerp(AgentStepsSpec? other, double t) {
    return AgentStepsSpec(
      container: container.lerp(other?.container, t),
      trigger: trigger.lerp(other?.trigger, t),
      icon: icon.lerp(other?.icon, t),
      label: label.lerp(other?.label, t),
      indicator: indicator.lerp(other?.indicator, t),
      rail: rail.lerp(other?.rail, t),
    );
  }

  @override
  List<Object?> get props => [container, trigger, icon, label, indicator, rail];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AgentStepsSpec &&
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
      ..add(DiagnosticsProperty('trigger', trigger))
      ..add(DiagnosticsProperty('icon', icon))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('indicator', indicator))
      ..add(DiagnosticsProperty('rail', rail));
  }
}

@Deprecated(
  'Rename to `_\$AgentStepsSpec` and migrate the class declaration to `class AgentStepsSpec with _\$AgentStepsSpec`. The `_\$AgentStepsSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$AgentStepsSpecMethods = _$AgentStepsSpec; // ignore: unused_element

mixin _$AgentStepSpec implements Spec<AgentStepSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<IconSpec> get icon;
  StyleSpec<TextSpec> get title;
  StyleSpec<TextSpec> get detail;

  @override
  Type get type => AgentStepSpec;

  @override
  AgentStepSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<IconSpec>? icon,
    StyleSpec<TextSpec>? title,
    StyleSpec<TextSpec>? detail,
  }) {
    return AgentStepSpec(
      container: container ?? this.container,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      detail: detail ?? this.detail,
    );
  }

  @override
  AgentStepSpec lerp(AgentStepSpec? other, double t) {
    return AgentStepSpec(
      container: container.lerp(other?.container, t),
      icon: icon.lerp(other?.icon, t),
      title: title.lerp(other?.title, t),
      detail: detail.lerp(other?.detail, t),
    );
  }

  @override
  List<Object?> get props => [container, icon, title, detail];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AgentStepSpec &&
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
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('detail', detail));
  }
}

@Deprecated(
  'Rename to `_\$AgentStepSpec` and migrate the class declaration to `class AgentStepSpec with _\$AgentStepSpec`. The `_\$AgentStepSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$AgentStepSpecMethods = _$AgentStepSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class AgentStepsStyler extends MixStyler<AgentStepsStyler, AgentStepsSpec>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<FlexBoxSpec>>? $trigger;
  final Prop<StyleSpec<IconSpec>>? $icon;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<StyleSpec<IconSpec>>? $indicator;
  final Prop<StyleSpec<FlexBoxSpec>>? $rail;

  const AgentStepsStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<FlexBoxSpec>>? trigger,
    Prop<StyleSpec<IconSpec>>? icon,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? indicator,
    Prop<StyleSpec<FlexBoxSpec>>? rail,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $trigger = trigger,
       $icon = icon,
       $label = label,
       $indicator = indicator,
       $rail = rail;

  AgentStepsStyler({
    BoxStyler? container,
    FlexBoxStyler? trigger,
    IconStyler? icon,
    TextStyler? label,
    IconStyler? indicator,
    FlexBoxStyler? rail,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<AgentStepsSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         trigger: Prop.maybeMix(trigger),
         icon: Prop.maybeMix(icon),
         label: Prop.maybeMix(label),
         indicator: Prop.maybeMix(indicator),
         rail: Prop.maybeMix(rail),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory AgentStepsStyler.container(BoxStyler value) =>
      AgentStepsStyler().container(value);
  factory AgentStepsStyler.trigger(FlexBoxStyler value) =>
      AgentStepsStyler().trigger(value);
  factory AgentStepsStyler.icon(IconStyler value) =>
      AgentStepsStyler().icon(value);
  factory AgentStepsStyler.label(TextStyler value) =>
      AgentStepsStyler().label(value);
  factory AgentStepsStyler.indicator(IconStyler value) =>
      AgentStepsStyler().indicator(value);
  factory AgentStepsStyler.rail(FlexBoxStyler value) =>
      AgentStepsStyler().rail(value);

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'trigger',
    'icon',
    'label',
    'indicator',
    'rail',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  AgentStepsStyler container(BoxStyler value) {
    return merge(AgentStepsStyler(container: value));
  }

  /// Sets the trigger.
  AgentStepsStyler trigger(FlexBoxStyler value) {
    return merge(AgentStepsStyler(trigger: value));
  }

  /// Sets the icon.
  AgentStepsStyler icon(IconStyler value) {
    return merge(AgentStepsStyler(icon: value));
  }

  /// Sets the label.
  AgentStepsStyler label(TextStyler value) {
    return merge(AgentStepsStyler(label: value));
  }

  /// Sets the indicator.
  AgentStepsStyler indicator(IconStyler value) {
    return merge(AgentStepsStyler(indicator: value));
  }

  /// Sets the rail.
  AgentStepsStyler rail(FlexBoxStyler value) {
    return merge(AgentStepsStyler(rail: value));
  }

  /// Sets the animation configuration.
  @override
  AgentStepsStyler animate(AnimationConfig value) {
    return merge(AgentStepsStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  AgentStepsStyler variants(List<VariantStyle<AgentStepsSpec>> value) {
    return merge(AgentStepsStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  AgentStepsStyler wrap(WidgetModifierConfig value) {
    return merge(AgentStepsStyler(modifier: value));
  }

  /// Sets the widget modifier.
  AgentStepsStyler modifier(WidgetModifierConfig value) {
    return merge(AgentStepsStyler(modifier: value));
  }

  /// Merges with another [AgentStepsStyler].
  @override
  AgentStepsStyler merge(AgentStepsStyler? other) {
    return AgentStepsStyler.create(
      container: MixOps.merge($container, other?.$container),
      trigger: MixOps.merge($trigger, other?.$trigger),
      icon: MixOps.merge($icon, other?.$icon),
      label: MixOps.merge($label, other?.$label),
      indicator: MixOps.merge($indicator, other?.$indicator),
      rail: MixOps.merge($rail, other?.$rail),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<AgentStepsSpec>] using [context].
  @override
  StyleSpec<AgentStepsSpec> resolve(BuildContext context) {
    final spec = AgentStepsSpec(
      container: MixOps.resolve(context, $container),
      trigger: MixOps.resolve(context, $trigger),
      icon: MixOps.resolve(context, $icon),
      label: MixOps.resolve(context, $label),
      indicator: MixOps.resolve(context, $indicator),
      rail: MixOps.resolve(context, $rail),
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
      ..add(DiagnosticsProperty('trigger', $trigger))
      ..add(DiagnosticsProperty('icon', $icon))
      ..add(DiagnosticsProperty('label', $label))
      ..add(DiagnosticsProperty('indicator', $indicator))
      ..add(DiagnosticsProperty('rail', $rail));
  }

  @override
  List<Object?> get props => [
    $container,
    $trigger,
    $icon,
    $label,
    $indicator,
    $rail,
    $animation,
    $modifier,
    $variants,
  ];
}

class AgentStepStyler extends MixStyler<AgentStepStyler, AgentStepSpec>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<IconSpec>>? $icon;
  final Prop<StyleSpec<TextSpec>>? $title;
  final Prop<StyleSpec<TextSpec>>? $detail;

  const AgentStepStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<IconSpec>>? icon,
    Prop<StyleSpec<TextSpec>>? title,
    Prop<StyleSpec<TextSpec>>? detail,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $icon = icon,
       $title = title,
       $detail = detail;

  AgentStepStyler({
    FlexBoxStyler? container,
    IconStyler? icon,
    TextStyler? title,
    TextStyler? detail,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<AgentStepSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         icon: Prop.maybeMix(icon),
         title: Prop.maybeMix(title),
         detail: Prop.maybeMix(detail),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory AgentStepStyler.container(FlexBoxStyler value) =>
      AgentStepStyler().container(value);
  factory AgentStepStyler.icon(IconStyler value) =>
      AgentStepStyler().icon(value);
  factory AgentStepStyler.title(TextStyler value) =>
      AgentStepStyler().title(value);
  factory AgentStepStyler.detail(TextStyler value) =>
      AgentStepStyler().detail(value);

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'icon',
    'title',
    'detail',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  AgentStepStyler container(FlexBoxStyler value) {
    return merge(AgentStepStyler(container: value));
  }

  /// Sets the icon.
  AgentStepStyler icon(IconStyler value) {
    return merge(AgentStepStyler(icon: value));
  }

  /// Sets the title.
  AgentStepStyler title(TextStyler value) {
    return merge(AgentStepStyler(title: value));
  }

  /// Sets the detail.
  AgentStepStyler detail(TextStyler value) {
    return merge(AgentStepStyler(detail: value));
  }

  /// Sets the animation configuration.
  @override
  AgentStepStyler animate(AnimationConfig value) {
    return merge(AgentStepStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  AgentStepStyler variants(List<VariantStyle<AgentStepSpec>> value) {
    return merge(AgentStepStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  AgentStepStyler wrap(WidgetModifierConfig value) {
    return merge(AgentStepStyler(modifier: value));
  }

  /// Sets the widget modifier.
  AgentStepStyler modifier(WidgetModifierConfig value) {
    return merge(AgentStepStyler(modifier: value));
  }

  /// Merges with another [AgentStepStyler].
  @override
  AgentStepStyler merge(AgentStepStyler? other) {
    return AgentStepStyler.create(
      container: MixOps.merge($container, other?.$container),
      icon: MixOps.merge($icon, other?.$icon),
      title: MixOps.merge($title, other?.$title),
      detail: MixOps.merge($detail, other?.$detail),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<AgentStepSpec>] using [context].
  @override
  StyleSpec<AgentStepSpec> resolve(BuildContext context) {
    final spec = AgentStepSpec(
      container: MixOps.resolve(context, $container),
      icon: MixOps.resolve(context, $icon),
      title: MixOps.resolve(context, $title),
      detail: MixOps.resolve(context, $detail),
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
      ..add(DiagnosticsProperty('title', $title))
      ..add(DiagnosticsProperty('detail', $detail));
  }

  @override
  List<Object?> get props => [
    $container,
    $icon,
    $title,
    $detail,
    $animation,
    $modifier,
    $variants,
  ];
}
