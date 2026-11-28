import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'radio.g.dart';

/// The sizes a radio comes in. Pixel values are at 100% theme scaling.
enum FortalRadioSize {
  /// A 14px circle with a 6px dot.
  size1,

  /// A 17px circle with a 7px dot. The default.
  size2,

  /// A 19px circle with a 7px dot.
  size3,
}

/// The looks a radio comes in.
enum FortalRadioVariant {
  /// An empty circle in a 1px strong frame; selected, a control-ink disc
  /// with a glyph-coloured dot.
  surface,

  /// The surface circle at rest; selected, a 10% control-ink tint inside a
  /// control-ink frame, with a control-ink dot.
  soft,

  /// The surface circle inside a 1px framed card row with 12px padding that
  /// fills on hover and takes a control-ink frame and a 5% tint when
  /// selected. Use it with a label, and a description under it.
  card,
}

/// The Fortal Radio recipe.
///
/// It reads top to bottom: the circle and its dot, then the variant's colors,
/// then the label, press, disabled and the focus ring. The dot stays mounted
/// so it grows in from 40% and fades out when another radio is chosen; a
/// pressed empty radio previews it at 22%.
///
/// [highContrast] moves the selected fill (surface, card) or dot (soft) to
/// accent step 12.
@MixWidget(target: RemixRadio.new)
RadioStyler fortalRadioStyle({
  FortalRadioVariant variant = .surface,
  FortalRadioSize size = .size2,
  bool highContrast = false,
  RadioStyler style = const RadioStyler.create(),
}) => _circle(size)
    .merge(switch (variant) {
      .surface || .card => _surface(highContrast),
      .soft => _soft(highContrast),
    })
    .merge(_copy(size, highContrast))
    .merge(variant == .card ? _card(highContrast) : _target())
    .onPressed(RadioStyler().scale(0.88))
    .animate(_motion)
    .onDisabled(RadioStyler().wrap(.opacity(0.5)))
    .merge(style);

/// Dot colour, dot scale and press scale: 150 ms on the standard ease.
final _motion = AnimationConfig.curve(
  duration: FortalMotion.fast,
  curve: FortalMotion.easeStandard,
);

/// The circle and its always-mounted dot, hidden at 40% while unselected.
RadioStyler _circle(FortalRadioSize size) {
  final (circle, dot) = switch (size) {
    .size1 => (
      FortalTokens.checkboxSize1(),
      FortalTokens.radioIndicatorSize1(),
    ),
    .size2 => (FortalTokens.radioSize2(), FortalTokens.radioIndicatorSize2()),
    .size3 => (FortalTokens.radioSize3(), FortalTokens.radioIndicatorSize2()),
  };

  return RadioStyler(
        container: .size(
          circle,
          circle,
        ).alignment(.center).borderRadius(.all(FortalTokens.radiusCircle())),
        indicator: .size(
          dot,
          dot,
        ).borderRadius(.all(FortalTokens.radiusCircle())),
        containerEffects: RemixBoxEffectsMix(
          behindContent: RemixBoxEffectLayerMix(),
        ),
      )
      .keepIndicatorMounted(true)
      .indicator(_dot(scale: 0.4, opacity: 0))
      .onPressed(
        RadioStyler()
            .indicator(_dot(scale: 1, opacity: 0.22))
            .indicatorColor(FortalTokens.gray12()),
      )
      .onSelected(RadioStyler().indicator(_dot(scale: 1, opacity: 1)));
}

BoxStyler _dot({required double scale, required double opacity}) =>
    BoxStyler().scale(scale).wrap(.opacity(opacity));

/// An empty circle in the strong frame; selected, a control-ink disc with a
/// glyph-coloured dot.
RadioStyler _surface(bool highContrast) {
  final ink = highContrast
      ? FortalTokens.accent12()
      : FortalTokens.accentIndicator();

  return RadioStyler()
      .merge(_frame(FortalTokens.controlBorder()))
      .onSelected(
        RadioStyler()
            .color(ink)
            .merge(_frame(ink))
            .indicatorColor(
              highContrast
                  ? FortalTokens.accent1()
                  : FortalTokens.accentIndicatorContrast(),
            ),
      );
}

/// The empty surface circle; selected, a tint of the control ink inside a
/// control-ink frame with a control-ink dot.
RadioStyler _soft(bool highContrast) {
  final ink = highContrast
      ? FortalTokens.accent12
      : FortalTokens.accentIndicator;

  return RadioStyler()
      .merge(_frame(FortalTokens.controlBorder()))
      .onSelected(
        RadioStyler()
            .color(_tint(ink, 0.1)())
            .merge(_frame(ink()))
            .indicatorColor(ink()),
      );
}

/// Secondary medium label 12px from the circle that turns foreground when
/// selected, and a muted description 2px under it.
RadioStyler _copy(FortalRadioSize size, bool highContrast) {
  final (label, description) = switch (size) {
    .size1 => (FortalTokens.text1, FortalTokens.text1),
    .size2 => (FortalTokens.text2, FortalTokens.text1),
    .size3 => (FortalTokens.text3, FortalTokens.text2),
  };

  return RadioStyler()
      .label(
        TextStyler()
            .style(label.mix())
            .fontWeight(FortalTokens.fontWeightMedium())
            .color(FortalTokens.gray11()),
      )
      .labelSpacing(FortalTokens.space3())
      .description(
        TextStyler()
            .style(description.mix())
            .color(highContrast ? FortalTokens.gray11() : _mutedContent()),
      )
      .descriptionSpacing(2)
      .onSelected(
        RadioStyler().label(TextStyler().color(FortalTokens.gray12())),
      );
}

/// The 40px touch target and a focus ring around the 40px box inside the
/// 48px tap target, with the control corner.
RadioStyler _target() => RadioStyler()
    .wrap(fortalTouchTarget())
    .onFocusVisible(
      RadioStyler().wrap(
        fortalFocusRingModifier(radius: const .circular(14), inset: 4),
      ),
    );

/// A 1px framed card row with 12px padding and the control corner; muted on
/// hover and press, control-ink frame and a 5% tint when selected. The ring
/// circles the card.
RadioStyler _card(bool highContrast) {
  final ink = highContrast
      ? FortalTokens.accent12
      : FortalTokens.accentIndicator;
  final corner = FortalTokens.radius4();

  return RadioStyler()
      .row(BoxStyler().padding(.all(_cardInset())).borderRadius(.all(corner)))
      .merge(_rowFrame(FortalTokens.gray7()))
      .onHovered(RadioStyler().row(BoxStyler().color(FortalTokens.gray3())))
      .onPressed(RadioStyler().row(BoxStyler().color(FortalTokens.gray3())))
      .onSelected(
        RadioStyler()
            .row(BoxStyler().color(_tint(ink, 0.05)()))
            .merge(_rowFrame(ink())),
      )
      .onFocusVisible(RadioStyler().wrap(fortalFocusRingModifier()));
}

/// The control ink at [alpha], one token per pair so equal arguments build
/// equal styles.
/// 12px inside the card's 1px frame, which is drawn inset and takes no
/// layout space.
/// Gray 10 reads at about 4.1:1 on a light page; high contrast takes gray 11.
final _mutedContent = ContextToken<Color>(
  (context) => FortalTheme.maybeOf(context)?.highContrast ?? false
      ? FortalTokens.gray11.resolve(context)
      : FortalTokens.gray10.resolve(context),
);

final _cardInset = ContextToken<double>(
  (c) => FortalTokens.space3.resolve(c) + FortalTokens.borderWidth1.resolve(c),
);

ContextToken<Color> _tint(ColorToken ink, double alpha) => _tints.putIfAbsent((
  ink,
  alpha,
), () => ContextToken<Color>((c) => ink.resolve(c).withValues(alpha: alpha)));
final _tints = <(ColorToken, double), ContextToken<Color>>{};

/// A 1px inset frame over the circle in [color].
RadioStyler _frame(Color color) => RadioStyler().containerEffects(
  RemixBoxEffectsMix.overContent(fortalInsetSurface(strokes: [color])),
);

/// A 1px inset frame over the card row in [color].
RadioStyler _rowFrame(Color color) => RadioStyler().rowEffects(
  RemixBoxEffectsMix.overContent(fortalInsetSurface(strokes: [color])),
);
