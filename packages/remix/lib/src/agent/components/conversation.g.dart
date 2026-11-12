// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$AgentConversationSpec
    implements Spec<AgentConversationSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<BoxSpec> get turn;
  double? get maxWidth;
  EdgeInsetsGeometry? get padding;
  double? get turnSpacing;
  double? get blockSpacing;
  StyleSpec<BoxSpec> get latest;
  StyleSpec<BoxSpec> get empty;

  @override
  Type get type => AgentConversationSpec;

  @override
  AgentConversationSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? turn,
    double? maxWidth,
    EdgeInsetsGeometry? padding,
    double? turnSpacing,
    double? blockSpacing,
    StyleSpec<BoxSpec>? latest,
    StyleSpec<BoxSpec>? empty,
  }) {
    return AgentConversationSpec(
      container: container ?? this.container,
      turn: turn ?? this.turn,
      maxWidth: maxWidth ?? this.maxWidth,
      padding: padding ?? this.padding,
      turnSpacing: turnSpacing ?? this.turnSpacing,
      blockSpacing: blockSpacing ?? this.blockSpacing,
      latest: latest ?? this.latest,
      empty: empty ?? this.empty,
    );
  }

  @override
  AgentConversationSpec lerp(AgentConversationSpec? other, double t) {
    return AgentConversationSpec(
      container: container.lerp(other?.container, t),
      turn: turn.lerp(other?.turn, t),
      maxWidth: MixOps.lerp(maxWidth, other?.maxWidth, t),
      padding: MixOps.lerp(padding, other?.padding, t),
      turnSpacing: MixOps.lerp(turnSpacing, other?.turnSpacing, t),
      blockSpacing: MixOps.lerp(blockSpacing, other?.blockSpacing, t),
      latest: latest.lerp(other?.latest, t),
      empty: empty.lerp(other?.empty, t),
    );
  }

  @override
  List<Object?> get props => [
    container,
    turn,
    maxWidth,
    padding,
    turnSpacing,
    blockSpacing,
    latest,
    empty,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AgentConversationSpec &&
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
      ..add(DiagnosticsProperty('turn', turn))
      ..add(DoubleProperty('maxWidth', maxWidth))
      ..add(DiagnosticsProperty('padding', padding))
      ..add(DoubleProperty('turnSpacing', turnSpacing))
      ..add(DoubleProperty('blockSpacing', blockSpacing))
      ..add(DiagnosticsProperty('latest', latest))
      ..add(DiagnosticsProperty('empty', empty));
  }
}

@Deprecated(
  'Rename to `_\$AgentConversationSpec` and migrate the class declaration to `class AgentConversationSpec with _\$AgentConversationSpec`. The `_\$AgentConversationSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$AgentConversationSpecMethods = _$AgentConversationSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class AgentConversationStyler
    extends MixStyler<AgentConversationStyler, AgentConversationSpec>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<BoxSpec>>? $turn;
  final Prop<double>? $maxWidth;
  final Prop<EdgeInsetsGeometry>? $padding;
  final Prop<double>? $turnSpacing;
  final Prop<double>? $blockSpacing;
  final Prop<StyleSpec<BoxSpec>>? $latest;
  final Prop<StyleSpec<BoxSpec>>? $empty;

  const AgentConversationStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<BoxSpec>>? turn,
    Prop<double>? maxWidth,
    Prop<EdgeInsetsGeometry>? padding,
    Prop<double>? turnSpacing,
    Prop<double>? blockSpacing,
    Prop<StyleSpec<BoxSpec>>? latest,
    Prop<StyleSpec<BoxSpec>>? empty,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $turn = turn,
       $maxWidth = maxWidth,
       $padding = padding,
       $turnSpacing = turnSpacing,
       $blockSpacing = blockSpacing,
       $latest = latest,
       $empty = empty;

  AgentConversationStyler({
    BoxStyler? container,
    BoxStyler? turn,
    double? maxWidth,
    EdgeInsetsGeometryMix? padding,
    double? turnSpacing,
    double? blockSpacing,
    BoxStyler? latest,
    BoxStyler? empty,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<AgentConversationSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         turn: Prop.maybeMix(turn),
         maxWidth: Prop.maybe(maxWidth),
         padding: Prop.maybeMix(padding),
         turnSpacing: Prop.maybe(turnSpacing),
         blockSpacing: Prop.maybe(blockSpacing),
         latest: Prop.maybeMix(latest),
         empty: Prop.maybeMix(empty),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory AgentConversationStyler.container(BoxStyler value) =>
      AgentConversationStyler().container(value);
  factory AgentConversationStyler.turn(BoxStyler value) =>
      AgentConversationStyler().turn(value);
  factory AgentConversationStyler.maxWidth(double value) =>
      AgentConversationStyler().maxWidth(value);
  factory AgentConversationStyler.padding(EdgeInsetsGeometryMix value) =>
      AgentConversationStyler().padding(value);
  factory AgentConversationStyler.turnSpacing(double value) =>
      AgentConversationStyler().turnSpacing(value);
  factory AgentConversationStyler.blockSpacing(double value) =>
      AgentConversationStyler().blockSpacing(value);
  factory AgentConversationStyler.latest(BoxStyler value) =>
      AgentConversationStyler().latest(value);
  factory AgentConversationStyler.empty(BoxStyler value) =>
      AgentConversationStyler().empty(value);

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'turn',
    'maxWidth',
    'padding',
    'turnSpacing',
    'blockSpacing',
    'latest',
    'empty',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  AgentConversationStyler container(BoxStyler value) {
    return merge(AgentConversationStyler(container: value));
  }

  /// Sets the turn.
  AgentConversationStyler turn(BoxStyler value) {
    return merge(AgentConversationStyler(turn: value));
  }

  /// Sets the maxWidth.
  AgentConversationStyler maxWidth(double value) {
    return merge(AgentConversationStyler(maxWidth: value));
  }

  /// Sets the padding.
  AgentConversationStyler padding(EdgeInsetsGeometryMix value) {
    return merge(AgentConversationStyler(padding: value));
  }

  /// Sets the turnSpacing.
  AgentConversationStyler turnSpacing(double value) {
    return merge(AgentConversationStyler(turnSpacing: value));
  }

  /// Sets the blockSpacing.
  AgentConversationStyler blockSpacing(double value) {
    return merge(AgentConversationStyler(blockSpacing: value));
  }

  /// Sets the latest.
  AgentConversationStyler latest(BoxStyler value) {
    return merge(AgentConversationStyler(latest: value));
  }

  /// Sets the empty.
  AgentConversationStyler empty(BoxStyler value) {
    return merge(AgentConversationStyler(empty: value));
  }

  /// Sets the animation configuration.
  @override
  AgentConversationStyler animate(AnimationConfig value) {
    return merge(AgentConversationStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  AgentConversationStyler variants(
    List<VariantStyle<AgentConversationSpec>> value,
  ) {
    return merge(AgentConversationStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  AgentConversationStyler wrap(WidgetModifierConfig value) {
    return merge(AgentConversationStyler(modifier: value));
  }

  /// Sets the widget modifier.
  AgentConversationStyler modifier(WidgetModifierConfig value) {
    return merge(AgentConversationStyler(modifier: value));
  }

  /// Merges with another [AgentConversationStyler].
  @override
  AgentConversationStyler merge(AgentConversationStyler? other) {
    return AgentConversationStyler.create(
      container: MixOps.merge($container, other?.$container),
      turn: MixOps.merge($turn, other?.$turn),
      maxWidth: MixOps.merge($maxWidth, other?.$maxWidth),
      padding: MixOps.merge($padding, other?.$padding),
      turnSpacing: MixOps.merge($turnSpacing, other?.$turnSpacing),
      blockSpacing: MixOps.merge($blockSpacing, other?.$blockSpacing),
      latest: MixOps.merge($latest, other?.$latest),
      empty: MixOps.merge($empty, other?.$empty),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<AgentConversationSpec>] using [context].
  @override
  StyleSpec<AgentConversationSpec> resolve(BuildContext context) {
    final spec = AgentConversationSpec(
      container: MixOps.resolve(context, $container),
      turn: MixOps.resolve(context, $turn),
      maxWidth: MixOps.resolve(context, $maxWidth),
      padding: MixOps.resolve(context, $padding),
      turnSpacing: MixOps.resolve(context, $turnSpacing),
      blockSpacing: MixOps.resolve(context, $blockSpacing),
      latest: MixOps.resolve(context, $latest),
      empty: MixOps.resolve(context, $empty),
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
      ..add(DiagnosticsProperty('turn', $turn))
      ..add(DiagnosticsProperty('maxWidth', $maxWidth))
      ..add(DiagnosticsProperty('padding', $padding))
      ..add(DiagnosticsProperty('turnSpacing', $turnSpacing))
      ..add(DiagnosticsProperty('blockSpacing', $blockSpacing))
      ..add(DiagnosticsProperty('latest', $latest))
      ..add(DiagnosticsProperty('empty', $empty));
  }

  @override
  List<Object?> get props => [
    $container,
    $turn,
    $maxWidth,
    $padding,
    $turnSpacing,
    $blockSpacing,
    $latest,
    $empty,
    $animation,
    $modifier,
    $variants,
  ];
}
