import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/activity.dart';
import '../components/disclosure.dart';
import '../theme/theme.dart';

/// Styles for the activity surface: HeroUI's disclosure around the shared
/// Agent activity list.
@immutable
final class UiAgentActivityRecipe {
  const UiAgentActivityRecipe({
    required this.style,
    required this.disclosureStyle,
  });
  final UiActivityStyler style;
  final DisclosureStyler disclosureStyle;
}

UiAgentActivityRecipe uiAgentActivityRecipe({
  UiActivityStyler style = const UiActivityStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
}) => UiAgentActivityRecipe(
  style: UiActivityStyler(
    viewport: BoxStyler().maxHeight(200),
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
        .wrap(.padding(.right(8))),
    indicator: IconStyler().color(UiTokens.foreground()).size(16),
    pendingStatus: IconStyler().color(UiTokens.muted()).size(16),
    activeStatus: IconStyler().color(UiTokens.accent()).size(16),
    completedStatus: IconStyler().color(UiTokens.accent()).size(16),
  ).merge(style),
  disclosureStyle: uiDisclosureStyle(
    style: DisclosureStyler()
        .padding(.vertical(12))
        .content(BoxStyler().padding(.all(0)))
        .merge(disclosureStyle),
  ),
);
