part of 'accordion.dart';

/// Fortal accordion size presets.
enum FortalAccordionSize { size1, size2, size3 }

/// Fortal accordion color variants.
enum FortalAccordionVariant { surface, soft }

/// Fortal-themed preset for [RemixAccordion].
@MixWidget(
  name: 'FortalAccordion',
  target: RemixAccordion.new,
  factoryParameters: .only({'variant', 'size'}),
)
RemixAccordionStyler fortalAccordionStyler({
  FortalAccordionVariant variant = .surface,
  FortalAccordionSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalAccordionSurfaceStyler(size),
    .soft => _fortalAccordionSoftStyler(size),
  };
}

RemixAccordionStyler _fortalAccordionBaseStyler(FortalAccordionSize size) {
  return RemixAccordionStyler()
      .trigger(FlexBoxStyler().direction(.horizontal))
      .title(TextStyler().fontWeight(.w500).color(FortalTokens.gray12()))
      .trailingIcon(IconStyler().color(FortalTokens.gray11()))
      .content(BoxStyler().width(.infinity))
      .merge(_fortalAccordionSizeStyler(size));
}

RemixAccordionStyler _fortalAccordionSurfaceStyler([
  FortalAccordionSize size = .size2,
]) {
  return _fortalAccordionBaseStyler(size)
      .trigger(FlexBoxStyler().color(FortalTokens.gray1()))
      .content(
        BoxStyler()
            .borderTop(
              color: FortalTokens.gray6(),
              width: FortalTokens.borderWidth1(),
            )
            .color(FortalTokens.gray2())
            .wrap(
              .defaultTextStyle(
                style: TextStyleMix().color(FortalTokens.gray12()),
              ),
            ),
      );
}

RemixAccordionStyler _fortalAccordionSoftStyler([
  FortalAccordionSize size = .size2,
]) {
  return _fortalAccordionBaseStyler(size)
      .trigger(FlexBoxStyler().color(FortalTokens.accent2()))
      .title(TextStyler().color(FortalTokens.accent12()))
      .trailingIcon(IconStyler().color(FortalTokens.accent11()))
      .content(
        BoxStyler()
            .borderTop(
              color: FortalTokens.accent6(),
              width: FortalTokens.borderWidth1(),
            )
            .color(FortalTokens.accent2())
            .wrap(
              .defaultTextStyle(
                style: TextStyleMix().color(FortalTokens.accent12()),
              ),
            ),
      );
}

RemixAccordionStyler _fortalAccordionSizeStyler(FortalAccordionSize size) {
  return switch (size) {
    .size1 => RemixAccordionStyler(
      trigger: FlexBoxStyler()
          .paddingX(FortalTokens.space2())
          .paddingY(FortalTokens.space2()),
      title: TextStyler().fontSize(14),
      trailingIcon: IconStyler().size(16),
      content: BoxStyler().paddingAll(FortalTokens.space2()),
    ),
    .size2 => RemixAccordionStyler(
      trigger: FlexBoxStyler()
          .paddingX(FortalTokens.space3())
          .paddingY(FortalTokens.space3()),
      title: TextStyler().fontSize(15),
      trailingIcon: IconStyler().size(20),
      content: BoxStyler().paddingAll(FortalTokens.space3()),
    ),
    .size3 => RemixAccordionStyler(
      trigger: FlexBoxStyler()
          .paddingX(FortalTokens.space4())
          .paddingY(FortalTokens.space4()),
      title: TextStyler().fontSize(16),
      trailingIcon: IconStyler().size(24),
      content: BoxStyler().paddingAll(FortalTokens.space4()),
    ),
  };
}

/// Fortal-themed preset for [RemixAccordion].
