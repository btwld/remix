// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sources.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$AgentSourcesSpec implements Spec<AgentSourcesSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get trigger;
  StyleSpec<IconSpec> get icon;
  StyleSpec<TextSpec> get label;
  StyleSpec<IconSpec> get indicator;
  StyleSpec<WrapBoxSpec> get list;
  StyleSpec<BoxSpec> get source;
  StyleSpec<TextSpec> get sourceLabel;

  @override
  Type get type => AgentSourcesSpec;

  @override
  AgentSourcesSpec copyWith({
    StyleSpec<FlexBoxSpec>? trigger,
    StyleSpec<IconSpec>? icon,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? indicator,
    StyleSpec<WrapBoxSpec>? list,
    StyleSpec<BoxSpec>? source,
    StyleSpec<TextSpec>? sourceLabel,
  }) {
    return AgentSourcesSpec(
      trigger: trigger ?? this.trigger,
      icon: icon ?? this.icon,
      label: label ?? this.label,
      indicator: indicator ?? this.indicator,
      list: list ?? this.list,
      source: source ?? this.source,
      sourceLabel: sourceLabel ?? this.sourceLabel,
    );
  }

  @override
  AgentSourcesSpec lerp(AgentSourcesSpec? other, double t) {
    return AgentSourcesSpec(
      trigger: trigger.lerp(other?.trigger, t),
      icon: icon.lerp(other?.icon, t),
      label: label.lerp(other?.label, t),
      indicator: indicator.lerp(other?.indicator, t),
      list: list.lerp(other?.list, t),
      source: source.lerp(other?.source, t),
      sourceLabel: sourceLabel.lerp(other?.sourceLabel, t),
    );
  }

  @override
  List<Object?> get props => [
    trigger,
    icon,
    label,
    indicator,
    list,
    source,
    sourceLabel,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AgentSourcesSpec &&
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
      ..add(DiagnosticsProperty('icon', icon))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('indicator', indicator))
      ..add(DiagnosticsProperty('list', list))
      ..add(DiagnosticsProperty('source', source))
      ..add(DiagnosticsProperty('sourceLabel', sourceLabel));
  }
}

@Deprecated(
  'Rename to `_\$AgentSourcesSpec` and migrate the class declaration to `class AgentSourcesSpec with _\$AgentSourcesSpec`. The `_\$AgentSourcesSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$AgentSourcesSpecMethods = _$AgentSourcesSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class AgentSourcesStyler extends MixStyler<AgentSourcesStyler, AgentSourcesSpec>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<FlexBoxSpec>>? $trigger;
  final Prop<StyleSpec<IconSpec>>? $icon;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<StyleSpec<IconSpec>>? $indicator;
  final Prop<StyleSpec<WrapBoxSpec>>? $list;
  final Prop<StyleSpec<BoxSpec>>? $source;
  final Prop<StyleSpec<TextSpec>>? $sourceLabel;

  const AgentSourcesStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? trigger,
    Prop<StyleSpec<IconSpec>>? icon,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? indicator,
    Prop<StyleSpec<WrapBoxSpec>>? list,
    Prop<StyleSpec<BoxSpec>>? source,
    Prop<StyleSpec<TextSpec>>? sourceLabel,
    super.variants,
    super.modifier,
    super.animation,
  }) : $trigger = trigger,
       $icon = icon,
       $label = label,
       $indicator = indicator,
       $list = list,
       $source = source,
       $sourceLabel = sourceLabel;

  AgentSourcesStyler({
    FlexBoxStyler? trigger,
    IconStyler? icon,
    TextStyler? label,
    IconStyler? indicator,
    WrapBoxStyler? list,
    BoxStyler? source,
    TextStyler? sourceLabel,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<AgentSourcesSpec>>? variants,
  }) : this.create(
         trigger: Prop.maybeMix(trigger),
         icon: Prop.maybeMix(icon),
         label: Prop.maybeMix(label),
         indicator: Prop.maybeMix(indicator),
         list: Prop.maybeMix(list),
         source: Prop.maybeMix(source),
         sourceLabel: Prop.maybeMix(sourceLabel),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory AgentSourcesStyler.trigger(FlexBoxStyler value) =>
      AgentSourcesStyler().trigger(value);
  factory AgentSourcesStyler.icon(IconStyler value) =>
      AgentSourcesStyler().icon(value);
  factory AgentSourcesStyler.label(TextStyler value) =>
      AgentSourcesStyler().label(value);
  factory AgentSourcesStyler.indicator(IconStyler value) =>
      AgentSourcesStyler().indicator(value);
  factory AgentSourcesStyler.list(WrapBoxStyler value) =>
      AgentSourcesStyler().list(value);
  factory AgentSourcesStyler.source(BoxStyler value) =>
      AgentSourcesStyler().source(value);
  factory AgentSourcesStyler.sourceLabel(TextStyler value) =>
      AgentSourcesStyler().sourceLabel(value);

  @override
  Set<String> get $stylerFieldNames => const {
    'trigger',
    'icon',
    'label',
    'indicator',
    'list',
    'source',
    'sourceLabel',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the trigger.
  AgentSourcesStyler trigger(FlexBoxStyler value) {
    return merge(AgentSourcesStyler(trigger: value));
  }

  /// Sets the icon.
  AgentSourcesStyler icon(IconStyler value) {
    return merge(AgentSourcesStyler(icon: value));
  }

  /// Sets the label.
  AgentSourcesStyler label(TextStyler value) {
    return merge(AgentSourcesStyler(label: value));
  }

  /// Sets the indicator.
  AgentSourcesStyler indicator(IconStyler value) {
    return merge(AgentSourcesStyler(indicator: value));
  }

  /// Sets the list.
  AgentSourcesStyler list(WrapBoxStyler value) {
    return merge(AgentSourcesStyler(list: value));
  }

  /// Sets the source.
  AgentSourcesStyler source(BoxStyler value) {
    return merge(AgentSourcesStyler(source: value));
  }

  /// Sets the sourceLabel.
  AgentSourcesStyler sourceLabel(TextStyler value) {
    return merge(AgentSourcesStyler(sourceLabel: value));
  }

  /// Sets the animation configuration.
  @override
  AgentSourcesStyler animate(AnimationConfig value) {
    return merge(AgentSourcesStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  AgentSourcesStyler variants(List<VariantStyle<AgentSourcesSpec>> value) {
    return merge(AgentSourcesStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  AgentSourcesStyler wrap(WidgetModifierConfig value) {
    return merge(AgentSourcesStyler(modifier: value));
  }

  /// Sets the widget modifier.
  AgentSourcesStyler modifier(WidgetModifierConfig value) {
    return merge(AgentSourcesStyler(modifier: value));
  }

  /// Merges with another [AgentSourcesStyler].
  @override
  AgentSourcesStyler merge(AgentSourcesStyler? other) {
    return AgentSourcesStyler.create(
      trigger: MixOps.merge($trigger, other?.$trigger),
      icon: MixOps.merge($icon, other?.$icon),
      label: MixOps.merge($label, other?.$label),
      indicator: MixOps.merge($indicator, other?.$indicator),
      list: MixOps.merge($list, other?.$list),
      source: MixOps.merge($source, other?.$source),
      sourceLabel: MixOps.merge($sourceLabel, other?.$sourceLabel),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<AgentSourcesSpec>] using [context].
  @override
  StyleSpec<AgentSourcesSpec> resolve(BuildContext context) {
    final spec = AgentSourcesSpec(
      trigger: MixOps.resolve(context, $trigger),
      icon: MixOps.resolve(context, $icon),
      label: MixOps.resolve(context, $label),
      indicator: MixOps.resolve(context, $indicator),
      list: MixOps.resolve(context, $list),
      source: MixOps.resolve(context, $source),
      sourceLabel: MixOps.resolve(context, $sourceLabel),
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
      ..add(DiagnosticsProperty('icon', $icon))
      ..add(DiagnosticsProperty('label', $label))
      ..add(DiagnosticsProperty('indicator', $indicator))
      ..add(DiagnosticsProperty('list', $list))
      ..add(DiagnosticsProperty('source', $source))
      ..add(DiagnosticsProperty('sourceLabel', $sourceLabel));
  }

  @override
  List<Object?> get props => [
    $trigger,
    $icon,
    $label,
    $indicator,
    $list,
    $source,
    $sourceLabel,
    $animation,
    $modifier,
    $variants,
  ];
}
