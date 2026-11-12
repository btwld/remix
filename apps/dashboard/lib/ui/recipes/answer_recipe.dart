import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/answer.dart';
import '../components/card.dart';
import '../components/disclosure.dart';
import '../components/icon_button.dart';
import '../theme/theme.dart';

/// Styles for the answer surface: a card, a disclosure for its sources, and
/// ghost icon buttons for copy and retry.
@immutable
final class UiAgentAnswerRecipe {
  const UiAgentAnswerRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.sourcesStyle,
    required this.copyStyle,
    required this.retryStyle,
  });

  /// Styles for the answer body, actions and feedback.
  final UiAnswerStyler style;

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
UiAgentAnswerRecipe uiAgentAnswerRecipe({
  UiAnswerStyler style = const UiAnswerStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  DisclosureStyler sourcesStyle = const DisclosureStyler.create(),
  IconButtonStyler copyStyle = const IconButtonStyler.create(),
  IconButtonStyler retryStyle = const IconButtonStyler.create(),
}) => UiAgentAnswerRecipe(
  style: UiAnswerStyler(
    body: BoxStyler(),
    actions: FlexBoxStyler()
        .spacing(UiTokens.space2())
        .padding(.top(UiTokens.space3())),
    feedback: BoxStyler().padding(.top(UiTokens.space2())),
    sourcesLabel: TextStyler()
        .color(UiTokens.gray12())
        .style(UiTokens.text2.mix()),
    indicator: IconStyler().color(UiTokens.gray12()).size(UiTokens.space4()),
  ).merge(style),
  surfaceStyle: uiCardStyle(size: .size2, style: surfaceStyle),
  sourcesStyle: uiDisclosureStyle(
    size: .size1,
    style: DisclosureStyler()
        .container(BoxStyler().margin(.top(UiTokens.space3())))
        .merge(sourcesStyle),
  ),
  copyStyle: uiIconButtonStyle(variant: .ghost, size: .size1, style: copyStyle),
  retryStyle: uiIconButtonStyle(
    variant: .ghost,
    size: .size1,
    style: retryStyle,
  ),
);
