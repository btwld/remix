import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/execution.dart';

import '../components/card.dart';
import '../components/disclosure.dart';
import '../components/icon_button.dart';
import '../theme/theme.dart';

@immutable
final class FortalAgentExecutionRecipe {
  const FortalAgentExecutionRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.disclosureStyle,
    required this.copyStyle,
    required this.retryStyle,
  });
  final AgentExecutionStyler style;
  final CardStyler surfaceStyle;
  final DisclosureStyler disclosureStyle;
  final IconButtonStyler copyStyle;
  final IconButtonStyler retryStyle;
}

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
    // Long output scrolls inside the well instead of growing the card.
    viewport: BoxStyler().maxHeight(FortalTokens.executionOutputMaxHeight()),
    actions: FlexBoxStyler()
        .spacing(FortalTokens.space2())
        .padding(.top(FortalTokens.space3())),
    // The tool is an identifier, so it is set in Fortal's code face.
    tool: TextStyler()
        .color(FortalTokens.gray11())
        .style(FortalTokens.text1.mix())
        .fontFamily('Menlo')
        .fontFamilyFallback(const [
          'Consolas',
          'Bitstream Vera Sans Mono',
          'monospace',
        ]),
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
    // The status mark takes its outcome's color from the status box below;
    // its glyph and label already name the outcome.
    statusIcon: IconStyler().size(FortalTokens.space3()),
    indicator: IconStyler()
        .color(FortalTokens.gray12())
        .size(FortalTokens.space4()),
    runningStatus: _statusMark(FortalTokens.accentIndicator),
    successStatus: _statusMark(FortalTokens.accentIndicator),
    errorStatus: _statusMark(FortalTokens.error11),
    cancelledStatus: _statusMark(FortalTokens.gray11),
  ).merge(style),
  // A compact row with a hairline frame: a tool call is a record of work,
  // lighter than the decision cards around it.
  surfaceStyle: fortalCardStyle(style: surfaceStyle),
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

BoxStyler _statusMark(ColorToken color) =>
    BoxStyler().wrap(.iconTheme(color: color()));
