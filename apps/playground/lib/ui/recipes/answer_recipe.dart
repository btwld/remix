import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/icon_button.dart';
import '../theme/tokens.dart';

/// Styles for an answer: its body, its sources and a bar of actions.
@immutable
final class PlaygroundAgentAnswerRecipe {
  const PlaygroundAgentAnswerRecipe({
    required this.style,
    required this.actionStyle,
    required this.selectedActionStyle,
  });

  /// Styles for the body, the spacing of its parts and the actions bar.
  final AgentAnswerStyler style;

  /// Styles for every action: copy, feedback and retry.
  final IconButtonStyler actionStyle;

  /// The chosen feedback action, merged over the ordinary action.
  final IconButtonStyler selectedActionStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
///
/// The answer is plain text on the page, with no card: 16px type, 12px between
/// the body, the sources and the actions. The 32px action buttons hang 8px
/// into the margin so their glyphs line up with the text edge.
PlaygroundAgentAnswerRecipe playgroundAgentAnswerRecipe({
  AgentAnswerStyler style = const AgentAnswerStyler.create(),
  IconButtonStyler actionStyle = const IconButtonStyler.create(),
  IconButtonStyler selectedActionStyle = const IconButtonStyler.create(),
}) => PlaygroundAgentAnswerRecipe(
  style: AgentAnswerStyler(
    container: FlexBoxStyler().spacing(PlaygroundTokens.s3),
    text: TextStyler()
        .style(PlaygroundTokens.textBase.mix())
        .color(PlaygroundTokens.foreground()),
    actions: FlexBoxStyler()
        .spacing(PlaygroundTokens.s2)
        .crossAxisAlignment(.center)
        .transform(Matrix4.translationValues(-_actionsHang, 0, 0)),
    feedback: TextStyler()
        .style(PlaygroundTokens.textXs.mix())
        .color(PlaygroundTokens.mutedForeground()),
  ).merge(style),
  actionStyle: playgroundIconButtonStyle(
    variant: .ghost,
    size: .small,
    style: IconButtonStyler()
        .icon(.color(PlaygroundTokens.mutedForeground()))
        .merge(actionStyle),
  ),
  selectedActionStyle: IconButtonStyler()
      .color(PlaygroundTokens.accent())
      .icon(.color(PlaygroundTokens.foreground()))
      .onHovered(.color(PlaygroundTokens.accent()))
      .onPressed(.color(PlaygroundTokens.accent()))
      .merge(selectedActionStyle),
);

/// How far the action buttons shift left: the 8px between a 32px
/// button's edge and its 16px glyph.
const _actionsHang = 8.0;
