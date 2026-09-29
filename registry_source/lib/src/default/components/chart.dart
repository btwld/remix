import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/scale.dart';
import '../theme/tokens.dart';

part 'chart.g.dart';

const _defaultPaletteToken = ContextToken<List<Color>>(
  resolveVanillaChartPalette,
);
const _tooltipBorderToken = ContextToken<BorderSide>(_resolveTooltipBorder);
const _tooltipRadiusToken = ContextToken<BorderRadius>(_resolveTooltipRadius);
const _tooltipPaddingToken = ContextToken<EdgeInsets>(_resolveTooltipPadding);
const _barRadiusToken = ContextToken<BorderRadius>(_resolveBarRadius);

/// Returns the categorical palette shared by this application's charts.
///
/// The colors are the theme's `chart1` through `chart5` tokens in series
/// order, so editing them in `VanillaThemeData` restyles every chart.
/// Pass `palette` to one recipe or generated widget for a local override.
List<Color> resolveVanillaChartPalette(BuildContext context) =>
    List<Color>.unmodifiable([
      for (final token in VanillaTokens.chart) token.resolve(context),
    ]);

/// The label color that reads on a pie slice filled with [slice].
///
/// The shipped palette is a gray ramp, so no one label color reads on every
/// slice: `background` vanishes on the lightest gray and `foreground` on the
/// darkest. This returns whichever of the two contrasts more with [slice].
///
/// Pie labels are off by default. A chart that turns them on sets each
/// slice's label color from this, next to the fill the slice is drawn in:
///
/// ```dart
/// final palette = resolveVanillaChartPalette(context);
///
/// PieSlice(
///   id: 'mobile',
///   label: 'Mobile',
///   value: 64,
///   style: PieSliceStyler().label(
///     TextStyler().color(vanillaPieSliceLabelColor(context, palette[0])),
///   ),
/// )
/// ```
Color vanillaPieSliceLabelColor(BuildContext context, Color slice) {
  final foreground = VanillaTokens.foreground.resolve(context);
  final background = VanillaTokens.background.resolve(context);

  return _contrast(foreground, slice) >= _contrast(background, slice)
      ? foreground
      : background;
}

/// WCAG contrast ratio between two opaque colors.
double _contrast(Color a, Color b) {
  final lighter = math.max(a.computeLuminance(), b.computeLuminance());
  final darker = math.min(a.computeLuminance(), b.computeLuminance());

  return (lighter + 0.05) / (darker + 0.05);
}

/// The application's line and area chart recipe.
///
/// `mix_chart` owns the data model, rendering, interaction, and semantics.
/// This file owns the palette, axes, grid, line, markers, and tooltip. Give the
/// generated [VanillaLineChart] a bounded height because charts have no
/// intrinsic height.
///
/// [style] merges last, so one call site can replace any part of the recipe.
@MixWidget(target: LineChart.new)
LineChartStyler vanillaLineChartStyle({
  bool showMarkers = false,
  List<Color>? palette,
  LineChartStyler style = const LineChartStyler.create(),
}) => LineChartStyler()
    .frame(_chartFrameStyle())
    .axis(_chartAxisStyle())
    .topAxis(_hiddenAxisStyle())
    .rightAxis(_hiddenAxisStyle())
    .grid(_chartGridStyle())
    .series(
      LineSeriesStyler()
          .curve(.curved)
          .smoothness(0.18)
          .preventCurveOvershooting(true)
          .roundStrokeCap(true)
          .roundStrokeJoin(true)
          .stroke(ChartStrokeStyler().width(_lineWidth))
          .marker(
            ChartMarkerStyler()
                .show(showMarkers)
                .radius(_markerRadius)
                .borderColor(VanillaTokens.background())
                .borderWidth(_markerBorderWidth),
          ),
    )
    .tooltip(_chartTooltipStyle())
    .merge(LineChartStyler.create(palette: _paletteProp(palette)))
    .merge(style);

/// The application's grouped, stacked, and floating bar chart recipe.
///
/// `mix_chart` owns the bar data and behavior. This recipe supplies the shared
/// visual treatment. Give the generated [VanillaBarChart] a bounded
/// height because charts have no intrinsic height.
///
/// [style] merges last, so one call site can replace any part of the recipe.
@MixWidget(target: BarChart.new)
BarChartStyler vanillaBarChartStyle({
  List<Color>? palette,
  BarChartStyler style = const BarChartStyler.create(),
}) => BarChartStyler()
    .frame(_chartFrameStyle())
    .axis(_chartAxisStyle())
    .topAxis(_hiddenAxisStyle())
    .rightAxis(_hiddenAxisStyle())
    .grid(_chartGridStyle())
    .bar(
      BarStyler.create(
        borderRadius: Prop.token(_barRadiusToken),
      ).width(_barWidth),
    )
    .groupSpacing(_barGroupSpacing)
    .barSpacing(_barSpacing)
    .tooltip(_chartTooltipStyle())
    .merge(BarChartStyler.create(palette: _paletteProp(palette)))
    .merge(style);

/// The application's pie and donut chart recipe.
///
/// A positive [centerRadius] creates a donut. Labels stay hidden by default;
/// a caller-owned legend keeps category names readable with any custom
/// palette. [showLabels] draws them in `background`, which a gray palette
/// cannot carry on every slice: pair it with [vanillaPieSliceLabelColor].
/// Give the generated [VanillaPieChart] a bounded width and height because
/// charts have no intrinsic size.
///
/// The pie does not scale to that box: mix_chart draws each slice 80px wide
/// whatever room it has, so a donut reaches [centerRadius] plus 80px and is
/// clipped in a box less than twice that. Set the ring to fit the box:
/// `style: PieChartStyler().slice(PieSliceStyler().radius(44))`.
///
/// [style] merges last, so one call site can replace any part of the recipe.
@MixWidget(target: PieChart.new)
PieChartStyler vanillaPieChartStyle({
  double centerRadius = 0,
  bool showLabels = false,
  List<Color>? palette,
  PieChartStyler style = const PieChartStyler.create(),
}) => PieChartStyler()
    .frame(_chartFrameStyle())
    .centerRadius(centerRadius)
    // The hole shows whatever the chart sits on. A page-colored hole would read
    // as a hole punched through a dark card, which is a step lighter than the
    // page.
    .centerColor(MixColors.transparent)
    .sliceSpacing(_sliceSpacing)
    .selectedSliceRadiusOffset(_selectedSliceOffset)
    .slice(
      PieSliceStyler()
          .showLabel(showLabels)
          .cornerRadius(_sliceRadius)
          .label(
            TextStyler()
                .style(VanillaTokens.textXs.mix())
                .fontWeight(FontWeight.w600)
                .color(VanillaTokens.background()),
          ),
    )
    .tooltip(_chartTooltipStyle())
    .merge(PieChartStyler.create(palette: _paletteProp(palette)))
    .merge(style);

/// Width of a line series.
const _lineWidth = 2.0;

/// Radius of an optional line marker.
const _markerRadius = 3.0;

/// Border that separates a line marker from the plot behind it.
const _markerBorderWidth = 2.0;

/// Width of each bar before a caller override.
const _barWidth = 16.0;

/// Space between bar groups.
const _barGroupSpacing = 12.0;

/// Space between bars in one group.
const _barSpacing = 6.0;

/// Gap between pie slices.
const _sliceSpacing = 2.0;

/// Extra radius applied to a selected pie slice.
const _selectedSliceOffset = 4.0;

/// Corner radius applied to each pie slice.
const _sliceRadius = 2.0;

/// Maximum corner radius for bars.
const _maxBarRadius = 4.0;

/// Maximum corner radius for the tooltip surface.
const _maxTooltipRadius = 12.0;

Prop<List<Color>> _paletteProp(List<Color>? palette) => palette == null
    ? Prop.token(_defaultPaletteToken)
    : Prop.value(List<Color>.unmodifiable(palette));

ChartFrameStyler _chartFrameStyle() => ChartFrameStyler()
    .backgroundColor(MixColors.transparent)
    .showBorder(false)
    .clip(true);

ChartAxisStyler _chartAxisStyle() => ChartAxisStyler()
    .showLabels(true)
    .label(
      TextStyler()
          .style(VanillaTokens.textXs.mix())
          .color(VanillaTokens.mutedForeground()),
    )
    .labelSpace(8)
    .fitInside(true)
    .fitInsideDistance(4)
    .drawBelowEverything(true);

ChartAxisStyler _hiddenAxisStyle() => ChartAxisStyler().showLabels(false);

ChartGridStyler _chartGridStyle() => ChartGridStyler()
    .show(true)
    .showHorizontal(true)
    .showVertical(false)
    .stroke(ChartStrokeStyler().color(VanillaTokens.border()).width(1));

ChartTooltipStyler _chartTooltipStyle() =>
    ChartTooltipStyler.create(
          border: Prop.token(_tooltipBorderToken),
          borderRadius: Prop.token(_tooltipRadiusToken),
          padding: Prop.token(_tooltipPaddingToken),
        )
        .backgroundColor(VanillaTokens.background())
        .margin(8)
        .maxWidth(280)
        .fitHorizontally(true)
        .fitVertically(true)
        .text(
          TextStyler()
              .style(VanillaTokens.textXs.mix())
              .fontWeight(FontWeight.w500)
              .color(VanillaTokens.foreground()),
        );

/// The tooltip's outline: `border` at half strength.
BorderSide _resolveTooltipBorder(BuildContext context) => BorderSide(
  color: _tooltipBorderColor.resolve(context),
  width: VanillaStroke.hairline,
);

final _tooltipBorderColor = vanillaTint(VanillaTokens.border, 0.5);

/// The tooltip's corners: `radiusLg`, at most 12px.
BorderRadius _resolveTooltipRadius(BuildContext context) => BorderRadius.all(
  _clampedThemeRadius(context, VanillaTokens.radiusLg, _maxTooltipRadius),
);

/// The tooltip's inset: 10px at the sides, 6px above and below.
EdgeInsets _resolveTooltipPadding(BuildContext context) =>
    const EdgeInsets.symmetric(
      horizontal: VanillaSpace.s2_5,
      vertical: VanillaSpace.s1_5,
    );

BorderRadius _resolveBarRadius(BuildContext context) => BorderRadius.all(
  _clampedThemeRadius(context, VanillaTokens.radiusMd, _maxBarRadius),
);

Radius _clampedThemeRadius(
  BuildContext context,
  RadiusToken step,
  double maximum,
) {
  final radius = step.resolve(context);

  return Radius.elliptical(
    math.min(radius.x, maximum),
    math.min(radius.y, maximum),
  );
}
