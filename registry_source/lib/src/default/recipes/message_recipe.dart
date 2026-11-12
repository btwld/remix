import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../theme/tokens.dart';

/// Styles for a message: the reader's bubble.
@immutable
final class VanillaAgentMessageRecipe {
  const VanillaAgentMessageRecipe({
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
VanillaAgentMessageRecipe vanillaAgentMessageRecipe({
  AgentMessageStyler style = const AgentMessageStyler.create(),
  ButtonStyler toggleStyle = const ButtonStyler.create(),
}) => VanillaAgentMessageRecipe(
  style: AgentMessageStyler()
      .text(
        TextStyler()
            .style(VanillaTokens.textBase.mix())
            .color(VanillaTokens.foreground()),
      )
      .onUser(
        AgentMessageStyler(
          surface: BoxStyler()
              .color(VanillaTokens.muted())
              .borderRadius(.all(VanillaTokens.radiusXl()))
              .padding(
                .symmetric(
                  horizontal: VanillaTokens.s4,
                  vertical: VanillaTokens.s2,
                ),
              ),
          maxWidthFactor: 0.75,
          collapsedHeight: 72.0,
        ),
      )
      .merge(style),
  toggleStyle: vanillaButtonStyle(
    variant: .ghost,
    size: .small,
    style: toggleStyle,
  ),
);
