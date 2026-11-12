import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/activity.dart';
import '../components/disclosure.dart';
import '../theme/tokens.dart';

/// Styles for the activity surface: a disclosure around the agent activity list.
@immutable
final class PlaygroundAgentActivityRecipe {
  const PlaygroundAgentActivityRecipe({
    required this.style,
    required this.disclosureStyle,
  });

  /// Styles for the activity rows, titles, counts and status icons.
  final PlaygroundActivityStyler style;

  /// Styles for the disclosure that wraps the list.
  final DisclosureStyler disclosureStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
PlaygroundAgentActivityRecipe playgroundAgentActivityRecipe({
  PlaygroundActivityStyler style = const PlaygroundActivityStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
}) => PlaygroundAgentActivityRecipe(
  style: PlaygroundActivityStyler(
    viewport: BoxStyler().maxHeight(200),
    item: FlexBoxStyler()
        .spacing(8)
        .crossAxisAlignment(.center)
        .padding(.symmetric(vertical: 6)),
    summaryTitle: TextStyler()
        .color(PlaygroundTokens.foreground())
        .fontSize(14)
        .fontWeight(FontWeight.w600),
    itemTitle: TextStyler().color(PlaygroundTokens.foreground()).fontSize(14),
    itemDetail: TextStyler()
        .color(PlaygroundTokens.mutedForeground())
        .fontSize(12),
    count: TextStyler()
        .color(PlaygroundTokens.mutedForeground())
        .fontSize(12)
        .wrap(.padding(.end(8))),
    indicator: IconStyler().color(PlaygroundTokens.foreground()).size(16),
    pendingStatus: IconStyler()
        .color(PlaygroundTokens.mutedForeground())
        .size(16),
    activeStatus: IconStyler().color(PlaygroundTokens.primary()).size(16),
    completedStatus: IconStyler().color(PlaygroundTokens.primary()).size(16),
  ).merge(style),
  disclosureStyle: playgroundDisclosureStyle(
    style: DisclosureStyler()
        .padding(.vertical(PlaygroundTokens.s3))
        .content(BoxStyler().padding(.all(0)))
        .merge(disclosureStyle),
  ),
);
