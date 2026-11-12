import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'switch.g.dart';

/// The sizes a switch comes in. Pixel values are at 100% theme scaling.
enum FortalSwitchSize {
  /// A 28px by 16px track.
  size1,

  /// A 36px by 20px track. The default.
  size2,

  /// A 44px by 24px track.
  size3,
}

/// The looks a switch comes in.
enum FortalSwitchVariant {
  /// A neutral track with a 1px frame, filled with the accent when on.
  surface,

  /// A neutral tint, accent-tinted when on, with no frame.
  soft,
}

/// The Fortal Switch recipe.
///
/// It reads top to bottom: the track, thumb and focus ring, then the variant's
/// colors for on, pressed and disabled, then the touch target.
///
/// [highContrast] moves the on state to accent step 12.
@MixWidget(target: RemixSwitch.new)
SwitchStyler fortalSwitchStyle({
  FortalSwitchVariant variant = .surface,
  FortalSwitchSize size = .size2,
  bool highContrast = false,
  SwitchStyler style = const SwitchStyler.create(),
}) => _track(size)
    .merge(switch (variant) {
      .surface => _surface(highContrast),
      .soft => _soft(highContrast),
    })
    .wrap(fortalTouchTarget())
    .merge(style);

/// The track and thumb sizes of each step, and the off look both variants
/// start from: a gray track, a white thumb, and a focus ring.
///
/// The empty effect layers give the variant's state fragments layers to
/// replace.
SwitchStyler _track(FortalSwitchSize size) {
  final (:width, :height, :thumb, :radius) = switch (size) {
    .size1 => (
      width: FortalTokens.switchWidth1(),
      height: FortalTokens.space4(),
      thumb: FortalTokens.switchThumbSize1(),
      radius: FortalTokens.radius1OrThumb(),
    ),
    .size2 => (
      width: FortalTokens.switchWidth2(),
      height: FortalTokens.switchHeight2(),
      thumb: FortalTokens.switchThumbSize2(),
      radius: FortalTokens.radius2OrThumb(),
    ),
    .size3 => (
      width: FortalTokens.switchWidth3(),
      height: FortalTokens.space5(),
      thumb: FortalTokens.switchThumbSize3(),
      radius: FortalTokens.radius2OrThumb(),
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
      .onFocusVisible(.trackEffects(fortalFocusOutline()))
      .trackColor(FortalTokens.grayA3())
      .merge(_trackRing(FortalTokens.controlBorder()))
      // The off thumb is a light surface; its neutral ring separates it from
      // the off track in light mode, where white alone is too close to it.
      .thumb(
        BoxStyler()
            .color(const Color(0xFFFFFFFF))
            .border(
              .all(
                .color(
                  FortalTokens.controlBorder(),
                ).width(FortalTokens.borderWidth1()),
              ),
            ),
      );
}

/// The accent track when on, and the gray press fill when off.
SwitchStyler _surface(bool highContrast) => SwitchStyler()
    .onSelected(
      SwitchStyler()
          .trackColor(
            highContrast ? FortalTokens.accent12() : FortalTokens.accentTrack(),
          )
          .merge(_trackRing(FortalTokens.grayA5()))
          .thumb(_surfaceOnThumb(highContrast)),
    )
    .merge(
      _pressed(
        on: highContrast
            ? FortalTokens.accent12()
            : FortalTokens.accentMarkHover(),
      ),
    )
    .onDisabled(
      _disabled(track: FortalTokens.grayA3(), ring: FortalTokens.grayA5()),
    );

/// An accent-tinted track when on, with an accent-colored thumb.
SwitchStyler _soft(bool highContrast) => SwitchStyler()
    .onSelected(
      SwitchStyler()
          .trackColor(
            highContrast ? FortalTokens.accentA6() : FortalTokens.accentA4(),
          )
          .merge(_trackRing(null))
          .thumb(_softOnThumb(highContrast)),
    )
    .merge(
      _pressed(
        on: highContrast ? FortalTokens.accentA7() : FortalTokens.accentA5(),
      ),
    )
    .onDisabled(_disabled(track: FortalTokens.grayA4()));

/// The selected surface thumb stays a light surface rather than a disc of ink.
/// Its 2px [FortalTokens.accentThumbRing] follows the track wherever white
/// already stands out on it, and carries the contrast on bright tracks. High
/// contrast keeps its deliberate step-1 knockout thumb.
BoxStyler _surfaceOnThumb(bool highContrast) => highContrast
    ? BoxStyler()
          .color(FortalTokens.accent1())
          .border(
            .all(
              .color(FortalTokens.gray7()).width(FortalTokens.borderWidth1()),
            ),
          )
    : BoxStyler()
          .color(const Color(0xFFFFFFFF))
          .border(
            .all(
              .color(
                FortalTokens.accentThumbRing(),
              ).width(FortalTokens.borderWidth2()),
            ),
          );

/// Soft thumbs keep their accent content role on the tinted track.
BoxStyler _softOnThumb(bool highContrast) => BoxStyler()
    .color(
      highContrast ? FortalTokens.accent12() : FortalTokens.accentContent(),
    )
    .border(
      .all(.color(FortalTokens.gray7()).width(FortalTokens.borderWidth1())),
    );

/// A gray press fill, or [on] while the switch is on.
SwitchStyler _pressed({required Color on}) => SwitchStyler().onPressed(
  SwitchStyler()
      .trackColor(FortalTokens.grayA4())
      .onSelected(SwitchStyler().trackColor(on))
      .trackEffects(RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix())),
);

/// Disabled switches stay muted: the active off-track boundary is replaced by
/// a quiet [ring] (surface) or removed (soft), whatever the selection, focus or
/// press state.
SwitchStyler _disabled({required Color track, Color? ring}) => SwitchStyler()
    .trackColor(track)
    .trackEffects(RemixBoxEffectsMix.overContent(_ringLayer(ring)))
    .thumbColor(FortalTokens.gray2())
    .thumb(
      .border(
        .all(.color(FortalTokens.gray6()).width(FortalTokens.borderWidth1())),
      ),
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
        spreadRadius: FortalTokens.borderWidth1(),
      ),
  ],
);
