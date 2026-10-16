import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

/// The navigation groups shared across dashboard showcase presets.
enum UiDashboardDemoSection {
  workspace('Workspace'),
  data('Data'),
  manage('Manage');

  const UiDashboardDemoSection(this.label);

  final String label;
}

/// The navigation destinations in the dashboard demo.
enum UiDashboardDemoPage {
  overview(UiDashboardDemoSection.workspace, 'Overview', RemixIcons.dashboard),
  chat(UiDashboardDemoSection.workspace, 'Chat', RemixIcons.chatBubble),
  customers(UiDashboardDemoSection.data, 'Customers', RemixIcons.group),
  orders(UiDashboardDemoSection.data, 'Orders', RemixIcons.table),
  settings(
    UiDashboardDemoSection.manage,
    'Settings',
    RemixIcons.mixerHorizontal,
  );

  const UiDashboardDemoPage(this.section, this.label, this.icon);

  final UiDashboardDemoSection section;
  final String label;
  final IconData icon;
}

/// The section identifiers for each page in the dashboard demo.
const uiDashboardDemoSectionIds = {
  UiDashboardDemoPage.overview: [
    'metrics',
    'analytics',
    'activity',
    'recent-orders',
  ],
  UiDashboardDemoPage.chat: [
    'starters',
    'transcript',
    'plan',
    'activity',
    'permission',
    'execution',
    'answer',
    'composer',
  ],
  UiDashboardDemoPage.customers: [
    'search',
    'selection-actions',
    'customer-table',
  ],
  UiDashboardDemoPage.orders: ['status-filters', 'order-table'],
  UiDashboardDemoPage.settings: [
    'profile',
    'preferences',
    'appearance',
    'danger-zone',
  ],
};

/// The interaction identifiers exercised by the parity test suite.
const uiDashboardDemoInteractionIds = <String>[
  'navigate-and-retain-page-state',
  'search-local-and-global',
  'sort-select-bulk-undo-paginate',
  'filter-export-row-actions',
  'agent-success-permission-failure-retry-stop-copy-follow',
  'appearance-notifications-theme-account',
];

/// The sidebar sections and destinations for the dashboard demo.
final uiDashboardDemoSections =
    List<RemixSidebarSection<UiDashboardDemoPage>>.unmodifiable([
      for (final section in UiDashboardDemoSection.values)
        RemixSidebarSection(
          label: section.label,
          destinations: [
            for (final page in UiDashboardDemoPage.values)
              if (page.section == section)
                RemixSidebarDestination(
                  value: page,
                  label: page.label,
                  icon: page.icon,
                ),
          ],
        ),
    ]);

/// Returns the dashboard destinations whose label, section, or component
/// section identifiers match [query].
Set<UiDashboardDemoPage> uiDashboardMatchingPages(String query) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) {
    return UiDashboardDemoPage.values.toSet();
  }
  return {
    for (final page in UiDashboardDemoPage.values)
      if (page.label.toLowerCase().contains(normalized) ||
          page.section.label.toLowerCase().contains(normalized) ||
          (uiDashboardDemoSectionIds[page]?.any(
                (id) =>
                    id.contains(normalized) ||
                    id.replaceAll('-', ' ').contains(normalized),
              ) ??
              false))
        page,
  };
}

typedef UiDashboardDemoShellBuilder =
    Widget Function(
      BuildContext context, {
      required List<RemixSidebarSection<UiDashboardDemoPage>> sections,
      required UiDashboardDemoPage selectedValue,
      required ValueChanged<UiDashboardDemoPage> onSelected,
      required Widget body,
      required String title,
      required ValueChanged<String> onSearchChanged,
    });

typedef UiDashboardDemoPageBuilder =
    Widget Function(
      BuildContext context,
      UiDashboardDemoPage page,
      String searchQuery,
      ValueChanged<UiDashboardDemoPage> onSelected,
    );

/// Shared state and navigation for the dashboard demo.
///
/// Displays pages in an [IndexedStack] to preserve state across navigation.
class UiDashboardDemoBase extends StatefulWidget {
  const UiDashboardDemoBase({
    super.key,
    required this.shellBuilder,
    required this.pageBuilder,
    this.initialPage = UiDashboardDemoPage.overview,
  });

  final UiDashboardDemoShellBuilder shellBuilder;
  final UiDashboardDemoPageBuilder pageBuilder;
  final UiDashboardDemoPage initialPage;

  @override
  State<UiDashboardDemoBase> createState() => _UiDashboardDemoBaseState();
}

class _UiDashboardDemoBaseState extends State<UiDashboardDemoBase> {
  late UiDashboardDemoPage _selected = widget.initialPage;
  late final _visitedPages = <UiDashboardDemoPage>{widget.initialPage};
  String _searchQuery = '';

  @override
  void didUpdateWidget(covariant UiDashboardDemoBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialPage != oldWidget.initialPage &&
        _selected == oldWidget.initialPage) {
      _selected = widget.initialPage;
      _visitedPages.add(_selected);
    }
  }

  void _select(UiDashboardDemoPage page) {
    if (_selected == page) return;
    setState(() {
      _selected = page;
      _visitedPages.add(page);
    });
  }

  void _handleSearchChanged(String value) {
    final nextQuery = value.trim().toLowerCase();
    if (_searchQuery == nextQuery) return;
    setState(() {
      _searchQuery = nextQuery;
      if (nextQuery.isEmpty) return;
      final matches = uiDashboardMatchingPages(nextQuery);
      if (matches.isNotEmpty &&
          !matches.contains(_selected) &&
          _selected != UiDashboardDemoPage.customers &&
          _selected != UiDashboardDemoPage.orders) {
        _selected = matches.first;
        _visitedPages.add(_selected);
      }
    });
  }

  List<RemixSidebarSection<UiDashboardDemoPage>> _visibleSections() {
    if (_searchQuery.isEmpty) return uiDashboardDemoSections;
    final matches = uiDashboardMatchingPages(_searchQuery);
    if (matches.isEmpty) return uiDashboardDemoSections;
    final visible = {...matches, _selected};
    return [
      for (final section in UiDashboardDemoSection.values)
        if (UiDashboardDemoPage.values.any(
          (page) => page.section == section && visible.contains(page),
        ))
          RemixSidebarSection(
            label: section.label,
            destinations: [
              for (final page in UiDashboardDemoPage.values)
                if (page.section == section && visible.contains(page))
                  RemixSidebarDestination(
                    value: page,
                    label: page.label,
                    icon: page.icon,
                  ),
            ],
          ),
    ];
  }

  @override
  Widget build(BuildContext context) => widget.shellBuilder(
    context,
    sections: _visibleSections(),
    selectedValue: _selected,
    onSelected: _select,
    title: _selected.label,
    onSearchChanged: _handleSearchChanged,
    body: IndexedStack(
      key: const ValueKey('dashboard-demo-pages'),
      index: _selected.index,
      children: [
        for (final page in UiDashboardDemoPage.values)
          if (_visitedPages.contains(page))
            TickerMode(
              key: ValueKey('dashboard-page-${page.name}'),
              enabled: page == _selected,
              child: RepaintBoundary(
                child: _FreezeInactiveConstraints(
                  active: page == _selected,
                  child: widget.pageBuilder(
                    context,
                    page,
                    _searchQuery,
                    _select,
                  ),
                ),
              ),
            )
          else
            const SizedBox.shrink(),
      ],
    ),
  );
}

class _FreezeInactiveConstraints extends SingleChildRenderObjectWidget {
  const _FreezeInactiveConstraints({
    required this.active,
    required super.child,
  });

  final bool active;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderFreezeInactiveConstraints(active);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderFreezeInactiveConstraints renderObject,
  ) {
    renderObject.active = active;
  }
}

class _RenderFreezeInactiveConstraints extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  _RenderFreezeInactiveConstraints(this._active);

  bool _active;
  BoxConstraints? _frozenConstraints;

  bool get active => _active;
  set active(bool value) {
    if (_active == value) return;
    _active = value;
    if (value) {
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    final effectiveConstraints = _active
        ? (_frozenConstraints = constraints)
        : (_frozenConstraints ?? constraints);
    if (constraints.isTight) {
      child.layout(effectiveConstraints);
      size = constraints.biggest;
    } else {
      child.layout(effectiveConstraints, parentUsesSize: true);
      size = constraints.constrain(child.size);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!_active) return;
    final child = this.child;
    if (child != null) {
      context.paintChild(child, offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      _active && (child?.hitTest(result, position: position) ?? false);
}
