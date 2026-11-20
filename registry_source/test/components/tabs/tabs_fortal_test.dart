import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

void main() {
  testWidgets('focus-visible hover keeps the Fortal accent hover treatment', (
    tester,
  ) async {
    final hovered = await _resolve(tester, const {WidgetState.hovered});
    final focusedHovered = await _resolve(tester, const {
      WidgetState.focused,
      WidgetState.hovered,
    });

    expect(_containerColor(hovered.spec), hovered.grayA3);
    expect(_containerColor(focusedHovered.spec), focusedHovered.accentA3);
    expect(focusedHovered.spec.containerEffects?.outline.width, 2);
  });

  for (final states in [
    {WidgetState.disabled},
    {WidgetState.disabled, WidgetState.hovered},
    {WidgetState.disabled, WidgetState.selected},
  ]) {
    testWidgets(
      'a disabled tab is grayA8 with no fill (${states.join(', ')})',
      (tester) async {
        final disabled = await _resolve(tester, states);

        expect(disabled.spec.label.spec.style?.color, disabled.grayA8);
        expect(disabled.spec.icon.spec.color, disabled.grayA8);
        expect(_containerColor(disabled.spec), const Color(0x00000000));
      },
    );
  }
}

Future<({TabSpec spec, Color grayA3, Color grayA8, Color accentA3})> _resolve(
  WidgetTester tester,
  Set<WidgetState> states,
) async {
  late ({TabSpec spec, Color grayA3, Color grayA8, Color accentA3}) result;

  await tester.pumpWidget(
    FortalTheme(
      accent: .mar,
      child: WidgetsApp(
        color: Colors.black,
        builder: (context, child) => WidgetStateStyleOverride(
          states: states,
          child: Builder(
            builder: (context) {
              result = (
                spec: fortalTabStyle().build(context).spec,
                grayA3: MixScope.tokenOf(FortalTokens.grayA3, context),
                grayA8: MixScope.tokenOf(FortalTokens.grayA8, context),
                accentA3: MixScope.tokenOf(FortalTokens.accentA3, context),
              );

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    ),
  );

  return result;
}

Color? _containerColor(TabSpec spec) {
  return _containerDecoration(spec)?.color;
}

BoxDecoration? _containerDecoration(TabSpec spec) =>
    spec.container.spec.box?.spec.decoration as BoxDecoration?;
