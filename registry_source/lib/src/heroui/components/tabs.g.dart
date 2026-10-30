// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tabs.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixTabBar], the tab list container.
class HeroUiTabBar extends StatelessWidget {
  const HeroUiTabBar({
    super.key,
    this.variant = .primary,
    this.style = const TabBarStyler.create(),
    required this.child,
  });

  const HeroUiTabBar.primary({
    super.key,
    this.style = const TabBarStyler.create(),
    required this.child,
  }) : variant = HeroUiTabsVariant.primary;

  const HeroUiTabBar.secondary({
    super.key,
    this.style = const TabBarStyler.create(),
    required this.child,
  }) : variant = HeroUiTabsVariant.secondary;

  final HeroUiTabsVariant variant;

  final TabBarStyler style;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RemixTabBar(
      key: this.key,
      style: heroUiTabBarStyle(variant: this.variant, style: this.style),
      child: this.child,
    );
  }
}

/// HeroUI recipe for [RemixTab].
///
/// The selected tab paints the indicator itself; upstream slides one shared
/// indicator between tabs.
class HeroUiTab extends StatelessWidget {
  const HeroUiTab({
    super.key,
    this.variant = .primary,
    this.style = const TabStyler.create(),
    required this.tabId,
    this.child,
    this.label,
    this.icon,
    this.enabled = true,
    this.mouseCursor = SystemMouseCursors.click,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.onHoverChange,
    this.onPressChange,
    this.builder,
    this.semanticLabel,
  });

  const HeroUiTab.primary({
    super.key,
    this.style = const TabStyler.create(),
    required this.tabId,
    this.child,
    this.label,
    this.icon,
    this.enabled = true,
    this.mouseCursor = SystemMouseCursors.click,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.onHoverChange,
    this.onPressChange,
    this.builder,
    this.semanticLabel,
  }) : variant = HeroUiTabsVariant.primary;

  const HeroUiTab.secondary({
    super.key,
    this.style = const TabStyler.create(),
    required this.tabId,
    this.child,
    this.label,
    this.icon,
    this.enabled = true,
    this.mouseCursor = SystemMouseCursors.click,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.onHoverChange,
    this.onPressChange,
    this.builder,
    this.semanticLabel,
  }) : variant = HeroUiTabsVariant.secondary;

  final HeroUiTabsVariant variant;

  final TabStyler style;

  final String tabId;

  final Widget? child;

  final String? label;

  final IconData? icon;

  final bool enabled;

  final MouseCursor mouseCursor;

  final bool enableFeedback;

  final FocusNode? focusNode;

  final bool autofocus;

  final ValueChanged<bool>? onFocusChange;

  final ValueChanged<bool>? onHoverChange;

  final ValueChanged<bool>? onPressChange;

  final ValueWidgetBuilder<NakedTabState>? builder;

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return RemixTab(
      key: this.key,
      style: heroUiTabStyle(variant: this.variant, style: this.style),
      tabId: this.tabId,
      child: this.child,
      label: this.label,
      icon: this.icon,
      enabled: this.enabled,
      mouseCursor: this.mouseCursor,
      enableFeedback: this.enableFeedback,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      onFocusChange: this.onFocusChange,
      onHoverChange: this.onHoverChange,
      onPressChange: this.onPressChange,
      builder: this.builder,
      semanticLabel: this.semanticLabel,
    );
  }
}

/// HeroUI recipe for [RemixTabView], the panel below the list.
class HeroUiTabView extends StatelessWidget {
  const HeroUiTabView({
    super.key,
    this.style = const TabViewStyler.create(),
    required this.tabId,
    required this.child,
    this.maintainState = true,
  });

  final TabViewStyler style;

  final String tabId;

  final Widget child;

  final bool maintainState;

  @override
  Widget build(BuildContext context) {
    return RemixTabView(
      key: this.key,
      style: heroUiTabViewStyle(style: this.style),
      tabId: this.tabId,
      child: this.child,
      maintainState: this.maintainState,
    );
  }
}
