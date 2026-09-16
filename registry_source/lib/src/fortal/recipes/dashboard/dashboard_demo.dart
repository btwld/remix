import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';

import '../../../dashboard/dashboard_demo_base.dart';
import '../../../dashboard/dashboard_demo_content.dart';
import '../../../dashboard/dashboard_sample_data.dart';
import '../../components/badge.dart';
import '../../components/button.dart';
import '../../components/card.dart';
import '../../components/chart.dart';
import '../../components/checkbox.dart';
import '../../components/code.dart';
import '../../components/data_table.dart';
import '../../components/disclosure.dart';
import '../../components/heading.dart';
import '../../components/kbd.dart';
import '../../components/link.dart';
import '../../components/popover.dart';
import '../../components/progress.dart';
import '../../components/switch.dart';
import '../../components/tabs.dart';
import '../../components/text.dart';
import '../../components/textfield.dart';
import 'dashboard_overview.dart';
import 'dashboard_shell.dart';

/// Full Fortal dashboard demo.
///
/// This is the open-code equivalent of the repository's Fortal showcase: it
/// includes the same Workspace, Data, Manage, and Components destinations,
/// while demonstrating the Radix-aligned Fortal vocabulary honestly.
class FortalDashboardDemo extends StatelessWidget {
  const FortalDashboardDemo({
    super.key,
    this.brand = const Text('Northstar'),
    this.account,
    this.headerActions = const [],
    this.onSearchChanged,
    this.data = registryDashboardSampleData,
    this.initialPage = RegistryDashboardDemoPage.overview,
    this.collapsed,
    this.initiallyCollapsed = false,
    this.onCollapsedChanged,
  });

  final Widget brand;
  final Widget? account;
  final List<Widget> headerActions;
  final ValueChanged<String>? onSearchChanged;
  final RegistryDashboardSampleData data;
  final RegistryDashboardDemoPage initialPage;
  final bool? collapsed;
  final bool initiallyCollapsed;
  final ValueChanged<bool>? onCollapsedChanged;

  @override
  Widget build(BuildContext context) {
    const kit = _FortalDashboardDemoKit();
    return RegistryDashboardDemoBase(
      initialPage: initialPage,
      shellBuilder:
          (
            context, {
            required sections,
            required selectedValue,
            required onSelected,
            required body,
            required title,
            required onSearchChanged,
          }) => FortalDashboardShell<RegistryDashboardDemoPage>(
            sections: sections,
            selectedValue: selectedValue,
            onSelected: onSelected,
            body: body,
            title: title,
            brand: brand,
            account: account,
            headerActions: headerActions,
            onSearchChanged: (value) {
              onSearchChanged(value);
              this.onSearchChanged?.call(value);
            },
            collapsed: collapsed,
            initiallyCollapsed: initiallyCollapsed,
            onCollapsedChanged: onCollapsedChanged,
          ),
      pageBuilder: (context, page, query, onSelected) => switch (page) {
        .overview => FortalDashboardOverview(data: data),
        _ => RegistryDashboardDemoContent(
          page: page,
          searchQuery: query,
          kit: kit,
          onSelected: onSelected,
          data: data,
        ),
      },
    );
  }
}

final class _FortalDashboardDemoKit implements RegistryDashboardDemoKit {
  const _FortalDashboardDemoKit();

  @override
  Widget pageHeader(String title, String description) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FortalHeading(title, size: .size7),
      const SizedBox(height: 6),
      FortalText(description, size: .size2, highContrast: false),
    ],
  );

  @override
  Widget section(String title, String description, Widget child) =>
      FortalCard.surface(
        size: .size2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FortalHeading(title, headingLevel: 2, size: .size4),
            const SizedBox(height: 4),
            FortalText(description, size: .size2, highContrast: false),
            const SizedBox(height: 16),
            child,
          ],
        ),
      );

  @override
  Widget surface(Widget child) =>
      FortalCard.surface(size: .size2, child: child);

  @override
  Widget text(String value, {bool emphasized = false, bool muted = false}) =>
      FortalText(
        value,
        size: .size2,
        weight: emphasized ? .bold : .regular,
        highContrast: !muted,
      );

  @override
  Widget button(String label, {int emphasis = 0, VoidCallback? onPressed}) =>
      switch (emphasis) {
        1 => FortalButton.soft(label: label, onPressed: onPressed),
        2 => FortalButton.outline(label: label, onPressed: onPressed),
        3 => FortalButton.ghost(label: label, onPressed: onPressed),
        4 => FortalButton.classic(label: label, onPressed: onPressed),
        _ => FortalButton.solid(label: label, onPressed: onPressed),
      };

  @override
  Widget badge(String label, {int emphasis = 0}) => switch (emphasis) {
    1 => FortalBadge.soft(label: label),
    2 => FortalBadge.surface(label: label),
    3 => FortalBadge.outline(label: label),
    _ => FortalBadge.solid(label: label),
  };

  @override
  Widget textField({
    required String hintText,
    ValueChanged<String>? onChanged,
  }) => FortalTextField(hintText: hintText, onChanged: onChanged);

  @override
  Widget checkbox({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) => FortalCheckbox(
    selected: value,
    semanticLabel: 'Receive account alerts',
    onChanged: (next) => onChanged(next ?? false),
  );

  @override
  Widget switchControl({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) => FortalSwitch(
    selected: value,
    semanticLabel: 'Toggle setting',
    onChanged: onChanged,
  );

  @override
  Widget progress(double value) => FortalProgress(
    value: value,
    semanticsLabel: 'Completion',
    semanticsValue: '${(value * 100).round()} percent',
  );

  @override
  Widget charts(RegistryDashboardSampleData data) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 760;
      final cards = [
        _chartCard(
          'Revenue momentum',
          'Area and markers preserve exact values.',
          FortalLineChart(
            showMarkers: true,
            semanticsLabel: 'Weekly revenue momentum',
            series: [
              LineSeries(
                id: 'revenue',
                label: 'Revenue',
                points: [
                  for (final (index, point) in data.revenue.indexed)
                    ChartPoint(
                      id: point.label,
                      x: index.toDouble(),
                      y: point.value,
                    ),
                ],
              ),
            ],
          ),
        ),
        _chartCard(
          'Actual versus plan',
          'Grouped bars compare monthly performance with targets.',
          FortalBarChart(
            semanticsLabel: 'Monthly actual and planned revenue',
            groups: _barGroups,
          ),
        ),
        _chartCard(
          'Traffic channels',
          'A donut keeps category proportions scannable.',
          FortalPieChart(
            centerRadius: 44,
            semanticsLabel: 'Traffic share by device',
            slices: [
              PieSlice(id: 'mobile', label: 'Mobile', value: 46),
              PieSlice(id: 'desktop', label: 'Desktop', value: 31),
              PieSlice(id: 'tablet', label: 'Tablet', value: 15),
              PieSlice(id: 'other', label: 'Other', value: 8),
            ],
          ),
        ),
      ];
      if (compact) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, card) in cards.indexed) ...[
              if (index > 0) const SizedBox(height: 16),
              card,
            ],
          ],
        );
      }
      final cardWidth = (constraints.maxWidth - 16) / 2;
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          for (final card in cards) SizedBox(width: cardWidth, child: card),
        ],
      );
    },
  );

  @override
  Widget records({required bool orders, required String query}) {
    final rows = registryDashboardSampleData.records.where((record) {
      if (query.isEmpty) return true;
      return record.id.toLowerCase().contains(query) ||
          record.customer.toLowerCase().contains(query) ||
          record.status.toLowerCase().contains(query);
    }).toList();
    return FortalDataTable<RegistryDashboardRecord>.surface(
      semanticLabel: orders ? 'Orders' : 'Customers',
      rows: rows,
      minimumWidth: 620,
      columns: [
        RemixDataTableColumn(
          id: orders ? 'order' : 'customer',
          label: orders ? 'Order' : 'Customer',
          width: const FlexColumnWidth(2),
          cellBuilder: (_, record) =>
              text(orders ? record.id : record.customer, emphasized: true),
        ),
        RemixDataTableColumn(
          id: 'status',
          label: 'Status',
          width: const FixedColumnWidth(140),
          cellBuilder: (_, record) => badge(record.status, emphasis: 1),
        ),
        RemixDataTableColumn(
          id: orders ? 'amount' : 'plan',
          label: orders ? 'Amount' : 'Plan',
          width: const FixedColumnWidth(120),
          cellBuilder: (_, record) =>
              text(orders ? record.amount : _planFor(record.id)),
        ),
      ],
    );
  }

  @override
  Widget overlays(VoidCallback onAction) => Wrap(
    spacing: 12,
    runSpacing: 12,
    children: [
      FortalPopover(
        semanticLabel: 'Invite teammates',
        popoverChild: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text('Invite teammates', emphasized: true),
              const SizedBox(height: 8),
              text('Share this workspace with collaborators.', muted: true),
              const SizedBox(height: 12),
              button('Copy invite link', onPressed: onAction),
            ],
          ),
        ),
        child: const FortalButton.outline(label: 'Open popover'),
      ),
      button('Show toast', emphasis: 1, onPressed: onAction),
      button('Open menu', emphasis: 3, onPressed: onAction),
    ],
  );

  @override
  Widget navigation() => const _FortalNavigationDemo();

  @override
  Widget typography(VoidCallback onAction) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const FortalHeading(
        'Build products with owned source',
        headingLevel: 2,
        size: .size6,
      ),
      const SizedBox(height: 8),
      const FortalText(
        'Body copy inherits the application theme and remains editable.',
        size: .size3,
      ),
      const SizedBox(height: 12),
      FortalLink('Interactive link', onPressed: onAction),
      const SizedBox(height: 12),
      const Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          FortalCode('remix add dashboard_demo'),
          FortalKbd('⌘'),
          FortalKbd('K'),
        ],
      ),
    ],
  );
}

class _FortalNavigationDemo extends StatefulWidget {
  const _FortalNavigationDemo();

  @override
  State<_FortalNavigationDemo> createState() => _FortalNavigationDemoState();
}

class _FortalNavigationDemoState extends State<_FortalNavigationDemo> {
  String _selected = 'overview';

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      RemixTabs(
        selectedTabId: _selected,
        onChanged: (value) => setState(() => _selected = value),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FortalTabBar(
              child: Row(
                children: [
                  FortalTab(tabId: 'overview', label: 'Overview'),
                  FortalTab(tabId: 'activity', label: 'Activity'),
                ],
              ),
            ),
            FortalTabView(
              tabId: 'overview',
              child: FortalText('Overview content'),
            ),
            FortalTabView(
              tabId: 'activity',
              child: FortalText('Activity content'),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      const FortalDisclosure.surface(
        trigger: FortalText('What is the dashboard demo?'),
        content: FortalText(
          'A complete, editable reference app installed into your project.',
        ),
      ),
    ],
  );
}

Widget _chartCard(String title, String description, Widget chart) =>
    FortalCard.surface(
      size: .size2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FortalHeading(title, headingLevel: 3, size: .size3),
          const SizedBox(height: 4),
          FortalText(description, size: .size1, highContrast: false),
          const SizedBox(height: 12),
          SizedBox(height: 240, child: chart),
        ],
      ),
    );

String _planFor(String id) => switch (id) {
  'ORD-1048' => 'Enterprise',
  'ORD-1047' => 'Pro',
  'ORD-1046' => 'Pro',
  _ => 'Starter',
};

final _barGroups = <BarGroup>[
  for (final (index, values) in const [
    (32.0, 29.0),
    (41.0, 36.0),
    (37.0, 40.0),
    (52.0, 45.0),
    (48.0, 50.0),
    (59.0, 54.0),
  ].indexed)
    BarGroup(
      id: 'month-$index',
      label: const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'][index],
      bars: [
        BarValue(id: 'actual', label: 'Actual', toY: values.$1),
        BarValue(id: 'plan', label: 'Plan', toY: values.$2),
      ],
    ),
];
