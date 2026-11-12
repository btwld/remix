import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/execution.dart';

import '../components/card.dart';
import '../components/disclosure.dart';
import '../components/icon_button.dart';
import '../theme/theme.dart';

/// Styles for the execution surface: a card, a disclosure for its output, and
/// ghost icon buttons for copy and retry.
@immutable
final class FortalAgentExecutionRecipe {
  const FortalAgentExecutionRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.disclosureStyle,
    required this.copyStyle,
    required this.retryStyle,
  });

  /// Styles for the header, output, actions, text and icons of an execution.
  final AgentExecutionStyler style;

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
FortalAgentExecutionRecipe fortalAgentExecutionRecipe({
  AgentExecutionStyler style = const AgentExecutionStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
  IconButtonStyler copyStyle = const IconButtonStyler.create(),
  IconButtonStyler retryStyle = const IconButtonStyler.create(),
}) => FortalAgentExecutionRecipe(
  style: AgentExecutionStyler(
    header: FlexBoxStyler()
        .spacing(FortalTokens.space2())
        .crossAxisAlignment(.center),
    output: BoxStyler()
        .color(FortalTokens.gray3())
        .borderRadius(.all(FortalTokens.radius3()))
        .padding(.all(FortalTokens.space3())),
    actions: FlexBoxStyler()
        .spacing(FortalTokens.space2())
        .padding(.top(FortalTokens.space3())),
    tool: TextStyler()
        .color(FortalTokens.gray11())
        .style(FortalTokens.text1.mix()),
    title: TextStyler()
        .color(FortalTokens.gray12())
        .fontWeight(FortalTokens.fontWeightSemibold()),
    meta: TextStyler()
        .color(FortalTokens.gray11())
        .style(FortalTokens.text1.mix()),
    status: TextStyler()
        .color(FortalTokens.gray11())
        .style(FortalTokens.text1.mix()),
    toolIcon: IconStyler()
        .color(FortalTokens.gray12())
        .size(FortalTokens.space4()),
    statusIcon: IconStyler()
        .color(FortalTokens.accentIndicator())
        .size(FortalTokens.space3()),
    indicator: IconStyler()
        .color(FortalTokens.gray12())
        .size(FortalTokens.space4()),
  ).merge(style),
  surfaceStyle: fortalCardStyle(size: .size2, style: surfaceStyle),
  disclosureStyle: fortalDisclosureStyle(
    style: DisclosureStyler()
        .container(
          BoxStyler()
              .color(const Color(0x00000000))
              .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
        )
        .trigger(BoxStyler().color(const Color(0x00000000)).padding(.all(0)))
        .content(
          BoxStyler()
              .padding(
                .fromLTRB(0, FortalTokens.space3(), 0, FortalTokens.space1()),
              )
              .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
        )
        .onHovered(.trigger(.color(const Color(0x00000000))))
        .onPressed(.trigger(.color(const Color(0x00000000))))
        .merge(disclosureStyle),
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
