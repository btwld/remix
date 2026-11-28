// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tabs.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal TabBar recipe: the row of tabs over a 1px gray line.
class UiTabBar extends StatelessWidget {
  const UiTabBar({
    super.key,
    this.style = const TabBarStyler.create(),
    required this.child,
  });

  final TabBarStyler style;

  final Widget child;

  @override
  Widget build(BuildContext _) {
    return RemixTabBar(
      style: uiTabBarStyle(style: style),
      child: child,
    );
  }
}

/// The Fortal TabView recipe: the panel under the tabs, which it leaves
/// unstyled.
class UiTabView extends StatelessWidget {
  const UiTabView({
    super.key,
    this.style = const TabViewStyler.create(),
    required this.tabId,
    required this.child,
    this.maintainState = true,
    this.transitionBuilder,
    this.animationStyle = const AnimationStyle(
      curve: Curves.ease,
      duration: Duration(milliseconds: 200),
      reverseDuration: Duration(milliseconds: 200),
    ),
  });

  final TabViewStyler style;

  final String tabId;

  final Widget child;

  final bool maintainState;

  final RemixTabViewTransitionBuilder? transitionBuilder;

  final AnimationStyle animationStyle;

  @override
  Widget build(BuildContext _) {
    return RemixTabView(
      style: uiTabViewStyle(style: style),
      tabId: tabId,
      maintainState: maintainState,
      transitionBuilder: transitionBuilder,
      animationStyle: animationStyle,
      child: child,
    );
  }
}

/// The Fortal Tab recipe.
///
/// A tab is gray text, darker under the pointer, with a 2px underline in the
/// accent when selected. The underline is a transparent border at rest, so
/// selecting a tab does not move it. The selected label is medium weight, and
/// its letter spacing is adjusted so the bolder label keeps its width. A
/// disabled tab is gray-alpha-8, underline included, with no fill under the
/// pointer.
///
/// [highContrast] moves the underline to accent step 12.
class UiTab extends StatelessWidget {
  const UiTab({
    super.key,
    this.size = UiTabsSize.size2,
    this.highContrast = false,
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

  final UiTabsSize size;

  final bool highContrast;

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
  Widget build(BuildContext _) {
    return RemixTab(
      style: uiTabStyle(size: size, highContrast: highContrast, style: style),
      tabId: tabId,
      label: label,
      icon: icon,
      enabled: enabled,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      autofocus: autofocus,
      onFocusChange: onFocusChange,
      onHoverChange: onHoverChange,
      onPressChange: onPressChange,
      builder: builder,
      semanticLabel: semanticLabel,
      child: child,
    );
  }
}
