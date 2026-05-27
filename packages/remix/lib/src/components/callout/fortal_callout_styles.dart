part of 'callout.dart';

enum FortalCalloutSize { size1, size2, size3 }

enum FortalCalloutVariant { outline, surface, soft }

RemixCalloutStyle fortalCalloutStyle({
  FortalCalloutVariant variant = .surface,
  FortalCalloutSize size = .size2,
}) {
  return switch (variant) {
    .soft => _fortalCalloutSoftStyle(size),
    .outline => _fortalCalloutOutlineStyle(size),
    .surface => _fortalCalloutSurfaceStyle(size),
  };
}

RemixCalloutStyle _fortalCalloutBaseStyle(FortalCalloutSize size) {
  return RemixCalloutStyle()
      .merge(
        RemixCalloutStyle(
          container: FlexBoxStyler(
            direction: .horizontal,
            crossAxisAlignment: .center,
          ),
        ),
      )
      .merge(_fortalCalloutSizeStyle(size));
}

RemixCalloutStyle _fortalCalloutOutlineStyle([
  FortalCalloutSize size = .size2,
]) {
  return _fortalCalloutBaseStyle(size)
      .backgroundColor(Colors.transparent)
      .borderAll(
        color: FortalTokens.accent7(),
        width: FortalTokens.borderWidth1(),
      )
      .borderRadiusAll(FortalTokens.radius3())
      .textColor(FortalTokens.accent11())
      .iconColor(FortalTokens.accent11());
}

RemixCalloutStyle _fortalCalloutSurfaceStyle([
  FortalCalloutSize size = .size2,
]) {
  return _fortalCalloutBaseStyle(size)
      .backgroundColor(FortalTokens.accentSurface())
      .borderAll(
        color: FortalTokens.accent6(),
        width: FortalTokens.borderWidth1(),
      )
      .borderRadiusAll(FortalTokens.radius3())
      .textColor(FortalTokens.accent11())
      .iconColor(FortalTokens.accent11());
}

RemixCalloutStyle _fortalCalloutSoftStyle([FortalCalloutSize size = .size2]) {
  return _fortalCalloutBaseStyle(size)
      .backgroundColor(FortalTokens.accent3())
      .borderRadiusAll(FortalTokens.radius3())
      .textColor(FortalTokens.accent11())
      .iconColor(FortalTokens.accent11());
}

RemixCalloutStyle _fortalCalloutSizeStyle(FortalCalloutSize size) {
  return switch (size) {
    .size1 => RemixCalloutStyle(
      container: FlexBoxStyler()
          .paddingY(8.0)
          .paddingX(12.0)
          .spacing(FortalTokens.space2()),
      text: TextStyler(style: FortalTokens.text1.mix()),
      icon: IconStyler(size: 16.0),
    ),
    .size2 => RemixCalloutStyle(
      container: FlexBoxStyler()
          .paddingY(12.0)
          .paddingX(16.0)
          .spacing(FortalTokens.space2()),
      text: TextStyler(style: FortalTokens.text2.mix()),
      icon: IconStyler(size: 20.0),
    ),
    .size3 => RemixCalloutStyle(
      container: FlexBoxStyler()
          .paddingY(16.0)
          .paddingX(20.0)
          .spacing(FortalTokens.space3()),
      text: TextStyler(style: FortalTokens.text3.mix()),
      icon: IconStyler(size: 24.0),
    ),
  };
}
