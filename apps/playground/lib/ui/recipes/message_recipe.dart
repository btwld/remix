import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../components/message.dart';
import '../theme/tokens.dart';

@immutable
final class PlaygroundAgentMessageRecipe {
  const PlaygroundAgentMessageRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.collapsibleStyle,
    required this.toggleStyle,
  });
  final PlaygroundMessageStyler style;
  final CardStyler surfaceStyle;
  final PlaygroundMessageCollapsibleStyler collapsibleStyle;
  final ButtonStyler toggleStyle;
}

PlaygroundAgentMessageRecipe playgroundAgentMessageRecipe({
  PlaygroundMessageStyler style = const PlaygroundMessageStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  PlaygroundMessageCollapsibleStyler collapsibleStyle =
      const PlaygroundMessageCollapsibleStyler.create(),
  ButtonStyler toggleStyle = const ButtonStyler.create(),
}) => PlaygroundAgentMessageRecipe(
  style: PlaygroundMessageStyler(
    row: FlexBoxStyler().mainAxisSize(.max).spacing(8),
    avatar: BoxStyler().size(28, 28),
    header: BoxStyler().padding(.bottom(6)),
    body: BoxStyler(),
    footer: BoxStyler().padding(.top(4)),
    maxWidth: 640,
  ).merge(style),
  // A muted bubble without a frame or shadow: the reader's own words, set
  // apart from the agent's work by fill rather than by another card.
  // Built without the card's frame and shadow rather than merged over them.
  surfaceStyle: CardStyler()
      .color(PlaygroundTokens.muted())
      .borderRadius(.all(PlaygroundTokens.radiusXl()))
      .padding(.symmetric(horizontal: 16, vertical: 12))
      .merge(surfaceStyle),
  collapsibleStyle: PlaygroundMessageCollapsibleStyler(
    collapsedHeight: 72,
    container: BoxStyler(),
    clipped: BoxStyler(),
  ).merge(collapsibleStyle),
  toggleStyle: playgroundButtonStyle(
    variant: .ghost,
    size: .small,
    style: toggleStyle,
  ),
);
