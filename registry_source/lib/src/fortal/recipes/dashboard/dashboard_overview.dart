import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../../dashboard/dashboard_overview_base.dart';
import '../../../dashboard/dashboard_sample_data.dart';
import '../../components/card.dart';
import '../../components/chart.dart';
import '../../components/data_table.dart';
import '../../components/button.dart';
import '../../components/divider.dart';
import '../../components/text.dart';
import '../../components/typography.dart';

/// The Fortal dashboard overview with Radix-native surfaces and type.
class FortalDashboardOverview extends StatelessWidget {
  const FortalDashboardOverview({
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
    headerBuilder: (context, title, description) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FortalText(title, size: .size7, weight: .bold),
        const SizedBox(height: 6),
        FortalText(description, size: .size2, highContrast: false),
      ],
    ),
    metricBuilder: (context, metric) => FortalCard.surface(
      size: .size2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FortalText(metric.label, size: .size2, weight: .medium),
          const SizedBox(height: 10),
          FortalText(metric.value, size: .size6, weight: .bold),
          const SizedBox(height: 6),
          FortalText(metric.change, size: .size1, highContrast: false),
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

Widget _revenueCard(RegistryDashboardSampleData data) => FortalCard.surface(
  size: .size2,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const FortalText('Revenue trend', size: .size4, weight: .bold),
      const SizedBox(height: 4),
      const FortalText(
        'Seven-day net revenue',
        size: .size2,
        highContrast: false,
      ),
      const SizedBox(height: 16),
      SizedBox(
        key: const ValueKey('dashboard-revenue-chart'),
        height: 220,
        child: FortalLineChart(
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
          // An explicit max that is a whole number of intervals: the top
          // gridline label and the axis maximum then coincide instead of
          // rendering two labels at almost the same height.
          yAxis: ChartAxis.numeric(min: 0, max: 100, interval: 20),
        ),
      ),
    ],
  ),
);

Widget _customerChartCard() => FortalCard.surface(
  size: .size2,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const FortalText('Customer acquisition', size: .size4, weight: .bold),
      const SizedBox(height: 4),
      const FortalText(
        'New accounts by month',
        size: .size2,
        highContrast: false,
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 220,
        child: FortalBarChart(
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
          // Customers peak at 44; see the revenue chart above for why the
          // maximum is pinned to a whole number of intervals.
          yAxis: ChartAxis.numeric(min: 0, max: 50, interval: 10),
        ),
      ),
    ],
  ),
);

Widget _fulfillmentCard() => FortalCard.surface(
  size: .size2,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const FortalText('Fulfillment mix', size: .size4, weight: .bold),
      const SizedBox(height: 4),
      const FortalText(
        'Current order status',
        size: .size2,
        highContrast: false,
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 220,
        child: FortalPieChart(
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

Widget _activityCard(RegistryDashboardSampleData data) => FortalCard.surface(
  size: .size2,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const FortalText('Recent activity', size: .size4, weight: .bold),
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
                    FortalText(event.title, size: .size2, weight: .medium),
                    FortalText(event.detail, size: .size1, highContrast: false),
                  ],
                ),
              ),
              FortalText(event.relativeTime, size: .size1, highContrast: false),
            ],
          ),
        ),
        if (index != data.activities.length - 1) const FortalDivider(),
      ],
    ],
  ),
);

Widget _ordersCard(
  RegistryDashboardSampleData data,
  VoidCallback? onViewOrders,
) => FortalCard.surface(
  size: .size2,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          const Expanded(
            child: FortalText('Recent orders', size: .size4, weight: .bold),
          ),
          FortalButton.ghost(
            key: const ValueKey('overview-view-orders'),
            size: .size1,
            label: 'View all',
            onPressed: onViewOrders,
          ),
        ],
      ),
      const SizedBox(height: 12),
      FortalDataTable<RegistryDashboardRecord>.surface(
        key: const ValueKey('dashboard-records-table'),
        semanticLabel: 'Recent customer orders',
        rows: data.records,
        minimumWidth: 560,
        columns: _recordColumns,
      ),
    ],
  ),
);

Widget _cell(String text, {bool emphasized = false}) => FortalText(
  text,
  size: .size2,
  weight: emphasized ? FortalTextWeight.bold : FortalTextWeight.regular,
);

LineSeries _revenueSeries(List<RegistryDashboardPoint> points) => LineSeries(
  id: 'revenue',
  label: 'Revenue',
  points: [
    for (final (index, point) in points.indexed)
      ChartPoint(id: point.label, x: index.toDouble(), y: point.value),
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
