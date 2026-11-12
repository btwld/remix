import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'radio.g.dart';

/// HeroUI radio variants: `primary` on the field surface with its shadow,
/// `secondary` on the default fill.
enum UiRadioVariant { primary, secondary }

/// HeroUI recipe for [RemixRadio].
///
/// The label sits inside the control's tap target. A description beneath it is
/// `UiRadioGroup`'s. [invalid] paints the error treatment and turns the
/// label danger; validation stays with the app.
@MixWidget(target: RemixRadio.new)
RadioStyler uiRadioStyle({
  UiRadioVariant variant = .primary,
  bool invalid = false,
  RadioStyler style = const RadioStyler.create(),
}) {
  final field = switch (variant) {
    .primary => uiPrimaryFieldFill,
    .secondary => uiSecondaryFieldFill,
  };
  final label = invalid ? UiTokens.danger : UiTokens.foreground;

  var result =
      RadioStyler(
            container: BoxStyler()
                .size(uiRadioSize, uiRadioSize)
                .alignment(.center)
                .borderRadius(.all(UiTokens.radiusLg())),
            indicator: _dot(_dotScale),
          )
          .label(uiLabelText.color(label()))
          .labelSpacing(uiControlGap)
          .color(field.rest())
          // The unselected dot is `bg-field-hover` while hovered, which fills the
          // whole control.
          .onHovered(.color(field.hover()))
          .onSelected(RadioStyler().color(UiTokens.accent()))
          .onPressed(
            RadioStyler()
                .scale(_pressedScale)
                .onSelected(
                  RadioStyler()
                      .color(UiTokens.accentHover())
                      .indicator(_dot(_pressedDotScale)),
                ),
          )
          .onFocusVisible(.containerEffects(uiFocusRing()))
          .animate(UiTokens.selectionMotion);

  if (variant == .primary) {
    result = result.containerEffects(uiSurfaceEffects());
  }
  if (invalid) {
    // The 1px danger outline stays when selected; focus still shows the
    // ordinary ring.
    result = result.containerEffects(uiInvalidRing());
  }

  return result
      .onDisabled(
        RadioStyler()
            .label(.color(uiDisabledLabelColor(danger: invalid)()))
            .wrap(.opacity(UiTokens.disabledOpacity)),
      )
      .merge(style);
}

/// `.radio__control`: `size-4`. Also the description indent in
/// `UiRadioGroup`, with the label gap.
const uiRadioSize = 16.0;

/// The selected dot, `scale: 0.4286` of the control, and `0.5714` while pressed.
const _dotScale = 0.4286;
const _pressedDotScale = 0.5714;

/// `.radio__control` while pressed: `scale-95`.
const _pressedScale = 0.95;

BoxStyler _dot(double scale) => BoxStyler()
    .size(uiRadioSize * scale, uiRadioSize * scale)
    .borderRadius(.all(UiTokens.radiusLg()))
    .color(UiTokens.accentForeground());
