import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';

import '../../../dashboard/dashboard_overview_base.dart';
import '../../../dashboard/dashboard_sample_data.dart';
import '../../components/card.dart';
import '../../components/chart.dart';
import '../../components/data_table.dart';
import '../../theme/tokens.dart';

/// The default-preset dashboard overview.
///
/// Pass local [data] to replace the starter metrics, chart, and records without
/// changing the responsive composition.
class VanillaDashboardOverview extends StatelessWidget {
  const VanillaDashboardOverview({
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
        StyledText(
          title,
          style: TextStyler()
              .fontSize(28)
              .fontWeight(FontWeight.w700)
              .color(VanillaTokens.foreground()),
        ),
        const SizedBox(height: 6),
        StyledText(
          description,
          style: TextStyler()
              .fontSize(14)
              .color(VanillaTokens.mutedForeground()),
        ),
      ],
    ),
    metricBuilder: (context, metric) => VanillaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StyledText(
            metric.label,
            style: TextStyler()
                .fontSize(13)
                .fontWeight(FontWeight.w500)
                .color(VanillaTokens.mutedForeground()),
          ),
          const SizedBox(height: 10),
          StyledText(
            metric.value,
            style: TextStyler()
                .fontSize(24)
                .fontWeight(FontWeight.w700)
                .color(VanillaTokens.foreground()),
          ),
          const SizedBox(height: 6),
          StyledText(
            metric.change,
            style: TextStyler()
                .fontSize(12)
                .color(VanillaTokens.mutedForeground()),
          ),
        ],
      ),
    ),
    chartBuilder: (context, data) => VanillaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle('Revenue trend'),
          const SizedBox(height: 4),
          _sectionDescription('Seven-day net revenue'),
          const SizedBox(height: 16),
          SizedBox(
            key: const ValueKey('dashboard-revenue-chart'),
            height: 260,
            child: VanillaLineChart(
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
        _sectionTitle('Recent records'),
        const SizedBox(height: 4),
        _sectionDescription('Latest customer orders'),
        const SizedBox(height: 12),
        VanillaDataTable<RegistryDashboardRecord>(
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

Widget _sectionTitle(String text) => StyledText(
  text,
  style: TextStyler()
      .fontSize(17)
      .fontWeight(FontWeight.w600)
      .color(VanillaTokens.foreground()),
);

Widget _sectionDescription(String text) => StyledText(
  text,
  style: TextStyler().fontSize(13).color(VanillaTokens.mutedForeground()),
);

Widget _cell(String text, {bool emphasized = false}) => StyledText(
  text,
  style: TextStyler()
      .fontSize(14)
      .fontWeight(emphasized ? FontWeight.w600 : FontWeight.w400)
      .color(VanillaTokens.foreground()),
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
