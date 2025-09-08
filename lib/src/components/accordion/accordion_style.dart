part of 'accordion.dart';

// Private per-component constants (sizes only)
const _kFontSizeSm = 12.0;
const _kFontSizeMd = 14.0;

const _kIconSizeMd = 16.0;
const _kIconSizeLg = 18.0;

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
    return merge(
      RemixAccordionStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixAccordionStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixAccordionStyle(
      container: BoxStyler(alignment: alignment, transform: value),
    ));
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

/// Canonical access to default styles
class RemixAccordionStyles {
  /// Default accordion style
  static RemixAccordionStyle get defaultStyle => RemixAccordionStyle(
        container: BoxStyler(
          margin: EdgeInsetsMix(bottom: RemixTokens.spaceMd()),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(
                color: RemixTokens.primary().withValues(alpha: 0.20), // TODO: Should be border token
                width: 1,
              ),
            ),
            borderRadius: BorderRadiusMix.circular(SpaceTokens.radius()),
            color: RemixTokens.onPrimary(), // TODO: Should be surface1 token
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
            color: RemixTokens.primary(), // TODO: Should be fg token
            fontSize: _kFontSizeMd,
          ),
        ),
        header: BoxStyler(padding: EdgeInsetsMix.all(RemixTokens.spaceMd())),
        headerLabel: RemixLabelStyle(
          label: TextStyler(
            style: TextStyleMix(
              color: RemixTokens.primary(), // TODO: Should be fg token
              fontSize: _kFontSizeMd,
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: IconStyler(
            color: RemixTokens.primary().withValues(alpha: 0.60), // TODO: Should be muted token
            size: _kIconSizeLg,
          ),
          flex: FlexStyler(spacing: RemixTokens.spaceSm()),
        ),
      )
          .onHovered(
            RemixAccordionStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: RemixTokens.primary().withValues(alpha: 0.03),
                ),
              ),
            ),
          )
          .onPressed(
            RemixAccordionStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: RemixTokens.primary().withValues(alpha: 0.06),
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
                      color: RemixTokens.primary().withValues(alpha: 0.40),
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
                      color: RemixTokens.primary().withValues(alpha: 0.20),
                      width: 1,
                    ),
                  ),
                ),
              ),
              headerLabel: RemixLabelStyle(
                label: TextStyler(
                  style: TextStyleMix(
                    color: RemixTokens.secondary().withValues(alpha: 0.6),
                  ),
                ),
                icon: IconStyler(
                  color: RemixTokens.secondary().withValues(alpha: 0.6),
                ),
              ),
            ),
          )
          .onSelected(
            RemixAccordionStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: RemixTokens.primary().withValues(alpha: 0.06),
                ),
              ),
            ),
          );
}
