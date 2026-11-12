import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/answer.dart';
import '../components/card.dart';
import '../components/disclosure.dart';
import '../components/icon_button.dart';
import '../theme/tokens.dart';

/// Styles for the answer surface: a card, a disclosure for its sources, and
/// ghost icon buttons for copy and retry.
@immutable
final class PlaygroundAgentAnswerRecipe {
  const PlaygroundAgentAnswerRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.sourcesStyle,
    required this.copyStyle,
    required this.retryStyle,
  });

  /// Styles for the answer body, actions and feedback.
  final PlaygroundAnswerStyler style;

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
PlaygroundAgentAnswerRecipe playgroundAgentAnswerRecipe({
  PlaygroundAnswerStyler style = const PlaygroundAnswerStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  DisclosureStyler sourcesStyle = const DisclosureStyler.create(),
  IconButtonStyler copyStyle = const IconButtonStyler.create(),
  IconButtonStyler retryStyle = const IconButtonStyler.create(),
}) => PlaygroundAgentAnswerRecipe(
  style: PlaygroundAnswerStyler(
    body: BoxStyler(),
    actions: FlexBoxStyler().spacing(6).padding(.top(8)),
    feedback: BoxStyler().padding(.top(6)),
    sourcesLabel: TextStyler()
        .color(PlaygroundTokens.foreground())
        .fontSize(13),
    indicator: IconStyler().color(PlaygroundTokens.foreground()).size(16),
  ).merge(style),
  surfaceStyle: playgroundCardStyle(
    style: CardStyler().padding(.all(PlaygroundTokens.s4)).merge(surfaceStyle),
  ),
  sourcesStyle: playgroundDisclosureStyle(
    style: DisclosureStyler()
        .container(BoxStyler().margin(.top(4)))
        .padding(.symmetric(vertical: 10))
        .content(BoxStyler().padding(.bottom(PlaygroundTokens.s2)))
        .merge(sourcesStyle),
  ),
  copyStyle: playgroundIconButtonStyle(
    variant: .ghost,
    size: .small,
    style: IconButtonStyler().size(28, 28).merge(copyStyle),
  ),
  retryStyle: playgroundIconButtonStyle(
    variant: .ghost,
    size: .small,
    style: IconButtonStyler().size(28, 28).merge(retryStyle),
  ),
);
