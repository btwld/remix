import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/answer.dart';
import '../components/button.dart';
import '../components/card.dart';
import '../components/disclosure.dart';
import '../theme/theme.dart';

/// Styles for the answer surface: a HeroUI card, a disclosure for its
/// sources, and ghost `sm` icon buttons for copy and retry.
@immutable
final class UiAgentAnswerRecipe {
  const UiAgentAnswerRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.sourcesStyle,
    required this.copyStyle,
    required this.retryStyle,
  });
  final UiAnswerStyler style;
  final CardStyler surfaceStyle;
  final DisclosureStyler sourcesStyle;
  final IconButtonStyler copyStyle;
  final IconButtonStyler retryStyle;
}

UiAgentAnswerRecipe uiAgentAnswerRecipe({
  UiAnswerStyler style = const UiAnswerStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  DisclosureStyler sourcesStyle = const DisclosureStyler.create(),
  IconButtonStyler copyStyle = const IconButtonStyler.create(),
  IconButtonStyler retryStyle = const IconButtonStyler.create(),
}) => UiAgentAnswerRecipe(
  style: UiAnswerStyler(
    body: BoxStyler(),
    actions: FlexBoxStyler().spacing(4).padding(.top(8)),
    feedback: BoxStyler().padding(.top(6)),
    sourcesLabel: TextStyler()
        .style(UiTokens.textSm.mix())
        .color(UiTokens.foreground()),
    indicator: IconStyler().color(UiTokens.foreground()).size(16),
  ).merge(style),
  surfaceStyle: uiCardStyle(style: surfaceStyle),
  sourcesStyle: uiDisclosureStyle(
    style: DisclosureStyler()
        .container(BoxStyler().margin(.top(4)))
        .padding(.symmetric(vertical: 10))
        .content(BoxStyler().padding(.bottom(8)))
        .merge(sourcesStyle),
  ),
  copyStyle: uiIconButtonStyle(variant: .ghost, size: .sm, style: copyStyle),
  retryStyle: uiIconButtonStyle(variant: .ghost, size: .sm, style: retryStyle),
);
