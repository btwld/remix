import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../motion/motion.dart';
import '../theme/theme.dart';

part 'switch.g.dart';

/// The sizes a switch comes in. Pixel values are at 100% theme scaling.
enum UiSwitchSize {
  /// A 34px by 20px track with a 14px thumb.
  size1,

  /// A 42px by 24px track with an 18px thumb. The default.
  size2,

  /// A 46px by 26px track with a 20px thumb.
  size3,
}

/// The looks a switch comes in.
enum UiSwitchVariant {
  /// A neutral track that darkens on hover and fills with the control ink
  /// when on, under a shadowed light thumb.
  surface,

  /// The surface track while off; on, a 10% control-ink tint with a
  /// control-ink thumb.
  soft,
}

/// The Fortal Switch recipe.
///
/// It reads top to bottom: the pill track and its shadowed thumb, then the
/// variant's on colours, then the press stretch, disabled and the focus ring.
/// The thumb glides on the smooth spring and stretches 5px while held, its
/// near edge staying put.
///
/// [highContrast] moves the on track to accent step 12.
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
    .animate(
      AnimationConfig.curve(
        duration: UiSpringCurve.smooth.duration,
        curve: UiSpringCurve.smooth,
      ),
    )
    .wrap(uiTouchTarget())
    // A square ring around the 40px-tall touch target, as the switch's
    // button root draws it.
    .onFocusVisible(SwitchStyler().wrap(uiFocusRingModifier(radius: .zero)))
    .onDisabled(SwitchStyler().wrap(.opacity(0.5)))
    .merge(style);

/// The pill track and thumb of each step, off: the control track under the
/// control thumb, lifted by its three-layer shadow. A 3px inset rings the
/// thumb at every step.
SwitchStyler _track(UiSwitchSize size) {
  final (width, height, thumb, radius) = switch (size) {
    .size1 => (
      UiTokens.switchWidth1(),
      UiTokens.space20(),
      UiTokens.switchThumbSize1(),
      UiTokens.radius1OrThumb(),
    ),
    .size2 => (
      UiTokens.switchWidth2(),
      UiTokens.switchHeight2(),
      UiTokens.switchThumbSize2(),
      UiTokens.radius2OrThumb(),
    ),
    .size3 => (
      UiTokens.switchWidth3(),
      UiTokens.switchHeight3(),
      UiTokens.switchThumbSize3(),
      UiTokens.radius2OrThumb(),
    ),
  };

  return SwitchStyler(
        container: .size(
          width,
          height,
        ).padding(.all(_inset())).borderRadius(.all(radius)),
        thumb: .size(thumb, thumb)
            .borderRadius(.all(radius))
            .decoration(
              BoxDecorationMix.create(boxShadow: UiTokens.shadowThumb.mix()),
            ),
      )
      .trackColor(UiTokens.controlTrack())
      .thumbColor(UiTokens.controlThumb())
      .onHovered(SwitchStyler().trackColor(UiTokens.controlTrackHover()))
      .onPressed(SwitchStyler().thumb(.width(_held[size]!())));
}

final _inset = ContextToken<double>((c) => 3 * UiTheme.of(c).scaling.factor);

/// The thumb stretched 5px while held.
final _held = {
  for (final (size, thumb) in [
    (UiSwitchSize.size1, UiTokens.switchThumbSize1),
    (UiSwitchSize.size2, UiTokens.switchThumbSize2),
    (UiSwitchSize.size3, UiTokens.switchThumbSize3),
  ])
    size: ContextToken<double>(
      (c) => thumb.resolve(c) + 5 * UiTheme.of(c).scaling.factor,
    ),
};

/// The control-ink track under the on thumb.
SwitchStyler _surface(bool highContrast) => SwitchStyler()
    .onSelected(
      SwitchStyler()
          .trackColor(
            highContrast ? UiTokens.accent12() : UiTokens.accentTrack(),
          )
          .thumbColor(
            highContrast ? UiTokens.accent1() : UiTokens.accentThumb(),
          )
          .merge(_thumbRing()),
    )
    // The on track draws no hover change; the hover role keeps it themable.
    .onHovered(
      SwitchStyler().onSelected(
        SwitchStyler().trackColor(
          highContrast ? UiTokens.accent12() : UiTokens.accentMarkHover(),
        ),
      ),
    );

/// A 2px ring on the on thumb: transparent by default, where the thumb's
/// shadow carries it, and a contrasting tone under the theme's high contrast.
SwitchStyler _thumbRing() => SwitchStyler().thumb(
  BoxStyler().border(
    .all(.color(UiTokens.accentThumbRing()).width(UiTokens.borderWidth2())),
  ),
);

/// A 10% control-ink tint under a control-ink thumb.
SwitchStyler _soft(bool highContrast) {
  final ink = highContrast ? UiTokens.accent12 : UiTokens.accentTrack;

  return SwitchStyler().onSelected(
    SwitchStyler()
        .trackColor(_softTrack[ink]!())
        .thumbColor(highContrast ? ink() : _softThumb())
        .merge(_thumbRing()),
  );
}

/// The control ink, or the accent's strong tone under the theme's high
/// contrast, where the ink is too light on its own tint.
final _softThumb = ContextToken<Color>(
  (c) =>
      (UiTheme.of(c).highContrast
              ? UiTokens.accentContent
              : UiTokens.accentTrack)
          .resolve(c),
);

/// The on track of the soft switch: the control ink at 10%.
final _softTrack = {
  for (final ink in [UiTokens.accent12, UiTokens.accentTrack])
    ink: ContextToken<Color>((c) => ink.resolve(c).withValues(alpha: 0.1)),
};
