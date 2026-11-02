import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';

import '../helpers/contrast.dart';
import '../helpers/test_helpers.dart';

void main() {
  final source =
      jsonDecode(File('specs/fortal_radix_colors.json').readAsStringSync())
          as Map<String, dynamic>;
  const pairs = {
    'orla': ('gray', 'gray'),
    'mar': ('teal', 'sage'),
    'ceu': ('blue', 'slate'),
    'serra': ('gold', 'olive'),
    'sol': ('amber', 'sand'),
    'duna': ('brown', 'sand'),
    'caju': ('orange', 'sand'),
  };

  Color sourceColor(String value) {
    final number = int.parse(value.substring(1), radix: 16);
    return value.length == 7
        ? Color(0xff000000 | number)
        : Color((number & 0xff) << 24 | number >> 8);
  }

  test('the approved theme combinations match the pinned source inventory', () {
    expect(FortalAccentColor.values.map((value) => value.name), pairs.keys);
    expect((source['source'] as Map)['version'], '3.0.0');
    for (final entry in pairs.entries) {
      expect((source['pairs'] as Map)[entry.key], {
        'accent': entry.value.$1,
        'neutral': entry.value.$2,
      });
    }
  });

  for (final dark in [false, true]) {
    testWidgets('Orla ${dark ? 'dark' : 'light'} primary roles stay distinct', (
      tester,
    ) async {
      final colors = dark ? orla.dark : orla.light;
      final fill = dark ? const Color(0xffffffff) : const Color(0xff202020);
      final hover = dark ? const Color(0xffeeeeee) : const Color(0xff303030);
      final ink = dark ? const Color(0xff111111) : const Color(0xffffffff);
      expect(colors.solid, fill);
      expect(colors.solidHover, hover);
      expect(colors.indicator, fill);
      expect(colors.track, fill);
      expect(colors.markHover, hover);
      expect(colors.contrast, ink);
      expect(computeAccentIndicatorContrast(colors), ink);
      final buttonFills = <Color>[];
      for (final state in [null, WidgetState.hovered, WidgetState.pressed]) {
        final spec = await resolveInFortalTheme(
          tester,
          (context) => fortalButtonStyle().build(context).spec,
          accent: .orla,
          mode: dark ? .dark : .light,
          states: {?state},
        );
        final actual =
            (spec.container.spec.box!.spec.decoration as BoxDecoration).color!;
        buttonFills.add(actual);
        expect(
          contrastRatio(spec.label.spec.style!.color!, actual),
          greaterThanOrEqualTo(4.5),
        );
      }
      expect(buttonFills.toSet(), hasLength(3));
      expect(buttonFills.first, fill);
      expect(buttonFills[1], hover);
      for (final pressed in [false, true]) {
        final spec = await resolveInFortalTheme(
          tester,
          (context) => fortalSwitchStyle().build(context).spec,
          accent: .orla,
          mode: dark ? .dark : .light,
          states: {WidgetState.selected, if (pressed) WidgetState.pressed},
        );
        expect(
          (spec.container.spec.decoration as BoxDecoration).color,
          pressed ? hover : fill,
        );
      }
    });
  }

  for (final theme in FortalAccentColor.values) {
    for (final brightness in Brightness.values) {
      final mode = brightness.name;
      final pair = pairs[theme.name]!;
      final colors = resolveFortalTokens(
        FortalThemeConfig(accent: theme, brightness: brightness),
      );
      testWidgets('${theme.name}/$mode inline code retains readable text', (
        tester,
      ) async {
        for (final variant in FortalCodeVariant.values) {
          for (final highContrast in [false, true]) {
            final spec = await resolveInFortalTheme(
              tester,
              (context) => fortalCodeStyle(
                context,
                variant: variant,
                accent: true,
                highContrast: highContrast,
              ).build(context).spec,
              accent: theme,
              mode: brightness == Brightness.dark ? .dark : .light,
            );
            final ink = spec.label.spec.style!.color!;
            final fill =
                (spec.container.spec.decoration as BoxDecoration?)?.color;
            for (final surface in [
              colors.colorBackground,
              colors.colorPanelSolid,
            ]) {
              final background = Color.alphaBlend(
                fill ?? const Color(0x00000000),
                surface,
              );
              expect(
                contrastRatio(Color.alphaBlend(ink, background), background),
                greaterThanOrEqualTo(4.5),
                reason:
                    '${theme.name}/$mode/$variant/highContrast=$highContrast',
              );
            }
          }
        }
      });
      test(
        '${theme.name}/$mode preserves every upstream opaque and alpha step',
        () {
          for (final (family, palette) in [
            (pair.$1, colors.accent),
            (pair.$2, colors.gray),
          ]) {
            final expected = (source['scales'] as Map)[family][mode] as Map;
            for (var i = 0; i < 12; i++) {
              expect(
                palette.scale.step(i + 1),
                sourceColor((expected['solid'] as List)[i] as String),
                reason: '$family/$mode opaque ${i + 1}',
              );
              expect(
                palette.scale.alphaStep(i + 1),
                sourceColor((expected['alpha'] as List)[i] as String),
                reason: '$family/$mode alpha ${i + 1}',
              );
            }
          }
          final neutral = (source['scales'] as Map)[pair.$2][mode] as Map;
          expect(
            colors.colorBackground,
            sourceColor((neutral['solid'] as List)[0] as String),
          );
          expect(
            colors.colorSurface,
            sourceColor((neutral['solid'] as List)[1] as String),
          );
          expect(colors.colorPanelSolid, colors.colorSurface);
          if (theme != FortalAccentColor.orla) {
            expect(colors.accent.markHover, colors.accent.scale.step(10));
          }
        },
      );

      test(
        '${theme.name}/$mode keeps text, focus and control cues accessible',
        () {
          for (final fill in [colors.accent.solid, colors.accent.solidHover]) {
            expect(
              contrastRatio(colors.accent.contrast, fill),
              greaterThanOrEqualTo(4.5),
            );
          }
          for (final surface in [
            colors.colorBackground,
            colors.colorPanelSolid,
          ]) {
            expect(
              contrastRatio(colors.focus8, surface),
              greaterThanOrEqualTo(3),
            );
            expect(
              contrastRatio(colors.controlBorder, surface),
              greaterThanOrEqualTo(3),
            );
            for (var step = 3; step <= 5; step++) {
              expect(
                compositedContrast(
                  foreground: colors.accentContentAlpha,
                  fill: colors.accent.scale.alphaStep(step),
                  panel: surface,
                ),
                greaterThanOrEqualTo(4.5),
              );
            }
          }
        },
      );
    }
  }
}
