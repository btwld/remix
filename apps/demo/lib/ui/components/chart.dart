import 'dart:math' as math;

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

/// Returns the categorical palette used by Fortal charts in the current scope.
///
/// The first entry is the accent's mark fill, `accentIndicator`. The other
/// Fortal color families follow, without the named accent's own family. Every
/// entry is a graphical object that must stay visible on the page and on solid
/// and translucent panels (WCAG 1.4.11), so each family uses its first source
/// step from 9 that keeps the 3.05:1 mark margin on those surfaces, and an
/// accent whose mark fill is luminous (Sol in light mode) does the same.
///
/// Set [highContrast] to use step 12 throughout instead.
List<Color> resolveFortalChartPalette(
  BuildContext context, {
  bool highContrast = false,
}) {
  final theme = FortalTheme.of(context);
  final colors = resolveFortalTokens(theme);
  final surfaces = [
    colors.colorBackground,
    colors.colorPanelSolid,
    Color.alphaBlend(colors.colorPanelTranslucent, colors.colorBackground),
  ];
  final namedAccent = theme.accentPalette == null ? theme.accent : null;
  Color series(FortalColorScale scale) =>
      highContrast ? scale.step(12) : _seriesStep(scale, surfaces);
  final indicator = colors.accent.indicator;

  final candidates = <Color>[
    if (!highContrast && _keepsSeriesContrast(indicator, surfaces))
      indicator
    else
      series(colors.accent.scale),
    for (final (accent, family) in _seriesFamilies)
      if (accent != namedAccent)
        series((theme.isDark ? family.dark : family.light).scale),
  ];

  return List<Color>.unmodifiable(candidates.toSet());
}

/// The label color that reads on a pie slice filled with [slice].
///
/// Slice labels are 12px text, which needs 4.5:1 on its fill (WCAG 1.4.3),
/// and no one color reaches that on every series color. This returns white
/// or Orla's deepest ink, `#111111`, whichever contrasts more with [slice];
/// on every Fortal series color, standard or high contrast, the lower of the
/// two choices is still 4.61:1.
///
/// Pie labels are off by default. A chart that turns them on sets each
/// slice's label color from this, next to the fill the slice is drawn in:
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

  return _contrast(white, slice) >= _contrast(ink, slice) ? white : ink;
}

/// The color families that follow the accent, in series order.
///
/// Teal, orange and blue lead because they are the furthest apart, so the
/// first four series stay distinct whichever accent goes first. The muted
/// warm families come next and gray, the least distinct in either mode and
/// the lowest-contrast series in dark mode, comes last.
const _seriesFamilies = <(FortalAccentColor, FortalColorTheme)>[
  (.mar, mar),
  (.caju, caju),
  (.ceu, ceu),
  (.serra, serra),
  (.sol, sol),
  (.duna, duna),
  (.orla, orla),
];

/// The 3.05:1 margin Fortal fits marks and focus rings to, over WCAG's 3:1.
const _seriesContrast = 3.05;

/// The first source step from 9 that keeps [_seriesContrast] on [surfaces].
Color _seriesStep(FortalColorScale scale, List<Color> surfaces) {
  for (var step = 9; step < 12; step++) {
    final color = scale.step(step);
    if (_keepsSeriesContrast(color, surfaces)) return color;
  }

  return scale.step(12);
}

bool _keepsSeriesContrast(Color color, List<Color> surfaces) =>
    surfaces.every((surface) => _contrast(color, surface) >= _seriesContrast);

/// WCAG 2 contrast ratio between two opaque colors.
double _contrast(Color a, Color b) {
  final lighter = math.max(a.computeLuminance(), b.computeLuminance());
  final darker = math.min(a.computeLuminance(), b.computeLuminance());

  return (lighter + 0.05) / (darker + 0.05);
}

/// Fortal presentation for a Mix line or area chart.
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
  final recipe = LineChartStyler()
      .frame(_fortalFrameStyle())
      .axis(_fortalAxisStyle())
      // Each value tick stays centred on the value it names, so the end
      // ticks overhang the plot by half a line rather than moving inward.
      // The line chart clips only its marks, so the overhang stays visible.
      .yAxis(_fortalValueAxisStyle().fitInside(false))
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
      .tooltip(_fortalTooltipStyle());

  return recipe
      .merge(
        LineChartStyler.create(
          palette: _paletteProp(highContrast: highContrast, palette: palette),
        ),
      )
      .merge(style);
}

/// Fortal presentation for a Mix grouped, stacked, or floating bar chart.
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
  final recipe = BarChartStyler()
      .frame(_fortalFrameStyle())
      .axis(_fortalAxisStyle())
      // mix_chart clips the whole bar chart, labels included, so an end tick
      // overhanging the plot would be cut in half: keep it fitted inside.
      .yAxis(_fortalValueAxisStyle())
      .topAxis(_hiddenAxisStyle())
      .rightAxis(_hiddenAxisStyle())
      .grid(_fortalGridStyle())
      .bar(bar)
      .groupSpacing(FortalTokens.space4())
      .barSpacing(FortalTokens.space2())
      .tooltip(_fortalTooltipStyle());

  return recipe
      .merge(
        BarChartStyler.create(
          palette: _paletteProp(highContrast: highContrast, palette: palette),
        ),
      )
      .merge(style);
}

/// Fortal presentation for a Mix pie or donut chart.
///
/// A positive [centerRadius] renders a donut. Labels are hidden by default so
/// category names can be presented in a caller-owned legend without forcing
/// low-contrast text onto arbitrary categorical colors. [showLabels] draws
/// them in `accentContrast`, which no series color is fitted to: pair it with
/// [fortalPieSliceLabelColor] on each slice. Generates
/// [FortalPieChart] through `mix_generator`. For advanced chart-level geometry,
/// pass this recipe directly to [PieChart.style] and merge a [PieSliceStyler].
///
/// The pie does not scale to its box: mix_chart draws each slice 80px wide
/// whatever room it has, so a donut reaches [centerRadius] plus 80px and is
/// clipped in a box less than twice that. Set the ring to fit the box:
/// `style: PieChartStyler().slice(PieSliceStyler().radius(44))`.
@MixWidget(target: PieChart.new)
PieChartStyler fortalPieChartStyle({
  bool highContrast = false,
  double centerRadius = 0,
  bool showLabels = false,
  List<Color>? palette,
  PieChartStyler style = const PieChartStyler.create(),
}) {
  final recipe = PieChartStyler()
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
            // Opt-in slice labels take the accent's label colour, which is
            // fitted to the accent's labelled solid, not to every slice of
            // the categorical palette. Callers set each slice's label colour
            // from fortalPieSliceLabelColor.
            .label(
              TextStyler()
                  .style(FortalTokens.text1.mix())
                  .fontWeight(.w600)
                  .color(FortalTokens.accentContrast()),
            ),
      )
      .tooltip(_fortalTooltipStyle());

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

/// The value axis reserves room for a six-character tick such as `1.284K`
/// beside its label space, and grows with the theme's scaling like the label
/// text does. The package's fixed 44px wraps such a tick onto two lines.
ChartAxisStyler _fortalValueAxisStyle() =>
    ChartAxisStyler().reservedSize(FortalTokens.space8());

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

List<Color> _resolveStandardPalette(BuildContext context) =>
    resolveFortalChartPalette(context);

List<Color> _resolveHighContrastPalette(BuildContext context) =>
    resolveFortalChartPalette(context, highContrast: true);

BorderSide _resolveTooltipBorder(BuildContext context) => BorderSide(
  color: FortalTokens.grayStroke6.resolve(context),
  width: FortalTokens.borderWidth1.resolve(context),
);

BorderRadius _resolveTooltipRadius(BuildContext context) =>
    BorderRadius.all(FortalTokens.radius3.resolve(context));

EdgeInsets _resolveTooltipPadding(BuildContext context) => EdgeInsets.symmetric(
  horizontal: FortalTokens.space3.resolve(context),
  vertical: FortalTokens.space2.resolve(context),
);

BorderRadius _resolveBarRadius(BuildContext context) =>
    BorderRadius.all(FortalTokens.radius2.resolve(context));

double _resolveLineWidth(BuildContext context) =>
    2 * FortalTheme.of(context).scaling.factor;

double _resolveHighContrastLineWidth(BuildContext context) =>
    3 * FortalTheme.of(context).scaling.factor;
