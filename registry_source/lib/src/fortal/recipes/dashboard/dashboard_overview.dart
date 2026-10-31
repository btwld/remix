import 'package:flutter/widgets.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../../dashboard/dashboard_demo_charts.dart';
import '../../../dashboard/dashboard_overview_base.dart';
import '../../../dashboard/dashboard_sample_data.dart';
import '../../components/avatar.dart';
import '../../components/button.dart';
import '../../components/card.dart';
import '../../components/chart.dart';
import '../../components/data_table.dart';
import '../../components/divider.dart';
import '../../components/text.dart';
import '../../theme/theme.dart';
import 'dashboard_demo_page_header.dart';
import 'dashboard_demo_theme.dart';
import 'dashboard_demo_typography.dart';
import 'dashboard_demo_widgets.dart';

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
  Widget build(BuildContext context) {
    return RegistryDashboardOverviewBase(
      data: data,
      scrollController: scrollController,
      headerBuilder: (context, title, description) =>
          FortalPageHeader(title: title, description: description),
      metricBuilder: (context, metric) => FortalStatCard(
        label: metric.label,
        value: metric.value,
        caption: metric.change,
        delta: metric.delta,
        positive: metric.positive,
        progress: metric.progress,
      ),
      chartBuilder: (context, data) => FortalAnalyticsCharts(data: data),
      tableBuilder: (context, data) => GridBox(
        style: GridBoxStyler.equalColumns(2)
            .gap(20)
            .onConstraints(const .maxWidth(1001), .equalColumns(1).gap(20)),
        children: [_activityCard(data), _ordersCard(data, onViewOrders)],
      ),
    );
  }
}

/// Overview analytics chart grid for the Fortal dashboard.
class FortalAnalyticsCharts extends StatelessWidget {
  const FortalAnalyticsCharts({
    super.key,
    this.data = registryDashboardSampleData,
  });

  final RegistryDashboardSampleData data;

  @override
  Widget build(BuildContext context) {
    final palette = resolveFortalChartPalette(context);
    final gap = MixScope.tokenOf(FortalTokens.space4, context);
    final chartInset = MixScope.tokenOf(FortalTokens.space2, context);

    return GridBox(
      key: const ValueKey('overview-chart-grid'),
      style: GridBoxStyler.equalColumns(3)
          .gap(gap)
          .onConstraints(const .maxWidth(1119), .equalColumns(2).gap(gap))
          .onConstraints(const .maxWidth(719), .equalColumns(1).gap(gap)),
      children: [
        _revenueCard(data, palette),
        _orderVolumeCard(palette),
        _channelMixCard(palette, chartInset),
      ],
    );
  }
}

Widget _revenueCard(RegistryDashboardSampleData data, List<Color> palette) =>
    FortalChartCard(
      title: 'Revenue trend',
      description: 'Seven-day net revenue',
      chartPadding: EdgeInsets.zero,
      chart: Box(
        key: const ValueKey('dashboard-revenue-chart'),
        child: FortalLineChart(
          palette: palette,
          semanticsLabel: 'Seven-day net revenue',
          showMarkers: true,
          series: [_revenueSeries(data.revenue)],
          xAxis: ChartAxis.numeric(
            min: -0.5,
            max: data.revenue.length > 1 ? data.revenue.length - 0.5 : 1.5,
            interval: 1,
            minIncluded: false,
            maxIncluded: false,
            labelFormatter: (value) => _pointLabel(data.revenue, value),
          ),
          yAxis: registryDashboardNumericAxis(max: 100, interval: 20),
          style: registryDashboardLineStyle(),
        ),
      ),
    );

Widget _orderVolumeCard(List<Color> palette) => FortalChartCard(
  title: 'Order volume',
  description: 'Actual versus plan',
  chartPadding: EdgeInsets.zero,
  legend: FortalDashboardChartLegend(
    key: const ValueKey('overview-order-legend'),
    semanticLabel: 'Order volume series',
    items: [
      FortalDashboardChartLegendItem(
        id: 'actual',
        label: 'Actual',
        color: palette[0],
      ),
      FortalDashboardChartLegendItem(
        id: 'plan',
        label: 'Plan',
        color: palette[1],
        pattern: .dashed,
      ),
    ],
  ),
  chart: FortalBarChart(
    key: const ValueKey('overview-order-chart'),
    palette: palette,
    semanticsLabel: 'Quarterly actual and planned orders',
    groups: [
      _orderGroup('q1', 'Q1', 52, 48, palette),
      _orderGroup('q2', 'Q2', 68, 64, palette),
      _orderGroup('q3', 'Q3', 74, 78, palette),
      _orderGroup('q4', 'Q4', 88, 82, palette),
    ],
    yAxis: registryDashboardNumericAxis(max: 100, interval: 25),
    style: registryDashboardBarStyle(),
  ),
);

BarGroup _orderGroup(
  String id,
  String label,
  double actual,
  double plan,
  List<Color> palette,
) => BarGroup(
  id: id,
  label: label,
  bars: [
    BarValue(
      id: 'actual',
      label: 'Actual',
      toY: actual,
      style: BarStyler().color(palette[0]),
    ),
    BarValue(
      id: 'plan',
      label: 'Plan',
      toY: plan,
      style: BarStyler()
          .color(palette[1].withValues(alpha: 0.22))
          .border(BorderSide(color: palette[1], width: 2))
          .borderDashArray([4, 3]),
    ),
  ],
);

Widget _channelMixCard(List<Color> palette, double chartInset) {
  final slices = [
    PieSlice(id: 'direct', label: 'Direct', value: 46),
    PieSlice(id: 'partners', label: 'Partners', value: 31),
    PieSlice(id: 'marketplace', label: 'Marketplace', value: 23),
  ];
  return FortalChartCard(
    title: 'Channel mix',
    description: 'Revenue contribution',
    chartPadding: EdgeInsets.symmetric(
      horizontal: chartInset,
      vertical: chartInset,
    ),
    chartPaddingKey: const ValueKey('overview-channel-chart-safe-area'),
    legend: FortalDashboardChartLegend(
      key: const ValueKey('overview-channel-legend'),
      semanticLabel: 'Revenue contribution legend',
      items: fortalPercentagePieLegendItems(slices: slices, palette: palette),
    ),
    chart: PieChart(
      style: fortalPieChartStyle(
        palette: palette,
        centerRadius: 44,
      ).slice(PieSliceStyler().radius(36)),
      semanticsLabel: 'Revenue contribution by channel',
      slices: slices,
      valueFormatter: (value) => '${value.toInt()}%',
    ),
  );
}

Widget _activityCard(RegistryDashboardSampleData data) => FortalCard(
  size: .size2,
  child: ColumnBox(
    style: FlexBoxStyler().crossAxisAlignment(.stretch),
    children: [
      Box(
        style: BoxStyler().padding(.bottom(8)),
        child: const FortalSectionLabel('Recent activity'),
      ),
      for (final (index, event) in data.activities.indexed) ...[
        RowBox(
          style: FlexBoxStyler()
              .padding(.symmetric(vertical: 11))
              .crossAxisAlignment(.center)
              .spacing(12),
          children: [
            _FortalActivityIcon(kind: event.kind),
            Expanded(
              child: ColumnBox(
                style: FlexBoxStyler().crossAxisAlignment(.start).spacing(2),
                children: [
                  FortalText(event.title, size: .size2, weight: .medium),
                  StyledText(
                    event.detail,
                    style: dashboardText(.size1, tone: .muted),
                  ),
                ],
              ),
            ),
            StyledText(
              event.relativeTime,
              style: dashboardText(.size1, tone: .subtle),
            ),
          ],
        ),
        if (index != data.activities.length - 1)
          const FortalDivider(size: .size4),
      ],
    ],
  ),
);

class _FortalActivityIcon extends StatelessWidget {
  const _FortalActivityIcon({required this.kind});

  final RegistryDashboardActivityKind kind;

  @override
  Widget build(BuildContext context) {
    final (icon, accent) = switch (kind) {
      .customer => (RemixIcons.user, FortalAccentColor.blue),
      .order => (LucideIcons.box, FortalAccentColor.indigo),
      .payment => (LucideIcons.circleCheck, FortalAccentColor.green),
      .alert => (RemixIcons.warning, FortalAccentColor.amber),
    };

    return FortalAccentScope(
      accent: accent,
      child: FortalAvatar.soft(icon: icon, size: .size2),
    );
  }
}

Widget _ordersCard(
  RegistryDashboardSampleData data,
  VoidCallback? onViewOrders,
) => FortalCard(
  size: .size2,
  child: ColumnBox(
    style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(12),
    children: [
      RowBox(
        style: FlexBoxStyler().crossAxisAlignment(.center),
        children: [
          const Expanded(child: FortalSectionLabel('Recent orders')),
          FortalButton.ghost(
            key: const ValueKey('overview-view-orders'),
            size: .size1,
            label: 'View all',
            trailingIcon: LucideIcons.chevronsRight,
            onPressed: onViewOrders,
          ),
        ],
      ),
      FortalDataTable<RegistryDashboardRecord>.surface(
        key: const ValueKey('dashboard-records-table'),
        semanticLabel: 'Recent orders',
        rows: data.records,
        minimumWidth: 400,
        columns: _recordColumns,
      ),
    ],
  ),
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
    label: 'Order',
    width: const FixedColumnWidth(105),
    cellBuilder: (_, record) =>
        FortalDataTableCellText(record.id, primary: true),
  ),
  RemixDataTableColumn(
    id: 'customer',
    label: 'Customer',
    width: const FlexColumnWidth(2),
    cellBuilder: (_, record) => FortalDataTableCellText(record.customer),
  ),
  RemixDataTableColumn(
    id: 'amount',
    label: 'Amount',
    width: const FixedColumnWidth(100),
    alignment: AlignmentDirectional.centerEnd,
    cellBuilder: (_, record) =>
        FortalDataTableCellText(record.amount, primary: true),
  ),
  RemixDataTableColumn(
    id: 'status',
    label: 'Status',
    width: const FixedColumnWidth(94),
    cellBuilder: (_, record) => FortalStatusBadge.label(record.status),
  ),
];
