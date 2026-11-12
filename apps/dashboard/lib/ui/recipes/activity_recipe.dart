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
        .color(UiTokens.gray11())
        .style(UiTokens.text2.mix()),
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
        .color(UiTokens.accentIndicator())
        .size(UiTokens.space4()),
    completedStatus: IconStyler()
        .color(UiTokens.accentIndicator())
        .size(UiTokens.space4()),
  ).merge(style),
  disclosureStyle: uiDisclosureStyle(
    style: DisclosureStyler()
        // The agent's working steps are secondary to the conversation: one
        // muted line, without a fill or frame, that opens on demand.
        .container(
          BoxStyler()
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
