part of 'callout.dart';

/// Fortal callout size presets.
enum FortalCalloutSize { size1, size2, size3 }

/// Fortal callout color and emphasis variants.
enum FortalCalloutVariant { outline, surface, soft }

/// Creates a Fortal-themed [RemixCalloutStyler].
@MixWidget(name: 'FortalCallout')
RemixCalloutStyler fortalCalloutStyler({
  FortalCalloutVariant variant = .surface,
  FortalCalloutSize size = .size2,
}) {
  return switch (variant) {
    .soft => _fortalCalloutSoftStyler(size),
    .outline => _fortalCalloutOutlineStyler(size),
    .surface => _fortalCalloutSurfaceStyler(size),
  };
}

RemixCalloutStyler _fortalCalloutBaseStyler(FortalCalloutSize size) {
  return RemixCalloutStyler()
      .merge(
        RemixCalloutStyler(
          container: FlexBoxStyler(
            direction: .horizontal,
            crossAxisAlignment: .center,
          ),
        ),
      )
      .merge(_fortalCalloutSizeStyler(size));
}

RemixCalloutStyler _fortalCalloutOutlineStyler([
  FortalCalloutSize size = .size2,
]) {
  return _fortalCalloutBaseStyler(size)
      .backgroundColor(Colors.transparent)
      .borderAll(
        color: FortalTokens.accent7(),
        width: FortalTokens.borderWidth1(),
      )
      .borderRadiusAll(FortalTokens.radius3())
      .foregroundColor(FortalTokens.accent11());
}

RemixCalloutStyler _fortalCalloutSurfaceStyler([
  FortalCalloutSize size = .size2,
]) {
  return _fortalCalloutBaseStyler(size)
      .backgroundColor(FortalTokens.accentSurface())
      .borderAll(
        color: FortalTokens.accent6(),
        width: FortalTokens.borderWidth1(),
      )
      .borderRadiusAll(FortalTokens.radius3())
      .foregroundColor(FortalTokens.accent11());
}

RemixCalloutStyler _fortalCalloutSoftStyler([FortalCalloutSize size = .size2]) {
  return _fortalCalloutBaseStyler(size)
      .backgroundColor(FortalTokens.accent3())
      .borderRadiusAll(FortalTokens.radius3())
      .foregroundColor(FortalTokens.accent11());
}

RemixCalloutStyler _fortalCalloutSizeStyler(FortalCalloutSize size) {
  return switch (size) {
    .size1 => RemixCalloutStyler(
      container: FlexBoxStyler()
          .paddingY(8.0)
          .paddingX(12.0)
          .spacing(FortalTokens.space2()),
      text: TextStyler(style: FortalTokens.text1.mix()),
      icon: IconStyler(size: 16.0),
    ),
    .size2 => RemixCalloutStyler(
      container: FlexBoxStyler()
          .paddingY(12.0)
          .paddingX(16.0)
          .spacing(FortalTokens.space2()),
      text: TextStyler(style: FortalTokens.text2.mix()),
      icon: IconStyler(size: 20.0),
    ),
    .size3 => RemixCalloutStyler(
      container: FlexBoxStyler()
          .paddingY(16.0)
          .paddingX(20.0)
          .spacing(FortalTokens.space3()),
      text: TextStyler(style: FortalTokens.text3.mix()),
      icon: IconStyler(size: 24.0),
    ),
  };
}
