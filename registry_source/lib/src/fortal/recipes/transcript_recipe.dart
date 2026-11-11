import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../theme/theme.dart';
import '../../agent/components/transcript.dart';

import '../components/icon_button.dart';

@immutable
final class FortalAgentTranscriptRecipe {
  const FortalAgentTranscriptRecipe({
    required this.style,
    required this.latestStyle,
  });
  final AgentTranscriptStyler style;
  final IconButtonStyler latestStyle;
}

FortalAgentTranscriptRecipe fortalAgentTranscriptRecipe({
  AgentTranscriptStyler style = const AgentTranscriptStyler.create(),
  IconButtonStyler latestStyle = const IconButtonStyler.create(),
}) => FortalAgentTranscriptRecipe(
  style: AgentTranscriptStyler(
    viewport: BoxStyler(),
    item: BoxStyler(),
    spacing: FortalTokens.space3(),
    latest: BoxStyler().padding(.bottom(FortalTokens.space3())),
  ).merge(style),
  // A round surface button over the newest output. Its fill is the opaque
  // panel, so the output beneath does not show through; Fortal keeps shadows
  // for floating layers, so its accent frame alone sets it apart.
  latestStyle: fortalIconButtonStyle(
    variant: .surface,
    size: .size2,
    style: IconButtonStyler()
        .color(FortalTokens.colorPanelSolid())
        .borderRadius(.all(FortalTokens.radiusCircle()))
        .onHovered(.color(FortalTokens.colorPanelSolid()))
        .onPressed(.color(FortalTokens.gray3()))
        .merge(latestStyle),
  ),
);
