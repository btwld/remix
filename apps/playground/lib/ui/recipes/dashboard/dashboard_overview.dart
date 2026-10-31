import 'package:flutter/widgets.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/badge.dart';
import '../../components/button.dart';
import '../../components/card.dart';
import '../../components/chart.dart';
import '../../components/data_table.dart';
import '../../components/divider.dart';
import '../../components/progress.dart';
import '../../theme/tokens.dart';
import 'dashboard_demo_charts.dart';
import 'dashboard_overview_base.dart';
import 'dashboard_sample_data.dart';

/// Revenue, orders, and recent activity.
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
    headerBuilder: (context, title, description) => ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.start)
          .spacing(PlaygroundTokens.s1_5),
      children: [
        StyledText(
          title,
          style: TextStyler()
              .style(PlaygroundTokens.text3xl.mix())
              .fontWeight(FontWeight.w700)
              .color(PlaygroundTokens.foreground()),
        ),
        StyledText(
          description,
          style: TextStyler()
              .style(PlaygroundTokens.textSm.mix())
              .color(PlaygroundTokens.mutedForeground()),
        ),
      ],
    ),
    metricBuilder: (context, metric) => PlaygroundCard(
      child: ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.stretch)
            .spacing(PlaygroundTokens.s2),
        children: [
          RowBox(
            style: FlexBoxStyler()
                .mainAxisAlignment(.spaceBetween)
                .crossAxisAlignment(.center),
            children: [
              Flexible(
                child: StyledText(
                  metric.label,
                  style: TextStyler()
                      .style(PlaygroundTokens.textSm.mix())
                      .fontWeight(FontWeight.w500)
                      .color(PlaygroundTokens.mutedForeground()),
                ),
              ),
              if (metric.delta case final delta?)
                PlaygroundBadge(
                  variant: metric.positive ? .secondary : .outline,
                  child: RowBox(
                    style: FlexBoxStyler()
                        .mainAxisSize(.min)
                        .crossAxisAlignment(.center)
                        .spacing(PlaygroundTokens.s1),
                    children: [
                      StyledIcon(
                        icon: metric.positive
                            ? RemixIcons.chevronUp
                            : RemixIcons.chevronDown,
                        style: IconStyler()
                            .size(12)
                            .color(
                              metric.positive
                                  ? PlaygroundTokens.secondaryForeground()
                                  : PlaygroundTokens.foreground(),
                            ),
                      ),
                      StyledText(delta),
                    ],
                  ),
                ),
            ],
          ),
          StyledText(
            metric.value,
            style: TextStyler()
                .style(PlaygroundTokens.text2xl.mix())
                .fontWeight(FontWeight.w700)
                .color(PlaygroundTokens.foreground()),
          ),
          if (metric.progress case final progress?)
            PlaygroundProgress(value: progress),
          StyledText(
            metric.change,
            style: TextStyler()
                .style(PlaygroundTokens.textXs.mix())
                .color(PlaygroundTokens.mutedForeground()),
          ),
        ],
      ),
    ),
    chartBuilder: (context, data) => GridBox(
      style: GridBoxStyler.equalColumns(3)
          .gap(PlaygroundTokens.s4)
          .onConstraints(
            const .maxWidth(759),
            .equalColumns(1).gap(PlaygroundTokens.s4),
          ),
      children: [_revenueCard(data), _customerChartCard(), _fulfillmentCard()],
    ),
    tableBuilder: (context, data) => GridBox(
      style: GridBoxStyler.equalColumns(2)
          .gap(PlaygroundTokens.s5)
          .onConstraints(
            const .maxWidth(899),
            .equalColumns(1).gap(PlaygroundTokens.s5),
          ),
      children: [_activityCard(data), _ordersCard(data, onViewOrders)],
    ),
  );
}

Widget _revenueCard(PlaygroundDashboardSampleData data) => PlaygroundCard(
  child: ColumnBox(
    style: FlexBoxStyler()
        .crossAxisAlignment(.stretch)
        .spacing(PlaygroundTokens.s4),
    children: [
      ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.start)
            .spacing(PlaygroundTokens.s1),
        children: [
          _sectionTitle('Revenue trend'),
          _sectionDescription('Seven-day net revenue'),
        ],
      ),
      Box(
        key: const ValueKey('dashboard-revenue-chart'),
        style: BoxStyler().height(220),
        child: PlaygroundLineChart(
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
          yAxis: playgroundDashboardNumericAxis(max: 100, interval: 20),
          style: playgroundDashboardLineStyle(),
        ),
      ),
    ],
  ),
);

Widget _customerChartCard() => PlaygroundCard(
  child: ColumnBox(
    style: FlexBoxStyler()
        .crossAxisAlignment(.stretch)
        .spacing(PlaygroundTokens.s4),
    children: [
      ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.start)
            .spacing(PlaygroundTokens.s1),
        children: [
          _sectionTitle('Customer acquisition'),
          _sectionDescription('New accounts by month'),
        ],
      ),
      Box(
        style: BoxStyler().height(220),
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
          // Customers peak at 44; see the revenue chart above for why the
          // maximum is pinned to a whole number of intervals.
          yAxis: playgroundDashboardNumericAxis(max: 50),
          style: playgroundDashboardBarStyle(),
        ),
      ),
    ],
  ),
);

Widget _fulfillmentCard() => PlaygroundCard(
  child: ColumnBox(
    style: FlexBoxStyler()
        .crossAxisAlignment(.stretch)
        .spacing(PlaygroundTokens.s3),
    children: [
      ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.start)
            .spacing(PlaygroundTokens.s1),
        children: [
          _sectionTitle('Fulfillment mix'),
          _sectionDescription('Current order status'),
        ],
      ),
      PlaygroundChartLegend(
        items: const [
          PlaygroundChartLegendItem(
            label: 'Fulfilled',
            detail: '72%',
            color: PlaygroundTokens.chart1,
          ),
          PlaygroundChartLegendItem(
            label: 'Processing',
            detail: '18%',
            color: PlaygroundTokens.chart2,
          ),
          PlaygroundChartLegendItem(
            label: 'Review',
            detail: '10%',
            color: PlaygroundTokens.chart3,
          ),
        ],
        labelStyle: TextStyler()
            .style(PlaygroundTokens.textXs.mix())
            .fontWeight(FontWeight.w500)
            .color(PlaygroundTokens.foreground()),
        detailStyle: TextStyler()
            .style(PlaygroundTokens.textXs.mix())
            .color(PlaygroundTokens.mutedForeground()),
      ),
      Box(
        style: BoxStyler().height(190),
        child: PlaygroundPieChart(
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
  ),
);

Widget _activityCard(PlaygroundDashboardSampleData data) => PlaygroundCard(
  child: ColumnBox(
    style: FlexBoxStyler()
        .crossAxisAlignment(.stretch)
        .spacing(PlaygroundTokens.s2),
    children: [
      _sectionTitle('Recent activity'),
      ColumnBox(
        style: FlexBoxStyler().crossAxisAlignment(.stretch),
        children: [
          for (final (index, event) in data.activities.indexed) ...[
            Box(
              style: BoxStyler().padding(.vertical(PlaygroundTokens.s2_5)),
              child: RowBox(
                style: FlexBoxStyler()
                    .crossAxisAlignment(.center)
                    .spacing(PlaygroundTokens.s2_5),
                children: [
                  Box(
                    style: BoxStyler()
                        .size(32, 32)
                        .alignment(.center)
                        .borderRadius(.all(PlaygroundTokens.radiusMd()))
                        .color(PlaygroundTokens.secondary()),
                    child: StyledIcon(
                      icon: _activityIcon(event.kind),
                      style: IconStyler()
                          .size(PlaygroundTokens.icon)
                          .color(PlaygroundTokens.secondaryForeground()),
                    ),
                  ),
                  Expanded(
                    child: ColumnBox(
                      style: FlexBoxStyler()
                          .crossAxisAlignment(.start)
                          .spacing(PlaygroundTokens.s0_5),
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
    ],
  ),
);

IconData _activityIcon(PlaygroundDashboardActivityKind kind) => switch (kind) {
  .customer => RemixIcons.user,
  .order => LucideIcons.box,
  .payment => LucideIcons.circleCheck,
  .alert => RemixIcons.warning,
};

Widget _ordersCard(
  PlaygroundDashboardSampleData data,
  VoidCallback? onViewOrders,
) => PlaygroundCard(
  child: ColumnBox(
    style: FlexBoxStyler()
        .crossAxisAlignment(.stretch)
        .spacing(PlaygroundTokens.s3),
    children: [
      RowBox(
        style: FlexBoxStyler().crossAxisAlignment(.center),
        children: [
          Expanded(child: _sectionTitle('Recent orders')),
          PlaygroundButton.ghost(
            key: const ValueKey('overview-view-orders'),
            size: .small,
            label: 'View all',
            trailingIcon: LucideIcons.chevronsRight,
            onPressed: onViewOrders,
          ),
        ],
      ),
      PlaygroundDataTable<PlaygroundDashboardRecord>(
        key: const ValueKey('dashboard-records-table'),
        semanticLabel: 'Recent customer orders',
        rows: data.records,
        // Fits the half-width card at a 1280px desktop with the sidebar open;
        // narrower than this, the table scrolls sideways.
        minimumWidth: 400,
        columns: _recordColumns,
      ),
    ],
  ),
);

Widget _sectionTitle(String text) => StyledText(
  text,
  style: TextStyler()
      .style(PlaygroundTokens.textLg.mix())
      .fontWeight(FontWeight.w600)
      .color(PlaygroundTokens.foreground()),
);

Widget _sectionDescription(String text) => StyledText(
  text,
  style: TextStyler()
      .style(PlaygroundTokens.textSm.mix())
      .color(PlaygroundTokens.mutedForeground()),
);

Widget _cell(String text, {bool emphasized = false}) => StyledText(
  text,
  style: TextStyler()
      .style(PlaygroundTokens.textSm.mix())
      .fontWeight(emphasized ? FontWeight.w600 : FontWeight.w400)
      .color(PlaygroundTokens.foreground()),
);

Widget _statusBadge(String status) => switch (status.toLowerCase()) {
  'paid' || 'fulfilled' => PlaygroundBadge(label: status),
  'pending' || 'in review' => PlaygroundBadge.secondary(label: status),
  'cancelled' => PlaygroundBadge.destructive(label: status),
  _ => PlaygroundBadge.outline(label: status),
};

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
    width: const FixedColumnWidth(96),
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
    cellBuilder: (_, record) => _statusBadge(record.status),
  ),
  RemixDataTableColumn(
    id: 'amount',
    label: 'Amount',
    width: const FixedColumnWidth(96),
    alignment: AlignmentDirectional.centerEnd,
    cellBuilder: (_, record) => _cell(record.amount, emphasized: true),
  ),
];
