part of 'accordion.dart';

class RemixAccordionStyle extends Style<AccordionSpec>
    with
        StyleModifierMixin<RemixAccordionStyle, AccordionSpec>,
        StyleVariantMixin<RemixAccordionStyle, AccordionSpec> {
  final Prop<BoxSpec>? $container;
  final Prop<BoxSpec>? $content;
  final Prop<BoxSpec>? $header;
  final Prop<WidgetSpec<LabelSpec>>? $headerLabel;

  const RemixAccordionStyle.create({
    Prop<BoxSpec>? container,
    Prop<BoxSpec>? content,
    Prop<BoxSpec>? header,
    Prop<WidgetSpec<LabelSpec>>? headerLabel,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $content = content,
        $header = header,
        $headerLabel = headerLabel;

  RemixAccordionStyle({
    BoxMix? container,
    BoxMix? content,
    BoxMix? header,
    RemixLabelStyle? headerLabel,
    AnimationConfig? animation,
    List<VariantStyle<AccordionSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: Prop.maybeMix(container),
          content: Prop.maybeMix(content),
          header: Prop.maybeMix(header),
          headerLabel: Prop.maybeMix(headerLabel),
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixAccordionStyle.value(AccordionSpec spec) => RemixAccordionStyle(
        container: BoxMix.maybeValue(spec.container),
        content: BoxMix.maybeValue(spec.content),
        header: BoxMix.maybeValue(spec.header),
        headerLabel: RemixLabelStyle.value(spec.headerLabel),
      );

  @override
  WidgetSpec<AccordionSpec> resolve(BuildContext context) {
    return WidgetSpec(
      spec: AccordionSpec(
        container: MixOps.resolve(context, $container),
        content: MixOps.resolve(context, $content),
        header: MixOps.resolve(context, $header),
        headerLabel: MixOps.resolve(context, $headerLabel)?.spec,
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
      inherit: $inherit,
    );
  }

  @override
  RemixAccordionStyle merge(RemixAccordionStyle? other) {
    if (other == null) return this;

    return RemixAccordionStyle.create(
      container: MixOps.merge($container, other.$container),
      content: MixOps.merge($content, other.$content),
      header: MixOps.merge($header, other.$header),
      headerLabel: MixOps.merge($headerLabel, other.$headerLabel),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  RemixAccordionStyle variant(Variant variant, RemixAccordionStyle style) {
    return merge(RemixAccordionStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixAccordionStyle variants(List<VariantStyle<AccordionSpec>> value) {
    return merge(RemixAccordionStyle(variants: value));
  }

  @override
  RemixAccordionStyle wrap(ModifierConfig value) {
    return merge(RemixAccordionStyle(modifier: value));
  }

  @override
  List<Object?> get props => [
        $container,
        $content,
        $header,
        $headerLabel,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

final DefaultRemixAccordionStyle = RemixAccordionStyle(
  container: BoxMix(
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(BorderSideMix(
        color: RemixTokens.border(),
        width: 1,
      )),
      borderRadius: BorderRadiusMix.circular(12),
    ),
    margin: EdgeInsetsMix(bottom: 12),
  ),
  content: BoxMix(
    padding: EdgeInsetsMix.fromLTRB(12, 0, 12, 12),
    constraints: BoxConstraintsMix(minWidth: double.infinity),
  ),
  header: BoxMix(padding: EdgeInsetsMix.all(12)),
  headerLabel: RemixLabelStyle(
    label: TextMix(
      style: TextStyleMix(
        color: RemixTokens.textPrimary(),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    leading: IconMix(size: 20),
    trailing: IconMix(size: 20),
    flex: FlexMix(spacing: 8),
  ),
);

extension AccordionVariants on RemixAccordionStyle {
  /// Default accordion variant (same as DefaultAccordionStyle)
  static RemixAccordionStyle get defaultVariant => RemixAccordionStyle(
        container: BoxMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.border(),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(12),
          ),
          margin: EdgeInsetsMix(bottom: 12),
        ),
        content: BoxMix(
          padding: EdgeInsetsMix.fromLTRB(12, 0, 12, 12),
          constraints: BoxConstraintsMix(minWidth: double.infinity),
        ),
        header: BoxMix(padding: EdgeInsetsMix.all(12)),
        headerLabel: RemixLabelStyle(
          label: TextMix(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: IconMix(size: 20),
          trailing: IconMix(size: 20),
          flex: FlexMix(spacing: 8),
        ),
      );

  /// Compact accordion variant with smaller padding
  static RemixAccordionStyle get compact => RemixAccordionStyle(
        container: BoxMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.border(),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(8),
          ),
          margin: EdgeInsetsMix(bottom: 8),
        ),
        content: BoxMix(
          padding: EdgeInsetsMix.fromLTRB(8, 0, 8, 8),
          constraints: BoxConstraintsMix(minWidth: double.infinity),
        ),
        header: BoxMix(padding: EdgeInsetsMix.all(8)),
        headerLabel: RemixLabelStyle(
          label: TextMix(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: IconMix(size: 16),
          trailing: IconMix(size: 16),
          flex: FlexMix(spacing: 6),
        ),
      );

  /// Bordered accordion variant with prominent borders
  static RemixAccordionStyle get bordered => RemixAccordionStyle(
        container: BoxMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.textSecondary(),
              width: 2,
            )),
            borderRadius: BorderRadiusMix.circular(12),
          ),
          margin: EdgeInsetsMix(bottom: 12),
        ),
        content: BoxMix(
          padding: EdgeInsetsMix.fromLTRB(16, 0, 16, 16),
          constraints: BoxConstraintsMix(minWidth: double.infinity),
        ),
        header: BoxMix(padding: EdgeInsetsMix.all(16)),
        headerLabel: RemixLabelStyle(
          label: TextMix(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconMix(size: 20),
          trailing: IconMix(size: 20),
          flex: FlexMix(spacing: 10),
        ),
      );
}
