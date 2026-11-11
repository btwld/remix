import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix_ui_fonts/remix_ui_fonts.dart';

import '../../helpers/contrast.dart';
import '../../helpers/pixels.dart';

void main() {
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

    group('series colours', () {
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

      // WCAG 1.4.11: a series is a graphical object needed to read the
      // chart, so it needs 3:1 on everything a chart sits on.
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
            // Sol's luminous light mark fill is 1.55:1 on the page; its
            // first source step that reaches 3:1 there is step 11.
            final expected = accent == .sol && mode == .light
                ? colors.accent.scale.step(11)
                : colors.accent.indicator;
            expect(palette.first, expected, reason: '${accent.name} $mode');
          }
        }
      });

      // WCAG 1.4.3: a slice label is 12px text, so it needs 4.5:1 on its
      // slice. Measured lowest: 4.61:1, ink on light-mode Sol amber step 11.
      testWidgets('slice labels read on every series colour', (tester) async {
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

      // Most charts show four series or fewer, so those must be the most
      // distinct. OKLab distance; gray beside gold is 0.054 and gold beside
      // brown 0.037, the closest pairs among the families.
      testWidgets('the first four series stay distinct and gray is last', (
        tester,
      ) async {
        for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
          for (final accent in FortalAccentColor.values) {
            final (palette, colors) = await resolve(tester, accent, mode);
            final lead = palette.take(4).toList();
            for (var i = 0; i < lead.length; i++) {
              for (var j = i + 1; j < lead.length; j++) {
                expect(
                  _oklabDistance(lead[i], lead[j]),
                  greaterThan(0.12),
                  reason: '${accent.name} $mode: series ${i + 1} and ${j + 1}',
                );
              }
            }
            if (accent != .orla) {
              final gray = mode == .dark ? orla.dark.scale : orla.light.scale;
              expect(palette.last, gray.step(9), reason: '${accent.name}');
            }
          }
        }
      });

      // Measured with this palette: the lowest WCAG ratio of each series on
      // the page and the solid panel. Raw step 9 left Mar teal at 2.91,
      // Caju orange at 2.81 and Sol amber at 1.50 on the light panel.
      testWidgets('records the light Mar and Sol palettes', (tester) async {
        const recorded = {
          FortalAccentColor.mar: [
            (Color(0xFF04A190), 3.05),
            (Color(0xFFEF5F00), 3.15),
            (Color(0xFF0090FF), 3.09),
            (Color(0xFF978365), 3.45),
            (Color(0xFFAB6400), 4.36),
            (Color(0xFFAD7F58), 3.34),
            (Color(0xFF8D8D8D), 3.14),
          ],
          FortalAccentColor.sol: [
            (Color(0xFFAB6400), 4.38),
            (Color(0xFF0D9B8A), 3.28),
            (Color(0xFFEF5F00), 3.16),
            (Color(0xFF0090FF), 3.10),
            (Color(0xFF978365), 3.47),
            (Color(0xFFAD7F58), 3.35),
            (Color(0xFF8D8D8D), 3.15),
          ],
        };
        for (final MapEntry(key: accent, value: expected) in recorded.entries) {
          final (palette, colors) = await resolve(tester, accent, .light);
          expect(palette, [for (final (color, _) in expected) color]);
          for (final (index, (color, ratio)) in expected.indexed) {
            final lowest = [
              colors.colorBackground,
              colors.colorPanelSolid,
            ].map((surface) => contrastRatio(color, surface)).reduce(math.min);
            expect(
              lowest,
              moreOrLessEquals(ratio, epsilon: 0.005),
              reason: '${accent.name} series ${index + 1}',
            );
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

    testWidgets('line value ticks sit on the values they name', (tester) async {
      const height = 200.0;
      final chart = GlobalKey();

      await tester.pumpWidget(
        _ChartHost(
          child: SizedBox(
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
        _ChartHost(
          child: SizedBox(
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

    for (final scaling in FortalScaling.values) {
      testWidgets(
        'value-axis ticks stay on one line at ${scaling.name} scaling',
        (tester) async {
          // The ticks fl_chart 1.3 prints for a 1088 to 1284 series: three
          // fraction digits for a 50 interval, trailing zeros dropped. The
          // six-character extremes wrapped in the package's fixed 44px.
          String tick(double value) {
            final digits = (value / 1000).toStringAsFixed(3);
            return '${digits.replaceFirst(RegExp(r'\.?0+$'), '')}K';
          }

          await tester.pumpWidget(
            _ChartHost(
              scaling: scaling,
              child: SizedBox(
                height: 200,
                child: FortalLineChart(
                  yAxis: ChartAxis.numeric(interval: 50, labelFormatter: tick),
                  series: [
                    LineSeries(
                      id: 'teams',
                      label: 'Teams',
                      points: [
                        for (final (index, y) in const [
                          1088.0,
                          1150.0,
                          1284.0,
                        ].indexed)
                          ChartPoint(id: index, x: index.toDouble(), y: y),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
          await tester.pump();

          final lineHeight = 16 * scaling.factor;
          final ticks = tester
              .renderObjectList<RenderParagraph>(find.textContaining('K'))
              .toList();
          expect(
            ticks.map((tick) => tick.text.toPlainText()),
            containsAll(['1.088K', '1.284K']),
          );
          for (final paragraph in ticks) {
            expect(
              paragraph.size.height,
              lessThan(lineHeight * 1.5),
              reason:
                  '"${paragraph.text.toPlainText()}" wrapped onto a second line',
            );
          }
          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets('a donut hole shows the surface the chart sits on', (
      tester,
    ) async {
      final key = GlobalKey();
      late Color page;

      await tester.pumpWidget(
        _ChartHost(
          child: Builder(
            builder: (context) {
              page = FortalTokens.colorBackground.resolve(context);
              return Center(
                child: RepaintBoundary(
                  key: key,
                  child: ColoredBox(
                    color: page,
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
              );
            },
          ),
        ),
      );
      await tester.pump();

      final pixels = await capturePixels(tester, key);
      expectNearColor(pixels.at(80 * pixelScale, 80 * pixelScale), page);
    });
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

/// A Fortal page with the Geist face, so label widths match an application.
class _ChartHost extends StatelessWidget {
  const _ChartHost({required this.child, this.scaling = .percent100});

  final FortalScaling scaling;
  final Widget child;

  @override
  Widget build(BuildContext context) => FortalTheme(
    scaling: scaling,
    mode: .light,
    child: Directionality(
      textDirection: .ltr,
      child: DefaultTextStyle(
        style: const TextStyle(fontFamily: RemixFonts.geist),
        child: Align(
          alignment: .topLeft,
          child: SizedBox(width: 360, child: child),
        ),
      ),
    ),
  );
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

/// Euclidean distance between two colors in Björn Ottosson's OKLab.
double _oklabDistance(Color a, Color b) {
  List<double> lab(Color color) {
    double linear(double c) => c <= 0.04045
        ? c / 12.92
        : math.pow((c + 0.055) / 1.055, 2.4).toDouble();
    final r = linear(color.r);
    final g = linear(color.g);
    final b = linear(color.b);
    final l = math.pow(
      0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b,
      1 / 3,
    );
    final m = math.pow(
      0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b,
      1 / 3,
    );
    final s = math.pow(
      0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b,
      1 / 3,
    );
    return [
      0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s,
      1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s,
      0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s,
    ];
  }

  final x = lab(a);
  final y = lab(b);
  return math.sqrt(
    math.pow(x[0] - y[0], 2) +
        math.pow(x[1] - y[1], 2) +
        math.pow(x[2] - y[2], 2),
  );
}
