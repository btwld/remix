import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

/// The navigation groups shared across dashboard showcase presets.
enum RegistryDashboardDemoSection {
  workspace('Workspace'),
  data('Data'),
  manage('Manage');

  const RegistryDashboardDemoSection(this.label);

  final String label;
}

/// The navigation destinations in the dashboard demo.
enum RegistryDashboardDemoPage {
  overview(
    RegistryDashboardDemoSection.workspace,
    'Overview',
    RemixIcons.dashboard,
  ),
  chat(RegistryDashboardDemoSection.workspace, 'Chat', RemixIcons.chatBubble),
  customers(RegistryDashboardDemoSection.data, 'Customers', RemixIcons.group),
  orders(RegistryDashboardDemoSection.data, 'Orders', RemixIcons.table),
  settings(
    RegistryDashboardDemoSection.manage,
    'Settings',
    RemixIcons.mixerHorizontal,
  );

  const RegistryDashboardDemoPage(this.section, this.label, this.icon);

  final RegistryDashboardDemoSection section;
  final String label;
  final IconData icon;
}

/// The section identifiers for each page in the dashboard demo.
const registryDashboardDemoSectionIds = {
  RegistryDashboardDemoPage.overview: [
    'metrics',
    'analytics',
    'activity',
    'recent-orders',
  ],
  RegistryDashboardDemoPage.chat: [
    'starters',
    'transcript',
    'plan',
    'activity',
    'permission',
    'execution',
    'answer',
    'composer',
  ],
  RegistryDashboardDemoPage.customers: [
    'search',
    'selection-actions',
    'customer-table',
  ],
  RegistryDashboardDemoPage.orders: ['status-filters', 'order-table'],
  RegistryDashboardDemoPage.settings: [
    'profile',
    'preferences',
    'appearance',
    'danger-zone',
  ],
};

/// The interaction identifiers exercised by the parity test suite.
const registryDashboardDemoInteractionIds = <String>[
  'navigate-and-retain-page-state',
  'search-local-and-global',
  'sort-select-bulk-undo-paginate',
  'filter-export-row-actions',
  'agent-success-permission-failure-retry-stop-copy-follow',
  'appearance-notifications-theme-account',
];

/// The sidebar sections and destinations for the dashboard demo.
final registryDashboardDemoSections =
    List<RemixSidebarSection<RegistryDashboardDemoPage>>.unmodifiable([
      for (final section in RegistryDashboardDemoSection.values)
        RemixSidebarSection(
          label: section.label,
          destinations: [
            for (final page in RegistryDashboardDemoPage.values)
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
Set<RegistryDashboardDemoPage> registryDashboardMatchingPages(String query) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) {
    return RegistryDashboardDemoPage.values.toSet();
  }
  return {
    for (final page in RegistryDashboardDemoPage.values)
      if (page.label.toLowerCase().contains(normalized) ||
          page.section.label.toLowerCase().contains(normalized) ||
          (registryDashboardDemoSectionIds[page]?.any(
                (id) =>
                    id.contains(normalized) ||
                    id.replaceAll('-', ' ').contains(normalized),
              ) ??
              false))
        page,
  };
}

typedef RegistryDashboardDemoShellBuilder =
    Widget Function(
      BuildContext context, {
      required List<RemixSidebarSection<RegistryDashboardDemoPage>> sections,
      required RegistryDashboardDemoPage selectedValue,
      required ValueChanged<RegistryDashboardDemoPage> onSelected,
      required Widget body,
      required String title,
      required ValueChanged<String> onSearchChanged,
    });

typedef RegistryDashboardDemoPageBuilder =
    Widget Function(
      BuildContext context,
      RegistryDashboardDemoPage page,
      String searchQuery,
      ValueChanged<RegistryDashboardDemoPage> onSelected,
    );

/// Shared state and navigation for the dashboard demo.
///
/// Displays pages in an [IndexedStack] to preserve state across navigation.
class RegistryDashboardDemoBase extends StatefulWidget {
  const RegistryDashboardDemoBase({
    super.key,
    required this.shellBuilder,
    required this.pageBuilder,
    this.initialPage = RegistryDashboardDemoPage.overview,
  });

  final RegistryDashboardDemoShellBuilder shellBuilder;
  final RegistryDashboardDemoPageBuilder pageBuilder;
  final RegistryDashboardDemoPage initialPage;

  @override
  State<RegistryDashboardDemoBase> createState() =>
      _RegistryDashboardDemoBaseState();
}

class _RegistryDashboardDemoBaseState extends State<RegistryDashboardDemoBase> {
  late RegistryDashboardDemoPage _selected = widget.initialPage;
  late final _visitedPages = <RegistryDashboardDemoPage>{widget.initialPage};
  String _searchQuery = '';

  @override
  void didUpdateWidget(covariant RegistryDashboardDemoBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialPage != oldWidget.initialPage &&
        _selected == oldWidget.initialPage) {
      _selected = widget.initialPage;
      _visitedPages.add(_selected);
    }
  }

  void _select(RegistryDashboardDemoPage page) {
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
      final matches = registryDashboardMatchingPages(nextQuery);
      if (matches.isNotEmpty &&
          !matches.contains(_selected) &&
          _selected != RegistryDashboardDemoPage.customers &&
          _selected != RegistryDashboardDemoPage.orders) {
        _selected = matches.first;
        _visitedPages.add(_selected);
      }
    });
  }

  List<RemixSidebarSection<RegistryDashboardDemoPage>> _visibleSections() {
    if (_searchQuery.isEmpty) return registryDashboardDemoSections;
    final matches = registryDashboardMatchingPages(_searchQuery);
    if (matches.isEmpty) return registryDashboardDemoSections;
    final visible = {...matches, _selected};
    return [
      for (final section in RegistryDashboardDemoSection.values)
        if (RegistryDashboardDemoPage.values.any(
          (page) => page.section == section && visible.contains(page),
        ))
          RemixSidebarSection(
            label: section.label,
            destinations: [
              for (final page in RegistryDashboardDemoPage.values)
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
        for (final page in RegistryDashboardDemoPage.values)
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

/// A responsive scroll container for dashboard demo pages.
class RegistryDashboardDemoPageFrame extends StatelessWidget {
  const RegistryDashboardDemoPageFrame({
    super.key,
    required this.header,
    required this.children,
  });

  final Widget header;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    key: const ValueKey('dashboard-demo-page-scroll'),
    padding: const EdgeInsets.all(24),
    child: Box(
      style: BoxStyler().alignment(.center),
      child: ColumnBox(
        style: FlexBoxStyler()
            .maxWidth(1180)
            .crossAxisAlignment(.stretch)
            .spacing(24),
        children: [
          header,
          ColumnBox(
            style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(16),
            children: children,
          ),
        ],
      ),
    ),
  );
}
