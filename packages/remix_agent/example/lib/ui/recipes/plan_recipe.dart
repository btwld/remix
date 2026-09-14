import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/disclosure.dart';
import '../components/plan.dart';
import '../theme/tokens.dart';

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
    item: FlexBoxStyler().spacing(6).padding(.symmetric(vertical: 6)),
    summaryTitle: TextStyler()
        .color(UiTokens.foreground())
        .fontSize(14)
        .fontWeight(FontWeight.w600),
    itemTitle: TextStyler().color(UiTokens.foreground()).fontSize(14),
    itemDetail: TextStyler().color(UiTokens.mutedForeground()).fontSize(12),
    count: TextStyler()
        .color(UiTokens.mutedForeground())
        .fontSize(12)
        .wrap(.padding(.only(right: 8))),
    indicator: IconStyler().color(UiTokens.foreground()).size(16),
    pendingStatus: IconStyler().color(UiTokens.mutedForeground()).size(18),
    activeStatus: IconStyler().color(UiTokens.primary()).size(18),
    completedStatus: IconStyler().color(UiTokens.primary()).size(18),
    cancelledStatus: IconStyler().color(UiTokens.mutedForeground()).size(18),
  ).merge(style),
  disclosureStyle: uiDisclosureStyle(style: disclosureStyle),
);
