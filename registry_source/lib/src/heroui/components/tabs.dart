import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'tabs.g.dart';

/// HeroUI tab styles: a segmented pill list, or an underlined row.
enum HeroUiTabsVariant { primary, secondary }

/// HeroUI recipe for [RemixTabBar], the tab list container.
@MixWidget(target: RemixTabBar.new)
TabBarStyler heroUiTabBarStyle({
  HeroUiTabsVariant variant = .primary,
  TabBarStyler style = const TabBarStyler.create(),
}) {
  final result = switch (variant) {
    .primary =>
      TabBarStyler()
          .color(HeroUiTokens.defaultColor())
          .borderRadius(.all(_listRadius()))
          .padding(.all(_listPadding)),
    .secondary => TabBarStyler().border(
      .bottom(.color(HeroUiTokens.border()).width(_ruleWidth)),
    ),
  };
  return result.merge(style);
}

/// HeroUI recipe for [RemixTab].
///
/// The selected tab paints the indicator itself; upstream slides one shared
/// indicator between tabs.
@MixWidget(target: RemixTab.new)
TabStyler heroUiTabStyle({
  HeroUiTabsVariant variant = .primary,
  TabStyler style = const TabStyler.create(),
}) {
  final result = TabStyler()
      .height(_height)
      .padding(.horizontal(_paddingX))
      .mainAxisAlignment(.center)
      .label(
        .style(
          HeroUiTokens.textSm.mix(),
        ).fontWeight(.w500).color(HeroUiTokens.muted()),
      )
      // Unselected tabs fade on hover; selected tabs restore it below.
      .onHovered(TabStyler().wrap(.opacity(_hoverOpacity)))
      .animate(HeroUiTokens.smoothMotion);

  final styled = switch (variant) {
    .primary =>
      result
          .borderRadius(.all(HeroUiTokens.radius3xl()))
          .onSelected(
            _selected(HeroUiTokens.segmentForeground)
                .color(HeroUiTokens.segment())
                .containerEffects(heroUiSurfaceEffects()),
          ),
    // The `h-0.5` indicator is the bottom edge, transparent until selected;
    // the top padding keeps the label centered in the tab.
    .secondary =>
      result
          .padding(.top(_indicatorWidth))
          .border(
            .bottom(.color(HeroUiTokens.transparent).width(_indicatorWidth)),
          )
          .onSelected(
            _selected(
              HeroUiTokens.foreground,
            ).border(.bottom(.color(HeroUiTokens.accent()))),
          ),
  };

  return styled
      .onFocusVisible(TabStyler().containerEffects(heroUiFocusRing()))
      .onDisabled(TabStyler().wrap(.opacity(HeroUiTokens.disabledOpacity)))
      .merge(style);
}

/// HeroUI recipe for [RemixTabView], the panel below the list.
@MixWidget(target: RemixTabView.new)
TabViewStyler heroUiTabViewStyle({
  TabViewStyler style = const TabViewStyler.create(),
}) => TabViewStyler().padding(.all(_panelPadding)).merge(style);

/// A selected tab's foreground, at full opacity even while hovered.
TabStyler _selected(ColorToken foreground) =>
    TabStyler().label(.color(foreground())).wrap(.opacity(1));

/// `.tabs__tab`: `h-8 px-4`, and `opacity-70` while hovered.
const _height = 32.0;
const _paddingX = 16.0;
const _hoverOpacity = .7;

/// `.tabs__list`: `p-1`; the secondary list's `border-b` and its `h-0.5`
/// indicator; `.tabs__panel`: `p-2`.
const _listPadding = 4.0;
const _ruleWidth = 1.0;
const _indicatorWidth = 2.0;
const _panelPadding = 8.0;

/// The list container's `calc(var(--radius) * 2.5)`.
final _listRadius = heroUiRadius(HeroUiTokens.radiusLg, scale: 2.5);
