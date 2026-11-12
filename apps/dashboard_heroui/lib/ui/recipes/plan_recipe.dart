import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/disclosure.dart';
import '../components/plan.dart';
import '../theme/theme.dart';

/// Styles for the plan surface: HeroUI's disclosure around the shared Agent
/// plan list.
@immutable
final class UiAgentPlanRecipe {
  const UiAgentPlanRecipe({required this.style, required this.disclosureStyle});
  final UiPlanStyler style;
  final DisclosureStyler disclosureStyle;
}

UiAgentPlanRecipe uiAgentPlanRecipe({
  UiPlanStyler style = const UiPlanStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
}) => UiAgentPlanRecipe(
  style: UiPlanStyler(
    viewport: BoxStyler().maxHeight(220),
    item: FlexBoxStyler()
        .spacing(8)
        .crossAxisAlignment(.center)
        .padding(.symmetric(vertical: 6)),
    summaryTitle: TextStyler()
        .style(UiTokens.textSm.mix())
        .fontWeight(.w600)
        .color(UiTokens.foreground()),
    itemTitle: TextStyler()
        .style(UiTokens.textSm.mix())
        .color(UiTokens.foreground()),
    itemDetail: TextStyler()
        .style(UiTokens.textXs.mix())
        .color(UiTokens.muted()),
    count: TextStyler()
        .style(UiTokens.textXs.mix())
        .color(UiTokens.muted())
        .wrap(.padding(.end(8))),
    indicator: IconStyler().color(UiTokens.foreground()).size(16),
    pendingStatus: IconStyler().color(UiTokens.muted()).size(16),
    activeStatus: IconStyler().color(UiTokens.accent()).size(16),
    completedStatus: IconStyler().color(UiTokens.accent()).size(16),
    cancelledStatus: IconStyler().color(UiTokens.muted()).size(16),
  ).merge(style),
  disclosureStyle: uiDisclosureStyle(
    style: DisclosureStyler()
        .padding(.vertical(12))
        .content(BoxStyler().padding(.bottom(8)))
        .merge(disclosureStyle),
  ),
);
