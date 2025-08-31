part of 'accordion.dart';

class RemixAccordionStyle extends Style<AccordionSpec>
    with
        StyleModifierMixin<RemixAccordionStyle, AccordionSpec>,
        StyleVariantMixin<RemixAccordionStyle, AccordionSpec> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<BoxSpec>>? $content;
  final Prop<StyleSpec<BoxSpec>>? $header;
  final Prop<StyleSpec<LabelSpec>>? $headerLabel;

  const RemixAccordionStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<BoxSpec>>? content,
    Prop<StyleSpec<BoxSpec>>? header,
    Prop<StyleSpec<LabelSpec>>? headerLabel,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $content = content,
        $header = header,
        $headerLabel = headerLabel;

  RemixAccordionStyle({
    BoxStyler? container,
    BoxStyler? content,
    BoxStyler? header,
    RemixLabelStyle? headerLabel,
    AnimationConfig? animation,
    List<VariantStyle<AccordionSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          content: Prop.maybeMix(content),
          header: Prop.maybeMix(header),
          headerLabel: Prop.maybeMix(headerLabel),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  @override
  StyleSpec<AccordionSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: AccordionSpec(
        container: MixOps.resolve(context, $container),
        content: MixOps.resolve(context, $content),
        header: MixOps.resolve(context, $header),
        headerLabel: MixOps.resolve(context, $headerLabel),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
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
      ];
}

final DefaultRemixAccordionStyle = RemixAccordionStyle(
  container: BoxStyler(
    margin: EdgeInsetsMix(bottom: 12),
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(BorderSideMix(
        color: RemixTokens.border(),
        width: 1,
      )),
      borderRadius: BorderRadiusMix.circular(12),
    ),
  ),
  content: BoxStyler(
    padding: EdgeInsetsMix.fromLTRB(12, 0, 12, 12),
    constraints: BoxConstraintsMix(minWidth: double.infinity),
  ),
  header: BoxStyler(padding: EdgeInsetsMix.all(12)),
  headerLabel: RemixLabelStyle(
    label: TextStyler(
      style: TextStyleMix(
        color: RemixTokens.textPrimary(),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    leading: IconStyler(size: 20),
    trailing: IconStyler(size: 20),
    flex: FlexStyler(spacing: 8),
  ),
);

extension AccordionVariants on RemixAccordionStyle {
  /// Default accordion variant (same as DefaultAccordionStyle)
  static RemixAccordionStyle get defaultVariant => RemixAccordionStyle(
        container: BoxStyler(
          margin: EdgeInsetsMix(bottom: 12),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.border(),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(12),
          ),
        ),
        content: BoxStyler(
          padding: EdgeInsetsMix.fromLTRB(12, 0, 12, 12),
          constraints: BoxConstraintsMix(minWidth: double.infinity),
        ),
        header: BoxStyler(padding: EdgeInsetsMix.all(12)),
        headerLabel: RemixLabelStyle(
          label: TextStyler(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: IconStyler(size: 20),
          trailing: IconStyler(size: 20),
          flex: FlexStyler(spacing: 8),
        ),
      );

  /// Compact accordion variant with smaller padding
  static RemixAccordionStyle get compact => RemixAccordionStyle(
        container: BoxStyler(
          margin: EdgeInsetsMix(bottom: 8),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.border(),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(8),
          ),
        ),
        content: BoxStyler(
          padding: EdgeInsetsMix.fromLTRB(8, 0, 8, 8),
          constraints: BoxConstraintsMix(minWidth: double.infinity),
        ),
        header: BoxStyler(padding: EdgeInsetsMix.all(8)),
        headerLabel: RemixLabelStyle(
          label: TextStyler(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: IconStyler(size: 16),
          trailing: IconStyler(size: 16),
          flex: FlexStyler(spacing: 6),
        ),
      );

  /// Bordered accordion variant with prominent borders
  static RemixAccordionStyle get bordered => RemixAccordionStyle(
        container: BoxStyler(
          margin: EdgeInsetsMix(bottom: 12),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.textSecondary(),
              width: 2,
            )),
            borderRadius: BorderRadiusMix.circular(12),
          ),
        ),
        content: BoxStyler(
          padding: EdgeInsetsMix.fromLTRB(16, 0, 16, 16),
          constraints: BoxConstraintsMix(minWidth: double.infinity),
        ),
        header: BoxStyler(padding: EdgeInsetsMix.all(16)),
        headerLabel: RemixLabelStyle(
          label: TextStyler(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconStyler(size: 20),
          trailing: IconStyler(size: 20),
          flex: FlexStyler(spacing: 10),
        ),
      );
}
