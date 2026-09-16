import 'package:flutter/widgets.dart';

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
      final columns = switch (width) {
        >= 1040 => 4,
        >= 600 => 2,
        _ => 1,
      };
      final gap = compact ? 12.0 : 16.0;
      final padding = compact ? 16.0 : 24.0;
      final available = (width - (padding * 2)).clamp(0.0, double.infinity);
      final metricWidth = (available - (gap * (columns - 1))) / columns;

      return SingleChildScrollView(
        key: const ValueKey('dashboard-overview-scroll'),
        controller: scrollController,
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            headerBuilder(
              context,
              'Overview',
              'A snapshot of your workspace performance.',
            ),
            SizedBox(height: compact ? 20 : 24),
            Wrap(
              key: const ValueKey('dashboard-metrics'),
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final metric in data.metrics)
                  SizedBox(
                    width: metricWidth,
                    child: metricBuilder(context, metric),
                  ),
              ],
            ),
            SizedBox(height: compact ? 20 : 24),
            chartBuilder(context, data),
            SizedBox(height: compact ? 20 : 24),
            tableBuilder(context, data),
          ],
        ),
      );
    },
  );
}
