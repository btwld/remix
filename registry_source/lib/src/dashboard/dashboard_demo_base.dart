import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

/// The four navigation groups shared with the repository dashboard showcase.
enum RegistryDashboardDemoSection {
  workspace('Workspace'),
  data('Data'),
  manage('Manage'),
  components('Components');

  const RegistryDashboardDemoSection(this.label);

  final String label;
}

/// Every destination in the full dashboard demo.
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

/// Stable screen inventory shared by both presets and parity tests.
typedef _RegistryDashboardSectionInventory =
    Map<RegistryDashboardDemoPage, List<String>>;

const _RegistryDashboardSectionInventory registryDashboardDemoSectionIds = {
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

/// Deterministic behaviors exercised by the parity fixture suite.
const registryDashboardDemoInteractionIds = <String>[
  'navigate-and-retain-page-state',
  'search-local-and-global',
  'sort-select-bulk-undo-paginate',
  'filter-export-row-actions',
  'agent-success-permission-failure-retry-stop-copy-follow',
  'dialog-popover-tooltip-menu-toast',
  'appearance-notifications-theme-account',
];

/// The complete sidebar inventory used by the presets.
final registryDashboardDemoSections =
    <RemixSidebarSection<RegistryDashboardDemoPage>>[
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
    ];

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

/// Preset-neutral navigation and state for the full dashboard demo.
///
/// Pages live in an [IndexedStack] so interactive controls and the chat draft
/// keep their state while visitors compare other destinations.
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
  String _searchQuery = '';

  void _select(RegistryDashboardDemoPage page) {
    if (_selected == page) return;
    setState(() => _selected = page);
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
          widget.pageBuilder(context, page, _searchQuery, _select),
      ],
    ),
  );
}

/// Responsive scrolling frame shared by the product and component pages.
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
