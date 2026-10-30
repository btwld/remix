import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../theme/theme.dart';
import '../../agent/components/message.dart';

import '../components/button.dart';
import '../components/card.dart';

@immutable
final class FortalAgentMessageRecipe {
  const FortalAgentMessageRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.collapsibleStyle,
    required this.toggleStyle,
  });
  final AgentMessageStyler style;
  final CardStyler surfaceStyle;
  final AgentMessageCollapsibleStyler collapsibleStyle;
  final ButtonStyler toggleStyle;
}

FortalAgentMessageRecipe fortalAgentMessageRecipe({
  AgentMessageStyler style = const AgentMessageStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  AgentMessageCollapsibleStyler collapsibleStyle =
      const AgentMessageCollapsibleStyler.create(),
  ButtonStyler toggleStyle = const ButtonStyler.create(),
}) => FortalAgentMessageRecipe(
  style: AgentMessageStyler(
    row: FlexBoxStyler().mainAxisSize(.max).spacing(FortalTokens.space2()),
    avatar: BoxStyler().size(
      FortalTokens.messageAvatarSize(),
      FortalTokens.messageAvatarSize(),
    ),
    header: BoxStyler().padding(.bottom(FortalTokens.space2())),
    body: BoxStyler(),
    footer: BoxStyler().padding(.top(FortalTokens.space1())),
    maxWidth: FortalTokens.messageContentMaxWidth(),
  ).merge(style),
  surfaceStyle: fortalCardStyle(style: surfaceStyle),
  collapsibleStyle: AgentMessageCollapsibleStyler(
    collapsedHeight: FortalTokens.messageCollapsedHeight(),
    container: BoxStyler(),
    clipped: BoxStyler(),
  ).merge(collapsibleStyle),
  toggleStyle: fortalButtonStyle(
    variant: .ghost,
    size: .size1,
    style: toggleStyle,
  ),
);
