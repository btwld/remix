import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/icon_button.dart';
import '../theme/theme.dart';

/// Styles for an answer: its body, its sources and a bar of actions.
@immutable
final class UiAgentAnswerRecipe {
  const UiAgentAnswerRecipe({
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
UiAgentAnswerRecipe uiAgentAnswerRecipe({
  AgentAnswerStyler style = const AgentAnswerStyler.create(),
  IconButtonStyler actionStyle = const IconButtonStyler.create(),
  IconButtonStyler selectedActionStyle = const IconButtonStyler.create(),
}) => UiAgentAnswerRecipe(
  style: AgentAnswerStyler(
    container: FlexBoxStyler().spacing(UiTokens.space3()),
    text: TextStyler().style(UiTokens.text3.mix()).color(UiTokens.gray12()),
    actions: FlexBoxStyler()
        .spacing(UiTokens.space2())
        .crossAxisAlignment(.center)
        .transform(Matrix4.translationValues(-_actionsHang, 0, 0)),
    feedback: TextStyler().style(UiTokens.text1.mix()).color(UiTokens.gray11()),
  ).merge(style),
  actionStyle: uiIconButtonStyle(
    variant: .ghost,
    size: .size2,
    style: IconButtonStyler()
        .icon(.color(UiTokens.gray11()))
        .merge(actionStyle),
  ),
  selectedActionStyle: IconButtonStyler()
      .color(UiTokens.grayA3())
      .icon(.color(UiTokens.gray12()))
      .onHovered(.color(UiTokens.grayA4()))
      .onPressed(.color(UiTokens.grayA4()))
      .merge(selectedActionStyle),
);

/// How far the action buttons shift left: the 8px between a 32px
/// button's edge and its 16px glyph.
const _actionsHang = 8.0;
