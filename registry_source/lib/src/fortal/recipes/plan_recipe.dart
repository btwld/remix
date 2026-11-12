import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/plan.dart';

import '../components/disclosure.dart';
import '../theme/theme.dart';

/// Styles for the plan surface: a disclosure around the agent plan list.
@immutable
final class FortalAgentPlanRecipe {
  const FortalAgentPlanRecipe({
    required this.style,
    required this.disclosureStyle,
  });

  /// Styles for the plan rows, titles, counts and status icons.
  final AgentPlanStyler style;

  /// Styles for the disclosure that wraps the list.
  final DisclosureStyler disclosureStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
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
        .wrap(.padding(.end(FortalTokens.space2()))),
    indicator: IconStyler()
        .color(FortalTokens.gray12())
        .size(FortalTokens.space4()),
    pendingStatus: IconStyler()
        .color(FortalTokens.gray9())
        .size(FortalTokens.space4()),
    activeStatus: IconStyler()
        .color(FortalTokens.accentIndicator())
        .size(FortalTokens.space4()),
    completedStatus: IconStyler()
        .color(FortalTokens.accentIndicator())
        .size(FortalTokens.space4()),
    cancelledStatus: IconStyler()
        .color(FortalTokens.gray9())
        .size(FortalTokens.space4()),
  ).merge(style),
  disclosureStyle: fortalDisclosureStyle(style: disclosureStyle),
);
