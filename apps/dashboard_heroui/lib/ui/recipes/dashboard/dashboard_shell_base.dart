import 'dart:math' as math;

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
    this.collapsedAccount,
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

  /// The sidebar's navigation groups and destinations.
  final List<RemixSidebarSection<T>> sections;

  /// The selected destination, or null when none is.
  final T? selectedValue;

  /// Called when a destination is chosen.
  final ValueChanged<T> onSelected;

  /// The page content.
  final Widget body;

  /// The page title, shown in the header and used as its accessible label.
  final String title;

  /// The custom widget displayed in place of the page title.
  ///
  /// When this is `null`, the header displays [title]. [title] always serves
  /// as the accessible label.
  final Widget? headerTitle;

  /// The brand shown at the top of the sidebar.
  final Widget brand;

  /// The footer content of the sidebar, such as the signed-in account.
  final Widget? account;

  /// The footer content shown while the desktop sidebar is collapsed.
  ///
  /// When `null`, the footer is hidden in the collapsed rail.
  final Widget? collapsedAccount;

  /// Widgets at the trailing end of the header, after the search field.
  final List<Widget> headerActions;

  /// Called with the search text. The search field is omitted when null.
  final ValueChanged<String>? onSearchChanged;

  /// Placeholder of the search field.
  final String searchHintText;

  /// Accessible label of the navigation sidebar.
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

  /// Builds the outer structure that places the sidebar, header and body.
  final UiDashboardLayoutBuilder layoutBuilder;

  /// Builds the sidebar panel.
  final UiDashboardSidebarBuilder<T> sidebarBuilder;

  /// The builder that creates the page app bar.
  final UiDashboardAppBarBuilder appBarBuilder;

  /// Builds the menu and collapse buttons.
  final UiDashboardIconButtonBuilder iconButtonBuilder;

  /// Builds the header's search field.
  final UiDashboardSearchBuilder searchBuilder;

  /// The style applied to the sidebar header container.
  ///
  /// Set this to match the app bar toolbar height and bottom border to align
  /// the sidebar and header rows across the shell.
  final BoxStyler sidebarHeaderStyle;

  /// Icon of the button that opens the navigation in compact mode.
  final IconData menuIcon;

  /// Icon at the start of the search field.
  final IconData searchIcon;

  /// Collapse icon that points toward the start edge in a left-to-right layout.
  final IconData backwardIcon;

  /// Collapse icon that points toward the end edge in a left-to-right layout.
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
          final showBrand = controls.isCompact || expansion > 0;
          // The brand and the collapse button split a 2000-part row. Expanded,
          // the brand takes all of it; collapsed, equal parts on each side
          // center the button.
          final trailingFlex = controls.isCompact
              ? 0
              : ((1 - expansion) * 1000).round();
          final leadingFlex = 2000 - trailingFlex;
          final brandGap = controls.isCompact
              ? 0.0
              : widget.headerSpacing * expansion;
          return Box(
            style: widget.sidebarHeaderStyle,
            child: RowBox(
              children: [
                Expanded(
                  flex: leadingFlex,
                  child: showBrand
                      ? Padding(
                          padding: EdgeInsetsDirectional.only(end: brandGap),
                          child: Opacity(
                            opacity: controls.isCompact ? 1 : labelOpacity,
                            child: DefaultTextStyle.merge(
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              child: widget.brand,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
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
                if (trailingFlex > 0) Spacer(flex: trailingFlex),
              ],
            ),
          );
        },
      ),
      footer: account == null
          ? null
          : _SidebarFooterSlot(
              collapsed: collapsed,
              collapsedChild: widget.collapsedAccount,
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
        child: widget.headerTitle ?? StyledText(widget.title),
      ),
      actions: [
        if (showSearch)
          Box(
            style: BoxStyler().width(widget.searchWidth),
            child: widget.searchBuilder(
              context,
              key: const ValueKey('dashboard-search'),
              hintText: widget.searchHintText,
              leading: StyledIcon(
                icon: widget.searchIcon,
                style: IconStyler().size(16),
              ),
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
    required this.child,
    this.collapsedChild,
  });

  /// Narrowest width the footer lays out at, so it does not reflow while the
  /// sidebar animates narrower.
  static const _minChildWidth = 220.0;

  final bool collapsed;
  final Widget child;
  final Widget? collapsedChild;

  @override
  Widget build(BuildContext context) {
    final motion = RemixSidebar.maybeAnimationOf(context);
    final expansion = motion?.expansion ?? (collapsed ? 0.0 : 1.0);
    final labelOpacity = motion?.labelOpacity ?? expansion;
    final animating = motion?.isAnimating ?? false;
    final rail = collapsedChild;
    if (rail != null && expansion < 0.5) return rail;
    if (expansion == 0 && !animating) {
      return const SizedBox.shrink();
    }
    if (expansion == 1 && !animating) {
      return child;
    }
    return ClipRect(
      child: Align(
        alignment: AlignmentDirectional.topStart,
        heightFactor: rail == null ? expansion : 1,
        child: Opacity(
          opacity: labelOpacity,
          child: IgnorePointer(
            ignoring: collapsed,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final targetWidth = math.max(
                  constraints.maxWidth,
                  _minChildWidth,
                );
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  child: SizedBox(width: targetWidth, child: child),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
