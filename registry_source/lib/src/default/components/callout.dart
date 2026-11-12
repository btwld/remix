import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';

part 'callout.g.dart';

/// The tones this application offers for a callout.
///
/// Two, not info/success/warning: those would each need a color pair this
/// theme does not have.
enum VanillaCalloutVariant {
  /// A neutral aside on the `card` surface.
  neutral,

  /// A problem the reader has to act on.
  destructive,
}

/// The application's Callout recipe.
///
/// The `card` surface inside a `border` hairline with `radiusLg` corners. One
/// content color sets both text and icon. The destructive tone keeps the
/// neutral surface and sets its text in `destructive` (4.5:1 on `card` in both
/// shipped themes); a solid fill would read as a pressed button.
///
/// A callout is not a control, so it has no state fragments.
@MixWidget(target: RemixCallout.new)
CalloutStyler vanillaCalloutStyle({
  VanillaCalloutVariant variant = .neutral,
  CalloutStyler style = const CalloutStyler.create(),
}) {
  final color = switch (variant) {
    .neutral => VanillaTokens.cardForeground(),
    .destructive => VanillaTokens.destructive(),
  };

  return CalloutStyler()
      .direction(.horizontal)
      .crossAxisAlignment(.start)
      .padding(
        .symmetric(horizontal: VanillaTokens.s4, vertical: VanillaTokens.s3),
      )
      .spacing(VanillaTokens.s3)
      .color(VanillaTokens.card())
      .border(
        .color(VanillaTokens.border()).width(VanillaTokens.strokeHairline),
      )
      .borderRadius(.all(VanillaTokens.radiusLg()))
      .text(.style(VanillaTokens.textSm.mix()).color(color))
      // Nudged 2px down: a font's line box reserves leading above the glyphs,
      // so an icon at the line origin looks high.
      .icon(
        .size(
          VanillaTokens.icon,
        ).color(color).wrap(.translate(x: 0, y: VanillaTokens.s0_5)),
      )
      .merge(style);
}
