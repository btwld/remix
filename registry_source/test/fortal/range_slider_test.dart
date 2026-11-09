import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/rendering/remix_box_effects.dart';

import '../helpers/test_helpers.dart';

// Inspect the independently resolved painted parts rather than the root spec.
// ignore: invalid_use_of_internal_member
Finder thumb(int index) => find.descendant(
  of: find.byKey(ValueKey(index)),
  // ignore: invalid_use_of_internal_member
  matching: find.byType(RemixBoxAdapter),
);
// ignore: invalid_use_of_internal_member
RemixBoxAdapter part(WidgetTester tester, int index) =>
    tester.widget(thumb(index));

void main() {
  for (final dark in [false, true]) {
    testWidgets(
      '${dark ? "dark" : "light"}: each thumb owns hover, press and keyboard focus',
      (tester) async {
        await tester.pumpRemixApp(
          SizedBox(
            width: 240,
            child: FortalRangeSlider(
              values: const [.25, .75],
              onChanged: (_) {},
              semanticLabels: const ['Minimum', 'Maximum'],
            ),
          ),
          mode: dark ? .dark : .light,
        );
        await tester.pumpAndSettle();
        final context = tester.element(find.byType(FortalRangeSlider));
        for (var index = 0; index < 2; index++) {
          final mouse = await tester.createGesture(
            kind: PointerDeviceKind.mouse,
          );
          await mouse.addPointer(location: Offset.zero);
          await mouse.moveTo(tester.getCenter(thumb(index)));
          await tester.pumpAndSettle();
          expect(
            part(tester, index).containerEffects?.outline.color,
            FortalTokens.accentA7.resolve(context),
          );
          expect(
            part(tester, 1 - index).containerEffects?.outline.style ??
                BorderStyle.none,
            BorderStyle.none,
          );
          await mouse.removePointer();
          await tester.pumpAndSettle();
          final touch = await tester.startGesture(
            tester.getCenter(thumb(index)),
          );
          await tester.pumpAndSettle();
          expect(part(tester, index).containerEffects?.outline.width, 4);
          expect(
            part(tester, 1 - index).containerEffects?.outline.style ??
                BorderStyle.none,
            BorderStyle.none,
          );
          await touch.up();
          await tester.pumpAndSettle();
        }
        // Pointer focus is on upper; Tab cycles to lower then upper.
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pump();
        for (var index = 0; index < 2; index++) {
          await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          await tester.pumpAndSettle();
          expect(
            part(tester, index).containerEffects?.outline.color,
            FortalTokens.accent11.resolve(context),
          );
          expect(part(tester, index).containerEffects?.outlineOffset, 0);
          expect(
            part(tester, 1 - index).containerEffects?.outline.style ??
                BorderStyle.none,
            BorderStyle.none,
          );
        }
      },
      variant: TargetPlatformVariant.only(TargetPlatform.macOS),
    );

    testWidgets(
      '${dark ? "dark" : "light"}: every variant and size fits RTL at 200% and disabled clears interaction',
      (tester) async {
        for (final variant in FortalSliderVariant.values) {
          for (final size in FortalSliderSize.values) {
            for (final disabled in [false, true]) {
              await tester.pumpRemixApp(
                MediaQuery(
                  data: const MediaQueryData(textScaler: TextScaler.linear(2)),
                  child: SizedBox(
                    width: 240,
                    child: FortalRangeSlider(
                      variant: variant,
                      size: size,
                      values: const [.25, .75],
                      enabled: !disabled,
                      onChanged: (_) {},
                    ),
                  ),
                ),
                mode: dark ? .dark : .light,
                textDirection: TextDirection.rtl,
              );
              await tester.pumpAndSettle();
              expect(
                tester.getSize(find.byType(RemixRangeSlider)).height,
                greaterThanOrEqualTo(48),
              );
              expect(
                tester.getCenter(thumb(0)).dx,
                greaterThan(tester.getCenter(thumb(1)).dx),
              );
              if (disabled) {
                for (var index = 0; index < 2; index++) {
                  expect(
                    part(tester, index).containerEffects?.outline.style,
                    BorderStyle.none,
                  );
                }
              }
              expect(tester.takeException(), isNull);
            }
          }
        }
      },
    );
  }

  testWidgets('shared range axes and caller overrides remain authoritative', (
    tester,
  ) async {
    const range = FortalRangeSlider(values: [.25, .75]);
    expect(range.size, FortalSliderSize.size2);
    expect(range.variant, FortalSliderVariant.surface);
    for (final states in <Set<WidgetState>>[
      {},
      {WidgetState.pressed},
      {WidgetState.disabled},
    ]) {
      final spec = await resolveInFortalTheme(
        tester,
        (context) => fortalRangeSliderStyle(
          style: SliderStyler()
              .thickness(12)
              .onPressed(
                SliderStyler().thumbEffects(
                  RemixBoxEffectsMix(outline: .width(8)),
                ),
              ),
        ).build(context).spec,
        states: states,
      );
      expect(spec.trackWidth, 12);
      if (states.contains(WidgetState.pressed))
        expect(spec.thumbEffects?.outline.width, 8);
    }
  });
}
