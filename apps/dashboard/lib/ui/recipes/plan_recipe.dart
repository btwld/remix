import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/disclosure.dart';
import '../components/plan.dart';
import '../theme/theme.dart';

/// Styles for the plan surface: a disclosure around the agent plan list.
@immutable
final class UiAgentPlanRecipe {
  const UiAgentPlanRecipe({required this.style, required this.disclosureStyle});

  /// Styles for the plan rows, titles, counts and status icons.
  final UiPlanStyler style;

  /// Styles for the disclosure that wraps the list.
  final DisclosureStyler disclosureStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
UiAgentPlanRecipe uiAgentPlanRecipe({
  UiPlanStyler style = const UiPlanStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
}) => UiAgentPlanRecipe(
  style: UiPlanStyler(
    viewport: BoxStyler().maxHeight(UiTokens.planMaxHeight()),
    item: FlexBoxStyler()
        .spacing(UiTokens.space2())
        .crossAxisAlignment(.center)
        .padding(.vertical(UiTokens.space2())),
    summaryTitle: TextStyler()
        .color(UiTokens.gray12())
        .style(UiTokens.text2.mix())
        .fontWeight(UiTokens.fontWeightSemibold()),
    itemTitle: TextStyler()
        .color(UiTokens.gray12())
        .style(UiTokens.text2.mix()),
    itemDetail: TextStyler()
        .color(UiTokens.gray11())
        .style(UiTokens.text1.mix()),
    count: TextStyler()
        .color(UiTokens.gray11())
        .style(UiTokens.text1.mix())
        .wrap(.padding(.end(UiTokens.space2()))),
    indicator: IconStyler().color(UiTokens.gray12()).size(UiTokens.space4()),
    pendingStatus: IconStyler().color(UiTokens.gray9()).size(UiTokens.space4()),
    activeStatus: IconStyler()
        .color(UiTokens.accentIndicator())
        .size(UiTokens.space4()),
    completedStatus: IconStyler()
        .color(UiTokens.accentIndicator())
        .size(UiTokens.space4()),
    cancelledStatus: IconStyler()
        .color(UiTokens.gray9())
        .size(UiTokens.space4()),
  ).merge(style),
  disclosureStyle: uiDisclosureStyle(style: disclosureStyle),
);
