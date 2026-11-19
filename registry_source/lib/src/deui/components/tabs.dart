import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'tabs.g.dart';

/// Deui tab styles.
enum DeuiTabsVariant {
  /// A segmented pill list; the selected tab is a raised pill.
  primary,

  /// An underlined row; the selected tab has an accent underline.
  secondary,
}

/// A one-line tab strip that scrolls within its available width.
///
/// Scrolling wraps the semantic tab bar, keeping its direct semantic children
/// as tabs and allowing Naked UI to reveal keyboard-focused tabs.
class DeuiTabBar extends StatelessWidget {
  const DeuiTabBar({
    super.key,
    this.variant = .primary,
    this.style = const TabBarStyler.create(),
    required this.child,
  });

  const DeuiTabBar.primary({
    super.key,
    this.style = const TabBarStyler.create(),
    required this.child,
  }) : variant = DeuiTabsVariant.primary;

  const DeuiTabBar.secondary({
    super.key,
    this.style = const TabBarStyler.create(),
    required this.child,
  }) : variant = DeuiTabsVariant.secondary;

  final DeuiTabsVariant variant;
  final TabBarStyler style;
  final Widget child;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: RemixTabBar(
      style: deuiTabBarStyle(variant: variant, style: style),
      child: child,
    ),
  );
}

/// Deui recipe for [RemixTabBar], the tab list container.
///
/// The selected indicator is one surface that glides between tabs on a 470 ms
/// overdamped spring; replace the motion with `TabBarStyler.indicatorMotion`.
TabBarStyler deuiTabBarStyle({
  DeuiTabsVariant variant = .primary,
  TabBarStyler style = const TabBarStyler.create(),
}) {
  final result = switch (variant) {
    .primary =>
      TabBarStyler()
          .color(DeuiTokens.defaultColor())
          .borderRadius(.all(_listRadius()))
          .padding(.all(_listPadding))
          .indicator(
            BoxStyler()
                .color(DeuiTokens.segment())
                .borderRadius(.all(DeuiTokens.radius3xl())),
          )
          .indicatorEffects(deuiSurfaceEffects()),
    .secondary =>
      TabBarStyler()
          .border(.bottom(.color(DeuiTokens.border()).width(_ruleWidth)))
          // The `h-0.5` indicator is the bottom edge of the selected tab.
          .indicator(
            BoxStyler().border(
              .bottom(.color(DeuiTokens.accent()).width(_indicatorWidth)),
            ),
          ),
  };
  return result.indicatorMotion(_glide).merge(style);
}

/// Deui recipe for [RemixTab].
///
/// The selected tab changes its foreground only; the pill or underline is the
/// tab bar's shared indicator, so it glides between tabs.
@MixWidget(target: RemixTab.new)
TabStyler deuiTabStyle({
  DeuiTabsVariant variant = .primary,
  TabStyler style = const TabStyler.create(),
}) {
  return TabStyler()
      .height(_height)
      .padding(.horizontal(_paddingX))
      .mainAxisAlignment(.center)
      .icon(.size(_iconSize).color(DeuiTokens.muted()))
      .label(
        .style(
          DeuiTokens.textSm.mix(),
        ).fontWeight(.w500).color(DeuiTokens.muted()),
      )
      // Unselected tabs fade on hover, on the 150 ms smooth motion in both
      // directions; selected tabs restore it below. A tab that becomes
      // selected takes its colors on the indicator's glide, as in Deui.
      .onHovered(TabStyler().wrap(.opacity(_hoverOpacity)))
      .animate(DeuiTokens.smoothMotion)
      .merge(switch (variant) {
        .primary =>
          TabStyler()
              .borderRadius(.all(DeuiTokens.radius3xl()))
              .onSelected(_selected(DeuiTokens.segmentForeground)),
        // The `h-0.5` indicator is the bottom edge of the bar's indicator;
        // this transparent edge and the top padding keep the label centered.
        .secondary =>
          TabStyler()
              .padding(.top(_indicatorWidth))
              .border(
                .bottom(.color(DeuiTokens.transparent).width(_indicatorWidth)),
              )
              .onSelected(_selected(DeuiTokens.foreground)),
      })
      .onFocusVisible(TabStyler().containerEffects(deuiFocusRing()))
      .onDisabled(TabStyler().wrap(.opacity(DeuiTokens.disabledOpacity)))
      .merge(style);
}

/// Deui recipe for [RemixTabView], the panel below the list.
@MixWidget(target: RemixTabView.new)
TabViewStyler deuiTabViewStyle({
  TabViewStyler style = const TabViewStyler.create(),
}) => TabViewStyler().padding(.all(_panelPadding)).merge(style);

const _glideCurve = _TabGlide(slow: -10.4356, fast: -19.5644, seconds: .47);
const _glide = RemixTabIndicatorMotion(
  duration: Duration(milliseconds: 470),
  curve: _glideCurve,
);

/// Deui reveals the selected foreground through a clip that follows the glide,
/// so the colors change on the indicator's timing, not on a 150 ms fade.
const _foregroundGlide = CurveAnimationConfig(
  duration: Duration(milliseconds: 470),
  curve: _glideCurve,
);

/// The unit-step response of an overdamped spring, normalized at its stop
/// time: the glide of Deui's selected pill.
class _TabGlide extends Curve {
  const _TabGlide({
    required this.slow,
    required this.fast,
    required this.seconds,
  });

  final double slow;
  final double fast;
  final double seconds;

  double _response(double elapsed) =>
      1 -
      (fast * math.exp(slow * elapsed) - slow * math.exp(fast * elapsed)) /
          (fast - slow);

  @override
  double transformInternal(double t) =>
      _response(t * seconds) / _response(seconds);
}

/// A selected tab's foreground, at full opacity even while hovered.
TabStyler _selected(ColorToken foreground) => TabStyler()
    .label(.color(foreground()))
    .icon(.color(foreground()))
    .wrap(.opacity(1))
    .animate(_foregroundGlide);

/// `.tabs__tab`: `h-8 px-4`, and `opacity-70` while hovered.
const _height = 32.0;
const _paddingX = 16.0;
const _iconSize = 16.0;
const _hoverOpacity = .7;

/// `.tabs__list`: `p-1`; the secondary list's `border-b` and its `h-0.5`
/// indicator; `.tabs__panel`: `p-2`.
const _listPadding = 4.0;
const _ruleWidth = 1.0;
const _indicatorWidth = 2.0;
const _panelPadding = 8.0;

/// The list container's `calc(var(--radius) * 2.5)`.
final _listRadius = deuiRadius(DeuiTokens.radiusLg, scale: 2.5);
