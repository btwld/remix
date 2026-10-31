import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/avatar.dart';
import '../../components/button.dart';
import '../../components/card.dart';
import '../../components/chart.dart';
import '../../components/data_table.dart';
import '../../components/divider.dart';
import '../../components/text.dart';
import '../../theme/theme.dart';
import 'dashboard_demo_charts.dart';
import 'dashboard_demo_page_header.dart';
import 'dashboard_demo_theme.dart';
import 'dashboard_demo_typography.dart';
import 'dashboard_demo_widgets.dart';
import 'dashboard_overview_base.dart';
import 'dashboard_sample_data.dart';

class UiDashboardOverview extends StatelessWidget {
  const UiDashboardOverview({
    super.key,
    this.data = uiDashboardSampleData,
    this.scrollController,
    this.onViewOrders,
  });

  final UiDashboardSampleData data;
  final ScrollController? scrollController;
  final VoidCallback? onViewOrders;

  @override
  Widget build(BuildContext context) {
    return UiDashboardOverviewBase(
      data: data,
      scrollController: scrollController,
      headerBuilder: (context, title, description) =>
          UiPageHeader(title: title, description: description),
      metricBuilder: (context, metric) => UiStatCard(
        label: metric.label,
        value: metric.value,
        caption: metric.change,
        delta: metric.delta,
        positive: metric.positive,
        progress: metric.progress,
      ),
      chartBuilder: (context, data) => UiAnalyticsCharts(data: data),
      tableBuilder: (context, data) => GridBox(
        style: GridBoxStyler.equalColumns(2)
            .gap(20)
            .onConstraints(const .maxWidth(1001), .equalColumns(1).gap(20)),
        children: [_activityCard(data), _ordersCard(data, onViewOrders)],
      ),
    );
  }
}

/// Overview analytics chart grid for the Ui dashboard.
class UiAnalyticsCharts extends StatelessWidget {
  const UiAnalyticsCharts({super.key, this.data = uiDashboardSampleData});

  final UiDashboardSampleData data;

  @override
  Widget build(BuildContext context) {
    final palette = resolveUiChartPalette(context);
    final gap = MixScope.tokenOf(UiTokens.space4, context);
    final chartInset = MixScope.tokenOf(UiTokens.space2, context);

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

Widget _revenueCard(UiDashboardSampleData data, List<Color> palette) =>
    UiChartCard(
      title: 'Revenue trend',
      description: 'Seven-day net revenue',
      chartPadding: EdgeInsets.zero,
      chart: Box(
        key: const ValueKey('dashboard-revenue-chart'),
        child: UiLineChart(
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
          yAxis: uiDashboardNumericAxis(max: 100, interval: 20),
          style: uiDashboardLineStyle(),
        ),
      ),
    );

Widget _orderVolumeCard(List<Color> palette) => UiChartCard(
  title: 'Order volume',
  description: 'Actual versus plan',
  chartPadding: EdgeInsets.zero,
  legend: UiDashboardChartLegend(
    key: const ValueKey('overview-order-legend'),
    semanticLabel: 'Order volume series',
    items: [
      UiDashboardChartLegendItem(
        id: 'actual',
        label: 'Actual',
        color: palette[0],
      ),
      UiDashboardChartLegendItem(
        id: 'plan',
        label: 'Plan',
        color: palette[1],
        pattern: .dashed,
      ),
    ],
  ),
  chart: UiBarChart(
    key: const ValueKey('overview-order-chart'),
    palette: palette,
    semanticsLabel: 'Quarterly actual and planned orders',
    groups: [
      _orderGroup('q1', 'Q1', 52, 48, palette),
      _orderGroup('q2', 'Q2', 68, 64, palette),
      _orderGroup('q3', 'Q3', 74, 78, palette),
      _orderGroup('q4', 'Q4', 88, 82, palette),
    ],
    yAxis: uiDashboardNumericAxis(max: 100, interval: 25),
    style: uiDashboardBarStyle(),
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
  return UiChartCard(
    title: 'Channel mix',
    description: 'Revenue contribution',
    chartPadding: EdgeInsets.symmetric(
      horizontal: chartInset,
      vertical: chartInset,
    ),
    chartPaddingKey: const ValueKey('overview-channel-chart-safe-area'),
    legend: UiDashboardChartLegend(
      key: const ValueKey('overview-channel-legend'),
      semanticLabel: 'Revenue contribution legend',
      items: uiPercentagePieLegendItems(slices: slices, palette: palette),
    ),
    chart: PieChart(
      style: uiPieChartStyle(
        palette: palette,
        centerRadius: 44,
      ).slice(PieSliceStyler().radius(36)),
      semanticsLabel: 'Revenue contribution by channel',
      slices: slices,
      valueFormatter: (value) => '${value.toInt()}%',
    ),
  );
}

Widget _activityCard(UiDashboardSampleData data) => UiCard(
  size: .size2,
  child: ColumnBox(
    style: FlexBoxStyler().crossAxisAlignment(.stretch),
    children: [
      Box(
        style: BoxStyler().padding(.bottom(8)),
        child: const UiSectionLabel('Recent activity'),
      ),
      for (final (index, event) in data.activities.indexed) ...[
        RowBox(
          style: FlexBoxStyler()
              .padding(.symmetric(vertical: 11))
              .crossAxisAlignment(.center)
              .spacing(12),
          children: [
            _UiActivityIcon(kind: event.kind),
            Expanded(
              child: ColumnBox(
                style: FlexBoxStyler().crossAxisAlignment(.start).spacing(2),
                children: [
                  UiText(event.title, size: .size2, weight: .medium),
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
        if (index != data.activities.length - 1) const UiDivider(size: .size4),
      ],
    ],
  ),
);

class _UiActivityIcon extends StatelessWidget {
  const _UiActivityIcon({required this.kind});

  final UiDashboardActivityKind kind;

  @override
  Widget build(BuildContext context) {
    final (icon, accent) = switch (kind) {
      .customer => (RemixIcons.person, UiAccentColor.ceu),
      .order => (RemixIcons.box, UiAccentColor.ceu),
      .payment => (RemixIcons.checkCircled, UiAccentColor.serra),
      .alert => (RemixIcons.exclamationTriangle, UiAccentColor.sol),
    };

    return UiAccentScope(
      accent: accent,
      child: UiAvatar.soft(icon: icon, size: .size2),
    );
  }
}

Widget _ordersCard(UiDashboardSampleData data, VoidCallback? onViewOrders) =>
    UiCard(
      size: .size2,
      child: ColumnBox(
        style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(12),
        children: [
          RowBox(
            style: FlexBoxStyler().crossAxisAlignment(.center),
            children: [
              const Expanded(child: UiSectionLabel('Recent orders')),
              UiButton.ghost(
                key: const ValueKey('overview-view-orders'),
                size: .size1,
                label: 'View all',
                trailingIcon: RemixIcons.doubleArrowRight,
                onPressed: onViewOrders,
              ),
            ],
          ),
          UiDataTable<UiDashboardRecord>.surface(
            key: const ValueKey('dashboard-records-table'),
            semanticLabel: 'Recent orders',
            rows: data.records,
            minimumWidth: 400,
            columns: _recordColumns,
          ),
        ],
      ),
    );

LineSeries _revenueSeries(List<UiDashboardPoint> points) => LineSeries(
  id: 'revenue',
  label: 'Revenue',
  points: [
    for (final (index, point) in points.indexed)
      ChartPoint(id: point.label, x: index.toDouble(), y: point.value),
  ],
);

String _pointLabel(List<UiDashboardPoint> points, double value) {
  final index = value.round();
  return index >= 0 && index < points.length ? points[index].label : '';
}

final _recordColumns = <RemixDataTableColumn<UiDashboardRecord>>[
  RemixDataTableColumn(
    id: 'id',
    label: 'Order',
    width: const FixedColumnWidth(105),
    cellBuilder: (_, record) => UiDataTableCellText(record.id, primary: true),
  ),
  RemixDataTableColumn(
    id: 'customer',
    label: 'Customer',
    width: const FlexColumnWidth(2),
    cellBuilder: (_, record) => UiDataTableCellText(record.customer),
  ),
  RemixDataTableColumn(
    id: 'amount',
    label: 'Amount',
    width: const FixedColumnWidth(100),
    alignment: AlignmentDirectional.centerEnd,
    cellBuilder: (_, record) =>
        UiDataTableCellText(record.amount, primary: true),
  ),
  RemixDataTableColumn(
    id: 'status',
    label: 'Status',
    width: const FixedColumnWidth(94),
    cellBuilder: (_, record) => UiStatusBadge.label(record.status),
  ),
];
