import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';

import '../theme/fortal_colors.dart';
import '../theme/palette.dart';
import '../theme/theme.dart';

part 'chart.g.dart';

const _standardPaletteToken = ContextToken<List<Color>>(
  _resolveStandardPalette,
);
const _highContrastPaletteToken = ContextToken<List<Color>>(
  _resolveHighContrastPalette,
);
const _tooltipBorderToken = ContextToken<BorderSide>(_resolveTooltipBorder);
const _tooltipRadiusToken = ContextToken<BorderRadius>(_resolveTooltipRadius);
const _tooltipPaddingToken = ContextToken<EdgeInsets>(_resolveTooltipPadding);
const _barRadiusToken = ContextToken<BorderRadius>(_resolveBarRadius);
const _lineWidthToken = ContextToken<double>(_resolveLineWidth);
const _highContrastLineWidthToken = ContextToken<double>(
  _resolveHighContrastLineWidth,
);

/// Returns the series colors for Ui charts in the current scope.
///
/// The accent's `accentIndicator` comes first, then the other named color
/// families, each at a step that keeps 3:1 on the page and panels (see
/// [computeChartSeries]). Set [highContrast] to use step 12 throughout.
List<Color> resolveUiChartPalette(
  BuildContext context, {
  bool highContrast = false,
}) {
  final theme = UiTheme.of(context);
  final colors = resolveUiTokens(theme);
  final namedAccent = theme.accentPalette == null ? theme.accent : null;
  Color series(UiColorScale scale, {Color? preferred}) => highContrast
      ? scale.step(12)
      : computeChartSeries(scale, colors.markSurfaces, preferred: preferred);

  return List<Color>.unmodifiable({
    series(colors.accent.scale, preferred: colors.accent.indicator),
    for (final (accent, family) in _seriesFamilies)
      if (accent != namedAccent)
        series((theme.isDark ? family.dark : family.light).scale),
  });
}

/// The label color for a pie slice filled with [slice]: white or Orla's
/// `#111111` ink, whichever contrasts more.
///
/// ```dart
/// final palette = resolveUiChartPalette(context);
///
/// PieSlice(
///   id: 'mobile',
///   label: 'Mobile',
///   value: 64,
///   style: PieSliceStyler().label(
///     TextStyler().color(uiPieSliceLabelColor(palette[0])),
///   ),
/// )
/// ```
Color uiPieSliceLabelColor(Color slice) {
  const white = Color(0xFFFFFFFF);
  final ink = orla.dark.scale.step(1);

  return computeContrastRatio(white, slice) >= computeContrastRatio(ink, slice)
      ? white
      : ink;
}

/// The color families after the accent. Teal, orange and blue lead because
/// they are the most distinct from one another; gray, the least, is last.
const _seriesFamilies = <(UiAccentColor, UiColorTheme)>[
  (.mar, mar),
  (.caju, caju),
  (.ceu, ceu),
  (.serra, serra),
  (.sol, sol),
  (.duna, duna),
  (.orla, orla),
];

/// Ui presentation for a Mix line or area chart.
///
/// Generates [UiLineChart] through `mix_generator`. The plot remains
/// transparent so callers can compose it inside any surface.
@MixWidget(target: LineChart.new)
LineChartStyler uiLineChartStyle({
  bool highContrast = false,
  bool showMarkers = false,
  List<Color>? palette,
  LineChartStyler style = const LineChartStyler.create(),
}) {
  final recipe = LineChartStyler()
      .frame(_uiFrameStyle())
      .axis(_uiAxisStyle())
      // Value ticks stay centered on their values, so the end ticks overhang
      // the plot by half a line.
      .yAxis(ChartAxisStyler().fitInside(false))
      .topAxis(_hiddenAxisStyle())
      .rightAxis(_hiddenAxisStyle())
      .grid(_uiGridStyle())
      .series(
        LineSeriesStyler()
            .curve(.curved)
            .smoothness(0.18)
            .preventCurveOvershooting(true)
            .roundStrokeCap(true)
            .roundStrokeJoin(true)
            .stroke(
              ChartStrokeStyler().width(
                highContrast
                    ? _highContrastLineWidthToken()
                    : _lineWidthToken(),
              ),
            )
            .marker(
              ChartMarkerStyler()
                  .show(showMarkers)
                  .radius(UiTokens.space1())
                  .borderColor(UiTokens.colorPanel())
                  .borderWidth(UiTokens.borderWidth2()),
            ),
      )
      .tooltip(_uiTooltipStyle());

  return recipe
      .merge(
        LineChartStyler.create(
          palette: _paletteProp(highContrast: highContrast, palette: palette),
        ),
      )
      .merge(style);
}

/// Ui presentation for a Mix grouped, stacked, or floating bar chart.
///
/// Generates [UiBarChart] through `mix_generator`.
@MixWidget(target: BarChart.new)
BarChartStyler uiBarChartStyle({
  bool highContrast = false,
  List<Color>? palette,
  BarChartStyler style = const BarChartStyler.create(),
}) {
  final bar = BarStyler.create(
    borderRadius: Prop.token(_barRadiusToken),
  ).width(UiTokens.space4());
  final recipe = BarChartStyler()
      .frame(_uiFrameStyle())
      .axis(_uiAxisStyle())
      .topAxis(_hiddenAxisStyle())
      .rightAxis(_hiddenAxisStyle())
      .grid(_uiGridStyle())
      .bar(bar)
      .groupSpacing(UiTokens.space4())
      .barSpacing(UiTokens.space2())
      .tooltip(_uiTooltipStyle());

  return recipe
      .merge(
        BarChartStyler.create(
          palette: _paletteProp(highContrast: highContrast, palette: palette),
        ),
      )
      .merge(style);
}

/// Ui presentation for a Mix pie or donut chart.
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
@MixWidget(target: PieChart.new)
PieChartStyler uiPieChartStyle({
  bool highContrast = false,
  double centerRadius = 0,
  bool showLabels = false,
  List<Color>? palette,
  PieChartStyler style = const PieChartStyler.create(),
}) {
  final recipe = PieChartStyler()
      .frame(_uiFrameStyle())
      .centerRadius(centerRadius)
      // The hole shows whatever the chart sits on. A panel-colored disc stands
      // out on the page and doubles the tint of a translucent panel.
      .centerColor(MixColors.transparent)
      .sliceSpacing(UiTokens.borderWidth2())
      .selectedSliceRadiusOffset(UiTokens.space2())
      .slice(
        PieSliceStyler()
            .showLabel(showLabels)
            .cornerRadius(UiTokens.borderWidth2())
            .label(
              TextStyler()
                  .style(UiTokens.text1.mix())
                  .fontWeight(.w600)
                  .color(UiTokens.accentContrast()),
            ),
      )
      .tooltip(_uiTooltipStyle());

  return recipe
      .merge(
        PieChartStyler.create(
          palette: _paletteProp(highContrast: highContrast, palette: palette),
        ),
      )
      .merge(style);
}

Prop<List<Color>> _paletteProp({
  required bool highContrast,
  required List<Color>? palette,
}) {
  if (palette != null) return Prop.value(List<Color>.unmodifiable(palette));

  return Prop.token(
    highContrast ? _highContrastPaletteToken : _standardPaletteToken,
  );
}

ChartFrameStyler _uiFrameStyle() => ChartFrameStyler()
    .backgroundColor(MixColors.transparent)
    .showBorder(false)
    .clip(true);

ChartAxisStyler _uiAxisStyle() => ChartAxisStyler()
    .showLabels(true)
    .label(
      TextStyler().style(UiTokens.text1.mix()).color(UiTokens.gray11()),
    )
    .labelSpace(UiTokens.space2())
    .fitInside(true)
    .fitInsideDistance(UiTokens.space1())
    .drawBelowEverything(true);

ChartAxisStyler _hiddenAxisStyle() => ChartAxisStyler().showLabels(false);

ChartGridStyler _uiGridStyle() => ChartGridStyler()
    .show(true)
    .showHorizontal(true)
    .showVertical(false)
    .stroke(
      ChartStrokeStyler()
          .color(UiTokens.grayA5())
          .width(UiTokens.borderWidth1()),
    );

ChartTooltipStyler _uiTooltipStyle() =>
    ChartTooltipStyler.create(
          border: Prop.token(_tooltipBorderToken),
          borderRadius: Prop.token(_tooltipRadiusToken),
          padding: Prop.token(_tooltipPaddingToken),
        )
        .backgroundColor(UiTokens.colorPanel())
        .margin(UiTokens.space2())
        .maxWidth(280)
        .fitHorizontally(true)
        .fitVertically(true)
        .text(
          TextStyler()
              .style(UiTokens.text1.mix())
              .fontWeight(.w500)
              .color(UiTokens.gray12()),
        );

List<Color> _resolveStandardPalette(BuildContext context) =>
    resolveUiChartPalette(context);

List<Color> _resolveHighContrastPalette(BuildContext context) =>
    resolveUiChartPalette(context, highContrast: true);

BorderSide _resolveTooltipBorder(BuildContext context) => BorderSide(
  color: UiTokens.grayStroke6.resolve(context),
  width: UiTokens.borderWidth1.resolve(context),
);

BorderRadius _resolveTooltipRadius(BuildContext context) =>
    BorderRadius.all(UiTokens.radius3.resolve(context));

EdgeInsets _resolveTooltipPadding(BuildContext context) => EdgeInsets.symmetric(
  horizontal: UiTokens.space3.resolve(context),
  vertical: UiTokens.space2.resolve(context),
);

BorderRadius _resolveBarRadius(BuildContext context) =>
    BorderRadius.all(UiTokens.radius2.resolve(context));

double _resolveLineWidth(BuildContext context) =>
    2 * UiTheme.of(context).scaling.factor;

double _resolveHighContrastLineWidth(BuildContext context) =>
    3 * UiTheme.of(context).scaling.factor;
