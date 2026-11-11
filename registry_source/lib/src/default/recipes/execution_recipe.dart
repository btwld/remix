import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/execution.dart';

import '../components/card.dart';
import '../components/disclosure.dart';
import '../components/icon_button.dart';
import '../theme/tokens.dart';

@immutable
final class VanillaAgentExecutionRecipe {
  const VanillaAgentExecutionRecipe({
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

VanillaAgentExecutionRecipe vanillaAgentExecutionRecipe({
  AgentExecutionStyler style = const AgentExecutionStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
  IconButtonStyler copyStyle = const IconButtonStyler.create(),
  IconButtonStyler retryStyle = const IconButtonStyler.create(),
}) => VanillaAgentExecutionRecipe(
  style: AgentExecutionStyler(
    header: FlexBoxStyler().spacing(8).crossAxisAlignment(.center),
    output: BoxStyler()
        .color(VanillaTokens.muted())
        .borderRadius(.circular(6))
        .padding(.all(12)),
    // Long output scrolls inside the well instead of growing the card; the
    // plan's own limit.
    viewport: BoxStyler().maxHeight(220),
    actions: FlexBoxStyler().spacing(6).padding(.top(6)),
    tool: TextStyler().color(VanillaTokens.mutedForeground()).fontSize(12),
    title: TextStyler()
        .color(VanillaTokens.foreground())
        .fontWeight(FontWeight.w600),
    meta: TextStyler().color(VanillaTokens.mutedForeground()).fontSize(12),
    status: TextStyler().color(VanillaTokens.mutedForeground()).fontSize(12),
    toolIcon: IconStyler().color(VanillaTokens.foreground()).size(16),
    // The status mark takes its outcome's color from the status box below;
    // its glyph and label already name the outcome.
    statusIcon: IconStyler().size(12),
    indicator: IconStyler().color(VanillaTokens.foreground()).size(16),
    runningStatus: _statusMark(VanillaTokens.primary),
    successStatus: _statusMark(VanillaTokens.primary),
    errorStatus: _statusMark(VanillaTokens.destructive),
    cancelledStatus: _statusMark(VanillaTokens.mutedForeground),
  ).merge(style),
  surfaceStyle: vanillaCardStyle(
    style: CardStyler().padding(.all(VanillaTokens.s4)).merge(surfaceStyle),
  ),
  disclosureStyle: vanillaDisclosureStyle(
    style: DisclosureStyler()
        .padding(.vertical(0))
        .content(BoxStyler().padding(.top(VanillaTokens.s3).bottom(0)))
        .merge(disclosureStyle),
  ),
  copyStyle: vanillaIconButtonStyle(
    variant: .ghost,
    size: .small,
    style: IconButtonStyler().size(28, 28).merge(copyStyle),
  ),
  retryStyle: vanillaIconButtonStyle(
    variant: .ghost,
    size: .small,
    style: IconButtonStyler().size(28, 28).merge(retryStyle),
  ),
);

BoxStyler _statusMark(ColorToken color) =>
    BoxStyler().wrap(.iconTheme(color: color()));
