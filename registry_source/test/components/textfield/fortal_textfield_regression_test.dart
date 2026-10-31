import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

/// Resolved-value coverage for the shared Fortal text-input recipe.
void main() {
  for (final (size, height, paddingX, softPaddingX, spacing, fontSize, radius)
      in const [
        (FortalTextFieldSize.size1, 24.0, 8.0, 8.0, 8.0, 12.0, 4.0),
        (FortalTextFieldSize.size2, 32.0, 8.0, 8.0, 8.0, 14.0, 4.0),
        (FortalTextFieldSize.size3, 40.0, 12.0, 12.0, 12.0, 16.0, 6.0),
      ]) {
    testWidgets('${size.name} resolves the pinned metrics', (tester) async {
      for (final variant in FortalTextFieldVariant.values) {
        final result = await _resolve(tester, size: size, variant: variant);
        final spec = result.spec;
        final container = spec.container.spec;

        expect(container.constraints?.minHeight, height);
        expect(container.constraints?.maxHeight, height);
        expect(
          container.padding?.resolve(TextDirection.ltr),
          EdgeInsets.symmetric(
            horizontal: variant == .soft ? softPaddingX : paddingX,
          ),
        );
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

  testWidgets('surface resolve neutral text and effect layers', (tester) async {
    for (final variant in [FortalTextFieldVariant.surface]) {
      final result = await _resolve(tester, variant: variant);
      final spec = result.spec;

      expect(spec.text.spec.style?.color, result.gray12);
      expect(spec.hintText.spec.style?.color, result.grayA11);
      expect(spec.text.spec.selectionColor, result.focusA5);
      expect(spec.cursorColor, result.gray12);
      expect(spec.helperText.spec.style?.color, result.gray11);
      expect(spec.label.spec.style?.color, result.gray12);
      expect(spec.label.spec.style?.fontWeight, FontWeight.w500);
      expect(_color(spec.container.spec), result.colorSurface);

      expect(spec.containerEffects?.behindContent?.shadows, isEmpty);
      expect(spec.containerEffects?.overContent?.shadows, hasLength(1));
      expect(
        spec.containerEffects?.overContent?.shadows.single.color,
        result.controlBorder,
      );
    }
  });

  testWidgets('soft resolves fill, text, cursor, and selection policy', (
    tester,
  ) async {
    final result = await _resolve(tester, variant: .soft);
    final spec = result.spec;

    expect(_color(spec.container.spec), result.accentA3);
    expect(spec.text.spec.style?.color, result.accent12);
    expect(spec.text.spec.selectionColor, result.accentA5);
    expect(spec.text.spec.style?.fontWeight, FontWeight.normal);
    expect(spec.cursorColor, result.accent12);
    expect(spec.helperText.spec.style?.color, result.gray11);
    expect(spec.label.spec.style?.color, result.gray12);
    expect(spec.label.spec.style?.fontWeight, FontWeight.w500);
  });

  testWidgets('soft inputs keep an accent-8 frame that disabled clears', (
    tester,
  ) async {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      for (final states in <Set<WidgetState>>[
        {},
        {WidgetState.focused},
        {WidgetState.hovered},
        {WidgetState.error},
        {WidgetState.disabled},
        {WidgetState.disabled, WidgetState.focused},
        {WidgetState.disabled, WidgetState.error},
        {WidgetState.disabled, WidgetState.focused, WidgetState.error},
      ]) {
        final result = await _resolve(
          tester,
          variant: .soft,
          brightness: brightness,
          states: states,
        );
        // Error keeps its precedence; otherwise disabled stays muted.
        final expected = states.contains(WidgetState.error)
            ? [result.error8]
            : states.contains(WidgetState.disabled)
            ? <Color>[]
            : [result.accentA8];
        expect(
          [
            ...?result.spec.containerEffects?.overContent?.shadows.map(
              (shadow) => shadow.color,
            ),
          ],
          expected,
          reason: '$brightness/$states',
        );
        expect(_color(result.spec.container.spec), switch (states) {
          _ when states.contains(WidgetState.disabled) => result.grayA3,
          _ => result.accentA3,
        });
      }
    }
  });

  testWidgets('caller frame overrides stay in force on soft inputs', (
    tester,
  ) async {
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
      ({WidgetState.focused}, base),
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

  testWidgets('disabled and read-only roles resolve for every variant', (
    tester,
  ) async {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      for (final variant in FortalTextFieldVariant.values) {
        final result = await _resolve(
          tester,
          variant: variant,
          brightness: brightness,
          states: {WidgetState.disabled, WidgetState.focused},
        );
        final spec = result.spec;

        expect(spec.text.spec.style?.color, result.grayA11);
        expect(spec.text.spec.selectionColor, result.grayA5);
        expect(
          spec.hintText.spec.style?.color,
          variant == .soft
              ? result.accent12.withValues(alpha: 0.5)
              : result.grayA10.withValues(alpha: result.grayA10.a * 0.5),
        );
        expect(spec.cursorColor, result.grayA11);
        expect(
          _color(spec.container.spec),
          variant == .soft ? result.grayA3 : result.colorSurface,
        );
        expect(spec.containerEffects?.outline.style, BorderStyle.none);
      }
    }
  });

  testWidgets('surface keep their existing focus outline', (tester) async {
    for (final variant in [FortalTextFieldVariant.surface]) {
      final result = await _resolve(
        tester,
        variant: variant,
        states: {WidgetState.focused},
      );
      expect(result.spec.containerEffects?.outline.color, result.focus8);
      expect(result.spec.containerEffects?.outline.width, 2);
      expect(result.spec.containerEffects?.outlineOffset, 2);
    }
  });

  testWidgets('error output remains stable for every variant', (tester) async {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      for (final variant in FortalTextFieldVariant.values) {
        final result = await _resolve(
          tester,
          variant: variant,
          brightness: brightness,
          states: {WidgetState.error},
        );
        final spec = result.spec;

        expect(spec.helperText.spec.style?.color, result.error11);
        expect(spec.label.spec.style?.color, result.error11);
        expect(spec.cursorColor, result.error9);
        expect(spec.containerEffects?.outline.style, BorderStyle.none);
        expect(
          spec.containerEffects?.overContent?.shadows.single.color,
          result.error8,
        );
      }
    }
  });

  testWidgets('error keeps precedence over disabled visual roles', (
    tester,
  ) async {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      for (final variant in FortalTextFieldVariant.values) {
        final result = await _resolve(
          tester,
          variant: variant,
          brightness: brightness,
          states: {
            WidgetState.disabled,
            WidgetState.focused,
            WidgetState.error,
          },
        );
        final spec = result.spec;

        expect(spec.helperText.spec.style?.color, result.error11);
        expect(spec.label.spec.style?.color, result.error11);
        expect(spec.cursorColor, result.error9);
        expect(spec.containerEffects?.outline.style, BorderStyle.none);
        expect(spec.text.spec.style?.color, result.grayA11);
        expect(spec.text.spec.selectionColor, result.grayA5);
      }
    }
  });

  testWidgets('bordered insets use full scaled values at 110 percent', (
    tester,
  ) async {
    for (final variant in [FortalTextFieldVariant.surface]) {
      for (final (size, expected) in const [
        (FortalTextFieldSize.size1, 8.8),
        (FortalTextFieldSize.size2, 8.8),
        (FortalTextFieldSize.size3, 13.2),
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
        expect(padding.top, 0);
        expect(padding.bottom, 0);
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
        expect(
          result.spec.text.spec.selectionColor,
          variant == .soft ? result.accentA5 : result.focusA5,
        );
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
    Color gray7,
    Color controlBorder,
    Color grayA10,
    Color accentA3,
    Color accentA5,
    Color accentA8,
    Color accent12,
    Color focus8,
    Color focusA5,
    Color error8,
    Color error9,
    Color error11,
    Color errorA7,
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
    Color gray7,
    Color controlBorder,
    Color grayA10,
    Color accentA3,
    Color accentA5,
    Color accentA8,
    Color accent12,
    Color focus8,
    Color focusA5,
    Color error8,
    Color error9,
    Color error11,
    Color errorA7,
  })
  result;
  await tester.pumpWidget(
    FortalTheme(
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
              gray7: MixScope.tokenOf(FortalTokens.gray7, context),
              controlBorder: MixScope.tokenOf(
                FortalTokens.controlBorder,
                context,
              ),
              grayA7: MixScope.tokenOf(FortalTokens.grayA7, context),
              grayA10: MixScope.tokenOf(FortalTokens.grayA10, context),
              accentA3: MixScope.tokenOf(FortalTokens.accentA3, context),
              accentA8: MixScope.tokenOf(FortalTokens.accentA8, context),
              accentA5: MixScope.tokenOf(FortalTokens.accentA5, context),
              accent12: MixScope.tokenOf(FortalTokens.accent12, context),
              focus8: MixScope.tokenOf(FortalTokens.focus8, context),
              focusA5: MixScope.tokenOf(FortalTokens.focusA5, context),
              error8: MixScope.tokenOf(FortalTokens.error8, context),
              error9: MixScope.tokenOf(FortalTokens.error9, context),
              error11: MixScope.tokenOf(FortalTokens.error11, context),
              errorA7: MixScope.tokenOf(FortalTokens.errorA7, context),
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

Color? _color(BoxSpec box) => (box.decoration as BoxDecoration?)?.color;
