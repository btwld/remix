import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../theme/theme.dart';

/// Styles for a message: the reader's bubble.
@immutable
final class HeroUiAgentMessageRecipe {
  const HeroUiAgentMessageRecipe({
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
HeroUiAgentMessageRecipe heroUiAgentMessageRecipe({
  AgentMessageStyler style = const AgentMessageStyler.create(),
  ButtonStyler toggleStyle = const ButtonStyler.create(),
}) => HeroUiAgentMessageRecipe(
  style: AgentMessageStyler()
      .text(
        TextStyler()
            .style(HeroUiTokens.textBase.mix())
            .color(HeroUiTokens.foreground()),
      )
      .onUser(
        AgentMessageStyler(
          surface: BoxStyler()
              .color(HeroUiTokens.surfaceSecondary())
              .borderRadius(.all(HeroUiTokens.radius2xl()))
              .padding(.symmetric(horizontal: 16, vertical: 8)),
          maxWidthFactor: 0.75,
          collapsedHeight: 72.0,
        ),
      )
      .merge(style),
  toggleStyle: heroUiButtonStyle(
    variant: .ghost,
    size: .sm,
    style: toggleStyle,
  ),
);
