import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../theme/theme.dart';

/// Styles for the conversation: the reading column and the button that
/// returns to the latest output.
@immutable
final class HeroUiAgentConversationRecipe {
  const HeroUiAgentConversationRecipe({
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
HeroUiAgentConversationRecipe heroUiAgentConversationRecipe({
  AgentConversationStyler style = const AgentConversationStyler.create(),
  IconButtonStyler latestStyle = const IconButtonStyler.create(),
}) => HeroUiAgentConversationRecipe(
  style: AgentConversationStyler(
    maxWidth: 768.0,
    padding: .only(left: 16, top: 32, right: 16, bottom: 24),
    turnSpacing: 48,
    blockSpacing: 24,
    // The button floats 16px above the composer.
    latest: BoxStyler().padding(.bottom(16)),
    empty: BoxStyler().alignment(.center),
  ).merge(style),
  latestStyle: heroUiIconButtonStyle(
    variant: .outline,
    size: .md,
    style: IconButtonStyler()
        .color(HeroUiTokens.surface())
        .borderRadius(.all(HeroUiTokens.radius4xl()))
        .merge(latestStyle),
  ),
);
