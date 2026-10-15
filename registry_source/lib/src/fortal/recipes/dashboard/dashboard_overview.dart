import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../../dashboard/dashboard_demo_charts.dart';
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
    headerBuilder: (context, title, description) => ColumnBox(
      style: FlexBoxStyler().crossAxisAlignment(.start).spacing(6),
      children: [
        FortalText(title, size: .size7, weight: .bold),
        FortalText(description, size: .size2, highContrast: false),
      ],
    ),
    metricBuilder: (context, metric) => FortalCard.surface(
      size: .size2,
      child: ColumnBox(
        style: FlexBoxStyler().crossAxisAlignment(.start).spacing(6),
        children: [
          FortalText(metric.label, size: .size2, weight: .medium),
          FortalText(metric.value, size: .size6, weight: .bold),
          FortalText(metric.change, size: .size1, highContrast: false),
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
      children: [_activityCard(data), _ordersCard(data, onViewOrders)],
    ),
  );
}

Widget _revenueCard(RegistryDashboardSampleData data) => FortalCard.surface(
  size: .size2,
  child: ColumnBox(
    style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(16),
    children: [
      ColumnBox(
        style: FlexBoxStyler().crossAxisAlignment(.start).spacing(4),
        children: const [
          FortalText('Revenue trend', size: .size4, weight: .bold),
          FortalText(
            'Seven-day net revenue',
            size: .size2,
            highContrast: false,
          ),
        ],
      ),
      Box(
        key: const ValueKey('dashboard-revenue-chart'),
        style: BoxStyler().height(220),
        child: FortalLineChart(
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

Widget _customerChartCard() => FortalCard.surface(
  size: .size2,
  child: ColumnBox(
    style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(16),
    children: [
      ColumnBox(
        style: FlexBoxStyler().crossAxisAlignment(.start).spacing(4),
        children: const [
          FortalText('Customer acquisition', size: .size4, weight: .bold),
          FortalText(
            'New accounts by month',
            size: .size2,
            highContrast: false,
          ),
        ],
      ),
      Box(
        style: BoxStyler().height(220),
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
          yAxis: registryDashboardNumericAxis(max: 50),
          style: registryDashboardBarStyle(),
        ),
      ),
    ],
  ),
);

Widget _fulfillmentCard() => FortalCard.surface(
  size: .size2,
  child: ColumnBox(
    style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(16),
    children: [
      ColumnBox(
        style: FlexBoxStyler().crossAxisAlignment(.start).spacing(4),
        children: const [
          FortalText('Fulfillment mix', size: .size4, weight: .bold),
          FortalText('Current order status', size: .size2, highContrast: false),
        ],
      ),
      Box(
        style: BoxStyler().height(220),
        child: FortalPieChart(
          centerRadius: 44,
          // mix_chart draws each slice 80px wide in any box; this ring stops
          // the donut at 88px, 80% of the way to the edge of its 220px box.
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

Widget _activityCard(RegistryDashboardSampleData data) => FortalCard.surface(
  size: .size2,
  child: ColumnBox(
    style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(8),
    children: [
      const FortalText('Recent activity', size: .size4, weight: .bold),
      ColumnBox(
        style: FlexBoxStyler().crossAxisAlignment(.stretch),
        children: [
          for (final (index, event) in data.activities.indexed) ...[
            Box(
              style: BoxStyler().padding(.vertical(10)),
              child: RowBox(
                style: FlexBoxStyler().crossAxisAlignment(.center).spacing(10),
                children: [
                  const Icon(RemixIcons.activityLog, size: 16),
                  Expanded(
                    child: ColumnBox(
                      style: FlexBoxStyler()
                          .crossAxisAlignment(.start)
                          .spacing(2),
                      children: [
                        FortalText(event.title, size: .size2, weight: .medium),
                        FortalText(
                          event.detail,
                          size: .size1,
                          highContrast: false,
                        ),
                      ],
                    ),
                  ),
                  FortalText(
                    event.relativeTime,
                    size: .size1,
                    highContrast: false,
                  ),
                ],
              ),
            ),
            if (index != data.activities.length - 1) const FortalDivider(),
          ],
        ],
      ),
    ],
  ),
);

Widget _ordersCard(
  RegistryDashboardSampleData data,
  VoidCallback? onViewOrders,
) => FortalCard.surface(
  size: .size2,
  child: ColumnBox(
    style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(12),
    children: [
      RowBox(
        style: FlexBoxStyler().crossAxisAlignment(.center),
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
      FortalDataTable<RegistryDashboardRecord>.surface(
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
    cellBuilder: (_, record) => _cell(record.status),
  ),
  RemixDataTableColumn(
    id: 'amount',
    label: 'Amount',
    width: const FixedColumnWidth(96),
    alignment: AlignmentDirectional.centerEnd,
    cellBuilder: (_, record) => _cell(record.amount, emphasized: true),
  ),
];
