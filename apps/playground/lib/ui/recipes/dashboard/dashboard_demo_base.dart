import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

/// The navigation groups shared across dashboard showcase presets.
enum PlaygroundDashboardDemoSection {
  workspace('Workspace'),
  data('Data'),
  manage('Manage');

  const PlaygroundDashboardDemoSection(this.label);

  final String label;
}

/// The navigation destinations in the dashboard demo.
enum PlaygroundDashboardDemoPage {
  overview(
    PlaygroundDashboardDemoSection.workspace,
    'Overview',
    RemixIcons.grid,
  ),
  chat(PlaygroundDashboardDemoSection.workspace, 'Chat', RemixIcons.chat),
  customers(
    PlaygroundDashboardDemoSection.data,
    'Customers',
    LucideIcons.group,
  ),
  orders(PlaygroundDashboardDemoSection.data, 'Orders', LucideIcons.table),
  settings(
    PlaygroundDashboardDemoSection.manage,
    'Settings',
    RemixIcons.sliders,
  );

  const PlaygroundDashboardDemoPage(this.section, this.label, this.icon);

  final PlaygroundDashboardDemoSection section;
  final String label;
  final IconData icon;
}

/// The section identifiers for each page in the dashboard demo.
const playgroundDashboardDemoSectionIds = {
  PlaygroundDashboardDemoPage.overview: [
    'metrics',
    'analytics',
    'activity',
    'recent-orders',
  ],
  PlaygroundDashboardDemoPage.chat: [
    'starters',
    'transcript',
    'plan',
    'activity',
    'permission',
    'execution',
    'answer',
    'composer',
  ],
  PlaygroundDashboardDemoPage.customers: [
    'search',
    'selection-actions',
    'customer-table',
  ],
  PlaygroundDashboardDemoPage.orders: ['status-filters', 'order-table'],
  PlaygroundDashboardDemoPage.settings: [
    'profile',
    'preferences',
    'appearance',
    'danger-zone',
  ],
};

/// The sidebar sections and destinations for the dashboard demo.
final playgroundDashboardDemoSections =
    List<RemixSidebarSection<PlaygroundDashboardDemoPage>>.unmodifiable([
      for (final section in PlaygroundDashboardDemoSection.values)
        RemixSidebarSection(
          label: section.label,
          destinations: [
            for (final page in PlaygroundDashboardDemoPage.values)
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
Set<PlaygroundDashboardDemoPage> playgroundDashboardMatchingPages(
  String query,
) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) {
    return PlaygroundDashboardDemoPage.values.toSet();
  }
  return {
    for (final page in PlaygroundDashboardDemoPage.values)
      if (page.label.toLowerCase().contains(normalized) ||
          page.section.label.toLowerCase().contains(normalized) ||
          (playgroundDashboardDemoSectionIds[page]?.any(
                (id) =>
                    id.contains(normalized) ||
                    id.replaceAll('-', ' ').contains(normalized),
              ) ??
              false))
        page,
  };
}

typedef PlaygroundDashboardDemoShellBuilder =
    Widget Function(
      BuildContext context, {
      required List<RemixSidebarSection<PlaygroundDashboardDemoPage>> sections,
      required PlaygroundDashboardDemoPage selectedValue,
      required ValueChanged<PlaygroundDashboardDemoPage> onSelected,
      required Widget body,
      required String title,
      required ValueChanged<String> onSearchChanged,
    });

typedef PlaygroundDashboardDemoPageBuilder =
    Widget Function(
      BuildContext context,
      PlaygroundDashboardDemoPage page,
      String searchQuery,
      ValueChanged<PlaygroundDashboardDemoPage> onSelected,
    );

/// Shared state and navigation for the dashboard demo.
///
/// Displays pages in an [IndexedStack] to preserve state across navigation.
class PlaygroundDashboardDemoBase extends StatefulWidget {
  const PlaygroundDashboardDemoBase({
    super.key,
    required this.shellBuilder,
    required this.pageBuilder,
    this.initialPage = PlaygroundDashboardDemoPage.overview,
  });

  final PlaygroundDashboardDemoShellBuilder shellBuilder;
  final PlaygroundDashboardDemoPageBuilder pageBuilder;
  final PlaygroundDashboardDemoPage initialPage;

  @override
  State<PlaygroundDashboardDemoBase> createState() =>
      _PlaygroundDashboardDemoBaseState();
}

class _PlaygroundDashboardDemoBaseState
    extends State<PlaygroundDashboardDemoBase> {
  late PlaygroundDashboardDemoPage _selected = widget.initialPage;
  late final _visitedPages = <PlaygroundDashboardDemoPage>{widget.initialPage};
  String _searchQuery = '';

  @override
  void didUpdateWidget(covariant PlaygroundDashboardDemoBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialPage != oldWidget.initialPage &&
        _selected == oldWidget.initialPage) {
      _selected = widget.initialPage;
      _visitedPages.add(_selected);
    }
  }

  void _select(PlaygroundDashboardDemoPage page) {
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
      final matches = playgroundDashboardMatchingPages(nextQuery);
      if (matches.isNotEmpty &&
          !matches.contains(_selected) &&
          _selected != PlaygroundDashboardDemoPage.customers &&
          _selected != PlaygroundDashboardDemoPage.orders) {
        _selected = matches.first;
        _visitedPages.add(_selected);
      }
    });
  }

  List<RemixSidebarSection<PlaygroundDashboardDemoPage>> _visibleSections() {
    if (_searchQuery.isEmpty) return playgroundDashboardDemoSections;
    final matches = playgroundDashboardMatchingPages(_searchQuery);
    if (matches.isEmpty) return playgroundDashboardDemoSections;
    final visible = {...matches, _selected};
    return [
      for (final section in PlaygroundDashboardDemoSection.values)
        if (PlaygroundDashboardDemoPage.values.any(
          (page) => page.section == section && visible.contains(page),
        ))
          RemixSidebarSection(
            label: section.label,
            destinations: [
              for (final page in PlaygroundDashboardDemoPage.values)
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
        for (final page in PlaygroundDashboardDemoPage.values)
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
