part of 'card.dart';

/// Fortal card size presets.
enum FortalCardSize { size1, size2, size3 }

/// Fortal card surface variants.
enum FortalCardVariant { surface, classic, ghost }

/// Fortal-themed preset for [RemixCard].
@MixWidget(name: 'FortalCard')
RemixCardStyler fortalCardStyler({
  FortalCardVariant variant = .surface,
  FortalCardSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalCardSurfaceStyler(size),
    .classic => _fortalCardClassicStyler(size),
    .ghost => _fortalCardGhostStyler(size),
  };
}

RemixCardStyler _fortalCardBaseStyler(FortalCardSize size) {
  return RemixCardStyler().merge(_fortalCardSizeStyler(size));
}

RemixCardStyler _fortalCardSurfaceStyler([FortalCardSize size = .size2]) {
  return _fortalCardBaseStyler(size)
      .borderAll(
        color: FortalTokens.gray6(),
        width: FortalTokens.borderWidth1(),
      )
      .borderRadiusAll(FortalTokens.radius5());
}

RemixCardStyler _fortalCardClassicStyler([FortalCardSize size = .size2]) {
  return _fortalCardBaseStyler(size)
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
      .merge(RemixCardStyler(container: BoxStyler()));
}

RemixCardStyler _fortalCardGhostStyler([FortalCardSize size = .size2]) {
  return _fortalCardBaseStyler(size).backgroundColor(Colors.transparent);
}

RemixCardStyler _fortalCardSizeStyler(FortalCardSize size) {
  return switch (size) {
    .size1 => RemixCardStyler().paddingAll(FortalTokens.space4()),
    .size2 => RemixCardStyler().paddingAll(FortalTokens.space5()),
    .size3 => RemixCardStyler().paddingAll(FortalTokens.space6()),
  };
}
