import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../theme/theme.dart';

/// Styles for a message: the reader's bubble.
@immutable
final class UiAgentMessageRecipe {
  const UiAgentMessageRecipe({required this.style, required this.toggleStyle});

  /// Styles for the bubble, its text and the collapsed height of a long one.
  final AgentMessageStyler style;

  /// Styles for the button that expands or collapses a long message.
  final ButtonStyler toggleStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
///
/// A user message occupies at most three quarters of the line.
/// An assistant message adds nothing: its answer is the content.
UiAgentMessageRecipe uiAgentMessageRecipe({
  AgentMessageStyler style = const AgentMessageStyler.create(),
  ButtonStyler toggleStyle = const ButtonStyler.create(),
}) => UiAgentMessageRecipe(
  style: AgentMessageStyler()
      .text(
        TextStyler()
            .style(UiTokens.textBase.mix())
            .color(UiTokens.foreground()),
      )
      .onUser(
        AgentMessageStyler(
          surface: BoxStyler()
              .color(UiTokens.surfaceSecondary())
              .borderRadius(.all(UiTokens.radius2xl()))
              .padding(.symmetric(horizontal: 16, vertical: 8)),
          maxWidthFactor: 0.75,
          collapsedHeight: 72.0,
        ),
      )
      .merge(style),
  toggleStyle: uiButtonStyle(variant: .ghost, size: .sm, style: toggleStyle),
);
