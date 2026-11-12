import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../theme/theme.dart';
import '../../agent/components/message.dart';

import '../components/button.dart';
import '../components/card.dart';

/// Styles for a message: a card and a ghost button that expands a long message.
@immutable
final class FortalAgentMessageRecipe {
  const FortalAgentMessageRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.collapsibleStyle,
    required this.toggleStyle,
  });

  /// Styles for the message row, avatar, header, body and footer.
  final AgentMessageStyler style;

  /// Styles for the card the message sits in.
  final CardStyler surfaceStyle;

  /// Styles for the collapsed height and clipping of a long message.
  final AgentMessageCollapsibleStyler collapsibleStyle;

  /// Styles for the button that expands or collapses a long message.
  final ButtonStyler toggleStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
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
