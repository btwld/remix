// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$AgentAnswerSpec implements Spec<AgentAnswerSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<BoxSpec> get body;
  StyleSpec<TextSpec> get text;
  StyleSpec<BoxSpec> get sources;
  StyleSpec<FlexBoxSpec> get actions;
  StyleSpec<TextSpec> get feedback;

  @override
  Type get type => AgentAnswerSpec;

  @override
  AgentAnswerSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<BoxSpec>? body,
    StyleSpec<TextSpec>? text,
    StyleSpec<BoxSpec>? sources,
    StyleSpec<FlexBoxSpec>? actions,
    StyleSpec<TextSpec>? feedback,
  }) {
    return AgentAnswerSpec(
      container: container ?? this.container,
      body: body ?? this.body,
      text: text ?? this.text,
      sources: sources ?? this.sources,
      actions: actions ?? this.actions,
      feedback: feedback ?? this.feedback,
    );
  }

  @override
  AgentAnswerSpec lerp(AgentAnswerSpec? other, double t) {
    return AgentAnswerSpec(
      container: container.lerp(other?.container, t),
      body: body.lerp(other?.body, t),
      text: text.lerp(other?.text, t),
      sources: sources.lerp(other?.sources, t),
      actions: actions.lerp(other?.actions, t),
      feedback: feedback.lerp(other?.feedback, t),
    );
  }

  @override
  List<Object?> get props => [
    container,
    body,
    text,
    sources,
    actions,
    feedback,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AgentAnswerSpec &&
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
      ..add(DiagnosticsProperty('body', body))
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('sources', sources))
      ..add(DiagnosticsProperty('actions', actions))
      ..add(DiagnosticsProperty('feedback', feedback));
  }
}

@Deprecated(
  'Rename to `_\$AgentAnswerSpec` and migrate the class declaration to `class AgentAnswerSpec with _\$AgentAnswerSpec`. The `_\$AgentAnswerSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$AgentAnswerSpecMethods = _$AgentAnswerSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class AgentAnswerStyler extends MixStyler<AgentAnswerStyler, AgentAnswerSpec>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<BoxSpec>>? $body;
  final Prop<StyleSpec<TextSpec>>? $text;
  final Prop<StyleSpec<BoxSpec>>? $sources;
  final Prop<StyleSpec<FlexBoxSpec>>? $actions;
  final Prop<StyleSpec<TextSpec>>? $feedback;

  const AgentAnswerStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<BoxSpec>>? body,
    Prop<StyleSpec<TextSpec>>? text,
    Prop<StyleSpec<BoxSpec>>? sources,
    Prop<StyleSpec<FlexBoxSpec>>? actions,
    Prop<StyleSpec<TextSpec>>? feedback,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $body = body,
       $text = text,
       $sources = sources,
       $actions = actions,
       $feedback = feedback;

  AgentAnswerStyler({
    FlexBoxStyler? container,
    BoxStyler? body,
    TextStyler? text,
    BoxStyler? sources,
    FlexBoxStyler? actions,
    TextStyler? feedback,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<AgentAnswerSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         body: Prop.maybeMix(body),
         text: Prop.maybeMix(text),
         sources: Prop.maybeMix(sources),
         actions: Prop.maybeMix(actions),
         feedback: Prop.maybeMix(feedback),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory AgentAnswerStyler.container(FlexBoxStyler value) =>
      AgentAnswerStyler().container(value);
  factory AgentAnswerStyler.body(BoxStyler value) =>
      AgentAnswerStyler().body(value);
  factory AgentAnswerStyler.text(TextStyler value) =>
      AgentAnswerStyler().text(value);
  factory AgentAnswerStyler.sources(BoxStyler value) =>
      AgentAnswerStyler().sources(value);
  factory AgentAnswerStyler.actions(FlexBoxStyler value) =>
      AgentAnswerStyler().actions(value);
  factory AgentAnswerStyler.feedback(TextStyler value) =>
      AgentAnswerStyler().feedback(value);

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'body',
    'text',
    'sources',
    'actions',
    'feedback',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  AgentAnswerStyler container(FlexBoxStyler value) {
    return merge(AgentAnswerStyler(container: value));
  }

  /// Sets the body.
  AgentAnswerStyler body(BoxStyler value) {
    return merge(AgentAnswerStyler(body: value));
  }

  /// Sets the text.
  AgentAnswerStyler text(TextStyler value) {
    return merge(AgentAnswerStyler(text: value));
  }

  /// Sets the sources.
  AgentAnswerStyler sources(BoxStyler value) {
    return merge(AgentAnswerStyler(sources: value));
  }

  /// Sets the actions.
  AgentAnswerStyler actions(FlexBoxStyler value) {
    return merge(AgentAnswerStyler(actions: value));
  }

  /// Sets the feedback.
  AgentAnswerStyler feedback(TextStyler value) {
    return merge(AgentAnswerStyler(feedback: value));
  }

  /// Sets the animation configuration.
  @override
  AgentAnswerStyler animate(AnimationConfig value) {
    return merge(AgentAnswerStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  AgentAnswerStyler variants(List<VariantStyle<AgentAnswerSpec>> value) {
    return merge(AgentAnswerStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  AgentAnswerStyler wrap(WidgetModifierConfig value) {
    return merge(AgentAnswerStyler(modifier: value));
  }

  /// Sets the widget modifier.
  AgentAnswerStyler modifier(WidgetModifierConfig value) {
    return merge(AgentAnswerStyler(modifier: value));
  }

  /// Merges with another [AgentAnswerStyler].
  @override
  AgentAnswerStyler merge(AgentAnswerStyler? other) {
    return AgentAnswerStyler.create(
      container: MixOps.merge($container, other?.$container),
      body: MixOps.merge($body, other?.$body),
      text: MixOps.merge($text, other?.$text),
      sources: MixOps.merge($sources, other?.$sources),
      actions: MixOps.merge($actions, other?.$actions),
      feedback: MixOps.merge($feedback, other?.$feedback),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<AgentAnswerSpec>] using [context].
  @override
  StyleSpec<AgentAnswerSpec> resolve(BuildContext context) {
    final spec = AgentAnswerSpec(
      container: MixOps.resolve(context, $container),
      body: MixOps.resolve(context, $body),
      text: MixOps.resolve(context, $text),
      sources: MixOps.resolve(context, $sources),
      actions: MixOps.resolve(context, $actions),
      feedback: MixOps.resolve(context, $feedback),
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
      ..add(DiagnosticsProperty('body', $body))
      ..add(DiagnosticsProperty('text', $text))
      ..add(DiagnosticsProperty('sources', $sources))
      ..add(DiagnosticsProperty('actions', $actions))
      ..add(DiagnosticsProperty('feedback', $feedback));
  }

  @override
  List<Object?> get props => [
    $container,
    $body,
    $text,
    $sources,
    $actions,
    $feedback,
    $animation,
    $modifier,
    $variants,
  ];
}
