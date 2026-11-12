import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/permission.dart';

import '../components/button.dart';
import '../components/card.dart';
import '../components/data_list.dart';
import '../components/disclosure.dart';
import '../theme/theme.dart';

@immutable
final class FortalAgentPermissionRecipe {
  const FortalAgentPermissionRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.detailsStyle,
    required this.parametersStyle,
    required this.allowOnceStyle,
    required this.alwaysAllowStyle,
    required this.denyStyle,
  });
  final AgentPermissionStyler style;
  final CardStyler surfaceStyle;
  final DisclosureStyler detailsStyle;
  final DataListStyler parametersStyle;
  final ButtonStyler allowOnceStyle;
  final ButtonStyler alwaysAllowStyle;
  final ButtonStyler denyStyle;
}

FortalAgentPermissionRecipe fortalAgentPermissionRecipe({
  AgentPermissionStyler style = const AgentPermissionStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  DisclosureStyler detailsStyle = const DisclosureStyler.create(),
  DataListStyler parametersStyle = const DataListStyler.create(),
  ButtonStyler allowOnceStyle = const ButtonStyler.create(),
  ButtonStyler alwaysAllowStyle = const ButtonStyler.create(),
  ButtonStyler denyStyle = const ButtonStyler.create(),
}) => FortalAgentPermissionRecipe(
  style: AgentPermissionStyler(
    header: FlexBoxStyler()
        .spacing(FortalTokens.space2())
        .crossAxisAlignment(.center),
    // Decisions sit at the trailing edge with the primary last, like Fortal
    // dialog actions.
    actions: FlexBoxStyler()
        .mainAxisAlignment(.end)
        .spacing(FortalTokens.space2())
        .padding(.top(FortalTokens.space2())),
    title: TextStyler()
        .color(FortalTokens.gray12())
        .fontWeight(FortalTokens.fontWeightSemibold()),
    tool: TextStyler()
        .color(FortalTokens.gray11())
        .style(FortalTokens.text1.mix())
        .fontFamily('Menlo')
        .fontFamilyFallback(const [
          'Consolas',
          'Bitstream Vera Sans Mono',
          'monospace',
        ])
        .wrap(.padding(.top(FortalTokens.space1()))),
    description: TextStyler()
        .color(FortalTokens.gray11())
        .wrap(.padding(.vertical(FortalTokens.space2()))),
    status: TextStyler()
        .color(FortalTokens.gray11())
        .style(FortalTokens.text1.mix()),
    detailsLabel: TextStyler()
        .color(FortalTokens.gray12())
        .style(FortalTokens.text2.mix()),
    toolIcon: IconStyler()
        .color(FortalTokens.gray12())
        .size(FortalTokens.space4()),
    // The status mark takes its outcome's color from the status box below;
    // its glyph and label already name the outcome.
    statusIcon: IconStyler().size(FortalTokens.space3()),
    indicator: IconStyler()
        .color(FortalTokens.gray12())
        .size(FortalTokens.space4()),
    // While it waits, the status is an amber badge: attention that does not
    // depend on the accent, which may be gray.
    pendingStatus: _attentionBadge(),
    decidingStatus: _attentionBadge(),
    allowedStatus: _statusMark(FortalTokens.accentIndicator),
    runningStatus: _statusMark(FortalTokens.accentIndicator),
    completedStatus: _statusMark(FortalTokens.accentIndicator),
    deniedStatus: _statusMark(FortalTokens.gray11),
    errorStatus: _statusMark(FortalTokens.error11),
  ).merge(style),
  // The one card in a turn that waits on the reader: an accent tint and
  // frame mark it. Fortal keeps elevation for floating layers, so emphasis
  // comes from color, not a shadow.
  surfaceStyle: fortalCardStyle(
    size: .size2,
    style: CardStyler()
        .color(FortalTokens.accent2())
        .border(.all(.color(FortalTokens.accent8())))
        .onHovered(.border(.all(.color(FortalTokens.accent8()))))
        .merge(surfaceStyle),
  ),
  // Details read as a quiet line, not a field inside the card.
  detailsStyle: fortalDisclosureStyle(
    size: .size1,
    style: DisclosureStyler()
        .container(
          BoxStyler()
              .margin(.top(FortalTokens.space1()))
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
  parametersStyle: fortalDataListStyle(style: parametersStyle),
  allowOnceStyle: fortalButtonStyle(style: allowOnceStyle),
  alwaysAllowStyle: fortalButtonStyle(
    variant: .outline,
    style: alwaysAllowStyle,
  ),
  denyStyle: fortalButtonStyle(variant: .ghost, style: denyStyle),
);

BoxStyler _statusMark(ColorToken color) =>
    BoxStyler().wrap(.iconTheme(color: color()));

BoxStyler _attentionBadge() => BoxStyler()
    .color(FortalTokens.attention3())
    .borderRadius(.all(FortalTokens.radiusFull()))
    .padding(.symmetric(horizontal: FortalTokens.space2(), vertical: 2))
    .wrap(.iconTheme(color: FortalTokens.attention11()))
    .wrap(.defaultText(TextStyler().color(FortalTokens.attention11())));
