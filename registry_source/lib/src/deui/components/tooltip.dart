import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'tooltip.g.dart';

/// Deui recipe for [RemixTooltip]: a small `overlay` chip with a hairline
/// border and a 12px medium label.
///
/// Hover, focus, and long-press behavior stay with Remix.
@MixWidget(target: RemixTooltip.new)
TooltipStyler deuiTooltipStyle({
  TooltipStyler style = const TooltipStyler.create(),
}) => TooltipStyler()
    .maxWidth(_maxWidth)
    .padding(.symmetric(horizontal: _paddingX, vertical: _paddingY))
    .color(DeuiTokens.overlay())
    .border(deuiHairline())
    .borderRadius(.circular(_radius))
    .label(.style(DeuiTokens.textXs.mix()).fontWeight(.w500))
    .merge(style);

const _maxWidth = 320.0;
const _paddingX = 10.0;
const _paddingY = 4.0;
const _radius = 8.0;
