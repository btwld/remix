import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'chart.g.dart';

const _defaultPaletteToken = ContextToken<List<Color>>(
  resolvePlaygroundChartPalette,
);
const _tooltipBorderToken = ContextToken<BorderSide>(_resolveTooltipBorder);
const _tooltipRadiusToken = ContextToken<BorderRadius>(_resolveTooltipRadius);
const _tooltipPaddingToken = ContextToken<EdgeInsets>(_resolveTooltipPadding);
const _barRadiusToken = ContextToken<BorderRadius>(_resolveBarRadius);

/// The categorical palette shared by the charts: the theme's `chart1` through
/// `chart5` in series order. Pass `palette` to one chart to override it.
List<Color> resolvePlaygroundChartPalette(BuildContext context) =>
    List<Color>.unmodifiable([
      for (final token in PlaygroundTokens.chart) token.resolve(context),
    ]);

/// Whichever of `foreground` and `background` contrasts more with [slice].
///
/// The shipped palette is a gray ramp, so no single label color reads on every
/// slice. Pie labels are off by default; a chart that turns them on sets each
/// slice's label color from this:
///
/// ```dart
/// final palette = resolvePlaygroundChartPalette(context);
///
/// PieSlice(
///   id: 'mobile',
///   label: 'Mobile',
///   value: 64,
///   style: PieSliceStyler().label(
///     TextStyler().color(playgroundPieSliceLabelColor(context, palette[0])),
///   ),
/// )
/// ```
Color playgroundPieSliceLabelColor(BuildContext context, Color slice) {
  final foreground = PlaygroundTokens.foreground.resolve(context);
  final background = PlaygroundTokens.background.resolve(context);

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
/// Give the generated [PlaygroundLineChart] a bounded height: charts have no
/// intrinsic height.
@MixWidget(target: LineChart.new)
LineChartStyler playgroundLineChartStyle({
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
          .stroke(ChartStrokeStyler().width(2))
          .marker(
            ChartMarkerStyler()
                .show(showMarkers)
                .radius(3)
                // Separates the marker from the line behind it.
                .borderColor(PlaygroundTokens.background())
                .borderWidth(2),
          ),
    )
    .tooltip(_chartTooltipStyle())
    .merge(LineChartStyler.create(palette: _paletteProp(palette)))
    .merge(style);

/// The application's grouped, stacked, and floating bar chart recipe.
///
/// Give the generated [PlaygroundBarChart] a bounded height.
@MixWidget(target: BarChart.new)
BarChartStyler playgroundBarChartStyle({
  List<Color>? palette,
  BarChartStyler style = const BarChartStyler.create(),
}) => BarChartStyler()
    .frame(_chartFrameStyle())
    .axis(_chartAxisStyle())
    .topAxis(_hiddenAxisStyle())
    .rightAxis(_hiddenAxisStyle())
    .grid(_chartGridStyle())
    .bar(BarStyler.create(borderRadius: Prop.token(_barRadiusToken)).width(16))
    .groupSpacing(12)
    .barSpacing(6)
    .tooltip(_chartTooltipStyle())
    .merge(BarChartStyler.create(palette: _paletteProp(palette)))
    .merge(style);

/// The application's pie and donut chart recipe.
///
/// A positive [centerRadius] makes a donut. Labels are hidden by default;
/// [showLabels] draws them in `background`, which a gray palette cannot carry
/// on every slice, so pair it with [playgroundPieSliceLabelColor]. Give the
/// generated [PlaygroundPieChart] a bounded width and height.
///
/// The default slice radius is at most 80px and shrinks to fit the box; an
/// explicit `PieSliceStyler().radius(...)` overrides it.
@MixWidget(target: PieChart.new)
PieChartStyler playgroundPieChartStyle({
  double centerRadius = 0,
  bool showLabels = false,
  List<Color>? palette,
  PieChartStyler style = const PieChartStyler.create(),
}) => PieChartStyler()
    .frame(_chartFrameStyle())
    .centerRadius(centerRadius)
    // Transparent: a page-colored hole would read as punched through a dark
    // card, which is a step lighter than the page.
    .centerColor(MixColors.transparent)
    .sliceSpacing(2)
    .selectedSliceRadiusOffset(4)
    .slice(
      PieSliceStyler()
          .showLabel(showLabels)
          .cornerRadius(2)
          .label(
            TextStyler()
                .style(PlaygroundTokens.textXs.mix())
                .fontWeight(FontWeight.w600)
                .color(PlaygroundTokens.background()),
          ),
    )
    .tooltip(_chartTooltipStyle())
    .merge(PieChartStyler.create(palette: _paletteProp(palette)))
    .merge(style);

/// The theme's radii are authored for 32-40px controls; they are clamped so a
/// pill radius does not round a bar or a tooltip into a capsule.
const _maxBarRadius = 4.0;
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
          .style(PlaygroundTokens.textXs.mix())
          .color(PlaygroundTokens.mutedForeground()),
    )
    .labelSpace(PlaygroundTokens.s2)
    .fitInside(true)
    .fitInsideDistance(PlaygroundTokens.s1)
    .drawBelowEverything(true);

ChartAxisStyler _hiddenAxisStyle() => ChartAxisStyler().showLabels(false);

ChartGridStyler _chartGridStyle() => ChartGridStyler()
    .show(true)
    .showHorizontal(true)
    .showVertical(false)
    .stroke(
      ChartStrokeStyler()
          .color(PlaygroundTokens.border())
          .width(PlaygroundTokens.strokeHairline),
    );

ChartTooltipStyler _chartTooltipStyle() =>
    ChartTooltipStyler.create(
          border: Prop.token(_tooltipBorderToken),
          borderRadius: Prop.token(_tooltipRadiusToken),
          padding: Prop.token(_tooltipPaddingToken),
        )
        .backgroundColor(PlaygroundTokens.background())
        .margin(PlaygroundTokens.s2)
        .maxWidth(280)
        .fitHorizontally(true)
        .fitVertically(true)
        .text(
          TextStyler()
              .style(PlaygroundTokens.textXs.mix())
              .fontWeight(FontWeight.w500)
              .color(PlaygroundTokens.foreground()),
        );

/// `border` at half strength.
BorderSide _resolveTooltipBorder(BuildContext context) => BorderSide(
  color: playgroundTint(PlaygroundTokens.border, 0.5).resolve(context),
  width: PlaygroundTokens.strokeHairline,
);

/// `radiusLg`, at most 12px.
BorderRadius _resolveTooltipRadius(BuildContext context) => BorderRadius.all(
  _clampedThemeRadius(context, PlaygroundTokens.radiusLg, _maxTooltipRadius),
);

/// 10px at the sides, 6px above and below.
EdgeInsets _resolveTooltipPadding(BuildContext context) =>
    const EdgeInsets.symmetric(
      horizontal: PlaygroundTokens.s2_5,
      vertical: PlaygroundTokens.s1_5,
    );

BorderRadius _resolveBarRadius(BuildContext context) => BorderRadius.all(
  _clampedThemeRadius(context, PlaygroundTokens.radiusMd, _maxBarRadius),
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
