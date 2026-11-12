import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../../dashboard/dashboard_demo_charts.dart';
import '../../../dashboard/dashboard_overview_base.dart';
import '../../../dashboard/dashboard_sample_data.dart';
import '../../components/button.dart';
import '../../components/card.dart';
import '../../components/chart.dart';
import '../../components/chip.dart';
import '../../components/progress.dart';
import '../../components/separator.dart';
import '../../components/table.dart';
import '../../theme/theme.dart';
import 'dashboard_demo_text.dart';

/// Revenue, orders, and recent activity, in HeroUI cards.
///
/// Pass local [data] to replace the starter metrics, chart, and records without
/// changing the responsive composition.
class HeroUiDashboardOverview extends StatelessWidget {
  const HeroUiDashboardOverview({
    super.key,
    this.data = registryDashboardSampleData,
    this.scrollController,
    this.onViewOrders,
  });

  final RegistryDashboardSampleData data;
  final ScrollController? scrollController;
  final VoidCallback? onViewOrders;

  @override
  Widget build(BuildContext context) => RegistryDashboardOverviewBase(
    data: data,
    scrollController: scrollController,
    headerBuilder: (context, title, description) => ColumnBox(
      style: FlexBoxStyler().crossAxisAlignment(.start).spacing(4),
      children: [
        HeroUiDashboardText(title, type: .h3),
        HeroUiDashboardText(description, muted: true),
      ],
    ),
    metricBuilder: (context, metric) => HeroUiCard(
      child: ColumnBox(
        style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(8),
        children: [
          RowBox(
            style: FlexBoxStyler()
                .mainAxisAlignment(.spaceBetween)
                .crossAxisAlignment(.center)
                .spacing(8),
            children: [
              Flexible(child: HeroUiCardDescription(metric.label)),
              if (metric.delta case final delta?)
                // Up and down are a status, so they take its colours here,
                // unlike a chart series.
                HeroUiChip.soft(
                  size: .sm,
                  color: metric.positive ? .success : .danger,
                  child: RowBox(
                    style: FlexBoxStyler()
                        .mainAxisSize(.min)
                        .crossAxisAlignment(.center)
                        .spacing(2),
                    children: [
                      StyledIcon(
                        icon: metric.positive
                            ? RemixIcons.chevronUp
                            : RemixIcons.chevronDown,
                        style: IconStyler().size(12),
                      ),
                      StyledText(delta),
                    ],
                  ),
                ),
            ],
          ),
          HeroUiDashboardText(metric.value, type: .h3),
          if (metric.progress case final progress?)
            HeroUiProgress(
              value: progress,
              size: .sm,
              semanticsLabel: metric.label,
            ),
          HeroUiDashboardText(metric.change, type: .bodyXs, muted: true),
        ],
      ),
    ),
    chartBuilder: (context, data) => GridBox(
      style: GridBoxStyler.equalColumns(
        3,
      ).gap(16).onConstraints(const .maxWidth(759), .equalColumns(1).gap(16)),
      children: [_revenueCard(data), _customerChartCard(), _fulfillmentCard()],
    ),
    tableBuilder: (context, data) => GridBox(
      style: GridBoxStyler.equalColumns(
        2,
      ).gap(20).onConstraints(const .maxWidth(899), .equalColumns(1).gap(20)),
      children: [_activityCard(data), _ordersCard(context, data, onViewOrders)],
    ),
  );
}

/// A card whose header is HeroUI's card title and description.
Widget _chartCard({
  required String title,
  required String description,
  required List<Widget> children,
}) => HeroUiCard(
  child: ColumnBox(
    style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(16),
    children: [
      ColumnBox(
        style: FlexBoxStyler().crossAxisAlignment(.start),
        children: [HeroUiCardTitle(title), HeroUiCardDescription(description)],
      ),
      ...children,
    ],
  ),
);

Widget _revenueCard(RegistryDashboardSampleData data) => _chartCard(
  title: 'Revenue trend',
  description: 'Seven-day net revenue',
  children: [
    Box(
      key: const ValueKey('dashboard-revenue-chart'),
      style: BoxStyler().height(220),
      child: HeroUiLineChart(
        semanticsLabel: 'Seven-day net revenue',
        showMarkers: true,
        series: [_revenueSeries(data.revenue)],
        // Half a step of room at each end keeps the first and last labels
        // and markers off the plot's edges, where a marker is cut in half
        // and a label is pushed into its neighbor.
        xAxis: ChartAxis.numeric(
          min: -0.5,
          max: data.revenue.length > 1 ? data.revenue.length - 0.5 : 1.5,
          interval: 1,
          minIncluded: false,
          maxIncluded: false,
          labelFormatter: (value) => _pointLabel(data.revenue, value),
        ),
        // Round steps, with room past each end so the end labels sit on
        // their gridlines.
        yAxis: registryDashboardDataAxis(
          data.revenue.map((point) => point.value),
        ),
        style: registryDashboardLineStyle(),
      ),
    ),
  ],
);

const _customerAcquisitionValues = [18.0, 24.0, 21.0, 32.0, 38.0, 44.0];

Widget _customerChartCard() => _chartCard(
  title: 'Customer acquisition',
  description: 'New accounts by month',
  children: [
    Box(
      style: BoxStyler().height(220),
      child: HeroUiBarChart(
        semanticsLabel: 'New accounts by month',
        groups: [
          for (final (index, value) in _customerAcquisitionValues.indexed)
            BarGroup(
              id: 'customers-$index',
              label: const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'][index],
              bars: [BarValue(id: 'customers', label: 'Customers', toY: value)],
            ),
        ],
        yAxis: registryDashboardDataAxis(_customerAcquisitionValues),
        style: registryDashboardBarStyle(),
      ),
    ),
  ],
);

Widget _fulfillmentCard() => _chartCard(
  title: 'Fulfillment mix',
  description: 'Current order status',
  children: [
    // The legend names the series colors the pie draws: the first three of
    // the chart ramp.
    RegistryChartLegend(
      items: [
        RegistryChartLegendItem(
          label: 'Fulfilled',
          detail: '72%',
          color: heroUiChartSeries[0],
        ),
        RegistryChartLegendItem(
          label: 'Processing',
          detail: '18%',
          color: heroUiChartSeries[1],
        ),
        RegistryChartLegendItem(
          label: 'Review',
          detail: '10%',
          color: heroUiChartSeries[2],
        ),
      ],
      labelStyle: heroUiDashboardTextStyle(type: .bodyXs, emphasized: true),
      detailStyle: heroUiDashboardTextStyle(type: .bodyXs, muted: true),
    ),
    Box(
      style: BoxStyler().height(190),
      child: HeroUiPieChart(
        centerRadius: 44,
        // mix_chart draws each slice 80px wide in any box; this ring stops
        // the donut at 88px, 80% of the way to the edge of its box.
        style: PieChartStyler().slice(PieSliceStyler().radius(44)),
        semanticsLabel: 'Current order status',
        slices: [
          PieSlice(id: 'fulfilled', label: 'Fulfilled', value: 72),
          PieSlice(id: 'processing', label: 'Processing', value: 18),
          PieSlice(id: 'review', label: 'Review', value: 10),
        ],
      ),
    ),
  ],
);

Widget _activityCard(RegistryDashboardSampleData data) => HeroUiCard(
  child: ColumnBox(
    style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(8),
    children: [
      const HeroUiCardTitle('Recent activity'),
      ColumnBox(
        style: FlexBoxStyler().crossAxisAlignment(.stretch),
        children: [
          for (final (index, event) in data.activities.indexed) ...[
            Box(
              style: BoxStyler().padding(.vertical(10)),
              child: RowBox(
                style: FlexBoxStyler().crossAxisAlignment(.center).spacing(12),
                children: [
                  Box(
                    style: BoxStyler()
                        .size(32, 32)
                        .alignment(.center)
                        .borderRadius(.all(HeroUiTokens.radiusXl()))
                        .color(HeroUiTokens.defaultColor()),
                    child: StyledIcon(
                      icon: _activityIcon(event.kind),
                      style: IconStyler()
                          .size(16)
                          .color(HeroUiTokens.defaultForeground()),
                    ),
                  ),
                  Expanded(
                    child: ColumnBox(
                      style: FlexBoxStyler()
                          .crossAxisAlignment(.start)
                          .spacing(2),
                      children: [
                        HeroUiDashboardText(event.title, emphasized: true),
                        HeroUiDashboardText(event.detail, muted: true),
                      ],
                    ),
                  ),
                  HeroUiDashboardText(
                    event.relativeTime,
                    type: .bodyXs,
                    muted: true,
                  ),
                ],
              ),
            ),
            if (index != data.activities.length - 1) const HeroUiSeparator(),
          ],
        ],
      ),
    ],
  ),
);

IconData _activityIcon(RegistryDashboardActivityKind kind) => switch (kind) {
  .customer => RemixIcons.user,
  .order => RemixIcons.box,
  .payment => RemixIcons.checkCircle,
  .alert => RemixIcons.warning,
};

Widget _ordersCard(
  BuildContext context,
  RegistryDashboardSampleData data,
  VoidCallback? onViewOrders,
) => HeroUiCard(
  child: ColumnBox(
    style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(12),
    children: [
      RowBox(
        style: FlexBoxStyler().crossAxisAlignment(.center),
        children: [
          const Expanded(child: HeroUiCardTitle('Recent orders')),
          HeroUiButton.ghost(
            key: const ValueKey('overview-view-orders'),
            size: .sm,
            label: 'View all',
            trailingIcon: Directionality.of(context) == TextDirection.rtl
                ? RemixIcons.chevronsLeft
                : RemixIcons.chevronsRight,
            onPressed: onViewOrders,
          ),
        ],
      ),
      HeroUiTable<RegistryDashboardRecord>.secondary(
        key: const ValueKey('dashboard-records-table'),
        semanticLabel: 'Recent customer orders',
        rows: data.records,
        // Fits the half-width card at a 1280px desktop with the sidebar open,
        // with the table's 16px cell insets; narrower than this, the table
        // scrolls sideways.
        minimumWidth: 440,
        columns: _recordColumns,
      ),
    ],
  ),
);

/// A status chip: soft, in the status colour the value names.
Widget heroUiDashboardStatusChip(String status) =>
    HeroUiChip.soft(label: status, size: .sm, color: _statusColor(status));

HeroUiColor _statusColor(String status) => switch (status.toLowerCase()) {
  'paid' || 'fulfilled' || 'active' => .success,
  'pending' || 'in review' || 'invited' => .warning,
  'cancelled' || 'suspended' => .danger,
  _ => .defaultColor,
};

Widget _cell(String text, {bool emphasized = false}) =>
    HeroUiDashboardText(text, emphasized: emphasized);

LineSeries _revenueSeries(List<RegistryDashboardPoint> points) => LineSeries(
  id: 'revenue',
  label: 'Revenue',
  points: [
    for (final (index, point) in points.indexed)
      ChartPoint(id: index, x: index.toDouble(), y: point.value),
  ],
);

String _pointLabel(List<RegistryDashboardPoint> points, double value) {
  final index = value.round();
  return index >= 0 && index < points.length ? points[index].label : '';
}

final _recordColumns = <RemixDataTableColumn<RegistryDashboardRecord>>[
  RemixDataTableColumn(
    id: 'id',
    label: 'Record',
    // An order number on one line inside the 16px cell insets.
    width: const FixedColumnWidth(112),
    cellBuilder: (_, record) => _cell(record.id, emphasized: true),
  ),
  RemixDataTableColumn(
    id: 'customer',
    label: 'Customer',
    width: const FlexColumnWidth(2),
    cellBuilder: (_, record) => _cell(record.customer),
  ),
  RemixDataTableColumn(
    id: 'status',
    label: 'Status',
    width: const FixedColumnWidth(104),
    cellBuilder: (_, record) => Align(
      alignment: AlignmentDirectional.centerStart,
      child: heroUiDashboardStatusChip(record.status),
    ),
  ),
  RemixDataTableColumn(
    id: 'amount',
    label: 'Amount',
    width: const FixedColumnWidth(96),
    alignment: AlignmentDirectional.centerEnd,
    cellBuilder: (_, record) => _cell(record.amount, emphasized: true),
  ),
];
