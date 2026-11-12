import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../components/card.dart';
import '../components/disclosure.dart';
import '../components/execution.dart';
import '../theme/theme.dart';

/// Styles for the execution surface: a HeroUI card, a disclosure for its
/// output, and ghost `sm` icon buttons for copy and retry.
@immutable
final class UiAgentExecutionRecipe {
  const UiAgentExecutionRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.disclosureStyle,
    required this.copyStyle,
    required this.retryStyle,
  });
  final UiExecutionStyler style;
  final CardStyler surfaceStyle;
  final DisclosureStyler disclosureStyle;
  final IconButtonStyler copyStyle;
  final IconButtonStyler retryStyle;
}

UiAgentExecutionRecipe uiAgentExecutionRecipe({
  UiExecutionStyler style = const UiExecutionStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
  IconButtonStyler copyStyle = const IconButtonStyler.create(),
  IconButtonStyler retryStyle = const IconButtonStyler.create(),
}) => UiAgentExecutionRecipe(
  style: UiExecutionStyler(
    header: FlexBoxStyler().spacing(8).crossAxisAlignment(.center),
    // A nested surface for the command output, as a secondary card is.
    output: BoxStyler()
        .color(UiTokens.surfaceSecondary())
        .borderRadius(.all(UiTokens.radiusXl()))
        .padding(.all(12)),
    actions: FlexBoxStyler().spacing(4).padding(.top(6)),
    tool: TextStyler().style(UiTokens.textXs.mix()).color(UiTokens.muted()),
    title: TextStyler()
        .style(UiTokens.textSm.mix())
        .fontWeight(.w600)
        .color(UiTokens.foreground()),
    meta: TextStyler().style(UiTokens.textXs.mix()).color(UiTokens.muted()),
    status: TextStyler().style(UiTokens.textXs.mix()).color(UiTokens.muted()),
    toolIcon: IconStyler().color(UiTokens.foreground()).size(16),
    statusIcon: IconStyler().color(UiTokens.accent()).size(12),
    indicator: IconStyler().color(UiTokens.foreground()).size(16),
  ).merge(style),
  surfaceStyle: uiCardStyle(style: surfaceStyle),
  disclosureStyle: uiDisclosureStyle(
    style: DisclosureStyler()
        .padding(.vertical(0))
        .content(BoxStyler().padding(.top(12).bottom(0)))
        .merge(disclosureStyle),
  ),
  copyStyle: uiIconButtonStyle(variant: .ghost, size: .sm, style: copyStyle),
  retryStyle: uiIconButtonStyle(variant: .ghost, size: .sm, style: retryStyle),
);
