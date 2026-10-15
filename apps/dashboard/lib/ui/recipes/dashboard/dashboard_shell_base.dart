import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

/// The layout state and navigation controls exposed to the dashboard shell.
abstract interface class UiDashboardLayoutControls {
  /// Whether the dashboard layout is in compact mode.
  bool get isCompact;

  /// Opens the navigation drawer in compact mode.
  void openCompact();

  /// Closes the navigation drawer in compact mode.
  void closeCompact();
}

/// Builds a dashboard region given layout [controls].
typedef UiDashboardRegionBuilder =
    Widget Function(BuildContext context, UiDashboardLayoutControls controls);

/// Builds the outer layout structure for the dashboard shell.
typedef UiDashboardLayoutBuilder =
    Widget Function(
      BuildContext context, {
      required bool collapsed,
      required Widget body,
      required UiDashboardRegionBuilder sidebarBuilder,
      required UiDashboardRegionBuilder headerBuilder,
    });

/// Builds the sidebar navigation panel for the dashboard shell.
typedef UiDashboardSidebarBuilder<T extends Object> =
    Widget Function(
      BuildContext context, {
      required bool collapsed,
      required List<RemixSidebarSection<T>> sections,
      required T? selectedValue,
      required ValueChanged<T> onSelected,
      required Widget header,
      required Widget? footer,
      required String semanticLabel,
    });

/// Builds an icon button for dashboard controls.
typedef UiDashboardIconButtonBuilder =
    Widget Function(
      BuildContext context, {
      required Key key,
      required IconData icon,
      required String semanticLabel,
      required VoidCallback onPressed,
    });

/// Builds the page app bar for the dashboard shell.
typedef UiDashboardAppBarBuilder =
    Widget Function(
      BuildContext context, {
      required Widget? leading,
      required String title,
      required Widget titleChild,
      required List<Widget> actions,
    });

/// Builds the search input field for the dashboard shell.
typedef UiDashboardSearchBuilder =
    Widget Function(
      BuildContext context, {
      required Key key,
      required String hintText,
      required Widget leading,
      required ValueChanged<String> onChanged,
    });

/// Shared behavior and composition for a source-owned dashboard shell.
///
/// The host owns navigation state, page content, and product actions. The
/// installed preset supplies the sidebar, layout, controls, and unresolved
/// styles so this implementation never branches on a preset name.
class UiDashboardShellBase<T extends Object> extends StatefulWidget {
  const UiDashboardShellBase({
    super.key,
    required this.sections,
    required this.selectedValue,
    required this.onSelected,
    required this.body,
    required this.title,
    required this.brand,
    required this.layoutBuilder,
    required this.sidebarBuilder,
    required this.appBarBuilder,
    required this.iconButtonBuilder,
    required this.searchBuilder,
    required this.sidebarHeaderStyle,
    required this.menuIcon,
    required this.searchIcon,
    required this.backwardIcon,
    required this.forwardIcon,
    this.headerTitle,
    this.account,
    this.headerActions = const [],
    this.onSearchChanged,
    this.searchHintText = 'Search…',
    this.navigationSemanticLabel = 'Dashboard navigation',
    this.collapsed,
    this.initiallyCollapsed = false,
    this.onCollapsedChanged,
    this.searchBreakpoint = 760,
    this.searchWidth = 240,
    this.headerSpacing = 12,
  }) : assert(searchBreakpoint > 0),
       assert(searchWidth > 0),
       assert(headerSpacing >= 0);

  final List<RemixSidebarSection<T>> sections;
  final T? selectedValue;
  final ValueChanged<T> onSelected;
  final Widget body;
  final String title;

  /// The custom widget displayed in place of the page title.
  ///
  /// When this is `null`, the header displays [title]. [title] always serves
  /// as the accessible label.
  final Widget? headerTitle;
  final Widget brand;
  final Widget? account;
  final List<Widget> headerActions;
  final ValueChanged<String>? onSearchChanged;
  final String searchHintText;
  final String navigationSemanticLabel;

  /// Whether the desktop sidebar is collapsed.
  ///
  /// When `null`, the shell manages its own collapse state.
  final bool? collapsed;

  /// Whether the desktop sidebar is initially collapsed when uncontrolled.
  final bool initiallyCollapsed;

  /// Called when the sidebar collapse state changes.
  final ValueChanged<bool>? onCollapsedChanged;

  /// The minimum header width in logical pixels required to display search.
  final double searchBreakpoint;

  /// The width of the search field in logical pixels.
  final double searchWidth;

  /// The gap between the brand widget and the collapse button in the sidebar header.
  final double headerSpacing;

  final UiDashboardLayoutBuilder layoutBuilder;
  final UiDashboardSidebarBuilder<T> sidebarBuilder;

  /// The builder that creates the page app bar.
  final UiDashboardAppBarBuilder appBarBuilder;
  final UiDashboardIconButtonBuilder iconButtonBuilder;
  final UiDashboardSearchBuilder searchBuilder;

  /// The style applied to the sidebar header container.
  ///
  /// Set this to match the app bar toolbar height and bottom border to align
  /// the sidebar and header rows across the shell.
  final BoxStyler sidebarHeaderStyle;
  final IconData menuIcon;
  final IconData searchIcon;
  final IconData backwardIcon;
  final IconData forwardIcon;

  @override
  State<UiDashboardShellBase<T>> createState() =>
      _UiDashboardShellBaseState<T>();
}

class _UiDashboardShellBaseState<T extends Object>
    extends State<UiDashboardShellBase<T>> {
  late bool _selfCollapsed = widget.initiallyCollapsed;

  // SidebarLayout changes the body's ancestry at its responsive breakpoint.
  // A GlobalKey preserves host page state through that reparenting.
  final _bodyKey = GlobalKey();

  bool get _collapsed => widget.collapsed ?? _selfCollapsed;

  void _setCollapsed(bool value) {
    if (_collapsed == value) return;
    if (widget.collapsed == null) setState(() => _selfCollapsed = value);
    widget.onCollapsedChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return widget.layoutBuilder(
      context,
      collapsed: _collapsed,
      body: KeyedSubtree(key: _bodyKey, child: widget.body),
      sidebarBuilder: _buildSidebar,
      headerBuilder: _buildHeader,
    );
  }

  Widget _buildSidebar(
    BuildContext context,
    UiDashboardLayoutControls controls,
  ) {
    final collapsed = !controls.isCompact && _collapsed;
    final account = widget.account;
    return widget.sidebarBuilder(
      context,
      collapsed: collapsed,
      sections: widget.sections,
      selectedValue: widget.selectedValue,
      onSelected: (value) {
        widget.onSelected(value);
        controls.closeCompact();
      },
      header: Builder(
        builder: (context) {
          final motion = RemixSidebar.maybeAnimationOf(context);
          final expansion = motion?.expansion ?? (collapsed ? 0.0 : 1.0);
          final labelOpacity = motion?.labelOpacity ?? expansion;
          final showBrand = controls.isCompact ? !collapsed : expansion > 0;
          return Box(
            style: widget.sidebarHeaderStyle,
            child: RowBox(
              style: FlexBoxStyler()
                  .spacing(
                    controls.isCompact
                        ? (collapsed ? 0 : widget.headerSpacing)
                        : widget.headerSpacing * expansion,
                  )
                  .mainAxisAlignment(showBrand ? .start : .center),
              children: [
                if (showBrand)
                  Expanded(
                    child: Opacity(
                      opacity: controls.isCompact ? 1 : labelOpacity,
                      child: DefaultTextStyle.merge(
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        child: widget.brand,
                      ),
                    ),
                  ),
                if (!controls.isCompact)
                  widget.iconButtonBuilder(
                    context,
                    key: const ValueKey('dashboard-collapse'),
                    icon: _collapseIcon(context, collapsed),
                    semanticLabel: collapsed
                        ? 'Expand navigation'
                        : 'Collapse navigation',
                    onPressed: () => _setCollapsed(!collapsed),
                  ),
              ],
            ),
          );
        },
      ),
      footer: account == null || collapsed
          ? null
          : _SidebarFooterSlot(
              collapsed: collapsed,
              isCompact: controls.isCompact,
              child: account,
            ),
      semanticLabel: widget.navigationSemanticLabel,
    );
  }

  Widget _buildHeader(
    BuildContext context,
    UiDashboardLayoutControls controls,
  ) {
    Widget buildAppBar(bool showSearch) => widget.appBarBuilder(
      context,
      leading: controls.isCompact
          ? widget.iconButtonBuilder(
              context,
              key: const ValueKey('dashboard-menu'),
              icon: widget.menuIcon,
              semanticLabel: 'Open navigation',
              onPressed: controls.openCompact,
            )
          : null,
      // The app bar names its heading with [title] and renders this,
      // which inherits the recipe's title style.
      title: widget.title,
      titleChild: KeyedSubtree(
        key: const ValueKey('dashboard-title'),
        child: widget.headerTitle ?? Text(widget.title),
      ),
      actions: [
        if (showSearch)
          Box(
            style: BoxStyler().width(widget.searchWidth),
            child: widget.searchBuilder(
              context,
              key: const ValueKey('dashboard-search'),
              hintText: widget.searchHintText,
              leading: Icon(widget.searchIcon, size: 16),
              onChanged: widget.onSearchChanged!,
            ),
          ),
        ...widget.headerActions,
      ],
    );

    if (widget.onSearchChanged == null) {
      return buildAppBar(false);
    }
    return LayoutBuilder(
      builder: (context, constraints) =>
          buildAppBar(constraints.maxWidth >= widget.searchBreakpoint),
    );
  }

  IconData _collapseIcon(BuildContext context, bool collapsed) {
    final ltr = Directionality.of(context) == TextDirection.ltr;
    if (collapsed) return ltr ? widget.forwardIcon : widget.backwardIcon;
    return ltr ? widget.backwardIcon : widget.forwardIcon;
  }
}

class _SidebarFooterSlot extends StatelessWidget {
  const _SidebarFooterSlot({
    required this.collapsed,
    required this.isCompact,
    required this.child,
  });

  final bool collapsed;
  final bool isCompact;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return collapsed ? const SizedBox.shrink() : child;
    }
    final motion = RemixSidebar.maybeAnimationOf(context);
    final expansion = motion?.expansion ?? (collapsed ? 0.0 : 1.0);
    final labelOpacity = motion?.labelOpacity ?? expansion;
    if (labelOpacity == 0) {
      return const SizedBox.shrink();
    }
    if (expansion == 1 && !(motion?.isAnimating ?? false)) {
      return child;
    }
    return Opacity(
      opacity: labelOpacity,
      child: IgnorePointer(ignoring: collapsed, child: child),
    );
  }
}
