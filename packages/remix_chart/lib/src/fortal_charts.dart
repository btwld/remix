import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart' as remix;

part 'fortal_charts.g.dart';

final _standardPaletteToken = ContextToken<List<Color>>(
  _resolveStandardPalette,
);
final _highContrastPaletteToken = ContextToken<List<Color>>(
  _resolveHighContrastPalette,
);
final _tooltipBorderToken = ContextToken<BorderSide>(_resolveTooltipBorder);
final _tooltipRadiusToken = ContextToken<BorderRadius>(_resolveTooltipRadius);
final _tooltipPaddingToken = ContextToken<EdgeInsets>(_resolveTooltipPadding);
final _barRadiusToken = ContextToken<BorderRadius>(_resolveBarRadius);
final _lineWidthToken = ContextToken<double>(_resolveLineWidth);
final _highContrastLineWidthToken = ContextToken<double>(
  _resolveHighContrastLineWidth,
);

/// Returns the categorical palette used by Fortal charts in the current scope.
///
/// The first entry follows the configured Fortal accent. Remaining entries use
/// Radix color families selected for clear categorical separation. Set
/// [highContrast] to use step 12 instead of the standard solid-color step 9.
List<Color> resolveFortalChartPalette(
  BuildContext context, {
  bool highContrast = false,
}) {
  final theme = remix.FortalTheme.of(context);
  final colors = remix.resolveFortalTokens(theme);
  final step = highContrast ? 12 : 9;
  final candidates = <Color>[
    colors.accent.scale.step(step),
    for (final family in [
      remix.cyan,
      remix.orange,
      remix.ruby,
      remix.green,
      remix.violet,
      remix.amber,
      remix.blue,
    ])
      (theme.isDark ? family.dark : family.light).scale.step(step),
  ];

  return List<Color>.unmodifiable(candidates.toSet());
}

/// Fortal presentation for a Mix line or area chart.
///
/// Generates [FortalLineChart] through `mix_generator`. The plot remains
/// transparent so callers can compose it inside a [remix.FortalCard] or any
/// other surface.
@MixWidget(target: LineChart.new)
LineChartStyler fortalLineChartStyle({
  bool highContrast = false,
  bool showMarkers = false,
  List<Color>? palette,
}) {
  final style = LineChartStyler()
      .frame(_fortalFrameStyle())
      .axis(_fortalAxisStyle())
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
                  .radius(remix.FortalTokens.space1())
                  .borderColor(remix.FortalTokens.colorPanel())
                  .borderWidth(remix.FortalTokens.borderWidth2()),
            ),
      )
      .tooltip(_fortalTooltipStyle());

  return style.merge(
    LineChartStyler.create(
      palette: _paletteProp(highContrast: highContrast, palette: palette),
    ),
  );
}

/// Fortal presentation for a Mix grouped, stacked, or floating bar chart.
///
/// Generates [FortalBarChart] through `mix_generator`.
@MixWidget(target: BarChart.new)
BarChartStyler fortalBarChartStyle({
  bool highContrast = false,
  List<Color>? palette,
}) {
  final bar = BarStyler.create(
    borderRadius: Prop.token(_barRadiusToken),
  ).width(remix.FortalTokens.space4());
  final style = BarChartStyler()
      .frame(_fortalFrameStyle())
      .axis(_fortalAxisStyle())
      .topAxis(_hiddenAxisStyle())
      .rightAxis(_hiddenAxisStyle())
      .grid(_fortalGridStyle())
      .bar(bar)
      .groupSpacing(remix.FortalTokens.space4())
      .barSpacing(remix.FortalTokens.space2())
      .tooltip(_fortalTooltipStyle());

  return style.merge(
    BarChartStyler.create(
      palette: _paletteProp(highContrast: highContrast, palette: palette),
    ),
  );
}

/// Fortal presentation for a Mix pie or donut chart.
///
/// A positive [centerRadius] renders a donut. Labels are hidden by default so
/// category names can be presented in a caller-owned legend without forcing
/// low-contrast text onto arbitrary categorical colors. Generates
/// [FortalPieChart] through `mix_generator`.
@MixWidget(target: PieChart.new)
PieChartStyler fortalPieChartStyle({
  bool highContrast = false,
  double centerRadius = 0,
  bool showLabels = false,
  List<Color>? palette,
}) {
  final style = PieChartStyler()
      .frame(_fortalFrameStyle())
      .centerRadius(centerRadius)
      .centerColor(remix.FortalTokens.colorPanel())
      .sliceSpacing(remix.FortalTokens.borderWidth2())
      .slice(
        PieSliceStyler()
            .showLabel(showLabels)
            .cornerRadius(remix.FortalTokens.borderWidth2())
            .label(
              TextStyler()
                  .style(remix.FortalTokens.text1.mix())
                  .fontWeight(.w600)
                  .color(remix.FortalTokens.accentContrast()),
            ),
      )
      .tooltip(_fortalTooltipStyle());

  return style.merge(
    PieChartStyler.create(
      palette: _paletteProp(highContrast: highContrast, palette: palette),
    ),
  );
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
    .backgroundColor(Colors.transparent)
    .showBorder(false)
    .clip(true);

ChartAxisStyler _fortalAxisStyle() => ChartAxisStyler()
    .showLabels(true)
    .label(
      TextStyler()
          .style(remix.FortalTokens.text1.mix())
          .color(remix.FortalTokens.gray11()),
    )
    .labelSpace(remix.FortalTokens.space2())
    .fitInside(true)
    .fitInsideDistance(remix.FortalTokens.space1())
    .drawBelowEverything(true);

ChartAxisStyler _hiddenAxisStyle() => ChartAxisStyler().showLabels(false);

ChartGridStyler _fortalGridStyle() => ChartGridStyler()
    .show(true)
    .showHorizontal(true)
    .showVertical(false)
    .stroke(
      ChartStrokeStyler()
          .color(remix.FortalTokens.grayA5())
          .width(remix.FortalTokens.borderWidth1()),
    );

ChartTooltipStyler _fortalTooltipStyle() =>
    ChartTooltipStyler.create(
          border: Prop.token(_tooltipBorderToken),
          borderRadius: Prop.token(_tooltipRadiusToken),
          padding: Prop.token(_tooltipPaddingToken),
        )
        .backgroundColor(remix.FortalTokens.colorPanel())
        .margin(remix.FortalTokens.space2())
        .maxWidth(280)
        .fitHorizontally(true)
        .fitVertically(true)
        .text(
          TextStyler()
              .style(remix.FortalTokens.text1.mix())
              .fontWeight(.w500)
              .color(remix.FortalTokens.gray12()),
        );

List<Color> _resolveStandardPalette(BuildContext context) =>
    resolveFortalChartPalette(context);

List<Color> _resolveHighContrastPalette(BuildContext context) =>
    resolveFortalChartPalette(context, highContrast: true);

BorderSide _resolveTooltipBorder(BuildContext context) => BorderSide(
  color: remix.FortalTokens.grayStroke6.resolve(context),
  width: remix.FortalTokens.borderWidth1.resolve(context),
);

BorderRadius _resolveTooltipRadius(BuildContext context) =>
    BorderRadius.all(remix.FortalTokens.radius3.resolve(context));

EdgeInsets _resolveTooltipPadding(BuildContext context) => EdgeInsets.symmetric(
  horizontal: remix.FortalTokens.space3.resolve(context),
  vertical: remix.FortalTokens.space2.resolve(context),
);

BorderRadius _resolveBarRadius(BuildContext context) =>
    BorderRadius.all(remix.FortalTokens.radius2.resolve(context));

double _resolveLineWidth(BuildContext context) =>
    2 * remix.FortalTheme.of(context).scaling.factor;

double _resolveHighContrastLineWidth(BuildContext context) =>
    3 * remix.FortalTheme.of(context).scaling.factor;
