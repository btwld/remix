import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/answer.dart';

import '../components/card.dart';
import '../components/disclosure.dart';
import '../components/icon_button.dart';
import '../theme/theme.dart';

/// Styles for the answer surface: a card, a disclosure for its sources, and
/// ghost icon buttons for copy and retry.
@immutable
final class FortalAgentAnswerRecipe {
  const FortalAgentAnswerRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.sourcesStyle,
    required this.copyStyle,
    required this.retryStyle,
  });

  /// Styles for the answer body, actions and feedback.
  final AgentAnswerStyler style;

  /// Styles for the card the answer sits in.
  final CardStyler surfaceStyle;

  /// Styles for the disclosure that lists the sources.
  final DisclosureStyler sourcesStyle;

  /// Styles for the copy icon button.
  final IconButtonStyler copyStyle;

  /// Styles for the retry icon button.
  final IconButtonStyler retryStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
FortalAgentAnswerRecipe fortalAgentAnswerRecipe({
  AgentAnswerStyler style = const AgentAnswerStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  DisclosureStyler sourcesStyle = const DisclosureStyler.create(),
  IconButtonStyler copyStyle = const IconButtonStyler.create(),
  IconButtonStyler retryStyle = const IconButtonStyler.create(),
}) => FortalAgentAnswerRecipe(
  style: AgentAnswerStyler(
    body: BoxStyler(),
    actions: FlexBoxStyler()
        .spacing(FortalTokens.space2())
        .padding(.top(FortalTokens.space3())),
    feedback: BoxStyler().padding(.top(FortalTokens.space2())),
    sourcesLabel: TextStyler()
        .color(FortalTokens.gray12())
        .style(FortalTokens.text2.mix()),
    indicator: IconStyler()
        .color(FortalTokens.gray12())
        .size(FortalTokens.space4()),
  ).merge(style),
  surfaceStyle: fortalCardStyle(size: .size2, style: surfaceStyle),
  sourcesStyle: fortalDisclosureStyle(
    size: .size1,
    style: DisclosureStyler()
        .container(BoxStyler().margin(.top(FortalTokens.space3())))
        .merge(sourcesStyle),
  ),
  copyStyle: fortalIconButtonStyle(
    variant: .ghost,
    size: .size1,
    style: copyStyle,
  ),
  retryStyle: fortalIconButtonStyle(
    variant: .ghost,
    size: .size1,
    style: retryStyle,
  ),
);
