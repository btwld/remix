part of 'accordion.dart';

// Local color constants (not tokens) for maintainability
const _kLightBorder = Color(0xFFE5E7EB); // grey 200
const _kLightHeaderText = Colors.black87;
const _kLightIcon = Colors.black45;
const _kLightSelectedBgAlpha = 0.02;
const _kLightHoverBgAlpha = 0.03;
const _kLightPressedBgAlpha = 0.05;
const _kLightDisabledText = Colors.black54;
const _kLightDisabledIcon = Colors.black38;

const _kDarkBorder = Colors.white60;
const _kDarkIcon = Colors.white70;
const _kDarkSelectedBgAlpha = 0.04;
const _kDarkHoverBgAlpha = 0.06;
const _kDarkPressedBgAlpha = 0.1;
const _kDarkDisabledText = Colors.white60;
const _kDarkDisabledIcon = Colors.white54;

class RemixAccordionStyle extends Style<AccordionSpec>
    with
        StyleModifierMixin<RemixAccordionStyle, AccordionSpec>,
        StyleVariantMixin<RemixAccordionStyle, AccordionSpec> {
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
        $contentText,
        $header,
        $headerLabel,
        $variants,
        $animation,
        $modifier,
      ];
}

RemixAccordionStyle get DefaultRemixAccordionStyle => RemixAccordionStyle(
      container: BoxStyler(
        margin: EdgeInsetsMix(bottom: 12),
        decoration: BoxDecorationMix(
          border: BoxBorderMix.all(
            BorderSideMix(color: _kLightBorder, width: 1),
          ),
          borderRadius: BorderRadiusMix.circular(12),
        ),
      ),
      content: BoxStyler(
        padding: EdgeInsetsMix.fromLTRB(12, 0, 12, 12),
        constraints: BoxConstraintsMix(minWidth: double.infinity),
      ),
      contentText: TextStyler(
        style: TextStyleMix(color: Colors.black87, fontSize: 14),
      ),
      header: BoxStyler(padding: EdgeInsetsMix.all(12)),
      headerLabel: RemixLabelStyle(
        label: TextStyler(
          style: TextStyleMix(
            color: _kLightHeaderText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconStyler(color: _kLightIcon, size: 20),
        trailing: IconStyler(color: _kLightIcon, size: 20),
        flex: FlexStyler(spacing: 8),
      ),
    )
        .onHovered(
          RemixAccordionStyle(
            container: BoxStyler(
              decoration: BoxDecorationMix(
                color: Colors.black.withValues(alpha: _kLightHoverBgAlpha),
              ),
            ),
          ),
        )
        .onPressed(
          RemixAccordionStyle(
            container: BoxStyler(
              decoration: BoxDecorationMix(
                color: Colors.black.withValues(alpha: _kLightPressedBgAlpha),
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
                    color: Colors.black.withValues(alpha: 0.2),
                    width: 1.5,
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
                  BorderSideMix(color: Colors.black26, width: 1),
                ),
              ),
            ),
            headerLabel: RemixLabelStyle(
              label:
                  TextStyler(style: TextStyleMix(color: _kLightDisabledText)),
              leading: IconStyler(color: _kLightDisabledIcon),
              trailing: IconStyler(color: _kLightDisabledIcon),
            ),
          ),
        )
        .onSelected(
          RemixAccordionStyle(
            container: BoxStyler(
              decoration: BoxDecorationMix(
                color: Colors.black.withValues(alpha: _kLightSelectedBgAlpha),
              ),
            ),
          ),
        )
        .onDark(
          RemixAccordionStyle(
            container: BoxStyler(
              decoration: BoxDecorationMix(
                border: BoxBorderMix.all(
                  BorderSideMix(color: _kDarkBorder, width: 1),
                ),
                color: Colors.grey[800],
              ),
            ),
            content: BoxStyler(
              decoration: BoxDecorationMix(
                borderRadius: BorderRadiusMix(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                color: Colors.grey[800],
              ),
            ),
            contentText: TextStyler(
              style: TextStyleMix(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: 14,
              ),
            ),
            headerLabel: RemixLabelStyle(
              label: TextStyler(
                style:
                    TextStyleMix(color: const Color.fromARGB(255, 242, 0, 255)),
              ),
              leading: IconStyler(color: _kDarkIcon),
              trailing: IconStyler(color: _kDarkIcon),
            ),
          )
              .onHovered(
                RemixAccordionStyle(
                  container: BoxStyler(
                    decoration: BoxDecorationMix(
                      color: Colors.white.withValues(alpha: _kDarkHoverBgAlpha),
                    ),
                  ),
                ),
              )
              .onPressed(
                RemixAccordionStyle(
                  container: BoxStyler(
                    decoration: BoxDecorationMix(
                      color:
                          Colors.white.withValues(alpha: _kDarkPressedBgAlpha),
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
                          color: Colors.white.withValues(alpha: 0.5),
                          width: 1.5,
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
                        BorderSideMix(color: Colors.white24, width: 1),
                      ),
                    ),
                  ),
                  headerLabel: RemixLabelStyle(
                    label: TextStyler(
                      style: TextStyleMix(color: _kDarkDisabledText),
                    ),
                    leading: IconStyler(color: _kDarkDisabledIcon),
                    trailing: IconStyler(color: _kDarkDisabledIcon),
                  ),
                ),
              )
              .onSelected(
                RemixAccordionStyle(
                  container: BoxStyler(
                    decoration: BoxDecorationMix(
                      color:
                          Colors.white.withValues(alpha: _kDarkSelectedBgAlpha),
                    ),
                  ),
                ),
              ),
        );

extension AccordionVariants on RemixAccordionStyle {
  /// Default accordion variant (same as DefaultAccordionStyle)
  static RemixAccordionStyle get defaultVariant => RemixAccordionStyle(
        container: BoxStyler(
          margin: EdgeInsetsMix(bottom: 12),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: Colors.black12, width: 1),
            ),
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
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: IconStyler(color: Colors.black45, size: 20),
          trailing: IconStyler(color: Colors.black45, size: 20),
          flex: FlexStyler(spacing: 8),
        ),
      )
          .onSelected(
            RemixAccordionStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: Colors.black.withValues(alpha: 0.02),
                ),
              ),
            ),
          )
          .onDark(
            RemixAccordionStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  border: BoxBorderMix.all(
                    BorderSideMix(color: Colors.white30, width: 1),
                  ),
                ),
              ),
              headerLabel: RemixLabelStyle(
                label: TextStyler(style: TextStyleMix(color: Colors.white)),
                leading: IconStyler(color: Colors.white70),
                trailing: IconStyler(color: Colors.white70),
              ),
            ).onSelected(
              RemixAccordionStyle(
                container: BoxStyler(
                  decoration: BoxDecorationMix(
                    color: Colors.white.withValues(alpha: 0.04),
                  ),
                ),
              ),
            ),
          );

  /// Compact accordion variant with smaller padding
  static RemixAccordionStyle get compact => RemixAccordionStyle(
        container: BoxStyler(
          margin: EdgeInsetsMix(bottom: 8),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: Colors.black12, width: 1),
            ),
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
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: IconStyler(color: Colors.black45, size: 16),
          trailing: IconStyler(color: Colors.black45, size: 16),
          flex: FlexStyler(spacing: 6),
        ),
      )
          .onSelected(
            RemixAccordionStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: Colors.black.withValues(alpha: 0.02),
                ),
              ),
            ),
          )
          .onDark(
            RemixAccordionStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  border: BoxBorderMix.all(
                    BorderSideMix(color: Colors.white30, width: 1),
                  ),
                ),
              ),
              headerLabel: RemixLabelStyle(
                label: TextStyler(style: TextStyleMix(color: Colors.white)),
                leading: IconStyler(color: Colors.white70),
                trailing: IconStyler(color: Colors.white70),
              ),
            ).onSelected(
              RemixAccordionStyle(
                container: BoxStyler(
                  decoration: BoxDecorationMix(
                    color: Colors.white.withValues(alpha: 0.04),
                  ),
                ),
              ),
            ),
          );

  /// Bordered accordion variant with prominent borders
  static RemixAccordionStyle get bordered => RemixAccordionStyle(
        container: BoxStyler(
          margin: EdgeInsetsMix(bottom: 12),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: Colors.black45, width: 2),
            ),
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
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconStyler(color: Colors.black45, size: 20),
          trailing: IconStyler(color: Colors.black45, size: 20),
          flex: FlexStyler(spacing: 10),
        ),
      )
          .onSelected(
            RemixAccordionStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: Colors.black.withValues(alpha: 0.02),
                ),
              ),
            ),
          )
          .onDark(
            RemixAccordionStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  border: BoxBorderMix.all(
                    BorderSideMix(color: Colors.white54, width: 2),
                  ),
                ),
              ),
              headerLabel: RemixLabelStyle(
                label: TextStyler(style: TextStyleMix(color: Colors.white)),
                leading: IconStyler(color: Colors.white70),
                trailing: IconStyler(color: Colors.white70),
              ),
            ).onSelected(
              RemixAccordionStyle(
                container: BoxStyler(
                  decoration: BoxDecorationMix(
                    color: Colors.white.withValues(alpha: 0.04),
                  ),
                ),
              ),
            ),
          );
}
