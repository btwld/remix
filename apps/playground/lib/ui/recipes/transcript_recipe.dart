import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/icon_button.dart';
import '../components/transcript.dart';
import '../theme/tokens.dart';

@immutable
final class PlaygroundAgentTranscriptRecipe {
  const PlaygroundAgentTranscriptRecipe({
    required this.style,
    required this.latestStyle,
  });
  final PlaygroundTranscriptStyler style;
  final IconButtonStyler latestStyle;
}

PlaygroundAgentTranscriptRecipe playgroundAgentTranscriptRecipe({
  PlaygroundTranscriptStyler style = const PlaygroundTranscriptStyler.create(),
  IconButtonStyler latestStyle = const IconButtonStyler.create(),
}) => PlaygroundAgentTranscriptRecipe(
  style: PlaygroundTranscriptStyler(
    viewport: BoxStyler(),
    item: BoxStyler(),
    spacing: 12,
    latest: BoxStyler().padding(.bottom(PlaygroundTokens.s4)),
  ).merge(style),
  // AI Elements' ConversationScrollButton: a round outline icon button. Its
  // fill is the opaque background in both modes (the outline variant's dark
  // fill is translucent), so the output beneath does not show through.
  latestStyle: playgroundIconButtonStyle(
    variant: .outline,
    size: .small,
    style: IconButtonStyler()
        .borderRadius(.circular(9999))
        .color(PlaygroundTokens.background())
        .onHovered(.color(PlaygroundTokens.accent()))
        .onPressed(.color(PlaygroundTokens.accent()))
        .merge(latestStyle),
  ),
);
