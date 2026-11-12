import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'segmented_control.g.dart';

/// The application's SegmentedControl recipe.
///
/// One control in parts: a recessed `muted` track with the chosen segment
/// lifted onto it, drawn like the filled tab list so the two read as a family.
/// It takes no variant; a second look would be a toggle group.
///
/// `item` is the default every `RemixSegmentedControlItem` resolves against, so
/// one recipe styles the track and its segments.
@MixWidget(target: RemixSegmentedControl.new)
SegmentedControlStyler vanillaSegmentedControlStyle({
  SegmentedControlStyler style = const SegmentedControlStyler.create(),
}) {
  return SegmentedControlStyler()
      .color(VanillaTokens.muted())
      .borderRadius(.all(VanillaTokens.radiusLg()))
      .padding(.all(_trackInset))
      .mainAxisSize(.min)
      .spacing(0)
      .item(
        // 60% `foreground`, or `mutedForeground` in the dark theme: the
        // unchosen tab's color, 4.5:1 on the track.
        _content(
              vanillaByBrightness(
                light: vanillaTint(VanillaTokens.foreground, 0.6),
                dark: VanillaTokens.mutedForeground,
              )(),
            )
            .color(_transparent)
            // The track's 36px less the inset on both sides, so it lands on
            // the height of the button and field beside it.
            .minHeight(VanillaTokens.controlMd - 2 * _trackInset)
            .padding(
              .symmetric(
                horizontal: VanillaTokens.s2,
                vertical: VanillaTokens.s1,
              ),
            )
            .spacing(VanillaTokens.s1_5)
            .borderRadius(.all(VanillaTokens.radiusMd()))
            // Holds the outline space the chosen segment paints.
            .border(.color(_transparent).width(VanillaTokens.strokeHairline))
            .label(
              .style(VanillaTokens.textSm.mix()).fontWeight(FontWeight.w500),
            )
            .icon(.size(VanillaTokens.icon))
            .onHovered(_content(VanillaTokens.foreground()))
            .onSelected(
              _content(VanillaTokens.foreground())
                  // The page color, or `input` at 30% in the dark theme.
                  .color(
                    vanillaByBrightness(
                      light: VanillaTokens.background,
                      dark: vanillaTint(VanillaTokens.input, 0.3),
                    )(),
                  )
                  // No outline in the light theme, `input` in the dark one.
                  .border(
                    .color(vanillaTint(VanillaTokens.input, 0, dark: 1)()),
                  )
                  // In the effects layer: the dark fill is translucent, and a
                  // decoration shadow would show through it.
                  .containerEffects(.behindContent(VanillaShadow.sm.effects)),
            )
            .onFocusVisible(.containerEffects(vanillaFocusRing()))
            // Declared last so it wins over every other state fragment.
            .onDisabled(
              SegmentedControlItemStyler()
                  .containerEffects(.outline(.style(.none)))
                  .wrap(.opacity(VanillaTokens.disabledOpacity)),
            ),
      )
      .merge(style);
}

/// Gap between the track edge and its segments.
const _trackInset = 3.0;

const _transparent = Color(0x00000000);

/// One content color for the label and the icons.
SegmentedControlItemStyler _content(Color foreground) =>
    SegmentedControlItemStyler()
        .label(.color(foreground))
        .icon(.color(foreground));
