part of 'accordion.dart';

class RemixAccordionStyle extends Style<AccordionSpec>
    with
        StyleModifierMixin<RemixAccordionStyle, AccordionSpec>,
        StyleVariantMixin<RemixAccordionStyle, AccordionSpec> {
  final Prop<ContainerSpec>? $container;
  final Prop<ContainerSpec>? $content;
  final Prop<FlexContainerSpec>? $header;
  final Prop<LabelSpec>? $headerLabel;

  const RemixAccordionStyle.create({
    Prop<ContainerSpec>? container,
    Prop<ContainerSpec>? content,
    Prop<FlexContainerSpec>? header,
    Prop<LabelSpec>? headerLabel,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $content = content,
        $header = header,
        $headerLabel = headerLabel;

  RemixAccordionStyle({
    ContainerMix? container,
    ContainerMix? content,
    FlexContainerMix? header,
    RemixLabelStyle? headerLabel,
    AnimationConfig? animation,
    List<VariantStyle<AccordionSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: container != null ? Prop.mix(container) : null,
          content:
              content != null ? Prop.mix(content) : null,
          header: header != null ? Prop.mix(header) : null,
          headerLabel: headerLabel != null ? Prop.mix(headerLabel) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixAccordionStyle.value(AccordionSpec spec) => RemixAccordionStyle(
        container: ContainerMix.maybeValue(spec.container),
        content: ContainerMix.maybeValue(spec.content),
        header: FlexContainerMix.maybeValue(spec.header),
        headerLabel: RemixLabelStyle.value(spec.headerLabel),
      );

  @override
  AccordionSpec resolve(BuildContext context) {
    return AccordionSpec(
      container: MixOps.resolve(context, $container),
      content: MixOps.resolve(context, $content),
      header: MixOps.resolve(context, $header),
      headerLabel: MixOps.resolve(context, $headerLabel),
    );
  }

  @override
  RemixAccordionStyle merge(RemixAccordionStyle? other) {
    if (other == null) return this;

    return RemixAccordionStyle.create(
      container: MixOps.merge($container, other.$container),
      content:
          MixOps.merge($content, other.$content),
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
  container: ContainerMix(
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(BorderSideMix(
        color: RemixTokens.border(),
        width: 1,
      )),
      borderRadius: BorderRadiusMix.circular(12),
    ),
    margin: EdgeInsetsMix(bottom: 12),
  ),
  content: ContainerMix(
    padding: EdgeInsetsMix.fromLTRB(12, 0, 12, 12),
    constraints: BoxConstraintsMix(minWidth: double.infinity),
  ),
  header: FlexContainerMix(
    padding: EdgeInsetsMix.all(12),
    direction: Axis.horizontal,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
  ),
  headerLabel: RemixLabelStyle(
    label: TypographyMix(
      style: TextStyleMix(
        color: RemixTokens.textPrimary(),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    leading: IconographyMix(size: 20),
    trailing: IconographyMix(size: 20),
    flex: FlexLayoutMix(spacing: 8),
  ),
);

extension AccordionVariants on RemixAccordionStyle {
  /// Default accordion variant (same as DefaultAccordionStyle)
  static RemixAccordionStyle get defaultVariant => RemixAccordionStyle(
        container: ContainerMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.border(),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(12),
          ),
          margin: EdgeInsetsMix(bottom: 12),
        ),
        content: ContainerMix(
          padding: EdgeInsetsMix.fromLTRB(12, 0, 12, 12),
          constraints: BoxConstraintsMix(minWidth: double.infinity),
        ),
        header: FlexContainerMix(
          padding: EdgeInsetsMix.all(12),
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        headerLabel: RemixLabelStyle(
          label: TypographyMix(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: IconographyMix(size: 20),
          trailing: IconographyMix(size: 20),
          flex: FlexLayoutMix(spacing: 8),
        ),
      );

  /// Compact accordion variant with smaller padding
  static RemixAccordionStyle get compact => RemixAccordionStyle(
        container: ContainerMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.border(),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(8),
          ),
          margin: EdgeInsetsMix(bottom: 8),
        ),
        content: ContainerMix(
          padding: EdgeInsetsMix.fromLTRB(8, 0, 8, 8),
          constraints: BoxConstraintsMix(minWidth: double.infinity),
        ),
        header: FlexContainerMix(
          padding: EdgeInsetsMix.all(8),
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        headerLabel: RemixLabelStyle(
          label: TypographyMix(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: IconographyMix(size: 16),
          trailing: IconographyMix(size: 16),
          flex: FlexLayoutMix(spacing: 6),
        ),
      );

  /// Bordered accordion variant with prominent borders
  static RemixAccordionStyle get bordered => RemixAccordionStyle(
        container: ContainerMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.textSecondary(),
              width: 2,
            )),
            borderRadius: BorderRadiusMix.circular(12),
          ),
          margin: EdgeInsetsMix(bottom: 12),
        ),
        content: ContainerMix(
          padding: EdgeInsetsMix.fromLTRB(16, 0, 16, 16),
          constraints: BoxConstraintsMix(minWidth: double.infinity),
        ),
        header: FlexContainerMix(
          padding: EdgeInsetsMix.all(16),
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        headerLabel: RemixLabelStyle(
          label: TypographyMix(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconographyMix(size: 20),
          trailing: IconographyMix(size: 20),
          flex: FlexLayoutMix(spacing: 10),
        ),
      );
}
