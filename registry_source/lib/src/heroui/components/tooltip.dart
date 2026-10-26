import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'tooltip.g.dart';

/// HeroUI recipe for [RemixTooltip].
///
/// Hover, focus, and long-press behavior stay with Remix.
@MixWidget(target: RemixTooltip.new)
TooltipStyler heroUiTooltipStyle({
  TooltipStyler style = const TooltipStyler.create(),
}) => TooltipStyler()
    .maxWidth(_maxWidth)
    .padding(.all(_padding))
    .color(HeroUiTokens.overlay())
    .borderRadius(.all(_radius()))
    .shadows(heroUiOverlayBoxShadows)
    .label(.style(HeroUiTokens.textXs.mix()))
    .merge(style);

/// `max-w-xs` and `p-2`.
const _maxWidth = 320.0;
const _padding = 8.0;

/// `min(32px, var(--radius-xl))`.
final _radius = heroUiRadius(HeroUiTokens.radiusXl, max: 32);
