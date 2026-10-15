import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import 'dashboard_sample_data.dart';

enum PlaygroundDashboardChartSection {
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

  const PlaygroundDashboardChartSection(this.label, this.description);
  final String label;
  final String description;
}

enum PlaygroundDashboardChartCase {
  revenueMomentum(
    PlaygroundDashboardChartSection.line,
    'Revenue momentum',
    'Area fill and markers preserve exact point values.',
  ),
  linePatterns(
    PlaygroundDashboardChartSection.line,
    'Per-series patterns',
    'Solid circles and dashed squares reinforce color differences.',
  ),
  stepGaps(
    PlaygroundDashboardChartSection.line,
    'Steps and gaps',
    'Missing values remain honest gaps instead of invented data.',
  ),
  viewportLabels(
    PlaygroundDashboardChartSection.line,
    'Viewport labels',
    'Labels stay readable while panning and zooming.',
  ),
  groupedBars(
    PlaygroundDashboardChartSection.bar,
    'Actual versus plan',
    'Grouped bars compare monthly performance with targets.',
  ),
  stackedBars(
    PlaygroundDashboardChartSection.bar,
    'Revenue mix',
    'Stacked segments expose composition and totals together.',
  ),
  floatingBars(
    PlaygroundDashboardChartSection.bar,
    'Floating changes',
    'Range bars encode gains and declines from a real baseline.',
  ),
  trackedBars(
    PlaygroundDashboardChartSection.bar,
    'Tracks and labels',
    'Visible tracks provide scale context before interaction.',
  ),
  trafficPie(
    PlaygroundDashboardChartSection.pie,
    'Traffic channels',
    'Legend-first labels keep the plot clean and easy to scan.',
  ),
  interactivePie(
    PlaygroundDashboardChartSection.pie,
    'Interactive product mix',
    'Selection expands one stable slice and preserves its ID.',
  ),
  badgePie(
    PlaygroundDashboardChartSection.pie,
    'Badge markers',
    'Ordinary widgets can annotate individual slices.',
  ),
  emptyPie(
    PlaygroundDashboardChartSection.pie,
    'Safe empty state',
    'Zero-value data produces an explicit, stable empty state.',
  );

  const PlaygroundDashboardChartCase(
    this.section,
    this.title,
    this.description,
  );
  final PlaygroundDashboardChartSection section;
  final String title;
  final String description;
}

typedef PlaygroundDashboardChartBuilder =
    Widget Function(
      BuildContext context,
      PlaygroundDashboardChartCase chart,
      Object? selectedSlice,
      ValueChanged<Object?> onSliceSelected,
    );

typedef PlaygroundDashboardChartLegendBuilder =
    Widget? Function(BuildContext context, PlaygroundDashboardChartCase chart);

typedef PlaygroundDashboardChartCardBuilder =
    Widget Function(
      String title,
      String description,
      Widget chart, {
      Widget? legend,
    });

typedef PlaygroundDashboardChartSectionBuilder =
    Widget Function(String title, String description, List<Widget> cards);

/// Shared 12-case chart inventory and interactive selection state.
class PlaygroundDashboardCharts extends StatefulWidget {
  const PlaygroundDashboardCharts({
    super.key,
    required this.chartBuilder,
    required this.cardBuilder,
    required this.sectionBuilder,
    this.legendBuilder,
  });

  final PlaygroundDashboardChartBuilder chartBuilder;
  final PlaygroundDashboardChartCardBuilder cardBuilder;
  final PlaygroundDashboardChartSectionBuilder sectionBuilder;
  final PlaygroundDashboardChartLegendBuilder? legendBuilder;

  @override
  State<PlaygroundDashboardCharts> createState() {
    return _PlaygroundDashboardChartsState();
  }
}

class _PlaygroundDashboardChartsState extends State<PlaygroundDashboardCharts> {
  Object? _selectedSlice = 'core';

  @override
  Widget build(BuildContext context) => ColumnBox(
    style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(24),
    children: [
      for (final section in PlaygroundDashboardChartSection.values)
        widget.sectionBuilder(section.label, section.description, [
          for (final chart in PlaygroundDashboardChartCase.values)
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
                legend: widget.legendBuilder?.call(context, chart),
              ),
        ]),
    ],
  );
}

List<ChartPoint> playgroundDashboardPoints(String id, List<double?> values) => [
  for (final (index, value) in values.indexed)
    ChartPoint(id: '$id-$index', x: index.toDouble(), y: value),
];

List<ChartPoint> playgroundDashboardRevenuePoints(
  PlaygroundDashboardSampleData data,
) => [
  for (final (index, point) in data.revenue.indexed)
    ChartPoint(id: point.label, x: index.toDouble(), y: point.value),
];

List<BarGroup> playgroundDashboardGroupedBars([List<Color>? palette]) =>
    _barGroups(
      const [32, 41, 37, 52, 48, 59],
      const [29, 36, 40, 45, 50, 54],
      palette: palette,
    );

List<BarGroup> playgroundDashboardStackedBars() {
  const product = <double>[21, 28, 25, 34, 31, 38];
  const services = <double>[11, 13, 12, 18, 17, 21];
  return [
    for (var index = 0; index < product.length; index++)
      BarGroup(
        id: 'stack-$index',
        label: playgroundDashboardMonths[index],
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

List<BarGroup> playgroundDashboardFloatingBars() {
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
        label: playgroundDashboardMonths[index],
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

List<BarGroup> playgroundDashboardTrackedBars() => [
  for (final (index, value) in const <double>[32, 41, 37, 52, 48, 59].indexed)
    BarGroup(
      id: 'tracked-$index',
      label: playgroundDashboardMonths[index],
      bars: [BarValue(id: 'tracked', label: 'Revenue', toY: value)],
    ),
];

List<PieSlice> playgroundDashboardChannelSlices({bool badges = false}) {
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

List<PieSlice> playgroundDashboardProductSlices() => [
  PieSlice(id: 'core', label: 'Core', value: 54),
  PieSlice(id: 'teams', label: 'Teams', value: 27),
  PieSlice(id: 'enterprise', label: 'Enterprise', value: 19),
];

List<PieSlice> playgroundDashboardEmptySlices() => [
  PieSlice(id: 'empty', label: 'No data', value: 0),
];

/// Monday through Sunday, with half a day of room at each end.
///
/// The room keeps the first and last labels and markers off the plot's edges:
/// flush against an edge, a marker is cut in half and a label is pushed inward
/// into its neighbor. The two bounds are not labels themselves.
ChartAxis playgroundDashboardWeekdayAxis() => ChartAxis.numeric(
  min: -0.5,
  max: 6.5,
  interval: 1,
  minIncluded: false,
  maxIncluded: false,
  labelFormatter: playgroundDashboardWeekdayLabel,
);

String playgroundDashboardWeekdayLabel(double value) {
  final index = value.round();
  return index >= 0 && index < playgroundDashboardWeekdays.length
      ? playgroundDashboardWeekdays[index]
      : '';
}

/// A value axis on round steps, from [min] to [max], with half a step of room
/// at each end.
///
/// Give every chart one, with [max] a whole number of [interval]s: an axis
/// left to the data ends on the data's own extremes, and labels them beside
/// the nearest round step, where the two labels collide. The room keeps the
/// [min] and [max] labels on their gridlines: flush against the plot's edge,
/// the chart pulls an end label inward, off the value it names. The padded
/// bounds are not labels themselves.
ChartAxis playgroundDashboardNumericAxis({
  double min = 0,
  double max = 70,
  double interval = 10,
}) => ChartAxis.numeric(
  min: min - interval / 2,
  max: max + interval / 2,
  interval: interval,
  minIncluded: false,
  maxIncluded: false,
);

/// The chart style for a [playgroundDashboardNumericAxis]: that axis already has
/// room past each end, so its value labels are left on their gridlines rather
/// than pulled inward to fit.
LineChartStyler playgroundDashboardLineStyle() =>
    LineChartStyler().yAxis(ChartAxisStyler().fitInside(false));

/// See [playgroundDashboardLineStyle].
BarChartStyler playgroundDashboardBarStyle() =>
    BarChartStyler().yAxis(ChartAxisStyler().fitInside(false));

const playgroundDashboardWeekdays = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];
const playgroundDashboardMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

List<BarGroup> _barGroups(
  List<double> first,
  List<double> second, {
  List<Color>? palette,
}) => [
  for (var index = 0; index < first.length; index++)
    BarGroup(
      id: 'month-$index',
      label: playgroundDashboardMonths[index],
      bars: [
        BarValue(
          id: 'actual',
          label: 'Actual',
          toY: first[index],
          style: palette != null && palette.isNotEmpty
              ? BarStyler().color(palette[0])
              : null,
        ),
        BarValue(
          id: 'plan',
          label: 'Plan',
          toY: second[index],
          style: palette != null && palette.length > 1
              ? BarStyler()
                    .color(palette[1].withValues(alpha: 0.22))
                    .border(BorderSide(color: palette[1], width: 2))
                    .borderDashArray([4, 3])
              : null,
        ),
      ],
    ),
];

/// Visual encoding for a [PlaygroundChartLegend] swatch.
enum PlaygroundChartSwatchPattern { solid, dashed, outlined, dot }

/// One series or slice entry in a [PlaygroundChartLegend].
final class PlaygroundChartLegendItem {
  const PlaygroundChartLegendItem({
    required this.label,
    required this.color,
    this.detail,
    this.pattern = .solid,
  });

  final String label;
  final ColorToken color;
  final String? detail;
  final PlaygroundChartSwatchPattern pattern;
}

/// Shared legend for multi-series and part-to-whole dashboard charts.
class PlaygroundChartLegend extends StatelessWidget {
  const PlaygroundChartLegend({
    super.key,
    required this.items,
    required this.labelStyle,
    required this.detailStyle,
    required this.outlineBorderColor,
  });

  final List<PlaygroundChartLegendItem> items;
  final TextStyler labelStyle;
  final TextStyler detailStyle;
  final ColorToken outlineBorderColor;

  @override
  Widget build(BuildContext context) => WrapBox(
    style: WrapBoxStyler()
        .spacing(16)
        .runSpacing(8)
        .crossAxisAlignment(.center),
    children: [
      for (final item in items)
        RowBox(
          style: FlexBoxStyler()
              .mainAxisSize(.min)
              .crossAxisAlignment(.center)
              .spacing(6),
          children: [
            _PlaygroundLegendSwatch(
              item: item,
              outlineBorderColor: outlineBorderColor,
            ),
            StyledText(item.label, style: labelStyle),
            if (item.detail case final detail?)
              StyledText(detail, style: detailStyle),
          ],
        ),
    ],
  );
}

class _PlaygroundLegendSwatch extends StatelessWidget {
  const _PlaygroundLegendSwatch({
    required this.item,
    required this.outlineBorderColor,
  });

  final PlaygroundChartLegendItem item;
  final ColorToken outlineBorderColor;

  @override
  Widget build(BuildContext context) => switch (item.pattern) {
    .solid => Box(
      style: BoxStyler()
          .size(10, 10)
          .borderRadius(.circular(3))
          .color(item.color()),
    ),
    .dot => Box(
      style: BoxStyler()
          .size(10, 10)
          .borderRadius(.circular(99))
          .color(item.color()),
    ),
    .outlined => Box(
      style: BoxStyler()
          .size(10, 10)
          .borderRadius(.circular(3))
          .color(item.color())
          .border(.color(outlineBorderColor()).width(1)),
    ),
    .dashed => RowBox(
      style: FlexBoxStyler()
          .mainAxisSize(.min)
          .crossAxisAlignment(.center)
          .spacing(2),
      children: [
        for (var index = 0; index < 2; index++)
          Box(
            style: BoxStyler()
                .width(5)
                .height(2.5)
                .borderRadius(.circular(99))
                .color(item.color()),
          ),
      ],
    ),
  };
}
