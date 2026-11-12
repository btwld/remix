import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/answer.dart';
import '../components/card.dart';
import '../components/disclosure.dart';
import '../components/icon_button.dart';
import '../theme/theme.dart';

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
    actions: FlexBoxStyler()
        .spacing(UiTokens.space2())
        .padding(.top(UiTokens.space3())),
    // The actions row centres its children; a top inset here dropped the
    // feedback below the icons beside it.
    feedback: BoxStyler().wrap(
      .defaultText(
        TextStyler().color(UiTokens.gray11()).style(UiTokens.text1.mix()),
      ),
    ),
    sourcesLabel: TextStyler()
        .color(UiTokens.gray12())
        .style(UiTokens.text2.mix()),
    indicator: IconStyler().color(UiTokens.gray12()).size(UiTokens.space4()),
  ).merge(style),
  // The answer is the conversation itself, so it sits on the page as prose,
  // aligned with the transcript, rather than in a card like the work around it.
  surfaceStyle: uiCardStyle(
    variant: .ghost,
    style: CardStyler()
        .margin(.all(0))
        .padding(.all(0))
        .onHovered(.color(const Color(0x00000000)))
        .onPressed(.color(const Color(0x00000000)))
        .merge(surfaceStyle),
  ),
  // Sources reads as a quiet line under the answer, not a field.
  sourcesStyle: uiDisclosureStyle(
    size: .size1,
    style: DisclosureStyler()
        .container(
          BoxStyler()
              .margin(.top(UiTokens.space2()))
              .color(const Color(0x00000000))
              .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
        )
        .trigger(
          BoxStyler().color(const Color(0x00000000)).padding(.horizontal(0)),
        )
        .content(
          BoxStyler()
              .padding(.fromLTRB(0, UiTokens.space1(), 0, 0))
              .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
        )
        .onHovered(.trigger(.color(const Color(0x00000000))))
        .onPressed(.trigger(.color(const Color(0x00000000))))
        .merge(sourcesStyle),
  ),
  copyStyle: uiIconButtonStyle(variant: .ghost, size: .size1, style: copyStyle),
  retryStyle: uiIconButtonStyle(
    variant: .ghost,
    size: .size1,
    style: retryStyle,
  ),
);
