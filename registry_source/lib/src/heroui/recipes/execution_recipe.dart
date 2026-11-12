import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/execution.dart';

import '../components/button.dart';
import '../components/card.dart';
import '../components/disclosure.dart';
import '../theme/theme.dart';

/// Styles for the execution surface: a HeroUI card, a disclosure for its
/// output, and ghost `sm` icon buttons for copy and retry.
@immutable
final class HeroUiAgentExecutionRecipe {
  const HeroUiAgentExecutionRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.disclosureStyle,
    required this.copyStyle,
    required this.retryStyle,
  });
  final AgentExecutionStyler style;
  final CardStyler surfaceStyle;
  final DisclosureStyler disclosureStyle;
  final IconButtonStyler copyStyle;
  final IconButtonStyler retryStyle;
}

HeroUiAgentExecutionRecipe heroUiAgentExecutionRecipe({
  AgentExecutionStyler style = const AgentExecutionStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
  IconButtonStyler copyStyle = const IconButtonStyler.create(),
  IconButtonStyler retryStyle = const IconButtonStyler.create(),
}) => HeroUiAgentExecutionRecipe(
  style: AgentExecutionStyler(
    header: FlexBoxStyler().spacing(8).crossAxisAlignment(.center),
    // A nested surface for the command output, as a secondary card is.
    output: BoxStyler()
        .color(HeroUiTokens.surfaceSecondary())
        .borderRadius(.all(HeroUiTokens.radiusXl()))
        .padding(.all(12)),
    actions: FlexBoxStyler().spacing(4).padding(.top(6)),
    tool: TextStyler()
        .style(HeroUiTokens.textXs.mix())
        .color(HeroUiTokens.muted()),
    title: TextStyler()
        .style(HeroUiTokens.textSm.mix())
        .fontWeight(.w600)
        .color(HeroUiTokens.foreground()),
    meta: TextStyler()
        .style(HeroUiTokens.textXs.mix())
        .color(HeroUiTokens.muted()),
    status: TextStyler()
        .style(HeroUiTokens.textXs.mix())
        .color(HeroUiTokens.muted()),
    toolIcon: IconStyler().color(HeroUiTokens.foreground()).size(16),
    statusIcon: IconStyler().color(HeroUiTokens.accent()).size(12),
    indicator: IconStyler().color(HeroUiTokens.foreground()).size(16),
  ).merge(style),
  surfaceStyle: heroUiCardStyle(style: surfaceStyle),
  disclosureStyle: heroUiDisclosureStyle(
    style: DisclosureStyler()
        .padding(.vertical(0))
        .content(BoxStyler().padding(.top(12).bottom(0)))
        .merge(disclosureStyle),
  ),
  copyStyle: heroUiIconButtonStyle(
    variant: .ghost,
    size: .sm,
    style: copyStyle,
  ),
  retryStyle: heroUiIconButtonStyle(
    variant: .ghost,
    size: .sm,
    style: retryStyle,
  ),
);
