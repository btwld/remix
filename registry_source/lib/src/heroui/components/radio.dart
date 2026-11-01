import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'radio.g.dart';

/// HeroUI radio variants: `primary` on the field surface with its shadow,
/// `secondary` on the default fill.
enum HeroUiRadioVariant { primary, secondary }

/// HeroUI recipe for [RemixRadio].
///
/// The label sits inside the control's tap target. A description beneath it is
/// `HeroUiRadioGroup`'s. [invalid] paints the error treatment and turns the
/// label danger; validation stays with the app.
@MixWidget(target: RemixRadio.new)
RadioStyler heroUiRadioStyle({
  HeroUiRadioVariant variant = .primary,
  bool invalid = false,
  RadioStyler style = const RadioStyler.create(),
}) {
  final field = switch (variant) {
    .primary => heroUiPrimaryFieldFill,
    .secondary => heroUiSecondaryFieldFill,
  };
  final label = invalid ? HeroUiTokens.danger : HeroUiTokens.foreground;

  var result =
      RadioStyler(
            container: BoxStyler()
                .size(heroUiRadioSize, heroUiRadioSize)
                .alignment(.center)
                .borderRadius(.all(HeroUiTokens.radiusLg())),
            indicator: _dot(_dotScale),
          )
          .label(heroUiLabelText.color(label()))
          .labelSpacing(heroUiControlGap)
          .color(field.rest())
          // The unselected dot is `bg-field-hover` while hovered, which fills the
          // whole control.
          .onHovered(.color(field.hover()))
          .onSelected(RadioStyler().color(HeroUiTokens.accent()))
          .onPressed(
            RadioStyler()
                .scale(_pressedScale)
                .onSelected(
                  RadioStyler()
                      .color(HeroUiTokens.accentHover())
                      .indicator(_dot(_pressedDotScale)),
                ),
          )
          .onFocusVisible(.containerEffects(heroUiFocusRing()))
          .animate(HeroUiTokens.selectionMotion);

  if (variant == .primary) {
    result = result.containerEffects(heroUiSurfaceEffects());
  }
  if (invalid) {
    // The 1px danger outline stays when selected; focus still shows the
    // ordinary ring.
    result = result.containerEffects(heroUiInvalidRing());
  }

  return result
      .onDisabled(
        RadioStyler()
            .label(.color(heroUiDisabledLabelColor(danger: invalid)()))
            .wrap(.opacity(HeroUiTokens.disabledOpacity)),
      )
      .merge(style);
}

/// `.radio__control`: `size-4`. Also the description indent in
/// `HeroUiRadioGroup`, with the label gap.
const heroUiRadioSize = 16.0;

/// The selected dot, `scale: 0.4286` of the control, and `0.5714` while pressed.
const _dotScale = 0.4286;
const _pressedDotScale = 0.5714;

/// `.radio__control` while pressed: `scale-95`.
const _pressedScale = 0.95;

BoxStyler _dot(double scale) => BoxStyler()
    .size(heroUiRadioSize * scale, heroUiRadioSize * scale)
    .borderRadius(.all(HeroUiTokens.radiusLg()))
    .color(HeroUiTokens.accentForeground());
