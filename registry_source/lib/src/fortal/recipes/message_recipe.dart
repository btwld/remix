import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../theme/theme.dart';

/// Styles for a message: the reader's bubble.
@immutable
final class FortalAgentMessageRecipe {
  const FortalAgentMessageRecipe({
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
FortalAgentMessageRecipe fortalAgentMessageRecipe({
  AgentMessageStyler style = const AgentMessageStyler.create(),
  ButtonStyler toggleStyle = const ButtonStyler.create(),
}) => FortalAgentMessageRecipe(
  style: AgentMessageStyler()
      .text(
        TextStyler()
            .style(FortalTokens.text3.mix())
            .color(FortalTokens.gray12()),
      )
      .onUser(
        AgentMessageStyler(
          surface: BoxStyler()
              .color(FortalTokens.gray3())
              .borderRadius(.all(FortalTokens.radius6()))
              .padding(
                .symmetric(
                  horizontal: FortalTokens.space4(),
                  vertical: FortalTokens.space2(),
                ),
              ),
          maxWidthFactor: 0.75,
          collapsedHeight: FortalTokens.messageCollapsedHeight(),
        ),
      )
      .merge(style),
  toggleStyle: fortalButtonStyle(
    variant: .ghost,
    size: .size1,
    style: toggleStyle,
  ),
);
