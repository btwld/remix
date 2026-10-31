import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_theme.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_theme_panel.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../helpers/pixels.dart';
import '../helpers/test_helpers.dart';

/// Pixel regressions for the shared Fortal ring and dashboard swatches.
void main() {
  late FocusHighlightStrategy previousStrategy;

  setUp(() {
    previousStrategy = FocusManager.instance.highlightStrategy;
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
  });

  tearDown(() => FocusManager.instance.highlightStrategy = previousStrategy);

  for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
    for (final radius in FortalRadius.values) {
      testWidgets('slider uses a clean token ring in ${mode.name} at '
          '${radius.name} radius', (tester) async {
        final node = FocusNode();
        addTearDown(node.dispose);
        final boundary = GlobalKey();
        await tester.pumpRemixApp(
          FortalTheme(
            mode: mode,
            radius: radius,
            child: RepaintBoundary(
              key: boundary,
              child: ColoredBox(
                color: const Color(0xFFFFFFFF),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: 200,
                    child: FortalSlider(
                      value: .5,
                      onChanged: (_) {},
                      focusNode: node,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        final idle = await capturePixels(tester, boundary);
        node.requestFocus();
        await tester.pump();
        final focused = await capturePixels(tester, boundary);
        final slider = find.byType(FortalSlider);
        final context = tester.element(slider);
        final spec = fortalSliderStyle().build(context).spec;
        final center = tester.getCenter(slider);
        final origin = tester.getTopLeft(find.byKey(boundary));
        final top = center.dy - spec.thumb.spec.constraints!.maxHeight / 2;
        Color pixel(Pixels pixels, double out) => pixels.at(
          ((center.dx - origin.dx) * pixelScale).round(),
          ((top - out - origin.dy) * pixelScale).round(),
        );
        expectNearColor(
          pixel(focused, 3),
          FortalTokens.focus8.resolve(context),
        );
        expectNearColor(pixel(focused, 1), pixel(idle, 1));
        expectNearColor(pixel(focused, 5), pixel(idle, 5));
      });
    }
  }

  group('accent swatch', () {
    // Selection and focus use the swatch theme's same token-driven outline.
    late GlobalKey panel;

    /// Pumps the panel the way the dashboard hosts it: the popover in a 400px
    /// vertical scroll view, the settings page in a horizontal one. A scroll
    /// view clips at the panel's own edge once the panel overflows it, so the
    /// vertical host is shorter than the panel. The margin around it lets a
    /// capture show what the clip removes.
    Future<void> pumpPanel(
      WidgetTester tester, {
      Map<SpaceToken, double>? ringTokens,
      Axis scroll = Axis.vertical,
    }) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      panel = GlobalKey();
      await tester.pumpRemixApp(
        RepaintBoundary(
          key: panel,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: 400,
              height: scroll == Axis.vertical ? 300 : null,
              child: MixScope.inherit(
                spaces: ringTokens,
                child: FortalDashboardThemeScope(
                  settings: const FortalThemeSettings(),
                  onChanged: (_) {},
                  child: SingleChildScrollView(
                    scrollDirection: scroll,
                    child: const FortalThemePanel(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    void focusSwatch(WidgetTester tester, String accent) {
      final check = find.descendant(
        of: find.byKey(ValueKey('accent-$accent')),
        matching: find.byIcon(RemixIcons.check),
      );
      Focus.of(tester.element(check)).requestFocus();
    }

    /// Captures the panel and returns the color [out] logical pixels past the
    /// right edge of [accent]'s swatch, or its left edge when [left].
    Future<Color Function(double out)> probe(
      WidgetTester tester,
      String accent, {
      bool left = false,
    }) async {
      final pixels = await capturePixels(tester, panel);
      final swatch = find.byKey(ValueKey('accent-$accent'));
      final center = tester.getCenter(swatch);
      final origin = tester.getTopLeft(find.byKey(panel));
      final radius = tester.getSize(swatch).width / 2;
      final y = ((center.dy - origin.dy) * pixelScale).round();
      return (out) => pixels.at(
        ((center.dx - origin.dx + (left ? -1 : 1) * (radius + out)) *
                pixelScale)
            .round(),
        y,
      );
    }

    // At the default tokens the gap is 0-2px out, the ring 2-4px, and the page
    // is beyond: 1, 3 and 5 are the centers.
    testWidgets('an idle swatch draws no ring', (tester) async {
      await pumpPanel(tester);

      final at = await probe(tester, 'mangue');

      expect(at(1), at(5));
      expect(at(3), at(5));
    });

    testWidgets('the selected swatch uses focus8, 2px off its edge', (
      tester,
    ) async {
      await pumpPanel(tester);

      final at = await probe(tester, 'calcadao');

      expect(at(1), at(5));
      expectNearColor(
        at(3),
        FortalTokens.focus8.resolve(
          tester.element(find.byKey(const ValueKey('accent-calcadao'))),
        ),
      );
    });

    testWidgets('a focused swatch rings in its step-8 focus token', (
      tester,
    ) async {
      await pumpPanel(tester);
      focusSwatch(tester, 'mangue');
      await tester.pump();

      final at = await probe(tester, 'mangue');

      expect(at(1), at(5));
      expectNearColor(
        at(3),
        FortalTokens.focus8.resolve(
          tester.element(find.byKey(const ValueKey('accent-mangue'))),
        ),
      );
    });

    testWidgets('focus stays visible on the selected swatch', (tester) async {
      await pumpPanel(tester);
      focusSwatch(tester, 'calcadao');
      await tester.pump();

      final at = await probe(tester, 'calcadao');

      expectNearColor(
        at(3),
        FortalTokens.focus8.resolve(
          tester.element(find.byKey(const ValueKey('accent-calcadao'))),
        ),
      );
    });

    testWidgets('the ring shows on the first column of the panel', (
      tester,
    ) async {
      await pumpPanel(tester);
      focusSwatch(tester, 'calcadao');
      await tester.pump();

      final at = await probe(tester, 'calcadao', left: true);

      expectNearColor(
        at(3),
        FortalTokens.focus8.resolve(
          tester.element(find.byKey(const ValueKey('accent-calcadao'))),
        ),
      );
    });

    testWidgets('the ring does not change the swatch layout', (tester) async {
      await pumpPanel(tester);
      final swatch = find.byKey(const ValueKey('accent-mangue'));
      final idle = tester.getRect(swatch);

      focusSwatch(tester, 'mangue');
      await tester.pump();

      expect(tester.getRect(swatch), idle);
    });

    testWidgets('a wider and farther ring still clears the panel edge', (
      tester,
    ) async {
      await pumpPanel(
        tester,
        ringTokens: {
          FortalTokens.focusRingWidth: 3,
          FortalTokens.focusRingOffset: 3,
        },
      );
      focusSwatch(tester, 'calcadao');
      await tester.pump();

      // The gap is 0-3px out, the ring 3-6px, and the page is beyond.
      final at = await probe(tester, 'calcadao', left: true);

      expect(at(1.5), at(7));
      expect(at(2.5), at(7));
      expectNearColor(
        at(3.5),
        FortalTokens.focus8.resolve(
          tester.element(find.byKey(const ValueKey('accent-calcadao'))),
        ),
      );
      expectNearColor(
        at(5.5),
        FortalTokens.focus8.resolve(
          tester.element(find.byKey(const ValueKey('accent-calcadao'))),
        ),
      );
      expect(at(6.5), at(7));
    });

    for (final (width, offset) in [(2.0, 2.0), (3.0, 3.0), (2.0, -3.0)]) {
      testWidgets('the panel content stays 360 wide at ring width $width and '
          'offset $offset', (tester) async {
        await pumpPanel(
          tester,
          scroll: Axis.horizontal,
          ringTokens: {
            FortalTokens.focusRingWidth: width,
            FortalTokens.focusRingOffset: offset,
          },
        );

        final content = find.descendant(
          of: find.byKey(const ValueKey('theme-panel')),
          matching: find.byType(ColumnBox),
        );

        expect(tester.getSize(content.first).width, 360);
      });
    }

    for (final offset in [0.0, 2.0, -3.0]) {
      testWidgets('a zero-width ring draws nothing at offset $offset', (
        tester,
      ) async {
        await pumpPanel(
          tester,
          ringTokens: {
            FortalTokens.focusRingWidth: 0,
            FortalTokens.focusRingOffset: offset,
          },
        );
        focusSwatch(tester, 'mangue');
        await tester.pump();

        expect(tester.takeException(), isNull);
        // Calçadão is selected and Mangue is focused.
        for (final accent in ['calcadao', 'mangue']) {
          final at = await probe(tester, accent);
          for (final out in [0.5, 1.0, 2.0, 3.0, 4.0]) {
            expect(at(out), at(6), reason: '$accent $out px out');
          }
        }
      });
    }
  });
}
