import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

/// The navigation groups shared across dashboard showcase presets.
enum RegistryDashboardDemoSection {
  workspace('Workspace'),
  data('Data'),
  manage('Manage'),
  components('Components');

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
  ),
  charts(
    // Keep this destination expanded at every generated preset prefix.
    RegistryDashboardDemoSection.components,
    'Charts',
    RemixIcons.barChart,
  ),
  actions(
    RegistryDashboardDemoSection.components,
    'Actions',
    RemixIcons.cursorArrow,
  ),
  forms(
    RegistryDashboardDemoSection.components,
    'Forms & Inputs',
    RemixIcons.input,
  ),
  dataDisplay(
    RegistryDashboardDemoSection.components,
    'Data Display',
    RemixIcons.table,
  ),
  overlays(
    RegistryDashboardDemoSection.components,
    'Overlays',
    RemixIcons.stack,
  ),
  navigation(
    RegistryDashboardDemoSection.components,
    'Navigation',
    RemixIcons.hamburgerMenu,
  ),
  typography(
    RegistryDashboardDemoSection.components,
    'Typography',
    RemixIcons.fontSize,
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
  RegistryDashboardDemoPage.charts: [
    // All three chart families remain distinct parity sections.
    'line-area',
    'bar-charts',
    'pie-donut',
  ],
  RegistryDashboardDemoPage.actions: [
    'button',
    'icon-button',
    'toggle',
    'states',
  ],
  RegistryDashboardDemoPage.forms: [
    'text-field',
    'text-area',
    'segmented-control',
    'select',
    'toggle-group',
    'checkbox',
    'checkbox-group',
    'radio',
    'switch',
    'slider',
    'states',
  ],
  RegistryDashboardDemoPage.dataDisplay: [
    'avatar',
    'badge',
    'card',
    'callout',
    'data-list',
    'skeleton',
    'progress',
    'spinner',
    'divider',
  ],
  RegistryDashboardDemoPage.overlays: [
    // Compound overlays share one ordered gallery contract.
    'dialog',
    'popover',
    'tooltip',
    'menu',
  ],
  RegistryDashboardDemoPage.navigation: [
    'sidebar',
    'tabs',
    'disclosure',
    'accordion',
  ],
  RegistryDashboardDemoPage.typography: [
    'text-scale',
    'weights',
    'heading-level-size',
    'code',
    'keyboard-keys',
    'links',
    'accent-contrast',
    'wrapping-truncation',
  ],
};

/// The interaction identifiers exercised by the parity test suite.
const registryDashboardDemoInteractionIds = <String>[
  'navigate-and-retain-page-state',
  'search-local-and-global',
  'sort-select-bulk-undo-paginate',
  'filter-export-row-actions',
  'agent-success-permission-failure-retry-stop-copy-follow',
  'dialog-popover-tooltip-menu-toast',
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
  late final Set<RegistryDashboardDemoPage> _visitedPages = {
    widget.initialPage,
  };
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

  @override
  Widget build(BuildContext context) => widget.shellBuilder(
    context,
    sections: registryDashboardDemoSections,
    selectedValue: _selected,
    onSelected: _select,
    title: _selected.label,
    onSearchChanged: (value) =>
        setState(() => _searchQuery = value.trim().toLowerCase()),
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
    child: Center(
      child: Box(
        style: BoxStyler().maxWidth(1180),
        child: ColumnBox(
          style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(24),
          children: [
            header,
            ColumnBox(
              style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(16),
              children: children,
            ),
          ],
        ),
      ),
    ),
  );
}
