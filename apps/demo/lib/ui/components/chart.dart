import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';

import '../theme/fortal_colors.dart';
import '../theme/palette.dart';
import '../theme/theme.dart';

part 'chart.g.dart';

/// Returns the series colors for Fortal charts in the current scope.
///
/// The accent's `accentIndicator` comes first, then the other named color
/// families, each at a step that keeps 3:1 on the page and panels (see
/// [computeChartSeries]). Set [highContrast] to use step 12 throughout.
List<Color> resolveFortalChartPalette(
  BuildContext context, {
  bool highContrast = false,
}) {
  final theme = FortalTheme.of(context);
  final colors = resolveFortalTokens(theme);
  final namedAccent = theme.accentPalette == null ? theme.accent : null;
  Color series(FortalColorScale scale, {Color? preferred}) => highContrast
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
/// final palette = resolveFortalChartPalette(context);
///
/// PieSlice(
///   id: 'mobile',
///   label: 'Mobile',
///   value: 64,
///   style: PieSliceStyler().label(
///     TextStyler().color(fortalPieSliceLabelColor(palette[0])),
///   ),
/// )
/// ```
Color fortalPieSliceLabelColor(Color slice) {
  const white = Color(0xFFFFFFFF);
  final ink = orla.dark.scale.step(1);

  return computeContrastRatio(white, slice) >= computeContrastRatio(ink, slice)
      ? white
      : ink;
}

/// The color families after the accent. Teal, orange and blue lead because
/// they are the most distinct from one another; gray, the least, is last.
const _seriesFamilies = <(FortalAccentColor, FortalColorTheme)>[
  (.mar, mar),
  (.caju, caju),
  (.ceu, ceu),
  (.serra, serra),
  (.sol, sol),
  (.duna, duna),
  (.orla, orla),
];

/// The Fortal LineChart recipe, for a Mix line or area chart.
///
/// Generates [FortalLineChart] through `mix_generator`. The plot remains
/// transparent so callers can compose it inside any surface.
@MixWidget(target: LineChart.new)
LineChartStyler fortalLineChartStyle({
  bool highContrast = false,
  bool showMarkers = false,
  List<Color>? palette,
  LineChartStyler style = const LineChartStyler.create(),
}) {
  return LineChartStyler()
      .frame(_fortalFrameStyle())
      .axis(_fortalAxisStyle())
      // Value ticks stay centered on their values, so the end ticks overhang
      // the plot by half a line.
      .yAxis(ChartAxisStyler().fitInside(false))
      .topAxis(_hiddenAxisStyle())
      .rightAxis(_hiddenAxisStyle())
      .grid(_fortalGridStyle())
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
                  .radius(FortalTokens.space1())
                  .borderColor(FortalTokens.colorPanel())
                  .borderWidth(FortalTokens.borderWidth2()),
            ),
      )
      .tooltip(_fortalTooltipStyle())
      .merge(
        LineChartStyler.create(
          palette: _paletteProp(highContrast: highContrast, palette: palette),
        ),
      )
      .merge(style);
}

/// The Fortal BarChart recipe: grouped, stacked or floating bars.
///
/// Generates [FortalBarChart] through `mix_generator`.
@MixWidget(target: BarChart.new)
BarChartStyler fortalBarChartStyle({
  bool highContrast = false,
  List<Color>? palette,
  BarChartStyler style = const BarChartStyler.create(),
}) {
  final bar = BarStyler.create(
    borderRadius: Prop.token(_barRadiusToken),
  ).width(FortalTokens.space4());
  return BarChartStyler()
      .frame(_fortalFrameStyle())
      .axis(_fortalAxisStyle())
      .topAxis(_hiddenAxisStyle())
      .rightAxis(_hiddenAxisStyle())
      .grid(_fortalGridStyle())
      .bar(bar)
      .groupSpacing(FortalTokens.space4())
      .barSpacing(FortalTokens.space2())
      .tooltip(_fortalTooltipStyle())
      .merge(
        BarChartStyler.create(
          palette: _paletteProp(highContrast: highContrast, palette: palette),
        ),
      )
      .merge(style);
}

/// The Fortal PieChart recipe, for a Mix pie or donut chart.
///
/// A positive [centerRadius] renders a donut. Labels are hidden by default so
/// category names can be presented in a caller-owned legend without forcing
/// low-contrast text onto arbitrary categorical colors; with [showLabels], set
/// each slice's label color with [fortalPieSliceLabelColor]. Generates
/// [FortalPieChart] through `mix_generator`. For advanced chart-level geometry,
/// pass this recipe directly to [PieChart.style] and merge a [PieSliceStyler].
///
/// The default slice radius is at most 80 logical pixels and shrinks to fit
/// the available box, accounting for the center hole and selection expansion.
/// An explicit `PieSliceStyler().radius(...)` keeps caller-controlled sizing.
@MixWidget(target: PieChart.new)
PieChartStyler fortalPieChartStyle({
  bool highContrast = false,
  double centerRadius = 0,
  bool showLabels = false,
  List<Color>? palette,
  PieChartStyler style = const PieChartStyler.create(),
}) {
  return PieChartStyler()
      .frame(_fortalFrameStyle())
      .centerRadius(centerRadius)
      // The hole shows whatever the chart sits on. A panel-colored disc stands
      // out on the page and doubles the tint of a translucent panel.
      .centerColor(MixColors.transparent)
      .sliceSpacing(FortalTokens.borderWidth2())
      .selectedSliceRadiusOffset(FortalTokens.space2())
      .slice(
        PieSliceStyler()
            .showLabel(showLabels)
            .cornerRadius(FortalTokens.borderWidth2())
            .label(
              TextStyler()
                  .style(FortalTokens.text1.mix())
                  .fontWeight(.w600)
                  .color(FortalTokens.accentContrast()),
            ),
      )
      .tooltip(_fortalTooltipStyle())
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

ChartFrameStyler _fortalFrameStyle() => ChartFrameStyler()
    .backgroundColor(MixColors.transparent)
    .showBorder(false)
    .clip(true);

ChartAxisStyler _fortalAxisStyle() => ChartAxisStyler()
    .showLabels(true)
    .label(
      TextStyler().style(FortalTokens.text1.mix()).color(FortalTokens.gray11()),
    )
    .labelSpace(FortalTokens.space2())
    .fitInside(true)
    .fitInsideDistance(FortalTokens.space1())
    .drawBelowEverything(true);

ChartAxisStyler _hiddenAxisStyle() => ChartAxisStyler().showLabels(false);

ChartGridStyler _fortalGridStyle() => ChartGridStyler()
    .show(true)
    .showHorizontal(true)
    .showVertical(false)
    .stroke(
      ChartStrokeStyler()
          .color(FortalTokens.grayA5())
          .width(FortalTokens.borderWidth1()),
    );

ChartTooltipStyler _fortalTooltipStyle() =>
    ChartTooltipStyler.create(
          border: Prop.token(_tooltipBorderToken),
          borderRadius: Prop.token(_tooltipRadiusToken),
          padding: Prop.token(_tooltipPaddingToken),
        )
        .backgroundColor(FortalTokens.colorPanel())
        .margin(FortalTokens.space2())
        .maxWidth(280)
        .fitHorizontally(true)
        .fitVertically(true)
        .text(
          TextStyler()
              .style(FortalTokens.text1.mix())
              .fontWeight(.w500)
              .color(FortalTokens.gray12()),
        );

/// The series colors of the active theme.
final _standardPaletteToken = ContextToken<List<Color>>(
  (context) => resolveFortalChartPalette(context),
);

/// The series colors of the active theme, all at step 12.
final _highContrastPaletteToken = ContextToken<List<Color>>(
  (context) => resolveFortalChartPalette(context, highContrast: true),
);

/// The tooltip's 1px frame.
final _tooltipBorderToken = ContextToken<BorderSide>(
  (context) => BorderSide(
    color: FortalTokens.grayStroke6.resolve(context),
    width: FortalTokens.borderWidth1.resolve(context),
  ),
);

final _tooltipRadiusToken = ContextToken<BorderRadius>(
  (context) => BorderRadius.all(FortalTokens.radius3.resolve(context)),
);

final _tooltipPaddingToken = ContextToken<EdgeInsets>(
  (context) => EdgeInsets.symmetric(
    horizontal: FortalTokens.space3.resolve(context),
    vertical: FortalTokens.space2.resolve(context),
  ),
);

final _barRadiusToken = ContextToken<BorderRadius>(
  (context) => BorderRadius.all(FortalTokens.radius2.resolve(context)),
);

/// A line's width: 2px at 100% theme scaling.
final _lineWidthToken = ContextToken<double>(
  (context) => 2 * FortalTheme.of(context).scaling.factor,
);

/// A line's width under high contrast: 3px at 100% theme scaling.
final _highContrastLineWidthToken = ContextToken<double>(
  (context) => 3 * FortalTheme.of(context).scaling.factor,
);
