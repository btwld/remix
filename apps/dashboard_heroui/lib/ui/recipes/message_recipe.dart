import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../components/card.dart';
import '../components/message.dart';

/// Styles for a message: a HeroUI card and a ghost `sm` button that expands a
/// long message.
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
    row: FlexBoxStyler().mainAxisSize(.max).spacing(8),
    avatar: BoxStyler().size(28, 28),
    header: BoxStyler().padding(.bottom(6)),
    body: BoxStyler(),
    footer: BoxStyler().padding(.top(4)),
    maxWidth: 640,
  ).merge(style),
  surfaceStyle: uiCardStyle(
    style: CardStyler()
        .padding(.symmetric(horizontal: 16, vertical: 12))
        .merge(surfaceStyle),
  ),
  collapsibleStyle: UiMessageCollapsibleStyler(
    collapsedHeight: 72,
    container: BoxStyler(),
    clipped: BoxStyler(),
  ).merge(collapsibleStyle),
  toggleStyle: uiButtonStyle(variant: .ghost, size: .sm, style: toggleStyle),
);
