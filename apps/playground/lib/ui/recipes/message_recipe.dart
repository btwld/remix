import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../theme/tokens.dart';

/// Styles for a message: the reader's bubble.
@immutable
final class PlaygroundAgentMessageRecipe {
  const PlaygroundAgentMessageRecipe({
    required this.style,
    required this.toggleStyle,
  });

  /// Styles for the bubble, its text and the collapsed height of a long one.
  final AgentMessageStyler style;

  /// Styles for the button that expands or collapses a long message.
  final ButtonStyler toggleStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
///
/// A user message is a `gray3` bubble at most three quarters of the line wide.
/// An assistant message adds nothing: its answer is the content.
PlaygroundAgentMessageRecipe playgroundAgentMessageRecipe({
  AgentMessageStyler style = const AgentMessageStyler.create(),
  ButtonStyler toggleStyle = const ButtonStyler.create(),
}) => PlaygroundAgentMessageRecipe(
  style: AgentMessageStyler()
      .text(
        TextStyler()
            .style(PlaygroundTokens.textBase.mix())
            .color(PlaygroundTokens.foreground()),
      )
      .onUser(
        AgentMessageStyler(
          surface: BoxStyler()
              .color(PlaygroundTokens.muted())
              .borderRadius(.all(PlaygroundTokens.radiusXl()))
              .padding(
                .symmetric(
                  horizontal: PlaygroundTokens.s4,
                  vertical: PlaygroundTokens.s2,
                ),
              ),
          maxWidthFactor: 0.75,
          collapsedHeight: 72.0,
        ),
      )
      .merge(style),
  toggleStyle: playgroundButtonStyle(
    variant: .ghost,
    size: .small,
    style: toggleStyle,
  ),
);
