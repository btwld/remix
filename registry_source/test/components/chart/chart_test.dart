import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/vanilla.dart' as vanilla;
import 'package:remix_ui_fonts/remix_ui_fonts.dart';

import '../../helpers/contrast.dart';
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
      expect(spec.palette!.first, colors.accent.indicator);
      expect(spec.palette, hasLength(greaterThanOrEqualTo(7)));
      expect(spec.palette!.toSet(), hasLength(spec.palette!.length));
      expect(
        spec.grid!.spec.stroke!.spec.color,
        colors.gray.scale.alphaStep(5),
      );
      expect(spec.tooltip!.spec.backgroundColor, colors.colorPanelSolid);
    });

    group('series colors', () {
      Future<(List<Color>, FortalThemeColors)> resolve(
        WidgetTester tester,
        FortalAccentColor accent,
        FortalThemeMode mode,
      ) async {
        late List<Color> palette;
        late FortalThemeColors colors;
        await tester.pumpWidget(
          FortalTheme(
            accent: accent,
            mode: mode,
            child: Builder(
              builder: (context) {
                palette = resolveFortalChartPalette(context);
                colors = resolveFortalTokens(FortalTheme.of(context));
                return const SizedBox();
              },
            ),
          ),
        );
        return (palette, colors);
      }

      // WCAG 1.4.11: a series needs 3:1 on everything a chart sits on.
      for (final mode in FortalThemeMode.values.where((m) => m != .system)) {
        for (final accent in FortalAccentColor.values) {
          testWidgets('${accent.name} ${mode.name}: 3:1 on page and panels', (
            tester,
          ) async {
            final (palette, colors) = await resolve(tester, accent, mode);
            final surfaces = {
              'page': colors.colorBackground,
              'solid panel': colors.colorPanelSolid,
              'translucent panel': Color.alphaBlend(
                colors.colorPanelTranslucent,
                colors.colorBackground,
              ),
            };

            expect(palette, hasLength(7));
            expect(palette.toSet(), hasLength(7));
            for (final (index, color) in palette.indexed) {
              for (final MapEntry(key: name, value: surface)
                  in surfaces.entries) {
                expect(
                  contrastRatio(color, surface),
                  greaterThanOrEqualTo(3),
                  reason: 'series ${index + 1} ($color) on the $name',
                );
              }
            }
            // The accent's own family is not repeated after its mark fill.
            final own = colors.accent.scale;
            for (final color in palette.skip(1)) {
              for (var step = 9; step <= 12; step++) {
                expect(color, isNot(own.step(step)));
              }
            }
          });
        }
      }

      testWidgets('the first series is the accent mark fill', (tester) async {
        for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
          for (final accent in FortalAccentColor.values) {
            final (palette, colors) = await resolve(tester, accent, mode);
            // Sol's light mark fill is too pale for 3:1 on the page, so its
            // series takes a deeper step of the same scale.
            final expected = accent == .sol && mode == .light
                ? colors.accent.scale.step(11)
                : colors.accent.indicator;
            expect(palette.first, expected, reason: '${accent.name} $mode');
          }
        }
      });

      // WCAG 1.4.3: 12px label text needs 4.5:1 on its slice.
      testWidgets('slice labels read on every series color', (tester) async {
        for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
          for (final accent in FortalAccentColor.values) {
            late List<Color> colors;
            await tester.pumpWidget(
              FortalTheme(
                accent: accent,
                mode: mode,
                child: Builder(
                  builder: (context) {
                    colors = [
                      ...resolveFortalChartPalette(context),
                      ...resolveFortalChartPalette(context, highContrast: true),
                    ];
                    return const SizedBox();
                  },
                ),
              ),
            );
            for (final slice in colors) {
              expect(
                contrastRatio(fortalPieSliceLabelColor(slice), slice),
                greaterThanOrEqualTo(4.5),
                reason: '${accent.name} $mode: label on $slice',
              );
            }
          }
        }
      });

      testWidgets('families follow the accent in order, gray last', (
        tester,
      ) async {
        const order = {
          FortalAccentColor.mar: mar,
          FortalAccentColor.caju: caju,
          FortalAccentColor.ceu: ceu,
          FortalAccentColor.serra: serra,
          FortalAccentColor.sol: sol,
          FortalAccentColor.duna: duna,
          FortalAccentColor.orla: orla,
        };
        for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
          for (final accent in FortalAccentColor.values) {
            final (palette, _) = await resolve(tester, accent, mode);
            final families = [
              for (final MapEntry(key: name, value: family) in order.entries)
                if (name != accent) (name, family),
            ];
            for (final (index, (name, family)) in families.indexed) {
              final scale = mode == .dark
                  ? family.dark.scale
                  : family.light.scale;
              expect(
                [for (var step = 9; step <= 12; step++) scale.step(step)],
                contains(palette[index + 1]),
                reason:
                    '${accent.name} $mode: series ${index + 2} is ${name.name}',
              );
            }
          }
        }
      });
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

    testWidgets('line value ticks sit on the values they name', (tester) async {
      const height = 200.0;
      final chart = GlobalKey();

      await tester.pumpWidget(
        _onPage(
          SizedBox(
            key: chart,
            height: height,
            child: FortalLineChart(
              yAxis: ChartAxis.numeric(
                min: 0,
                max: 10,
                interval: 5,
                labelFormatter: (value) => '${value.round()}',
              ),
              xAxis: ChartAxis.numeric(labelFormatter: (_) => ''),
              series: [
                LineSeries(
                  id: 'a',
                  label: 'A',
                  points: [
                    ChartPoint(id: 0, x: 0, y: 0),
                    ChartPoint(id: 1, x: 1, y: 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      // The plot spans the chart's top to the bottom axis's 30px band, so 10
      // is at the top edge, 5 halfway and 0 at the bottom edge.
      final top = tester.getTopLeft(find.byKey(chart)).dy;
      const plot = height - 30;
      for (final (label, y) in [('10', 0.0), ('5', plot / 2), ('0', plot)]) {
        expect(
          tester.getCenter(find.text(label)).dy - top,
          moreOrLessEquals(y, epsilon: 0.5),
          reason: 'the $label tick is drawn off its value',
        );
      }
    });

    testWidgets('bar value ticks stay inside the clipped bar chart', (
      tester,
    ) async {
      final chart = GlobalKey();

      await tester.pumpWidget(
        _onPage(
          SizedBox(
            key: chart,
            height: 200,
            child: FortalBarChart(
              yAxis: ChartAxis.numeric(
                min: 0,
                max: 10,
                interval: 5,
                labelFormatter: (value) => '${value.round()}',
              ),
              groups: [
                BarGroup(
                  id: 'q1',
                  label: 'Q1',
                  bars: [BarValue(id: 'a', label: 'A', toY: 10)],
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      final bounds = tester.getRect(find.byKey(chart));
      for (final label in ['10', '5', '0']) {
        final rect = tester.getRect(find.text(label));
        expect(
          rect.top >= bounds.top - 0.5 && rect.bottom <= bounds.bottom + 0.5,
          isTrue,
          reason: 'the $label tick is cut by the bar chart clip',
        );
      }
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
      for (final isBar in [false, true]) {
        testWidgets(
          '${isBar ? 'bar' : 'line'} ticks fit long values at ${scaling.name}',
          (tester) async {
            final axis = ChartAxis.numeric(
              min: 1050,
              max: 1300,
              interval: 50,
              labelFormatter: (value) => 'USD ${value.toStringAsFixed(2)}',
            );
            final chart = isBar
                ? FortalBarChart(yAxis: axis, groups: [_barGroup()])
                : FortalLineChart(yAxis: axis, series: [_lineSeries()]);

            await tester.pumpWidget(
              FortalTheme(
                scaling: scaling,
                child: Directionality(
                  textDirection: .ltr,
                  child: DefaultTextStyle(
                    style: const TextStyle(fontFamily: RemixFonts.geist),
                    child: Align(
                      alignment: .topLeft,
                      child: SizedBox(width: 360, height: 200, child: chart),
                    ),
                  ),
                ),
              ),
            );
            await tester.pump();

            final ticks = tester.renderObjectList<RenderParagraph>(
              find.textContaining('USD'),
            );
            expect(ticks, isNotEmpty);
            for (final tick in ticks) {
              expect(
                tick.size.height,
                tick.getMaxIntrinsicHeight(double.infinity),
                reason: '"${tick.text.toPlainText()}" wrapped',
              );
              expect(
                tick.size.width,
                greaterThanOrEqualTo(
                  tick.getMaxIntrinsicWidth(double.infinity) - 0.5,
                ),
                reason: '"${tick.text.toPlainText()}" was clipped',
              );
            }
            expect(tester.takeException(), isNull);
          },
        );
      }
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

  for (final isFortal in [false, true]) {
    testWidgets(
      '${isFortal ? 'Fortal' : 'Vanilla'} chart formatters reach semantics',
      (tester) async {
        final semantics = tester.ensureSemantics();
        try {
          String format(double value) => 'USD ${value.round()}';

          final charts = Column(
            children: [
              SizedBox(
                width: 360,
                height: 180,
                child: isFortal
                    ? FortalLineChart(
                        semanticsLabel: 'Line revenue',
                        valueFormatter: format,
                        series: [_lineSeries()],
                      )
                    : vanilla.VanillaLineChart(
                        semanticsLabel: 'Line revenue',
                        valueFormatter: format,
                        series: [_lineSeries()],
                      ),
              ),
              SizedBox(
                width: 360,
                height: 180,
                child: isFortal
                    ? FortalBarChart(
                        semanticsLabel: 'Bar orders',
                        valueFormatter: format,
                        groups: [_barGroup()],
                      )
                    : vanilla.VanillaBarChart(
                        semanticsLabel: 'Bar orders',
                        valueFormatter: format,
                        groups: [_barGroup()],
                      ),
              ),
            ],
          );
          final app = WidgetsApp(
            color: const Color(0xFFFFFFFF),
            pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
              settings: settings,
              pageBuilder: (context, _, _) => builder(context),
            ),
            home: charts,
          );
          await tester.pumpWidget(
            isFortal
                ? FortalTheme(child: app)
                : vanilla.VanillaTheme(child: app),
          );
          await tester.pump();

          for (final (label, value) in [
            ('Line revenue', 'USD 18'),
            ('Bar orders', 'USD 42'),
          ]) {
            expect(
              tester
                  .getSemantics(find.bySemanticsLabel(label))
                  .getSemanticsData()
                  .value,
              contains(value),
            );
          }
          expect(tester.takeException(), isNull);
        } finally {
          semantics.dispose();
        }
      },
    );
  }

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

/// [chart] on a light Fortal page, 360px wide.
Widget _onPage(Widget chart) => FortalTheme(
  mode: .light,
  child: Directionality(
    textDirection: .ltr,
    child: Align(
      alignment: .topLeft,
      child: SizedBox(width: 360, child: chart),
    ),
  ),
);

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
