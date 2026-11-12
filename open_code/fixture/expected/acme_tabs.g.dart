// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tabs.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's tab-strip recipe.
///
/// A 36px strip with a 3px inset, hugging its tabs. [AcmeTabsVariant.filled]
/// is a recessed `muted` list with large corners; [AcmeTabsVariant.line] has
/// no surface of its own.
///
/// The strip does not scroll. Put a scroll view **outside** the bar: Flutter's
/// tab-bar semantics role requires every direct semantics child to be a tab, so
/// a scroll view inside it trips an assertion.
///
/// ```dart
/// SingleChildScrollView(
///   scrollDirection: Axis.horizontal,
///   child: AcmeTabBar(child: Row(children: tabs)),
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
///       AcmeTabBar(
///         child: Row(mainAxisSize: MainAxisSize.min, children: [
///           AcmeTab(tabId: 'account', label: 'Account'),
///           AcmeTab(tabId: 'billing', label: 'Billing'),
///         ]),
///       ),
///       AcmeTabView(tabId: 'account', child: accountPanel),
///       AcmeTabView(tabId: 'billing', child: billingPanel),
///     ],
///   ),
/// )
/// ```
class AcmeTabBar extends StatelessWidget {
  const AcmeTabBar({
    super.key,
    this.variant = .filled,
    this.style = const TabBarStyler.create(),
    required this.child,
  });

  /// The default: a recessed `muted` list, with the current tab lifted onto
  /// the page color.
  const AcmeTabBar.filled({
    super.key,
    this.style = const TabBarStyler.create(),
    required this.child,
  }) : variant = AcmeTabsVariant.filled;

  /// No list surface; the current tab is marked by a `foreground` underline.
  const AcmeTabBar.line({
    super.key,
    this.style = const TabBarStyler.create(),
    required this.child,
  }) : variant = AcmeTabsVariant.line;

  final AcmeTabsVariant variant;

  final TabBarStyler style;

  final Widget child;

  @override
  Widget build(BuildContext _) {
    return RemixTabBar(
      key: key,
      style: acmeTabBarStyle(variant: variant, style: style),
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
///
/// The generated widget omits `builder`: `NakedTabState` comes from
/// `package:naked_ui`, which this layer does not import. Pass a `child` for
/// custom content, or use `RemixTab` for the raw state.
class AcmeTab extends StatelessWidget {
  const AcmeTab({
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
  const AcmeTab.filled({
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
  }) : variant = AcmeTabsVariant.filled;

  /// No list surface; the current tab is marked by a `foreground` underline.
  const AcmeTab.line({
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
  }) : variant = AcmeTabsVariant.line;

  final AcmeTabsVariant variant;

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
  Widget build(BuildContext _) {
    return RemixTab(
      key: key,
      style: acmeTabStyle(variant: variant, style: style),
      tabId: tabId,
      child: child,
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
      semanticLabel: semanticLabel,
    );
  }
}

/// The panel a tab reveals. It owns the 8px gap between the strip and the
/// content.
class AcmeTabView extends StatelessWidget {
  const AcmeTabView({
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
  Widget build(BuildContext _) {
    return RemixTabView(
      key: key,
      style: acmeTabViewStyle(style: style),
      tabId: tabId,
      child: child,
      maintainState: maintainState,
    );
  }
}
