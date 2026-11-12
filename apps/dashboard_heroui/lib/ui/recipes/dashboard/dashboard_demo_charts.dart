import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';

/// Chart axis, style, and legend helpers shared by the dashboard overview.

/// A value axis on round steps, from [min] to [max], with half a step of room
/// at each end.
///
/// Give every chart one, with [max] a whole number of [interval]s: an axis
/// left to the data ends on the data's own extremes, and labels them beside
/// the nearest round step, where the two labels collide. The room keeps the
/// [min] and [max] labels on their gridlines: flush against the plot's edge,
/// the chart pulls an end label inward, off the value it names. The padded
/// bounds are not labels themselves.
ChartAxis uiDashboardNumericAxis({
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

/// A zero-inclusive value axis fitted to caller data, with about
/// [targetIntervals] round intervals and the same half-step padding as
/// [uiDashboardNumericAxis].
/// Empty or all-zero data uses the starter revenue axis (0–100 by 20).
ChartAxis uiDashboardDataAxis(
  Iterable<double> values, {
  int targetIntervals = 5,
}) {
  assert(targetIntervals > 0);
  var min = 0.0;
  var max = 0.0;
  for (final value in values) {
    min = math.min(min, value);
    max = math.max(max, value);
  }
  if (min == max) {
    return uiDashboardNumericAxis(max: 100, interval: 20);
  }

  final rawInterval = (max - min) / targetIntervals;
  final magnitude = math.pow(10, (math.log(rawInterval) / math.ln10).floor());
  final fraction = rawInterval / magnitude;
  final step = switch (fraction) {
    <= 1 => 1.0,
    <= 2 => 2.0,
    <= 2.5 => 2.5,
    <= 5 => 5.0,
    _ => 10.0,
  };
  final interval = step * magnitude;
  return uiDashboardNumericAxis(
    min: (min / interval).floor() * interval,
    max: (max / interval).ceil() * interval,
    interval: interval,
  );
}

/// The chart style for a [uiDashboardNumericAxis]: that axis already has
/// room past each end, so its value labels are left on their gridlines rather
/// than pulled inward to fit.
LineChartStyler uiDashboardLineStyle() =>
    LineChartStyler().yAxis(ChartAxisStyler().fitInside(false));

/// See [uiDashboardLineStyle].
BarChartStyler uiDashboardBarStyle() =>
    BarChartStyler().yAxis(ChartAxisStyler().fitInside(false));

/// One series or slice entry in a [UiChartLegend].
final class UiChartLegendItem {
  const UiChartLegendItem({
    required this.label,
    required this.color,
    this.detail,
  });

  /// The series or slice name.
  final String label;

  /// The swatch color.
  final ColorToken color;

  /// Secondary text after the label, such as a value or share.
  final String? detail;
}

/// Shared legend for multi-series and part-to-whole dashboard charts.
class UiChartLegend extends StatelessWidget {
  const UiChartLegend({
    super.key,
    required this.items,
    required this.labelStyle,
    required this.detailStyle,
  });

  /// The entries, in display order.
  final List<UiChartLegendItem> items;

  /// Style of each entry's label.
  final TextStyler labelStyle;

  /// Style of each entry's detail.
  final TextStyler detailStyle;

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
            Box(
              style: BoxStyler()
                  .size(10, 10)
                  .borderRadius(.circular(3))
                  .color(item.color()),
            ),
            StyledText(item.label, style: labelStyle),
            if (item.detail case final detail?)
              StyledText(detail, style: detailStyle),
          ],
        ),
    ],
  );
}
