import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../motion/motion.dart';
import '../theme/theme.dart';

part 'switch.g.dart';

/// The sizes a switch comes in. Pixel values are at 100% theme scaling.
enum FortalSwitchSize {
  /// A 34px by 20px track with a 14px thumb.
  size1,

  /// A 42px by 24px track with an 18px thumb. The default.
  size2,

  /// A 46px by 26px track with a 20px thumb.
  size3,
}

/// The looks a switch comes in.
enum FortalSwitchVariant {
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
    .animate(
      AnimationConfig.curve(
        duration: FortalSpringCurve.smooth.duration,
        curve: FortalSpringCurve.smooth,
      ),
    )
    .wrap(fortalTouchTarget())
    // The ring circles the 40px touch target with the control corner.
    .onFocusVisible(
      SwitchStyler().wrap(fortalFocusRingModifier(radius: const .circular(14))),
    )
    .onDisabled(SwitchStyler().wrap(.opacity(0.5)))
    .merge(style);

/// The pill track and thumb of each step, off: the control track under the
/// control thumb, lifted by its three-layer shadow. A 3px inset rings the
/// thumb at every step.
SwitchStyler _track(FortalSwitchSize size) {
  final (width, height, thumb, radius) = switch (size) {
    .size1 => (
      FortalTokens.switchWidth1(),
      FortalTokens.space20(),
      FortalTokens.switchThumbSize1(),
      FortalTokens.radius1OrThumb(),
    ),
    .size2 => (
      FortalTokens.switchWidth2(),
      FortalTokens.switchHeight2(),
      FortalTokens.switchThumbSize2(),
      FortalTokens.radius2OrThumb(),
    ),
    .size3 => (
      FortalTokens.switchWidth3(),
      FortalTokens.switchHeight3(),
      FortalTokens.switchThumbSize3(),
      FortalTokens.radius2OrThumb(),
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
              BoxDecorationMix.create(
                boxShadow: FortalTokens.shadowThumb.mix(),
              ),
            ),
      )
      .trackColor(FortalTokens.controlTrack())
      .thumbColor(FortalTokens.controlThumb())
      .onHovered(SwitchStyler().trackColor(FortalTokens.controlTrackHover()))
      .onPressed(SwitchStyler().thumb(.width(_held[size]!())));
}

final _inset = ContextToken<double>(
  (c) => 3 * FortalTheme.of(c).scaling.factor,
);

/// The thumb stretched 5px while held.
final _held = {
  for (final (size, thumb) in [
    (FortalSwitchSize.size1, FortalTokens.switchThumbSize1),
    (FortalSwitchSize.size2, FortalTokens.switchThumbSize2),
    (FortalSwitchSize.size3, FortalTokens.switchThumbSize3),
  ])
    size: ContextToken<double>(
      (c) => thumb.resolve(c) + 5 * FortalTheme.of(c).scaling.factor,
    ),
};

/// The control-ink track under the on thumb.
SwitchStyler _surface(bool highContrast) => SwitchStyler()
    .onSelected(
      SwitchStyler()
          .trackColor(
            highContrast ? FortalTokens.accent12() : FortalTokens.accentTrack(),
          )
          .thumbColor(
            highContrast ? FortalTokens.accent1() : FortalTokens.accentThumb(),
          )
          .merge(_thumbRing()),
    )
    // The on track draws no hover change; the hover role keeps it themable.
    .onHovered(
      SwitchStyler().onSelected(
        SwitchStyler().trackColor(
          highContrast
              ? FortalTokens.accent12()
              : FortalTokens.accentMarkHover(),
        ),
      ),
    );

/// A 2px ring on the on thumb: transparent by default, where the thumb's
/// shadow carries it, and a contrasting tone under the theme's high contrast.
SwitchStyler _thumbRing() => SwitchStyler().thumb(
  BoxStyler().border(
    .all(
      .color(FortalTokens.accentThumbRing()).width(FortalTokens.borderWidth2()),
    ),
  ),
);

/// A 10% control-ink tint under a control-ink thumb.
SwitchStyler _soft(bool highContrast) {
  final ink = highContrast ? FortalTokens.accent12 : FortalTokens.accentTrack;

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
      (FortalTheme.of(c).highContrast
              ? FortalTokens.accentContent
              : FortalTokens.accentTrack)
          .resolve(c),
);

/// The on track of the soft switch: the control ink at 10%.
final _softTrack = {
  for (final ink in [FortalTokens.accent12, FortalTokens.accentTrack])
    ink: ContextToken<Color>((c) => ink.resolve(c).withValues(alpha: 0.1)),
};
