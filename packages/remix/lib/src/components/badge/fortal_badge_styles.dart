part of 'badge.dart';

/// Fortal badge size presets.
enum FortalBadgeSize { size1, size2, size3 }

/// Fortal badge color and emphasis variants.
enum FortalBadgeVariant { solid, soft, surface, outline }

/// Creates a Fortal-themed [RemixBadgeStyler].
@MixWidget(name: 'FortalBadge')
RemixBadgeStyler fortalBadgeStyler({
  FortalBadgeVariant variant = .solid,
  FortalBadgeSize size = .size2,
}) {
  return switch (variant) {
    .solid => _fortalBadgeSolidStyler(size),
    .soft => _fortalBadgeSoftStyler(size),
    .surface => _fortalBadgeSurfaceStyler(size),
    .outline => _fortalBadgeOutlineStyler(size),
  };
}

RemixBadgeStyler _fortalBadgeBaseStyler(FortalBadgeSize size) {
  return RemixBadgeStyler().merge(_fortalBadgeSizeStyler(size));
}

RemixBadgeStyler _fortalBadgeSolidStyler([FortalBadgeSize size = .size2]) {
  return _fortalBadgeBaseStyler(size)
      .backgroundColor(FortalTokens.accent9())
      .foregroundColor(FortalTokens.accentContrast());
}

RemixBadgeStyler _fortalBadgeSoftStyler([FortalBadgeSize size = .size2]) {
  return _fortalBadgeBaseStyler(size)
      .backgroundColor(FortalTokens.accentA3())
      .foregroundColor(FortalTokens.accentA10());
}

RemixBadgeStyler _fortalBadgeSurfaceStyler([FortalBadgeSize size = .size2]) {
  return _fortalBadgeBaseStyler(size)
      .backgroundColor(FortalTokens.accentA2())
      .borderAll(
        color: FortalTokens.accent6(),
        width: FortalTokens.borderWidth1(),
      )
      .foregroundColor(FortalTokens.accentA10());
}

RemixBadgeStyler _fortalBadgeOutlineStyler([FortalBadgeSize size = .size2]) {
  return _fortalBadgeBaseStyler(size)
      .backgroundColor(Colors.transparent)
      .borderAll(
        color: FortalTokens.accent7(),
        width: FortalTokens.borderWidth1(),
      )
      .foregroundColor(FortalTokens.accentA10());
}

RemixBadgeStyler _fortalBadgeSizeStyler(FortalBadgeSize size) {
  return switch (size) {
    .size1 => RemixBadgeStyler(
      container: BoxStyler()
          .paddingX(6.0)
          .paddingY(2.0)
          .borderRadiusAll(FortalTokens.radius2()),
      label: TextStyler().fontSize(11.0).height(16.0 / 11.0),
    ),
    .size2 => RemixBadgeStyler(
      container: BoxStyler()
          .paddingX(8.0)
          .paddingY(3.0)
          .borderRadiusAll(FortalTokens.radius3()),
      label: TextStyler().fontSize(12.0).height(18.0 / 12.0),
    ),
    .size3 => RemixBadgeStyler(
      container: BoxStyler()
          .paddingX(10.0)
          .paddingY(4.0)
          .borderRadiusAll(FortalTokens.radius3()),
      label: TextStyler().fontSize(13.0).height(20.0 / 13.0),
    ),
  };
}
