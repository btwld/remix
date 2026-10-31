import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/activity.dart';

import '../components/disclosure.dart';
import '../theme/theme.dart';

@immutable
final class FortalAgentActivityRecipe {
  const FortalAgentActivityRecipe({
    required this.style,
    required this.disclosureStyle,
  });
  final AgentActivityStyler style;
  final DisclosureStyler disclosureStyle;
}

FortalAgentActivityRecipe fortalAgentActivityRecipe({
  AgentActivityStyler style = const AgentActivityStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
}) => FortalAgentActivityRecipe(
  style: AgentActivityStyler(
    viewport: BoxStyler().maxHeight(FortalTokens.activityMaxHeight()),
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
  ).merge(style),
  disclosureStyle: fortalDisclosureStyle(
    style: DisclosureStyler()
        .content(
          BoxStyler().padding(
            .symmetric(
              horizontal: FortalTokens.space3(),
              vertical: FortalTokens.space1(),
            ),
          ),
        )
        .merge(disclosureStyle),
  ),
);
