import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/scale.dart';
import '../theme/tokens.dart';

part 'tooltip.g.dart';

/// The application's Tooltip recipe.
///
/// Remix owns the rendering, the overlay, the anchor positioning, and the
/// hover and focus timing; this recipe supplies the bubble and the three
/// durations that decide when it appears and how long it stays.
///
/// It is shadcn's tooltip: `textXs` on a `foreground` bubble with `radiusMd`
/// corners, shown the moment the pointer arrives, as shadcn's
/// `TooltipProvider` (`delayDuration = 0`) shows it.
///
/// It is the one floating surface here that does *not* use `background`. A
/// tooltip is a transient label, not a panel a reader can act in, and
/// inverting it — `foreground` fill, `background` text — is what makes that
/// difference legible at a glance without a second token.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it.
@MixWidget(target: RemixTooltip.new)
TooltipStyler vanillaTooltipStyle({
  TooltipStyler style = const TooltipStyler.create(),
}) => TooltipStyler()
    .color(VanillaTokens.foreground())
    .borderRadius(.all(VanillaTokens.radiusMd()))
    .padding(
      .symmetric(horizontal: VanillaSpace.s3, vertical: VanillaSpace.s1_5),
    )
    .label(.style(VanillaTokens.textXs.mix()).color(VanillaTokens.background()))
    .waitDuration(Duration.zero)
    .showDuration(_showDuration)
    .dismissDuration(_dismissDuration)
    .merge(style);

/// How long a *touch*-triggered tooltip stays up after the press ends.
///
/// Remix maps this onto Naked UI's `touchDelay`, so despite the name it has
/// nothing to say about hovering: a finger has no hover state, and this is
/// the whole time a touch user gets to read the bubble.
const _showDuration = Duration(milliseconds: 1500);

/// The grace period between the pointer leaving and the bubble closing.
///
/// Remix maps this onto Naked UI's `dismissDelay`. Short, but not zero: a
/// pointer that clips the anchor's edge on its way somewhere else should not
/// snap the bubble shut mid-sentence.
const _dismissDuration = Duration(milliseconds: 100);
