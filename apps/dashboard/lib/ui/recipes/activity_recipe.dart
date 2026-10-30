import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/activity.dart';
import '../components/disclosure.dart';
import '../theme/theme.dart';

@immutable
final class UiAgentActivityRecipe {
  const UiAgentActivityRecipe({
    required this.style,
    required this.disclosureStyle,
  });
  final UiActivityStyler style;
  final DisclosureStyler disclosureStyle;
}

UiAgentActivityRecipe uiAgentActivityRecipe({
  UiActivityStyler style = const UiActivityStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
}) => UiAgentActivityRecipe(
  style: UiActivityStyler(
    viewport: BoxStyler().maxHeight(UiTokens.activityMaxHeight()),
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
        .wrap(.padding(.right(UiTokens.space2()))),
    indicator: IconStyler().color(UiTokens.gray12()).size(UiTokens.space4()),
    pendingStatus: IconStyler().color(UiTokens.gray9()).size(UiTokens.space4()),
    activeStatus: IconStyler()
        .color(UiTokens.accent9())
        .size(UiTokens.space4()),
    completedStatus: IconStyler()
        .color(UiTokens.accent9())
        .size(UiTokens.space4()),
  ).merge(style),
  disclosureStyle: uiDisclosureStyle(
    style: DisclosureStyler()
        .content(
          BoxStyler().padding(
            .symmetric(
              horizontal: UiTokens.space3(),
              vertical: UiTokens.space1(),
            ),
          ),
        )
        .merge(disclosureStyle),
  ),
);
