import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'dashboard_sample_data.dart';

typedef PlaygroundDashboardHeaderBuilder =
    Widget Function(BuildContext context, String title, String description);
typedef PlaygroundDashboardMetricBuilder =
    Widget Function(BuildContext context, PlaygroundDashboardMetric metric);
typedef PlaygroundDashboardDataBuilder =
    Widget Function(BuildContext context, PlaygroundDashboardSampleData data);

/// Preset-neutral responsive composition for the starter overview.
class PlaygroundDashboardOverviewBase extends StatelessWidget {
  const PlaygroundDashboardOverviewBase({
    super.key,
    required this.data,
    required this.headerBuilder,
    required this.metricBuilder,
    required this.chartBuilder,
    required this.tableBuilder,
    this.scrollController,
  });

  final PlaygroundDashboardSampleData data;
  final PlaygroundDashboardHeaderBuilder headerBuilder;
  final PlaygroundDashboardMetricBuilder metricBuilder;
  final PlaygroundDashboardDataBuilder chartBuilder;
  final PlaygroundDashboardDataBuilder tableBuilder;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.hasBoundedWidth ? constraints.maxWidth : 960.0;
      final compact = width < 600;
      final gap = compact ? 12.0 : 16.0;
      final padding = compact ? 16.0 : 24.0;
      final sectionGap = compact ? 20.0 : 24.0;
      final GridBoxStyler metricsStyle = .equalColumns(4)
          .gap(gap)
          .onConstraints(const .maxWidth(991), .equalColumns(2).gap(gap))
          .onConstraints(const .maxWidth(551), .equalColumns(1).gap(gap));

      return SingleChildScrollView(
        key: const ValueKey('dashboard-overview-scroll'),
        controller: scrollController,
        padding: EdgeInsets.all(padding),
        child: ColumnBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.stretch)
              .spacing(sectionGap),
          children: [
            headerBuilder(
              context,
              'Overview',
              'A snapshot of your workspace performance.',
            ),
            GridBox(
              key: const ValueKey('dashboard-metrics'),
              style: metricsStyle,
              children: [
                for (final metric in data.metrics)
                  metricBuilder(context, metric),
              ],
            ),
            chartBuilder(context, data),
            tableBuilder(context, data),
          ],
        ),
      );
    },
  );
}
