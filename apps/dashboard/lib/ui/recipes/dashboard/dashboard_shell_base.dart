import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

/// The layout state exposed to the shared dashboard composition.
abstract interface class UiDashboardLayoutControls {
  bool get isCompact;

  void openCompact();

  void closeCompact();
}

typedef UiDashboardRegionBuilder =
    Widget Function(BuildContext context, UiDashboardLayoutControls controls);

typedef UiDashboardLayoutBuilder =
    Widget Function(
      BuildContext context, {
      required bool collapsed,
      required Widget body,
      required UiDashboardRegionBuilder sidebarBuilder,
      required UiDashboardRegionBuilder headerBuilder,
    });

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

typedef UiDashboardIconButtonBuilder =
    Widget Function(
      BuildContext context, {
      required Key key,
      required IconData icon,
      required String semanticLabel,
      required VoidCallback onPressed,
    });

typedef UiDashboardAppBarBuilder =
    Widget Function(
      BuildContext context, {
      required Widget? leading,
      required String title,
      required Widget titleChild,
      required List<Widget> actions,
    });

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

  /// Optional visible title composition. [title] remains the accessible label
  /// and the fallback when this is null.
  final Widget? headerTitle;
  final Widget brand;
  final Widget? account;
  final List<Widget> headerActions;
  final ValueChanged<String>? onSearchChanged;
  final String searchHintText;
  final String navigationSemanticLabel;

  /// Controlled desktop collapse state. Null lets the shell own it.
  final bool? collapsed;
  final bool initiallyCollapsed;
  final ValueChanged<bool>? onCollapsedChanged;

  /// The header width, in logical pixels, from which the search field shows.
  final double searchBreakpoint;
  final double searchWidth;

  /// The gap between the brand and the collapse button in the sidebar header.
  /// The app bar's own recipe spaces the page header.
  final double headerSpacing;

  final UiDashboardLayoutBuilder layoutBuilder;
  final UiDashboardSidebarBuilder<T> sidebarBuilder;

  /// Builds the page header from the installed `app_bar` recipe.
  final UiDashboardAppBarBuilder appBarBuilder;
  final UiDashboardIconButtonBuilder iconButtonBuilder;
  final UiDashboardSearchBuilder searchBuilder;

  /// The sidebar's brand row. Give it the app bar's toolbar height and bottom
  /// edge so the two line up across the shell.
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
    return widget.sidebarBuilder(
      context,
      collapsed: collapsed,
      sections: widget.sections,
      selectedValue: widget.selectedValue,
      onSelected: (value) {
        widget.onSelected(value);
        controls.closeCompact();
      },
      header: Box(
        style: widget.sidebarHeaderStyle,
        child: RowBox(
          style: FlexBoxStyler()
              .spacing(collapsed ? 0 : widget.headerSpacing)
              .mainAxisAlignment(collapsed ? .center : .start),
          children: [
            if (!collapsed)
              Expanded(
                child: DefaultTextStyle.merge(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  child: widget.brand,
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
      ),
      footer: collapsed ? null : widget.account,
      semanticLabel: widget.navigationSemanticLabel,
    );
  }

  Widget _buildHeader(
    BuildContext context,
    UiDashboardLayoutControls controls,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showSearch =
            widget.onSearchChanged != null &&
            constraints.maxWidth >= widget.searchBreakpoint;
        return widget.appBarBuilder(
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
              SizedBox(
                width: widget.searchWidth,
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
      },
    );
  }

  IconData _collapseIcon(BuildContext context, bool collapsed) {
    final ltr = Directionality.of(context) == TextDirection.ltr;
    if (collapsed) return ltr ? widget.forwardIcon : widget.backwardIcon;
    return ltr ? widget.backwardIcon : widget.forwardIcon;
  }
}
