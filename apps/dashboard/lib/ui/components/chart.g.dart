// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal LineChart recipe, for a Mix line or area chart.
///
/// Generates [UiLineChart] through `mix_generator`. The plot remains
/// transparent so callers can compose it inside any surface.
class UiLineChart extends StatelessWidget {
  const UiLineChart({
    super.key,
    this.highContrast = false,
    this.showMarkers = false,
    this.palette,
    this.style = const LineChartStyler.create(),
    required this.series,
    this.xAxis,
    this.yAxis,
    this.topAxis,
    this.rightAxis,
    this.viewport,
    this.dataTransition = ChartDataTransition.none,
    this.selectedPoints = const {},
    this.onPointHover,
    this.onPointTap,
    this.onPointLongPress,
    this.tooltipBuilder,
    this.hitTestRadius = 10,
    this.mouseCursorResolver,
    this.valueFormatter,
    this.semanticsLabel,
    this.semanticsValue,
    this.excludeFromSemantics = false,
  });

  final bool highContrast;

  final bool showMarkers;

  final List<Color>? palette;

  final LineChartStyler style;

  final List<LineSeries> series;

  final ChartAxis? xAxis;

  final ChartAxis? yAxis;

  final ChartAxis? topAxis;

  final ChartAxis? rightAxis;

  final ChartViewport? viewport;

  final ChartDataTransition dataTransition;

  final Set<LinePointKey> selectedPoints;

  final ValueChanged<LineChartHit?>? onPointHover;

  final ValueChanged<LineChartHit>? onPointTap;

  final ValueChanged<LineChartHit>? onPointLongPress;

  final ChartTooltipBuilder? tooltipBuilder;

  final double hitTestRadius;

  final ChartMouseCursorResolver<LineChartHit>? mouseCursorResolver;

  final ChartAxisLabelFormatter? valueFormatter;

  final String? semanticsLabel;

  final String? semanticsValue;

  final bool excludeFromSemantics;

  @override
  Widget build(BuildContext _) {
    return LineChart(
      style: uiLineChartStyle(
        highContrast: highContrast,
        showMarkers: showMarkers,
        palette: palette,
        style: style,
      ),
      series: series,
      xAxis: xAxis,
      yAxis: yAxis,
      topAxis: topAxis,
      rightAxis: rightAxis,
      viewport: viewport,
      dataTransition: dataTransition,
      selectedPoints: selectedPoints,
      onPointHover: onPointHover,
      onPointTap: onPointTap,
      onPointLongPress: onPointLongPress,
      tooltipBuilder: tooltipBuilder,
      hitTestRadius: hitTestRadius,
      mouseCursorResolver: mouseCursorResolver,
      valueFormatter: valueFormatter,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
      excludeFromSemantics: excludeFromSemantics,
    );
  }
}

/// The Fortal BarChart recipe: grouped, stacked or floating bars.
///
/// Generates [UiBarChart] through `mix_generator`.
class UiBarChart extends StatelessWidget {
  const UiBarChart({
    super.key,
    this.highContrast = false,
    this.palette,
    this.style = const BarChartStyler.create(),
    required this.groups,
    this.xAxis,
    this.yAxis,
    this.topAxis,
    this.rightAxis,
    this.viewport,
    this.dataTransition = ChartDataTransition.none,
    this.selectedItems = const {},
    this.onBarHover,
    this.onBarTap,
    this.onBarLongPress,
    this.tooltipBuilder,
    this.hitTestPadding = const EdgeInsets.all(4),
    this.mouseCursorResolver,
    this.valueFormatter,
    this.semanticsLabel,
    this.semanticsValue,
    this.excludeFromSemantics = false,
  });

  final bool highContrast;

  final List<Color>? palette;

  final BarChartStyler style;

  final List<BarGroup> groups;

  final ChartAxis? xAxis;

  final ChartAxis? yAxis;

  final ChartAxis? topAxis;

  final ChartAxis? rightAxis;

  final ChartViewport? viewport;

  final ChartDataTransition dataTransition;

  final Set<BarSelectionKey> selectedItems;

  final ValueChanged<BarChartHit?>? onBarHover;

  final ValueChanged<BarChartHit>? onBarTap;

  final ValueChanged<BarChartHit>? onBarLongPress;

  final ChartTooltipBuilder? tooltipBuilder;

  final EdgeInsets hitTestPadding;

  final ChartMouseCursorResolver<BarChartHit>? mouseCursorResolver;

  final ChartAxisLabelFormatter? valueFormatter;

  final String? semanticsLabel;

  final String? semanticsValue;

  final bool excludeFromSemantics;

  @override
  Widget build(BuildContext _) {
    return BarChart(
      style: uiBarChartStyle(
        highContrast: highContrast,
        palette: palette,
        style: style,
      ),
      groups: groups,
      xAxis: xAxis,
      yAxis: yAxis,
      topAxis: topAxis,
      rightAxis: rightAxis,
      viewport: viewport,
      dataTransition: dataTransition,
      selectedItems: selectedItems,
      onBarHover: onBarHover,
      onBarTap: onBarTap,
      onBarLongPress: onBarLongPress,
      tooltipBuilder: tooltipBuilder,
      hitTestPadding: hitTestPadding,
      mouseCursorResolver: mouseCursorResolver,
      valueFormatter: valueFormatter,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
      excludeFromSemantics: excludeFromSemantics,
    );
  }
}

/// The Fortal PieChart recipe, for a Mix pie or donut chart.
///
/// A positive [centerRadius] renders a donut. Labels are hidden by default so
/// category names can be presented in a caller-owned legend without forcing
/// low-contrast text onto arbitrary categorical colors; with [showLabels], set
/// each slice's label color with [uiPieSliceLabelColor]. Generates
/// [UiPieChart] through `mix_generator`. For advanced chart-level geometry,
/// pass this recipe directly to [PieChart.style] and merge a [PieSliceStyler].
///
/// The default slice radius is at most 80 logical pixels and shrinks to fit
/// the available box, accounting for the center hole and selection expansion.
/// An explicit `PieSliceStyler().radius(...)` keeps caller-controlled sizing.
class UiPieChart extends StatelessWidget {
  const UiPieChart({
    super.key,
    this.highContrast = false,
    this.centerRadius = 0,
    this.showLabels = false,
    this.palette,
    this.style = const PieChartStyler.create(),
    required this.slices,
    this.dataTransition = ChartDataTransition.none,
    this.selectedSliceIds = const {},
    this.onSliceHover,
    this.onSliceTap,
    this.onSliceLongPress,
    this.tooltipBuilder,
    this.mouseCursorResolver,
    this.valueFormatter,
    this.semanticsLabel,
    this.semanticsValue,
    this.excludeFromSemantics = false,
  });

  final bool highContrast;

  final double centerRadius;

  final bool showLabels;

  final List<Color>? palette;

  final PieChartStyler style;

  final List<PieSlice> slices;

  final ChartDataTransition dataTransition;

  final Set<Object> selectedSliceIds;

  final ValueChanged<PieChartHit?>? onSliceHover;

  final ValueChanged<PieChartHit>? onSliceTap;

  final ValueChanged<PieChartHit>? onSliceLongPress;

  final ChartTooltipBuilder? tooltipBuilder;

  final ChartMouseCursorResolver<PieChartHit>? mouseCursorResolver;

  final ChartAxisLabelFormatter? valueFormatter;

  final String? semanticsLabel;

  final String? semanticsValue;

  final bool excludeFromSemantics;

  @override
  Widget build(BuildContext _) {
    return PieChart(
      style: uiPieChartStyle(
        highContrast: highContrast,
        centerRadius: centerRadius,
        showLabels: showLabels,
        palette: palette,
        style: style,
      ),
      slices: slices,
      dataTransition: dataTransition,
      selectedSliceIds: selectedSliceIds,
      onSliceHover: onSliceHover,
      onSliceTap: onSliceTap,
      onSliceLongPress: onSliceLongPress,
      tooltipBuilder: tooltipBuilder,
      mouseCursorResolver: mouseCursorResolver,
      valueFormatter: valueFormatter,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
      excludeFromSemantics: excludeFromSemantics,
    );
  }
}
