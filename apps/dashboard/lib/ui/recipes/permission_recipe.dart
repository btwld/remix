import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../components/card.dart';
import '../components/data_list.dart';
import '../components/disclosure.dart';
import '../components/permission.dart';
import '../theme/theme.dart';

@immutable
final class UiAgentPermissionRecipe {
  const UiAgentPermissionRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.detailsStyle,
    required this.parametersStyle,
    required this.allowOnceStyle,
    required this.alwaysAllowStyle,
    required this.denyStyle,
  });
  final UiPermissionStyler style;
  final CardStyler surfaceStyle;
  final DisclosureStyler detailsStyle;
  final DataListStyler parametersStyle;
  final ButtonStyler allowOnceStyle;
  final ButtonStyler alwaysAllowStyle;
  final ButtonStyler denyStyle;
}

UiAgentPermissionRecipe uiAgentPermissionRecipe({
  UiPermissionStyler style = const UiPermissionStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  DisclosureStyler detailsStyle = const DisclosureStyler.create(),
  DataListStyler parametersStyle = const DataListStyler.create(),
  ButtonStyler allowOnceStyle = const ButtonStyler.create(),
  ButtonStyler alwaysAllowStyle = const ButtonStyler.create(),
  ButtonStyler denyStyle = const ButtonStyler.create(),
}) => UiAgentPermissionRecipe(
  style: UiPermissionStyler(
    header: FlexBoxStyler()
        .spacing(UiTokens.space2())
        .crossAxisAlignment(.center),
    // Decisions sit at the trailing edge with the primary last, like Ui
    // dialog actions.
    actions: FlexBoxStyler()
        .mainAxisAlignment(.end)
        .spacing(UiTokens.space2())
        .padding(.top(UiTokens.space2())),
    title: TextStyler()
        .color(UiTokens.gray12())
        .fontWeight(UiTokens.fontWeightSemibold()),
    tool: TextStyler()
        .color(UiTokens.gray11())
        .style(UiTokens.text1.mix())
        .fontFamily('Menlo')
        .fontFamilyFallback(const [
          'Consolas',
          'Bitstream Vera Sans Mono',
          'monospace',
        ])
        .wrap(.padding(.top(UiTokens.space1()))),
    description: TextStyler()
        .color(UiTokens.gray11())
        .wrap(.padding(.vertical(UiTokens.space2()))),
    status: TextStyler().color(UiTokens.gray11()).style(UiTokens.text1.mix()),
    detailsLabel: TextStyler()
        .color(UiTokens.gray12())
        .style(UiTokens.text2.mix()),
    toolIcon: IconStyler().color(UiTokens.gray12()).size(UiTokens.space4()),
    // The status mark takes its outcome's color from the status box below;
    // its glyph and label already name the outcome.
    statusIcon: IconStyler().size(UiTokens.space3()),
    indicator: IconStyler().color(UiTokens.gray12()).size(UiTokens.space4()),
    // While it waits, the status is an amber badge: attention that does not
    // depend on the accent, which may be gray.
    pendingStatus: _attentionBadge(),
    decidingStatus: _attentionBadge(),
    allowedStatus: _statusMark(UiTokens.accentIndicator),
    runningStatus: _statusMark(UiTokens.accentIndicator),
    completedStatus: _statusMark(UiTokens.accentIndicator),
    deniedStatus: _statusMark(UiTokens.gray11),
    errorStatus: _statusMark(UiTokens.error11),
  ).merge(style),
  // The one card in a turn that waits on the reader: an accent tint and
  // frame mark it. Ui keeps elevation for floating layers, so emphasis
  // comes from color, not a shadow.
  surfaceStyle: uiCardStyle(
    size: .size2,
    style: CardStyler()
        .color(UiTokens.accent2())
        .border(.all(.color(UiTokens.accent8())))
        .onHovered(.border(.all(.color(UiTokens.accent8()))))
        .merge(surfaceStyle),
  ),
  // Details read as a quiet line, not a field inside the card.
  detailsStyle: uiDisclosureStyle(
    size: .size1,
    style: DisclosureStyler()
        .container(
          BoxStyler()
              .margin(.top(UiTokens.space1()))
              .color(const Color(0x00000000))
              .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
        )
        .trigger(
          BoxStyler().color(const Color(0x00000000)).padding(.horizontal(0)),
        )
        .content(
          BoxStyler()
              .padding(.horizontal(0))
              .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
        )
        .onHovered(.trigger(.color(const Color(0x00000000))))
        .onPressed(.trigger(.color(const Color(0x00000000))))
        .merge(detailsStyle),
  ),
  parametersStyle: uiDataListStyle(style: parametersStyle),
  allowOnceStyle: uiButtonStyle(style: allowOnceStyle),
  alwaysAllowStyle: uiButtonStyle(variant: .outline, style: alwaysAllowStyle),
  denyStyle: uiButtonStyle(variant: .ghost, style: denyStyle),
);

BoxStyler _statusMark(ColorToken color) =>
    BoxStyler().wrap(.iconTheme(color: color()));

BoxStyler _attentionBadge() => BoxStyler()
    .color(UiTokens.attention3())
    .borderRadius(.all(UiTokens.radiusFull()))
    .padding(.symmetric(horizontal: UiTokens.space2(), vertical: 2))
    .wrap(.iconTheme(color: UiTokens.attention11()))
    .wrap(.defaultText(TextStyler().color(UiTokens.attention11())));
