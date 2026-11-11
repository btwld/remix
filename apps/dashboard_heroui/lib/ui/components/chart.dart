import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'chart.g.dart';

/// The series colors of this application's charts, in series order.
///
/// An extension: HeroUI web 3.2.6 ships no chart and no chart colors, so the
/// ramp is built from tokens the theme already has. The first series is
/// `accent`; the next two step away from the card through neutrals, `muted`
/// then `foreground`, so each later series contrasts more with the `surface`
/// behind it in either mode. Status colors (`success`, `warning`, `danger`)
/// are left out because a series in them reads as a status.
///
/// Against `surface`, the first three keep at least 3:1 in both modes
/// (`accent` 3.7 light and 4.8 dark, `muted` 4.8 and 6.8, `foreground` 17.7
/// and 17.3). `accent` and `muted` are told apart by hue rather than
/// lightness. The fourth, `border-tertiary`, is fainter (2.4 and 2.7), so a
/// chart with more than three series should label its marks or pass its own
/// `palette`.
///
/// Each entry is a theme token, so a legend can name the same color its
/// series is drawn in.
const uiChartSeries = <ColorToken>[
  UiTokens.accent,
  UiTokens.muted,
  UiTokens.foreground,
  UiTokens.borderTertiary,
];

/// Returns [uiChartSeries] resolved in [context].
///
/// Pass `palette` to one recipe or generated widget for a local override.
List<Color> resolveUiChartPalette(BuildContext context) =>
    List<Color>.unmodifiable([
      for (final token in uiChartSeries) token.resolve(context),
    ]);

/// The label color that reads on a pie slice filled with [slice].
///
/// The ramp holds both a dark and a light neutral in either mode, so no one
/// label color reads on every slice. This returns whichever of `foreground`
/// and `surface` contrasts more with [slice].
///
/// Pie labels are off by default. A chart that turns them on sets each
/// slice's label color from this, next to the fill the slice is drawn in:
///
/// ```dart
/// final palette = resolveUiChartPalette(context);
///
/// PieSlice(
///   id: 'mobile',
///   label: 'Mobile',
///   value: 64,
///   style: PieSliceStyler().label(
///     TextStyler().color(uiPieSliceLabelColor(context, palette[0])),
///   ),
/// )
/// ```
Color uiPieSliceLabelColor(BuildContext context, Color slice) {
  final foreground = UiTokens.foreground.resolve(context);
  final surface = UiTokens.surface.resolve(context);

  return _contrast(foreground, slice) >= _contrast(surface, slice)
      ? foreground
      : surface;
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
/// This file owns the series colors, axes, grid, line, markers, and tooltip.
/// Give the generated [UiLineChart] a bounded height because charts have
/// no intrinsic height.
///
/// [style] merges last, so one call site can replace any part of the recipe.
@MixWidget(target: LineChart.new)
LineChartStyler uiLineChartStyle({
  bool showMarkers = false,
  List<Color>? palette,
  LineChartStyler style = const LineChartStyler.create(),
}) => LineChartStyler()
    .frame(_frameStyle())
    .axis(_axisStyle())
    .topAxis(_hiddenAxisStyle())
    .rightAxis(_hiddenAxisStyle())
    .grid(_gridStyle())
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
                // The ring matches the card the chart sits on.
                .borderColor(UiTokens.surface())
                .borderWidth(_markerBorderWidth),
          ),
    )
    .tooltip(_tooltipStyle())
    .merge(LineChartStyler.create(palette: _paletteProp(palette)))
    .merge(style);

/// The application's grouped, stacked, and floating bar chart recipe.
///
/// `mix_chart` owns the bar data and behavior. This recipe supplies the shared
/// visual treatment. Give the generated [UiBarChart] a bounded height
/// because charts have no intrinsic height.
///
/// [style] merges last, so one call site can replace any part of the recipe.
@MixWidget(target: BarChart.new)
BarChartStyler uiBarChartStyle({
  List<Color>? palette,
  BarChartStyler style = const BarChartStyler.create(),
}) => BarChartStyler()
    .frame(_frameStyle())
    .axis(_axisStyle())
    .topAxis(_hiddenAxisStyle())
    .rightAxis(_hiddenAxisStyle())
    .grid(_gridStyle())
    .bar(
      BarStyler.create(
        borderRadius: Prop.token(_barRadiusToken),
      ).width(_barWidth),
    )
    .groupSpacing(_barGroupSpacing)
    .barSpacing(_barSpacing)
    .tooltip(_tooltipStyle())
    .merge(BarChartStyler.create(palette: _paletteProp(palette)))
    .merge(style);

/// The application's pie and donut chart recipe.
///
/// A positive [centerRadius] creates a donut. Labels stay hidden by default;
/// a caller-owned legend keeps category names readable with any palette.
/// [showLabels] draws them in `surface`, which not every series of the ramp
/// can carry: pair it with [uiPieSliceLabelColor]. Give the generated
/// [UiPieChart] a bounded width and height because charts have no
/// intrinsic size.
///
/// The default slice radius is at most 80 logical pixels and shrinks to fit
/// the available box, accounting for the center hole and selection expansion.
/// An explicit `PieSliceStyler().radius(...)` keeps caller-controlled sizing.
///
/// [style] merges last, so one call site can replace any part of the recipe.
@MixWidget(target: PieChart.new)
PieChartStyler uiPieChartStyle({
  double centerRadius = 0,
  bool showLabels = false,
  List<Color>? palette,
  PieChartStyler style = const PieChartStyler.create(),
}) => PieChartStyler()
    .frame(_frameStyle())
    .centerRadius(centerRadius)
    // The hole shows whatever the chart sits on.
    .centerColor(UiTokens.transparent)
    .sliceSpacing(_sliceSpacing)
    .selectedSliceRadiusOffset(_selectedSliceOffset)
    .slice(
      PieSliceStyler()
          .showLabel(showLabels)
          .cornerRadius(_sliceRadius)
          .label(
            TextStyler()
                .style(UiTokens.textXs.mix())
                .fontWeight(.w600)
                .color(UiTokens.surface()),
          ),
    )
    .tooltip(_tooltipStyle())
    .merge(PieChartStyler.create(palette: _paletteProp(palette)))
    .merge(style);

/// Width of a line series.
const _lineWidth = 2.0;

/// Radius of an optional line marker.
const _markerRadius = 3.0;

/// Ring that separates a line marker from the plot behind it.
const _markerBorderWidth = 2.0;

/// Width of each bar before a caller override.
const _barWidth = 16.0;

/// Space between bar groups: `gap-3`.
const _barGroupSpacing = 12.0;

/// Space between bars in one group.
const _barSpacing = 6.0;

/// Gap between pie slices.
const _sliceSpacing = 2.0;

/// Extra radius applied to a selected pie slice.
const _selectedSliceOffset = 4.0;

/// Corner radius applied to each pie slice.
const _sliceRadius = 2.0;

/// The tooltip's padding and maximum width, as the `tooltip` recipe's
/// (`p-2`, `max-w-xs`).
const _tooltipPadding = 8.0;
const _tooltipMaxWidth = 320.0;

/// Distance between the tooltip and the mark it describes.
const _tooltipMargin = 8.0;

/// The tooltip's outline, standing in for the overlay shadow, which the chart
/// tooltip cannot draw.
const _tooltipBorderWidth = 1.0;

const _defaultPaletteToken = ContextToken<List<Color>>(resolveUiChartPalette);
const _tooltipBorderToken = ContextToken<BorderSide>(_resolveTooltipBorder);
const _tooltipRadiusToken = ContextToken<BorderRadius>(_resolveTooltipRadius);
const _barRadiusToken = ContextToken<BorderRadius>(_resolveBarRadius);

Prop<List<Color>> _paletteProp(List<Color>? palette) => palette == null
    ? Prop.token(_defaultPaletteToken)
    : Prop.value(List<Color>.unmodifiable(palette));

ChartFrameStyler _frameStyle() => ChartFrameStyler()
    .backgroundColor(UiTokens.transparent)
    .showBorder(false)
    .clip(true);

ChartAxisStyler _axisStyle() => ChartAxisStyler()
    .showLabels(true)
    .label(TextStyler().style(UiTokens.textXs.mix()).color(UiTokens.muted()))
    .labelSpace(8)
    .fitInside(true)
    .fitInsideDistance(4)
    .drawBelowEverything(true);

ChartAxisStyler _hiddenAxisStyle() => ChartAxisStyler().showLabels(false);

ChartGridStyler _gridStyle() => ChartGridStyler()
    .show(true)
    .showHorizontal(true)
    .showVertical(false)
    .stroke(ChartStrokeStyler().color(UiTokens.separator()).width(1));

ChartTooltipStyler _tooltipStyle() =>
    ChartTooltipStyler.create(
          border: Prop.token(_tooltipBorderToken),
          borderRadius: Prop.token(_tooltipRadiusToken),
        )
        .backgroundColor(UiTokens.overlay())
        .padding(const EdgeInsets.all(_tooltipPadding))
        .margin(_tooltipMargin)
        .maxWidth(_tooltipMaxWidth)
        .fitHorizontally(true)
        .fitVertically(true)
        .text(
          TextStyler()
              .style(UiTokens.textXs.mix())
              .fontWeight(.w500)
              .color(UiTokens.overlayForeground()),
        );

BorderSide _resolveTooltipBorder(BuildContext context) => BorderSide(
  color: UiTokens.border.resolve(context),
  width: _tooltipBorderWidth,
);

/// The `tooltip` recipe's corners: `min(32px, var(--radius-xl))`.
BorderRadius _resolveTooltipRadius(BuildContext context) =>
    BorderRadius.all(_cappedRadius(context, UiTokens.radiusXl, 32));

/// `radius-sm` on each bar corner.
BorderRadius _resolveBarRadius(BuildContext context) =>
    BorderRadius.all(UiTokens.radiusSm.resolve(context));

Radius _cappedRadius(BuildContext context, RadiusToken step, double maximum) {
  final radius = step.resolve(context);

  return Radius.elliptical(
    math.min(radius.x, maximum),
    math.min(radius.y, maximum),
  );
}
