import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/button.dart';
import '../../components/card.dart';
import '../../components/chart.dart';
import '../../components/data_table.dart';
import '../../components/divider.dart';
import '../../theme/tokens.dart';
import 'dashboard_overview_base.dart';
import 'dashboard_sample_data.dart';

/// The default-preset dashboard overview.
///
/// Pass local [data] to replace the starter metrics, chart, and records without
/// changing the responsive composition.
class PlaygroundDashboardOverview extends StatelessWidget {
  const PlaygroundDashboardOverview({
    super.key,
    this.data = playgroundDashboardSampleData,
    this.scrollController,
    this.onViewOrders,
  });

  final PlaygroundDashboardSampleData data;
  final ScrollController? scrollController;
  final VoidCallback? onViewOrders;

  @override
  Widget build(BuildContext context) => PlaygroundDashboardOverviewBase(
    data: data,
    scrollController: scrollController,
    headerBuilder: (context, title, description) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StyledText(
          title,
          style: TextStyler()
              .fontSize(28)
              .fontWeight(FontWeight.w700)
              .color(PlaygroundTokens.foreground()),
        ),
        const SizedBox(height: 6),
        StyledText(
          description,
          style: TextStyler()
              .fontSize(14)
              .color(PlaygroundTokens.mutedForeground()),
        ),
      ],
    ),
    metricBuilder: (context, metric) => PlaygroundCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StyledText(
            metric.label,
            style: TextStyler()
                .fontSize(13)
                .fontWeight(FontWeight.w500)
                .color(PlaygroundTokens.mutedForeground()),
          ),
          const SizedBox(height: 10),
          StyledText(
            metric.value,
            style: TextStyler()
                .fontSize(24)
                .fontWeight(FontWeight.w700)
                .color(PlaygroundTokens.foreground()),
          ),
          const SizedBox(height: 6),
          StyledText(
            metric.change,
            style: TextStyler()
                .fontSize(12)
                .color(PlaygroundTokens.mutedForeground()),
          ),
        ],
      ),
    ),
    chartBuilder: (context, data) => LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth < 760
            ? constraints.maxWidth
            : (constraints.maxWidth - 32) / 3;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(width: width, child: _revenueCard(data)),
            SizedBox(width: width, child: _customerChartCard()),
            SizedBox(width: width, child: _fulfillmentCard()),
          ],
        );
      },
    ),
    tableBuilder: (context, data) => LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth < 900
            ? constraints.maxWidth
            : (constraints.maxWidth - 20) / 2;
        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            SizedBox(width: width, child: _activityCard(data)),
            SizedBox(width: width, child: _ordersCard(data, onViewOrders)),
          ],
        );
      },
    ),
  );
}

Widget _revenueCard(PlaygroundDashboardSampleData data) => PlaygroundCard(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _sectionTitle('Revenue trend'),
      const SizedBox(height: 4),
      _sectionDescription('Seven-day net revenue'),
      const SizedBox(height: 16),
      SizedBox(
        key: const ValueKey('dashboard-revenue-chart'),
        height: 220,
        child: PlaygroundLineChart(
          semanticsLabel: 'Seven-day net revenue',
          showMarkers: true,
          series: [_revenueSeries(data.revenue)],
          xAxis: ChartAxis.numeric(
            min: 0,
            max: data.revenue.length > 1
                ? (data.revenue.length - 1).toDouble()
                : 1,
            interval: 1,
            labelFormatter: (value) => _pointLabel(data.revenue, value),
          ),
          yAxis: ChartAxis.numeric(min: 0, interval: 20),
        ),
      ),
    ],
  ),
);

Widget _customerChartCard() => PlaygroundCard(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _sectionTitle('Customer acquisition'),
      const SizedBox(height: 4),
      _sectionDescription('New accounts by month'),
      const SizedBox(height: 16),
      SizedBox(
        height: 220,
        child: PlaygroundBarChart(
          semanticsLabel: 'New accounts by month',
          groups: [
            for (final (index, value) in const [
              18.0,
              24.0,
              21.0,
              32.0,
              38.0,
              44.0,
            ].indexed)
              BarGroup(
                id: 'customers-$index',
                label: const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'][index],
                bars: [
                  BarValue(id: 'customers', label: 'Customers', toY: value),
                ],
              ),
          ],
        ),
      ),
    ],
  ),
);

Widget _fulfillmentCard() => PlaygroundCard(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _sectionTitle('Fulfillment mix'),
      const SizedBox(height: 4),
      _sectionDescription('Current order status'),
      const SizedBox(height: 16),
      SizedBox(
        height: 220,
        child: PlaygroundPieChart(
          centerRadius: 44,
          semanticsLabel: 'Current order status',
          slices: [
            PieSlice(id: 'fulfilled', label: 'Fulfilled', value: 72),
            PieSlice(id: 'processing', label: 'Processing', value: 18),
            PieSlice(id: 'review', label: 'Review', value: 10),
          ],
        ),
      ),
    ],
  ),
);

Widget _activityCard(PlaygroundDashboardSampleData data) => PlaygroundCard(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _sectionTitle('Recent activity'),
      const SizedBox(height: 8),
      for (final (index, event) in data.activities.indexed) ...[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            children: [
              const Icon(RemixIcons.activityLog, size: 16),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _cell(event.title, emphasized: true),
                    _sectionDescription(event.detail),
                  ],
                ),
              ),
              _sectionDescription(event.relativeTime),
            ],
          ),
        ),
        if (index != data.activities.length - 1) const PlaygroundDivider(),
      ],
    ],
  ),
);

Widget _ordersCard(
  PlaygroundDashboardSampleData data,
  VoidCallback? onViewOrders,
) => PlaygroundCard(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Expanded(child: _sectionTitle('Recent orders')),
          PlaygroundButton.ghost(
            key: const ValueKey('overview-view-orders'),
            size: .small,
            label: 'View all',
            onPressed: onViewOrders,
          ),
        ],
      ),
      const SizedBox(height: 12),
      PlaygroundDataTable<PlaygroundDashboardRecord>(
        key: const ValueKey('dashboard-records-table'),
        semanticLabel: 'Recent customer orders',
        rows: data.records,
        minimumWidth: 560,
        columns: _recordColumns,
      ),
    ],
  ),
);

Widget _sectionTitle(String text) => StyledText(
  text,
  style: TextStyler()
      .fontSize(17)
      .fontWeight(FontWeight.w600)
      .color(PlaygroundTokens.foreground()),
);

Widget _sectionDescription(String text) => StyledText(
  text,
  style: TextStyler().fontSize(13).color(PlaygroundTokens.mutedForeground()),
);

Widget _cell(String text, {bool emphasized = false}) => StyledText(
  text,
  style: TextStyler()
      .fontSize(14)
      .fontWeight(emphasized ? FontWeight.w600 : FontWeight.w400)
      .color(PlaygroundTokens.foreground()),
);

LineSeries _revenueSeries(List<PlaygroundDashboardPoint> points) => LineSeries(
  id: 'revenue',
  label: 'Revenue',
  points: [
    for (final (index, point) in points.indexed)
      ChartPoint(id: point.label, x: index.toDouble(), y: point.value),
  ],
);

String _pointLabel(List<PlaygroundDashboardPoint> points, double value) {
  final index = value.round();
  return index >= 0 && index < points.length ? points[index].label : '';
}

final _recordColumns = <RemixDataTableColumn<PlaygroundDashboardRecord>>[
  RemixDataTableColumn(
    id: 'id',
    label: 'Record',
    width: const FixedColumnWidth(120),
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
    width: const FixedColumnWidth(130),
    cellBuilder: (_, record) => _cell(record.status),
  ),
  RemixDataTableColumn(
    id: 'amount',
    label: 'Amount',
    width: const FixedColumnWidth(110),
    alignment: AlignmentDirectional.centerEnd,
    cellBuilder: (_, record) => _cell(record.amount, emphasized: true),
  ),
];
