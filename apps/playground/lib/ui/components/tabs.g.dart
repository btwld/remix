// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tabs.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's tab-strip recipe.
///
/// A 36px strip with a 3px inset, hugging its tabs. [PlaygroundTabsVariant.filled]
/// is a recessed `muted` list with large corners; [PlaygroundTabsVariant.line] has
/// no surface of its own.
///
/// The strip does not scroll. Put a scroll view **outside** the bar: Flutter's
/// tab-bar semantics role requires every direct semantics child to be a tab, so
/// a scroll view inside it trips an assertion.
///
/// ```dart
/// SingleChildScrollView(
///   scrollDirection: Axis.horizontal,
///   child: PlaygroundTabBar(child: Row(children: tabs)),
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
///       PlaygroundTabBar(
///         child: Row(mainAxisSize: MainAxisSize.min, children: [
///           PlaygroundTab(tabId: 'account', label: 'Account'),
///           PlaygroundTab(tabId: 'billing', label: 'Billing'),
///         ]),
///       ),
///       PlaygroundTabView(tabId: 'account', child: accountPanel),
///       PlaygroundTabView(tabId: 'billing', child: billingPanel),
///     ],
///   ),
/// )
/// ```
class PlaygroundTabBar extends StatelessWidget {
  const PlaygroundTabBar({
    super.key,
    this.variant = .filled,
    this.style = const TabBarStyler.create(),
    required this.child,
  });

  /// The default: a recessed `muted` list, with the current tab lifted onto
  /// the page color.
  const PlaygroundTabBar.filled({
    super.key,
    this.style = const TabBarStyler.create(),
    required this.child,
  }) : variant = PlaygroundTabsVariant.filled;

  /// No list surface; the current tab is marked by a `foreground` underline.
  const PlaygroundTabBar.line({
    super.key,
    this.style = const TabBarStyler.create(),
    required this.child,
  }) : variant = PlaygroundTabsVariant.line;

  final PlaygroundTabsVariant variant;

  final TabBarStyler style;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RemixTabBar(
      key: this.key,
      style: playgroundTabBarStyle(variant: this.variant, style: this.style),
      child: this.child,
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
///
/// The generated widget omits `builder`: `NakedTabState` comes from
/// `package:naked_ui`, which this layer does not import. Pass a `child` for
/// custom content, or use `RemixTab` for the raw state.
class PlaygroundTab extends StatelessWidget {
  const PlaygroundTab({
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
    this.semanticLabel,
  });

  /// The default: a recessed `muted` list, with the current tab lifted onto
  /// the page color.
  const PlaygroundTab.filled({
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
    this.semanticLabel,
  }) : variant = PlaygroundTabsVariant.filled;

  /// No list surface; the current tab is marked by a `foreground` underline.
  const PlaygroundTab.line({
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
    this.semanticLabel,
  }) : variant = PlaygroundTabsVariant.line;

  final PlaygroundTabsVariant variant;

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

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return RemixTab(
      key: this.key,
      style: playgroundTabStyle(variant: this.variant, style: this.style),
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
      semanticLabel: this.semanticLabel,
    );
  }
}

/// The panel a tab reveals. It owns the 8px gap between the strip and the
/// content.
class PlaygroundTabView extends StatelessWidget {
  const PlaygroundTabView({
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
      style: playgroundTabViewStyle(style: this.style),
      tabId: this.tabId,
      child: this.child,
      maintainState: this.maintainState,
    );
  }
}
