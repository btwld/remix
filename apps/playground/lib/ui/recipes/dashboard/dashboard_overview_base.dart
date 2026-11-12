import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'dashboard_sample_data.dart';

/// Builds the page heading from a [title] and [description].
typedef PlaygroundDashboardHeaderBuilder =
    Widget Function(BuildContext context, String title, String description);

/// Builds the card for one headline metric.
typedef PlaygroundDashboardMetricBuilder =
    Widget Function(BuildContext context, PlaygroundDashboardMetric metric);

/// Builds a section from the overview's sample data.
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

  /// The content the overview shows.
  final PlaygroundDashboardSampleData data;

  /// Builds the heading above the metrics.
  final PlaygroundDashboardHeaderBuilder headerBuilder;

  /// Builds each metric card in the metrics grid.
  final PlaygroundDashboardMetricBuilder metricBuilder;

  /// Builds the charts section.
  final PlaygroundDashboardDataBuilder chartBuilder;

  /// Builds the recent-records table section.
  final PlaygroundDashboardDataBuilder tableBuilder;

  /// Controls the page's vertical scroll position.
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final header = headerBuilder(
      context,
      'Overview',
      'A snapshot of your workspace performance.',
    );
    final metrics = [
      for (final metric in data.metrics) metricBuilder(context, metric),
    ];
    final charts = chartBuilder(context, data);
    final table = tableBuilder(context, data);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : 960.0;
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
              header,
              GridBox(
                key: const ValueKey('dashboard-metrics'),
                style: metricsStyle,
                children: metrics,
              ),
              charts,
              table,
            ],
          ),
        );
      },
    );
  }
}
