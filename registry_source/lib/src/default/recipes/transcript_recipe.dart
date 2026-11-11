import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/transcript.dart';

import '../components/icon_button.dart';
import '../theme/tokens.dart';

@immutable
final class VanillaAgentTranscriptRecipe {
  const VanillaAgentTranscriptRecipe({
    required this.style,
    required this.latestStyle,
  });
  final AgentTranscriptStyler style;
  final IconButtonStyler latestStyle;
}

VanillaAgentTranscriptRecipe vanillaAgentTranscriptRecipe({
  AgentTranscriptStyler style = const AgentTranscriptStyler.create(),
  IconButtonStyler latestStyle = const IconButtonStyler.create(),
}) => VanillaAgentTranscriptRecipe(
  style: AgentTranscriptStyler(
    viewport: BoxStyler(),
    item: BoxStyler(),
    spacing: 12,
    latest: BoxStyler().padding(.bottom(VanillaTokens.s4)),
  ).merge(style),
  // AI Elements' ConversationScrollButton: a round outline icon button. Its
  // fill is the opaque background in both modes (the outline variant's dark
  // fill is translucent), so the output beneath does not show through.
  latestStyle: vanillaIconButtonStyle(
    variant: .outline,
    size: .small,
    style: IconButtonStyler()
        .borderRadius(.circular(9999))
        .color(VanillaTokens.background())
        .onHovered(.color(VanillaTokens.accent()))
        .onPressed(.color(VanillaTokens.accent()))
        .merge(latestStyle),
  ),
);
