import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/card.dart';
import '../components/disclosure.dart';
import '../components/execution.dart';
import '../components/icon_button.dart';
import '../theme/tokens.dart';

@immutable
final class PlaygroundAgentExecutionRecipe {
  const PlaygroundAgentExecutionRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.disclosureStyle,
    required this.copyStyle,
    required this.retryStyle,
  });
  final PlaygroundExecutionStyler style;
  final CardStyler surfaceStyle;
  final DisclosureStyler disclosureStyle;
  final IconButtonStyler copyStyle;
  final IconButtonStyler retryStyle;
}

PlaygroundAgentExecutionRecipe playgroundAgentExecutionRecipe({
  PlaygroundExecutionStyler style = const PlaygroundExecutionStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
  IconButtonStyler copyStyle = const IconButtonStyler.create(),
  IconButtonStyler retryStyle = const IconButtonStyler.create(),
}) => PlaygroundAgentExecutionRecipe(
  style: PlaygroundExecutionStyler(
    header: FlexBoxStyler().spacing(8).crossAxisAlignment(.center),
    output: BoxStyler()
        .color(PlaygroundTokens.muted())
        .borderRadius(.circular(6))
        .padding(.all(12)),
    actions: FlexBoxStyler().spacing(6).padding(.top(6)),
    tool: TextStyler().color(PlaygroundTokens.mutedForeground()).fontSize(12),
    title: TextStyler()
        .color(PlaygroundTokens.foreground())
        .fontWeight(FontWeight.w600),
    meta: TextStyler().color(PlaygroundTokens.mutedForeground()).fontSize(12),
    status: TextStyler().color(PlaygroundTokens.mutedForeground()).fontSize(12),
    toolIcon: IconStyler().color(PlaygroundTokens.foreground()).size(16),
    statusIcon: IconStyler().color(PlaygroundTokens.primary()).size(12),
    indicator: IconStyler().color(PlaygroundTokens.foreground()).size(16),
  ).merge(style),
  surfaceStyle: playgroundCardStyle(
    style: CardStyler().padding(.all(PlaygroundTokens.s4)).merge(surfaceStyle),
  ),
  disclosureStyle: playgroundDisclosureStyle(
    style: DisclosureStyler()
        .padding(.vertical(0))
        .content(BoxStyler().padding(.top(PlaygroundTokens.s3).bottom(0)))
        .merge(disclosureStyle),
  ),
  copyStyle: playgroundIconButtonStyle(
    variant: .ghost,
    size: .small,
    style: IconButtonStyler().size(28, 28).merge(copyStyle),
  ),
  retryStyle: playgroundIconButtonStyle(
    variant: .ghost,
    size: .small,
    style: IconButtonStyler().size(28, 28).merge(retryStyle),
  ),
);
