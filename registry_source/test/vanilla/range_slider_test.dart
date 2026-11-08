import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/rendering/remix_box_effects.dart';

import 'support.dart';

// The rendered thumb adapter lets these tests inspect both independent parts.
// ignore: invalid_use_of_internal_member
RemixBoxAdapter thumbOf(WidgetTester tester, int index) => tester.widget(
  find.descendant(
    of: find.byKey(ValueKey(index)),
    // ignore: invalid_use_of_internal_member
    matching: find.byType(RemixBoxAdapter),
  ),
);

void main() {
  for (final theme in vanillaThemes) {
    testWidgets('${theme.name}: each thumb responds to hover and touch press', (
      tester,
    ) async {
      await tester.pumpWidget(
        VanillaTheme(
          theme: theme.data,
          child: hostOf(
            Center(
              child: SizedBox(
                width: 240,
                child: VanillaRangeSlider(
                  values: const [0.25, 0.75],
                  onChanged: (_) {},
                  semanticLabels: const ['Minimum', 'Maximum'],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (var index = 0; index < 2; index++) {
        final thumb = rangeThumb(index);
        final other = 1 - index;
        final decoration = decorationOf(thumbOf(tester, index).styleSpec);
        expect(decoration?.color, const Color(0xFFFFFFFF));
        expect(decoration?.border, Border.all(color: theme.data.primary));
        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: Offset.zero);
        await mouse.moveTo(tester.getCenter(thumb));
        await tester.pumpAndSettle();
        expect(
          thumbOf(tester, index).containerEffects?.outline,
          BorderSide(color: tint(theme.data.ring, 0.5), width: 4),
        );
        expect(
          thumbOf(tester, other).containerEffects?.outline.style ??
              BorderStyle.none,
          BorderStyle.none,
        );
        await mouse.removePointer();
        await tester.pumpAndSettle();
        final touch = await tester.startGesture(tester.getCenter(thumb));
        await tester.pumpAndSettle();
        expect(
          thumbOf(tester, index).containerEffects?.outline,
          BorderSide(color: tint(theme.data.ring, 0.5), width: 4),
        );
        expect(
          thumbOf(tester, other).containerEffects?.outline.style ??
              BorderStyle.none,
          BorderStyle.none,
        );
        await touch.up();
        await tester.pumpAndSettle();
      }
    });

    for (final enabled in [true, false]) {
      testWidgets(
        '${theme.name}: ${enabled ? "null callback" : "enabled false"} mutes the whole interval',
        (tester) async {
          await tester.pumpWidget(
            VanillaTheme(
              theme: theme.data,
              child: hostOf(
                Center(
                  child: SizedBox(
                    width: 240,
                    child: VanillaRangeSlider(
                      values: const [0.25, 0.75],
                      enabled: enabled,
                      onChanged: enabled ? null : (_) {},
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(
            find.ancestor(
              of: rangeThumb(0),
              matching: find.byWidgetPredicate(
                (w) =>
                    w is Opacity && w.opacity == VanillaTokens.disabledOpacity,
              ),
            ),
            findsOneWidget,
          );
          for (var index = 0; index < 2; index++) {
            expect(
              thumbOf(tester, index).containerEffects?.outline.style,
              BorderStyle.none,
            );
          }
        },
      );
    }

    testWidgets('${theme.name}: caller overrides merge last including states', (
      tester,
    ) async {
      final spec = await resolveVanilla(
        tester,
        vanillaRangeSliderStyle(
          style: SliderStyler()
              .rangeColor(VanillaTokens.destructive())
              .onPressed(
                SliderStyler().thumbEffects(vanillaFocusRing(width: 8)),
              ),
        ),
        theme: theme.data,
        states: {WidgetState.pressed},
      );
      expect(spec.spec.rangeColor, theme.data.destructive);
      expect(spec.spec.thumbEffects?.outline.width, 8);
    });
  }
}
