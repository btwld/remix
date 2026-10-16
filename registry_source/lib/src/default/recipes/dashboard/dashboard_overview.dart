import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../../dashboard/dashboard_demo_charts.dart';
import '../../../dashboard/dashboard_overview_base.dart';
import '../../../dashboard/dashboard_sample_data.dart';
import '../../components/badge.dart';
import '../../components/card.dart';
import '../../components/chart.dart';
import '../../components/data_table.dart';
import '../../components/button.dart';
import '../../components/divider.dart';
import '../../components/progress.dart';
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
      style: FlexBoxStyler()
          .crossAxisAlignment(.start)
          .spacing(VanillaTokens.s1_5),
      children: [
        StyledText(
          title,
          style: TextStyler()
              .style(VanillaTokens.text3xl.mix())
              .fontWeight(FontWeight.w700)
              .color(VanillaTokens.foreground()),
        ),
        StyledText(
          description,
          style: TextStyler()
              .style(VanillaTokens.textSm.mix())
              .color(VanillaTokens.mutedForeground()),
        ),
      ],
    ),
    metricBuilder: (context, metric) => VanillaCard(
      child: ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.stretch)
            .spacing(VanillaTokens.s2),
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
                      .style(VanillaTokens.textSm.mix())
                      .fontWeight(FontWeight.w500)
                      .color(VanillaTokens.mutedForeground()),
                ),
              ),
              if (metric.delta case final delta?)
                VanillaBadge(
                  variant: metric.positive ? .secondary : .outline,
                  child: RowBox(
                    style: FlexBoxStyler()
                        .mainAxisSize(.min)
                        .crossAxisAlignment(.center)
                        .spacing(VanillaTokens.s1),
                    children: [
                      StyledIcon(
                        icon: metric.positive
                            ? RemixIcons.chevronUp
                            : RemixIcons.chevronDown,
                        style: IconStyler()
                            .size(12)
                            .color(
                              metric.positive
                                  ? VanillaTokens.secondaryForeground()
                                  : VanillaTokens.foreground(),
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
                .style(VanillaTokens.text2xl.mix())
                .fontWeight(FontWeight.w700)
                .color(VanillaTokens.foreground()),
          ),
          if (metric.progress case final progress?)
            VanillaProgress(value: progress),
          StyledText(
            metric.change,
            style: TextStyler()
                .style(VanillaTokens.textXs.mix())
                .color(VanillaTokens.mutedForeground()),
          ),
        ],
      ),
    ),
    chartBuilder: (context, data) => GridBox(
      style: GridBoxStyler.equalColumns(3)
          .gap(VanillaTokens.s4)
          .onConstraints(
            const .maxWidth(759),
            .equalColumns(1).gap(VanillaTokens.s4),
          ),
      children: [_revenueCard(data), _customerChartCard(), _fulfillmentCard()],
    ),
    tableBuilder: (context, data) => GridBox(
      style: GridBoxStyler.equalColumns(2)
          .gap(VanillaTokens.s5)
          .onConstraints(
            const .maxWidth(899),
            .equalColumns(1).gap(VanillaTokens.s5),
          ),
      children: [_activityCard(data), _ordersCard(data, onViewOrders)],
    ),
  );
}

Widget _revenueCard(RegistryDashboardSampleData data) => VanillaCard(
  child: ColumnBox(
    style: FlexBoxStyler()
        .crossAxisAlignment(.stretch)
        .spacing(VanillaTokens.s4),
    children: [
      ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.start)
            .spacing(VanillaTokens.s1),
        children: [
          _sectionTitle('Revenue trend'),
          _sectionDescription('Seven-day net revenue'),
        ],
      ),
      Box(
        key: const ValueKey('dashboard-revenue-chart'),
        style: BoxStyler().height(220),
        child: VanillaLineChart(
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
          yAxis: registryDashboardNumericAxis(max: 100, interval: 20),
          style: registryDashboardLineStyle(),
        ),
      ),
    ],
  ),
);

Widget _customerChartCard() => VanillaCard(
  child: ColumnBox(
    style: FlexBoxStyler()
        .crossAxisAlignment(.stretch)
        .spacing(VanillaTokens.s4),
    children: [
      ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.start)
            .spacing(VanillaTokens.s1),
        children: [
          _sectionTitle('Customer acquisition'),
          _sectionDescription('New accounts by month'),
        ],
      ),
      Box(
        style: BoxStyler().height(220),
        child: VanillaBarChart(
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
          yAxis: registryDashboardNumericAxis(max: 50),
          style: registryDashboardBarStyle(),
        ),
      ),
    ],
  ),
);

Widget _fulfillmentCard() => VanillaCard(
  child: ColumnBox(
    style: FlexBoxStyler()
        .crossAxisAlignment(.stretch)
        .spacing(VanillaTokens.s3),
    children: [
      ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.start)
            .spacing(VanillaTokens.s1),
        children: [
          _sectionTitle('Fulfillment mix'),
          _sectionDescription('Current order status'),
        ],
      ),
      RegistryChartLegend(
        items: const [
          RegistryChartLegendItem(
            label: 'Fulfilled',
            detail: '72%',
            color: VanillaTokens.chart1,
          ),
          RegistryChartLegendItem(
            label: 'Processing',
            detail: '18%',
            color: VanillaTokens.chart2,
          ),
          RegistryChartLegendItem(
            label: 'Review',
            detail: '10%',
            color: VanillaTokens.chart3,
          ),
        ],
        labelStyle: TextStyler()
            .style(VanillaTokens.textXs.mix())
            .fontWeight(FontWeight.w500)
            .color(VanillaTokens.foreground()),
        detailStyle: TextStyler()
            .style(VanillaTokens.textXs.mix())
            .color(VanillaTokens.mutedForeground()),
      ),
      Box(
        style: BoxStyler().height(190),
        child: VanillaPieChart(
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

Widget _activityCard(RegistryDashboardSampleData data) => VanillaCard(
  child: ColumnBox(
    style: FlexBoxStyler()
        .crossAxisAlignment(.stretch)
        .spacing(VanillaTokens.s2),
    children: [
      _sectionTitle('Recent activity'),
      ColumnBox(
        style: FlexBoxStyler().crossAxisAlignment(.stretch),
        children: [
          for (final (index, event) in data.activities.indexed) ...[
            Box(
              style: BoxStyler().padding(.vertical(VanillaTokens.s2_5)),
              child: RowBox(
                style: FlexBoxStyler()
                    .crossAxisAlignment(.center)
                    .spacing(VanillaTokens.s2_5),
                children: [
                  Box(
                    style: BoxStyler()
                        .size(32, 32)
                        .alignment(.center)
                        .borderRadius(.all(VanillaTokens.radiusMd()))
                        .color(VanillaTokens.secondary()),
                    child: StyledIcon(
                      icon: _activityIcon(event.kind),
                      style: IconStyler()
                          .size(VanillaTokens.icon)
                          .color(VanillaTokens.secondaryForeground()),
                    ),
                  ),
                  Expanded(
                    child: ColumnBox(
                      style: FlexBoxStyler()
                          .crossAxisAlignment(.start)
                          .spacing(VanillaTokens.s0_5),
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
            if (index != data.activities.length - 1) const VanillaDivider(),
          ],
        ],
      ),
    ],
  ),
);

IconData _activityIcon(RegistryDashboardActivityKind kind) => switch (kind) {
  .customer => RemixIcons.person,
  .order => RemixIcons.box,
  .payment => RemixIcons.checkCircled,
  .alert => RemixIcons.exclamationTriangle,
};

Widget _ordersCard(
  RegistryDashboardSampleData data,
  VoidCallback? onViewOrders,
) => VanillaCard(
  child: ColumnBox(
    style: FlexBoxStyler()
        .crossAxisAlignment(.stretch)
        .spacing(VanillaTokens.s3),
    children: [
      RowBox(
        style: FlexBoxStyler().crossAxisAlignment(.center),
        children: [
          Expanded(child: _sectionTitle('Recent orders')),
          VanillaButton.ghost(
            key: const ValueKey('overview-view-orders'),
            size: .small,
            label: 'View all',
            trailingIcon: RemixIcons.doubleArrowRight,
            onPressed: onViewOrders,
          ),
        ],
      ),
      VanillaDataTable<RegistryDashboardRecord>(
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
      .style(VanillaTokens.textLg.mix())
      .fontWeight(FontWeight.w600)
      .color(VanillaTokens.foreground()),
);

Widget _sectionDescription(String text) => StyledText(
  text,
  style: TextStyler()
      .style(VanillaTokens.textSm.mix())
      .color(VanillaTokens.mutedForeground()),
);

Widget _cell(String text, {bool emphasized = false}) => StyledText(
  text,
  style: TextStyler()
      .style(VanillaTokens.textSm.mix())
      .fontWeight(emphasized ? FontWeight.w600 : FontWeight.w400)
      .color(VanillaTokens.foreground()),
);

Widget _statusBadge(String status) => switch (status.toLowerCase()) {
  'paid' || 'fulfilled' => VanillaBadge(label: status),
  'pending' || 'in review' => VanillaBadge.secondary(label: status),
  'cancelled' => VanillaBadge.destructive(label: status),
  _ => VanillaBadge.outline(label: status),
};

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
