import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/message.dart';

import '../components/button.dart';
import '../components/card.dart';

@immutable
final class VanillaAgentMessageRecipe {
  const VanillaAgentMessageRecipe({
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

VanillaAgentMessageRecipe vanillaAgentMessageRecipe({
  AgentMessageStyler style = const AgentMessageStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  AgentMessageCollapsibleStyler collapsibleStyle =
      const AgentMessageCollapsibleStyler.create(),
  ButtonStyler toggleStyle = const ButtonStyler.create(),
}) => VanillaAgentMessageRecipe(
  style: AgentMessageStyler(
    row: FlexBoxStyler().mainAxisSize(.max).spacing(8),
    avatar: BoxStyler().size(28, 28),
    header: BoxStyler().padding(.bottom(6)),
    body: BoxStyler(),
    footer: BoxStyler().padding(.top(4)),
    maxWidth: 640,
  ).merge(style),
  surfaceStyle: vanillaCardStyle(
    style: CardStyler()
        .padding(.symmetric(horizontal: 16, vertical: 12))
        .merge(surfaceStyle),
  ),
  collapsibleStyle: AgentMessageCollapsibleStyler(
    collapsedHeight: 72,
    container: BoxStyler(),
    clipped: BoxStyler(),
  ).merge(collapsibleStyle),
  toggleStyle: vanillaButtonStyle(
    variant: .ghost,
    size: .small,
    style: toggleStyle,
  ),
);
