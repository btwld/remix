// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$AgentMessageSpec implements Spec<AgentMessageSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<BoxSpec> get surface;
  StyleSpec<TextSpec> get text;
  StyleSpec<BoxSpec> get header;
  StyleSpec<BoxSpec> get footer;
  double? get maxWidthFactor;
  double? get collapsedHeight;

  @override
  Type get type => AgentMessageSpec;

  @override
  AgentMessageSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? surface,
    StyleSpec<TextSpec>? text,
    StyleSpec<BoxSpec>? header,
    StyleSpec<BoxSpec>? footer,
    double? maxWidthFactor,
    double? collapsedHeight,
  }) {
    return AgentMessageSpec(
      container: container ?? this.container,
      surface: surface ?? this.surface,
      text: text ?? this.text,
      header: header ?? this.header,
      footer: footer ?? this.footer,
      maxWidthFactor: maxWidthFactor ?? this.maxWidthFactor,
      collapsedHeight: collapsedHeight ?? this.collapsedHeight,
    );
  }

  @override
  AgentMessageSpec lerp(AgentMessageSpec? other, double t) {
    return AgentMessageSpec(
      container: container.lerp(other?.container, t),
      surface: surface.lerp(other?.surface, t),
      text: text.lerp(other?.text, t),
      header: header.lerp(other?.header, t),
      footer: footer.lerp(other?.footer, t),
      maxWidthFactor: MixOps.lerp(maxWidthFactor, other?.maxWidthFactor, t),
      collapsedHeight: MixOps.lerp(collapsedHeight, other?.collapsedHeight, t),
    );
  }

  @override
  List<Object?> get props => [
    container,
    surface,
    text,
    header,
    footer,
    maxWidthFactor,
    collapsedHeight,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AgentMessageSpec &&
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
      ..add(DiagnosticsProperty('surface', surface))
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('header', header))
      ..add(DiagnosticsProperty('footer', footer))
      ..add(DoubleProperty('maxWidthFactor', maxWidthFactor))
      ..add(DoubleProperty('collapsedHeight', collapsedHeight));
  }
}

@Deprecated(
  'Rename to `_\$AgentMessageSpec` and migrate the class declaration to `class AgentMessageSpec with _\$AgentMessageSpec`. The `_\$AgentMessageSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$AgentMessageSpecMethods = _$AgentMessageSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class AgentMessageStyler extends MixStyler<AgentMessageStyler, AgentMessageSpec>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<BoxSpec>>? $surface;
  final Prop<StyleSpec<TextSpec>>? $text;
  final Prop<StyleSpec<BoxSpec>>? $header;
  final Prop<StyleSpec<BoxSpec>>? $footer;
  final Prop<double>? $maxWidthFactor;
  final Prop<double>? $collapsedHeight;

  const AgentMessageStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<BoxSpec>>? surface,
    Prop<StyleSpec<TextSpec>>? text,
    Prop<StyleSpec<BoxSpec>>? header,
    Prop<StyleSpec<BoxSpec>>? footer,
    Prop<double>? maxWidthFactor,
    Prop<double>? collapsedHeight,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $surface = surface,
       $text = text,
       $header = header,
       $footer = footer,
       $maxWidthFactor = maxWidthFactor,
       $collapsedHeight = collapsedHeight;

  AgentMessageStyler({
    BoxStyler? container,
    BoxStyler? surface,
    TextStyler? text,
    BoxStyler? header,
    BoxStyler? footer,
    double? maxWidthFactor,
    double? collapsedHeight,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<AgentMessageSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         surface: Prop.maybeMix(surface),
         text: Prop.maybeMix(text),
         header: Prop.maybeMix(header),
         footer: Prop.maybeMix(footer),
         maxWidthFactor: Prop.maybe(maxWidthFactor),
         collapsedHeight: Prop.maybe(collapsedHeight),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory AgentMessageStyler.container(BoxStyler value) =>
      AgentMessageStyler().container(value);
  factory AgentMessageStyler.surface(BoxStyler value) =>
      AgentMessageStyler().surface(value);
  factory AgentMessageStyler.text(TextStyler value) =>
      AgentMessageStyler().text(value);
  factory AgentMessageStyler.header(BoxStyler value) =>
      AgentMessageStyler().header(value);
  factory AgentMessageStyler.footer(BoxStyler value) =>
      AgentMessageStyler().footer(value);
  factory AgentMessageStyler.maxWidthFactor(double value) =>
      AgentMessageStyler().maxWidthFactor(value);
  factory AgentMessageStyler.collapsedHeight(double value) =>
      AgentMessageStyler().collapsedHeight(value);

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'surface',
    'text',
    'header',
    'footer',
    'maxWidthFactor',
    'collapsedHeight',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  AgentMessageStyler container(BoxStyler value) {
    return merge(AgentMessageStyler(container: value));
  }

  /// Sets the surface.
  AgentMessageStyler surface(BoxStyler value) {
    return merge(AgentMessageStyler(surface: value));
  }

  /// Sets the text.
  AgentMessageStyler text(TextStyler value) {
    return merge(AgentMessageStyler(text: value));
  }

  /// Sets the header.
  AgentMessageStyler header(BoxStyler value) {
    return merge(AgentMessageStyler(header: value));
  }

  /// Sets the footer.
  AgentMessageStyler footer(BoxStyler value) {
    return merge(AgentMessageStyler(footer: value));
  }

  /// Sets the maxWidthFactor.
  AgentMessageStyler maxWidthFactor(double value) {
    return merge(AgentMessageStyler(maxWidthFactor: value));
  }

  /// Sets the collapsedHeight.
  AgentMessageStyler collapsedHeight(double value) {
    return merge(AgentMessageStyler(collapsedHeight: value));
  }

  /// Sets the animation configuration.
  @override
  AgentMessageStyler animate(AnimationConfig value) {
    return merge(AgentMessageStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  AgentMessageStyler variants(List<VariantStyle<AgentMessageSpec>> value) {
    return merge(AgentMessageStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  AgentMessageStyler wrap(WidgetModifierConfig value) {
    return merge(AgentMessageStyler(modifier: value));
  }

  /// Sets the widget modifier.
  AgentMessageStyler modifier(WidgetModifierConfig value) {
    return merge(AgentMessageStyler(modifier: value));
  }

  /// Merges with another [AgentMessageStyler].
  @override
  AgentMessageStyler merge(AgentMessageStyler? other) {
    return AgentMessageStyler.create(
      container: MixOps.merge($container, other?.$container),
      surface: MixOps.merge($surface, other?.$surface),
      text: MixOps.merge($text, other?.$text),
      header: MixOps.merge($header, other?.$header),
      footer: MixOps.merge($footer, other?.$footer),
      maxWidthFactor: MixOps.merge($maxWidthFactor, other?.$maxWidthFactor),
      collapsedHeight: MixOps.merge($collapsedHeight, other?.$collapsedHeight),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<AgentMessageSpec>] using [context].
  @override
  StyleSpec<AgentMessageSpec> resolve(BuildContext context) {
    final spec = AgentMessageSpec(
      container: MixOps.resolve(context, $container),
      surface: MixOps.resolve(context, $surface),
      text: MixOps.resolve(context, $text),
      header: MixOps.resolve(context, $header),
      footer: MixOps.resolve(context, $footer),
      maxWidthFactor: MixOps.resolve(context, $maxWidthFactor),
      collapsedHeight: MixOps.resolve(context, $collapsedHeight),
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
      ..add(DiagnosticsProperty('surface', $surface))
      ..add(DiagnosticsProperty('text', $text))
      ..add(DiagnosticsProperty('header', $header))
      ..add(DiagnosticsProperty('footer', $footer))
      ..add(DiagnosticsProperty('maxWidthFactor', $maxWidthFactor))
      ..add(DiagnosticsProperty('collapsedHeight', $collapsedHeight));
  }

  @override
  List<Object?> get props => [
    $container,
    $surface,
    $text,
    $header,
    $footer,
    $maxWidthFactor,
    $collapsedHeight,
    $animation,
    $modifier,
    $variants,
  ];
}
