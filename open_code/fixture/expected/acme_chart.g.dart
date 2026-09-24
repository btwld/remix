// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's line and area chart recipe.
///
/// `mix_chart` owns the data model, rendering, interaction, and semantics.
/// This file owns the palette, axes, grid, line, markers, and tooltip. Give the
/// generated [AcmeLineChart] a bounded height because charts have no
/// intrinsic height.
///
/// [style] merges last, so one call site can replace any part of the recipe.
class AcmeLineChart extends StatelessWidget {
  const AcmeLineChart({
    super.key,
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
    this.semanticsLabel,
    this.semanticsValue,
    this.excludeFromSemantics = false,
  });

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

  final String? semanticsLabel;

  final String? semanticsValue;

  final bool excludeFromSemantics;

  @override
  Widget build(BuildContext _) {
    return LineChart(
      key: key,
      style: acmeLineChartStyle(
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
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
      excludeFromSemantics: excludeFromSemantics,
    );
  }
}

/// The application's grouped, stacked, and floating bar chart recipe.
///
/// `mix_chart` owns the bar data and behavior. This recipe supplies the shared
/// visual treatment. Give the generated [AcmeBarChart] a bounded
/// height because charts have no intrinsic height.
///
/// [style] merges last, so one call site can replace any part of the recipe.
class AcmeBarChart extends StatelessWidget {
  const AcmeBarChart({
    super.key,
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
    this.semanticsLabel,
    this.semanticsValue,
    this.excludeFromSemantics = false,
  });

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

  final String? semanticsLabel;

  final String? semanticsValue;

  final bool excludeFromSemantics;

  @override
  Widget build(BuildContext _) {
    return BarChart(
      key: key,
      style: acmeBarChartStyle(palette: palette, style: style),
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
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
      excludeFromSemantics: excludeFromSemantics,
    );
  }
}

/// The application's pie and donut chart recipe.
///
/// A positive [centerRadius] creates a donut. Labels stay hidden by default;
/// a caller-owned legend keeps category names readable with any custom
/// palette. Give the generated [AcmePieChart] a bounded width and
/// height because charts have no intrinsic size.
///
/// [style] merges last, so one call site can replace any part of the recipe.
class AcmePieChart extends StatelessWidget {
  const AcmePieChart({
    super.key,
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
      key: key,
      style: acmePieChartStyle(
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
