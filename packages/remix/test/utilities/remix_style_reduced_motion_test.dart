import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../helpers/motion_harness.dart';

const _rest = Color(0xFFFF0000);
const _hover = Color(0xFF0000FF);
final _motion = AnimationConfig.linear(const Duration(milliseconds: 200));

Color? _paintedColor(WidgetTester tester) {
  final boxes = tester.widgetList<DecoratedBox>(
    find.descendant(
      of: find.byType(RemixButton),
      matching: find.byType(DecoratedBox),
    ),
  );
  for (final box in boxes) {
    final decoration = box.decoration;
    if (decoration is BoxDecoration && decoration.color != null) {
      return decoration.color;
    }
  }

  return null;
}

Future<TestGesture> _hoverButton(WidgetTester tester) async {
  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  addTearDown(mouse.removePointer);
  await mouse.addPointer(location: Offset.zero);
  await mouse.moveTo(tester.getCenter(find.byType(RemixButton)));
  await tester.pump();

  return mouse;
}

Matcher _between(Color from, Color to) => predicate<Color?>(
  (color) => color != null && color != from && color != to,
  'a colour strictly between $from and $to',
);

void main() {
  final styles = <String, ButtonStyler>{
    'base .animate': ButtonStyler()
        .color(_rest)
        .onHovered(ButtonStyler().color(_hover))
        .animate(_motion),
    'variant .animate': ButtonStyler()
        .color(_rest)
        .onHovered(ButtonStyler().color(_hover).animate(_motion)),
  };

  for (final MapEntry(key: name, value: style) in styles.entries) {
    group('RemixStyleSpecBuilder with $name', () {
      Widget button() =>
          RemixButton(label: 'Save', onPressed: () {}, style: style);

      testWidgets('animates the hover colour by default', (tester) async {
        await MotionHarness.pump(tester, button());
        expect(_paintedColor(tester), _rest);

        await _hoverButton(tester);
        await tester.pump(const Duration(milliseconds: 100));
        expect(_paintedColor(tester), _between(_rest, _hover));

        await tester.pumpAndSettle();
        expect(_paintedColor(tester), _hover);
      });

      testWidgets('lands on the hover colour in one frame when motion is '
          'reduced before the first frame', (tester) async {
        tester.platformDispatcher.accessibilityFeaturesTestValue =
            const FakeAccessibilityFeatures(reduceMotion: true);
        await MotionHarness.pump(tester, button());

        await _hoverButton(tester);
        expect(_paintedColor(tester), _hover);
        expect(tester.hasRunningAnimations, isFalse);
      });

      for (final request in MotionRequest.values) {
        testWidgets('lands on the hover colour in one frame under '
            '${request.name} reduced motion', (tester) async {
          final harness = await MotionHarness.pump(tester, button());
          await harness.set(request, enabled: true);
          await tester.pumpAndSettle();

          final mouse = await _hoverButton(tester);
          expect(_paintedColor(tester), _hover);
          expect(tester.hasRunningAnimations, isFalse);

          await mouse.moveTo(Offset.zero);
          await tester.pump();
          expect(_paintedColor(tester), _rest);
          expect(tester.hasRunningAnimations, isFalse);
        });
      }
    });
  }

  testWidgets('drops timing from a StyleProvider-inherited style and keeps it '
      'visible to descendants', (tester) async {
    final inherited = ButtonStyler()
        .onHovered(ButtonStyler().color(_hover))
        .animate(_motion);
    Style<ButtonSpec>? seen;

    final harness = await MotionHarness.pump(
      tester,
      StyleProvider<ButtonSpec>(
        style: inherited,
        child: RemixButton(
          label: 'Save',
          onPressed: () {},
          style: ButtonStyler().color(_rest),
          textBuilder: (context, spec, text) {
            seen = Style.maybeOf<ButtonSpec>(context);

            return Text(text);
          },
        ),
      ),
    );
    expect(seen, same(inherited));

    await harness.set(MotionRequest.mediaQuery, enabled: true);
    await tester.pumpAndSettle();
    await _hoverButton(tester);
    expect(_paintedColor(tester), _hover);
    expect(tester.hasRunningAnimations, isFalse);
  });
}
