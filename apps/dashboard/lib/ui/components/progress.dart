import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'progress.g.dart';

/// Ui progress size presets.
enum UiProgressSize { size1, size2, size3 }

/// Ui progress color variants.
enum UiProgressVariant { surface, soft }

/// Ui-themed preset for [RemixProgress].
@MixWidget(target: RemixProgress.new)
ProgressStyler uiProgressStyle({
  UiProgressVariant variant = .surface,
  UiProgressSize size = .size2,
  bool highContrast = false,
  ProgressStyler style = const ProgressStyler.create(),
}) {
  return (switch (variant) {
    .surface => _uiProgressSurfaceStyler(size, highContrast: highContrast),
    .soft => _uiProgressSoftStyler(size, highContrast: highContrast),
  }).merge(style);
}

ProgressStyler _uiProgressBaseStyler(UiProgressSize size) {
  final metrics = _uiProgressMetrics(size);
  return ProgressStyler(
    container: .width(.infinity)
        .height(metrics.height)
        .borderRadius(.all(metrics.radius))
        .clipBehavior(.antiAlias),
    track: .width(.infinity).height(metrics.height),
    indicator: .height(metrics.height).borderRadius(.all(metrics.radius)),
    trackEffects: RemixBoxEffectsMix(
      behindContent: _uiProgressLayer(),
      overContent: _uiProgressLayer(),
    ),
    indicatorEffects: RemixBoxEffectsMix(
      behindContent: _uiProgressLayer(),
      overContent: _uiProgressLayer(),
    ),
  );
}

// A bare progress bar carries its value in two extents: the whole track
// (the total) and the filled indicator (the value). The track is edged in
// controlBorder, which keeps 3:1 on the page and panels, so the total stays
// readable at 0. The fill keeps 3:1 against those surroundings through its own
// colour or, for the surface variant, an inset outline in accentThumbRing:
// seamless on fills that already contrast, a dark ink on bright fills.

ProgressStyler _uiProgressSurfaceStyler(
  UiProgressSize size, {
  required bool highContrast,
}) {
  final styler = _uiProgressBaseStyler(size)
      .trackColor(UiTokens.grayA3())
      .trackEffects(
        RemixBoxEffectsMix.overContent(
          _uiProgressInsetRing(UiTokens.controlBorder()),
        ),
      )
      .indicatorColor(
        highContrast ? UiTokens.accent12() : UiTokens.accentTrack(),
      );
  return highContrast
      ? styler
      : styler.indicatorEffects(
          RemixBoxEffectsMix.overContent(
            _uiProgressInsetRing(UiTokens.accentThumbRing()),
          ),
        );
}

ProgressStyler _uiProgressSoftStyler(
  UiProgressSize size, {
  required bool highContrast,
}) {
  // Step 8 already keeps 3:1 on the page and panels. No accent alpha is
  // layered over it: alpha steps reconstruct their tint over the page and can
  // be opaque, which would replace the fill.
  return _uiProgressBaseStyler(size)
      .trackColor(UiTokens.grayA4())
      .track(.foregroundDecoration(BoxDecorationMix(color: UiTokens.whiteA1())))
      .trackEffects(
        RemixBoxEffectsMix.overContent(
          _uiProgressInsetRing(UiTokens.controlBorder()),
        ),
      )
      .indicatorColor(highContrast ? UiTokens.accent12() : UiTokens.accent8());
}

({double height, Radius radius}) _uiProgressMetrics(UiProgressSize size) =>
    switch (size) {
      .size1 => (height: UiTokens.space1(), radius: UiTokens.progressRadius1()),
      .size2 => (
        height: UiTokens.progressHeight2(),
        radius: UiTokens.progressRadius2(),
      ),
      .size3 => (height: UiTokens.space2(), radius: UiTokens.progressRadius3()),
    };

/// A 1px inset ring that follows the bar's radius.
RemixBoxEffectLayerMix _uiProgressInsetRing(Color color) => _uiProgressLayer(
  shadows: [RemixBoxShadowMix(kind: .inset, color: color, spreadRadius: 1)],
);

RemixBoxEffectLayerMix _uiProgressLayer({
  List<RemixBoxShadowMix>? shadows,
  RemixBoxShadowListToken? shadowToken,
}) => RemixBoxEffectLayerMix(shadows: shadows, shadowToken: shadowToken);
