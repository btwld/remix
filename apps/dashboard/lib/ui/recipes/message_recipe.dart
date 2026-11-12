import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../components/card.dart';
import '../components/message.dart';
import '../theme/theme.dart';

@immutable
final class UiAgentMessageRecipe {
  const UiAgentMessageRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.collapsibleStyle,
    required this.toggleStyle,
  });
  final UiMessageStyler style;
  final CardStyler surfaceStyle;
  final UiMessageCollapsibleStyler collapsibleStyle;
  final ButtonStyler toggleStyle;
}

UiAgentMessageRecipe uiAgentMessageRecipe({
  UiMessageStyler style = const UiMessageStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  UiMessageCollapsibleStyler collapsibleStyle =
      const UiMessageCollapsibleStyler.create(),
  ButtonStyler toggleStyle = const ButtonStyler.create(),
}) => UiAgentMessageRecipe(
  style: UiMessageStyler(
    row: FlexBoxStyler().mainAxisSize(.max).spacing(UiTokens.space2()),
    avatar: BoxStyler().size(
      UiTokens.messageAvatarSize(),
      UiTokens.messageAvatarSize(),
    ),
    header: BoxStyler().padding(.bottom(UiTokens.space2())),
    body: BoxStyler(),
    footer: BoxStyler().padding(.top(UiTokens.space1())),
    maxWidth: UiTokens.messageContentMaxWidth(),
  ).merge(style),
  // A filled bubble without a frame: the reader's own words, set apart
  // from the agent's work by fill rather than by another bordered card.
  surfaceStyle: uiCardStyle(
    size: .size2,
    style: CardStyler()
        .color(UiTokens.grayA3())
        .border(BoxBorderMix.none)
        .onHovered(CardStyler().border(BoxBorderMix.none))
        .merge(surfaceStyle),
  ),
  collapsibleStyle: UiMessageCollapsibleStyler(
    collapsedHeight: UiTokens.messageCollapsedHeight(),
    container: BoxStyler(),
    clipped: BoxStyler(),
  ).merge(collapsibleStyle),
  toggleStyle: uiButtonStyle(variant: .ghost, size: .size1, style: toggleStyle),
);
