import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/plan.dart';

import '../components/disclosure.dart';
import '../theme/theme.dart';

@immutable
final class FortalAgentPlanRecipe {
  const FortalAgentPlanRecipe({
    required this.style,
    required this.disclosureStyle,
  });
  final AgentPlanStyler style;
  final DisclosureStyler disclosureStyle;
}

FortalAgentPlanRecipe fortalAgentPlanRecipe({
  AgentPlanStyler style = const AgentPlanStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
}) => FortalAgentPlanRecipe(
  style: AgentPlanStyler(
    viewport: BoxStyler().maxHeight(FortalTokens.planMaxHeight()),
    item: FlexBoxStyler()
        .spacing(FortalTokens.space2())
        .crossAxisAlignment(.center)
        .padding(.vertical(FortalTokens.space2())),
    summaryTitle: TextStyler()
        .color(FortalTokens.gray12())
        .style(FortalTokens.text2.mix())
        .fontWeight(FortalTokens.fontWeightSemibold()),
    itemTitle: TextStyler()
        .color(FortalTokens.gray12())
        .style(FortalTokens.text2.mix()),
    itemDetail: TextStyler()
        .color(FortalTokens.gray11())
        .style(FortalTokens.text1.mix()),
    count: TextStyler()
        .color(FortalTokens.gray11())
        .style(FortalTokens.text1.mix())
        .wrap(.padding(.right(FortalTokens.space2()))),
    indicator: IconStyler()
        .color(FortalTokens.gray12())
        .size(FortalTokens.space4()),
    pendingStatus: IconStyler()
        .color(FortalTokens.gray9())
        .size(FortalTokens.space4()),
    activeStatus: IconStyler()
        .color(FortalTokens.accent9())
        .size(FortalTokens.space4()),
    completedStatus: IconStyler()
        .color(FortalTokens.accent9())
        .size(FortalTokens.space4()),
    cancelledStatus: IconStyler()
        .color(FortalTokens.gray9())
        .size(FortalTokens.space4()),
  ).merge(style),
  disclosureStyle: fortalDisclosureStyle(style: disclosureStyle),
);
