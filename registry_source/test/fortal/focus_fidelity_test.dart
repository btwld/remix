import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_theme.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_theme_panel.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../helpers/test_helpers.dart';

/// Shared Fortal control rings and the dashboard accent swatch ring.
void main() {
  late FocusHighlightStrategy previousStrategy;

  setUp(() {
    previousStrategy = FocusManager.instance.highlightStrategy;
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
  });

  tearDown(() => FocusManager.instance.highlightStrategy = previousStrategy);

  testWidgets('every radio variant uses the shared focus color', (
    tester,
  ) async {
    final (rings, focus8) = await _resolveFocused(
      tester,
      (context) => (
        {
          for (final variant in FortalRadioVariant.values)
            variant: fortalRadioStyle(
              variant: variant,
            ).build(context).spec.containerEffects!.outline.color,
        },
        MixScope.tokenOf(FortalTokens.focus8, context),
      ),
    );

    expect(rings, {
      FortalRadioVariant.surface: focus8,
      FortalRadioVariant.soft: focus8,
    });
  });

  testWidgets('every select variant follows an overridden focus color', (
    tester,
  ) async {
    // Distinct overrides catch recipes accidentally using the accent token.
    const focusOverride = Color(0xFFFF00FF);
    final rings = await _resolveFocused(
      tester,
      colors: {FortalTokens.focus8: focusOverride},
      (context) => {
        for (final variant in FortalSelectVariant.values)
          variant: fortalSelectStyle(
            variant: variant,
          ).build(context).spec.trigger.spec.containerEffects!.outline.color,
      },
    );

    expect(rings, {
      FortalSelectVariant.surface: focusOverride,
      FortalSelectVariant.soft: focusOverride,
      FortalSelectVariant.ghost: focusOverride,
    });
  });

  group('slider thumb', () {
    testWidgets('uses the shared ring without a thumb halo', (tester) async {
      for (final variant in FortalSliderVariant.values) {
        final (ring, focus8) = await _resolveFocused(
          tester,
          (context) => (
            fortalSliderStyle(
              variant: variant,
            ).build(context).spec.thumbFocusEffects!,
            FortalTokens.focus8.resolve(context),
          ),
        );
        final reason = '$variant';
        expect(ring.overContent?.shadows ?? const [], isEmpty, reason: reason);
        expect(
          ring.behindContent?.shadows ?? const [],
          isEmpty,
          reason: reason,
        );
        expect(ring.outline.color, focus8, reason: reason);
        expect(ring.outline.width, 2, reason: reason);
        expect(ring.outlineOffset, 2, reason: reason);
      }
    });

    for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
      for (final radius in FortalRadius.values) {
        testWidgets(
          'keeps the thumb 2px edge inside the shared ring at ${radius.name} radius '
          'in ${mode.name} mode',
          (tester) async {
            final node = FocusNode();
            addTearDown(node.dispose);
            final slider = GlobalKey();
            await tester.pumpRemixApp(
              FortalTheme(
                mode: mode,
                radius: radius,
                child: RepaintBoundary(
                  key: slider,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: SizedBox(
                      width: 200,
                      child: FortalSlider(
                        value: 0.5,
                        onChanged: (_) {},
                        focusNode: node,
                      ),
                    ),
                  ),
                ),
              ),
            );
            node.requestFocus();
            await tester.pump();

            final context = tester.element(find.byType(FortalSlider));
            final edgeColor = FortalTokens.accentThumbRing.resolve(context);
            final focus8 = MixScope.tokenOf(FortalTokens.focus8, context);
            final pixels = await _capture(tester, slider);
            final thumb = tester.getCenter(find.byType(FortalSlider));
            final origin = tester.getTopLeft(find.byKey(slider));

            // Sample the 2px border, 2px clear gap and 2px shared ring
            // along the thumb's center column at four device pixels per px.
            var y = ((thumb.dy - origin.dy) * _scale).round();
            final x = ((thumb.dx - origin.dx) * _scale).round();
            while (pixels.at(x, y) == const Color(0xFFFFFFFF)) {
              y--;
            }
            final edge = y - _scale;
            final gap = y - 3 * _scale;
            final ring = y - 5 * _scale;

            _expectNear(pixels.at(x, edge), edgeColor);
            // The capture excludes the theme background, so the gap is clear.
            expect(pixels.at(x, gap), const Color(0x00000000));
            _expectNear(pixels.at(x, ring), focus8);
          },
        );
      }
    }
  });

  group('accent swatch', () {
    // A swatch draws
    //   outline-offset: 2px; outline-width: 2px;
    // and nothing until it is selected (gray-12) or focus-visible (focus-8).
    // Focus uses the panel's shared control ring color and takes precedence
    // over selection, regardless of the swatch's own accent.
    late GlobalKey panel;

    /// Pumps the panel the way the dashboard hosts it: the popover in a 400px
    /// vertical scroll view, the settings page in a horizontal one. A scroll
    /// view clips at the panel's own edge once the panel overflows it, so the
    /// vertical host is shorter than the panel. The margin around it lets a
    /// capture show what the clip removes.
    Future<void> pumpPanel(
      WidgetTester tester, {
      Map<SpaceToken, double>? ringTokens,
      Map<ColorToken, Color>? colors,
      FortalThemeMode mode = FortalThemeMode.light,
      Axis scroll = Axis.vertical,
    }) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      panel = GlobalKey();
      await tester.pumpRemixApp(
        FortalTheme(
          mode: mode,
          child: RepaintBoundary(
            key: panel,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: 400,
                height: scroll == Axis.vertical ? 300 : null,
                child: MixScope.inherit(
                  spaces: ringTokens,
                  colors: colors,
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
        ),
      );
    }

    Color panelToken(WidgetTester tester, ColorToken token) =>
        MixScope.tokenOf(token, tester.element(find.byType(FortalThemePanel)));

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
      final pixels = await _capture(tester, panel);
      final swatch = find.byKey(ValueKey('accent-$accent'));
      final center = tester.getCenter(swatch);
      final origin = tester.getTopLeft(find.byKey(panel));
      final radius = tester.getSize(swatch).width / 2;
      final y = ((center.dy - origin.dy) * _scale).round();
      return (out) => pixels.at(
        ((center.dx - origin.dx + (left ? -1 : 1) * (radius + out)) * _scale)
            .round(),
        y,
      );
    }

    // At Fortal's defaults the gap is 0-2px out, the ring 2-4px, and the page
    // is beyond: 1, 3 and 5 are the centers.
    testWidgets('an idle swatch draws no ring', (tester) async {
      await pumpPanel(tester);

      final at = await probe(tester, 'serra');

      expect(at(1), at(5));
      expect(at(3), at(5));
    });

    testWidgets('the selected swatch rings in gray-12, 2px off its edge', (
      tester,
    ) async {
      await pumpPanel(tester);

      final at = await probe(tester, 'calcadao');

      expect(at(1), at(5));
      _expectNear(at(3), panelToken(tester, FortalTokens.gray12));
    });

    testWidgets('a focused swatch uses the panel shared focus color', (
      tester,
    ) async {
      await pumpPanel(tester);
      focusSwatch(tester, 'serra');
      await tester.pump();

      final at = await probe(tester, 'serra');

      expect(at(1), at(5));
      _expectNear(at(3), panelToken(tester, FortalTokens.focus8));
    });

    for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
      for (final accent in ['serra', 'calcadao']) {
        testWidgets('a focused $accent swatch follows the shared ring override '
            'in ${mode.name} mode', (tester) async {
          const focusColor = Color(0xFFFF00FF);
          const accentColor = Color(0xFF00FFFF);
          await pumpPanel(
            tester,
            mode: mode,
            colors: {
              FortalTokens.focus8: focusColor,
              FortalTokens.accent9: accentColor,
            },
          );
          focusSwatch(tester, accent);
          await tester.pump();

          final context = tester.element(find.byType(FortalThemePanel));
          final sharedRing = fortalFocusOutline().resolve(context);
          expect(sharedRing.outline.color, focusColor);
          expect(panelToken(tester, FortalTokens.accent9), accentColor);
          final at = await probe(tester, accent);
          expect(at(1), at(5));
          _expectNear(at(3), focusColor);
        });
      }
    }

    testWidgets('focus stays visible on the selected swatch', (tester) async {
      await pumpPanel(tester);
      focusSwatch(tester, 'calcadao');
      await tester.pump();

      final at = await probe(tester, 'calcadao');

      _expectNear(at(3), panelToken(tester, FortalTokens.focus8));
    });

    testWidgets('the ring shows on the first column of the panel', (
      tester,
    ) async {
      await pumpPanel(tester);
      focusSwatch(tester, 'calcadao');
      await tester.pump();

      final at = await probe(tester, 'calcadao', left: true);

      _expectNear(at(3), panelToken(tester, FortalTokens.focus8));
    });

    testWidgets('the ring does not change the swatch layout', (tester) async {
      await pumpPanel(tester);
      final swatch = find.byKey(const ValueKey('accent-serra'));
      final idle = tester.getRect(swatch);

      focusSwatch(tester, 'serra');
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
      _expectNear(at(3.5), panelToken(tester, FortalTokens.focus8));
      _expectNear(at(5.5), panelToken(tester, FortalTokens.focus8));
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
        focusSwatch(tester, 'serra');
        await tester.pump();

        expect(tester.takeException(), isNull);
        // Calçadão is selected and Serra is focused.
        for (final accent in ['calcadao', 'serra']) {
          final at = await probe(tester, accent);
          for (final out in [0.5, 1.0, 2.0, 3.0, 4.0]) {
            expect(at(out), at(6), reason: '$accent $out px out');
          }
        }
      });
    }
  });
}

/// Pixels per logical pixel in [_capture].
const _scale = 4;

/// An RGBA capture of a repaint boundary.
final class _Pixels {
  const _Pixels(this._data, this._width);

  final ByteData _data;
  final int _width;

  Color at(int x, int y) {
    final offset = (y * _width + x) * 4;
    return Color.fromARGB(
      _data.getUint8(offset + 3),
      _data.getUint8(offset),
      _data.getUint8(offset + 1),
      _data.getUint8(offset + 2),
    );
  }
}

/// Renders the repaint boundary at [key] at [_scale] times its logical size.
Future<_Pixels> _capture(WidgetTester tester, GlobalKey key) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(key));
  return (await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: _scale.toDouble());
    final data = (await image.toByteData())!;
    return _Pixels(data, image.width);
  }))!;
}

/// Passes when every channel of [actual] is within 2/255 of [expected].
void _expectNear(Color actual, Color expected) {
  for (final (name, a, e) in [
    ('red', actual.r, expected.r),
    ('green', actual.g, expected.g),
    ('blue', actual.b, expected.b),
    ('alpha', actual.a, expected.a),
  ]) {
    expect(
      (a - e).abs() * 255,
      lessThanOrEqualTo(2),
      reason: '$name of $actual is not near $expected',
    );
  }
}

/// Reads [read] under [FortalTheme] with the focused state forced on and, when
/// given, [colors] overriding tokens.
Future<T> _resolveFocused<T>(
  WidgetTester tester,
  T Function(BuildContext context) read, {
  Map<ColorToken, Color>? colors,
}) async {
  late T result;
  await tester.pumpWidget(
    FortalTheme(
      child: MixScope.inherit(
        colors: colors,
        child: WidgetStateProvider(
          states: const {WidgetState.focused},
          child: Builder(
            builder: (context) {
              result = read(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    ),
  );
  return result;
}
