import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

void main() {
  test('flat card API and defaults', () {
    expect(FortalCardVariant.values.map((v) => v.name), ['surface', 'ghost']);
    const card = FortalCard(child: Text('Panel'));
    expect(card.variant, FortalCardVariant.surface);
    expect(card.size, FortalCardSize.size1);
  });

  for (final (size, padding, radius) in const [
    (FortalCardSize.size1, 12.0, 8.0),
    (FortalCardSize.size2, 16.0, 8.0),
    (FortalCardSize.size3, 24.0, 12.0),
    (FortalCardSize.size4, 32.0, 12.0),
    (FortalCardSize.size5, 48.0, 16.0),
  ]) {
    testWidgets(
      '${size.name} padding, radius, scaling and ghost compensation',
      (tester) async {
        for (final scaling in FortalScaling.values) {
          final surface = await _resolve(tester, size: size, scaling: scaling);
          final ghost = await _resolve(
            tester,
            size: size,
            scaling: scaling,
            variant: .ghost,
          );
          expect(
            surface.container.spec.padding,
            EdgeInsets.all(padding * scaling.factor),
          );
          final decoration =
              surface.container.spec.decoration! as BoxDecoration;
          expect(
            decoration.borderRadius!.resolve(TextDirection.ltr).topLeft.x,
            closeTo(radius * scaling.factor, 1e-9),
          );
          expect(
            ghost.container.spec.margin,
            EdgeInsets.all(-padding * scaling.factor),
          );
        }
      },
    );
  }

  for (final dark in [false, true]) {
    testWidgets(
      '${dark ? 'dark' : 'light'} surface is flat in every interaction state',
      (tester) async {
        final scale = (dark ? calcadao.dark : calcadao.light).scale;
        for (final states in <Set<WidgetState>>[
          {},
          {WidgetState.hovered},
          {WidgetState.pressed},
          {WidgetState.selected},
          {WidgetState.selected, WidgetState.pressed},
          {WidgetState.focused},
        ]) {
          final card = await _resolve(tester, dark: dark, states: states);
          final decoration = card.container.spec.decoration! as BoxDecoration;
          expect(
            decoration.color,
            scale.step(
              states.contains(WidgetState.pressed) ||
                      states.contains(WidgetState.selected)
                  ? 3
                  : 2,
            ),
          );
          expect(
            decoration.border!.top.color,
            scale.step(states.contains(WidgetState.hovered) ? 7 : 6),
          );
          expect(decoration.boxShadow, isNull);
          expect(card.containerEffects?.backdropBlur ?? 0, 0);
          expect(card.containerEffects?.behindContent?.shadows ?? [], isEmpty);
          expect(card.containerEffects?.overContent?.shadows ?? [], isEmpty);
        }
      },
    );
  }

  testWidgets('focus is outside, and disabled wins over focus', (tester) async {
    final focused = await _resolve(tester, states: {WidgetState.focused});
    expect(focused.containerEffects!.outline.width, 2);
    expect(focused.containerEffects!.outlineOffset, 2);
    final disabled = await _resolve(
      tester,
      states: {WidgetState.disabled, WidgetState.focused},
    );
    expect(disabled.containerEffects!.outline.style, BorderStyle.none);
  });

  testWidgets('ghost state fills keep their independent semantics', (
    tester,
  ) async {
    for (final (states, color) in [
      (<WidgetState>{}, const Color(0x00000000)),
      ({WidgetState.hovered}, calcadao.light.scale.alphaStep(3)),
      ({WidgetState.pressed}, calcadao.light.scale.alphaStep(4)),
      ({WidgetState.selected}, calcadao.light.scale.alphaStep(3)),
    ]) {
      final card = await _resolve(tester, variant: .ghost, states: states);
      expect((card.container.spec.decoration! as BoxDecoration).color, color);
    }
  });
}

Future<CardSpec> _resolve(
  WidgetTester tester, {
  FortalCardSize size = .size1,
  FortalCardVariant variant = .surface,
  FortalScaling scaling = .percent100,
  bool dark = false,
  Set<WidgetState> states = const {},
}) async {
  late CardSpec result;
  await tester.pumpWidget(
    FortalTheme(
      mode: dark ? .dark : .light,
      scaling: scaling,
      child: WidgetStateStyleOverride(
        states: states,
        child: Builder(
          builder: (context) {
            result = fortalCardStyle(
              size: size,
              variant: variant,
            ).build(context).spec;
            return const SizedBox();
          },
        ),
      ),
    ),
  );
  return result;
}
