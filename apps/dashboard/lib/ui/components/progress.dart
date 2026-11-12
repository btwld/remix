import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'progress.g.dart';

/// The sizes a progress bar comes in. Pixel values are at 100% theme scaling.
enum UiProgressSize {
  /// 4px tall.
  size1,

  /// 6px tall. The default.
  size2,

  /// 8px tall.
  size3,
}

/// The looks a progress bar comes in.
enum UiProgressVariant {
  /// A gray track with a 1px frame, and a solid accent fill.
  surface,

  /// A gray track with a 1px frame, and a softer accent fill.
  soft,
}

/// The Ui Progress recipe.
///
/// It reads top to bottom: the size, then the variant's track and fill.
///
/// A bare progress bar carries its value in two extents: the whole track (the
/// total) and the filled indicator (the value). The track is edged in
/// controlBorder, which keeps 3:1 on the page and panels, so the total stays
/// readable at 0. The fill keeps 3:1 against those surroundings through its
/// own color or, for the surface variant, an inset outline in accentThumbRing:
/// seamless on fills that already contrast, a dark ink on bright fills.
///
/// [highContrast] moves the fill to accent step 12.
@MixWidget(target: RemixProgress.new)
ProgressStyler uiProgressStyle({
  UiProgressVariant variant = .surface,
  UiProgressSize size = .size2,
  bool highContrast = false,
  ProgressStyler style = const ProgressStyler.create(),
}) => _bar(size)
    .merge(switch (variant) {
      .surface => _surface(highContrast),
      .soft => _soft(highContrast),
    })
    .merge(style);

/// The height and corners of each step, with empty effect layers for the
/// variant to fill in.
ProgressStyler _bar(UiProgressSize size) {
  final (:height, :radius) = switch (size) {
    .size1 => (height: UiTokens.space1(), radius: UiTokens.progressRadius1()),
    .size2 => (
      height: UiTokens.progressHeight2(),
      radius: UiTokens.progressRadius2(),
    ),
    .size3 => (height: UiTokens.space2(), radius: UiTokens.progressRadius3()),
  };

  return ProgressStyler(
    container: .width(
      .infinity,
    ).height(height).borderRadius(.all(radius)).clipBehavior(.antiAlias),
    track: .width(.infinity).height(height),
    indicator: .height(height).borderRadius(.all(radius)),
    trackEffects: RemixBoxEffectsMix(
      behindContent: RemixBoxEffectLayerMix(),
      overContent: RemixBoxEffectLayerMix(),
    ),
    indicatorEffects: RemixBoxEffectsMix(
      behindContent: RemixBoxEffectLayerMix(),
      overContent: RemixBoxEffectLayerMix(),
    ),
  );
}

ProgressStyler _surface(bool highContrast) {
  final progress = ProgressStyler()
      .trackColor(UiTokens.grayA3())
      .trackEffects(.overContent(_insetRing(UiTokens.controlBorder())))
      .indicatorColor(
        highContrast ? UiTokens.accent12() : UiTokens.accentTrack(),
      );

  return progress.merge(
    highContrast
        ? null
        : ProgressStyler().indicatorEffects(
            .overContent(_insetRing(UiTokens.accentThumbRing())),
          ),
  );
}

// Step 8 already keeps 3:1 on the page and panels. No accent alpha is layered
// over it: alpha steps reconstruct their tint over the page and can be opaque,
// which would replace the fill.
ProgressStyler _soft(bool highContrast) => ProgressStyler()
    .trackColor(UiTokens.grayA4())
    .track(.foregroundDecoration(BoxDecorationMix(color: UiTokens.whiteA1())))
    .trackEffects(.overContent(_insetRing(UiTokens.controlBorder())))
    .indicatorColor(highContrast ? UiTokens.accent12() : UiTokens.focus8());

/// A 1px inset ring that follows the bar's radius.
RemixBoxEffectLayerMix _insetRing(Color color) => RemixBoxEffectLayerMix(
  shadows: [
    RemixBoxShadowMix(
      kind: .inset,
      color: color,
      spreadRadius: UiTokens.borderWidth1(),
    ),
  ],
);
