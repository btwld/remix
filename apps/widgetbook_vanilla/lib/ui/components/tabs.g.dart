// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tabs.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's tab-strip recipe.
///
/// A 36px strip with a 3px inset, hugging its tabs. [VanillaTabsVariant.filled]
/// is a recessed `muted` list with large corners; [VanillaTabsVariant.line] has
/// no surface of its own.
///
/// The strip does not scroll. Put a scroll view **outside** the bar: Flutter's
/// tab-bar semantics role requires every direct semantics child to be a tab, so
/// a scroll view inside it trips an assertion.
///
/// ```dart
/// SingleChildScrollView(
///   scrollDirection: Axis.horizontal,
///   child: VanillaTabBar(child: Row(children: tabs)),
/// )
/// ```
///
/// `RemixTabs`, which owns selection and roving focus, has no styler and no
/// recipe. Wrap the bar and the views in it directly:
///
/// ```dart
/// RemixTabs(
///   selectedTabId: tab,
///   onChanged: (id) => setState(() => tab = id),
///   child: Column(
///     crossAxisAlignment: CrossAxisAlignment.start,
///     children: [
///       VanillaTabBar(
///         child: Row(mainAxisSize: MainAxisSize.min, children: [
///           VanillaTab(tabId: 'account', label: 'Account'),
///           VanillaTab(tabId: 'billing', label: 'Billing'),
///         ]),
///       ),
///       VanillaTabView(tabId: 'account', child: accountPanel),
///       VanillaTabView(tabId: 'billing', child: billingPanel),
///     ],
///   ),
/// )
/// ```
class VanillaTabBar extends StatelessWidget {
  const VanillaTabBar({
    super.key,
    this.variant = .filled,
    this.style = const TabBarStyler.create(),
    required this.child,
  });

  /// The default: a recessed `muted` list, with the current tab lifted onto
  /// the page color.
  const VanillaTabBar.filled({
    super.key,
    this.style = const TabBarStyler.create(),
    required this.child,
  }) : variant = VanillaTabsVariant.filled;

  /// No list surface; the current tab is marked by a `foreground` underline.
  const VanillaTabBar.line({
    super.key,
    this.style = const TabBarStyler.create(),
    required this.child,
  }) : variant = VanillaTabsVariant.line;

  final VanillaTabsVariant variant;

  final TabBarStyler style;

  final Widget child;

  @override
  Widget build(BuildContext _) {
    return RemixTabBar(
      style: vanillaTabBarStyle(variant: variant, style: style),
      child: child,
    );
  }
}

/// The application's Tab recipe.
///
/// `textSm` at medium weight, 60% `foreground` until hovered or current
/// (`mutedForeground` in the dark theme). In the filled list the current tab is
/// lifted onto the page color with a small shadow; in the dark theme onto a
/// faint `input` well with an `input` outline, since the dark page is darker
/// than the list. In the line list it is underlined in `foreground` instead.
class VanillaTab extends StatelessWidget {
  const VanillaTab({
    super.key,
    this.variant = .filled,
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

  /// The default: a recessed `muted` list, with the current tab lifted onto
  /// the page color.
  const VanillaTab.filled({
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
  }) : variant = VanillaTabsVariant.filled;

  /// No list surface; the current tab is marked by a `foreground` underline.
  const VanillaTab.line({
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
  }) : variant = VanillaTabsVariant.line;

  final VanillaTabsVariant variant;

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
      style: vanillaTabStyle(variant: variant, style: style),
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

/// The panel a tab reveals. It owns the 8px gap between the strip and the
/// content.
class VanillaTabView extends StatelessWidget {
  const VanillaTabView({
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
      style: vanillaTabViewStyle(style: style),
      tabId: tabId,
      maintainState: maintainState,
      transitionBuilder: transitionBuilder,
      animationStyle: animationStyle,
      child: child,
    );
  }
}
