import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/activity.dart';

import '../components/disclosure.dart';
import '../theme/theme.dart';

/// Styles for the activity surface: HeroUI's disclosure around the shared
/// Agent activity list.
@immutable
final class HeroUiAgentActivityRecipe {
  const HeroUiAgentActivityRecipe({
    required this.style,
    required this.disclosureStyle,
  });
  final AgentActivityStyler style;
  final DisclosureStyler disclosureStyle;
}

HeroUiAgentActivityRecipe heroUiAgentActivityRecipe({
  AgentActivityStyler style = const AgentActivityStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
}) => HeroUiAgentActivityRecipe(
  style: AgentActivityStyler(
    viewport: BoxStyler().maxHeight(200),
    item: FlexBoxStyler()
        .spacing(8)
        .crossAxisAlignment(.center)
        .padding(.symmetric(vertical: 6)),
    summaryTitle: TextStyler()
        .style(HeroUiTokens.textSm.mix())
        .fontWeight(.w600)
        .color(HeroUiTokens.foreground()),
    itemTitle: TextStyler()
        .style(HeroUiTokens.textSm.mix())
        .color(HeroUiTokens.foreground()),
    itemDetail: TextStyler()
        .style(HeroUiTokens.textXs.mix())
        .color(HeroUiTokens.muted()),
    count: TextStyler()
        .style(HeroUiTokens.textXs.mix())
        .color(HeroUiTokens.muted())
        .wrap(.padding(.right(8))),
    indicator: IconStyler().color(HeroUiTokens.foreground()).size(16),
    pendingStatus: IconStyler().color(HeroUiTokens.muted()).size(16),
    activeStatus: IconStyler().color(HeroUiTokens.accent()).size(16),
    completedStatus: IconStyler().color(HeroUiTokens.accent()).size(16),
  ).merge(style),
  disclosureStyle: heroUiDisclosureStyle(
    style: DisclosureStyler()
        .padding(.vertical(12))
        .content(BoxStyler().padding(.all(0)))
        .merge(disclosureStyle),
  ),
);
