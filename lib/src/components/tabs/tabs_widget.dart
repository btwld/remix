part of 'tabs.dart';

/// A customizable tabs component that supports tab navigation and content switching.
///
/// ## Example
///
/// ```dart
/// RemixTabs(
///   selectedTabId: 'tab1',
///   onChanged: (id) => setState(() => selectedTabId = id),
///   child: Column(
///     children: [
///       RemixTabBar(
///         child: Row(
///           children: [
///             RemixTab(tabId: 'tab1', child: Text('Tab 1')),
///             RemixTab(tabId: 'tab2', child: Text('Tab 2')),
///           ],
///         ),
///       ),
///       Expanded(
///         child: Column(
///           children: [
///             RemixTabView(tabId: 'tab1', child: Text('Content 1')),
///             RemixTabView(tabId: 'tab2', child: Text('Content 2')),
///           ],
///         ),
///       ),
///     ],
///   ),
/// )
/// ```
class RemixTabs extends StatelessWidget {
  const RemixTabs({
    super.key,
    required this.child,
    this.controller,
    this.selectedTabId,
    this.onChanged,
    this.orientation = Axis.horizontal,
    this.enabled = true,
    this.onEscapePressed,
    this.style = const RemixTabsStyle.create(),
  }) : assert(
          controller != null || selectedTabId != null,
          'Either controller or selectedTabId must be provided',
        );

  /// The tabs content.
  final Widget child;

  /// Optional controller for managing tab state.
  final NakedTabController? controller;

  /// The identifier of the currently selected tab.
  final String? selectedTabId;

  /// Called when the selected tab changes.
  final ValueChanged<String>? onChanged;

  /// Whether the tabs are enabled.
  final bool enabled;

  /// The tab list orientation.
  final Axis orientation;

  /// Called when Escape is pressed while a tab has focus.
  final VoidCallback? onEscapePressed;

  /// The style configuration for the tabs.
  final RemixTabsStyle style;

  static late final styleFrom = RemixTabsStyle.new;

  @override
  Widget build(BuildContext context) {
    return NakedTabs(
      controller: controller,
      selectedTabId: selectedTabId,
      onChanged: onChanged,
      orientation: orientation,
      enabled: enabled,
      onEscapePressed: onEscapePressed,
      child: StyleBuilder(
        style: style,
        builder: (context, spec) {
          return FlexBox(styleSpec: spec.container, children: [child]);
        },
      ),
    );
  }
}

/// A container widget for tab buttons.
class RemixTabBar extends StatelessWidget {
  const RemixTabBar({super.key, required this.child});

  /// The tab buttons.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// An individual tab button.
class RemixTab extends StatelessWidget {
  const RemixTab({
    super.key,
    this.child,
    required this.tabId,
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
    this.style = const RemixTabStyle.create(),
    this.icon,
    this.label,
  }) : assert(
          child != null || builder != null || label != null,
          'Either child, builder, or label must be provided',
        );

  /// The tab content when not using [builder].
  final Widget? child;

  /// The unique identifier for this tab.
  final String tabId;

  /// Whether this tab is enabled.
  final bool enabled;

  /// The mouse cursor for this tab.
  final MouseCursor mouseCursor;

  /// Whether to enable haptic feedback.
  final bool enableFeedback;

  /// Optional focus node for this tab.
  final FocusNode? focusNode;

  /// Whether this tab should automatically request focus.
  final bool autofocus;

  /// Called when focus changes.
  final ValueChanged<bool>? onFocusChange;

  /// Called when hover changes.
  final ValueChanged<bool>? onHoverChange;

  /// Called when press state changes.
  final ValueChanged<bool>? onPressChange;

  /// Custom builder for the tab content.
  final ValueWidgetBuilder<NakedTabState>? builder;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  /// The style configuration for this tab.
  final RemixTabStyle style;

  /// Optional icon to display in the tab.
  final IconData? icon;

  /// Optional label text for the tab.
  final String? label;

  static late final styleFrom = RemixTabStyle.new;

  @override
  Widget build(BuildContext context) {
    return NakedTab(
      tabId: tabId,
      enabled: enabled,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      autofocus: autofocus,
      onFocusChange: onFocusChange,
      onHoverChange: onHoverChange,
      onPressChange: onPressChange,
      semanticLabel: semanticLabel ?? label,
      builder: (context, state, _) {
        return StyleBuilder(
          style: style,
          controller: NakedTabState.controllerOf(context),
          builder: (context, spec) {
            // Use custom builder if provided
            if (builder != null) {
              return builder!(context, state, child);
            }

            // Use custom child if provided
            if (child != null) {
              return child!;
            }

            // Default content with label and icon
            return FlexBox(
              styleSpec: spec.container,
              children: [
                if (icon != null) StyledIcon(icon: icon!, styleSpec: spec.icon),
                if (label != null) StyledText(label!, styleSpec: spec.label),
              ],
            );
          },
        );
      },
    );
  }
}

/// A tab content panel that is shown when its corresponding tab is selected.
class RemixTabView extends StatelessWidget {
  const RemixTabView({super.key, required this.tabId, required this.child});

  /// The unique identifier that matches a tab.
  final String tabId;

  /// The content to show when this tab is selected.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NakedTabView(tabId: tabId, child: child);
  }
}
