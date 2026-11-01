import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'progress.g.dart';

/// Fortal progress size presets.
enum FortalProgressSize { size1, size2, size3 }

/// Fortal progress color variants.
enum FortalProgressVariant { surface, soft }

/// Fortal-themed preset for [RemixProgress].
@MixWidget(target: RemixProgress.new)
ProgressStyler fortalProgressStyle({
  FortalProgressVariant variant = .surface,
  FortalProgressSize size = .size2,
  bool highContrast = false,
  ProgressStyler style = const ProgressStyler.create(),
}) {
  return (switch (variant) {
    .surface => _fortalProgressSurfaceStyler(size, highContrast: highContrast),
    .soft => _fortalProgressSoftStyler(size, highContrast: highContrast),
  }).merge(style);
}

ProgressStyler _fortalProgressBaseStyler(FortalProgressSize size) {
  final metrics = _fortalProgressMetrics(size);
  return ProgressStyler(
    container: .width(.infinity)
        .height(metrics.height)
        .borderRadius(.all(metrics.radius))
        .clipBehavior(.antiAlias),
    track: .width(.infinity).height(metrics.height),
    indicator: .height(metrics.height).borderRadius(.all(metrics.radius)),
    trackEffects: RemixBoxEffectsMix(
      behindContent: _fortalProgressLayer(),
      overContent: _fortalProgressLayer(),
    ),
    indicatorEffects: RemixBoxEffectsMix(
      behindContent: _fortalProgressLayer(),
      overContent: _fortalProgressLayer(),
    ),
  );
}

// A bare progress bar carries its value in two extents: the whole track
// (the total) and the filled indicator (the value). The track is edged in
// controlBorder, which keeps 3:1 on the page and panels, so the total stays
// readable at 0. The fill keeps 3:1 against those surroundings through its own
// colour or, for the surface variant, an inset outline in accentThumbRing:
// seamless on fills that already contrast, a dark ink on bright fills.

ProgressStyler _fortalProgressSurfaceStyler(
  FortalProgressSize size, {
  required bool highContrast,
}) {
  final styler = _fortalProgressBaseStyler(size)
      .trackColor(FortalTokens.grayA3())
      .trackEffects(
        RemixBoxEffectsMix.overContent(
          _fortalProgressInsetRing(FortalTokens.controlBorder()),
        ),
      )
      .indicatorColor(
        highContrast ? FortalTokens.accent12() : FortalTokens.accentTrack(),
      );
  return highContrast
      ? styler
      : styler.indicatorEffects(
          RemixBoxEffectsMix.overContent(
            _fortalProgressInsetRing(FortalTokens.accentThumbRing()),
          ),
        );
}

ProgressStyler _fortalProgressSoftStyler(
  FortalProgressSize size, {
  required bool highContrast,
}) {
  // Step 8 already keeps 3:1 on the page and panels. No accent alpha is
  // layered over it: alpha steps reconstruct their tint over the page and can
  // be opaque, which would replace the fill.
  return _fortalProgressBaseStyler(size)
      .trackColor(FortalTokens.grayA4())
      .track(
        .foregroundDecoration(BoxDecorationMix(color: FortalTokens.whiteA1())),
      )
      .trackEffects(
        RemixBoxEffectsMix.overContent(
          _fortalProgressInsetRing(FortalTokens.controlBorder()),
        ),
      )
      .indicatorColor(
        highContrast ? FortalTokens.accent12() : FortalTokens.accent8(),
      );
}

({double height, Radius radius}) _fortalProgressMetrics(
  FortalProgressSize size,
) => switch (size) {
  .size1 => (
    height: FortalTokens.space1(),
    radius: FortalTokens.progressRadius1(),
  ),
  .size2 => (
    height: FortalTokens.progressHeight2(),
    radius: FortalTokens.progressRadius2(),
  ),
  .size3 => (
    height: FortalTokens.space2(),
    radius: FortalTokens.progressRadius3(),
  ),
};

/// A 1px inset ring that follows the bar's radius.
RemixBoxEffectLayerMix _fortalProgressInsetRing(Color color) =>
    _fortalProgressLayer(
      shadows: [RemixBoxShadowMix(kind: .inset, color: color, spreadRadius: 1)],
    );

RemixBoxEffectLayerMix _fortalProgressLayer({
  List<RemixBoxShadowMix>? shadows,
  RemixBoxShadowListToken? shadowToken,
}) => RemixBoxEffectLayerMix(shadows: shadows, shadowToken: shadowToken);
