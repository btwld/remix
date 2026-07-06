part of 'accordion.dart';

/// Fortal accordion size presets.
enum FortalAccordionSize { size1, size2, size3 }

/// Fortal accordion color variants.
enum FortalAccordionVariant { surface, soft }

/// Creates a Fortal-themed [RemixAccordionStyle].
RemixAccordionStyle fortalAccordionStyle({
  FortalAccordionVariant variant = .surface,
  FortalAccordionSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalAccordionSurfaceStyle(size),
    .soft => _fortalAccordionSoftStyle(size),
  };
}

RemixAccordionStyle _fortalAccordionBaseStyle(FortalAccordionSize size) {
  return RemixAccordionStyle()
      .trigger(FlexBoxStyler().direction(.horizontal))
      .title(
        TextStyler().fontWeight(FontWeight.w500).color(FortalTokens.gray12()),
      )
      .trailingIcon(IconStyler().color(FortalTokens.gray11()))
      .content(BoxStyler().width(double.infinity))
      .merge(_fortalAccordionSizeStyle(size));
}

RemixAccordionStyle _fortalAccordionSurfaceStyle([
  FortalAccordionSize size = .size2,
]) {
  return _fortalAccordionBaseStyle(size)
      .trigger(FlexBoxStyler().color(FortalTokens.gray1()))
      .content(
        BoxStyler()
            .borderTop(
              color: FortalTokens.gray6(),
              width: FortalTokens.borderWidth1(),
            )
            .color(FortalTokens.gray2()),
      );
}

RemixAccordionStyle _fortalAccordionSoftStyle([
  FortalAccordionSize size = .size2,
]) {
  return _fortalAccordionBaseStyle(size)
      .trigger(FlexBoxStyler().color(FortalTokens.accent2()))
      .title(TextStyler().color(FortalTokens.accent12()))
      .trailingIcon(IconStyler().color(FortalTokens.accent11()))
      .content(
        BoxStyler()
            .borderTop(
              color: FortalTokens.accent6(),
              width: FortalTokens.borderWidth1(),
            )
            .color(FortalTokens.accent2()),
      );
}

RemixAccordionStyle _fortalAccordionSizeStyle(FortalAccordionSize size) {
  return switch (size) {
    .size1 => RemixAccordionStyle(
      trigger: FlexBoxStyler()
          .paddingX(FortalTokens.space2())
          .paddingY(FortalTokens.space2()),
      title: TextStyler().fontSize(14),
      trailingIcon: IconStyler().size(16),
      content: BoxStyler().paddingAll(FortalTokens.space2()),
    ),
    .size2 => RemixAccordionStyle(
      trigger: FlexBoxStyler()
          .paddingX(FortalTokens.space3())
          .paddingY(FortalTokens.space3()),
      title: TextStyler().fontSize(15),
      trailingIcon: IconStyler().size(20),
      content: BoxStyler().paddingAll(FortalTokens.space3()),
    ),
    .size3 => RemixAccordionStyle(
      trigger: FlexBoxStyler()
          .paddingX(FortalTokens.space4())
          .paddingY(FortalTokens.space4()),
      title: TextStyler().fontSize(16),
      trailingIcon: IconStyler().size(24),
      content: BoxStyler().paddingAll(FortalTokens.space4()),
    ),
  };
}
