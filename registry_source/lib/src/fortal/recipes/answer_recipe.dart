import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/icon_button.dart';
import '../theme/theme.dart';

/// Styles for an answer: its body, its sources and a bar of actions.
@immutable
final class FortalAgentAnswerRecipe {
  const FortalAgentAnswerRecipe({
    required this.style,
    required this.actionStyle,
  });

  /// Styles for the body, the spacing of its parts and the actions bar.
  final AgentAnswerStyler style;

  /// Styles for every action: copy, feedback and retry.
  final IconButtonStyler actionStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
///
/// The answer is plain text on the page, with no card: 16px type, 12px between
/// the body, the sources and the actions. The 32px action buttons hang 8px
/// into the margin so their glyphs line up with the text edge.
FortalAgentAnswerRecipe fortalAgentAnswerRecipe({
  AgentAnswerStyler style = const AgentAnswerStyler.create(),
  IconButtonStyler actionStyle = const IconButtonStyler.create(),
}) => FortalAgentAnswerRecipe(
  style: AgentAnswerStyler(
    container: FlexBoxStyler().spacing(FortalTokens.space3()),
    text: TextStyler()
        .style(FortalTokens.text3.mix())
        .color(FortalTokens.gray12()),
    actions: FlexBoxStyler()
        .spacing(FortalTokens.space2())
        .crossAxisAlignment(.center)
        .transform(Matrix4.translationValues(-_actionsHang, 0, 0)),
    feedback: TextStyler()
        .style(FortalTokens.text1.mix())
        .color(FortalTokens.gray11()),
  ).merge(style),
  actionStyle: fortalIconButtonStyle(
    variant: .ghost,
    size: .size2,
    style: IconButtonStyler()
        .icon(.color(FortalTokens.gray11()))
        .merge(actionStyle),
  ),
);

/// How far the action buttons shift left: the 8px between a 32px
/// button's edge and its 16px glyph.
const _actionsHang = 8.0;
