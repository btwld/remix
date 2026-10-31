import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/src/fortal/theme/theme_data.dart'
    show buildFortalScopeTokens;

void main() {
  final specification =
      jsonDecode(File('specs/fortal_catalog.json').readAsStringSync())
          as Map<String, dynamic>;

  test(
    'the independent specification owns the seven palettes and defaults',
    () {
      final enums = specification['theme']['enums'] as Map;
      expect(
        FortalAccentColor.values.map((value) => value.name),
        enums['accent']['values'],
      );
      expect(FortalGrayColor.values.map((value) => value.name), ['calcadao']);
      for (final theme in [
        const FortalThemeData.light(),
        const FortalThemeData.dark(),
      ]) {
        expect(theme.accent.name, enums['accent']['default']);
        expect(theme.gray.name, enums['gray']['default']);
        expect(theme.panelBackground.name, 'solid');
        expect(theme.radius.name, 'medium');
        expect(theme.scaling.name, 'percent100');
        expect(buildFortalScopeTokens(theme)[FortalTokens.panelBlur], 0);
      }
    },
  );

  for (final dark in [false, true]) {
    final brightness = dark ? Brightness.dark : Brightness.light;
    test('${brightness.name}: page, panel, error and typography roles', () {
      final neutral = dark ? calcadao.dark : calcadao.light;
      final errors = dark ? fortalError.dark : fortalError.light;
      // Error roles ignore every named accent and a custom brand palette.
      for (final theme in [
        for (final accent in FortalAccentColor.values)
          FortalThemeData.light(accent: accent),
        const FortalThemeData.light(accentPalette: caju),
        const FortalThemeData.light(accentPalette: fortalError),
      ]) {
        final label = theme.accentPalette == null
            ? theme.accent.name
            : 'custom palette';
        final tokens = buildFortalScopeTokens(
          theme.copyWith(brightness: brightness),
        );
        expect(tokens[FortalTokens.colorBackground], neutral.scale.step(1));
        expect(tokens[FortalTokens.colorPanelSolid], neutral.scale.step(2));
        expect(tokens[FortalTokens.colorPanel], neutral.scale.step(2));
        for (final (token, step) in [
          (FortalTokens.error3, 3),
          (FortalTokens.error7, 7),
          (FortalTokens.error8, 8),
          (FortalTokens.error9, 9),
          (FortalTokens.error11, 11),
          (FortalTokens.error12, 12),
        ]) {
          expect(
            tokens[token],
            errors.scale.step(step),
            reason: '$label error$step',
          );
        }
        expect(tokens[FortalTokens.errorA7], errors.scale.alphaStep(7));
        expect(
          tokens.keys.any((token) => token.name.contains('.classic.')),
          isFalse,
        );
        final text = tokens[FortalTokens.text8]! as TextStyle;
        expect(text.fontSize, 36);
        expect(text.fontSize! * text.height!, 40);
      }
    });

    testWidgets(
      '${brightness.name}: flat cards and opaque filled surface inputs',
      (tester) async {
        await tester.pumpWidget(
          FortalTheme(
            mode: dark ? .dark : .light,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Builder(
                builder: (context) {
                  final neutral = dark ? calcadao.dark : calcadao.light;
                  final card = fortalCardStyle().build(context).spec;
                  final decoration =
                      card.container.spec.decoration! as BoxDecoration;
                  expect(decoration.color, neutral.scale.step(2));
                  expect(decoration.boxShadow, isNull);
                  expect(
                    card.containerEffects?.behindContent?.shadows ?? [],
                    isEmpty,
                  );
                  expect(
                    card.containerEffects?.overContent?.shadows ?? [],
                    isEmpty,
                  );
                  for (final style in [
                    fortalTextFieldStyle(),
                    fortalTextAreaStyle(),
                  ]) {
                    final spec = style.build(context).spec;
                    expect(
                      (spec.container.spec.decoration as BoxDecoration).color,
                      neutral.scale.step(2),
                    );
                    // Text inputs frame with the control border (3:1), so an
                    // unlabeled field can still be found; the select trigger
                    // below keeps gray 7, identified by its value and chevron.
                    final frame =
                        spec.containerEffects!.overContent!.shadows.single;
                    expect(
                      frame.color,
                      resolveFortalTokens(
                        FortalTheme.of(context),
                      ).controlBorder,
                    );
                    expect(frame.blurRadius, 0);
                    expect(frame.offset, Offset.zero);
                  }
                  final trigger = fortalSelectStyle()
                      .build(context)
                      .spec
                      .trigger
                      .spec;
                  expect(
                    (trigger.container.spec.box!.spec.decoration
                            as BoxDecoration)
                        .color,
                    neutral.scale.step(2),
                  );
                  expect(
                    trigger
                        .containerEffects!
                        .behindContent!
                        .shadows
                        .single
                        .color,
                    neutral.scale.step(7),
                  );
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  test('fixed role scales follow scaling and touch targets never shrink', () {
    for (final scaling in FortalScaling.values) {
      final tokens = buildFortalScopeTokens(
        FortalThemeData.light(scaling: scaling),
      );
      expect(tokens[FortalTokens.space4], 16 * scaling.factor);
      expect(
        (tokens[FortalTokens.text8] as TextStyle).fontSize,
        36 * scaling.factor,
      );
      expect(tokens[FortalTokens.focusRingWidth], 2);
      expect(tokens[FortalTokens.focusRingOffset], 2);
      expect(tokens[FortalTokens.touchTargetMin], greaterThanOrEqualTo(40));
    }
  });

  testWidgets(
    'custom brand palettes inherit, and explicit named accents reset them',
    (tester) async {
      final captured = <String, Color>{};
      Widget capture(String name) => Builder(
        builder: (context) {
          captured[name] = FortalTokens.accent9.resolve(context);
          return const SizedBox();
        },
      );
      Widget configured(
        String name, {
        FortalAccentColor? accent,
        FortalColorTheme? accentPalette,
      }) => FortalTheme(
        theme: const FortalThemeData.light(accentPalette: mar),
        darkTheme: const FortalThemeData.dark(accentPalette: sol),
        accent: accent,
        accentPalette: accentPalette,
        child: capture(name),
      );
      for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
        await tester.pumpWidget(
          FortalTheme(
            accentPalette: mar,
            mode: mode,
            child: Column(
              children: [
                capture('root'),
                FortalTheme(child: capture('inherited')),
                FortalTheme(accent: .caju, child: capture('named')),
                FortalTheme(accentPalette: ceu, child: capture('custom')),
                configured('configured'),
                configured('configured-named', accent: .caju),
                configured(
                  'configured-custom',
                  accent: .caju,
                  accentPalette: ceu,
                ),
              ],
            ),
          ),
        );
        final dark = mode == FortalThemeMode.dark;
        final inherited = dark ? mar.dark : mar.light;
        final named = dark ? caju.dark : caju.light;
        final custom = dark ? ceu.dark : ceu.light;
        expect(captured, {
          'root': inherited.scale.step(9),
          'inherited': inherited.scale.step(9),
          'named': named.scale.step(9),
          'custom': custom.scale.step(9),
          'configured': (dark ? sol.dark : mar.light).scale.step(9),
          'configured-named': named.scale.step(9),
          'configured-custom': custom.scale.step(9),
        });
      }
      expect(
        const FortalThemeData.light(
          accentPalette: mar,
        ).copyWith(accent: .caju).accentPalette,
        isNull,
      );
    },
  );
}
