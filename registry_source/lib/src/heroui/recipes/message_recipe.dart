import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/message.dart';

import '../components/button.dart';
import '../components/card.dart';

/// Styles for a message: a HeroUI card and a ghost `sm` button that expands a
/// long message.
@immutable
final class HeroUiAgentMessageRecipe {
  const HeroUiAgentMessageRecipe({
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
HeroUiAgentMessageRecipe heroUiAgentMessageRecipe({
  AgentMessageStyler style = const AgentMessageStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  AgentMessageCollapsibleStyler collapsibleStyle =
      const AgentMessageCollapsibleStyler.create(),
  ButtonStyler toggleStyle = const ButtonStyler.create(),
}) => HeroUiAgentMessageRecipe(
  style: AgentMessageStyler(
    row: FlexBoxStyler().mainAxisSize(.max).spacing(8),
    avatar: BoxStyler().size(28, 28),
    header: BoxStyler().padding(.bottom(6)),
    body: BoxStyler(),
    footer: BoxStyler().padding(.top(4)),
    maxWidth: 640,
  ).merge(style),
  surfaceStyle: heroUiCardStyle(
    style: CardStyler()
        .padding(.symmetric(horizontal: 16, vertical: 12))
        .merge(surfaceStyle),
  ),
  collapsibleStyle: AgentMessageCollapsibleStyler(
    collapsedHeight: 72,
    container: BoxStyler(),
    clipped: BoxStyler(),
  ).merge(collapsibleStyle),
  toggleStyle: heroUiButtonStyle(
    variant: .ghost,
    size: .sm,
    style: toggleStyle,
  ),
);
