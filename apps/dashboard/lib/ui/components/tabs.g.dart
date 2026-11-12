// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tabs.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Ui TabBar recipe: the row of tabs over a 1px gray line.
class UiTabBar extends StatelessWidget {
  const UiTabBar({
    super.key,
    this.style = const TabBarStyler.create(),
    required this.child,
  });

  final TabBarStyler style;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RemixTabBar(
      key: this.key,
      style: uiTabBarStyle(style: this.style),
      child: this.child,
    );
  }
}

/// The Ui TabView recipe: the panel under the tabs, which it leaves
/// unstyled.
class UiTabView extends StatelessWidget {
  const UiTabView({
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
      style: uiTabViewStyle(style: this.style),
      tabId: this.tabId,
      child: this.child,
      maintainState: this.maintainState,
    );
  }
}

/// The Ui Tab recipe.
///
/// A tab is gray text, darker under the pointer, with a 2px underline in the
/// accent when selected. The underline is a transparent border at rest, so
/// selecting a tab does not move it. The selected label is medium weight, and
/// its letter spacing is adjusted so the bolder label keeps its width.
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
  Widget build(BuildContext context) {
    return RemixTab(
      key: this.key,
      style: uiTabStyle(
        size: this.size,
        highContrast: this.highContrast,
        style: this.style,
      ),
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
