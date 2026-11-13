import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/icon_button.dart';
import '../theme/tokens.dart';

/// Styles for the conversation: the reading column and the button that
/// returns to the latest output.
@immutable
final class PlaygroundAgentConversationRecipe {
  const PlaygroundAgentConversationRecipe({
    required this.style,
    required this.latestStyle,
  });

  /// Styles for the column, the spacing of turns and blocks, and the empty state.
  final AgentConversationStyler style;

  /// Styles for the button that scrolls back to the latest output.
  final IconButtonStyler latestStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
///
/// Turns sit 48px apart and the blocks of a turn 24px apart, in a column that
/// stops at 768px and centers in a wider transcript.
PlaygroundAgentConversationRecipe playgroundAgentConversationRecipe({
  AgentConversationStyler style = const AgentConversationStyler.create(),
  IconButtonStyler latestStyle = const IconButtonStyler.create(),
}) => PlaygroundAgentConversationRecipe(
  style: AgentConversationStyler(
    maxWidth: 768.0,
    padding: .only(
      left: PlaygroundTokens.s4,
      top: PlaygroundTokens.s8,
      right: PlaygroundTokens.s4,
      bottom: PlaygroundTokens.s6,
    ),
    turnSpacing: PlaygroundTokens.s12,
    blockSpacing: PlaygroundTokens.s6,
    // The button floats 16px above the composer.
    latest: BoxStyler().padding(.bottom(PlaygroundTokens.s4)),
    empty: BoxStyler().alignment(.center),
  ).merge(style),
  latestStyle: playgroundIconButtonStyle(
    variant: .outline,
    size: .large,
    style: IconButtonStyler()
        .color(PlaygroundTokens.background())
        .borderRadius(.circular(PlaygroundTokens.pill))
        .merge(latestStyle),
  ),
);
