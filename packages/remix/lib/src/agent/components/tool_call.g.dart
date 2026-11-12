// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tool_call.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$AgentToolCallSpec implements Spec<AgentToolCallSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get row;
  StyleSpec<IconSpec> get icon;
  StyleSpec<TextSpec> get summary;
  StyleSpec<TextSpec> get meta;
  StyleSpec<TextSpec> get toolId;
  StyleSpec<FlexBoxSpec> get status;
  StyleSpec<IconSpec> get statusIcon;
  StyleSpec<TextSpec> get statusLabel;
  StyleSpec<IconSpec> get indicator;
  StyleSpec<BoxSpec> get output;
  double? get outputMaxHeight;
  StyleSpec<BoxSpec> get outputContent;
  StyleSpec<TextSpec> get outputText;
  StyleSpec<BoxSpec> get error;
  StyleSpec<TextSpec> get errorText;
  StyleSpec<BoxSpec> get card;
  StyleSpec<FlexBoxSpec> get cardBody;
  StyleSpec<BoxSpec> get cardIcon;
  StyleSpec<IconSpec> get cardGlyph;
  StyleSpec<FlexBoxSpec> get cardContent;
  StyleSpec<FlexBoxSpec> get cardHeading;
  StyleSpec<FlexBoxSpec> get cardTitleRow;
  StyleSpec<TextSpec> get title;
  StyleSpec<TextSpec> get description;
  StyleSpec<FlexBoxSpec> get footer;

  @override
  Type get type => AgentToolCallSpec;

  @override
  AgentToolCallSpec copyWith({
    StyleSpec<FlexBoxSpec>? row,
    StyleSpec<IconSpec>? icon,
    StyleSpec<TextSpec>? summary,
    StyleSpec<TextSpec>? meta,
    StyleSpec<TextSpec>? toolId,
    StyleSpec<FlexBoxSpec>? status,
    StyleSpec<IconSpec>? statusIcon,
    StyleSpec<TextSpec>? statusLabel,
    StyleSpec<IconSpec>? indicator,
    StyleSpec<BoxSpec>? output,
    double? outputMaxHeight,
    StyleSpec<BoxSpec>? outputContent,
    StyleSpec<TextSpec>? outputText,
    StyleSpec<BoxSpec>? error,
    StyleSpec<TextSpec>? errorText,
    StyleSpec<BoxSpec>? card,
    StyleSpec<FlexBoxSpec>? cardBody,
    StyleSpec<BoxSpec>? cardIcon,
    StyleSpec<IconSpec>? cardGlyph,
    StyleSpec<FlexBoxSpec>? cardContent,
    StyleSpec<FlexBoxSpec>? cardHeading,
    StyleSpec<FlexBoxSpec>? cardTitleRow,
    StyleSpec<TextSpec>? title,
    StyleSpec<TextSpec>? description,
    StyleSpec<FlexBoxSpec>? footer,
  }) {
    return AgentToolCallSpec(
      row: row ?? this.row,
      icon: icon ?? this.icon,
      summary: summary ?? this.summary,
      meta: meta ?? this.meta,
      toolId: toolId ?? this.toolId,
      status: status ?? this.status,
      statusIcon: statusIcon ?? this.statusIcon,
      statusLabel: statusLabel ?? this.statusLabel,
      indicator: indicator ?? this.indicator,
      output: output ?? this.output,
      outputMaxHeight: outputMaxHeight ?? this.outputMaxHeight,
      outputContent: outputContent ?? this.outputContent,
      outputText: outputText ?? this.outputText,
      error: error ?? this.error,
      errorText: errorText ?? this.errorText,
      card: card ?? this.card,
      cardBody: cardBody ?? this.cardBody,
      cardIcon: cardIcon ?? this.cardIcon,
      cardGlyph: cardGlyph ?? this.cardGlyph,
      cardContent: cardContent ?? this.cardContent,
      cardHeading: cardHeading ?? this.cardHeading,
      cardTitleRow: cardTitleRow ?? this.cardTitleRow,
      title: title ?? this.title,
      description: description ?? this.description,
      footer: footer ?? this.footer,
    );
  }

  @override
  AgentToolCallSpec lerp(AgentToolCallSpec? other, double t) {
    return AgentToolCallSpec(
      row: row.lerp(other?.row, t),
      icon: icon.lerp(other?.icon, t),
      summary: summary.lerp(other?.summary, t),
      meta: meta.lerp(other?.meta, t),
      toolId: toolId.lerp(other?.toolId, t),
      status: status.lerp(other?.status, t),
      statusIcon: statusIcon.lerp(other?.statusIcon, t),
      statusLabel: statusLabel.lerp(other?.statusLabel, t),
      indicator: indicator.lerp(other?.indicator, t),
      output: output.lerp(other?.output, t),
      outputMaxHeight: MixOps.lerp(outputMaxHeight, other?.outputMaxHeight, t),
      outputContent: outputContent.lerp(other?.outputContent, t),
      outputText: outputText.lerp(other?.outputText, t),
      error: error.lerp(other?.error, t),
      errorText: errorText.lerp(other?.errorText, t),
      card: card.lerp(other?.card, t),
      cardBody: cardBody.lerp(other?.cardBody, t),
      cardIcon: cardIcon.lerp(other?.cardIcon, t),
      cardGlyph: cardGlyph.lerp(other?.cardGlyph, t),
      cardContent: cardContent.lerp(other?.cardContent, t),
      cardHeading: cardHeading.lerp(other?.cardHeading, t),
      cardTitleRow: cardTitleRow.lerp(other?.cardTitleRow, t),
      title: title.lerp(other?.title, t),
      description: description.lerp(other?.description, t),
      footer: footer.lerp(other?.footer, t),
    );
  }

  @override
  List<Object?> get props => [
    row,
    icon,
    summary,
    meta,
    toolId,
    status,
    statusIcon,
    statusLabel,
    indicator,
    output,
    outputMaxHeight,
    outputContent,
    outputText,
    error,
    errorText,
    card,
    cardBody,
    cardIcon,
    cardGlyph,
    cardContent,
    cardHeading,
    cardTitleRow,
    title,
    description,
    footer,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AgentToolCallSpec &&
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
      ..add(DiagnosticsProperty('row', row))
      ..add(DiagnosticsProperty('icon', icon))
      ..add(DiagnosticsProperty('summary', summary))
      ..add(DiagnosticsProperty('meta', meta))
      ..add(DiagnosticsProperty('toolId', toolId))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('statusIcon', statusIcon))
      ..add(DiagnosticsProperty('statusLabel', statusLabel))
      ..add(DiagnosticsProperty('indicator', indicator))
      ..add(DiagnosticsProperty('output', output))
      ..add(DoubleProperty('outputMaxHeight', outputMaxHeight))
      ..add(DiagnosticsProperty('outputContent', outputContent))
      ..add(DiagnosticsProperty('outputText', outputText))
      ..add(DiagnosticsProperty('error', error))
      ..add(DiagnosticsProperty('errorText', errorText))
      ..add(DiagnosticsProperty('card', card))
      ..add(DiagnosticsProperty('cardBody', cardBody))
      ..add(DiagnosticsProperty('cardIcon', cardIcon))
      ..add(DiagnosticsProperty('cardGlyph', cardGlyph))
      ..add(DiagnosticsProperty('cardContent', cardContent))
      ..add(DiagnosticsProperty('cardHeading', cardHeading))
      ..add(DiagnosticsProperty('cardTitleRow', cardTitleRow))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('footer', footer));
  }
}

@Deprecated(
  'Rename to `_\$AgentToolCallSpec` and migrate the class declaration to `class AgentToolCallSpec with _\$AgentToolCallSpec`. The `_\$AgentToolCallSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$AgentToolCallSpecMethods = _$AgentToolCallSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class AgentToolCallStyler
    extends MixStyler<AgentToolCallStyler, AgentToolCallSpec>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<FlexBoxSpec>>? $row;
  final Prop<StyleSpec<IconSpec>>? $icon;
  final Prop<StyleSpec<TextSpec>>? $summary;
  final Prop<StyleSpec<TextSpec>>? $meta;
  final Prop<StyleSpec<TextSpec>>? $toolId;
  final Prop<StyleSpec<FlexBoxSpec>>? $status;
  final Prop<StyleSpec<IconSpec>>? $statusIcon;
  final Prop<StyleSpec<TextSpec>>? $statusLabel;
  final Prop<StyleSpec<IconSpec>>? $indicator;
  final Prop<StyleSpec<BoxSpec>>? $output;
  final Prop<double>? $outputMaxHeight;
  final Prop<StyleSpec<BoxSpec>>? $outputContent;
  final Prop<StyleSpec<TextSpec>>? $outputText;
  final Prop<StyleSpec<BoxSpec>>? $error;
  final Prop<StyleSpec<TextSpec>>? $errorText;
  final Prop<StyleSpec<BoxSpec>>? $card;
  final Prop<StyleSpec<FlexBoxSpec>>? $cardBody;
  final Prop<StyleSpec<BoxSpec>>? $cardIcon;
  final Prop<StyleSpec<IconSpec>>? $cardGlyph;
  final Prop<StyleSpec<FlexBoxSpec>>? $cardContent;
  final Prop<StyleSpec<FlexBoxSpec>>? $cardHeading;
  final Prop<StyleSpec<FlexBoxSpec>>? $cardTitleRow;
  final Prop<StyleSpec<TextSpec>>? $title;
  final Prop<StyleSpec<TextSpec>>? $description;
  final Prop<StyleSpec<FlexBoxSpec>>? $footer;

  const AgentToolCallStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? row,
    Prop<StyleSpec<IconSpec>>? icon,
    Prop<StyleSpec<TextSpec>>? summary,
    Prop<StyleSpec<TextSpec>>? meta,
    Prop<StyleSpec<TextSpec>>? toolId,
    Prop<StyleSpec<FlexBoxSpec>>? status,
    Prop<StyleSpec<IconSpec>>? statusIcon,
    Prop<StyleSpec<TextSpec>>? statusLabel,
    Prop<StyleSpec<IconSpec>>? indicator,
    Prop<StyleSpec<BoxSpec>>? output,
    Prop<double>? outputMaxHeight,
    Prop<StyleSpec<BoxSpec>>? outputContent,
    Prop<StyleSpec<TextSpec>>? outputText,
    Prop<StyleSpec<BoxSpec>>? error,
    Prop<StyleSpec<TextSpec>>? errorText,
    Prop<StyleSpec<BoxSpec>>? card,
    Prop<StyleSpec<FlexBoxSpec>>? cardBody,
    Prop<StyleSpec<BoxSpec>>? cardIcon,
    Prop<StyleSpec<IconSpec>>? cardGlyph,
    Prop<StyleSpec<FlexBoxSpec>>? cardContent,
    Prop<StyleSpec<FlexBoxSpec>>? cardHeading,
    Prop<StyleSpec<FlexBoxSpec>>? cardTitleRow,
    Prop<StyleSpec<TextSpec>>? title,
    Prop<StyleSpec<TextSpec>>? description,
    Prop<StyleSpec<FlexBoxSpec>>? footer,
    super.variants,
    super.modifier,
    super.animation,
  }) : $row = row,
       $icon = icon,
       $summary = summary,
       $meta = meta,
       $toolId = toolId,
       $status = status,
       $statusIcon = statusIcon,
       $statusLabel = statusLabel,
       $indicator = indicator,
       $output = output,
       $outputMaxHeight = outputMaxHeight,
       $outputContent = outputContent,
       $outputText = outputText,
       $error = error,
       $errorText = errorText,
       $card = card,
       $cardBody = cardBody,
       $cardIcon = cardIcon,
       $cardGlyph = cardGlyph,
       $cardContent = cardContent,
       $cardHeading = cardHeading,
       $cardTitleRow = cardTitleRow,
       $title = title,
       $description = description,
       $footer = footer;

  AgentToolCallStyler({
    FlexBoxStyler? row,
    IconStyler? icon,
    TextStyler? summary,
    TextStyler? meta,
    TextStyler? toolId,
    FlexBoxStyler? status,
    IconStyler? statusIcon,
    TextStyler? statusLabel,
    IconStyler? indicator,
    BoxStyler? output,
    double? outputMaxHeight,
    BoxStyler? outputContent,
    TextStyler? outputText,
    BoxStyler? error,
    TextStyler? errorText,
    BoxStyler? card,
    FlexBoxStyler? cardBody,
    BoxStyler? cardIcon,
    IconStyler? cardGlyph,
    FlexBoxStyler? cardContent,
    FlexBoxStyler? cardHeading,
    FlexBoxStyler? cardTitleRow,
    TextStyler? title,
    TextStyler? description,
    FlexBoxStyler? footer,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<AgentToolCallSpec>>? variants,
  }) : this.create(
         row: Prop.maybeMix(row),
         icon: Prop.maybeMix(icon),
         summary: Prop.maybeMix(summary),
         meta: Prop.maybeMix(meta),
         toolId: Prop.maybeMix(toolId),
         status: Prop.maybeMix(status),
         statusIcon: Prop.maybeMix(statusIcon),
         statusLabel: Prop.maybeMix(statusLabel),
         indicator: Prop.maybeMix(indicator),
         output: Prop.maybeMix(output),
         outputMaxHeight: Prop.maybe(outputMaxHeight),
         outputContent: Prop.maybeMix(outputContent),
         outputText: Prop.maybeMix(outputText),
         error: Prop.maybeMix(error),
         errorText: Prop.maybeMix(errorText),
         card: Prop.maybeMix(card),
         cardBody: Prop.maybeMix(cardBody),
         cardIcon: Prop.maybeMix(cardIcon),
         cardGlyph: Prop.maybeMix(cardGlyph),
         cardContent: Prop.maybeMix(cardContent),
         cardHeading: Prop.maybeMix(cardHeading),
         cardTitleRow: Prop.maybeMix(cardTitleRow),
         title: Prop.maybeMix(title),
         description: Prop.maybeMix(description),
         footer: Prop.maybeMix(footer),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory AgentToolCallStyler.row(FlexBoxStyler value) =>
      AgentToolCallStyler().row(value);
  factory AgentToolCallStyler.icon(IconStyler value) =>
      AgentToolCallStyler().icon(value);
  factory AgentToolCallStyler.summary(TextStyler value) =>
      AgentToolCallStyler().summary(value);
  factory AgentToolCallStyler.meta(TextStyler value) =>
      AgentToolCallStyler().meta(value);
  factory AgentToolCallStyler.toolId(TextStyler value) =>
      AgentToolCallStyler().toolId(value);
  factory AgentToolCallStyler.status(FlexBoxStyler value) =>
      AgentToolCallStyler().status(value);
  factory AgentToolCallStyler.statusIcon(IconStyler value) =>
      AgentToolCallStyler().statusIcon(value);
  factory AgentToolCallStyler.statusLabel(TextStyler value) =>
      AgentToolCallStyler().statusLabel(value);
  factory AgentToolCallStyler.indicator(IconStyler value) =>
      AgentToolCallStyler().indicator(value);
  factory AgentToolCallStyler.output(BoxStyler value) =>
      AgentToolCallStyler().output(value);
  factory AgentToolCallStyler.outputMaxHeight(double value) =>
      AgentToolCallStyler().outputMaxHeight(value);
  factory AgentToolCallStyler.outputContent(BoxStyler value) =>
      AgentToolCallStyler().outputContent(value);
  factory AgentToolCallStyler.outputText(TextStyler value) =>
      AgentToolCallStyler().outputText(value);
  factory AgentToolCallStyler.error(BoxStyler value) =>
      AgentToolCallStyler().error(value);
  factory AgentToolCallStyler.errorText(TextStyler value) =>
      AgentToolCallStyler().errorText(value);
  factory AgentToolCallStyler.card(BoxStyler value) =>
      AgentToolCallStyler().card(value);
  factory AgentToolCallStyler.cardBody(FlexBoxStyler value) =>
      AgentToolCallStyler().cardBody(value);
  factory AgentToolCallStyler.cardIcon(BoxStyler value) =>
      AgentToolCallStyler().cardIcon(value);
  factory AgentToolCallStyler.cardGlyph(IconStyler value) =>
      AgentToolCallStyler().cardGlyph(value);
  factory AgentToolCallStyler.cardContent(FlexBoxStyler value) =>
      AgentToolCallStyler().cardContent(value);
  factory AgentToolCallStyler.cardHeading(FlexBoxStyler value) =>
      AgentToolCallStyler().cardHeading(value);
  factory AgentToolCallStyler.cardTitleRow(FlexBoxStyler value) =>
      AgentToolCallStyler().cardTitleRow(value);
  factory AgentToolCallStyler.title(TextStyler value) =>
      AgentToolCallStyler().title(value);
  factory AgentToolCallStyler.description(TextStyler value) =>
      AgentToolCallStyler().description(value);
  factory AgentToolCallStyler.footer(FlexBoxStyler value) =>
      AgentToolCallStyler().footer(value);

  @override
  Set<String> get $stylerFieldNames => const {
    'row',
    'icon',
    'summary',
    'meta',
    'toolId',
    'status',
    'statusIcon',
    'statusLabel',
    'indicator',
    'output',
    'outputMaxHeight',
    'outputContent',
    'outputText',
    'error',
    'errorText',
    'card',
    'cardBody',
    'cardIcon',
    'cardGlyph',
    'cardContent',
    'cardHeading',
    'cardTitleRow',
    'title',
    'description',
    'footer',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the row.
  AgentToolCallStyler row(FlexBoxStyler value) {
    return merge(AgentToolCallStyler(row: value));
  }

  /// Sets the icon.
  AgentToolCallStyler icon(IconStyler value) {
    return merge(AgentToolCallStyler(icon: value));
  }

  /// Sets the summary.
  AgentToolCallStyler summary(TextStyler value) {
    return merge(AgentToolCallStyler(summary: value));
  }

  /// Sets the meta.
  AgentToolCallStyler meta(TextStyler value) {
    return merge(AgentToolCallStyler(meta: value));
  }

  /// Sets the toolId.
  AgentToolCallStyler toolId(TextStyler value) {
    return merge(AgentToolCallStyler(toolId: value));
  }

  /// Sets the status.
  AgentToolCallStyler status(FlexBoxStyler value) {
    return merge(AgentToolCallStyler(status: value));
  }

  /// Sets the statusIcon.
  AgentToolCallStyler statusIcon(IconStyler value) {
    return merge(AgentToolCallStyler(statusIcon: value));
  }

  /// Sets the statusLabel.
  AgentToolCallStyler statusLabel(TextStyler value) {
    return merge(AgentToolCallStyler(statusLabel: value));
  }

  /// Sets the indicator.
  AgentToolCallStyler indicator(IconStyler value) {
    return merge(AgentToolCallStyler(indicator: value));
  }

  /// Sets the output.
  AgentToolCallStyler output(BoxStyler value) {
    return merge(AgentToolCallStyler(output: value));
  }

  /// Sets the outputMaxHeight.
  AgentToolCallStyler outputMaxHeight(double value) {
    return merge(AgentToolCallStyler(outputMaxHeight: value));
  }

  /// Sets the outputContent.
  AgentToolCallStyler outputContent(BoxStyler value) {
    return merge(AgentToolCallStyler(outputContent: value));
  }

  /// Sets the outputText.
  AgentToolCallStyler outputText(TextStyler value) {
    return merge(AgentToolCallStyler(outputText: value));
  }

  /// Sets the error.
  AgentToolCallStyler error(BoxStyler value) {
    return merge(AgentToolCallStyler(error: value));
  }

  /// Sets the errorText.
  AgentToolCallStyler errorText(TextStyler value) {
    return merge(AgentToolCallStyler(errorText: value));
  }

  /// Sets the card.
  AgentToolCallStyler card(BoxStyler value) {
    return merge(AgentToolCallStyler(card: value));
  }

  /// Sets the cardBody.
  AgentToolCallStyler cardBody(FlexBoxStyler value) {
    return merge(AgentToolCallStyler(cardBody: value));
  }

  /// Sets the cardIcon.
  AgentToolCallStyler cardIcon(BoxStyler value) {
    return merge(AgentToolCallStyler(cardIcon: value));
  }

  /// Sets the cardGlyph.
  AgentToolCallStyler cardGlyph(IconStyler value) {
    return merge(AgentToolCallStyler(cardGlyph: value));
  }

  /// Sets the cardContent.
  AgentToolCallStyler cardContent(FlexBoxStyler value) {
    return merge(AgentToolCallStyler(cardContent: value));
  }

  /// Sets the cardHeading.
  AgentToolCallStyler cardHeading(FlexBoxStyler value) {
    return merge(AgentToolCallStyler(cardHeading: value));
  }

  /// Sets the cardTitleRow.
  AgentToolCallStyler cardTitleRow(FlexBoxStyler value) {
    return merge(AgentToolCallStyler(cardTitleRow: value));
  }

  /// Sets the title.
  AgentToolCallStyler title(TextStyler value) {
    return merge(AgentToolCallStyler(title: value));
  }

  /// Sets the description.
  AgentToolCallStyler description(TextStyler value) {
    return merge(AgentToolCallStyler(description: value));
  }

  /// Sets the footer.
  AgentToolCallStyler footer(FlexBoxStyler value) {
    return merge(AgentToolCallStyler(footer: value));
  }

  /// Sets the animation configuration.
  @override
  AgentToolCallStyler animate(AnimationConfig value) {
    return merge(AgentToolCallStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  AgentToolCallStyler variants(List<VariantStyle<AgentToolCallSpec>> value) {
    return merge(AgentToolCallStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  AgentToolCallStyler wrap(WidgetModifierConfig value) {
    return merge(AgentToolCallStyler(modifier: value));
  }

  /// Sets the widget modifier.
  AgentToolCallStyler modifier(WidgetModifierConfig value) {
    return merge(AgentToolCallStyler(modifier: value));
  }

  /// Merges with another [AgentToolCallStyler].
  @override
  AgentToolCallStyler merge(AgentToolCallStyler? other) {
    return AgentToolCallStyler.create(
      row: MixOps.merge($row, other?.$row),
      icon: MixOps.merge($icon, other?.$icon),
      summary: MixOps.merge($summary, other?.$summary),
      meta: MixOps.merge($meta, other?.$meta),
      toolId: MixOps.merge($toolId, other?.$toolId),
      status: MixOps.merge($status, other?.$status),
      statusIcon: MixOps.merge($statusIcon, other?.$statusIcon),
      statusLabel: MixOps.merge($statusLabel, other?.$statusLabel),
      indicator: MixOps.merge($indicator, other?.$indicator),
      output: MixOps.merge($output, other?.$output),
      outputMaxHeight: MixOps.merge($outputMaxHeight, other?.$outputMaxHeight),
      outputContent: MixOps.merge($outputContent, other?.$outputContent),
      outputText: MixOps.merge($outputText, other?.$outputText),
      error: MixOps.merge($error, other?.$error),
      errorText: MixOps.merge($errorText, other?.$errorText),
      card: MixOps.merge($card, other?.$card),
      cardBody: MixOps.merge($cardBody, other?.$cardBody),
      cardIcon: MixOps.merge($cardIcon, other?.$cardIcon),
      cardGlyph: MixOps.merge($cardGlyph, other?.$cardGlyph),
      cardContent: MixOps.merge($cardContent, other?.$cardContent),
      cardHeading: MixOps.merge($cardHeading, other?.$cardHeading),
      cardTitleRow: MixOps.merge($cardTitleRow, other?.$cardTitleRow),
      title: MixOps.merge($title, other?.$title),
      description: MixOps.merge($description, other?.$description),
      footer: MixOps.merge($footer, other?.$footer),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<AgentToolCallSpec>] using [context].
  @override
  StyleSpec<AgentToolCallSpec> resolve(BuildContext context) {
    final spec = AgentToolCallSpec(
      row: MixOps.resolve(context, $row),
      icon: MixOps.resolve(context, $icon),
      summary: MixOps.resolve(context, $summary),
      meta: MixOps.resolve(context, $meta),
      toolId: MixOps.resolve(context, $toolId),
      status: MixOps.resolve(context, $status),
      statusIcon: MixOps.resolve(context, $statusIcon),
      statusLabel: MixOps.resolve(context, $statusLabel),
      indicator: MixOps.resolve(context, $indicator),
      output: MixOps.resolve(context, $output),
      outputMaxHeight: MixOps.resolve(context, $outputMaxHeight),
      outputContent: MixOps.resolve(context, $outputContent),
      outputText: MixOps.resolve(context, $outputText),
      error: MixOps.resolve(context, $error),
      errorText: MixOps.resolve(context, $errorText),
      card: MixOps.resolve(context, $card),
      cardBody: MixOps.resolve(context, $cardBody),
      cardIcon: MixOps.resolve(context, $cardIcon),
      cardGlyph: MixOps.resolve(context, $cardGlyph),
      cardContent: MixOps.resolve(context, $cardContent),
      cardHeading: MixOps.resolve(context, $cardHeading),
      cardTitleRow: MixOps.resolve(context, $cardTitleRow),
      title: MixOps.resolve(context, $title),
      description: MixOps.resolve(context, $description),
      footer: MixOps.resolve(context, $footer),
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
      ..add(DiagnosticsProperty('row', $row))
      ..add(DiagnosticsProperty('icon', $icon))
      ..add(DiagnosticsProperty('summary', $summary))
      ..add(DiagnosticsProperty('meta', $meta))
      ..add(DiagnosticsProperty('toolId', $toolId))
      ..add(DiagnosticsProperty('status', $status))
      ..add(DiagnosticsProperty('statusIcon', $statusIcon))
      ..add(DiagnosticsProperty('statusLabel', $statusLabel))
      ..add(DiagnosticsProperty('indicator', $indicator))
      ..add(DiagnosticsProperty('output', $output))
      ..add(DiagnosticsProperty('outputMaxHeight', $outputMaxHeight))
      ..add(DiagnosticsProperty('outputContent', $outputContent))
      ..add(DiagnosticsProperty('outputText', $outputText))
      ..add(DiagnosticsProperty('error', $error))
      ..add(DiagnosticsProperty('errorText', $errorText))
      ..add(DiagnosticsProperty('card', $card))
      ..add(DiagnosticsProperty('cardBody', $cardBody))
      ..add(DiagnosticsProperty('cardIcon', $cardIcon))
      ..add(DiagnosticsProperty('cardGlyph', $cardGlyph))
      ..add(DiagnosticsProperty('cardContent', $cardContent))
      ..add(DiagnosticsProperty('cardHeading', $cardHeading))
      ..add(DiagnosticsProperty('cardTitleRow', $cardTitleRow))
      ..add(DiagnosticsProperty('title', $title))
      ..add(DiagnosticsProperty('description', $description))
      ..add(DiagnosticsProperty('footer', $footer));
  }

  @override
  List<Object?> get props => [
    $row,
    $icon,
    $summary,
    $meta,
    $toolId,
    $status,
    $statusIcon,
    $statusLabel,
    $indicator,
    $output,
    $outputMaxHeight,
    $outputContent,
    $outputText,
    $error,
    $errorText,
    $card,
    $cardBody,
    $cardIcon,
    $cardGlyph,
    $cardContent,
    $cardHeading,
    $cardTitleRow,
    $title,
    $description,
    $footer,
    $animation,
    $modifier,
    $variants,
  ];
}
