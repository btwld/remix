// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcript.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$AgentTranscriptSpec
    implements Spec<AgentTranscriptSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get viewport;
  StyleSpec<BoxSpec> get item;
  double? get spacing;
  StyleSpec<BoxSpec> get latest;

  @override
  Type get type => AgentTranscriptSpec;

  @override
  AgentTranscriptSpec copyWith({
    StyleSpec<BoxSpec>? viewport,
    StyleSpec<BoxSpec>? item,
    double? spacing,
    StyleSpec<BoxSpec>? latest,
  }) {
    return AgentTranscriptSpec(
      viewport: viewport ?? this.viewport,
      item: item ?? this.item,
      spacing: spacing ?? this.spacing,
      latest: latest ?? this.latest,
    );
  }

  @override
  AgentTranscriptSpec lerp(AgentTranscriptSpec? other, double t) {
    return AgentTranscriptSpec(
      viewport: viewport.lerp(other?.viewport, t),
      item: item.lerp(other?.item, t),
      spacing: MixOps.lerp(spacing, other?.spacing, t),
      latest: latest.lerp(other?.latest, t),
    );
  }

  @override
  List<Object?> get props => [viewport, item, spacing, latest];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AgentTranscriptSpec &&
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
      ..add(DiagnosticsProperty('viewport', viewport))
      ..add(DiagnosticsProperty('item', item))
      ..add(DoubleProperty('spacing', spacing))
      ..add(DiagnosticsProperty('latest', latest));
  }
}

@Deprecated(
  'Rename to `_\$AgentTranscriptSpec` and migrate the class declaration to `class AgentTranscriptSpec with _\$AgentTranscriptSpec`. The `_\$AgentTranscriptSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$AgentTranscriptSpecMethods = _$AgentTranscriptSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class AgentTranscriptStyler
    extends MixStyler<AgentTranscriptStyler, AgentTranscriptSpec>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<BoxSpec>>? $viewport;
  final Prop<StyleSpec<BoxSpec>>? $item;
  final Prop<double>? $spacing;
  final Prop<StyleSpec<BoxSpec>>? $latest;

  const AgentTranscriptStyler.create({
    Prop<StyleSpec<BoxSpec>>? viewport,
    Prop<StyleSpec<BoxSpec>>? item,
    Prop<double>? spacing,
    Prop<StyleSpec<BoxSpec>>? latest,
    super.variants,
    super.modifier,
    super.animation,
  }) : $viewport = viewport,
       $item = item,
       $spacing = spacing,
       $latest = latest;

  AgentTranscriptStyler({
    BoxStyler? viewport,
    BoxStyler? item,
    double? spacing,
    BoxStyler? latest,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<AgentTranscriptSpec>>? variants,
  }) : this.create(
         viewport: Prop.maybeMix(viewport),
         item: Prop.maybeMix(item),
         spacing: Prop.maybe(spacing),
         latest: Prop.maybeMix(latest),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory AgentTranscriptStyler.viewport(BoxStyler value) =>
      AgentTranscriptStyler().viewport(value);
  factory AgentTranscriptStyler.item(BoxStyler value) =>
      AgentTranscriptStyler().item(value);
  factory AgentTranscriptStyler.spacing(double value) =>
      AgentTranscriptStyler().spacing(value);
  factory AgentTranscriptStyler.latest(BoxStyler value) =>
      AgentTranscriptStyler().latest(value);

  @override
  Set<String> get $stylerFieldNames => const {
    'viewport',
    'item',
    'spacing',
    'latest',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the viewport.
  AgentTranscriptStyler viewport(BoxStyler value) {
    return merge(AgentTranscriptStyler(viewport: value));
  }

  /// Sets the item.
  AgentTranscriptStyler item(BoxStyler value) {
    return merge(AgentTranscriptStyler(item: value));
  }

  /// Sets the spacing.
  AgentTranscriptStyler spacing(double value) {
    return merge(AgentTranscriptStyler(spacing: value));
  }

  /// Sets the latest.
  AgentTranscriptStyler latest(BoxStyler value) {
    return merge(AgentTranscriptStyler(latest: value));
  }

  /// Sets the animation configuration.
  @override
  AgentTranscriptStyler animate(AnimationConfig value) {
    return merge(AgentTranscriptStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  AgentTranscriptStyler variants(
    List<VariantStyle<AgentTranscriptSpec>> value,
  ) {
    return merge(AgentTranscriptStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  AgentTranscriptStyler wrap(WidgetModifierConfig value) {
    return merge(AgentTranscriptStyler(modifier: value));
  }

  /// Sets the widget modifier.
  AgentTranscriptStyler modifier(WidgetModifierConfig value) {
    return merge(AgentTranscriptStyler(modifier: value));
  }

  AgentTranscript call({
    Key? key,
    required List<Widget> children,
    bool followOutput = true,
    double followThreshold = 48.0,
    bool busy = false,
    String busyLabel = 'Busy',
    String label = 'Conversation',
    ValueChanged<bool>? onFollowChanged,
    ScrollController? controller,
    Clip clipBehavior = Clip.hardEdge,
    bool showLatestButton = true,
    String latestLabel = 'Scroll to latest',
    RemixIconButtonIconBuilder? latestIconBuilder,
    IconButtonStyler latestStyle = const IconButtonStyler.create(),
  }) {
    return AgentTranscript(
      key: key,
      style: this,
      children: children,
      followOutput: followOutput,
      followThreshold: followThreshold,
      busy: busy,
      busyLabel: busyLabel,
      label: label,
      onFollowChanged: onFollowChanged,
      controller: controller,
      clipBehavior: clipBehavior,
      showLatestButton: showLatestButton,
      latestLabel: latestLabel,
      latestIconBuilder: latestIconBuilder,
      latestStyle: latestStyle,
    );
  }

  /// Merges with another [AgentTranscriptStyler].
  @override
  AgentTranscriptStyler merge(AgentTranscriptStyler? other) {
    return AgentTranscriptStyler.create(
      viewport: MixOps.merge($viewport, other?.$viewport),
      item: MixOps.merge($item, other?.$item),
      spacing: MixOps.merge($spacing, other?.$spacing),
      latest: MixOps.merge($latest, other?.$latest),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<AgentTranscriptSpec>] using [context].
  @override
  StyleSpec<AgentTranscriptSpec> resolve(BuildContext context) {
    final spec = AgentTranscriptSpec(
      viewport: MixOps.resolve(context, $viewport),
      item: MixOps.resolve(context, $item),
      spacing: MixOps.resolve(context, $spacing),
      latest: MixOps.resolve(context, $latest),
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
      ..add(DiagnosticsProperty('viewport', $viewport))
      ..add(DiagnosticsProperty('item', $item))
      ..add(DiagnosticsProperty('spacing', $spacing))
      ..add(DiagnosticsProperty('latest', $latest));
  }

  @override
  List<Object?> get props => [
    $viewport,
    $item,
    $spacing,
    $latest,
    $animation,
    $modifier,
    $variants,
  ];
}
