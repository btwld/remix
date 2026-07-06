part of 'card.dart';

/// Fortal card size presets.
enum FortalCardSize { size1, size2, size3 }

/// Fortal card surface variants.
enum FortalCardVariant { surface, classic, ghost }

/// Creates a Fortal-themed [RemixCardStyle].
@MixWidget()
RemixCardStyle fortalCardStyle({
  FortalCardVariant variant = .surface,
  FortalCardSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalCardSurfaceStyle(size),
    .classic => _fortalCardClassicStyle(size),
    .ghost => _fortalCardGhostStyle(size),
  };
}

RemixCardStyle _fortalCardBaseStyle(FortalCardSize size) {
  return RemixCardStyle().merge(_fortalCardSizeStyle(size));
}

RemixCardStyle _fortalCardSurfaceStyle([FortalCardSize size = .size2]) {
  return _fortalCardBaseStyle(size)
      .borderAll(
        color: FortalTokens.gray6(),
        width: FortalTokens.borderWidth1(),
      )
      .borderRadiusAll(FortalTokens.radius5());
}

RemixCardStyle _fortalCardClassicStyle([FortalCardSize size = .size2]) {
  return _fortalCardBaseStyle(size)
      .backgroundColor(FortalTokens.graySurface())
      .borderAll(
        color: FortalTokens.gray6(),
        width: FortalTokens.borderWidth1(),
      )
      .shadow(
        BoxShadowMix()
            .color(FortalTokens.grayA3())
            .offset(x: 0, y: 2)
            .blurRadius(3)
            .spreadRadius(0),
      )
      .borderRadiusAll(FortalTokens.radius5())
      .merge(RemixCardStyle(container: BoxStyler()));
}

RemixCardStyle _fortalCardGhostStyle([FortalCardSize size = .size2]) {
  return _fortalCardBaseStyle(size).backgroundColor(Colors.transparent);
}

RemixCardStyle _fortalCardSizeStyle(FortalCardSize size) {
  return switch (size) {
    .size1 => RemixCardStyle().paddingAll(FortalTokens.space4()),
    .size2 => RemixCardStyle().paddingAll(FortalTokens.space5()),
    .size3 => RemixCardStyle().paddingAll(FortalTokens.space6()),
  };
}
