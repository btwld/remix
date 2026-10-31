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
    actions: FlexBoxStyler()
        .spacing(FortalTokens.space2())
        .padding(.top(FortalTokens.space2())),
    title: TextStyler()
        .color(FortalTokens.gray12())
        .fontWeight(FortalTokens.fontWeightSemibold()),
    tool: TextStyler()
        .color(FortalTokens.gray11())
        .style(FortalTokens.text1.mix())
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
    statusIcon: IconStyler()
        .color(FortalTokens.accent9())
        .size(FortalTokens.space3()),
    indicator: IconStyler()
        .color(FortalTokens.gray12())
        .size(FortalTokens.space4()),
  ).merge(style),
  surfaceStyle: fortalCardStyle(size: .size2, style: surfaceStyle),
  detailsStyle: fortalDisclosureStyle(
    size: .size1,
    style: DisclosureStyler()
        .container(BoxStyler().margin(.top(FortalTokens.space1())))
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
