// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tabs.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's tab-strip recipe.
///
/// The strip is shadcn's `TabsList`: 36px tall with a 3px inset, hugging its
/// tabs. The [PlaygroundTabsVariant.filled] list is a recessed `muted` surface
/// with large corners; the [PlaygroundTabsVariant.line] list has no surface of
/// its own.
///
/// The strip does not scroll. Tabs wider than the container are a layout
/// decision, and the scroll view belongs **outside** the bar:
///
/// ```dart
/// SingleChildScrollView(
///   scrollDirection: Axis.horizontal,
///   child: PlaygroundTabBar(child: Row(children: tabs)),
/// )
/// ```
///
/// Not inside it. Flutter's tab-bar semantics role requires every direct
/// semantics child of the bar to be a tab, and a scroll view inserted between
/// them adds a node of its own, which trips that assertion at runtime.
///
/// `RemixTabs` — the behavioral root that owns selection, roving focus, and
/// arrow-key traversal — carries no styler and therefore no recipe. Compose it
/// directly around this bar:
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
/// Everything visual about one tab lives in this function: geometry,
/// typography, and the hover/selected/focus/disabled fragments. Remix keeps
/// ownership of rendering, selection, keyboard traversal, and the tab
/// accessibility semantics — this recipe never reimplements any of that.
///
/// It is shadcn's `TabsTrigger`: `textSm` at medium weight, 60% `foreground`
/// until it is hovered or current (`mutedForeground` in the dark theme). In
/// the filled list the current tab is lifted onto the page color with a small
/// shadow — in the dark theme onto a faint `input` well with an `input`
/// outline, since the dark page is darker than the list it would lift out of.
/// In the line list the current tab is underlined in `foreground` instead.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it. State fragments merge by state, not
/// by depth: an override that must beat the recipe's current tab has to be
/// declared as a selected fragment too (`TabStyler().onSelected(...)`).
///
/// `builder` is deliberately not forwarded to the generated
/// `PlaygroundTab`. Its type is `ValueWidgetBuilder<NakedTabState>`, and
/// `NakedTabState` comes from `package:naked_ui`, which this layer does not
/// depend on. Pass a `child` for custom content, or reach for `RemixTab`
/// directly on the rare call site that needs the raw state.
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

/// The application's recipe for the panel a tab reveals.
///
/// It exists so the panel carries the application's prefix and has one place
/// to edit, and it earns that by owning the gap between the strip and the
/// content: shadcn's `gap-2`.
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
