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
import '../../components/data_table.dart';
import '../../components/disclosure.dart';
import '../../components/link.dart';
import '../../components/popover.dart';
import '../../components/progress.dart';
import '../../components/switch.dart';
import '../../components/tabs.dart';
import '../../components/textfield.dart';
import '../../theme/tokens.dart';
import 'dashboard_overview.dart';
import 'dashboard_shell.dart';

/// Full default-preset dashboard demo.
///
/// This is the open-code equivalent of the repository's Fortal showcase: it
/// includes the same Workspace, Data, Manage, and Components destinations,
/// while demonstrating the smaller default preset vocabulary honestly.
class VanillaDashboardDemo extends StatelessWidget {
  const VanillaDashboardDemo({
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
    const kit = _VanillaDashboardDemoKit();
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
          }) => VanillaDashboardShell<RegistryDashboardDemoPage>(
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
        .overview => VanillaDashboardOverview(data: data),
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

final class _VanillaDashboardDemoKit implements RegistryDashboardDemoKit {
  const _VanillaDashboardDemoKit();

  @override
  Widget pageHeader(String title, String description) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StyledText(title, style: _textStyle(size: 28, weight: FontWeight.w700)),
      const SizedBox(height: 6),
      StyledText(description, style: _textStyle(muted: true)),
    ],
  );

  @override
  Widget section(String title, String description, Widget child) => VanillaCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StyledText(title, style: _textStyle(size: 17, weight: FontWeight.w600)),
        const SizedBox(height: 4),
        StyledText(description, style: _textStyle(muted: true, size: 13)),
        const SizedBox(height: 16),
        child,
      ],
    ),
  );

  @override
  Widget surface(Widget child) => VanillaCard(child: child);

  @override
  Widget text(String value, {bool emphasized = false, bool muted = false}) =>
      StyledText(
        value,
        style: _textStyle(
          weight: emphasized ? FontWeight.w600 : FontWeight.w400,
          muted: muted,
        ),
      );

  @override
  Widget button(String label, {int emphasis = 0, VoidCallback? onPressed}) =>
      switch (emphasis) {
        1 => VanillaButton.secondary(label: label, onPressed: onPressed),
        2 => VanillaButton.outline(label: label, onPressed: onPressed),
        3 => VanillaButton.ghost(label: label, onPressed: onPressed),
        4 => VanillaButton.destructive(label: label, onPressed: onPressed),
        _ => VanillaButton.primary(label: label, onPressed: onPressed),
      };

  @override
  Widget badge(String label, {int emphasis = 0}) => switch (emphasis) {
    1 => VanillaBadge.secondary(label: label),
    2 => VanillaBadge.outline(label: label),
    3 => VanillaBadge.destructive(label: label),
    _ => VanillaBadge.primary(label: label),
  };

  @override
  Widget textField({
    required String hintText,
    ValueChanged<String>? onChanged,
  }) => VanillaTextField(hintText: hintText, onChanged: onChanged);

  @override
  Widget checkbox({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) => VanillaCheckbox(
    selected: value,
    semanticLabel: 'Receive account alerts',
    onChanged: (next) => onChanged(next ?? false),
  );

  @override
  Widget switchControl({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) => VanillaSwitch(
    selected: value,
    semanticLabel: 'Toggle setting',
    onChanged: onChanged,
  );

  @override
  Widget progress(double value) => VanillaProgress(
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
          VanillaLineChart(
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
          VanillaBarChart(
            semanticsLabel: 'Monthly actual and planned revenue',
            groups: _barGroups,
          ),
        ),
        _chartCard(
          'Traffic channels',
          'A donut keeps category proportions scannable.',
          VanillaPieChart(
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
    return VanillaDataTable<RegistryDashboardRecord>(
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
      VanillaPopover(
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
        child: const VanillaButton.outline(label: 'Open popover'),
      ),
      button('Show toast', emphasis: 1, onPressed: onAction),
      button('Open menu', emphasis: 3, onPressed: onAction),
    ],
  );

  @override
  Widget navigation() => const _VanillaNavigationDemo();

  @override
  Widget typography(VoidCallback onAction) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StyledText(
        'Build products with owned source',
        style: _textStyle(size: 24, weight: FontWeight.w700),
      ),
      const SizedBox(height: 8),
      StyledText(
        'Body copy inherits the application theme and remains editable.',
        style: _textStyle(),
      ),
      const SizedBox(height: 12),
      VanillaLink(label: 'Interactive link', onPressed: onAction),
      const SizedBox(height: 12),
      DecoratedBox(
        decoration: BoxDecoration(
          color: VanillaTokens.muted(),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: StyledText('remix add dashboard_demo', style: _textStyle()),
        ),
      ),
    ],
  );
}

class _VanillaNavigationDemo extends StatefulWidget {
  const _VanillaNavigationDemo();

  @override
  State<_VanillaNavigationDemo> createState() => _VanillaNavigationDemoState();
}

class _VanillaNavigationDemoState extends State<_VanillaNavigationDemo> {
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
            VanillaTabBar(
              child: Row(
                children: [
                  VanillaTab(tabId: 'overview', label: 'Overview'),
                  VanillaTab(tabId: 'activity', label: 'Activity'),
                ],
              ),
            ),
            VanillaTabView(tabId: 'overview', child: Text('Overview content')),
            VanillaTabView(tabId: 'activity', child: Text('Activity content')),
          ],
        ),
      ),
      const SizedBox(height: 12),
      const VanillaDisclosure(
        trigger: Text('What is the dashboard demo?'),
        content: Text(
          'A complete, editable reference app installed into your project.',
        ),
      ),
    ],
  );
}

Widget _chartCard(String title, String description, Widget chart) =>
    VanillaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StyledText(
            title,
            style: _textStyle(size: 16, weight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          StyledText(description, style: _textStyle(size: 13, muted: true)),
          const SizedBox(height: 12),
          SizedBox(height: 240, child: chart),
        ],
      ),
    );

TextStyler _textStyle({
  double size = 14,
  FontWeight weight = FontWeight.w400,
  bool muted = false,
}) => TextStyler()
    .fontSize(size)
    .fontWeight(weight)
    .color(
      muted ? VanillaTokens.mutedForeground() : VanillaTokens.foreground(),
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
