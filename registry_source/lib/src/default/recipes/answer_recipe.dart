import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/answer.dart';

import '../components/card.dart';
import '../components/disclosure.dart';
import '../components/icon_button.dart';
import '../theme/tokens.dart';

@immutable
final class VanillaAgentAnswerRecipe {
  const VanillaAgentAnswerRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.sourcesStyle,
    required this.copyStyle,
    required this.retryStyle,
  });
  final AgentAnswerStyler style;
  final CardStyler surfaceStyle;
  final DisclosureStyler sourcesStyle;
  final IconButtonStyler copyStyle;
  final IconButtonStyler retryStyle;
}

VanillaAgentAnswerRecipe vanillaAgentAnswerRecipe({
  AgentAnswerStyler style = const AgentAnswerStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  DisclosureStyler sourcesStyle = const DisclosureStyler.create(),
  IconButtonStyler copyStyle = const IconButtonStyler.create(),
  IconButtonStyler retryStyle = const IconButtonStyler.create(),
}) => VanillaAgentAnswerRecipe(
  style: AgentAnswerStyler(
    body: BoxStyler(),
    actions: FlexBoxStyler().spacing(6).padding(.top(8)),
    feedback: BoxStyler().padding(.top(6)),
    sourcesLabel: TextStyler().color(VanillaTokens.foreground()).fontSize(13),
    indicator: IconStyler().color(VanillaTokens.foreground()).size(16),
  ).merge(style),
  surfaceStyle: vanillaCardStyle(
    style: CardStyler().padding(.all(VanillaTokens.s4)).merge(surfaceStyle),
  ),
  sourcesStyle: vanillaDisclosureStyle(
    style: DisclosureStyler()
        .container(BoxStyler().margin(.top(4)))
        .padding(.symmetric(vertical: 10))
        .content(BoxStyler().padding(.bottom(VanillaTokens.s2)))
        .merge(sourcesStyle),
  ),
  copyStyle: vanillaIconButtonStyle(
    variant: .ghost,
    size: .small,
    style: IconButtonStyler().size(28, 28).merge(copyStyle),
  ),
  retryStyle: vanillaIconButtonStyle(
    variant: .ghost,
    size: .small,
    style: IconButtonStyler().size(28, 28).merge(retryStyle),
  ),
);
