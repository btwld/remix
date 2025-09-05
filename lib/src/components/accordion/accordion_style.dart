part of 'accordion.dart';

class RemixAccordionStyle extends Style<AccordionSpec>
    with
        StyleModifierMixin<RemixAccordionStyle, AccordionSpec>,
        StyleVariantMixin<RemixAccordionStyle, AccordionSpec>,
        ModifierStyleMixin<RemixAccordionStyle, AccordionSpec>,
        BorderStyleMixin<RemixAccordionStyle>,
        BorderRadiusStyleMixin<RemixAccordionStyle>,
        ShadowStyleMixin<RemixAccordionStyle>,
        DecorationStyleMixin<RemixAccordionStyle>,
        SpacingStyleMixin<RemixAccordionStyle>,
        TransformStyleMixin<RemixAccordionStyle>,
        ConstraintStyleMixin<RemixAccordionStyle>,
        AnimationStyleMixin<AccordionSpec, RemixAccordionStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<BoxSpec>>? $content;
  final Prop<StyleSpec<TextSpec>>? $contentText;
  final Prop<StyleSpec<BoxSpec>>? $header;
  final Prop<StyleSpec<LabelSpec>>? $headerLabel;

  const RemixAccordionStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<BoxSpec>>? content,
    Prop<StyleSpec<TextSpec>>? contentText,
    Prop<StyleSpec<BoxSpec>>? header,
    Prop<StyleSpec<LabelSpec>>? headerLabel,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $content = content,
        $contentText = contentText,
        $header = header,
        $headerLabel = headerLabel;

  RemixAccordionStyle({
    BoxStyler? container,
    BoxStyler? content,
    TextStyler? contentText,
    BoxStyler? header,
    RemixLabelStyle? headerLabel,
    AnimationConfig? animation,
    List<VariantStyle<AccordionSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          content: Prop.maybeMix(content),
          contentText: Prop.maybeMix(contentText),
          header: Prop.maybeMix(header),
          headerLabel: Prop.maybeMix(headerLabel),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Sets container padding
  RemixAccordionStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixAccordionStyle(container: BoxStyler(padding: value)));
  }

  /// Sets container background color
  RemixAccordionStyle color(Color value) {
    return merge(RemixAccordionStyle(
      container: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets container border radius
  RemixAccordionStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixAccordionStyle(
      container: BoxStyler(
        decoration: BoxDecorationMix(borderRadius: radius),
      ),
    ));
  }

  /// Sets container margin
  RemixAccordionStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixAccordionStyle(container: BoxStyler(margin: value)));
  }

  /// Sets container decoration
  RemixAccordionStyle decoration(DecorationMix value) {
    return merge(RemixAccordionStyle(
      container: BoxStyler(decoration: value),
    ));
  }

  /// Sets content area styling
  RemixAccordionStyle content(BoxStyler value) {
    return merge(RemixAccordionStyle(content: value));
  }

  /// Sets header styling
  RemixAccordionStyle header(BoxStyler value) {
    return merge(RemixAccordionStyle(header: value));
  }

  @override
  StyleSpec<AccordionSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: AccordionSpec(
        container: MixOps.resolve(context, $container),
        content: MixOps.resolve(context, $content),
        contentText: MixOps.resolve(context, $contentText),
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
      contentText: MixOps.merge($contentText, other.$contentText),
      header: MixOps.merge($header, other.$header),
      headerLabel: MixOps.merge($headerLabel, other.$headerLabel),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixAccordionStyle variants(List<VariantStyle<AccordionSpec>> value) {
    return merge(RemixAccordionStyle(variants: value));
  }

  @override
  RemixAccordionStyle wrap(ModifierConfig value) {
    return merge(RemixAccordionStyle(modifier: value));
  }

  // Abstract method implementations for mixins
  
  @override
  RemixAccordionStyle animate(AnimationConfig config) {
    return merge(RemixAccordionStyle(animation: config));
  }
  
  @override
  RemixAccordionStyle constraints(BoxConstraintsMix value) {
    return merge(RemixAccordionStyle(container: BoxStyler(constraints: value)));
  }
  
  @override
  RemixAccordionStyle foregroundDecoration(DecorationMix value) {
    return merge(RemixAccordionStyle(container: BoxStyler(foregroundDecoration: value)));
  }
  
  @override
  RemixAccordionStyle transform(Matrix4 value, {AlignmentGeometry alignment = Alignment.center}) {
    return merge(RemixAccordionStyle(container: BoxStyler(transform: value, alignment: alignment)));
  }

  @override
  List<Object?> get props => [
        $container,
        $content,
        $contentText,
        $header,
        $headerLabel,
        $variants,
        $animation,
        $modifier,
      ];
}

/// Default accordion styles and variants
class RemixAccordionStyles {
  /// Default accordion style
  static RemixAccordionStyle get defaultStyle => RemixAccordionStyle(
        container: BoxStyler(
          margin: EdgeInsetsMix(bottom: RemixTokens.spaceMd()),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.border(), width: 1),
            ),
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
          ),
        ),
        content: BoxStyler(
          padding: EdgeInsetsMix.fromLTRB(
            RemixTokens.spaceMd(),
            0,
            RemixTokens.spaceMd(),
            RemixTokens.spaceMd(),
          ),
          constraints: BoxConstraintsMix(minWidth: double.infinity),
        ),
        contentText: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: RemixTokens.fontSizeMd(),
          ),
        ),
        header: BoxStyler(padding: EdgeInsetsMix.all(RemixTokens.spaceMd())),
        headerLabel: RemixLabelStyle(
          label: TextStyler(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: RemixTokens.fontSizeMd(),
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: IconStyler(
            color: RemixTokens.textSecondary(),
            size: RemixTokens.iconSizeLg(),
          ),
          flex: FlexStyler(spacing: RemixTokens.spaceSm()),
        ),
      )
          .onHovered(
            RemixAccordionStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: RemixTokens.surfaceVariant().withValues(alpha: 0.5),
                ),
              ),
            ),
          )
          .onPressed(
            RemixAccordionStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: RemixTokens.surfaceVariant().withValues(alpha: 0.8),
                ),
              ),
            ),
          )
          .onFocused(
            RemixAccordionStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  border: BoxBorderMix.all(
                    BorderSideMix(
                      color: RemixTokens.primary().withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          )
          .onDisabled(
            RemixAccordionStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  border: BoxBorderMix.all(
                    BorderSideMix(
                      color: RemixTokens.border().withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                ),
              ),
              headerLabel: RemixLabelStyle(
                label: TextStyler(
                  style: TextStyleMix(color: RemixTokens.textDisabled()),
                ),
                icon: IconStyler(color: RemixTokens.textDisabled()),
              ),
            ),
          )
          .onSelected(
            RemixAccordionStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: RemixTokens.primary().withValues(alpha: 0.05),
                ),
              ),
            ),
          );

  /// Compact accordion variant with smaller padding
  static RemixAccordionStyle get compact => RemixAccordionStyle(
        container: BoxStyler(
          margin: EdgeInsetsMix(bottom: RemixTokens.spaceSm()),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.border(), width: 1),
            ),
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusMd()),
          ),
        ),
        content: BoxStyler(
          padding: EdgeInsetsMix.fromLTRB(
            RemixTokens.spaceSm(),
            0,
            RemixTokens.spaceSm(),
            RemixTokens.spaceSm(),
          ),
          constraints: BoxConstraintsMix(minWidth: double.infinity),
        ),
        contentText: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: RemixTokens.fontSizeSm(),
          ),
        ),
        header: BoxStyler(padding: EdgeInsetsMix.all(RemixTokens.spaceSm())),
        headerLabel: RemixLabelStyle(
          label: TextStyler(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: RemixTokens.fontSizeSm(),
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: IconStyler(
            color: RemixTokens.textSecondary(),
            size: RemixTokens.iconSizeMd(),
          ),
          flex: FlexStyler(spacing: RemixTokens.spaceXs()),
        ),
      ).onSelected(
        RemixAccordionStyle(
          container: BoxStyler(
            decoration: BoxDecorationMix(
              color: RemixTokens.primary().withValues(alpha: 0.05),
            ),
          ),
        ),
      );

  /// Bordered accordion variant with prominent borders
  static RemixAccordionStyle get bordered => RemixAccordionStyle(
        container: BoxStyler(
          margin: EdgeInsetsMix(bottom: RemixTokens.spaceMd()),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.border(), width: 2),
            ),
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
          ),
        ),
        content: BoxStyler(
          padding: EdgeInsetsMix.fromLTRB(
            RemixTokens.spaceLg(),
            0,
            RemixTokens.spaceLg(),
            RemixTokens.spaceLg(),
          ),
          constraints: BoxConstraintsMix(minWidth: double.infinity),
        ),
        contentText: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: RemixTokens.fontSizeMd(),
          ),
        ),
        header: BoxStyler(padding: EdgeInsetsMix.all(RemixTokens.spaceLg())),
        headerLabel: RemixLabelStyle(
          label: TextStyler(
            style: TextStyleMix(
              color: RemixTokens.textPrimary(),
              fontSize: RemixTokens.fontSizeLg(),
              fontWeight: FontWeight.w600,
            ),
          ),
          icon: IconStyler(
            color: RemixTokens.textSecondary(),
            size: RemixTokens.iconSizeXl(),
          ),
          flex: FlexStyler(spacing: RemixTokens.spaceMd()),
        ),
      )
          .onSelected(
            RemixAccordionStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: RemixTokens.primary().withValues(alpha: 0.05),
                ),
              ),
            ),
          )
          .onHovered(
            RemixAccordionStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  border: BoxBorderMix.all(
                    BorderSideMix(color: RemixTokens.primary(), width: 2),
                  ),
                ),
              ),
            ),
          );

  /// Primary accordion variant with primary color theme
  static RemixAccordionStyle get primary => RemixAccordionStyle(
        container: BoxStyler(
          margin: EdgeInsetsMix(bottom: RemixTokens.spaceMd()),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.primary(), width: 1),
            ),
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
          ),
        ),
        content: BoxStyler(
          padding: EdgeInsetsMix.fromLTRB(
            RemixTokens.spaceMd(),
            0,
            RemixTokens.spaceMd(),
            RemixTokens.spaceMd(),
          ),
          constraints: BoxConstraintsMix(minWidth: double.infinity),
        ),
        contentText: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: RemixTokens.fontSizeMd(),
          ),
        ),
        header: BoxStyler(padding: EdgeInsetsMix.all(RemixTokens.spaceMd())),
        headerLabel: RemixLabelStyle(
          label: TextStyler(
            style: TextStyleMix(
              color: RemixTokens.primary(),
              fontSize: RemixTokens.fontSizeMd(),
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: IconStyler(
            color: RemixTokens.primary(),
            size: RemixTokens.iconSizeLg(),
          ),
          flex: FlexStyler(spacing: RemixTokens.spaceSm()),
        ),
      )
          .onSelected(
            RemixAccordionStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: RemixTokens.primary().withValues(alpha: 0.1),
                ),
              ),
            ),
          )
          .onHovered(
            RemixAccordionStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: RemixTokens.primary().withValues(alpha: 0.05),
                ),
              ),
            ),
          );

  /// Secondary accordion variant with secondary color theme
  static RemixAccordionStyle get secondary => RemixAccordionStyle(
        container: BoxStyler(
          margin: EdgeInsetsMix(bottom: RemixTokens.spaceMd()),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.secondary(), width: 1),
            ),
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
          ),
        ),
        content: BoxStyler(
          padding: EdgeInsetsMix.fromLTRB(
            RemixTokens.spaceMd(),
            0,
            RemixTokens.spaceMd(),
            RemixTokens.spaceMd(),
          ),
          constraints: BoxConstraintsMix(minWidth: double.infinity),
        ),
        contentText: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: RemixTokens.fontSizeMd(),
          ),
        ),
        header: BoxStyler(padding: EdgeInsetsMix.all(RemixTokens.spaceMd())),
        headerLabel: RemixLabelStyle(
          label: TextStyler(
            style: TextStyleMix(
              color: RemixTokens.secondary(),
              fontSize: RemixTokens.fontSizeMd(),
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: IconStyler(
            color: RemixTokens.secondary(),
            size: RemixTokens.iconSizeLg(),
          ),
          flex: FlexStyler(spacing: RemixTokens.spaceSm()),
        ),
      )
          .onSelected(
            RemixAccordionStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: RemixTokens.secondary().withValues(alpha: 0.1),
                ),
              ),
            ),
          )
          .onHovered(
            RemixAccordionStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: RemixTokens.secondary().withValues(alpha: 0.05),
                ),
              ),
            ),
          );
}
