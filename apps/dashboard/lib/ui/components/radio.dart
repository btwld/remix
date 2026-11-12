import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'radio.g.dart';

/// The sizes a radio comes in. Pixel values are at 100% theme scaling.
enum UiRadioSize {
  /// A 14px circle with a 5.6px dot.
  size1,

  /// A 16px circle with a 6.4px dot. The default.
  size2,

  /// A 20px circle with an 8px dot.
  size3,
}

/// The looks a radio comes in.
enum UiRadioVariant {
  /// A surface fill inside a 1px neutral frame, filled with the accent when
  /// selected.
  surface,

  /// An accent tint inside a 1px accent ring, with an accent-colored dot.
  soft,
}

/// The Ui Radio recipe.
///
/// It reads top to bottom: the circle and its focus ring, then the variant's
/// colors for rest, selected and disabled, then the touch target.
///
/// [highContrast] moves the selected fill (surface) or dot (soft) to accent
/// step 12.
@MixWidget(target: RemixRadio.new)
RadioStyler uiRadioStyle({
  UiRadioVariant variant = .surface,
  UiRadioSize size = .size2,
  bool highContrast = false,
  RadioStyler style = const RadioStyler.create(),
}) => _circle(size)
    .merge(switch (variant) {
      .surface => _surface(highContrast),
      .soft => _soft(highContrast),
    })
    .wrap(uiTouchTarget())
    .onDisabled(.containerEffects(.outline(.style(.none))))
    .merge(style);

/// The circle and dot sizes of each step, with the focus ring and no effects.
///
/// The empty effect layers give the variant's state fragments layers to
/// replace.
RadioStyler _circle(UiRadioSize size) {
  final (:circle, :dot) = switch (size) {
    .size1 => (
      circle: UiTokens.checkboxSize1(),
      dot: UiTokens.radioIndicatorSize1(),
    ),
    .size2 => (circle: UiTokens.space4(), dot: UiTokens.radioIndicatorSize2()),
    .size3 => (circle: UiTokens.checkboxSize3(), dot: UiTokens.space2()),
  };

  return RadioStyler(
    container: .size(
      circle,
      circle,
    ).alignment(.center).borderRadius(.all(UiTokens.radiusCircle())),
    indicator: .size(dot, dot).borderRadius(.all(UiTokens.radiusCircle())),
    containerEffects: RemixBoxEffectsMix(
      behindContent: RemixBoxEffectLayerMix(),
      overContent: RemixBoxEffectLayerMix(),
    ),
  ).onFocusVisible(.containerEffects(uiFocusOutline()));
}

/// A surface fill with a neutral frame; the accent fill when selected.
RadioStyler _surface(bool highContrast) => RadioStyler()
    .color(UiTokens.colorSurface())
    .merge(_effects(over: uiInsetSurface(strokes: [UiTokens.controlBorder()])))
    .indicatorColor(UiTokens.accentIndicator())
    .onSelected(
      RadioStyler()
          .color(
            highContrast ? UiTokens.accent12() : UiTokens.accentIndicator(),
          )
          .merge(_effects(over: RemixBoxEffectLayerMix(shadows: const [])))
          .indicatorColor(
            highContrast
                ? UiTokens.accent1()
                : UiTokens.accentIndicatorContrast(),
          ),
    )
    .onDisabled(_disabled(frame: UiTokens.grayA6()));

/// An accent tint with an accent ring and an accent dot.
RadioStyler _soft(bool highContrast) {
  final dot = highContrast ? UiTokens.accent12() : UiTokens.accentContent();

  return RadioStyler()
      .color(UiTokens.accentA4())
      // The tint alone is too faint to show an empty control; the accent-8
      // ring keeps a 3:1 boundary in every enabled state.
      .merge(_effects(over: uiInsetSurface(strokes: [UiTokens.focus8()])))
      .indicatorColor(dot)
      .onSelected(
        RadioStyler()
            .color(UiTokens.accentA4())
            .containerEffects(
              RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
            )
            .indicatorColor(dot),
      )
      .onDisabled(_disabled());
}

/// A gray fill and dot. The surface variant keeps a [frame]; soft has none.
RadioStyler _disabled({Color? frame}) => RadioStyler()
    .color(UiTokens.grayA3())
    .merge(
      _effects(
        over: frame == null
            ? RemixBoxEffectLayerMix(shadows: const [])
            : uiInsetSurface(strokes: [frame]),
      ),
    )
    .indicatorColor(UiTokens.grayA8());

/// Sets the layer over the content and empties the one behind it.
RadioStyler _effects({required RemixBoxEffectLayerMix over}) => RadioStyler()
    .containerEffects(
      RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
    )
    .containerEffects(RemixBoxEffectsMix.overContent(over));
