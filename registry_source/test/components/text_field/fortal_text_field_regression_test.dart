import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

import '../../helpers/test_helpers.dart';
import '../../helpers/fortal_text_input_geometry.dart';

/// Resolved-value coverage for the shared Fortal text-input recipe.
void main() {
  for (final (size, height, paddingY) in const [
    // Vertical padding is (height - line box) / 2 at 1x, against the 14px
    // line box of 19.6px that the engine lays out on 20px: 6, 10 and 12.
    (FortalTextFieldSize.size1, 32.0, 6.0),
    (FortalTextFieldSize.size2, 40.0, 10.0),
    (FortalTextFieldSize.size3, 44.0, 12.0),
  ]) {
    for (final variant in FortalTextFieldVariant.values) {
      for (final scale in [1.0, 2.0]) {
        testWidgets(
          '$size/$variant at $scale keeps the text line inside its field',
          (tester) async {
            final controller = TextEditingController(text: 'Agj Ép');
            addTearDown(controller.dispose);
            for (final direction in TextDirection.values) {
              for (final enabled in [true, false]) {
                await tester.pumpRemixApp(
                  MediaQuery(
                    data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                    child: SizedBox(
                      width: 320,
                      child: FortalTextField(
                        size: size,
                        variant: variant,
                        controller: controller,
                        enabled: enabled,
                      ),
                    ),
                  ),
                  textDirection: direction,
                );
                await tester.pumpAndSettle();
                expectFortalTextInputGeometry(
                  tester,
                  scale: scale,
                  height: height,
                  paddingY: paddingY,
                );
              }
            }
          },
        );
      }
    }
  }

  for (final (size, height, paddingX, softPaddingX, spacing, fontSize, radius)
      in const [
        (FortalTextFieldSize.size1, 32.0, 13.0, 13.0, 8.0, 14.0, 14.0),
        (FortalTextFieldSize.size2, 40.0, 13.0, 13.0, 8.0, 14.0, 14.0),
        (FortalTextFieldSize.size3, 44.0, 13.0, 13.0, 8.0, 14.0, 14.0),
      ]) {
    testWidgets('${size.name} resolves the pinned metrics', (tester) async {
      for (final variant in FortalTextFieldVariant.values) {
        final result = await _resolve(tester, size: size, variant: variant);
        final spec = result.spec;
        final container = spec.container.spec;

        expect(container.constraints?.minHeight, height);
        expect(container.constraints?.maxHeight, double.infinity);
        final padding = container.padding!.resolve(TextDirection.ltr);
        expect(padding.left, variant == .soft ? softPaddingX : paddingX);
        expect(padding.right, variant == .soft ? softPaddingX : paddingX);
        // (height - rounded line box) / 2: 6, 10 and 12.
        final vertical = (height - 20) / 2;
        expect(padding.top, closeTo(vertical, 1e-9));
        expect(padding.bottom, closeTo(vertical, 1e-9));
        expect(spec.spacing, spacing);
        expect(spec.crossAxisAlignment, CrossAxisAlignment.center);
        expect(spec.text.spec.style?.fontSize, fontSize);
        expect(spec.hintText.spec.style?.fontSize, fontSize);
        expect(_radius(container), radius);
        expect(container.clipBehavior, Clip.antiAlias);
        expect(spec.cursorWidth, 1.5);
        expect(spec.containerEffects?.behindContent, isNotNull);
        expect(spec.containerEffects?.overContent, isNotNull);
      }
    });
  }

  testWidgets('caller frame overrides hold at rest and disabled on soft '
      'inputs', (tester) async {
    const base = Color(0xff8038cc);
    const disabled = Color(0xff3366cc);
    final style = TextFieldStyler()
        .containerEffects(
          RemixBoxEffectsMix.overContent(fortalInsetSurface(strokes: [base])),
        )
        .onDisabled(
          TextFieldStyler().containerEffects(
            RemixBoxEffectsMix.overContent(
              fortalInsetSurface(strokes: [disabled]),
            ),
          ),
        );
    for (final (states, expected) in <(Set<WidgetState>, Color)>[
      ({}, base),
      ({WidgetState.disabled}, disabled),
    ]) {
      final result = await _resolve(
        tester,
        variant: .soft,
        states: states,
        style: style,
      );
      expect(
        result.spec.containerEffects?.overContent?.shadows.single.color,
        expected,
        reason: '$states',
      );
    }
  });

  testWidgets('bordered insets use full scaled values at 110 percent', (
    tester,
  ) async {
    for (final variant in [FortalTextFieldVariant.surface]) {
      for (final (size, expected) in const [
        // 12px scaled plus the 1px frame, which does not scale.
        (FortalTextFieldSize.size1, 14.2),
        (FortalTextFieldSize.size2, 14.2),
        (FortalTextFieldSize.size3, 14.2),
      ]) {
        final result = await _resolve(
          tester,
          size: size,
          variant: variant,
          scaling: .percent110,
        );
        final padding = result.spec.container.spec.padding!.resolve(
          TextDirection.ltr,
        );
        expect(padding.left, closeTo(expected, 0.000001));
        expect(padding.right, closeTo(expected, 0.000001));
        // (height - line box) / 2 at 110 percent, against the 21.56px line
        // box rounded up to 22px.
        final inset = ([32, 40, 44][size.index] * 1.1 - 22) / 2;
        expect(padding.top, closeTo(inset, 0.000001));
        expect(padding.bottom, closeTo(inset, 0.000001));
      }
    }
  });

  testWidgets('selection roles resolve in light and dark themes', (
    tester,
  ) async {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      for (final variant in FortalTextFieldVariant.values) {
        final result = await _resolve(
          tester,
          variant: variant,
          brightness: brightness,
        );
        expect(result.spec.text.spec.selectionColor, result.focusA5);
      }
    }
  });
}

Future<
  ({
    TextFieldSpec spec,
    Color colorSurface,
    Color gray8,
    Color gray11,
    Color grayA5,
    Color grayA11,
    Color gray12,
    Color grayA3,
    Color grayA7,
    Color controlBorder,
    Color grayA10,
    Color accentA3,
    Color accentA5,
    Color accent12,
    Color focus8,
    Color focusA5,
    Color error8,
    Color error9,
    Color error11,
  })
>
_resolve(
  WidgetTester tester, {
  FortalTextFieldSize size = FortalTextFieldSize.size2,
  FortalTextFieldVariant variant = FortalTextFieldVariant.surface,
  FortalScaling scaling = FortalScaling.percent100,
  Brightness brightness = Brightness.light,
  Set<WidgetState> states = const {},
  TextFieldStyler style = const TextFieldStyler.create(),
}) async {
  late ({
    TextFieldSpec spec,
    Color colorSurface,
    Color gray8,
    Color gray11,
    Color grayA5,
    Color grayA11,
    Color gray12,
    Color grayA3,
    Color grayA7,
    Color controlBorder,
    Color grayA10,
    Color accentA3,
    Color accentA5,
    Color accent12,
    Color focus8,
    Color focusA5,
    Color error8,
    Color error9,
    Color error11,
  })
  result;
  await tester.pumpWidget(
    FortalTheme(
      accent: .mar,
      mode: brightness == Brightness.dark ? .dark : .light,
      scaling: scaling,
      child: WidgetStateProvider(
        states: states,
        child: Builder(
          builder: (context) {
            result = (
              spec: fortalTextFieldStyle(
                size: size,
                variant: variant,
                style: style,
              ).build(context).spec,
              colorSurface: MixScope.tokenOf(
                FortalTokens.colorSurface,
                context,
              ),
              gray8: MixScope.tokenOf(FortalTokens.gray8, context),
              gray11: MixScope.tokenOf(FortalTokens.gray11, context),
              grayA5: MixScope.tokenOf(FortalTokens.grayA5, context),
              grayA11: MixScope.tokenOf(FortalTokens.grayA11, context),
              gray12: MixScope.tokenOf(FortalTokens.gray12, context),
              grayA3: MixScope.tokenOf(FortalTokens.grayA3, context),
              controlBorder: MixScope.tokenOf(
                FortalTokens.controlBorder,
                context,
              ),
              grayA7: MixScope.tokenOf(FortalTokens.grayA7, context),
              grayA10: MixScope.tokenOf(FortalTokens.grayA10, context),
              accentA3: MixScope.tokenOf(FortalTokens.accentA3, context),
              accentA5: MixScope.tokenOf(FortalTokens.accentA5, context),
              accent12: MixScope.tokenOf(FortalTokens.accent12, context),
              focus8: MixScope.tokenOf(FortalTokens.focus8, context),
              focusA5: MixScope.tokenOf(FortalTokens.focusA5, context),
              error8: MixScope.tokenOf(FortalTokens.error8, context),
              error9: MixScope.tokenOf(FortalTokens.error9, context),
              error11: MixScope.tokenOf(FortalTokens.error11, context),
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
  return result;
}

double _radius(BoxSpec box) =>
    ((box.decoration! as BoxDecoration).borderRadius! as BorderRadius)
        .topLeft
        .x;
