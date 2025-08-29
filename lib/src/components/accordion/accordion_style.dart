part of 'accordion.dart';

class RemixAccordionStyle extends Style<AccordionSpec>
    with
        StyleModifierMixin<RemixAccordionStyle, AccordionSpec>,
        StyleVariantMixin<RemixAccordionStyle, AccordionSpec> {
  final Prop<WidgetSpec<BoxSpec>>? $container;
  final Prop<WidgetSpec<BoxSpec>>? $content;
  final Prop<WidgetSpec<BoxSpec>>? $header;
  final Prop<WidgetSpec<LabelSpec>>? $headerLabel;

  const RemixAccordionStyle.create({
    Prop<WidgetSpec<BoxSpec>>? container,
    Prop<WidgetSpec<BoxSpec>>? content,
    Prop<WidgetSpec<BoxSpec>>? header,
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
    BoxStyle? container,
    BoxStyle? content,
    BoxStyle? header,
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


  @override
  WidgetSpec<AccordionSpec> resolve(BuildContext context) {
    return WidgetSpec(
      spec: AccordionSpec(
        container: MixOps.resolve(context, $container),
        content: MixOps.resolve(context, $content),
        header: MixOps.resolve(context, $header),
        headerLabel: MixOps.resolve(context, $headerLabel),
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
  container: BoxStyle(
    margin: EdgeInsetsMix(bottom: 12),
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(BorderSideMix(
        color: RemixTokens.border(),
        width: 1,
      )),
      borderRadius: BorderRadiusMix.circular(12),
    ),
  ),
  content: BoxStyle(
    padding: EdgeInsetsMix.fromLTRB(12, 0, 12, 12),
    constraints: BoxConstraintsMix(minWidth: double.infinity),
  ),
  header: BoxStyle(padding: EdgeInsetsMix.all(12)),
  headerLabel: RemixLabelStyle(
    label: TextStyling(
      style: TextStyleMix(
        color: RemixTokens.textPrimary(),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    leading: IconStyle(size: 20),
    trailing: IconStyle(size: 20),
    flex: FlexStyle(spacing: 8),
  ),
);

extension AccordionVariants on RemixAccordionStyle {
  /// Default accordion variant (same as DefaultAccordionStyle)
  static RemixAccordionStyle get defaultVariant => RemixAccordionStyle(
        container: BoxStyle(
          margin: EdgeInsetsMix(bottom: 12),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.border(),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(12),
          ),
        ),
        content: BoxStyle(
          padding: EdgeInsetsMix.fromLTRB(12, 0, 12, 12),
          constraints: BoxConstraintsMix(minWidth: double.infinity),
        ),
        header: BoxStyle(padding: EdgeInsetsMix.all(12)),
        headerLabel: RemixLabelStyle(
          label: TextStyling(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: IconStyle(size: 20),
          trailing: IconStyle(size: 20),
          flex: FlexStyle(spacing: 8),
        ),
      );

  /// Compact accordion variant with smaller padding
  static RemixAccordionStyle get compact => RemixAccordionStyle(
        container: BoxStyle(
          margin: EdgeInsetsMix(bottom: 8),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.border(),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(8),
          ),
        ),
        content: BoxStyle(
          padding: EdgeInsetsMix.fromLTRB(8, 0, 8, 8),
          constraints: BoxConstraintsMix(minWidth: double.infinity),
        ),
        header: BoxStyle(padding: EdgeInsetsMix.all(8)),
        headerLabel: RemixLabelStyle(
          label: TextStyling(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: IconStyle(size: 16),
          trailing: IconStyle(size: 16),
          flex: FlexStyle(spacing: 6),
        ),
      );

  /// Bordered accordion variant with prominent borders
  static RemixAccordionStyle get bordered => RemixAccordionStyle(
        container: BoxStyle(
          margin: EdgeInsetsMix(bottom: 12),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.textSecondary(),
              width: 2,
            )),
            borderRadius: BorderRadiusMix.circular(12),
          ),
        ),
        content: BoxStyle(
          padding: EdgeInsetsMix.fromLTRB(16, 0, 16, 16),
          constraints: BoxConstraintsMix(minWidth: double.infinity),
        ),
        header: BoxStyle(padding: EdgeInsetsMix.all(16)),
        headerLabel: RemixLabelStyle(
          label: TextStyling(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconStyle(size: 20),
          trailing: IconStyle(size: 20),
          flex: FlexStyle(spacing: 10),
        ),
      );
}
