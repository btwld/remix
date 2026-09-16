import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';

import '../../../dashboard/dashboard_overview_base.dart';
import '../../../dashboard/dashboard_sample_data.dart';
import '../../components/card.dart';
import '../../components/chart.dart';
import '../../components/data_table.dart';
import '../../components/text.dart';
import '../../components/typography.dart';

/// The Fortal dashboard overview with Radix-native surfaces and type.
class FortalDashboardOverview extends StatelessWidget {
  const FortalDashboardOverview({
    super.key,
    this.data = registryDashboardSampleData,
    this.scrollController,
  });

  final RegistryDashboardSampleData data;
  final ScrollController? scrollController;

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
    chartBuilder: (context, data) => FortalCard.surface(
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
            height: 260,
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
              yAxis: ChartAxis.numeric(
                min: 0,
                interval: 20,
                labelFormatter: (value) => '\$${value.toInt()}k',
              ),
            ),
          ),
        ],
      ),
    ),
    tableBuilder: (context, data) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const FortalText('Recent records', size: .size4, weight: .bold),
        const SizedBox(height: 4),
        const FortalText(
          'Latest customer orders',
          size: .size2,
          highContrast: false,
        ),
        const SizedBox(height: 12),
        FortalDataTable<RegistryDashboardRecord>.surface(
          key: const ValueKey('dashboard-records-table'),
          semanticLabel: 'Recent customer orders',
          rows: data.records,
          minimumWidth: 620,
          columns: _recordColumns,
        ),
      ],
    ),
  );
}

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
