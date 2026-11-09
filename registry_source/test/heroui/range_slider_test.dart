import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/rendering/remix_box_effects.dart';

import '../helpers/heroui.dart';

Finder thumb(int index) => find.descendant(
  of: find.byKey(ValueKey(index)),
  // ignore: invalid_use_of_internal_member
  matching: find.byType(RemixBoxAdapter),
);
// ignore: invalid_use_of_internal_member
RemixBoxAdapter part(WidgetTester tester, int index) =>
    tester.widget(thumb(index));

void main() {
  for (final mode in ['light', 'dark']) {
    testWidgets(
      '$mode: range preserves the upstream track and both thumb pills',
      (tester) async {
        await tester.pumpHeroUi(
          SizedBox(
            width: 360,
            child: HeroUiRangeSlider(
              values: const [.25, .75],
              onChanged: (_) {},
            ),
          ),
          mode: mode,
        );
        await tester.pumpAndSettle();
        final spec = tester
            .widget<StyleSpecProvider<SliderSpec>>(
              find.byType(StyleSpecProvider<SliderSpec>),
            )
            .spec
            .spec;
        expect(
          spec.trackWidth,
          heroUiCase('slider-range-track', mode: mode).size.height,
        );
        expectCssColor(
          spec.rangeColor,
          heroUiCase(
            'slider-range-fill',
            mode: mode,
          ).styles['backgroundColor']!,
        );
        for (var index = 0; index < 2; index++) {
          expect(
            part(tester, index).styleSpec.spec.constraints,
            BoxConstraints.tight(
              heroUiCase('slider-range-thumb$index', mode: mode).size,
            ),
          );
          final decoration =
              part(tester, index).styleSpec.spec.decoration as BoxDecoration;
          expectCssColor(
            decoration.color!,
            heroUiCase(
              'slider-range-thumb$index-pill',
              mode: mode,
            ).styles['backgroundColor']!,
          );
        }
        expect(tester.getSize(find.byType(RemixRangeSlider)).height, 48);
      },
    );

    testWidgets(
      '$mode: press and visible focus affect one thumb at a time',
      (tester) async {
        await tester.pumpHeroUi(
          SizedBox(
            width: 360,
            child: HeroUiRangeSlider(
              values: const [.25, .75],
              onChanged: (_) {},
            ),
          ),
          mode: mode,
        );
        await tester.pumpAndSettle();
        for (var index = 0; index < 2; index++) {
          final mouse = await tester.createGesture(
            kind: PointerDeviceKind.mouse,
          );
          await mouse.addPointer(location: Offset.zero);
          await mouse.moveTo(tester.getCenter(thumb(index)));
          await tester.pumpAndSettle();
          // slider.css has no painted hover change; hovering must not drag either pill.
          for (var i = 0; i < 2; i++)
            expect(part(tester, i).styleSpec.spec.transform, isNull);
          await mouse.removePointer();
          final touch = await tester.startGesture(
            tester.getCenter(thumb(index)),
          );
          await tester.pumpAndSettle();
          expect(
            part(tester, index).styleSpec.spec.transform!.entry(0, 0),
            closeTo(
              double.parse(
                heroUiCase(
                  'slider-range-drag-thumb$index-pill',
                  mode: mode,
                  state: true,
                ).styles['scale']!,
              ),
              .001,
            ),
          );
          expect(part(tester, 1 - index).styleSpec.spec.transform, isNull);
          await touch.up();
          await tester.pumpAndSettle();
        }
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pump();
        for (var index = 0; index < 2; index++) {
          await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          await tester.pumpAndSettle();
          expectFocusRing(
            part(tester, index).containerEffects,
            heroUiCase(
              'slider-range-focus-thumb$index',
              mode: mode,
              state: true,
            ),
          );
          expect(
            part(tester, 1 - index).containerEffects?.outline.style ??
                BorderStyle.none,
            BorderStyle.none,
          );
        }
      },
      variant: desktopOnly,
    );

    testWidgets('$mode: disabled, RTL 200% and caller hover overrides', (
      tester,
    ) async {
      for (final disabled in [false, true]) {
        await tester.pumpHeroUi(
          Directionality(
            textDirection: TextDirection.rtl,
            child: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2)),
              child: SizedBox(
                width: 280,
                child: HeroUiRangeSlider(
                  values: const [.25, .75],
                  onChanged: disabled ? null : (_) {},
                  semanticLabels: const ['Minimum', 'Maximum'],
                  style: SliderStyler()
                      .thickness(12)
                      .onHovered(SliderStyler().thumb(BoxStyler().scale(1.1))),
                ),
              ),
            ),
          ),
          mode: mode,
        );
        await tester.pumpAndSettle();
        expect(
          tester.getCenter(thumb(0)).dx,
          greaterThan(tester.getCenter(thumb(1)).dx),
        );
        if (disabled) {
          expect(
            find.descendant(
              of: find.byType(RemixRangeSlider),
              matching: find.byWidgetPredicate(
                (w) =>
                    w is Opacity && w.opacity == HeroUiTokens.disabledOpacity,
              ),
            ),
            findsOneWidget,
          );
        } else {
          final mouse = await tester.createGesture(
            kind: PointerDeviceKind.mouse,
          );
          await mouse.addPointer(location: Offset.zero);
          await mouse.moveTo(tester.getCenter(thumb(0)));
          await tester.pumpAndSettle();
          expect(
            part(tester, 0).styleSpec.spec.transform!.entry(0, 0),
            closeTo(1.1, .001),
          );
          expect(part(tester, 1).styleSpec.spec.transform, isNull);
          await mouse.removePointer();
        }
        expect(tester.takeException(), isNull);
      }
    }, variant: desktopOnly);
  }
}
