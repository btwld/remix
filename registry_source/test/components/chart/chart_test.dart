import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix_ui_fonts/remix_ui_fonts.dart';

import '../../helpers/pixels.dart';

void main() {
  group('Fortal chart recipes', () {
    testWidgets('resolve the active Fortal theme and contextual palette', (
      tester,
    ) async {
      late StyleSpec<LineChartSpec> resolved;
      late List<Color> publicPalette;

      await tester.pumpWidget(
        FortalTheme(
          accent: .sol,
          mode: .dark,
          child: Builder(
            builder: (context) {
              publicPalette = resolveFortalChartPalette(context);
              resolved = fortalLineChartStyle().build(context);
              return const SizedBox();
            },
          ),
        ),
      );

      final colors = resolveFortalTokens(
        const FortalThemeConfig(accent: .sol, brightness: .dark),
      );
      final spec = resolved.spec;

      expect(spec.palette, publicPalette);
      expect(spec.palette!.first, colors.accent.scale.step(9));
      expect(spec.palette, hasLength(greaterThanOrEqualTo(7)));
      expect(spec.palette!.toSet(), hasLength(spec.palette!.length));
      expect(
        spec.grid!.spec.stroke!.spec.color,
        colors.gray.scale.alphaStep(5),
      );
      expect(spec.tooltip!.spec.backgroundColor, colors.colorPanelSolid);
    });

    testWidgets('high contrast uses the Fortal step-12 palette', (
      tester,
    ) async {
      late StyleSpec<PieChartSpec> resolved;

      await tester.pumpWidget(
        FortalTheme(
          accent: .ceu,
          child: Builder(
            builder: (context) {
              resolved = fortalPieChartStyle(highContrast: true).build(context);
              return const SizedBox();
            },
          ),
        ),
      );

      final colors = resolveFortalTokens(const FortalThemeConfig(accent: .ceu));
      expect(resolved.spec.palette!.first, colors.accent.scale.step(12));
    });

    testWidgets('caller palette overrides the contextual default', (
      tester,
    ) async {
      const palette = [Color(0xFF112233), Color(0xFF445566)];
      late StyleSpec<BarChartSpec> resolved;

      await tester.pumpWidget(
        FortalTheme(
          child: Builder(
            builder: (context) {
              resolved = fortalBarChartStyle(palette: palette).build(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolved.spec.palette, palette);
    });

    testWidgets('pie selection expansion follows Fortal spacing', (
      tester,
    ) async {
      late StyleSpec<PieChartSpec> resolved;
      late double expectedOffset;

      await tester.pumpWidget(
        FortalTheme(
          child: Builder(
            builder: (context) {
              expectedOffset = MixScope.tokenOf(FortalTokens.space2, context);
              resolved = fortalPieChartStyle().build(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolved.spec.selectedSliceRadiusOffset, expectedOffset);
    });

    testWidgets('line and bar value axes share one scaled reservation', (
      tester,
    ) async {
      late double expected;
      late StyleSpec<LineChartSpec> line;
      late StyleSpec<BarChartSpec> bar;

      await tester.pumpWidget(
        FortalTheme(
          scaling: .percent110,
          child: Builder(
            builder: (context) {
              expected = MixScope.tokenOf(FortalTokens.space8, context);
              line = fortalLineChartStyle().build(context);
              bar = fortalBarChartStyle().build(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(line.spec.yAxis!.spec.reservedSize, expected);
      expect(bar.spec.yAxis!.spec.reservedSize, expected);
    });

    for (final (name, panel) in [
      ('the page', null),
      ('a translucent panel', FortalPanelBackground.translucent),
    ]) {
      testWidgets('a donut hole shows $name behind it', (tester) async {
        final key = GlobalKey();
        late Color behind;

        await tester.pumpWidget(
          FortalTheme(
            mode: .light,
            panelBackground: panel ?? .solid,
            child: Builder(
              builder: (context) {
                final page = FortalTokens.colorBackground.resolve(context);
                final surface = panel == null
                    ? const Color(0x00000000)
                    : FortalTokens.colorPanel.resolve(context);
                behind = Color.alphaBlend(surface, page);
                return Directionality(
                  textDirection: .ltr,
                  child: Center(
                    child: RepaintBoundary(
                      key: key,
                      child: ColoredBox(
                        color: page,
                        child: ColoredBox(
                          color: surface,
                          child: SizedBox.square(
                            dimension: 160,
                            child: FortalPieChart(
                              centerRadius: 40,
                              style: PieChartStyler().slice(
                                PieSliceStyler().radius(30),
                              ),
                              slices: [_pieSlice()],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
        await tester.pump();

        final pixels = await capturePixels(tester, key);
        expectNearColor(pixels.at(80 * pixelScale, 80 * pixelScale), behind);
      });
    }
  });

  group('Fortal value axis', () {
    setUpAll(() async {
      final loader = FontLoader(RemixFonts.geist);
      for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
        loader.addFont(
          rootBundle.load(
            'packages/remix_ui_fonts/lib/fonts/geist/Geist-$weight.ttf',
          ),
        );
      }
      await loader.load();
    });

    for (final scaling in [
      FortalScaling.percent100,
      FortalScaling.percent110,
    ]) {
      testWidgets('six-character ticks stay on one line at ${scaling.name}', (
        tester,
      ) async {
        await tester.pumpWidget(
          FortalTheme(
            scaling: scaling,
            child: Directionality(
              textDirection: .ltr,
              child: DefaultTextStyle(
                style: const TextStyle(fontFamily: RemixFonts.geist),
                child: Align(
                  alignment: .topLeft,
                  child: SizedBox(
                    width: 360,
                    height: 200,
                    child: FortalLineChart(
                      yAxis: ChartAxis.numeric(
                        min: 1050,
                        max: 1300,
                        interval: 50,
                        labelFormatter: (value) =>
                            '${(value / 1000).toStringAsFixed(3)}K',
                      ),
                      series: [_lineSeries()],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        // Every tick, such as "1.250K", must lay out as a single line.
        final ticks = tester.renderObjectList<RenderParagraph>(
          find.textContaining('K'),
        );
        expect(ticks, isNotEmpty);
        for (final tick in ticks) {
          expect(
            tick.size.height,
            tick.getMaxIntrinsicHeight(double.infinity),
            reason: '"${tick.text.toPlainText()}" wrapped',
          );
        }
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('Fortal chart widgets', () {
    test('forward recipe and chart constructor parameters', () {
      final line = FortalLineChart(
        highContrast: true,
        showMarkers: true,
        semanticsLabel: 'Revenue',
        series: [_lineSeries()],
      );
      final bar = FortalBarChart(
        highContrast: true,
        semanticsLabel: 'Orders',
        groups: [_barGroup()],
      );
      final pie = FortalPieChart(
        centerRadius: 40,
        showLabels: true,
        semanticsLabel: 'Channels',
        slices: [_pieSlice()],
      );

      expect(line.highContrast, isTrue);
      expect(line.showMarkers, isTrue);
      expect(line.semanticsLabel, 'Revenue');
      expect(bar.highContrast, isTrue);
      expect(bar.semanticsLabel, 'Orders');
      expect(pie.centerRadius, 40);
      expect(pie.showLabels, isTrue);
      expect(pie.semanticsLabel, 'Channels');
    });

    testWidgets('render through the mix_chart widgets', (tester) async {
      await tester.pumpWidget(
        FortalTheme(
          child: WidgetsApp(
            color: const Color(0xFFFFFFFF),
            pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
              settings: settings,
              pageBuilder: (context, _, _) => builder(context),
            ),
            home: Column(
              children: [
                SizedBox(
                  width: 360,
                  height: 180,
                  child: FortalLineChart(series: [_lineSeries()]),
                ),
                SizedBox(
                  width: 360,
                  height: 180,
                  child: FortalBarChart(groups: [_barGroup()]),
                ),
                SizedBox(
                  width: 360,
                  height: 180,
                  child: FortalPieChart(slices: [_pieSlice()]),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(FortalLineChart), findsOneWidget);
      expect(find.byType(FortalBarChart), findsOneWidget);
      expect(find.byType(FortalPieChart), findsOneWidget);
      expect(find.byType(LineChart), findsOneWidget);
      expect(find.byType(BarChart), findsOneWidget);
      expect(find.byType(PieChart), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('package boundary', () {
    test('Fortal does not import the private chart renderer', () {
      final sources = Directory('lib')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'));

      for (final source in sources) {
        expect(
          source.readAsStringSync(),
          isNot(contains('package:fl_chart')),
          reason: '${source.path} crosses the mix_chart renderer boundary',
        );
      }
    });

    test('mix_chart belongs to Fortal rather than core Remix', () {
      final fortalPubspec = File('pubspec.yaml').readAsStringSync();
      final remixPubspec = File(
        '../packages/remix/pubspec.yaml',
      ).readAsStringSync();

      expect(
        fortalPubspec,
        contains(RegExp(r'^name: registry_source$', multiLine: true)),
      );
      expect(
        fortalPubspec,
        contains(RegExp(r'^  mix_chart:', multiLine: true)),
      );
      expect(remixPubspec, isNot(contains('mix_chart:')));
    });
  });
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
