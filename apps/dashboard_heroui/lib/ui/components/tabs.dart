import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'tabs.g.dart';

/// HeroUI tab styles.
enum UiTabsVariant {
  /// A segmented pill list; the selected tab is a raised pill.
  primary,

  /// An underlined row; the selected tab has an accent underline.
  secondary,
}

/// A one-line tab strip that scrolls within its available width.
///
/// Scrolling wraps the semantic tab bar, keeping its direct semantic children
/// as tabs and allowing Naked UI to reveal keyboard-focused tabs.
class UiTabBar extends StatelessWidget {
  const UiTabBar({
    super.key,
    this.variant = .primary,
    this.style = const TabBarStyler.create(),
    required this.child,
  });

  const UiTabBar.primary({
    super.key,
    this.style = const TabBarStyler.create(),
    required this.child,
  }) : variant = UiTabsVariant.primary;

  const UiTabBar.secondary({
    super.key,
    this.style = const TabBarStyler.create(),
    required this.child,
  }) : variant = UiTabsVariant.secondary;

  final UiTabsVariant variant;
  final TabBarStyler style;
  final Widget child;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: RemixTabBar(
      style: uiTabBarStyle(variant: variant, style: style),
      child: child,
    ),
  );
}

/// HeroUI recipe for [RemixTabBar], the tab list container.
TabBarStyler uiTabBarStyle({
  UiTabsVariant variant = .primary,
  TabBarStyler style = const TabBarStyler.create(),
}) {
  final result = switch (variant) {
    .primary =>
      TabBarStyler()
          .color(UiTokens.defaultColor())
          .borderRadius(.all(_listRadius()))
          .padding(.all(_listPadding)),
    .secondary => TabBarStyler().border(
      .bottom(.color(UiTokens.border()).width(_ruleWidth)),
    ),
  };
  return result.merge(style);
}

/// HeroUI recipe for [RemixTab].
///
/// The selected tab paints the indicator itself; upstream slides one shared
/// indicator between tabs.
@MixWidget(target: RemixTab.new)
TabStyler uiTabStyle({
  UiTabsVariant variant = .primary,
  TabStyler style = const TabStyler.create(),
}) {
  return TabStyler()
      .height(_height)
      .padding(.horizontal(_paddingX))
      .mainAxisAlignment(.center)
      .label(
        .style(UiTokens.textSm.mix()).fontWeight(.w500).color(UiTokens.muted()),
      )
      // Unselected tabs fade on hover; selected tabs restore it below.
      .onHovered(TabStyler().wrap(.opacity(_hoverOpacity)))
      .animate(UiTokens.smoothMotion)
      .merge(switch (variant) {
        .primary =>
          TabStyler()
              .borderRadius(.all(UiTokens.radius3xl()))
              .onSelected(
                _selected(UiTokens.segmentForeground)
                    .color(UiTokens.segment())
                    .containerEffects(uiSurfaceEffects()),
              ),
        // The `h-0.5` indicator is the bottom edge, transparent until
        // selected; the top padding keeps the label centered in the tab.
        .secondary =>
          TabStyler()
              .padding(.top(_indicatorWidth))
              .border(
                .bottom(.color(UiTokens.transparent).width(_indicatorWidth)),
              )
              .onSelected(
                _selected(
                  UiTokens.foreground,
                ).border(.bottom(.color(UiTokens.accent()))),
              ),
      })
      .onFocusVisible(TabStyler().containerEffects(uiFocusRing()))
      .onDisabled(TabStyler().wrap(.opacity(UiTokens.disabledOpacity)))
      .merge(style);
}

/// HeroUI recipe for [RemixTabView], the panel below the list.
@MixWidget(target: RemixTabView.new)
TabViewStyler uiTabViewStyle({
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
final _listRadius = uiRadius(UiTokens.radiusLg, scale: 2.5);
