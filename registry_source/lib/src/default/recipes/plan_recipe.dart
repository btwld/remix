import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/plan.dart';

import '../components/disclosure.dart';
import '../theme/tokens.dart';

@immutable
final class VanillaAgentPlanRecipe {
  const VanillaAgentPlanRecipe({
    required this.style,
    required this.disclosureStyle,
  });
  final AgentPlanStyler style;
  final DisclosureStyler disclosureStyle;
}

VanillaAgentPlanRecipe vanillaAgentPlanRecipe({
  AgentPlanStyler style = const AgentPlanStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
}) => VanillaAgentPlanRecipe(
  style: AgentPlanStyler(
    viewport: BoxStyler().maxHeight(220),
    item: FlexBoxStyler()
        .spacing(8)
        .crossAxisAlignment(.center)
        .padding(.symmetric(vertical: 6)),
    summaryTitle: TextStyler()
        .color(VanillaTokens.foreground())
        .fontSize(14)
        .fontWeight(FontWeight.w600),
    itemTitle: TextStyler().color(VanillaTokens.foreground()).fontSize(14),
    itemDetail: TextStyler()
        .color(VanillaTokens.mutedForeground())
        .fontSize(12),
    count: TextStyler()
        .color(VanillaTokens.mutedForeground())
        .fontSize(12)
        .wrap(.padding(.right(8))),
    indicator: IconStyler().color(VanillaTokens.foreground()).size(16),
    pendingStatus: IconStyler().color(VanillaTokens.mutedForeground()).size(16),
    activeStatus: IconStyler().color(VanillaTokens.primary()).size(16),
    completedStatus: IconStyler().color(VanillaTokens.primary()).size(16),
    cancelledStatus: IconStyler()
        .color(VanillaTokens.mutedForeground())
        .size(16),
  ).merge(style),
  disclosureStyle: vanillaDisclosureStyle(
    style: DisclosureStyler()
        .padding(.vertical(VanillaTokens.s3))
        .content(BoxStyler().padding(.bottom(VanillaTokens.s2)))
        .merge(disclosureStyle),
  ),
);
