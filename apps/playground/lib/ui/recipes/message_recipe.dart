import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../components/card.dart';
import '../components/message.dart';

/// Styles for a message: a card and a ghost button that expands a long message.
@immutable
final class PlaygroundAgentMessageRecipe {
  const PlaygroundAgentMessageRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.collapsibleStyle,
    required this.toggleStyle,
  });

  /// Styles for the message row, avatar, header, body and footer.
  final PlaygroundMessageStyler style;

  /// Styles for the card the message sits in.
  final CardStyler surfaceStyle;

  /// Styles for the collapsed height and clipping of a long message.
  final PlaygroundMessageCollapsibleStyler collapsibleStyle;

  /// Styles for the button that expands or collapses a long message.
  final ButtonStyler toggleStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
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
  surfaceStyle: playgroundCardStyle(
    style: CardStyler()
        .padding(.symmetric(horizontal: 16, vertical: 12))
        .merge(surfaceStyle),
  ),
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
