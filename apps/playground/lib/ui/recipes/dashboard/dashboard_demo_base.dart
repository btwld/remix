import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

/// The four navigation groups shared with the repository dashboard showcase.
enum PlaygroundDashboardDemoSection {
  workspace('Workspace'),
  data('Data'),
  manage('Manage'),
  components('Components');

  const PlaygroundDashboardDemoSection(this.label);

  final String label;
}

/// Every destination in the full dashboard demo.
enum PlaygroundDashboardDemoPage {
  overview(
    PlaygroundDashboardDemoSection.workspace,
    'Overview',
    RemixIcons.dashboard,
  ),
  chat(PlaygroundDashboardDemoSection.workspace, 'Chat', RemixIcons.chatBubble),
  customers(PlaygroundDashboardDemoSection.data, 'Customers', RemixIcons.group),
  orders(PlaygroundDashboardDemoSection.data, 'Orders', RemixIcons.table),
  settings(
    PlaygroundDashboardDemoSection.manage,
    'Settings',
    RemixIcons.mixerHorizontal,
  ),
  charts(
    // Keep this destination expanded at every generated preset prefix.
    PlaygroundDashboardDemoSection.components,
    'Charts',
    RemixIcons.barChart,
  ),
  actions(
    PlaygroundDashboardDemoSection.components,
    'Actions',
    RemixIcons.cursorArrow,
  ),
  forms(
    PlaygroundDashboardDemoSection.components,
    'Forms & Inputs',
    RemixIcons.input,
  ),
  dataDisplay(
    PlaygroundDashboardDemoSection.components,
    'Data Display',
    RemixIcons.table,
  ),
  overlays(
    PlaygroundDashboardDemoSection.components,
    'Overlays',
    RemixIcons.stack,
  ),
  navigation(
    PlaygroundDashboardDemoSection.components,
    'Navigation',
    RemixIcons.hamburgerMenu,
  ),
  typography(
    PlaygroundDashboardDemoSection.components,
    'Typography',
    RemixIcons.fontSize,
  );

  const PlaygroundDashboardDemoPage(this.section, this.label, this.icon);

  final PlaygroundDashboardDemoSection section;
  final String label;
  final IconData icon;
}

/// Stable screen inventory shared by both presets and parity tests.
typedef _PlaygroundDashboardSectionInventory =
    Map<PlaygroundDashboardDemoPage, List<String>>;

const _PlaygroundDashboardSectionInventory playgroundDashboardDemoSectionIds = {
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
  PlaygroundDashboardDemoPage.charts: [
    // All three chart families remain distinct parity sections.
    'line-area',
    'bar-charts',
    'pie-donut',
  ],
  PlaygroundDashboardDemoPage.actions: [
    'button',
    'icon-button',
    'toggle',
    'states',
  ],
  PlaygroundDashboardDemoPage.forms: [
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
  PlaygroundDashboardDemoPage.dataDisplay: [
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
  PlaygroundDashboardDemoPage.overlays: [
    // Compound overlays share one ordered gallery contract.
    'dialog',
    'popover',
    'tooltip',
    'menu',
  ],
  PlaygroundDashboardDemoPage.navigation: [
    'sidebar',
    'tabs',
    'disclosure',
    'accordion',
  ],
  PlaygroundDashboardDemoPage.typography: [
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

/// Deterministic behaviors exercised by the parity fixture suite.
const playgroundDashboardDemoInteractionIds = <String>[
  'navigate-and-retain-page-state',
  'search-local-and-global',
  'sort-select-bulk-undo-paginate',
  'filter-export-row-actions',
  'agent-success-permission-failure-retry-stop-copy-follow',
  'dialog-popover-tooltip-menu-toast',
  'appearance-notifications-theme-account',
];

/// The complete sidebar inventory used by both playground presets.
final playgroundDashboardDemoSections =
    <RemixSidebarSection<PlaygroundDashboardDemoPage>>[
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
    ];

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

/// Preset-neutral navigation and state for the full dashboard demo.
///
/// Pages live in an [IndexedStack] so interactive controls and the chat draft
/// keep their state while visitors compare other destinations.
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
  String _searchQuery = '';

  void _select(PlaygroundDashboardDemoPage page) {
    if (_selected == page) return;
    setState(() => _selected = page);
  }

  @override
  Widget build(BuildContext context) => widget.shellBuilder(
    context,
    sections: playgroundDashboardDemoSections,
    selectedValue: _selected,
    onSelected: _select,
    title: _selected.label,
    onSearchChanged: (value) =>
        setState(() => _searchQuery = value.trim().toLowerCase()),
    body: IndexedStack(
      key: const ValueKey('dashboard-demo-pages'),
      index: _selected.index,
      children: [
        for (final page in PlaygroundDashboardDemoPage.values)
          widget.pageBuilder(context, page, _searchQuery, _select),
      ],
    ),
  );
}

/// Responsive scrolling frame shared by the product and component pages.
class PlaygroundDashboardDemoPageFrame extends StatelessWidget {
  const PlaygroundDashboardDemoPageFrame({
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            const SizedBox(height: 24),
            for (final (index, child) in children.indexed) ...[
              if (index > 0) const SizedBox(height: 16),
              child,
            ],
          ],
        ),
      ),
    ),
  );
}
