import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/icon_button.dart';
import '../theme/theme.dart';

/// Styles for the conversation: the reading column and the button that
/// returns to the latest output.
@immutable
final class FortalAgentConversationRecipe {
  const FortalAgentConversationRecipe({
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
FortalAgentConversationRecipe fortalAgentConversationRecipe({
  AgentConversationStyler style = const AgentConversationStyler.create(),
  IconButtonStyler latestStyle = const IconButtonStyler.create(),
}) => FortalAgentConversationRecipe(
  style: AgentConversationStyler(
    maxWidth: FortalTokens.messageContentMaxWidth(),
    padding: .only(
      left: FortalTokens.space4(),
      top: FortalTokens.space6(),
      right: FortalTokens.space4(),
      bottom: FortalTokens.space5(),
    ),
    turnSpacing: FortalTokens.space8(),
    blockSpacing: FortalTokens.space5(),
    // The button floats 16px above the composer.
    latest: BoxStyler().padding(.bottom(FortalTokens.space4())),
    empty: BoxStyler().alignment(.center),
  ).merge(style),
  latestStyle: fortalIconButtonStyle(
    variant: .outline,
    size: .size3,
    style: IconButtonStyler()
        .color(FortalTokens.colorSurface())
        .borderRadius(.all(FortalTokens.radiusFull()))
        .merge(latestStyle),
  ),
);
