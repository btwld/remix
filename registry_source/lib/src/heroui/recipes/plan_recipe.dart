import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/plan.dart';

import '../components/disclosure.dart';
import '../theme/theme.dart';

/// Styles for the plan surface: HeroUI's disclosure around the shared Agent
/// plan list.
@immutable
final class HeroUiAgentPlanRecipe {
  const HeroUiAgentPlanRecipe({
    required this.style,
    required this.disclosureStyle,
  });

  /// Styles for the plan rows, titles, counts and status icons.
  final AgentPlanStyler style;

  /// Styles for the disclosure that wraps the list.
  final DisclosureStyler disclosureStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
HeroUiAgentPlanRecipe heroUiAgentPlanRecipe({
  AgentPlanStyler style = const AgentPlanStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
}) => HeroUiAgentPlanRecipe(
  style: AgentPlanStyler(
    viewport: BoxStyler().maxHeight(220),
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
        .wrap(.padding(.end(8))),
    indicator: IconStyler().color(HeroUiTokens.foreground()).size(16),
    pendingStatus: IconStyler().color(HeroUiTokens.muted()).size(16),
    activeStatus: IconStyler().color(HeroUiTokens.accent()).size(16),
    completedStatus: IconStyler().color(HeroUiTokens.accent()).size(16),
    cancelledStatus: IconStyler().color(HeroUiTokens.muted()).size(16),
  ).merge(style),
  disclosureStyle: heroUiDisclosureStyle(
    style: DisclosureStyler()
        .padding(.vertical(12))
        .content(BoxStyler().padding(.bottom(8)))
        .merge(disclosureStyle),
  ),
);
