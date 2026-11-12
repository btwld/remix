import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/answer.dart';
import '../components/disclosure.dart';
import '../components/icon_button.dart';
import '../theme/tokens.dart';

@immutable
final class PlaygroundAgentAnswerRecipe {
  const PlaygroundAgentAnswerRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.sourcesStyle,
    required this.copyStyle,
    required this.retryStyle,
  });
  final PlaygroundAnswerStyler style;
  final CardStyler surfaceStyle;
  final DisclosureStyler sourcesStyle;
  final IconButtonStyler copyStyle;
  final IconButtonStyler retryStyle;
}

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
    // The actions row centres its children; a top inset here dropped the
    // feedback below the icons beside it.
    feedback: BoxStyler(),
    sourcesLabel: TextStyler()
        .color(PlaygroundTokens.foreground())
        .fontSize(13),
    indicator: IconStyler().color(PlaygroundTokens.foreground()).size(16),
  ).merge(style),
  // The answer is the conversation itself, so it sits on the page as prose,
  // aligned with the transcript, rather than in a card like the work around it.
  // No fill, frame or shadow: a card's shadow would show through as a gray
  // wash behind a transparent fill.
  surfaceStyle: CardStyler().merge(surfaceStyle),
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
