import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/card.dart';
import '../components/disclosure.dart';
import '../components/execution.dart';
import '../components/icon_button.dart';
import '../theme/theme.dart';

@immutable
final class UiAgentExecutionRecipe {
  const UiAgentExecutionRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.disclosureStyle,
    required this.copyStyle,
    required this.retryStyle,
  });
  final UiExecutionStyler style;
  final CardStyler surfaceStyle;
  final DisclosureStyler disclosureStyle;
  final IconButtonStyler copyStyle;
  final IconButtonStyler retryStyle;
}

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
    // Long output scrolls inside the well instead of growing the card.
    viewport: BoxStyler().maxHeight(UiTokens.executionOutputMaxHeight()),
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
    // The status mark takes its outcome's color from the status box below;
    // its glyph and label already name the outcome.
    statusIcon: IconStyler().size(UiTokens.space3()),
    indicator: IconStyler().color(UiTokens.gray12()).size(UiTokens.space4()),
    runningStatus: _statusMark(UiTokens.accentIndicator),
    successStatus: _statusMark(UiTokens.accentIndicator),
    errorStatus: _statusMark(UiTokens.error11),
    cancelledStatus: _statusMark(UiTokens.gray11),
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

BoxStyler _statusMark(ColorToken color) =>
    BoxStyler().wrap(.iconTheme(color: color()));
