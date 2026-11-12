import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'switch.g.dart';

/// The sizes a switch comes in. Pixel values are at 100% theme scaling.
enum UiSwitchSize {
  /// A 28px by 16px track.
  size1,

  /// A 36px by 20px track. The default.
  size2,

  /// A 44px by 24px track.
  size3,
}

/// The looks a switch comes in.
enum UiSwitchVariant {
  /// A neutral track with a 1px frame, filled with the accent when on.
  surface,

  /// A neutral tint, accent-tinted when on. The 1px frame shows only while off
  /// and enabled.
  soft,
}

/// The Ui Switch recipe.
///
/// It reads top to bottom: the track, thumb and focus ring, then the variant's
/// colors for on, pressed and disabled, then the touch target.
///
/// [highContrast] moves the on state to accent step 12.
@MixWidget(target: RemixSwitch.new)
SwitchStyler uiSwitchStyle({
  UiSwitchVariant variant = .surface,
  UiSwitchSize size = .size2,
  bool highContrast = false,
  SwitchStyler style = const SwitchStyler.create(),
}) => _track(size)
    .merge(switch (variant) {
      .surface => _surface(highContrast),
      .soft => _soft(highContrast),
    })
    .wrap(uiTouchTarget())
    .merge(style);

/// The track and thumb sizes of each step, and the off look both variants
/// start from: a gray track with a 1px frame, a white thumb, and a focus ring.
///
/// The empty effect layers give the variant's state fragments layers to
/// replace.
SwitchStyler _track(UiSwitchSize size) {
  final (:width, :height, :thumb, :radius) = switch (size) {
    .size1 => (
      width: UiTokens.switchWidth1(),
      height: UiTokens.space4(),
      thumb: UiTokens.switchThumbSize1(),
      radius: UiTokens.radius1OrThumb(),
    ),
    .size2 => (
      width: UiTokens.switchWidth2(),
      height: UiTokens.switchHeight2(),
      thumb: UiTokens.switchThumbSize2(),
      radius: UiTokens.radius2OrThumb(),
    ),
    .size3 => (
      width: UiTokens.switchWidth3(),
      height: UiTokens.space5(),
      thumb: UiTokens.switchThumbSize3(),
      radius: UiTokens.radius2OrThumb(),
    ),
  };

  return SwitchStyler(
        container: .size(
          width,
          height,
        ).padding(.all(1)).borderRadius(.all(radius)),
        thumb: .size(thumb, thumb).borderRadius(.all(radius)),
        trackEffects: RemixBoxEffectsMix(
          behindContent: RemixBoxEffectLayerMix(),
          overContent: RemixBoxEffectLayerMix(),
        ),
      )
      .thumbColor(const Color(0xFFFFFFFF))
      .onFocusVisible(.trackEffects(uiFocusOutline()))
      .trackColor(UiTokens.grayA3())
      .merge(_trackRing(UiTokens.controlBorder()))
      // The off thumb is a light surface; its neutral ring separates it from
      // the off track in light mode, where white alone is too close to it.
      .thumb(
        BoxStyler()
            .color(const Color(0xFFFFFFFF))
            .border(
              .all(
                .color(UiTokens.controlBorder()).width(UiTokens.borderWidth1()),
              ),
            ),
      );
}

/// The accent track when on, and the gray press fill when off.
SwitchStyler _surface(bool highContrast) => SwitchStyler()
    .onSelected(
      SwitchStyler()
          .trackColor(
            highContrast ? UiTokens.accent12() : UiTokens.accentTrack(),
          )
          .merge(_trackRing(UiTokens.grayA5()))
          .thumb(_surfaceOnThumb(highContrast)),
    )
    .merge(
      _pressed(
        on: highContrast ? UiTokens.accent12() : UiTokens.accentMarkHover(),
      ),
    )
    .onDisabled(_disabled(track: UiTokens.grayA3(), ring: UiTokens.grayA5()));

/// An accent-tinted track when on, with an accent-colored thumb.
SwitchStyler _soft(bool highContrast) => SwitchStyler()
    .onSelected(
      SwitchStyler()
          .trackColor(highContrast ? UiTokens.accentA6() : UiTokens.accentA4())
          .merge(_trackRing(null))
          .thumb(_softOnThumb(highContrast)),
    )
    .merge(
      _pressed(on: highContrast ? UiTokens.accentA7() : UiTokens.accentA5()),
    )
    .onDisabled(_disabled(track: UiTokens.grayA4()));

/// The selected surface thumb stays a light surface rather than a disc of ink.
/// Its 2px [UiTokens.accentThumbRing] follows the track wherever white
/// already stands out on it, and carries the contrast on bright tracks. High
/// contrast keeps its deliberate step-1 knockout thumb.
BoxStyler _surfaceOnThumb(bool highContrast) => highContrast
    ? BoxStyler()
          .color(UiTokens.accent1())
          .border(.all(.color(UiTokens.gray7()).width(UiTokens.borderWidth1())))
    : BoxStyler()
          .color(const Color(0xFFFFFFFF))
          .border(
            .all(
              .color(UiTokens.accentThumbRing()).width(UiTokens.borderWidth2()),
            ),
          );

/// Soft thumbs keep their accent content role on the tinted track.
BoxStyler _softOnThumb(bool highContrast) => BoxStyler()
    .color(highContrast ? UiTokens.accent12() : UiTokens.accentContent())
    .border(.all(.color(UiTokens.gray7()).width(UiTokens.borderWidth1())));

/// A gray press fill, or [on] while the switch is on.
SwitchStyler _pressed({required Color on}) => SwitchStyler().onPressed(
  SwitchStyler()
      .trackColor(UiTokens.grayA4())
      .onSelected(SwitchStyler().trackColor(on))
      .trackEffects(RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix())),
);

/// Disabled switches stay muted: the active off-track boundary is replaced by
/// a quiet [ring] (surface) or removed (soft), whatever the selection, focus or
/// press state.
SwitchStyler _disabled({required Color track, Color? ring}) => SwitchStyler()
    .trackColor(track)
    .trackEffects(RemixBoxEffectsMix.overContent(_ringLayer(ring)))
    .thumbColor(UiTokens.gray2())
    .thumb(
      .border(.all(.color(UiTokens.gray6()).width(UiTokens.borderWidth1()))),
    )
    .trackEffects(RemixBoxEffectsMix(outline: BorderSideMix(style: .none)));

/// Empties the layer behind the track and sets a 1px inset [ring] over it, or
/// none when [ring] is null.
SwitchStyler _trackRing(Color? ring) => SwitchStyler()
    .trackEffects(RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()))
    .trackEffects(RemixBoxEffectsMix.overContent(_ringLayer(ring)));

/// A 1px inset ring, or no shadow when [color] is null.
RemixBoxEffectLayerMix _ringLayer(Color? color) => RemixBoxEffectLayerMix(
  shadows: [
    if (color != null)
      RemixBoxShadowMix(
        kind: .inset,
        color: color,
        spreadRadius: UiTokens.borderWidth1(),
      ),
  ],
);
