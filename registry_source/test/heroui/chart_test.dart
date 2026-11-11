import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:registry_source/src/heroui/components/card.dart';
import 'package:registry_source/src/heroui/components/chart.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

void main() {
  test('the series ramp is accent, then neutral tokens, never a status', () {
    expect(heroUiChartSeries, const [
      HeroUiTokens.accent,
      HeroUiTokens.muted,
      HeroUiTokens.foreground,
      HeroUiTokens.borderTertiary,
    ]);
    for (final status in const [
      HeroUiTokens.success,
      HeroUiTokens.warning,
      HeroUiTokens.danger,
      HeroUiTokens.successSoft,
      HeroUiTokens.warningSoft,
      HeroUiTokens.dangerSoft,
    ]) {
      expect(heroUiChartSeries, isNot(contains(status)));
    }
  });

  for (final mode in ['light', 'dark']) {
    test('the first three series keep 3:1 against a card in $mode', () {
      final surface = heroUiToken(HeroUiTokens.surface, mode);
      final colors = [
        for (final token in heroUiChartSeries) heroUiToken(token, mode),
      ];
      for (final (index, color) in colors.take(3).indexed) {
        expect(
          _contrast(color, surface),
          greaterThanOrEqualTo(3),
          reason: 'series ${index + 1}, ${heroUiChartSeries[index].name}',
        );
      }
      // The neutrals step away from the card: each contrasts more with it.
      expect(
        _contrast(colors[2], surface),
        greaterThan(_contrast(colors[1], surface)),
      );
      expect(colors.toSet(), hasLength(colors.length));
    });

    testWidgets('recipes resolve the ramp and the shared parts in $mode', (
      tester,
    ) async {
      late List<Color> palette;
      late LineChartSpec line;
      late BarChartSpec bar;
      late PieChartSpec pie;
      await tester.pumpHeroUi(
        Builder(
          builder: (context) {
            palette = resolveHeroUiChartPalette(context);
            line = heroUiLineChartStyle(showMarkers: true).build(context).spec;
            bar = heroUiBarChartStyle().build(context).spec;
            pie = heroUiPieChartStyle(centerRadius: 40).build(context).spec;
            return const SizedBox.shrink();
          },
        ),
        mode: mode,
      );

      final expected = [
        for (final token in heroUiChartSeries) heroUiToken(token, mode),
      ];
      expect(palette, expected);
      expect(line.palette, expected);
      expect(bar.palette, expected);
      expect(pie.palette, expected);

      // Axes in `text-xs` `muted`, a `separator` grid, a `surface` ring.
      final label = line.axis!.spec.label!.spec.style!;
      expect(label.fontSize, 12);
      expect(label.color, heroUiToken(HeroUiTokens.muted, mode));
      expect(
        line.grid!.spec.stroke!.spec.color,
        heroUiToken(HeroUiTokens.separator, mode),
      );
      expect(line.grid!.spec.showVertical, isFalse);
      final marker = line.series!.spec.marker!.spec;
      expect(marker.show, isTrue);
      expect(marker.borderColor, heroUiToken(HeroUiTokens.surface, mode));
      expect(line.series!.spec.stroke!.spec.width, 2);

      // The tooltip is the tooltip recipe's overlay, outlined in `border`.
      final tooltip = line.tooltip!.spec;
      expect(tooltip.backgroundColor, heroUiToken(HeroUiTokens.overlay, mode));
      expect(tooltip.border!.color, heroUiToken(HeroUiTokens.border, mode));
      expect(tooltip.borderRadius, BorderRadius.circular(12));
      expect(tooltip.padding, const EdgeInsets.all(8));
      expect(
        tooltip.text!.spec.style!.color,
        heroUiToken(HeroUiTokens.overlayForeground, mode),
      );

      // `radius-sm` bars, a transparent donut hole.
      expect(bar.bar!.spec.borderRadius, BorderRadius.circular(4));
      expect(bar.bar!.spec.width, 16);
      expect(pie.centerRadius, 40);
      expect(pie.centerColor, HeroUiTokens.transparent);
      expect(pie.slice!.spec.showLabel, isFalse);
    });

    testWidgets('a pie label reads on every series in $mode', (tester) async {
      late List<Color> labels;
      await tester.pumpHeroUi(
        Builder(
          builder: (context) {
            labels = [
              for (final color in resolveHeroUiChartPalette(context))
                heroUiPieSliceLabelColor(context, color),
            ];
            return const SizedBox.shrink();
          },
        ),
        mode: mode,
      );

      final palette = [
        for (final token in heroUiChartSeries) heroUiToken(token, mode),
      ];
      for (final (index, label) in labels.indexed) {
        expect(
          label,
          anyOf(
            heroUiToken(HeroUiTokens.foreground, mode),
            heroUiToken(HeroUiTokens.surface, mode),
          ),
        );
        expect(
          _contrast(label, palette[index]),
          greaterThanOrEqualTo(3),
          reason: 'label on series ${index + 1}',
        );
      }
    });
  }

  testWidgets('a caller palette and style override the recipe', (tester) async {
    const palette = [Color(0xFF112233), Color(0xFF445566)];
    late BarChartSpec bar;
    late LineChartSpec line;
    await tester.pumpHeroUi(
      Builder(
        builder: (context) {
          bar = heroUiBarChartStyle(palette: palette).build(context).spec;
          line = heroUiLineChartStyle(
            style: LineChartStyler().grid(
              ChartGridStyler().stroke(ChartStrokeStyler().width(3)),
            ),
          ).build(context).spec;
          return const SizedBox.shrink();
        },
      ),
    );

    expect(bar.palette, palette);
    expect(line.grid!.spec.stroke!.spec.width, 3);
    expect(
      line.grid!.spec.stroke!.spec.color,
      heroUiToken(HeroUiTokens.separator),
    );
  });

  test('the generated widgets forward recipe and chart parameters', () {
    final line = HeroUiLineChart(
      showMarkers: true,
      semanticsLabel: 'Revenue',
      series: [_lineSeries()],
    );
    final bar = HeroUiBarChart(semanticsLabel: 'Orders', groups: [_barGroup()]);
    final pie = HeroUiPieChart(
      centerRadius: 40,
      showLabels: true,
      semanticsLabel: 'Channels',
      slices: [_pieSlice()],
    );

    expect(line.showMarkers, isTrue);
    expect(line.semanticsLabel, 'Revenue');
    expect(bar.semanticsLabel, 'Orders');
    expect(pie.centerRadius, 40);
    expect(pie.showLabels, isTrue);
    expect(pie.semanticsLabel, 'Channels');
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('the three charts render on a card in $mode', (tester) async {
      await tester.pumpHeroUi(
        SizedBox(
          width: 360,
          child: HeroUiCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 160,
                  child: HeroUiLineChart(
                    showMarkers: true,
                    series: [_lineSeries()],
                  ),
                ),
                SizedBox(
                  height: 160,
                  child: HeroUiBarChart(groups: [_barGroup()]),
                ),
                SizedBox(
                  height: 180,
                  child: HeroUiPieChart(
                    centerRadius: 40,
                    style: PieChartStyler().slice(PieSliceStyler().radius(44)),
                    slices: [_pieSlice()],
                  ),
                ),
              ],
            ),
          ),
        ),
        mode: mode,
      );
      await tester.pump();

      expect(find.byType(LineChart), findsOneWidget);
      expect(find.byType(BarChart), findsOneWidget);
      expect(find.byType(PieChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}

/// WCAG contrast ratio between two opaque colors.
double _contrast(Color a, Color b) {
  final lighter = math.max(a.computeLuminance(), b.computeLuminance());
  final darker = math.min(a.computeLuminance(), b.computeLuminance());
  return (lighter + 0.05) / (darker + 0.05);
}

LineSeries _lineSeries() => LineSeries(
  id: 'revenue',
  label: 'Revenue',
  points: [
    ChartPoint(id: 'monday', x: 0, y: 18),
    ChartPoint(id: 'tuesday', x: 1, y: 31),
  ],
);

BarGroup _barGroup() => BarGroup(
  id: 'q1',
  label: 'Q1',
  bars: [BarValue(id: 'actual', label: 'Actual', toY: 42)],
);

PieSlice _pieSlice() => PieSlice(id: 'mobile', label: 'Mobile', value: 64);
