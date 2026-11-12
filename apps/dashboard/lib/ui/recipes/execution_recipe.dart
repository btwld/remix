import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/card.dart';
import '../components/disclosure.dart';
import '../components/execution.dart';
import '../components/icon_button.dart';
import '../theme/theme.dart';

/// Styles for the execution surface: a card, a disclosure for its output, and
/// ghost icon buttons for copy and retry.
@immutable
final class UiAgentExecutionRecipe {
  const UiAgentExecutionRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.disclosureStyle,
    required this.copyStyle,
    required this.retryStyle,
  });

  /// Styles for the header, output, actions, text and icons of an execution.
  final UiExecutionStyler style;

  /// Styles for the card the execution sits in.
  final CardStyler surfaceStyle;

  /// Styles for the disclosure that reveals the output.
  final DisclosureStyler disclosureStyle;

  /// Styles for the copy icon button.
  final IconButtonStyler copyStyle;

  /// Styles for the retry icon button.
  final IconButtonStyler retryStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
UiAgentExecutionRecipe uiAgentExecutionRecipe({
  UiExecutionStyler style = const UiExecutionStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
  IconButtonStyler copyStyle = const IconButtonStyler.create(),
  IconButtonStyler retryStyle = const IconButtonStyler.create(),
}) => UiAgentExecutionRecipe(
  style: UiExecutionStyler(
    header: FlexBoxStyler()
        .spacing(UiTokens.space2())
        .crossAxisAlignment(.center),
    output: BoxStyler()
        .color(UiTokens.gray3())
        .borderRadius(.all(UiTokens.radius3()))
        .padding(.all(UiTokens.space3())),
    actions: FlexBoxStyler()
        .spacing(UiTokens.space2())
        .padding(.top(UiTokens.space3())),
    tool: TextStyler().color(UiTokens.gray11()).style(UiTokens.text1.mix()),
    title: TextStyler()
        .color(UiTokens.gray12())
        .fontWeight(UiTokens.fontWeightSemibold()),
    meta: TextStyler().color(UiTokens.gray11()).style(UiTokens.text1.mix()),
    status: TextStyler().color(UiTokens.gray11()).style(UiTokens.text1.mix()),
    toolIcon: IconStyler().color(UiTokens.gray12()).size(UiTokens.space4()),
    statusIcon: IconStyler()
        .color(UiTokens.accentIndicator())
        .size(UiTokens.space3()),
    indicator: IconStyler().color(UiTokens.gray12()).size(UiTokens.space4()),
  ).merge(style),
  surfaceStyle: uiCardStyle(size: .size2, style: surfaceStyle),
  disclosureStyle: uiDisclosureStyle(
    style: DisclosureStyler()
        .container(
          BoxStyler()
              .color(const Color(0x00000000))
              .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
        )
        .trigger(BoxStyler().color(const Color(0x00000000)).padding(.all(0)))
        .content(
          BoxStyler()
              .padding(.fromLTRB(0, UiTokens.space3(), 0, UiTokens.space1()))
              .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
        )
        .onHovered(.trigger(.color(const Color(0x00000000))))
        .onPressed(.trigger(.color(const Color(0x00000000))))
        .merge(disclosureStyle),
  ),
  copyStyle: uiIconButtonStyle(variant: .ghost, size: .size1, style: copyStyle),
  retryStyle: uiIconButtonStyle(
    variant: .ghost,
    size: .size1,
    style: retryStyle,
  ),
);
