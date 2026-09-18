import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import 'dashboard_sample_data.dart';

enum RegistryDashboardChartSection {
  line(
    'Line & area',
    'Trends, comparisons, discontinuities, and scalable viewports.',
  ),
  bar(
    'Bar charts',
    'Grouped, stacked, floating, and tracked quantitative comparisons.',
  ),
  pie(
    'Pie & donut',
    'Part-to-whole views with interaction, badges, and safe empty states.',
  );

  const RegistryDashboardChartSection(this.label, this.description);
  final String label;
  final String description;
}

enum RegistryDashboardChartCase {
  revenueMomentum(
    RegistryDashboardChartSection.line,
    'Revenue momentum',
    'Area fill and markers preserve exact point values.',
  ),
  linePatterns(
    RegistryDashboardChartSection.line,
    'Per-series patterns',
    'Solid circles and dashed squares reinforce color differences.',
  ),
  stepGaps(
    RegistryDashboardChartSection.line,
    'Steps and gaps',
    'Missing values remain honest gaps instead of invented data.',
  ),
  viewportLabels(
    RegistryDashboardChartSection.line,
    'Viewport labels',
    'Labels stay readable while panning and zooming.',
  ),
  groupedBars(
    RegistryDashboardChartSection.bar,
    'Actual versus plan',
    'Grouped bars compare monthly performance with targets.',
  ),
  stackedBars(
    RegistryDashboardChartSection.bar,
    'Revenue mix',
    'Stacked segments expose composition and totals together.',
  ),
  floatingBars(
    RegistryDashboardChartSection.bar,
    'Floating changes',
    'Range bars encode gains and declines from a real baseline.',
  ),
  trackedBars(
    RegistryDashboardChartSection.bar,
    'Tracks and labels',
    'Visible tracks provide scale context before interaction.',
  ),
  trafficPie(
    RegistryDashboardChartSection.pie,
    'Traffic channels',
    'Legend-first labels keep the plot clean and easy to scan.',
  ),
  interactivePie(
    RegistryDashboardChartSection.pie,
    'Interactive product mix',
    'Selection expands one stable slice and preserves its ID.',
  ),
  badgePie(
    RegistryDashboardChartSection.pie,
    'Badge markers',
    'Ordinary widgets can annotate individual slices.',
  ),
  emptyPie(
    RegistryDashboardChartSection.pie,
    'Safe empty state',
    'Zero-value data produces an explicit, stable empty state.',
  );

  const RegistryDashboardChartCase(this.section, this.title, this.description);
  final RegistryDashboardChartSection section;
  final String title;
  final String description;
}

typedef RegistryDashboardChartBuilder =
    Widget Function(
      BuildContext context,
      RegistryDashboardChartCase chart,
      Object? selectedSlice,
      ValueChanged<Object?> onSliceSelected,
    );

typedef RegistryDashboardChartCardBuilder =
    Widget Function(String title, String description, Widget chart);

typedef RegistryDashboardChartSectionBuilder =
    Widget Function(String title, String description, List<Widget> cards);

/// Shared 12-case chart inventory and interactive selection state.
class RegistryDashboardCharts extends StatefulWidget {
  const RegistryDashboardCharts({
    super.key,
    required this.chartBuilder,
    required this.cardBuilder,
    required this.sectionBuilder,
  });

  final RegistryDashboardChartBuilder chartBuilder;
  final RegistryDashboardChartCardBuilder cardBuilder;
  final RegistryDashboardChartSectionBuilder sectionBuilder;

  @override
  State<RegistryDashboardCharts> createState() {
    return _RegistryDashboardChartsState();
  }
}

class _RegistryDashboardChartsState extends State<RegistryDashboardCharts> {
  Object? _selectedSlice = 'core';

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final (index, section)
          in RegistryDashboardChartSection.values.indexed) ...[
        if (index > 0) const SizedBox(height: 24),
        widget.sectionBuilder(section.label, section.description, [
          for (final chart in RegistryDashboardChartCase.values)
            if (chart.section == section)
              widget.cardBuilder(
                chart.title,
                chart.description,
                widget.chartBuilder(
                  context,
                  chart,
                  _selectedSlice,
                  (value) => setState(() => _selectedSlice = value),
                ),
              ),
        ]),
      ],
    ],
  );
}

List<ChartPoint> registryDashboardPoints(String id, List<double?> values) => [
  for (final (index, value) in values.indexed)
    ChartPoint(id: '$id-$index', x: index.toDouble(), y: value),
];

List<ChartPoint> registryDashboardRevenuePoints(
  RegistryDashboardSampleData data,
) => [
  for (final (index, point) in data.revenue.indexed)
    ChartPoint(id: point.label, x: index.toDouble(), y: point.value),
];

List<BarGroup> registryDashboardGroupedBars() =>
    _barGroups(const [32, 41, 37, 52, 48, 59], const [29, 36, 40, 45, 50, 54]);

List<BarGroup> registryDashboardStackedBars() {
  const product = <double>[21, 28, 25, 34, 31, 38];
  const services = <double>[11, 13, 12, 18, 17, 21];
  return [
    for (var index = 0; index < product.length; index++)
      BarGroup(
        id: 'stack-$index',
        label: registryDashboardMonths[index],
        bars: [
          BarValue(
            id: 'revenue',
            label: 'Revenue',
            toY: product[index] + services[index],
            segments: [
              BarSegment(
                id: 'product',
                label: 'Product',
                fromY: 0,
                toY: product[index],
              ),
              BarSegment(
                id: 'services',
                label: 'Services',
                fromY: product[index],
                toY: product[index] + services[index],
              ),
            ],
          ),
        ],
      ),
  ];
}

List<BarGroup> registryDashboardFloatingBars() {
  const ranges = [
    (12.0, 18.0),
    (18.0, 14.0),
    (14.0, 22.0),
    (22.0, 17.0),
    (17.0, 25.0),
    (25.0, 31.0),
  ];
  return [
    for (final (index, range) in ranges.indexed)
      BarGroup(
        id: 'floating-$index',
        label: registryDashboardMonths[index],
        bars: [
          BarValue(
            id: 'change',
            label: 'Change',
            fromY: range.$1,
            toY: range.$2,
          ),
        ],
      ),
  ];
}

List<BarGroup> registryDashboardTrackedBars() => [
  for (final (index, value) in const <double>[32, 41, 37, 52, 48, 59].indexed)
    BarGroup(
      id: 'tracked-$index',
      label: registryDashboardMonths[index],
      bars: [BarValue(id: 'tracked', label: 'Revenue', toY: value)],
    ),
];

List<PieSlice> registryDashboardChannelSlices({bool badges = false}) {
  const source = [
    ('mobile', 'Mobile', 46.0),
    ('desktop', 'Desktop', 31.0),
    ('tablet', 'Tablet', 15.0),
    ('other', 'Other', 8.0),
  ];
  const icons = [
    RemixIcons.mobile,
    RemixIcons.laptop,
    RemixIcons.dashboard,
    RemixIcons.activityLog,
  ];
  return [
    for (final (index, value) in source.indexed)
      PieSlice(
        id: value.$1,
        label: value.$2,
        value: value.$3,
        badge: badges ? Icon(icons[index], size: 16) : null,
      ),
  ];
}

List<PieSlice> registryDashboardProductSlices() => [
  PieSlice(id: 'core', label: 'Core', value: 54),
  PieSlice(id: 'teams', label: 'Teams', value: 27),
  PieSlice(id: 'enterprise', label: 'Enterprise', value: 19),
];

List<PieSlice> registryDashboardEmptySlices() => [
  PieSlice(id: 'empty', label: 'No data', value: 0),
];

ChartAxis registryDashboardWeekdayAxis() => ChartAxis.numeric(
  min: 0,
  max: 6,
  interval: 1,
  labelFormatter: (value) {
    final index = value.round();
    return index >= 0 && index < registryDashboardWeekdays.length
        ? registryDashboardWeekdays[index]
        : '';
  },
);

ChartAxis registryDashboardNumericAxis({double min = 0, double max = 70}) =>
    ChartAxis.numeric(min: min, max: max, interval: 10);

const registryDashboardWeekdays = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];
const registryDashboardMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

List<BarGroup> _barGroups(List<double> first, List<double> second) => [
  for (var index = 0; index < first.length; index++)
    BarGroup(
      id: 'month-$index',
      label: registryDashboardMonths[index],
      bars: [
        BarValue(id: 'actual', label: 'Actual', toY: first[index]),
        BarValue(id: 'plan', label: 'Plan', toY: second[index]),
      ],
    ),
];
