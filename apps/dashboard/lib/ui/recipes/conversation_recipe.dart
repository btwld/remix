import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/icon_button.dart';
import '../theme/theme.dart';

/// Styles for the conversation: the reading column and the button that
/// returns to the latest output.
@immutable
final class UiAgentConversationRecipe {
  const UiAgentConversationRecipe({
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
UiAgentConversationRecipe uiAgentConversationRecipe({
  AgentConversationStyler style = const AgentConversationStyler.create(),
  IconButtonStyler latestStyle = const IconButtonStyler.create(),
}) => UiAgentConversationRecipe(
  style: AgentConversationStyler(
    maxWidth: UiTokens.messageContentMaxWidth(),
    padding: .only(
      left: UiTokens.space4(),
      top: UiTokens.space6(),
      right: UiTokens.space4(),
      bottom: UiTokens.space5(),
    ),
    turnSpacing: UiTokens.space8(),
    blockSpacing: UiTokens.space5(),
    // The button floats 16px above the composer.
    latest: BoxStyler().padding(.bottom(UiTokens.space4())),
    empty: BoxStyler().alignment(.center),
  ).merge(style),
  latestStyle: uiIconButtonStyle(
    variant: .outline,
    size: .size3,
    style: IconButtonStyler()
        .color(UiTokens.colorSurface())
        .borderRadius(.circular(_pill))
        .merge(latestStyle),
  ),
);

/// Pill corners, whatever radius the theme chooses.
const _pill = 999.0;
