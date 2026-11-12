import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';

part 'tooltip.g.dart';

/// The application's Tooltip recipe.
///
/// `textXs` on a `foreground` bubble with `radiusMd` corners, shown the moment
/// the pointer arrives. It is the one floating surface that is not `popover`:
/// inverted (`foreground` fill, `background` text), so a transient label reads
/// differently from a panel a reader can act in.
@MixWidget(target: RemixTooltip.new)
TooltipStyler playgroundTooltipStyle({
  TooltipStyler style = const TooltipStyler.create(),
}) => TooltipStyler()
    .color(PlaygroundTokens.foreground())
    .borderRadius(.all(PlaygroundTokens.radiusMd()))
    .padding(
      .symmetric(
        horizontal: PlaygroundTokens.s3,
        vertical: PlaygroundTokens.s1_5,
      ),
    )
    .label(
      .style(
        PlaygroundTokens.textXs.mix(),
      ).color(PlaygroundTokens.background()),
    )
    .waitDuration(Duration.zero)
    // Remix maps this onto Naked UI's `touchDelay`: how long a touch tooltip
    // stays up after the press ends. A finger has no hover.
    .showDuration(const Duration(milliseconds: 1500))
    // Remix maps this onto `dismissDelay`. Short but not zero, so a pointer
    // clipping the anchor's edge does not snap the bubble shut.
    .dismissDuration(const Duration(milliseconds: 100))
    .merge(style);
